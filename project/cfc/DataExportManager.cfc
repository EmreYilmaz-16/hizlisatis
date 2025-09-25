<!--- 
Data Export Manager for Product Design System
Handles Excel, CSV, and PDF export capabilities
--->

<cfcomponent displayname="DataExportManager" hint="Manages data export functionality for product design system">
    
    <cfscript>
        variables.dsn = application.zeroApp.dsnZero;
        variables.supportedFormats = ["excel", "csv", "pdf", "json"];
        variables.maxExportRecords = 10000;
    </cfscript>
    
    <!--- Main export function --->
    <cffunction name="exportData" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="exportType" required="true" type="string">
        <cfargument name="format" required="true" type="string">
        <cfargument name="filters" required="false" type="struct" default="#{}#">
        <cfargument name="columns" required="false" type="string" default="">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Validate format --->
            <cfif NOT arrayFind(variables.supportedFormats, lcase(arguments.format))>
                <cfthrow message="Desteklenmeyen format: #arguments.format#" type="Validation">
            </cfif>
            
            <!--- Initialize audit logger --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset startTime = getTickCount()>
            
            <!--- Get data based on export type --->
            <cfswitch expression="#arguments.exportType#">
                <cfcase value="products">
                    <cfset exportData = getProductsForExport(arguments.filters, arguments.columns)>
                </cfcase>
                <cfcase value="categories">
                    <cfset exportData = getCategoriesForExport(arguments.filters)>
                </cfcase>
                <cfcase value="pricing">
                    <cfset exportData = getPricingForExport(arguments.filters)>
                </cfcase>
                <cfcase value="inventory">
                    <cfset exportData = getInventoryForExport(arguments.filters)>
                </cfcase>
                <cfdefaultcase>
                    <cfthrow message="Geçersiz export type: #arguments.exportType#" type="Validation">
                </cfdefaultcase>
            </cfswitch>
            
            <!--- Check record limit --->
            <cfif exportData.recordCount GT variables.maxExportRecords>
                <cfthrow message="Çok fazla kayıt. Maksimum #variables.maxExportRecords# kayıt export edilebilir." type="Validation">
            </cfif>
            
            <!--- Generate export file --->
            <cfset exportResult = generateExportFile(exportData, arguments.format, arguments.exportType)>
            
            <!--- Log export operation --->
            <cfset executionTime = getTickCount() - startTime>
            <cfset auditLogger.logUserAction(
                action = "DATA_EXPORT",
                details = "Exported #exportData.recordCount# #arguments.exportType# records as #arguments.format#",
                affectedRecords = "#exportData.recordCount#",
                newValues = {
                    exportType: arguments.exportType,
                    format: arguments.format,
                    recordCount: exportData.recordCount,
                    fileName: exportResult.fileName
                },
                severity = "INFO"
            )>
            
            <cfset auditLogger.logPerformance(
                operation = "DATA_EXPORT_#arguments.exportType#_#arguments.format#",
                executionTime = executionTime,
                recordsProcessed = exportData.recordCount
            )>
            
            <cfreturn serializeJSON({
                success: true,
                fileName: exportResult.fileName,
                filePath: exportResult.filePath,
                fileSize: exportResult.fileSize,
                recordCount: exportData.recordCount,
                downloadUrl: "/downloads/" & exportResult.fileName
            })>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("EXPORT_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "DataExportManager.cfc")>
                <cfreturn serializeJSON({
                    success: false, 
                    message: "Export işlemi başarısız: " & cfcatch.message
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Get products data for export --->
    <cffunction name="getProductsForExport" access="private" returntype="query">
        <cfargument name="filters" required="false" type="struct" default="#{}#">
        <cfargument name="columns" required="false" type="string" default="">
        
        <cfset var selectedColumns = "*">
        <cfif len(trim(arguments.columns))>
            <!--- Validate and sanitize column names --->
            <cfset var columnList = listToArray(arguments.columns)>
            <cfset var allowedColumns = [
                "PRODUCT_ID", "PRODUCT_NAME", "PRODUCT_CATEGORY", "PRODUCT_UNIT_PRICE",
                "IS_ACTIVE", "IS_VIRTUAL", "RECORD_DATE", "UPDATE_DATE", "DISCOUNT_RATE",
                "STOCK_AMOUNT", "MIN_STOCK", "MAX_STOCK"
            ]>
            <cfset var validColumns = []>
            
            <cfloop array="#columnList#" index="col">
                <cfif arrayFind(allowedColumns, ucase(trim(col)))>
                    <cfset arrayAppend(validColumns, trim(col))>
                </cfif>
            </cfloop>
            
            <cfif arrayLen(validColumns) GT 0>
                <cfset selectedColumns = arrayToList(validColumns)>
            </cfif>
        </cfif>
        
        <!--- Build query with filters --->
        <cfset var whereClause = "WHERE p.IS_DELETED = 0">
        
        <!--- Apply filters --->
        <cfif structKeyExists(arguments.filters, "categoryId") AND isNumeric(arguments.filters.categoryId)>
            <cfset whereClause = whereClause & " AND p.PRODUCT_CATEGORY = " & arguments.filters.categoryId>
        </cfif>
        
        <cfif structKeyExists(arguments.filters, "isActive") AND isBoolean(arguments.filters.isActive)>
            <cfset whereClause = whereClause & " AND p.IS_ACTIVE = " & (arguments.filters.isActive ? 1 : 0)>
        </cfif>
        
        <cfif structKeyExists(arguments.filters, "isVirtual") AND isBoolean(arguments.filters.isVirtual)>
            <cfset whereClause = whereClause & " AND p.IS_VIRTUAL = " & (arguments.filters.isVirtual ? 1 : 0)>
        </cfif>
        
        <cfquery name="exportProducts" datasource="#variables.dsn#">
            SELECT TOP #variables.maxExportRecords#
                p.PRODUCT_ID,
                p.PRODUCT_NAME,
                c.PRODUCT_CAT as CATEGORY_NAME,
                p.PRODUCT_UNIT_PRICE,
                p.DISCOUNT_RATE,
                CASE WHEN p.IS_ACTIVE = 1 THEN 'Aktif' ELSE 'Pasif' END as STATUS,
                CASE WHEN p.IS_VIRTUAL = 1 THEN 'Virtual' ELSE 'Real' END as PRODUCT_TYPE,
                p.STOCK_AMOUNT,
                p.MIN_STOCK,
                p.MAX_STOCK,
                p.RECORD_DATE,
                p.UPDATE_DATE,
                ISNULL(s.PRODUCT_NAME, '') as STOCK_NAME,
                ISNULL(e1.EMPLOYEE_NAME, '') as CREATED_BY,
                ISNULL(e2.EMPLOYEE_NAME, '') as UPDATED_BY
            FROM VIRTUAL_PRODUCT_TREE_PRODUCTS_2 p
            LEFT JOIN PRODUCT_CAT c ON p.PRODUCT_CATEGORY = c.PRODUCT_CATID  
            LEFT JOIN STOCKS s ON p.STOCK_ID = s.STOCK_ID
            LEFT JOIN EMPLOYEES e1 ON p.RECORD_EMP = e1.EMPLOYEE_ID
            LEFT JOIN EMPLOYEES e2 ON p.UPDATE_EMP = e2.EMPLOYEE_ID
            #preserveSingleQuotes(whereClause)#
            ORDER BY p.RECORD_DATE DESC
        </cfquery>
        
        <cfreturn exportProducts>
    </cffunction>
    
    <!--- Generate export file based on format --->
    <cffunction name="generateExportFile" access="private" returntype="struct">
        <cfargument name="data" required="true" type="query">
        <cfargument name="format" required="true" type="string">
        <cfargument name="exportType" required="true" type="string">
        
        <cfset var exportDir = expandPath("/exports/")>
        <cfif not directoryExists(exportDir)>
            <cfdirectory action="create" directory="#exportDir#">
        </cfif>
        
        <cfset var timestamp = dateFormat(now(), "yyyymmdd") & "_" & timeFormat(now(), "HHmmss")>
        <cfset var fileName = arguments.exportType & "_export_" & timestamp>
        <cfset var filePath = "">
        <cfset var fileSize = 0>
        
        <cfswitch expression="#lcase(arguments.format)#">
            <cfcase value="excel">
                <cfset fileName = fileName & ".xlsx">
                <cfset filePath = exportDir & fileName>
                <cfset generateExcelFile(arguments.data, filePath, arguments.exportType)>
            </cfcase>
            
            <cfcase value="csv">
                <cfset fileName = fileName & ".csv">
                <cfset filePath = exportDir & fileName>
                <cfset generateCSVFile(arguments.data, filePath)>
            </cfcase>
            
            <cfcase value="pdf">
                <cfset fileName = fileName & ".pdf">
                <cfset filePath = exportDir & fileName>
                <cfset generatePDFFile(arguments.data, filePath, arguments.exportType)>
            </cfcase>
            
            <cfcase value="json">
                <cfset fileName = fileName & ".json">
                <cfset filePath = exportDir & fileName>
                <cfset generateJSONFile(arguments.data, filePath)>
            </cfcase>
        </cfswitch>
        
        <!--- Get file size --->
        <cfif fileExists(filePath)>
            <cfdirectory action="list" directory="#exportDir#" name="fileInfo" filter="#fileName#">
            <cfif fileInfo.recordCount GT 0>
                <cfset fileSize = fileInfo.size[1]>
            </cfif>
        </cfif>
        
        <cfreturn {
            fileName: fileName,
            filePath: filePath,
            fileSize: fileSize
        }>
    </cffunction>
    
    <!--- Generate Excel file --->
    <cffunction name="generateExcelFile" access="private" returntype="void">
        <cfargument name="data" required="true" type="query">
        <cfargument name="filePath" required="true" type="string">
        <cfargument name="exportType" required="true" type="string">
        
        <cftry>
            <!--- Create spreadsheet object --->
            <cfset var spreadsheet = spreadsheetNew("Product Export", true)>
            
            <!--- Set header style --->
            <cfset var headerFormat = {
                bold: true,
                fgcolor: "light_blue",
                color: "white",
                alignment: "center"
            }>
            
            <!--- Add headers --->
            <cfset var headers = []>
            <cfloop list="#arguments.data.columnList#" index="col">
                <cfset arrayAppend(headers, ucase(replace(col, "_", " ", "all")))>
            </cfloop>
            
            <cfset spreadsheetAddRow(spreadsheet, arrayToList(headers))>
            <cfset spreadsheetFormatRow(spreadsheet, headerFormat, 1)>
            
            <!--- Add data rows --->
            <cfloop query="arguments.data">
                <cfset var rowData = []>
                <cfloop list="#arguments.data.columnList#" index="col">
                    <cfset var cellValue = arguments.data[col][currentRow]>
                    <!--- Format dates and numbers --->
                    <cfif isDate(cellValue)>
                        <cfset cellValue = dateFormat(cellValue, "dd/mm/yyyy") & " " & timeFormat(cellValue, "HH:mm")>
                    <cfelseif isNumeric(cellValue)>
                        <cfset cellValue = numberFormat(cellValue, "999,999.99")>
                    </cfif>
                    <cfset arrayAppend(rowData, toString(cellValue))>
                </cfloop>
                <cfset spreadsheetAddRow(spreadsheet, arrayToList(rowData))>
            </cfloop>
            
            <!--- Auto-size columns --->
            <cfloop from="1" to="#arrayLen(headers)#" index="i">
                <cfset spreadsheetSetColumnWidth(spreadsheet, i, -1)>
            </cfloop>
            
            <!--- Add summary row --->
            <cfset var summaryRow = currentRow + 2>
            <cfset spreadsheetSetCellValue(spreadsheet, "TOPLAM KAYIT: #arguments.data.recordCount#", summaryRow, 1)>
            <cfset spreadsheetFormatCell(spreadsheet, {bold: true, color: "blue"}, summaryRow, 1)>
            
            <!--- Write to file --->
            <cfset spreadsheetWrite(spreadsheet, arguments.filePath, true)>
            
            <cfcatch type="any">
                <!--- Fallback to simple text export --->
                <cfset generateCSVFile(arguments.data, replace(arguments.filePath, ".xlsx", ".csv"))>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Generate CSV file --->
    <cffunction name="generateCSVFile" access="private" returntype="void">
        <cfargument name="data" required="true" type="query">
        <cfargument name="filePath" required="true" type="string">
        
        <cfset var csvContent = "">
        
        <!--- Add headers --->
        <cfset var headers = []>
        <cfloop list="#arguments.data.columnList#" index="col">
            <cfset arrayAppend(headers, '"' & ucase(replace(col, "_", " ", "all")) & '"')>
        </cfloop>
        <cfset csvContent = arrayToList(headers) & chr(13) & chr(10)>
        
        <!--- Add data rows --->
        <cfloop query="arguments.data">
            <cfset var rowData = []>
            <cfloop list="#arguments.data.columnList#" index="col">
                <cfset var cellValue = toString(arguments.data[col][currentRow])>
                <!--- Escape quotes and wrap in quotes --->
                <cfset cellValue = replace(cellValue, '"', '""', "all")>
                <cfset arrayAppend(rowData, '"' & cellValue & '"')>
            </cfloop>
            <cfset csvContent = csvContent & arrayToList(rowData) & chr(13) & chr(10)>
        </cfloop>
        
        <!--- Write to file --->
        <cffile action="write" file="#arguments.filePath#" output="#csvContent#" charset="utf-8">
    </cffunction>
    
    <!--- Generate PDF file --->
    <cffunction name="generatePDFFile" access="private" returntype="void">
        <cfargument name="data" required="true" type="query">
        <cfargument name="filePath" required="true" type="string">
        <cfargument name="exportType" required="true" type="string">
        
        <cfsavecontent variable="pdfContent">
            <cfoutput>
            <html>
            <head>
                <style>
                    body { font-family: Arial, sans-serif; font-size: 10px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                    th, td { border: 1px solid ##ccc; padding: 5px; text-align: left; }
                    th { background-color: ##f0f0f0; font-weight: bold; }
                    .header { text-align: center; margin-bottom: 20px; }
                    .summary { margin-top: 20px; font-weight: bold; }
                </style>
            </head>
            <body>
                <div class="header">
                    <h2>#ucase(arguments.exportType)# EXPORT RAPORU</h2>
                    <p>Tarih: #dateFormat(now(), "dd/mm/yyyy")# #timeFormat(now(), "HH:mm")#</p>
                    <p>Toplam Kayıt: #arguments.data.recordCount#</p>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <cfloop list="#arguments.data.columnList#" index="col">
                                <th>#ucase(replace(col, "_", " ", "all"))#</th>
                            </cfloop>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop query="arguments.data">
                            <tr>
                                <cfloop list="#arguments.data.columnList#" index="col">
                                    <td>
                                        <cfset cellValue = arguments.data[col][currentRow]>
                                        <cfif isDate(cellValue)>
                                            #dateFormat(cellValue, "dd/mm/yyyy")#
                                        <cfelseif isNumeric(cellValue)>
                                            #numberFormat(cellValue, "999,999.99")#
                                        <cfelse>
                                            #htmlEditFormat(toString(cellValue))#
                                        </cfif>
                                    </td>
                                </cfloop>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
                
                <div class="summary">
                    <p>Bu rapor sistem tarafından otomatik olarak oluşturulmuştur.</p>
                    <p>Export Tarihi: #now()#</p>
                </div>
            </body>
            </html>
            </cfoutput>
        </cfsavecontent>
        
        <cfpdf action="writeToBrowser" 
               name="pdfContent" 
               source="#pdfContent#" 
               destination="#arguments.filePath#"
               overwrite="yes"
               orientation="landscape">
    </cffunction>
    
    <!--- Generate JSON file --->
    <cffunction name="generateJSONFile" access="private" returntype="void">
        <cfargument name="data" required="true" type="query">
        <cfargument name="filePath" required="true" type="string">
        
        <cfset var jsonData = {
            exportInfo: {
                timestamp: now(),
                recordCount: arguments.data.recordCount,
                columns: listToArray(arguments.data.columnList)
            },
            data: []
        }>
        
        <!--- Convert query to array --->
        <cfloop query="arguments.data">
            <cfset var record = {}>
            <cfloop list="#arguments.data.columnList#" index="col">
                <cfset record[col] = arguments.data[col][currentRow]>
            </cfloop>
            <cfset arrayAppend(jsonData.data, record)>
        </cfloop>
        
        <!--- Write JSON to file --->
        <cffile action="write" 
                file="#arguments.filePath#" 
                output="#serializeJSON(jsonData)#" 
                charset="utf-8">
    </cffunction>
    
    <!--- Get available export formats --->
    <cffunction name="getExportFormats" access="remote" returntype="any" returnformat="json">
        <cfreturn serializeJSON({
            formats: variables.supportedFormats,
            maxRecords: variables.maxExportRecords
        })>
    </cffunction>
    
</cfcomponent>