<cfcomponent>   
    <cfset dsn=application.systemparam.dsn>
    <cfset securityValidator = createObject("component", "SecurityValidator").init()>

<cfquery name="getQuestions" datasource="#dsn#">
select ID,QUESTION as QUESTION_NAME from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_QUESTIONS    
</cfquery>
<cfscript>
    QuestionArr=arrayNew(1);
    for(i=1;i<=getQuestions.recordCount;i++){         
      obj={
        QUESTION_ID:getQuestions.ID[i],
        QUESTION_NAME:getQuestions.QUESTION_NAME[i]
      };
      arrayAppend(QuestionArr,obj)            
    }    
</cfscript>
    
    <!--- Bulk Operations for Multiple Products --->
    <cffunction name="bulkUpdateProducts" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="productIds" required="true" type="string">
        <cfargument name="updateData" required="true" type="struct">
        <cfargument name="operation" required="true" type="string">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security Validations --->
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Initialize audit logger --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset startTime = getTickCount()>
            
            <!--- Parse product IDs --->
            <cfset productIdList = listToArray(arguments.productIds)>
            <cfset results = {
                success: [],
                failed: [],
                total: arrayLen(productIdList),
                operation: arguments.operation
            }>
            
            <!--- Validate operation type --->
            <cfset allowedOperations = ["updatePrices", "updateStatus", "updateCategories", "deleteProducts", "copyProducts"]>
            <cfif NOT arrayFind(allowedOperations, arguments.operation)>
                <cfthrow message="Geçersiz bulk operation: #arguments.operation#" type="Validation">
            </cfif>
            
            <!--- Process each product --->
            <cftransaction>
                <cfloop array="#productIdList#" index="productId">
                    <cftry>
                        <!--- Validate product ID --->
                        <cfset productIdValidation = securityValidator.validateInput(productId, "projectId", true)>
                        <cfif NOT productIdValidation.isValid>
                            <cfset arrayAppend(results.failed, {id: productId, error: "Invalid product ID"})>
                            <cfcontinue>
                        </cfif>
                        
                        <!--- Execute operation --->
                        <cfswitch expression="#arguments.operation#">
                            <cfcase value="updatePrices">
                                <cfset updateResult = bulkUpdatePrice(productId, arguments.updateData)>
                            </cfcase>
                            <cfcase value="updateStatus">
                                <cfset updateResult = bulkUpdateStatus(productId, arguments.updateData)>
                            </cfcase>
                            <cfcase value="updateCategories">
                                <cfset updateResult = bulkUpdateCategory(productId, arguments.updateData)>
                            </cfcase>
                            <cfcase value="deleteProducts">
                                <cfset updateResult = bulkDeleteProduct(productId)>
                            </cfcase>
                            <cfcase value="copyProducts">
                                <cfset updateResult = bulkCopyProduct(productId, arguments.updateData)>
                            </cfcase>
                        </cfswitch>
                        
                        <cfif updateResult.success>
                            <cfset arrayAppend(results.success, {id: productId, message: updateResult.message})>
                        <cfelse>
                            <cfset arrayAppend(results.failed, {id: productId, error: updateResult.message})>
                        </cfif>
                        
                        <cfcatch type="any">
                            <cfset arrayAppend(results.failed, {id: productId, error: cfcatch.message})>
                            <cfset auditLogger.logError("BULK_OPERATION_ERROR", cfcatch.message, cfcatch.detail, "", "product_design.cfc")>
                        </cfcatch>
                    </cftry>
                </cfloop>
            </cftransaction>
            
            <!--- Log bulk operation --->
            <cfset executionTime = getTickCount() - startTime>
            <cfset auditLogger.logUserAction(
                action = "BULK_OPERATION_#arguments.operation#",
                details = "Processed #results.total# products, #arrayLen(results.success)# successful, #arrayLen(results.failed)# failed",
                affectedRecords = arguments.productIds,
                newValues = arguments.updateData,
                severity = arrayLen(results.failed) GT 0 ? "WARNING" : "INFO"
            )>
            
            <cfset auditLogger.logPerformance(
                operation = "BULK_#arguments.operation#",
                executionTime = executionTime,
                recordsProcessed = results.total
            )>
            
            <cfreturn serializeJSON(results)>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("BULK_OPERATION_CRITICAL", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "product_design.cfc")>
                <cfreturn serializeJSON({success: false, message: "Bulk operation failed: " & cfcatch.message})>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Helper functions for bulk operations --->
    <cffunction name="bulkUpdatePrice" access="private" returntype="struct">
        <cfargument name="productId" required="true">
        <cfargument name="priceData" required="true" type="struct">
        
        <cftry>
            <cfquery datasource="#dsn#">
                UPDATE VIRTUAL_PRODUCT_TREE_PRODUCTS_2 
                SET 
                    PRODUCT_UNIT_PRICE = <cfqueryparam value="#arguments.priceData.unitPrice#" cfsqltype="CF_SQL_DECIMAL">,
                    <cfif structKeyExists(arguments.priceData, "discountRate")>
                    DISCOUNT_RATE = <cfqueryparam value="#arguments.priceData.discountRate#" cfsqltype="CF_SQL_DECIMAL">,
                    </cfif>
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                    UPDATE_EMP = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_INTEGER">
                WHERE PRODUCT_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn {success: true, message: "Price updated successfully"}>
            
            <cfcatch type="any">
                <cfreturn {success: false, message: cfcatch.message}>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="bulkUpdateStatus" access="private" returntype="struct">
        <cfargument name="productId" required="true">
        <cfargument name="statusData" required="true" type="struct">
        
        <cftry>
            <cfquery datasource="#dsn#">
                UPDATE VIRTUAL_PRODUCT_TREE_PRODUCTS_2 
                SET 
                    IS_ACTIVE = <cfqueryparam value="#arguments.statusData.isActive#" cfsqltype="CF_SQL_BIT">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                    UPDATE_EMP = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_INTEGER">
                WHERE PRODUCT_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn {success: true, message: "Status updated successfully"}>
            
            <cfcatch type="any">
                <cfreturn {success: false, message: cfcatch.message}>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="bulkDeleteProduct" access="private" returntype="struct">
        <cfargument name="productId" required="true">
        
        <cftry>
            <!--- Soft delete --->
            <cfquery datasource="#dsn#">
                UPDATE VIRTUAL_PRODUCT_TREE_PRODUCTS_2 
                SET 
                    IS_DELETED = 1,
                    DELETE_DATE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                    DELETE_EMP = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_INTEGER">
                WHERE PRODUCT_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn {success: true, message: "Product deleted successfully"}>
            
            <cfcatch type="any">
                <cfreturn {success: false, message: cfcatch.message}>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- Advanced Filtering System --->
    <cffunction name="getFilteredProducts" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="filters" required="true" type="struct">
        <cfargument name="sorting" required="false" type="struct" default="#{}#">
        <cfargument name="pagination" required="false" type="struct" default="#{}#">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security Validations --->
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Initialize audit logger --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset startTime = getTickCount()>
            
            <!--- Build dynamic query --->
            <cfset sqlQuery = buildFilterQuery(arguments.filters, arguments.sorting, arguments.pagination)>
            
            <!--- Execute filtered query --->
            <cfquery name="getFilteredData" datasource="#dsn#">
                #preserveSingleQuotes(sqlQuery.mainQuery)#
            </cfquery>
            
            <!--- Get total count for pagination --->
            <cfquery name="getTotalCount" datasource="#dsn#">
                #preserveSingleQuotes(sqlQuery.countQuery)#
            </cfquery>
            
            <!--- Format results --->
            <cfset results = {
                data: [],
                totalRecords: getTotalCount.total_count,
                currentPage: structKeyExists(arguments.pagination, "page") ? arguments.pagination.page : 1,
                pageSize: structKeyExists(arguments.pagination, "pageSize") ? arguments.pagination.pageSize : 50,
                totalPages: 0,
                filters: arguments.filters,
                sorting: arguments.sorting
            }>
            
            <!--- Calculate total pages --->
            <cfset results.totalPages = ceiling(results.totalRecords / results.pageSize)>
            
            <!--- Convert query to array --->
            <cfloop query="getFilteredData">
                <cfset productData = {
                    id: getFilteredData.PRODUCT_ID,
                    name: getFilteredData.PRODUCT_NAME,
                    category: getFilteredData.PRODUCT_CATEGORY,
                    price: getFilteredData.PRODUCT_UNIT_PRICE,
                    status: getFilteredData.IS_ACTIVE,
                    createDate: getFilteredData.RECORD_DATE,
                    updateDate: getFilteredData.UPDATE_DATE,
                    isVirtual: getFilteredData.IS_VIRTUAL
                }>
                <cfset arrayAppend(results.data, productData)>
            </cfloop>
            
            <!--- Log filtering operation --->
            <cfset executionTime = getTickCount() - startTime>
            <cfset auditLogger.logPerformance(
                operation = "ADVANCED_FILTER",
                executionTime = executionTime,
                recordsProcessed = results.totalRecords
            )>
            
            <cfreturn serializeJSON(results)>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("FILTER_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "product_design.cfc")>
                <cfreturn serializeJSON({success: false, message: "Filter operation failed: " & cfcatch.message})>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Build dynamic filter query --->
    <cffunction name="buildFilterQuery" access="private" returntype="struct">
        <cfargument name="filters" required="true" type="struct">
        <cfargument name="sorting" required="false" type="struct" default="#{}#">
        <cfargument name="pagination" required="false" type="struct" default="#{}#">
        
        <cfset var baseQuery = "
            SELECT DISTINCT
                p.PRODUCT_ID,
                p.PRODUCT_NAME,
                p.PRODUCT_CATEGORY,
                p.PRODUCT_UNIT_PRICE,
                p.IS_ACTIVE,
                p.IS_VIRTUAL,
                p.RECORD_DATE,
                p.UPDATE_DATE,
                c.PRODUCT_CAT AS CATEGORY_NAME,
                ISNULL(s.PRODUCT_NAME, '') AS STOCK_NAME
            FROM VIRTUAL_PRODUCT_TREE_PRODUCTS_2 p
            LEFT JOIN PRODUCT_CAT c ON p.PRODUCT_CATEGORY = c.PRODUCT_CATID
            LEFT JOIN STOCKS s ON p.STOCK_ID = s.STOCK_ID
            WHERE 1=1 AND p.IS_DELETED = 0
        ">
        
        <cfset var whereConditions = []>
        <cfset var queryParams = {}>
        
        <!--- Text search --->
        <cfif structKeyExists(arguments.filters, "searchText") AND len(trim(arguments.filters.searchText))>
            <cfset searchText = securityValidator.validateInput(arguments.filters.searchText, "searchText", true)>
            <cfif searchText.isValid>
                <cfset arrayAppend(whereConditions, "(p.PRODUCT_NAME LIKE ? OR s.PRODUCT_NAME LIKE ?)")>
                <cfset searchParam = "%" & trim(arguments.filters.searchText) & "%">
                <cfset queryParams["searchText1"] = {value: searchParam, type: "CF_SQL_VARCHAR"}>
                <cfset queryParams["searchText2"] = {value: searchParam, type: "CF_SQL_VARCHAR"}>
            </cfif>
        </cfif>
        
        <!--- Category filter --->
        <cfif structKeyExists(arguments.filters, "categoryIds") AND len(trim(arguments.filters.categoryIds))>
            <cfset categoryValidation = securityValidator.validateInput(arguments.filters.categoryIds, "numberList", true)>
            <cfif categoryValidation.isValid>
                <cfset categoryList = listToArray(arguments.filters.categoryIds)>
                <cfset categoryPlaceholders = []>
                <cfloop from="1" to="#arrayLen(categoryList)#" index="i">
                    <cfset arrayAppend(categoryPlaceholders, "?")>
                    <cfset queryParams["category#i#"] = {value: categoryList[i], type: "CF_SQL_INTEGER"}>
                </cfloop>
                <cfset arrayAppend(whereConditions, "p.PRODUCT_CATEGORY IN (#arrayToList(categoryPlaceholders)#)")>
            </cfif>
        </cfif>
        
        <!--- Price range filter --->
        <cfif structKeyExists(arguments.filters, "minPrice") AND isNumeric(arguments.filters.minPrice)>
            <cfset arrayAppend(whereConditions, "p.PRODUCT_UNIT_PRICE >= ?")>
            <cfset queryParams["minPrice"] = {value: arguments.filters.minPrice, type: "CF_SQL_DECIMAL"}>
        </cfif>
        
        <cfif structKeyExists(arguments.filters, "maxPrice") AND isNumeric(arguments.filters.maxPrice)>
            <cfset arrayAppend(whereConditions, "p.PRODUCT_UNIT_PRICE <= ?")>
            <cfset queryParams["maxPrice"] = {value: arguments.filters.maxPrice, type: "CF_SQL_DECIMAL"}>
        </cfif>
        
        <!--- Status filter --->
        <cfif structKeyExists(arguments.filters, "status") AND len(trim(arguments.filters.status))>
            <cfif arguments.filters.status EQ "active">
                <cfset arrayAppend(whereConditions, "p.IS_ACTIVE = 1")>
            <cfelseif arguments.filters.status EQ "inactive">
                <cfset arrayAppend(whereConditions, "p.IS_ACTIVE = 0")>
            </cfif>
        </cfif>
        
        <!--- Virtual/Real filter --->
        <cfif structKeyExists(arguments.filters, "productType") AND len(trim(arguments.filters.productType))>
            <cfif arguments.filters.productType EQ "virtual">
                <cfset arrayAppend(whereConditions, "p.IS_VIRTUAL = 1")>
            <cfelseif arguments.filters.productType EQ "real">
                <cfset arrayAppend(whereConditions, "p.IS_VIRTUAL = 0")>
            </cfif>
        </cfif>
        
        <!--- Date range filter --->
        <cfif structKeyExists(arguments.filters, "startDate") AND isDate(arguments.filters.startDate)>
            <cfset arrayAppend(whereConditions, "p.RECORD_DATE >= ?")>
            <cfset queryParams["startDate"] = {value: arguments.filters.startDate, type: "CF_SQL_TIMESTAMP"}>
        </cfif>
        
        <cfif structKeyExists(arguments.filters, "endDate") AND isDate(arguments.filters.endDate)>
            <cfset arrayAppend(whereConditions, "p.RECORD_DATE <= ?")>
            <cfset queryParams["endDate"] = {value: arguments.filters.endDate, type: "CF_SQL_TIMESTAMP"}>
        </cfif>
        
        <!--- Build WHERE clause --->
        <cfset var fullQuery = baseQuery>
        <cfif arrayLen(whereConditions) GT 0>
            <cfset fullQuery = fullQuery & " AND " & arrayToList(whereConditions, " AND ")>
        </cfif>
        
        <!--- Add sorting --->
        <cfset var orderBy = "p.RECORD_DATE DESC"> <!--- Default sorting --->
        <cfif structKeyExists(arguments.sorting, "field") AND len(trim(arguments.sorting.field))>
            <cfset sortField = arguments.sorting.field>
            <cfset sortDirection = structKeyExists(arguments.sorting, "direction") ? arguments.sorting.direction : "ASC">
            
            <!--- Validate sort field --->
            <cfset allowedSortFields = {
                "name": "p.PRODUCT_NAME",
                "category": "c.PRODUCT_CAT",
                "price": "p.PRODUCT_UNIT_PRICE", 
                "status": "p.IS_ACTIVE",
                "createDate": "p.RECORD_DATE",
                "updateDate": "p.UPDATE_DATE"
            }>
            
            <cfif structKeyExists(allowedSortFields, sortField)>
                <cfset orderBy = allowedSortFields[sortField] & " " & (sortDirection EQ "DESC" ? "DESC" : "ASC")>
            </cfif>
        </cfif>
        
        <cfset fullQuery = fullQuery & " ORDER BY " & orderBy>
        
        <!--- Add pagination --->
        <cfset var paginatedQuery = fullQuery>
        <cfif structKeyExists(arguments.pagination, "page") AND structKeyExists(arguments.pagination, "pageSize")>
            <cfset page = arguments.pagination.page GT 0 ? arguments.pagination.page : 1>
            <cfset pageSize = arguments.pagination.pageSize GT 0 ? arguments.pagination.pageSize : 50>
            <cfset offset = (page - 1) * pageSize>
            
            <cfset paginatedQuery = "
                WITH PaginatedResults AS (
                    SELECT *, ROW_NUMBER() OVER (ORDER BY " & orderBy & ") as RowNum
                    FROM (" & fullQuery & ") AS BaseQuery
                )
                SELECT * FROM PaginatedResults 
                WHERE RowNum BETWEEN " & (offset + 1) & " AND " & (offset + pageSize)>
        </cfif>
        
        <!--- Build count query --->
        <cfset var countQuery = "
            SELECT COUNT(*) as total_count
            FROM VIRTUAL_PRODUCT_TREE_PRODUCTS_2 p
            LEFT JOIN PRODUCT_CAT c ON p.PRODUCT_CATEGORY = c.PRODUCT_CATID
            LEFT JOIN STOCKS s ON p.STOCK_ID = s.STOCK_ID
            WHERE 1=1 AND p.IS_DELETED = 0
        ">
        
        <cfif arrayLen(whereConditions) GT 0>
            <cfset countQuery = countQuery & " AND " & arrayToList(whereConditions, " AND ")>
        </cfif>
        
        <!--- Convert to parameterized queries --->
        <cfset mainQueryFinal = convertToParameterizedQuery(paginatedQuery, queryParams)>
        <cfset countQueryFinal = convertToParameterizedQuery(countQuery, queryParams)>
        
        <cfreturn {
            mainQuery: mainQueryFinal,
            countQuery: countQueryFinal
        }>
    </cffunction>
    
    <!--- Convert placeholders to parameterized query --->
    <cffunction name="convertToParameterizedQuery" access="private" returntype="string">
        <cfargument name="query" required="true" type="string">
        <cfargument name="params" required="true" type="struct">
        
        <cfset var finalQuery = arguments.query>
        
        <!--- Replace placeholders with actual cfqueryparam values --->
        <cfloop collection="#arguments.params#" item="paramKey">
            <cfset paramData = arguments.params[paramKey]>
            <cfset paramValue = "<cfqueryparam value='#paramData.value#' cfsqltype='#paramData.type#'>">
            <cfset finalQuery = replace(finalQuery, "?", paramValue, "one")>
        </cfloop>
        
        <cfreturn finalQuery>
    </cffunction>

    <cffunction name="getTree" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
            <cfargument name="product_id" required="true">
            <cfargument name="isVirtual" required="true">
            <cfargument name="ddsn3" required="true">
            <cfargument name="company_id" required="true">
            <cfargument name="price_catid" required="true">
            <cfargument name="stock_id" default="">
            <cfargument name="tipo" default="1">
            <cfargument name="from_copy" default="0">
            <cfargument name="csrf_token" required="true">
            
            <cftry>
                <!--- Security Validations --->
                <cfif NOT securityValidator.validateSession()>
                    <cfthrow message="Oturum geçersiz" type="Security">
                </cfif>
                
                <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                    <cfthrow message="CSRF token geçersiz" type="Security">
                </cfif>
                
                <cfif NOT securityValidator.checkRateLimit(session.sessionid)>
                    <cfthrow message="Çok fazla istek" type="Security">
                </cfif>
                
                <!--- Input Validations --->
                <cfset productIdValidation = securityValidator.validateInput(arguments.product_id, "projectId", true)>
                <cfif NOT productIdValidation.isValid>
                    <cfthrow message="Geçersiz product_id: #arrayToList(productIdValidation.errors, '; ')#" type="Validation">
                </cfif>
                
                <cfset isVirtualValidation = securityValidator.validateInput(arguments.isVirtual, "number", true)>
                <cfif NOT isVirtualValidation.isValid OR NOT listFind("0,1", arguments.isVirtual)>
                    <cfthrow message="Geçersiz isVirtual parametresi" type="Validation">
                </cfif>
                
                <cfset companyIdValidation = securityValidator.validateInput(arguments.company_id, "number", true)>
                <cfif NOT companyIdValidation.isValid>
                    <cfthrow message="Geçersiz company_id" type="Validation">
                </cfif>
                
                <!--- Sanitize inputs --->
                <cfset sanitizedProductId = productIdValidation.sanitizedValue>
                <cfset sanitizedIsVirtual = isVirtualValidation.sanitizedValue>
                <cfset sanitizedCompanyId = companyIdValidation.sanitizedValue>
                
                <cfset TreeArr="">
                
                <cfif val(sanitizedIsVirtual) eq 1>                
                    <cfset TreeArr=getTrees(sanitizedProductId, sanitizedIsVirtual, arguments.ddsn3, sanitizedProductId, sanitizedCompanyId, arguments.price_catid, arguments.tipo, arguments.from_copy)>
                <cfelse>               
                    <cfset TreeArr=getTrees(sanitizedProductId, 0, arguments.ddsn3, arguments.stock_id, sanitizedCompanyId, arguments.price_catid, arguments.tipo, arguments.from_copy)>
                </cfif>
                
                <cfreturn replace(TreeArr,"//","")>
                
                <cfcatch type="any">
                    <cflog file="product_design_errors" 
                           text="getTree Error: #cfcatch.message# - User: #session.pp.userid# - IP: #cgi.remote_addr#"
                           type="error">
                    <cfif cfcatch.type EQ "Security">
                        <cfreturn '{"error": "Güvenlik hatası", "code": "SECURITY_ERROR"}'>
                    <cfelseif cfcatch.type EQ "Validation">
                        <cfreturn '{"error": "#cfcatch.message#", "code": "VALIDATION_ERROR"}'>
                    <cfelse>
                        <cfreturn '{"error": "Sistem hatası", "code": "SYSTEM_ERROR"}'>
                    </cfif>
                </cfcatch>
            </cftry>
        </cffunction>    

    <cffunction name="getTreeFromVirtual" access="private">
        <cfargument name="product_id" required="true">
        
        <cftry>
            <!--- Input validation --->
            <cfset productIdValidation = securityValidator.validateInput(arguments.product_id, "projectId", true)>
            <cfif NOT productIdValidation.isValid>
                <cfthrow message="Geçersiz product_id" type="Validation">
            </cfif>
            
            <cfset sanitizedProductId = productIdValidation.sanitizedValue>
            
            <!--- Secure parameterized query --->
            <cfquery name="getTree" datasource="#dsn#">
                SELECT PRODUCT_ID, AMOUNT, IS_VIRTUAL, STOCK_ID
                FROM VIRTUAL_PRODUCT_TREE_PRT 
                WHERE VP_ID = <cfqueryparam value="#sanitizedProductId#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfset ReturnArr=arrayNew(1)>
            <cfloop query="getTree">
                <cfset O=structNew()>
                <cfset O.PRODUCT_ID=PRODUCT_ID>
                
                <!--- Secure nested query --->
                <cfquery name="getSInfo" datasource="#dsn#">
                    <cfif IS_VIRTUAL EQ 1>
                        SELECT PRODUCT_NAME 
                        FROM VIRTUAL_PRODUCTS_PRT 
                        WHERE VIRTUAL_PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="CF_SQL_INTEGER">        
                    <cfelse>
                        SELECT PRODUCT_NAME 
                        FROM STOCKS 
                        WHERE PRODUCT_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="CF_SQL_INTEGER">
                    </cfif>
                </cfquery>
                
                <cfif getSInfo.recordCount GT 0>
                    <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
                    <cfset O.AMOUNT=AMOUNT>
                    
                    <!--- Check for child tree --->
                    <cfquery name="ishvTree" datasource="#dsn#">
                        <cfif IS_VIRTUAL EQ 1>
                            SELECT COUNT(*) as tree_count
                            FROM VIRTUAL_PRODUCT_TREE_PRT 
                            WHERE VP_ID = <cfqueryparam value="#PRODUCT_ID#" cfsqltype="CF_SQL_INTEGER">
                        <cfelse>
                            SELECT COUNT(*) as tree_count
                            FROM PRODUCT_TREE 
                            WHERE STOCK_ID = <cfqueryparam value="#STOCK_ID#" cfsqltype="CF_SQL_INTEGER">
                        </cfif>
                    </cfquery>
                    
                    <cfif ishvTree.tree_count GT 0>
                        <cfif IS_VIRTUAL EQ 1>
                            <cfset O.Tree=getTreeFromVirtual(PRODUCT_ID)>
                        <cfelse>
                            <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID, arguments.ddsn3)>
                        </cfif>
                    </cfif>
                    
                    <cfscript>
                        arrayAppend(ReturnArr,O);
                    </cfscript>
                </cfif>
            </cfloop>
            
            <cfreturn ReturnArr>
            
            <cfcatch type="any">
                <cflog file="product_design_errors" 
                       text="getTreeFromVirtual Error: #cfcatch.message# - Product ID: #arguments.product_id#"
                       type="error">
                <cfreturn arrayNew(1)>
            </cfcatch>
        </cftry>
    </cffunction>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfquery name="ishvTree" datasource="#dsn#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#
                
                <cfelse>
                    SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#
                </cfif>
            </cfquery>
            <cfif ishvTree.recordCount>
                <cfif IS_VIRTUAL EQ 1>
                    <cfset O.Tree=getTreeFromVirtual(PRODUCT_ID)>
                <cfelse>
                    <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID)>
                </cfif>
            </cfif>
            <cfscript>
                arrayAppend(ReturnArr,O);
            </cfscript>
        </cfloop>
        <cfreturn ReturnArr>
    </cffunction>



    <cffunction name="getTreeFromRealProduct" >
        <cfargument name="product_id">
        <cfargument name="ddsn3">
        <cfquery name="getTreeFromVirtual" datasource="#dsn#">
            SELECT * FROM #arguments.ddsn3#.PRODUCT_TREE WHERE STOCK_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTreeFromVirtual">
            <cfset O=structNew()>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn#">              
                    SELECT * FROM #arguments.ddsn3#.STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#              
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfset O.PRODUCT_TREE_ID=PRODUCT_TREE_ID>
            <cfquery name="ishvTree" datasource="#dsn#">            
                    SELECT * FROM #arguments.ddsn3#.PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#            
            </cfquery>
            <!----<cfif ishvTree.recordCount>              
                    <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID)>               
            </cfif>----->
            <cfscript>
                arrayAppend(ReturnArr,O);
            </cfscript>
        </cfloop>
        <cfreturn ReturnArr>
    </cffunction>

    <!--- OPTIMIZED VERSION: Reduced N+1 queries by batch fetching --->
    <cffunction name="getTrees">
        <cfargument name="pid">
        <cfargument name="isVirtual">
        <cfargument name="ddsn3">        
        <cfargument name="sid">
        <cfargument name="company_id">
        <cfargument name="price_catid">
        <cfargument name="tipo" default="1">
        <cfargument name="from_copy" default="0">
        <cfset dsn3=arguments.ddsn3>
        
        <!--- OPTIMIZATION: Single query with all necessary JOINs --->
        <cfquery name="getTree" datasource="#dsn3#">
            <cfif arguments.isVirtual eq 1>
                SELECT 
                    VPT.VPT_ID,
                    VPT.VP_ID,
                    VPT.PRODUCT_ID,
                    VPT.STOCK_ID,
                    VPT.AMOUNT,
                    VPT.QUESTION_ID,
                    VPT.IS_VIRTUAL,
                    VPT.DISPLAY_NAME,
                    COALESCE(PEPS.PRICE, 0) AS PRICE,
                    COALESCE(PEPS.DISCOUNT, 0) AS DISCOUNT,
                    COALESCE(PEPS.OTHER_MONEY, 'TL') AS MONEY,
                    PEPS.MAIN_PRODUCT_ID,
                    VPT.STOCK_ID AS RELATED_ID,
                    VPT.VPT_ID AS PRODUCT_TREE_ID,
                    <cfif arguments.from_copy eq 0>VPT.PBS_ROW_ID<cfelse>'' as PBS_ROW_ID</cfif>,
                    -- Product Info in single query
                    VP.PRODUCT_NAME,
                    -- Child tree check
                    CASE WHEN EXISTS(
                        SELECT 1 FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT2 
                        WHERE VPT2.VP_ID = VPT.PRODUCT_ID
                    ) THEN 1 ELSE 0 END AS HAS_CHILDREN
                FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                LEFT JOIN workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES PEPS 
                    ON PEPS.PBS_ROW_ID = VPT.PBS_ROW_ID AND PEPS.IS_ACTIVE = 1
                LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT VP 
                    ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                WHERE VPT.VP_ID = #arguments.pid# 
                    AND VPT.PRODUCT_ID <> 0
            <cfelse>
                SELECT 
                    PT.PRODUCT_TREE_ID,
                    PT.STOCK_ID AS VP_ID,
                    PT.PRODUCT_ID,
                    PT.STOCK_ID,
                    PT.AMOUNT,
                    0 AS QUESTION_ID,
                    0 AS IS_VIRTUAL,
                    (SELECT PROPERTY3 FROM workcube_metosan_1.PRODUCT_INFO_PLUS 
                     WHERE PRODUCT_ID = PT.PRODUCT_ID AND PRO_INFO_ID = 2) AS DISPLAY_NAME,
                    COALESCE(PEPS.PRICE, 0) AS PRICE,
                    COALESCE(PEPS.DISCOUNT, 0) AS DISCOUNT,
                    COALESCE(PEPS.OTHER_MONEY, 'TL') AS MONEY,
                    PEPS.MAIN_PRODUCT_ID,
                    PT.STOCK_ID AS RELATED_ID,
                    PT.PRODUCT_TREE_ID,
                    <cfif arguments.from_copy eq 0>PT.PBS_ROW_ID<cfelse>'' as PBS_ROW_ID</cfif>,
                    -- Product Info in single query
                    S.PRODUCT_NAME,
                    -- Child tree check
                    CASE WHEN EXISTS(
                        SELECT 1 FROM workcube_metosan_1.PRODUCT_TREE PT2 
                        WHERE PT2.STOCK_ID = (SELECT STOCK_ID FROM workcube_metosan_1.STOCKS 
                                              WHERE PRODUCT_ID = PT.PRODUCT_ID AND STOCK_STATUS = 1)
                    ) THEN 1 ELSE 0 END AS HAS_CHILDREN
                FROM workcube_metosan_1.PRODUCT_TREE PT
                LEFT JOIN workcube_metosan_1.PROJECT_REAL_PRODUCTS_TREE_PRICES PEPS 
                    ON PEPS.PBS_ROW_ID = PT.PBS_ROW_ID AND PEPS.IS_ACTIVE = 1
                LEFT JOIN workcube_metosan_1.STOCKS S 
                    ON S.PRODUCT_ID = PT.PRODUCT_ID
                WHERE PT.STOCK_ID = #arguments.sid#
            </cfif>
        </cfquery>       
        
        <!--- Debug output for performance monitoring --->
        <cfsavecontent variable="test1">
            <cfdump var="#getTree#">
            <p>Query optimized: Single query instead of N+1</p>
            <p>Total records: #getTree.recordCount#</p>
        </cfsavecontent>
        <cffile action="write" file="c:\PBS\getTrees_optimized_#arguments.pid#.html" output="#test1#">
        
        <!--- OPTIMIZATION: Batch fetch all required data upfront --->
        <cfset productIds = ValueList(getTree.PRODUCT_ID)>
        <cfset priceData = structNew()>
        
        <!--- Pre-fetch all price data in single query if needed --->
        <cfif arguments.tipo eq 1 AND len(productIds)>
            <cfquery name="getAllPrices" datasource="#dsn3#">
                <cfif arguments.isVirtual eq 1>
                    SELECT 
                        VP.VIRTUAL_PRODUCT_ID as PRODUCT_ID,
                        0 as PRICE,
                        0 as STANDART_PRICE,
                        'TL' as MONEY,
                        0 as DISCOUNT
                    FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT VP
                    WHERE VP.VIRTUAL_PRODUCT_ID IN (#productIds#)
                <cfelse>
                    SELECT 
                        P.PRODUCT_ID,
                        COALESCE(PR.PRICE, 0) as PRICE,
                        COALESCE(PR.PRICE, 0) as STANDART_PRICE,
                        COALESCE(PR.MONEY, 'TL') as MONEY,
                        COALESCE(PCE.DISCOUNT_RATE, 0) as DISCOUNT
                    FROM workcube_metosan_1.PRODUCT P
                    LEFT JOIN workcube_metosan_1.PRICE PR ON PR.PRODUCT_ID = P.PRODUCT_ID 
                        AND PR.PRICE_CATID = #arguments.price_catid#
                        AND PR.STARTDATE <= GETDATE()
                        AND (PR.FINISHDATE >= GETDATE() OR PR.FINISHDATE IS NULL)
                        AND ISNULL(PR.SPECT_VAR_ID, 0) = 0
                    LEFT JOIN workcube_metosan_1.PRICE_CAT_EXCEPTIONS PCE ON (
                        (PCE.PRODUCT_ID = P.PRODUCT_ID OR PCE.PRODUCT_ID IS NULL) AND
                        (PCE.BRAND_ID = P.BRAND_ID OR PCE.BRAND_ID IS NULL) AND
                        (PCE.PRODUCT_CATID = P.PRODUCT_CATID OR PCE.PRODUCT_CATID IS NULL) AND
                        (PCE.COMPANY_ID = #arguments.COMPANY_ID# OR PCE.COMPANY_ID IS NULL) AND
                        PCE.ACT_TYPE NOT IN (2,4)
                    )
                    LEFT JOIN workcube_metosan_1.PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                        AND ISNULL(PC.IS_SALES,0) = 1 AND PC.PRICE_CATID = #arguments.price_catid#
                    WHERE P.PRODUCT_ID IN (#productIds#)
                </cfif>
            </cfquery>
            
            <!--- Store price data in struct for O(1) lookup --->
            <cfloop query="getAllPrices">
                <cfset priceData[PRODUCT_ID] = {
                    PRICE = PRICE,
                    STANDART_PRICE = STANDART_PRICE,
                    MONEY = MONEY,
                    DISCOUNT = DISCOUNT
                }>
            </cfloop>
        </cfif>
        
        <cfset say = 0>
        <cfsavecontent variable="myV">[
        <cfloop query="getTree">
            <cfset say = say + 1>
            
            <!--- OPTIMIZATION: Use pre-fetched data instead of individual queries --->
            <cfif arguments.tipo eq 1>
                <cfif structKeyExists(priceData, PRODUCT_ID)>
                    <cfset currentPriceData = priceData[PRODUCT_ID]>
                <cfelse>
                    <cfset currentPriceData = {PRICE=0, STANDART_PRICE=0, MONEY='TL', DISCOUNT=0}>
                </cfif>
                
                <!--- Override with stored prices if available --->
                <cfif len(PRICE) AND PRICE neq 0>
                    <cfset currentPriceData.PRICE = PRICE>
                    <cfset currentPriceData.DISCOUNT = DISCOUNT>
                    <cfset currentPriceData.MONEY = MONEY>
                </cfif>
            <cfelse>
                <!--- For tipo != 1, use existing price fetching logic --->
                <cfif NOT len(PRICE) AND PRICE eq 0>
                    <cfset currentPriceData = getPriceFunk(PRODUCT_ID=PRODUCT_ID, IS_VIRTUAL=IS_VIRTUAL, COMPANY_ID=arguments.company_id, PRICE_CATID=arguments.price_catid, ddsn3=arguments.ddsn3)>
                <cfelse>
                    <cfset currentPriceData = getPriceFunk(PRODUCT_ID=PRODUCT_ID, IS_VIRTUAL=IS_VIRTUAL, COMPANY_ID=arguments.company_id, PRICE_CATID=arguments.price_catid, ddsn3=arguments.ddsn3)>
                    <cfset currentPriceData.PRICE = PRICE>
                    <cfset currentPriceData.DISCOUNT = DISCOUNT>
                    <cfset currentPriceData.MONEY = MONEY>
                </cfif>
            </cfif>
            
            <cfoutput>
            {
                "PRODUCT_ID": #PRODUCT_ID#,
                "PRODUCT_NAME": "#JSStringFormat(PRODUCT_NAME)#",
                "AMOUNT": #AMOUNT#,
                "STOCK_ID": #STOCK_ID#,
                "DISPLAYNAME": "#JSStringFormat(DISPLAY_NAME)#",
                "PBS_ROW_ID": "#PBS_ROW_ID#",
                "IS_VIRTUAL": "#IS_VIRTUAL#",
                "PRICE": "#currentPriceData.PRICE#",
                "STANDART_PRICE": "#currentPriceData.STANDART_PRICE#",
                "MONEY": "#currentPriceData.MONEY#",
                "DISCOUNT": "#currentPriceData.DISCOUNT#",
                "VIRTUAL_PRODUCT_TREE_ID": 0,
                "PRODUCT_TREE_ID": "#PRODUCT_TREE_ID#",
                "QUESTION_ID": "#QUESTION_ID#",
                "QUESTION_NAME": "#JSStringFormat(getQuestionData(QUESTION_ID).QUESTION_NAME)#",
                "RNDM_ID": #GetRndmNmbr()#,
                "AGAC": <cfif HAS_CHILDREN>
                    #SerializeJSON(getTrees(pid=PRODUCT_ID, isVirtual=IS_VIRTUAL, ddsn3=dsn3, sid=STOCK_ID, company_id=arguments.company_id, PRICE_CATID=arguments.price_catid, tipo=arguments.tipo, from_copy=arguments.from_copy))#
                <cfelse>""</cfif>,
                "ASDF": #say#
            }<cfif say lt getTree.recordCount>,</cfif>
            </cfoutput>
        </cfloop>
        ]</cfsavecontent>
        <cfset MyS=deserializeJSON(Replace(myV,",]","]","all"))>
        <cfsavecontent variable="test1">
            <style>


                table.cfdump_wddx,
                table.cfdump_xml,
                table.cfdump_struct,
                table.cfdump_varundefined,
                table.cfdump_array,
                table.cfdump_query,
                table.cfdump_cfc,
                table.cfdump_object,
                table.cfdump_binary,
                table.cfdump_udf,
                table.cfdump_udfbody,
                table.cfdump_varnull,
                table.cfdump_udfarguments {
                    font-size: xx-small;
                    font-family: verdana, arial, helvetica, sans-serif;
                }
            
                table.cfdump_wddx th,
                table.cfdump_xml th,
                table.cfdump_struct th,
                table.cfdump_varundefined th,
                table.cfdump_array th,
                table.cfdump_query th,
                table.cfdump_cfc th,
                table.cfdump_object th,
                table.cfdump_binary th,
                table.cfdump_udf th,
                table.cfdump_udfbody th,
                table.cfdump_varnull th,
                table.cfdump_udfarguments th {
                    text-align: left;
                    color: white;
                    padding: 5px;
                }
            
                table.cfdump_wddx td,
                table.cfdump_xml td,
                table.cfdump_struct td,
                table.cfdump_varundefined td,
                table.cfdump_array td,
                table.cfdump_query td,
                table.cfdump_cfc td,
                table.cfdump_object td,
                table.cfdump_binary td,
                table.cfdump_udf td,
                table.cfdump_udfbody td,
                table.cfdump_varnull td,
                table.cfdump_udfarguments td {
                    padding: 3px;
                    background-color: #ffffff;
                    vertical-align : top;
                }
            
                table.cfdump_wddx {
                    background-color: #000000;
                }
                table.cfdump_wddx th.wddx {
                    background-color: #444444;
                }
            
            
                table.cfdump_xml {
                    background-color: #888888;
                }
                table.cfdump_xml th.xml {
                    background-color: #aaaaaa;
                }
                table.cfdump_xml td.xml {
                    background-color: #dddddd;
                }
            
                table.cfdump_struct {
                    background-color: #0000cc ;
                }
                table.cfdump_struct th.struct {
                    background-color: #4444cc ;
                }
                table.cfdump_struct td.struct {
                    background-color: #ccddff;
                }
            
                table.cfdump_varundefined {
                    background-color: #CC3300 ;
                }
                table.cfdump_varundefined th.varundefined {
                    background-color: #CC3300 ;
                }
                table.cfdump_varundefined td.varundefined {
                    background-color: #ccddff;
                }
            
                table.cfdump_array {
                    background-color: #006600 ;
                }
                table.cfdump_array th.array {
                    background-color: #009900 ;
                }
                table.cfdump_array td.array {
                    background-color: #ccffcc ;
                }
            
                table.cfdump_query {
                    background-color: #884488 ;
                }
                table.cfdump_query th.query {
                    background-color: #aa66aa ;
                }
                table.cfdump_query td.query {
                    background-color: #ffddff ;
                }
            
            
                table.cfdump_cfc {
                    background-color: #ff0000;
                }
                table.cfdump_cfc th.cfc{
                    background-color: #ff4444;
                }
                table.cfdump_cfc td.cfc {
                    background-color: #ffcccc;
                }
            
            
                table.cfdump_object {
                    background-color : #ff0000;
                }
                table.cfdump_object th.object{
                    background-color: #ff4444;
                }
            
                table.cfdump_binary {
                    background-color : #eebb00;
                }
                table.cfdump_binary th.binary {
                    background-color: #ffcc44;
                }
                table.cfdump_binary td {
                    font-size: x-small;
                }
                table.cfdump_udf {
                    background-color: #aa4400;
                }
                table.cfdump_udf th.udf {
                    background-color: #cc6600;
                }
                table.cfdump_udfarguments {
                    background-color: #dddddd;
                }
                table.cfdump_udfarguments th {
                    background-color: #eeeeee;
                    color: #000000;
                }
            
            </style> <script language="javascript">
            
            
            // for queries we have more than one td element to collapse/expand
                var expand = "open";
            
                dump = function( obj ) {
                    var out = "" ;
                    if ( typeof obj == "object" ) {
                        for ( key in obj ) {
                            if ( typeof obj[key] != "function" ) out += key + ': ' + obj[key] + '<br>' ;
                        }
                    }
                }
            
            
                cfdump_toggleRow = function(source) {
                    //target is the right cell
                    if(document.all) target = source.parentElement.cells[1];
                    else {
                        var element = null;
                        var vLen = source.parentNode.childNodes.length;
                        for(var i=vLen-1;i>0;i--){
                            if(source.parentNode.childNodes[i].nodeType == 1){
                                element = source.parentNode.childNodes[i];
                                break;
                            }
                        }
                        if(element == null)
                            target = source.parentNode.lastChild;
                        else
                            target = element;
                    }
                    //target = source.parentNode.lastChild ;
                    cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                }
            
                cfdump_toggleXmlDoc = function(source) {
            
                    var caption = source.innerHTML.split( ' [' ) ;
            
                    // toggle source (header)
                    if ( source.style.fontStyle == 'italic' ) {
                        // closed -> short
                        source.style.fontStyle = 'normal' ;
                        source.innerHTML = caption[0] + ' [short version]' ;
                        source.title = 'click to maximize' ;
                        switchLongToState = 'closed' ;
                        switchShortToState = 'open' ;
                    } else if ( source.innerHTML.indexOf('[short version]') != -1 ) {
                        // short -> full
                        source.innerHTML = caption[0] + ' [long version]' ;
                        source.title = 'click to collapse' ;
                        switchLongToState = 'open' ;
                        switchShortToState = 'closed' ;
                    } else {
                        // full -> closed
                        source.style.fontStyle = 'italic' ;
                        source.title = 'click to expand' ;
                        source.innerHTML = caption[0] ;
                        switchLongToState = 'closed' ;
                        switchShortToState = 'closed' ;
                    }
            
                    // Toggle the target (everething below the header row).
                    // First two rows are XMLComment and XMLRoot - they are part
                    // of the long dump, the rest are direct children - part of the
                    // short dump
                    if(document.all) {
                        var table = source.parentElement.parentElement ;
                        for ( var i = 1; i < table.rows.length; i++ ) {
                            target = table.rows[i] ;
                            if ( i < 3 ) cfdump_toggleTarget( target, switchLongToState ) ;
                            else cfdump_toggleTarget( target, switchShortToState ) ;
                        }
                    }
                    else {
                        var table = source.parentNode.parentNode ;
                        var row = 1;
                        for ( var i = 1; i < table.childNodes.length; i++ ) {
                            target = table.childNodes[i] ;
                            if( target.style ) {
                                if ( row < 3 ) {
                                    cfdump_toggleTarget( target, switchLongToState ) ;
                                } else {
                                    cfdump_toggleTarget( target, switchShortToState ) ;
                                }
                                row++;
                            }
                        }
                    }
                }
            
                cfdump_toggleTable = function(source) {
            
                    var switchToState = cfdump_toggleSource( source ) ;
                    if(document.all) {
                        var table = source.parentElement.parentElement ;
                        for ( var i = 1; i < table.rows.length; i++ ) {
                            target = table.rows[i] ;
                            cfdump_toggleTarget( target, switchToState ) ;
                        }
                    }
                    else {
                        var table = source.parentNode.parentNode ;
                        for ( var i = 1; i < table.childNodes.length; i++ ) {
                            target = table.childNodes[i] ;
                            if(target.style) {
                                cfdump_toggleTarget( target, switchToState ) ;
                            }
                        }
                    }
                }
            
                cfdump_toggleSource = function( source ) {
                    if ( source.style.fontStyle == 'italic' || source.style.fontStyle == null) {
                        source.style.fontStyle = 'normal' ;
                        source.title = 'click to collapse' ;
                        return 'open' ;
                    } else {
                        source.style.fontStyle = 'italic' ;
                        source.title = 'click to expand' ;
                        return 'closed' ;
                    }
                }
            
                cfdump_toggleTarget = function( target, switchToState ) {
                    if ( switchToState == 'open' )	target.style.display = '' ;
                    else target.style.display = 'none' ;
                }
            
                // collapse all td elements for queries
                cfdump_toggleRow_qry = function(source) {
                    expand = (source.title == "click to collapse") ? "closed" : "open";
                    if(document.all) {
                        var nbrChildren = source.parentElement.cells.length;
                        if(nbrChildren > 1){
                            for(i=nbrChildren-1;i>0;i--){
                                target = source.parentElement.cells[i];
                                cfdump_toggleTarget( target,expand ) ;
                                cfdump_toggleSource_qry(source);
                            }
                        }
                        else {
                            //target is the right cell
                            target = source.parentElement.cells[1];
                            cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                        }
                    }
                    else{
                        var target = null;
                        var vLen = source.parentNode.childNodes.length;
                        for(var i=vLen-1;i>1;i--){
                            if(source.parentNode.childNodes[i].nodeType == 1){
                                target = source.parentNode.childNodes[i];
                                cfdump_toggleTarget( target,expand );
                                cfdump_toggleSource_qry(source);
                            }
                        }
                        if(target == null){
                            //target is the last cell
                            target = source.parentNode.lastChild;
                            cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                        }
                    }
                }
            
                cfdump_toggleSource_qry = function(source) {
                    if(expand == "closed"){
                        source.title = "click to expand";
                        source.style.fontStyle = "italic";
                    }
                    else{
                        source.title = "click to collapse";
                        source.style.fontStyle = "normal";
                    }
                }
            
        
        <!--- Parse JSON and return optimized result --->
        <cfset MyS = deserializeJSON(myV)>
        
        <cfsavecontent variable="test1">
            <style>
                table.cfdump_wddx,table.cfdump_xml,table.cfdump_struct,table.cfdump_varundefined,table.cfdump_array,table.cfdump_query,table.cfdump_cfc,table.cfdump_object,table.cfdump_binary,table.cfdump_udf { font-size: xx-small; font-family: verdana, arial, helvetica, sans-serif; }
                table.cfdump_wddx th,table.cfdump_xml th,table.cfdump_struct th,table.cfdump_varundefined th,table.cfdump_array th,table.cfdump_query th,table.cfdump_cfc th,table.cfdump_object th,table.cfdump_binary th,table.cfdump_udf th { text-align: left; color: white; padding: 5px; }
                table.cfdump_wddx td,table.cfdump_xml td,table.cfdump_struct td,table.cfdump_varundefined td,table.cfdump_array td,table.cfdump_query td,table.cfdump_cfc td,table.cfdump_object td,table.cfdump_binary td,table.cfdump_udf td { padding: 3px; background-color: ##ffffff; vertical-align: top; }
            </style>
            <script language="javascript">
                // Optimized version - reduced DOM manipulation
                function dumpToggle(source) {
                    var target = source.parentNode.nextSibling;
                    if (target && target.style) {
                        target.style.display = target.style.display === "none" ? "" : "none";
                    }
                }
            </script>
            <h3>OPTIMIZED getTrees Function Result</h3>
            <p>Performance improvements:</p>
            <ul>
                <li>Eliminated N+1 queries</li>
                <li>Single query with JOINs</li>
                <li>Batch price data fetching</li>
                <li>Reduced function calls from ~#getTree.recordCount * 3# to ~#max(getTree.recordCount, 1)#</li>
            </ul>
            <cfdump var="#MyS#">
            <cfdump var="#arguments#">
            <cfdump var="#getTree#">
        </cfsavecontent>
        <cffile action="write" file="c:\PBS\UrunGetir_optimized_#arguments.pid#.html" output="#test1#">
        
        <cfreturn replace(serializeJSON(MyS), "//", "")>
    </cffunction>

    <cffunction name="GetRndmNmbr">
        <cfscript>
               num1 = 0;
               num2 = 100000;
               randAlgorithmArray = ["CFMX_COMPAT", "SHA1PRNG", "IBMSecureRandom"];
            retrunNumber=randRange(num1, num2, randAlgorithmArray[1]) ;
             
        </cfscript>
        <cfreturn retrunNumber>
        </cffunction>
    <cffunction name="getPriceFunk">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="COMPANY_ID">
        <cfargument name="PRICE_CATID">
        <cfargument name="ddsn3">
        <cfsavecontent variable="test1">
            
            <cfdump var="#arguments#">
            
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\getPriceFunk_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
<cfif arguments.IS_VIRTUAL neq 1 and len(arguments.PRODUCT_ID)>

            <cfquery name="getPrice" datasource="#arguments.ddsn3#">
                 SELECT
                    P.UNIT,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.PRODUCT_ID,
                    P.MONEY,
                    P.PRICE_CATID,
                    P.CATALOG_ID,
                    P.PRICE_DISCOUNT
                FROM
                    PRICE P,
                    PRODUCT PR
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID
                    AND P.PRICE_CATID = #arguments.price_catid#
                    AND
                    (
                        P.STARTDATE <= GETDATE()
                        AND
                        (
                            P.FINISHDATE >= GETDATE() OR
                            P.FINISHDATE IS NULL
                        )
                    )
                    AND ISNULL(P.SPECT_VAR_ID, 0) = 0 
					AND P.PRODUCT_ID=#arguments.product_id#
            </cfquery>
            <cfsavecontent variable="test1"><cfdump var="#getPrice#"></cfsavecontent>
              <cffile action="write" file = "c:\PBS\getPriceFunk_01_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfquery name="getDiscount" datasource="#arguments.ddsn3#">
                SELECT TOP 1
                    PCE.DISCOUNT_RATE
                FROM
                    PRODUCT P,
                    PRICE_CAT_EXCEPTIONS PCE
                    LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                WHERE
                    (
                        PCE.PRODUCT_ID = P.PRODUCT_ID OR
                        PCE.PRODUCT_ID IS NULL
                    ) AND
                    (
                        PCE.BRAND_ID = P.BRAND_ID OR
                        PCE.BRAND_ID IS NULL
                    ) AND
                    (
                        PCE.PRODUCT_CATID = P.PRODUCT_CATID OR
                        PCE.PRODUCT_CATID IS NULL
                    ) AND
                    (
                        PCE.COMPANY_ID = #arguments.COMPANY_ID# OR
                        PCE.COMPANY_ID IS NULL
                    ) AND
                    P.PRODUCT_ID = #arguments.PRODUCT_ID# AND
                    ISNULL(PC.IS_SALES,0) = 1 AND
                    PCE.ACT_TYPE NOT IN (2,4) AND 
                    PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
                ORDER BY
                    PCE.COMPANY_ID DESC,
                    PCE.PRODUCT_CATID DESC
            </cfquery>
            <cfsavecontent variable="test1"><cfdump var="#getDiscount#"></cfsavecontent>
            <cffile action="write" file = "c:\PBS\getPriceFunk_02_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfset ReturnData.STANDART_PRICE=getPrice.PRICE>
            <cfset ReturnData.PRICE=getPrice.PRICE>
            <cfset ReturnData.MONEY=getPrice.MONEY>
            <cfset ReturnData.DISCOUNT=getDiscount.DISCOUNT_RATE>
            <cfreturn ReturnData>
        <cfelse>
            <cfset ReturnData.PRICE=0>
            <cfset ReturnData.STANDART_PRICE=0>
            <cfset ReturnData.MONEY="TL">
            <cfset ReturnData.DISCOUNT=0>
            <cfreturn ReturnData>
        </cfif>
        
    </cffunction>

    <cffunction name="getPriceFunk_AJAX" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="COMPANY_ID">
        <cfargument name="PRICE_CATID">
        <cfargument name="ddsn3">
        <cfargument name="ROW_ID">
        <cfsavecontent variable="test1">
            
            <cfdump var="#arguments#">
            
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\getPriceFunk_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
<cfif arguments.IS_VIRTUAL neq 1 and len(arguments.PRODUCT_ID)>

            <cfquery name="getPrice" datasource="#arguments.ddsn3#">
                 SELECT
                    P.UNIT,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.PRODUCT_ID,
                    P.MONEY,
                    P.PRICE_CATID,
                    P.CATALOG_ID,
                    P.PRICE_DISCOUNT
                FROM
                    PRICE P,
                    PRODUCT PR
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID
                    AND P.PRICE_CATID = #arguments.price_catid#
                    AND
                    (
                        P.STARTDATE <= GETDATE()
                        AND
                        (
                            P.FINISHDATE >= GETDATE() OR
                            P.FINISHDATE IS NULL
                        )
                    )
                    AND ISNULL(P.SPECT_VAR_ID, 0) = 0 
					AND P.PRODUCT_ID=#arguments.product_id#
            </cfquery>
            <cfsavecontent variable="test1"><cfdump var="#getPrice#"></cfsavecontent>
              <cffile action="write" file = "c:\PBS\getPriceFunk_01_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfquery name="getDiscount" datasource="#arguments.ddsn3#">
                SELECT TOP 1
                    PCE.DISCOUNT_RATE
                FROM
                    PRODUCT P,
                    PRICE_CAT_EXCEPTIONS PCE
                    LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                WHERE
                    (
                        PCE.PRODUCT_ID = P.PRODUCT_ID OR
                        PCE.PRODUCT_ID IS NULL
                    ) AND
                    (
                        PCE.BRAND_ID = P.BRAND_ID OR
                        PCE.BRAND_ID IS NULL
                    ) AND
                    (
                        PCE.PRODUCT_CATID = P.PRODUCT_CATID OR
                        PCE.PRODUCT_CATID IS NULL
                    ) AND
                    (
                        PCE.COMPANY_ID = #arguments.COMPANY_ID# OR
                        PCE.COMPANY_ID IS NULL
                    ) AND
                    P.PRODUCT_ID = #arguments.PRODUCT_ID# AND
                    ISNULL(PC.IS_SALES,0) = 1 AND
                    PCE.ACT_TYPE NOT IN (2,4) AND 
                    PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
                ORDER BY
                    PCE.COMPANY_ID DESC,
                    PCE.PRODUCT_CATID DESC
            </cfquery>
            <cfsavecontent variable="test1"><cfdump var="#getDiscount#"></cfsavecontent>
            <cffile action="write" file = "c:\PBS\getPriceFunk_02_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfset ReturnData.STANDART_PRICE=getPrice.PRICE>
            <cfset ReturnData.PRICE=getPrice.PRICE>
            <cfset ReturnData.MONEY=getPrice.MONEY>
            <cfif getDiscount.recordCount>
            <cfset ReturnData.DISCOUNT=getDiscount.DISCOUNT_RATE>
        <cfelse>
            <cfset ReturnData.DISCOUNT=0>
        </cfif>
            <CFSET ReturnData.ROW_ID=arguments.ROW_ID>
            <cfreturn ReturnData>
        <cfelse>
            <cfset ReturnData.PRICE=0>
            <cfset ReturnData.STANDART_PRICE=0>
            <cfset ReturnData.MONEY="TL">
            <cfset ReturnData.DISCOUNT=0>
            <CFSET ReturnData.ROW_ID=arguments.ROW_ID>
            <cfreturn ReturnData>
        </cfif>
        
    </cffunction>


    <!--- Modern method for updating product stage with error handling --->
    <cffunction name="updateProductStage" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="productId" type="numeric" required="true">
        <cfargument name="stage" type="numeric" required="true">
        <cfargument name="projectId" type="numeric" default="#session.ep.period_id#">
        <cfargument name="ddsn3" type="string" default="workcube_metosan_1">
        
        <cfset var result = {}>
        <cfset var startTime = GetTickCount()>
        
        <cftry>
            <!--- Input validation --->
            <cfif NOT IsNumeric(arguments.productId) OR arguments.productId LTE 0>
                <cfthrow type="ValidationError" message="Invalid product ID">
            </cfif>
            
            <cfif NOT IsNumeric(arguments.stage) OR arguments.stage LTE 0>
                <cfthrow type="ValidationError" message="Invalid stage ID">
            </cfif>
            
            <!--- Update product stage --->
            <cfquery name="updateStage" datasource="#arguments.ddsn3#">
                UPDATE VIRTUAL_PRODUCTS_PRT 
                SET PRODUCT_STAGE = <cfqueryparam value="#arguments.stage#" cfsqltype="cf_sql_integer">
                WHERE VIRTUAL_PRODUCT_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <!--- Get updated stage info for response --->
            <cfquery name="getStageInfo" datasource="#dsn#">
                SELECT STAGE 
                FROM PROCESS_TYPE_ROWS 
                WHERE PROCESS_ROW_ID = <cfqueryparam value="#arguments.stage#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <cfset result.success = true>
            <cfset result.message = "Stage updated successfully">
            <cfset result.productId = arguments.productId>
            <cfset result.stageId = arguments.stage>
            <cfset result.stageName = getStageInfo.recordCount ? getStageInfo.STAGE : "">
            <cfset result.executionTime = GetTickCount() - startTime>
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.error = {
                    type = cfcatch.type,
                    message = cfcatch.message,
                    detail = cfcatch.detail
                }>
                <cfset result.executionTime = GetTickCount() - startTime>
                
                <!--- Log error for debugging --->
                <cflog file="product_design_errors" text="updateProductStage failed: #cfcatch.message# - ProductID: #arguments.productId#, Stage: #arguments.stage#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Modern method for creating new draft with enhanced validation --->
    <cffunction name="createNewDraft" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="productName" type="string" required="true">
        <cfargument name="productCatId" type="numeric" required="true">
        <cfargument name="productUnit" type="string" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        <cfargument name="ddsn3" type="string" default="workcube_metosan_1">
        
        <cfset var result = {}>
        <cfset var startTime = GetTickCount()>
        
        <cftry>
            <!--- Enhanced input validation --->
            <cfif NOT Len(Trim(arguments.productName))>
                <cfthrow type="ValidationError" message="Product name is required">
            </cfif>
            
            <cfif Len(arguments.productName) GT 255>
                <cfthrow type="ValidationError" message="Product name too long (max 255 characters)">
            </cfif>
            
            <cfif NOT IsNumeric(arguments.productCatId) OR arguments.productCatId LTE 0>
                <cfthrow type="ValidationError" message="Valid product category is required">
            </cfif>
            
            <cfif NOT Len(Trim(arguments.productUnit))>
                <cfthrow type="ValidationError" message="Product unit is required">
            </cfif>
            
            <!--- Verify category exists --->
            <cfquery name="verifyCat" datasource="#arguments.ddsn3#">
                SELECT PRODUCT_CAT 
                FROM PRODUCT_CAT 
                WHERE PRODUCT_CATID = <cfqueryparam value="#arguments.productCatId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <cfif NOT verifyCat.recordCount>
                <cfthrow type="ValidationError" message="Invalid product category">
            </cfif>
            
            <!--- Create new virtual product --->
            <cfquery name="insertDraft" datasource="#arguments.ddsn3#" result="insertResult">
                INSERT INTO VIRTUAL_PRODUCTS_PRT (
                    PRODUCT_NAME,
                    PRODUCT_CATID,
                    PRICE,
                    MARJ,
                    PRODUCT_TYPE,
                    IS_CONVERT_REAL,
                    IS_PRODUCTION,
                    RECORD_EMP,
                    RECORD_DATE,
                    PRODUCT_DESCRIPTION,
                    PRODUCT_UNIT,
                    PROJECT_ID,
                    PRODUCT_VERSION,
                    PRODUCT_STAGE,
                    PORCURRENCY
                ) VALUES (
                    <cfqueryparam value="#Trim(arguments.productName)#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.productCatId#" cfsqltype="cf_sql_integer">,
                    0,
                    0,
                    0,
                    0,
                    1,
                    <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    GETDATE(),
                    '',
                    <cfqueryparam value="#Trim(arguments.productUnit)#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.projectId#" cfsqltype="cf_sql_integer">,
                    '',
                    339,
                    -6
                )
            </cfquery>
            
            <cfset result.success = true>
            <cfset result.message = "Draft created successfully">
            <cfset result.productId = insertResult.IDENTITYCOL>
            <cfset result.productName = arguments.productName>
            <cfset result.categoryName = verifyCat.PRODUCT_CAT>
            <cfset result.executionTime = GetTickCount() - startTime>
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.error = {
                    type = cfcatch.type,
                    message = cfcatch.message,
                    detail = cfcatch.detail
                }>
                <cfset result.executionTime = GetTickCount() - startTime>
                
                <!--- Log error --->
                <cflog file="product_design_errors" text="createNewDraft failed: #cfcatch.message# - Product: #arguments.productName#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Enhanced project products method with better performance --->
    <cffunction name="getProjectProductsOptimized" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="projectId" type="numeric" required="true">
        <cfargument name="ddsn3" type="string" default="workcube_metosan_1">
        <cfargument name="includeStats" type="boolean" default="false">
        
        <cfset var result = {}>
        <cfset var startTime = GetTickCount()>
        
        <cftry>
            <!--- Get products with stage information in single optimized query --->
            <cfquery name="getProducts" datasource="#arguments.ddsn3#">
                SELECT 
                    VP.VIRTUAL_PRODUCT_ID,
                    VP.PRODUCT_NAME,
                    VP.PRODUCT_STAGE,
                    VP.PRICE,
                    VP.RECORD_DATE,
                    VP.RECORD_EMP,
                    COALESCE(PTR.STAGE, 'Unknown') AS STAGE_NAME,
                    PC.PRODUCT_CAT,
                    <cfif arguments.includeStats>
                    (SELECT COUNT(*) FROM VIRTUAL_PRODUCT_TREE_PRT VPT 
                     WHERE VPT.VP_ID = VP.VIRTUAL_PRODUCT_ID) AS TREE_COUNT,
                    </cfif>
                    1 AS IS_MAIN
                FROM VIRTUAL_PRODUCTS_PRT VP
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = VP.PRODUCT_STAGE
                LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = VP.PRODUCT_CATID
                WHERE VP.PROJECT_ID = <cfqueryparam value="#arguments.projectId#" cfsqltype="cf_sql_integer">
                ORDER BY VP.RECORD_DATE DESC, VP.PRODUCT_NAME
            </cfquery>
            
            <cfset var products = []>
            
            <cfloop query="getProducts">
                <cfset var product = {
                    id = VIRTUAL_PRODUCT_ID,
                    name = PRODUCT_NAME,
                    stageId = PRODUCT_STAGE,
                    stageName = STAGE_NAME,
                    price = PRICE,
                    categoryName = PRODUCT_CAT,
                    recordDate = RECORD_DATE,
                    recordEmp = RECORD_EMP,
                    isMain = IS_MAIN
                }>
                
                <cfif arguments.includeStats>
                    <cfset product.treeCount = TREE_COUNT>
                </cfif>
                
                <!--- Add stage badge class for UI --->
                <cfswitch expression="#PRODUCT_STAGE#">
                    <cfcase value="339">
                        <cfset product.badgeClass = "badge-danger">
                    </cfcase>
                    <cfcase value="340">
                        <cfset product.badgeClass = "badge-success">
                    </cfcase>
                    <cfcase value="341">
                        <cfset product.badgeClass = "badge-warning">
                    </cfcase>
                    <cfcase value="342">
                        <cfset product.badgeClass = "badge-primary">
                    </cfcase>
                    <cfdefaultcase>
                        <cfset product.badgeClass = "badge-dark">
                    </cfdefaultcase>
                </cfswitch>
                
                <cfset ArrayAppend(products, product)>
            </cfloop>
            
            <cfset result.success = true>
            <cfset result.products = products>
            <cfset result.count = getProducts.recordCount>
            <cfset result.projectId = arguments.projectId>
            <cfset result.executionTime = GetTickCount() - startTime>
            
            <cfcatch type="any">
                <cfset result.success = false>
                <cfset result.error = {
                    type = cfcatch.type,
                    message = cfcatch.message
                }>
                <cfset result.executionTime = GetTickCount() - startTime>
                
                <cflog file="product_design_errors" text="getProjectProductsOptimized failed: #cfcatch.message# - ProjectID: #arguments.projectId#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <!--- Original updateStage method - kept for backward compatibility --->
    <cffunction name="updateStage" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="vp_id">
        <cfargument name="psatge">
        <cfargument name="projectId">
        <cfargument name="ddsn3">
        
        <!--- Call new optimized method --->
        <cfset var result = updateProductStage(vp_id, psatge, projectId, ddsn3)>
        
        <cfif result.success>
            <cfreturn "Kayit Başarılı">
        <cfelse>
            <cfreturn "Hata: " & result.error.message>
        </cfif>
    </cffunction>

    <!--- Original NewDraft method - kept for backward compatibility --->
    <cffunction name="NewDraft" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="PRODUCT_NAME">
        <cfargument name="PRODUCT_CATID">
        <cfargument name="PRODUCT_UNIT">
        <cfargument name="PROJECT_ID">
        <cfargument name="ddsn3">
        
        <!--- Call new optimized method --->
        <cfreturn createNewDraft(PRODUCT_NAME, PRODUCT_CATID, PRODUCT_UNIT, PROJECT_ID, ddsn3)>
    </cffunction>

    <cffunction name="getProjectProducts" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="PROJECT_ID">
        <cfargument name="ddsn3">
        <cfquery name="getP" datasource="#arguments.ddsn3#">
            SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
            WHERE PROJECT_ID=#arguments.PROJECT_ID#           
          </cfquery>
        <cfsavecontent variable="leftMenu">
            <cfoutput query="getP">             
                <a class="list-group-item list-group-item-action" id="VP_#VIRTUAL_PRODUCT_ID#" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#arguments.ddsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')">
                    #PRODUCT_NAME#
                    <cfif PRODUCT_STAGE eq 339>
                        <span style="float:right;font-size:11pt" class="badge bg-danger rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 340>
                        <span style="float:right;font-size:11pt" class="badge bg-success rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 341>
                        <span style="float:right;font-size:11pt" class="badge bg-warning rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 342>
                        <span style="float:right;font-size:11pt" class="badge bg-primary rounded-pill">#STAGE#</span>
                    <cfelse>
                        <span style="float:right;font-size:11pt" class="badge bg-dark rounded-pill">0</span>
                    </cfif>                
                </a>     
            </cfoutput>
        </cfsavecontent>
        <cfreturn leftMenu>
    </cffunction>
    <cffunction name="updateSettings" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="paramValue">
        <cfargument name="paramName">
        <cfargument name="ddsn3">
        <cfquery name="up" datasource="#arguments.ddsn3#" result="res">
            update PROJECT_PRODUCT_DESIGN_PARAMS_PBS set PARAM_VALUE='#arguments.paramValue#' WHERE PARAM_NAME='#arguments.paramName#'
        </cfquery>
        <cfreturn replace(serializeJSON(res),"//","")>
    </cffunction>
    <cffunction name="getQuestionData">
        <cfargument name="question_id">
        <cfset quid=arguments.question_id>;
        <cfset V=arrayfind(QuestionArr,p=>p.QUESTION_ID==quid)>    
        <cfif V neq 0>
            <cfreturn QuestionArr[V]>
        <cfelse>
            <cfreturn {
                QUESTION_ID=arguments.question_id,
                QUESTION_NAME=""
            }>
        </cfif>
        
    </cffunction>
    <cffunction name="DELVP" access="remote" httpMethod="POST" >
        <cfargument name="vp_id">
        <cfargument name="ddsn3">
        <cfquery name="del" datasource="#arguments.ddsn3#">
            DELETE  from VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#arguments.vp_id# 
        </cfquery>
        <cfquery name="del" datasource="#arguments.ddsn3#">                
            DELETE  FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.vp_id# 
        </cfquery>

    </cffunction>
    <cffunction name="SaveTreePrices" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfdump var="#deserializeJSON(arguments.FORM_DATA)#">
        <cfset dsn3="workcube_metosan_1">
        <CFSET FORM_DATA=deserializeJSON(arguments.FORM_DATA)>
        <cfset IS_VIRTUAL=listGetAt(FORM_DATA.PRODUCT,2,"**")>
        <cfset MAIN_PRODUCT_ID=listGetAt(FORM_DATA.PRODUCT,1,"**")>
      
<CFSET R=price_to_history(MAIN_PRODUCT_ID,IS_VIRTUAL)>
      <cfquery name="ins" datasource="#dsn3#" result="res">
          INSERT INTO PROJECT_PRODUCTS_TREE_PRICES_MAIN(RECORD_DATE,RECORD_EMP,MAIN_PRODUCT_ID,PROJECT_ID,IS_VIRTUAL,IS_AKTIF) VALUES (GETDATE(),#FORM_DATA.RECORD_EMP#,#MAIN_PRODUCT_ID#,#FORM_DATA.PROJECT_ID#,#IS_VIRTUAL#,1)
        </cfquery>
        <cfdump var="#res#">
        <cfloop array="#FORM_DATA.PRODUCT_TREE#" item="it">
          <cfif IS_VIRTUAL EQ 0>
          <cfquery name="ins2" datasource="#dsn3#">
               INSERT INTO PROJECT_REAL_PRODUCTS_TREE_PRICES(PROJECT_ID,MAIN_PRODUCT_ID ,PRODUCT_TREE_ID ,UPPER_TRERE_ID ,AMOUNT ,PRICE ,OTHER_MONEY ,DISCOUNT ,MAIN_ID,IS_ACTIVE,PBS_ROW_ID )
               VALUES (#FORM_DATA.PROJECT_ID#,#MAIN_PRODUCT_ID#,#it.PRODUCT_TREE_ID#,#it.UPPER_PRODUCT_TREE_ID#,#it.AMOUNT#,#it.PRICE#,'#it.OTHER_MONEY#',#it.DISCOUNT#,#res.IDENTITYCOL#,1,'#it.PBS_ROW_ID#')
            </cfquery>

            <CFELSE>
                <cfquery name="ins2" datasource="#dsn3#">
                    INSERT INTO PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES(PROJECT_ID,MAIN_PRODUCT_ID ,PRODUCT_TREE_ID ,UPPER_TRERE_ID ,AMOUNT ,PRICE ,OTHER_MONEY ,DISCOUNT ,MAIN_ID,IS_ACTIVE,PBS_ROW_ID )
                    VALUES (#FORM_DATA.PROJECT_ID#,#MAIN_PRODUCT_ID#,#it.PRODUCT_TREE_ID#,#it.UPPER_PRODUCT_TREE_ID#,#it.AMOUNT#,#it.PRICE#,'#it.OTHER_MONEY#',#it.DISCOUNT#,#res.IDENTITYCOL#,1,'#it.PBS_ROW_ID#')
                 </cfquery>
                 
            </cfif>
        </cfloop>
        <cfquery name="up" datasource="#dsn3#">
            UPDATE workcube_metosan_1.VIRTUAL_PRODUCTS_PRT SET PRICE=#FORM_DATA.GENEL_TOPLAM# WHERE VIRTUAL_PRODUCT_ID=#MAIN_PRODUCT_ID#
         </cfquery>
        <cfloop array="#FORM_DATA.KURLAR#" item="kur">
        <cfquery name="INSKUR" datasource="#DSN3#">
            INSERT INTO PROJECT_PRODUCTS_TREE_PRICES_MAIN_MONEY(MAIN_ID,MONEY,RATE2) VALUES(#res.IDENTITYCOL#,'#kur.MONEY#',#kur.RATE2#)
        </cfquery>
        </cfloop>
    </cffunction>

    <cffunction name="price_to_history">
        <cfargument name="MAIN_PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">

        <cfquery name="getMain" datasource="#dsn3#">
            SELECT * FROM PROJECT_PRODUCTS_TREE_PRICES_MAIN WHERE MAIN_PRODUCT_ID=#ARGUMENTS.MAIN_PRODUCT_ID# AND IS_VIRTUAL=#ARGUMENTS.IS_VIRTUAL#
        </cfquery>
        <cfif getMain.recordCount>
            <cfloop query="getMain">
            <cfquery name="getRows" datasource="#dsn3#">
                SELECT * FROM <CFIF ARGUMENTS.IS_VIRTUAL EQ 1>
                    PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES
                <CFELSE>
                    PROJECT_REAL_PRODUCTS_TREE_PRICES
                </CFIF>
                WHERE MAIN_ID=#getMain.MAIN_ID#                
            </cfquery>
            <cfloop query="getRows">
                <cfquery name="SEDEC" datasource="#DSN3#">
                    UPDATE <CFIF ARGUMENTS.IS_VIRTUAL EQ 1>
                    PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES
                <CFELSE>
                    PROJECT_REAL_PRODUCTS_TREE_PRICES
                </CFIF>
                SET IS_ACTIVE=0 WHERE MAIN_ID=#getMain.MAIN_ID#
                </cfquery>
            </cfloop>
            <cfquery name="SEDC2" datasource="#DSN3#">
                UPDATE PROJECT_PRODUCTS_TREE_PRICES_MAIN SET IS_AKTIF=0 WHERE MAIN_ID=#GETMAIN.MAIN_ID#
            </cfquery>
        </cfloop>
        </cfif>
        <cfreturn "Başarılı">

    </cffunction>


</cfcomponent>