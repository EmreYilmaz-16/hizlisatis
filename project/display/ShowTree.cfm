<cffunction name="getTreeFro">
    <cfargument name="productId">
    <cfargument name="isVirtual">
    <cfargument name="stockId">
    <cfquery name="getTree" datasource="#dsn3#">
        <cfif arguments.isVirtual eq 1>
            SELECT *,STOCK_ID AS RELATED_ID,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0
        <cfelse>
            select *,0 AS IS_VIRTUAL from PRODUCT_TREE WHERE STOCK_ID=#arguments.sid#
        </cfif>
    </cfquery>
    <ul>
    <cfloop query="getTree">
        <cfquery name="getSInfo" datasource="#dsn3#">
            <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
            <cfelse>
                    SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
            </cfif>
        </cfquery>
        <cfset O = structNew()>
        <cfif IS_VIRTUAL eq 1>
            <cfset O.STOCK_ID = STOCK_ID>
        <CFELSE>
            <CFSET O.STOCK_ID = RELATED_ID>
        </cfif>
        <cfset O.PRICE = priceData.PRICE>
        <cfset O.MONEY = priceData.MONEY>
        <cfset O.DISCOUNT = priceData.DISCOUNT>
        <cfset O.IS_VIRTUAL = IS_VIRTUAL>
        <cfset O.VIRTUAL_PRODUCT_TREE_ID = 0>
        <CFSET O.PRODUCT_TREE_ID = PRODUCT_TREE_ID>
        <cfset O.PRODUCT_ID = PRODUCT_ID>
        <cfoutput>
                <li>
                #getSInfo.PRODUCT_NAME# <span>#AMOUNT#</span>
                <cfquery name="ishvTree" datasource="#dsn3#">
                    <cfif IS_VIRTUAL EQ 1>
                            SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#
                    <cfelse>
                            SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=(SELECT STOCK_ID FROM STOCKS WHERE
                            PRODUCT_ID=#PRODUCT_ID#)
                    </cfif>

                </cfquery>
                <cfif ishvTree.recordCount>
                    <cfscript>
                        getTreeFro(pid = O.PRODUCT_ID, isVirtual = O.IS_VIRTUAL, sid = ishvTree.STOCK_ID);
                    </cfscript>
                <cfelse>""</cfif>
                </li>
        </cfoutput>
    </cfloop>
    </ul>
</cffunction>