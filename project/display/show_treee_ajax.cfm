<cfdump var="#attributes#">

<cfquery name="getTree" datasource="#dsn3#">
    SELECT * FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#attributes.vp_id#
</cfquery>

<ul>
    <cfoutput query="getTree">
        <cfset seviye=0>
        <cfquery name="getSInfo" datasource="#dsn3#">
        <cfif IS_VIRTUAL EQ 1>
            SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
        
        <cfelse>
            SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
        </cfif>
    </cfquery>
    <li>
        #getSInfo.PRODUCT_NAME# <input type="text" name="amount_#seviye#_#VPT_ID#" id="amount_#seviye#_#VPT_ID#">
        <cfquery name="ishvTree" datasource="#dsn3#">
            <cfif IS_VIRTUAL EQ 1>
                SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#
            
            <cfelse>
                SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#
            </cfif>
        </cfquery>
        <cfif ishvTree.recordCount>
            <ul>
                <cfloop query="ishvTree">
                    <cfset seviye=1>
                    <cfquery name="getSInfoa" datasource="#dsn3#">
                        <cfif IS_VIRTUAL EQ 1>
                            SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
                        
                        <cfelse>
                            SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
                        </cfif>
                    </cfquery>
                    <li>
                        #getSInfoa.PRODUCT_NAME# <input type="text" name="amount_#seviye#_#VPT_ID#" id="amount_#seviye#_#VPT_ID#">
                    </li>
                </cfloop>
            </ul>
        </cfif>
    </li>
</cfoutput>
</ul>