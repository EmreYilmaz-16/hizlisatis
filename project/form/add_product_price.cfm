
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
    .ajax_list  > tfoot > tr > td >  input[type=text]{
        text-align:right
    }
    .ajax_list > thead > tr > th {
        text-align:right
    }
    table {
        width:100%
    }
    td table{
        margin-left :15px;
        padding-right:15px;
    }
    td .ajax_list{
        width:98%;
    }
     .ajax_list{
        width:100%
     }
     .ajax_list>tbody>tr>td{
        padding:0px
     }
     .satirNormal{
        width:7%
     }
</style>

<cfquery name="getMoney" datasource="#dsn#">
    SELECT 
 (SELECT RATE1 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
 SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
 (SELECT EFFECTIVE_SALE RATE2 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
 SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE2,
 SM.MONEY
 FROM workcube_metosan.SETUP_MONEY AS SM WHERE SM.PERIOD_ID=#session.ep.period_id#
 </cfquery>
 
 <script>
     var moneyArr=[
         <cfoutput query="getMoney">
             {
                 MONEY:"#MONEY#",
                 RATE1:"#RATE1#",
                 RATE2:"#RATE2#",
             },
         </cfoutput>
     ]
 </script>



<cf_box title="Ürün Fiyat Girişi">
<cfif isDefined("from_project") and attributes.from_project eq 1>
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
        <input type="hidden" name="project_id" id="project_id">
        <input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#session.ep.userid#</cfoutput>">
        
        <input type="hidden" name="is_submit" value="1">
    </div>
</cfform>
<cfelse>
    <cfset attributes.is_submit=1>
    <cfquery name="getProjectC" datasource="#dsn#">
    SELECT PROJECT_ID,COMPANY_ID,(SELECT PRICE_CAT FROM workcube_metosan.COMPANY_CREDIT WHERE COMPANY_ID=PRO_PROJECTS.COMPANY_ID) AS PRICE_CAT  FROM workcube_metosan.PRO_PROJECTS WHERE PROJECT_ID=#attributes.PROJECT_ID#       
    </cfquery>
<CFSET attributes.COMPANY_ID=getProjectC.COMPANY_ID>
<CFSET attributes.PRICE_CAT=getProjectC.PRICE_CAT>
<CFSET attributes.RECORD_EMP=session.ep.userid>

</cfif>


<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
    


    
<button type="button" onclick="FiyatlariGetir()">Standart Fiyatları Getir ve Hesapla</button>
<button type="button" onclick="FiyatlariHesapla()">Hesapla</button>
<button type="button" onclick="OpenPricesInte()">Geçmiş Fiyat Girişleri</button>
<button type="button" onclick="KaydetCanim()">Fiyat Girişini Kaydet</button>
<cfset IS_VIRTUAL=listGetAt(attributes.PRODUCT,2,"**")>
<cfset MAIN_PRODUCT_ID=listGetAt(attributes.PRODUCT,1,"**")>
<cfoutput>
<script>
        ProjectData=#replace(serializeJSON(attributes),"//","")#
</script>
</cfoutput>
   <CFSET SEVIYE_1=getTree(MAIN_PRODUCT_ID,IS_VIRTUAL)>
   <CFSET I=0>
   <cf_ajax_list id="BasketForm"><cfloop query="SEVIYE_1">
    
    
    <cfoutput>
    <thead>
        <tr>
            <th></th>
            <th style="text-align:left">Ürün</th>
            <th>Miktar</th>
            <th>Fiyat</th>
            <th>TL Fiyat</th>
            <th>İndirim</th>
            <th>Tutar</th>
        </tr>
    </thead>
       <tr upper_ptid="10000000" class="basket_row" pit_id="#SEVIYE_1.PTID#">
        <td style="width:2%">1</td>
            <td style="width:50%">#SEVIYE_1.PRODUCT_NAME#</td>
            <td class="satirNormal">
                <div class="form-group">
                    <input style="text-align:right;padding-right:3px" type="text" name="AMOUNT_#SEVIYE_1.PTID#" data-rowid="#SEVIYE_1.PTID#" value="#TLFORMAT(SEVIYE_1.AMOUNT)#">
                    <input type="hidden" name="PRODUCT_ID#SEVIYE_1.PTID#" value="#SEVIYE_1.PRODUCT_ID#">
                    <input type="hidden" name="IS_VIRTUAL#SEVIYE_1.PTID#" value="#SEVIYE_1.IS_VIRTUAL#">
                </div>
            </td>
            <td class="satirNormal">
                <div class="form-group">
                    <div class="input-group">
                    <input style="text-align:right;padding-right:3px" data-rowid="#SEVIYE_1.PTID#" type="text" name="PRICE_#SEVIYE_1.PTID#" value=" #TLFORMAT(SEVIYE_1.PRICE)#">
                    <span name="OTHER_MONEY_#SEVIYE_1.PTID#" class="input-group-addon">#SEVIYE_1.MONEY#</span>
                </div>
                </div>
            </td>
            <td class="satirNormal">
                <div class="form-group">
                    <input style="text-align:right;padding-right:3px" type="text" name="PRICETL_#SEVIYE_1.PTID#" value="#TLFORMAT(SEVIYE_1.PRICE)#">
                </div>
            </td>
            <td class="satirNormal">
                <div class="form-group">
                    <input style="text-align:right;padding-right:3px" type="text" data-rowid="#SEVIYE_1.PTID#" name="DISCOUNT_#SEVIYE_1.PTID#" value="#TLFORMAT(SEVIYE_1.DISCOUNT)#">
                </div>
            </td>
            <td class="satirNormal">
                <CFSET TX= (SEVIYE_1.AMOUNT*SEVIYE_1.PRICE)>
                <CFSET DV=(TX*SEVIYE_1.DISCOUNT)/100>
                <CFSET TT=TX-DV>
                <div class="form-group">
                    <input style="text-align:right;padding-right:3px" type="text" name="TOTAL_#SEVIYE_1.PTID#" value="#TLFORMAT(TT)#">
                </div>
            </td>
        </tr>
        <CFSET "SEVIYE_2_#I#"=getTree(SEVIYE_1.SIDO,SEVIYE_1.IS_VIRTUAL)>
        <CFIF evaluate("SEVIYE_2_#I#").recordcount gt 0>
            <CFSET J=0>
            <tr>
                <td colspan="7">
                       <cf_ajax_list>
                        <cfloop query="#evaluate("SEVIYE_2_#I#")#">
                            <tr upper_ptid="#SEVIYE_1.PTID#" class="basket_row" pit_id="#evaluate("SEVIYE_2_#I#").PTID#" >
                                <td style="width:2%">2</td>
                                    <td style="width:50%">#evaluate("SEVIYE_2_#I#").PRODUCT_NAME#</td>
                                    <td class="satirNormal">
                                        <div class="form-group">
                                            <input style="text-align:right;padding-right:3px" type="text" name="AMOUNT_#evaluate("SEVIYE_2_#I#").PTID#" data-rowid="#evaluate("SEVIYE_2_#I#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_2_#I#").AMOUNT)#">
                                            <input type="hidden" name="PRODUCT_ID#evaluate("SEVIYE_2_#I#").PTID#" value="#evaluate("SEVIYE_2_#I#").PRODUCT_ID#">
                                            <input type="hidden" name="IS_VIRTUAL#evaluate("SEVIYE_2_#I#").PTID#" value="#evaluate("SEVIYE_2_#I#").IS_VIRTUAL#">
                                        </div>
                                    </td>
                                    <td class="satirNormal">
                                        <div class="form-group">
                                            <div class="input-group">
                                            <input style="text-align:right;padding-right:3px" type="text" name="PRICE_#evaluate("SEVIYE_2_#I#").PTID#" data-rowid="#evaluate("SEVIYE_2_#I#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_2_#I#").PRICE)#">
                                            <span name="OTHER_MONEY_#evaluate("SEVIYE_2_#I#").PTID#" class="input-group-addon">#evaluate("SEVIYE_2_#I#").MONEY#</span>
                                        </div> </div>
                                    </td>
                                    <td class="satirNormal">
                                        <div class="form-group">
                                            <div class="input-group">
                                            <input style="text-align:right;padding-right:3px" type="text" name="PRICETL_#evaluate("SEVIYE_2_#I#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_2_#I#").PRICE)#">
                                            
                                            </div>
                                        </div>
                                    </td>
                                    <td class="satirNormal">
                                        <div class="form-group">
                                            <input style="text-align:right;padding-right:3px" type="text" data-rowid="#evaluate("SEVIYE_2_#I#").PTID#" name="DISCOUNT_#evaluate("SEVIYE_2_#I#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_2_#I#").DISCOUNT)#">
                                        </div>
                                    </td>
                                    <td class="satirNormal">
                                        <CFSET TX= (evaluate("SEVIYE_2_#I#").AMOUNT*evaluate("SEVIYE_2_#I#").PRICE)>
                                        <CFSET DV=(TX*evaluate("SEVIYE_2_#I#").DISCOUNT)/100>
                                        <CFSET TT=TX-DV>
                                        <div class="form-group">
                                            <input style="text-align:right;padding-right:3px" type="text" name="TOTAL_#evaluate("SEVIYE_2_#I#").PTID#" value="#TLFORMAT(TT)#">
                                        </div>
                                    </td>
                                </tr>
                                <CFSET "SEVIYE_3_#J#"=getTree(evaluate("SEVIYE_2_#I#").SIDO,evaluate("SEVIYE_2_#I#").IS_VIRTUAL)>
                                    <cfif evaluate("SEVIYE_3_#J#").recordCount gt 0>
                                        <CFSET K=0>
                                        <tr >
                                            <td colspan="7">
                                                <cf_ajax_list>
                                                    <cfloop query="#evaluate("SEVIYE_3_#J#")#">
                                                        <tr upper_ptid="#evaluate("SEVIYE_2_#I#").PTID#" class="basket_row" pit_id="#evaluate("SEVIYE_3_#J#").PTID#">
                                                            <td style="width:2%">3</td>
                                                                <td style="width:50%">#evaluate("SEVIYE_3_#J#").PRODUCT_NAME#</td>
                                                                <td class="satirNormal">
                                                                    <div class="form-group">
                                                                        <input style="text-align:right;padding-right:3px" type="text" name="AMOUNT_#evaluate("SEVIYE_3_#J#").PTID#" data-rowid="#evaluate("SEVIYE_3_#J#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_3_#J#").AMOUNT)#">
                                                                        <input type="hidden" name="PRODUCT_ID#evaluate("SEVIYE_3_#J#").PTID#" value="#evaluate("SEVIYE_3_#J#").PRODUCT_ID#">
                                                                        <input type="hidden" name="IS_VIRTUAL#evaluate("SEVIYE_3_#J#").PTID#" value="#evaluate("SEVIYE_3_#J#").IS_VIRTUAL#">
                                                                    </div>
                                                                </td>
                                                                <td class="satirNormal">
                                                                    <div class="form-group">
                                                                        <div class="input-group">
                                                                        <input style="text-align:right;padding-right:3px" type="text" name="PRICE_#evaluate("SEVIYE_3_#J#").PTID#" data-rowid="#evaluate("SEVIYE_3_#J#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_3_#J#").PRICE)#">
                                                                        <span name="OTHER_MONEY_#evaluate("SEVIYE_3_#J#").PTID#" class="input-group-addon">#evaluate("SEVIYE_3_#J#").MONEY#</span>
                                                                        <div>
                                                                    </div>
                                                                </td>
                                                                <td class="satirNormal">
                                                                    <div class="form-group">
                                                                        
                                                                        <input style="text-align:right;padding-right:3px" type="text" name="PRICETL_#evaluate("SEVIYE_3_#J#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_3_#J#").PRICE)#">
                                                                        
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td class="satirNormal">
                                                                    <div class="form-group">
                                                                        <input style="text-align:right;padding-right:3px" data-rowid="#evaluate("SEVIYE_3_#J#").PTID#" type="text" name="DISCOUNT_#evaluate("SEVIYE_3_#J#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_3_#J#").DISCOUNT)#">
                                                                    </div>
                                                                </td>
                                                                <td class="satirNormal">
                                                                    <CFSET TX= (evaluate("SEVIYE_3_#J#").AMOUNT*evaluate("SEVIYE_3_#J#").PRICE)>
                                                                    <CFSET DV=(TX*evaluate("SEVIYE_3_#J#").DISCOUNT)/100>
                                                                    <CFSET TT=TX-DV>
                                                                    <div class="form-group">
                                                                        <input style="text-align:right;padding-right:3px" type="text" name="TOTAL_#evaluate("SEVIYE_3_#J#").PTID#" value="#TLFORMAT(TT)#">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                            
                                                            <CFSET "SEVIYE_4_#K#"=getTree(evaluate("SEVIYE_3_#J#").SIDO,evaluate("SEVIYE_3_#J#").IS_VIRTUAL)>
                                                            <CFIF evaluate("SEVIYE_4_#K#").RecordCount gt 0>
                                                                <tr >
                                                                    <td colspan="7">
                                                                        <cf_ajax_list>
                                                                            <cfloop query="#evaluate("SEVIYE_4_#K#")#">
                                                                                <tr upper_ptid="#evaluate("SEVIYE_3_#J#").PTID#" class="basket_row" pit_id="#evaluate("SEVIYE_4_#K#").PTID#">
                                                                                    <td style="width:2%">4</td>
                                                                                        <td style="width:50%">#evaluate("SEVIYE_4_#K#").PRODUCT_NAME#</td>
                                                                                        <td class="satirNormal">
                                                                                            <div class="form-group">
                                                                                                <input style="text-align:right;padding-right:3px" type="text" name="AMOUNT_#evaluate("SEVIYE_4_#K#").PTID#" data-rowid="#evaluate("SEVIYE_4_#K#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_4_#K#").AMOUNT)#">
                                                                                                <input type="hidden" name="PRODUCT_ID#evaluate("SEVIYE_4_#K#").PTID#" value="#evaluate("SEVIYE_4_#K#").PRODUCT_ID#">
                                                                                                <input type="hidden" name="IS_VIRTUAL#evaluate("SEVIYE_4_#K#").PTID#" value="#evaluate("SEVIYE_4_#K#").IS_VIRTUAL#">
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="satirNormal">
                                                                                            <div class="form-group">
                                                                                                <div class="input-group">
                                                                                                <input style="text-align:right;padding-right:3px" type="text" name="PRICE_#evaluate("SEVIYE_4_#K#").PTID#" data-rowid="#evaluate("SEVIYE_4_#K#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_4_#K#").PRICE)#">
                                                                                                <span name="OTHER_MONEY_#evaluate("SEVIYE_4_#K#").PTID#" class="input-group-addon">#evaluate("SEVIYE_4_#K#").MONEY#</span>
                                                                                            </div>
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="satirNormal">
                                                                                            <div class="form-group">
                                                                                                <input style="text-align:right;padding-right:3px" type="text" name="PRICETL_#evaluate("SEVIYE_4_#K#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_4_#K#").PRICE)#">
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="satirNormal">
                                                                                            <div class="form-group">
                                                                                                <input style="text-align:right;padding-right:3px" type="text" data-rowid="#evaluate("SEVIYE_4_#K#").PTID#" name="DISCOUNT_#evaluate("SEVIYE_4_#K#").PTID#" value="#TLFORMAT(evaluate("SEVIYE_4_#K#").DISCOUNT)#">
                                                                                            </div>
                                                                                        </td>
                                                                                        <td class="satirNormal">
                                                                                            <CFSET TX= (evaluate("SEVIYE_4_#K#").AMOUNT*evaluate("SEVIYE_4_#K#").PRICE)>
                                                                                            <CFSET DV=(TX*evaluate("SEVIYE_4_#K#").DISCOUNT)/100>
                                                                                            <CFSET TT=TX-DV>
                                                                                            <div class="form-group">
                                                                                                <input style="text-align:right;padding-right:3px" type="text" name="TOTAL_#evaluate("SEVIYE_4_#K#").PTID#" value="#TLFORMAT(TT)#">
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    
                                                                            </cfloop>
                                                                        </cf_ajax_list>
                                                                    </td>
                                                                </tr>
                                                            </CFIF>
                                                            <cfset K=K+1>
                                                    </cfloop>
                                                </cf_ajax_list>
                                            </td>
                                        </tr>
                                    </cfif>
                                <CFSET J=J+1>
                        </cfloop>
                       </cf_ajax_list>
                </td>
            </tr>
        </CFIF>
        <!---<cfloop query="#evaluate("SEVIYE_2_#I#")#">
            <tr>
                <td colspan="4">

                </td>
            </tr>
        </cfloop>--->
        <CFSET I=I+1>
        

    
    
</cfoutput></cfloop>
<tfoot>
    <tr>
        <td colspan="6">Toplam</td>
        <td><input type="text" value="350.0000"></td>
    </tr>
</tfoot>
</cf_ajax_list>
</cfif>
        <cffunction name="getTree">
    <cfargument name="STOCK_ID">
    <cfargument name="IS_VIRTUAL">
    <cfquery name="SEVIYE_2" datasource="#DSN3#">
        <cfif arguments.IS_VIRTUAL EQ 1>
            SELECT VPT_ID AS PTID , PT.PRODUCT_ID ,CASE WHEN PT.IS_VIRTUAL =1 THEN VPT.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS SIDO,PT.AMOUNT,ISNULL(PT.PRICE,0) PRICE,ISNULL(PT.DISCOUNT,0) DISCOUNT,ISNULL(PT.MONEY,'TL') MONEY,CASE WHEN PT.IS_VIRTUAL =1 THEN ISNULL(VPT.PRODUCT_NAME,PT.DISPLAY_NAME) ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,PT.IS_VIRTUAL,0 AS PRODUCT_UNIT_ID FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS PT  --WHERE IS_VIRTUAL=1
            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.PRODUCT_ID
            LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VPT ON VPT.VIRTUAL_PRODUCT_ID=PT.PRODUCT_ID
            WHERE VP_ID=#ARGUMENTS.STOCK_ID#
        <CFELSE>
            SELECT PRODUCT_TREE_ID AS PTID, S.PRODUCT_ID,S.STOCK_ID SIDO ,ISNULL(AMOUNT,0) AMOUNT,ISNULL(PRICE_PBS,0) AS PRICE,ISNULL(DISCOUNT_PBS,0) AS DISCOUNT ,ISNULL(OTHER_MONEY_PBS,'TL') AS MONEY ,S.PRODUCT_NAME,0 AS IS_VIRTUAL,PRODUCT_UNIT_ID FROM workcube_metosan_1.PRODUCT_TREE AS PT INNER JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID WHERE PT.STOCK_ID=#arguments.STOCK_ID#
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

<cffunction name="fiyatKarari">
    <cfargument name="FIYAT1" hint="AGAC">
    <cfargument name="PARAB1">
    <cfargument name="FIYAT2" hint="LİSTE FİYATI">
    <cfargument name="PARAB2">
    <cfset RETURN_VALUE.FIYAT=0>
    <CFSET RETURN_VALUE.OTHER_MONEY="TL">
    <CFIF ARGUMENTS.FIYAT1 NEQ 0>
        <CFSET RETURN_VALUE.FIYAT=arguments.FIYAT1>
        <CFSET RETURN_VALUE.OTHER_MONEY=arguments.PARAB1>
    <cfelseif ARGUMENTS.FIYAT2 NEQ 0>
        <CFSET RETURN_VALUE.FIYAT=arguments.FIYAT2>
        <CFSET RETURN_VALUE.OTHER_MONEY=arguments.PARAB2>
    </CFIF>


</cffunction>


<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        


</cfform>

</cf_box>

<script src="/AddOns/Partner/Project/js/fiyat_gir.js"></script>
