<style>
    .productFound{
        border: solid 4px #00800061 !important;
    }
    .productNotFound{
        border: solid 4px #ff000061 !important;
    }
    .productDefault{
    border: 1px solid #ccc !important;
    }
</style>
<cf_box title="Ürün Fiyat Girişi">

    <div class="form-group">
        <input type="text" name="project_no" placeholder="Proje No" id="project_no" onkeydown="getProjectProducts(this,event)">
    </div>
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#"><div class="form-group">
        <select name="product" id="product">
            <option value="">Ürün</option>
            <optgroup label="Gerçek Ürünler" id="ProductrRealOptGroup">

            </optgroup>
            <optgroup label="Sanal Ürünler" id="ProductrVirtualOptGroup">

            </optgroup>
        </select>
    </div>
    <div class="form-group">
        <input type="submit">
        <input type="hidden" name="is_submit" value="1">
    </div>
</cfform>
</cf_box>
<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfdump var="#attributes#">

    

<cfset IS_VIRTUAL=listGetAt(attributes.PRODUCT,2,"**")>
<cfset MAIN_PRODUCT_ID=listGetAt(attributes.PRODUCT,1,"**")>
<cfif IS_VIRTUAL EQ 1>
   <cfquery name="SEVIYE_1" datasource="#DSN3#">
    SELECT PT.*,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS SIDO FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS PT  --WHERE IS_VIRTUAL=1
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.STOCK_ID
LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VPT ON VPT.VIRTUAL_PRODUCT_ID=PT.PRODUCT_ID
 WHERE VP_ID=#MAIN_PRODUCT_ID#
   </cfquery>
    <ul>
    <cfoutput query="SEVIYE_1">
        <CFSET SEVIYE_2=getTree(SEVIYE_1.SIDO,SEVIYE_1.IS_VIRTUAL)>
        <li>
            <div style="display:flex">
           <span> #PRODUCT_NAME#</span>  <table><tr><th>Fiyat</th><th>İndirim</th></tr><tr><td><input <cfif SEVIYE_2.recordCount>disabled=""</cfif> type="text" value="#SEVIYE_1.PRICE#"></td><td><input type="text" <cfif SEVIYE_2.recordCount>disabled=""</cfif> value="#SEVIYE_1.DISCOUNT#"></td></tr></table>
        </div>
        <cfif SEVIYE_2.recordCount>
            <ul>
                <cfloop query="SEVIYE_2">
                    <CFSET SEVIYE_3=getTree(SEVIYE_1.SIDO,SEVIYE_1.IS_VIRTUAL)>
                    <li>
                        <div style="display:flex">
                            <span> #SEVIYE_2.PRODUCT_NAME#</span>  <table><tr><th>Fiyat</th><th>İndirim</th></tr><tr><td><input <cfif SEVIYE_2.recordCount>disabled=""</cfif> type="text" value="#SEVIYE_2.PRICE#"></td><td><input type="text" <cfif SEVIYE_2.recordCount>disabled=""</cfif> value="#SEVIYE_1.DISCOUNT#"></td></tr></table>
                         </div>
                    </li>
                </cfloop>
            </ul>
        </cfif>
        </li>

    </cfoutput>
</ul>

<cfelseif IS_VIRTUAL EQ 0>
</cfif>

</cfif>
<cffunction name="getTree">
    <cfargument name="STOCK_ID">
    <cfargument name="IS_VIRTUAL">
    <cfquery name="SEVIYE_2" datasource="#DSN3#">
        <cfif arguments.IS_VIRTUAL EQ 1>
            SELECT PT.*,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS SIDO FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS PT  --WHERE IS_VIRTUAL=1
            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.STOCK_ID
            LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VPT ON VPT.VIRTUAL_PRODUCT_ID=PT.PRODUCT_ID
            WHERE VP_ID=#ARGUMENTS.PRODUCT_ID#
        <CFELSE>
            SELECT S.PRODUCT_ID,S.STOCK_ID SIDO ,AMOUNT,PRICE_PBS AS PRICE,DISCOUNT_PBS AS DISCOUNT ,OTHER_MONEY_PBS AS MONEY ,S.PRODUCT_NAME,0 AS IS_VIRTUAL FROM workcube_metosan_1.PRODUCT_TREE AS PT LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID WHERE PT.STOCK_ID=#arguments.STOCK_ID#
        </cfif>
    </cfquery>
    <cfreturn SEVIYE_2>
</cffunction>


<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        


</cfform>



<script src="/AddOns/Partner/Project/js/fiyat_gir.js"></script>