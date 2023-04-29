<cfcomponent>
    <cfset dsn=application.systemparam.dsn>
    <cfset dsn3="#dsn#_1">
        <cffunction name="getTree" access="remote" httpMethod="POST" returntype="any" returnFormat="json">
            <cfargument name="product_id">
            <cfargument name="isVirtual">
            <cfset TreeArr=arrayNew(1)>
            <cfif arguments.isVirtual eq 1>
                <cfset TreeArr=getTreeFromVirtual(product_id)>
            <cfelse>
                <cfset TreeArr=getTreeFromRealProduct(product_id)>
            </cfif>
            <cfreturn replace(serializeJSON(TreeArr),"//","")>
        </cffunction>

    
    <cffunction name="getTreeFromVirtual" >
        <cfargument name="product_id">        
        <cfquery name="getTree" datasource="#dsn3#">
            SELECT * FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTree">
            <cfset O=structNew()>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn3#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#        
                <cfelse>
                    SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
                </cfif>
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfquery name="ishvTree" datasource="#dsn3#">
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
        

        <cfquery name="getTreeFromVirtual" datasource="#dsn3#">
            SELECT * FROM workcube_metosan_1.PRODUCT_TREE WHERE STOCK_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTree">
            <cfset O=structNew()>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn3#">              
                    SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#              
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfquery name="ishvTree" datasource="#dsn3#">            
                    SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#            
            </cfquery>
            <cfif ishvTree.recordCount>              
                    <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID)>               
            </cfif>
            <cfscript>
                arrayAppend(ReturnArr,O);
            </cfscript>
        </cfloop>
        <cfreturn ReturnArr>
    </cffunction>
</cfcomponent>