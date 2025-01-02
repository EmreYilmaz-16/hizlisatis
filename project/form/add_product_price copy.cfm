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
    .ajax_list  > tbody > tr > td > div > input[type=text]{
        text-align:right
    }
    .ajax_list > thead > tr > th {
        text-align:right
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
        <input type="hidden" name="company_id" id="company_id">
        <input type="hidden" name="price_cat" id="price_cat">
        
        <input type="hidden" name="is_submit" value="1">
    </div>
</cfform>

<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfdump var="#attributes#">

    

<cfset IS_VIRTUAL=listGetAt(attributes.PRODUCT,2,"**")>
<cfset MAIN_PRODUCT_ID=listGetAt(attributes.PRODUCT,1,"**")>

   <CFSET SEVIYE_1=getTree(MAIN_PRODUCT_ID,IS_VIRTUAL)>
   
    <ul  class="ui-list">               
        <CFSET I=0>
        <cfloop query="SEVIYE_1">            
            <CFIF SEVIYE_1.IS_VIRTUAL NEQ 1>
                <CFSET SV1_FIYATI=getprice(SEVIYE_1.PRODUCT_ID,SEVIYE_1.PRODUCT_UNIT_ID,attributes.PRICE_CAT)>
                <cfdump var="#SV1_FIYATI#">
            <CFELSE>
                <CFSET SV1_FIYATI.RECORDCOUNT=0>
            </CFIF>
            <CFSET "SEVIYE2_#I#"=getTree(SEVIYE_1.SIDO,SEVIYE_1.IS_VIRTUAL)>
            
            <li>
                <a href="javascript:void(0)">
                    <div class="ui-list-left">
                        <span class="" style="display: block;background: #ff0000a3;color: white;padding: 5px;border-radius: 5px;margin-right: 5px;">1</span>
                        <cfoutput>#SEVIYE_1.PRODUCT_NAME#--#SEVIYE_1.PRODUCT_ID#--#PRODUCT_UNIT_ID#</cfoutput>
                    </div>
                    <div class="ui-list-right ui-list-right-open">
                            <cf_ajax_list>
                                <thead><tr><th>Miktar</th><th>Fiyat</th><th>İndirim</th><th>Tutar</th></tr></thead>
                                <tbody><tr><td><div class="form-group"><input readonly type="text" id="AMOUNT_<CFOUTPUT>#PTID#</CFOUTPUT>" value="<cfoutput>#TLFORMAT(SEVIYE_1.AMOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input  type="text" id="PRICE_<CFOUTPUT>#PTID#</CFOUTPUT>"  onchange="this.value=commaSplit(filterNum(this.value))" value="<cfoutput>#TLFORMAT(SEVIYE_1.PRICE)#</cfoutput>"></div></td><td><div class="form-group"><input type="text" id="DISCOUNT_<CFOUTPUT>#PTID#</CFOUTPUT>"  value="<cfoutput>#TLFORMAT(SEVIYE_1.DISCOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input readonly type="text" id="P_TOTAL_<CFOUTPUT>#PTID#</CFOUTPUT>"  value="<cfoutput>#TLFORMAT(0)#</cfoutput>"></div></td></tr></tbody>
                            </cf_ajax_list>
                           <i class="fa fa-chevron-down"></i>
                    </div>
                </a>
                <cfif EVALUATE("SEVIYE2_#I#").recordcount gt 0>
                    <ul>
                        <CFTRY>
                        <CFSET J=0>
                        
                        <cfloop query="#EVALUATE("SEVIYE2_#I#")#">
                            <CFIF EVALUATE("SEVIYE2_#I#").IS_VIRTUAL NEQ 1>
                                <CFSET SV2_FIYATI=getprice(EVALUATE("SEVIYE2_#I#").PRODUCT_ID,EVALUATE("SEVIYE2_#I#").PRODUCT_UNIT_ID,attributes.PRICE_CAT)>
                                
                            <CFELSE>
                                <CFSET SV2_FIYATI.RECORDCOUNT=0>
                            </CFIF>
                          <cftry>
                            <CFSET "SEVIYE3_#J#"=getTree(EVALUATE("SEVIYE2_#I#").SIDO,EVALUATE("SEVIYE2_#I#").IS_VIRTUAL)>
                            <cfcatch>
                                <CFSET "SEVIYE3_#J#.RECORDCOUNT"=0>
                            </cfcatch>
                        </cftry>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <span class="" style="display: block;background: #005fffa3;color: white;padding: 5px;border-radius: 5px;margin-right: 5px;">2</span>
                                        <cfoutput>#EVALUATE("SEVIYE2_#I#").PRODUCT_NAME#</cfoutput>
                                    </div>
                                    <div class="ui-list-right ui-list-right-open">
                                        <cf_ajax_list>
                                            <thead><tr><th>Miktar</th><th>Fiyat</th><th>İndirim</th><th>Tutar</th></tr></thead>
                                            <tr><td><div class="form-group"><input readonly type="text" id="AMOUNT_<CFOUTPUT>#PTID#</CFOUTPUT>"  value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE2_#I#").AMOUNT)#</cfoutput>"></div></td>
                                                <td><div class="form-group"><input type="text" id="PRICE_<CFOUTPUT>#PTID#</CFOUTPUT>"  value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE2_#I#").PRICE)#</cfoutput>"></div></td>
                                                <td><div class="form-group"><input type="text" id="DISCOUNT_<CFOUTPUT>#PTID#</CFOUTPUT>"  value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE2_#I#").DISCOUNT)#</cfoutput>"></div></td>
                                                <td><div class="form-group"><input readonly Ğtype="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE2_#I#").AMOUNT)#</cfoutput>"></div></td></tr>
                                        </cf_ajax_list>
                                       <i class="fa fa-chevron-down"></i>
                                    </div>
                                </a>
                                <cfif EVALUATE("SEVIYE3_#J#").recordcount gt 0>
                                    <ul>
                                        <CFTRY> 
                                        <CFSET K=0>
                                       <cfloop query="#EVALUATE("SEVIYE3_#J#")#">
                                            <CFIF EVALUATE("SEVIYE3_#J#").IS_VIRTUAL NEQ 1>
                                                <CFSET SV3_FIYATI=getprice(EVALUATE("SEVIYE3_#J#").PRODUCT_ID,EVALUATE("SEVIYE3_#J#").PRODUCT_UNIT_ID,attributes.PRICE_CAT)>
                                                
                                            <CFELSE>
                                                <CFSET SV3_FIYATI.RECORDCOUNT=0>
                                            </CFIF>
                                            
                                            <cftry>
                                                <CFSET "SEVIYE4_#K#"=getTree(EVALUATE("SEVIYE3_#J#").SIDO,EVALUATE("SEVIYE3_#J#").IS_VIRTUAL)>
                                                <cfcatch>
                                                    <CFSET "SEVIYE4_#K#.RECORDCOUNT"=0>
                                                </cfcatch>
                                            </cftry>
                                            <li>
                                                <a href="javascript:void(0)">
                                                    <div class="ui-list-left">
                                                        <span class="" style="display: block;background: #ff00a0a3;color: white;padding: 5px;border-radius: 5px;margin-right: 5px;">3</span>
                                                        <cfoutput>#EVALUATE("SEVIYE3_#J#").PRODUCT_NAME#</cfoutput>
                                                    </div>
                                                    <div class="ui-list-right ui-list-right-open">
                                                        <cf_ajax_list>
                                                            <thead><tr><th>Miktar</th><th>Fiyat</th><th>İndirim</th><th>Tutar</th></tr></thead>
                                                            <tr><td><div class="form-group"><input readonly type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE3_#J#").AMOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE3_#J#").PRICE)#</cfoutput>"></div></td><td><div class="form-group"><input type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE3_#J#").DISCOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input readonly type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE3_#J#").AMOUNT)#</cfoutput>"></div></td></tr>
                                                        </cf_ajax_list>
                                                        <i class="fa fa-chevron-down"></i>
                                                    </div>
                                                </a>
                                                <cfif EVALUATE("SEVIYE4_#K#").recordcount gt 0>
                                                    <ul>
                                                        <cfloop query="#EVALUATE("SEVIYE4_#K#")#">
                                                            <CFIF EVALUATE("SEVIYE4_#K#").IS_VIRTUAL NEQ 1>
                                                                <CFSET "SV4_FIYATI_#K#"=getprice(EVALUATE("SEVIYE4_#J#").PRODUCT_ID,EVALUATE("SEVIYE4_#K#").PRODUCT_UNIT_ID,attributes.PRICE_CAT)>
                                                                
                                                            <CFELSE>
                                                                <CFSET "SV4_FIYATI_#K#.RECORDCOUNT"=0>
                                                            </CFIF>
                                                            <CFSET "GUNCEL_FIYAT4_#K#"=0>
                                                            <CFIF LEN(EVALUATE("SEVIYE4_#K#").PRICE) AND EVALUATE("SEVIYE4_#K#").PRICE NEQ 0>
                                                                <CFSET "GUNCEL_FIYAT4_#K#"=EVALUATE("SEVIYE4_#K#").PRICE>
                                                            <CFELSE>
                                                                <CFIF EVALUATE("SV4_FIYATI_#K#").RECORDCOUNT NEQ 0>
                                                                    <CFSET "GUNCEL_FIYAT4_#K#"=EVALUATE("SV4_FIYATI_#J#").PRICE>
                                                                </CFIF>

                                                            </CFIF>
                                                            <li>
                                                                <a href="javascript:void(0)">
                                                                    <div class="ui-list-left">
                                                                        <span class="" style="display: block;background: #ff930fa3;color: white;padding: 5px;border-radius: 5px;margin-right: 5px;">4</span>
                                                                        <cfoutput>#EVALUATE("SEVIYE4_#K#").PRODUCT_NAME#</cfoutput>
                                                                    </div>
                                                                    <div class="ui-list-right ui-list-right-open">
                                                                        <cf_ajax_list>
                                                                            <thead><tr><th>Miktar</th><th>Fiyat</th><th>İndirim</th><th>Tutar</th></tr></thead>
                                                                            <tr><td><div class="form-group"><input readonly type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE4_#k#").AMOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input type="text" value="<cfoutput>#TLFORMAT(evaluate("GUNCEL_FIYAT4_#J#"))#</cfoutput>"></div></td><td><div class="form-group"><input type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE4_#K#").DISCOUNT)#</cfoutput>"></div></td><td><div class="form-group"><input readonly type="text" value="<cfoutput>#TLFORMAT(EVALUATE("SEVIYE4_#k#").AMOUNT)#</cfoutput>"></div></td></tr>
                                                                        </cf_ajax_list>
                                                                        <i class="fa fa-chevron-down"></i>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                            <CFSET K=K+1>
                                                        </cfloop>
                                                    </ul>
                                                </cfif>
                                            </li>
                                            <CFSET J=J+1>
                                        </cfloop>
                                        <cfcatch></cfcatch>
                                    </CFTRY>
                                    
                                    </ul>
                                </cfif>
                            </li>
                            <CFSET I=I+1>
                        </cfloop>

                        <cfcatch></cfcatch>
                    </CFTRY>
                    </ul>
                </cfif>
            </li>
            
        </cfloop>
    </ul>
</cfif>
        <cffunction name="getTree">
    <cfargument name="STOCK_ID">
    <cfargument name="IS_VIRTUAL">
    <cfquery name="SEVIYE_2" datasource="#DSN3#">
        <cfif arguments.IS_VIRTUAL EQ 1>
            SELECT VPT_ID AS PTID , PT.PRODUCT_ID ,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS SIDO,PT.AMOUNT,ISNULL(PT.PRICE,0) PRICE,ISNULL(PT.DISCOUNT,0) DISCOUNT,PT.MONEY,CASE WHEN PT.IS_VIRTUAL =1 THEN ISNULL(VPT.PRODUCT_NAME,PT.DISPLAY_NAME) ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,PT.IS_VIRTUAL,0 AS PRODUCT_UNIT_ID FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS PT  --WHERE IS_VIRTUAL=1
            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.PRODUCT_ID
            LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VPT ON VPT.VIRTUAL_PRODUCT_ID=PT.PRODUCT_ID
            WHERE VP_ID=#ARGUMENTS.STOCK_ID#
        <CFELSE>
            SELECT PRODUCT_TREE_ID AS PTID, S.PRODUCT_ID,S.STOCK_ID SIDO ,AMOUNT,PRICE_PBS AS PRICE,DISCOUNT_PBS AS DISCOUNT ,OTHER_MONEY_PBS AS MONEY ,S.PRODUCT_NAME,0 AS IS_VIRTUAL,PRODUCT_UNIT_ID FROM workcube_metosan_1.PRODUCT_TREE AS PT INNER JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID WHERE PT.STOCK_ID=#arguments.STOCK_ID#
        </cfif>
    </cfquery>
    <cfreturn SEVIYE_2>
</cffunction>
<cffunction name="getprice">
    <cfargument name="PRODUCT_ID">
    <cfargument name="PRODUCT_UNIT_ID">
    <cfargument name="PRICE_CAT_ID">
    <cfquery name="get_jsq" datasource="#dsn3#">
        EXEC workcube_metosan_1.GET_PRICES_PBS #arguments.PRODUCT_ID#,#arguments.PRODUCT_UNIT_ID#,#arguments.PRICE_CAT_ID# --PRODUCT_ID,PRODUCT_UNIT_ID,PRICE_CAT_ID
    </cfquery>
    <cfreturn get_jsq>
</cffunction>


<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        


</cfform>

</cf_box>

<script src="/AddOns/Partner/Project/js/fiyat_gir.js"></script>
