<style>
    .btn i {
 margin:0 !important;
}
</style>
<cfif isDefined("attributes.isfrom_price_offer")>
    <cfquery name="getData" datasource="#dsn3#">
        SELECT *
    FROM 
        #DSN3#.VirmanProduct AS VP 
        LEFT JOIN #DSN3#.PBS_OFFER_ROW AS POR ON POR.UNIQUE_RELATION_ID = '#getPor.UNIQUE_RELATION_ID#'
    WHERE VP.VIRMAN_ID = #getPor.CONVERTED_STOCK_ID#
    </cfquery>

<cfelse>
<cfquery name="getData" datasource="#dsn3#">
    SELECT *
FROM #DSN3#.VIRTUAL_PRODUCTION_ORDERS AS VPO
LEFT JOIN #DSN3#.PBS_OFFER_ROW AS POR ON POR.UNIQUE_RELATION_ID = VPO.UNIQUE_RELATION_ID
LEFT JOIN #DSN3#.VirmanProduct AS VP ON VP.VIRMAN_ID = POR.CONVERTED_STOCK_ID
WHERE VPO.V_P_ORDER_ID = #attributes.VP_ORDER_ID#
</cfquery>
</cfif>
<cfset fr_data=deserializeJSON(replace(getData.JSON_DATA,"//",""))>
<cfquery name="getC" datasource="#dsn3#">
    SELECT * FROM PRODUCT_CAT WHERE HIERARCHY='#fr_data.HIERARCHY#'
</cfquery>
<cfoutput>
    <script>
       var BozulacakArr=#Replace(SerializeJSON(fr_data.BozulacakUrunler),'//','')#
       var CikanArr=#Replace(SerializeJSON(fr_data.CikanUrunler),'//','')#
       var GirenArr=#Replace(SerializeJSON(fr_data.GirenUrunler),'//','')#
       var OlusacakUrun=#Replace(SerializeJSON(fr_data.OlusacakUrun),'//','')# 
    </script>
</cfoutput>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.PRICE_CATID" default="">
<cfoutput>
<input type="hidden" name="virman_id" id="virman_id" value="#getData.CONVERTED_STOCK_ID#">
</cfoutput>
<cfset plkcddd=0>
<cfinclude template="/AddOns/Partner/satis/includes/virtual_offer_parameters.cfm">
<cf_box title="">
    <cfform name="search_product">
    <div style="display:flex">
    <div style="width:30%;">
        <cf_box title="Oluşacak Ürün" collapsable="0" resize="0">
            <div style="height:30vh">
                
                <div style="display: flex; margin-top: 10px; margin-right: 10px; justify-content: flex-end;">
                    <button <cfif isDefined("hide_buttons") and hide_buttons eq 1>style="display:none"</cfif>  type="button" onclick="OpenBasketProducts(0,0)"  class="btn btn-success">+</button>
                                            
                </div>
                <table class="table" style="">
                    <tbody><tr>
                        <td>Ürün Adı</td>
                        <td>
                            <div class="form-group">
                                <input type="text" style="font-size: 15pt !important;color:green !important" onchange="SetUrunAdi(this)"  name="NamePumpa" id="NamePumpa" <cfif isDefined("hide_buttons") and hide_buttons eq 1>readonly</cfif>>
                                <input type="hidden" name="pidPumpa" id="pidPumpa" value="<cfoutput>#fr_data.OlusacakUrun.PRODUCT_ID#</cfoutput>">
                                <input type="hidden" name="SidPumpa" id="SidPumpa" value="<cfoutput>#fr_data.OlusacakUrun.STOCK_ID#</cfoutput>">
                                <input type="hidden" name="isVirtualPumpa" id="isVirtualPumpa" value="<cfoutput>#fr_data.OlusacakUrun.IS_VIRTUAL#</cfoutput>">
                                <input type="hidden" name="PricePumpa" id="PricePumpa" value="<cfoutput>#fr_data.OlusacakUrun.PRICE#</cfoutput>">
                                <input type="hidden" name="DiscountPumpa" id="DiscountPumpa" value="<cfoutput>#fr_data.OlusacakUrun.DISCOUNT#</cfoutput>">
                                <input type="hidden" name="is_rotation" id="is_rotation" value="<cfoutput>#fr_data.IsRotate#</cfoutput>">
                                <input type="hidden" name="isfrom_price_offer" id="isfrom_price_offer" value="<cfif isdefined("attributes.isfrom_price_offer")>1<cfelse>0</cfif>">
                                <input type="hidden" name="uniqRelationId" id="uniqRelationId" value="<cfoutput>#getData.UNIQUE_RELATION_ID#</cfoutput>">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Açıklama
                        </td>
                    </tr>
                        <tr>
                            <td colspan="2">
                                <div class="form-group">
                                <textarea onchange="ChangeDesc(this)" name="AciklamaPUMPA" id="AciklamaPUMPA"><cfoutput>#fr_data.OlusacakUrun.DESCRIPTION#</cfoutput></textarea>
                            </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="form-group" id="item-cat_id">
                                    <label>Kategori </label>
                                    <div class="input-group">
        <cfoutput>                                <input type="hidden" name="Pumpa_cat_id" id="Pumpa_cat_id" value="#getC.PRODUCT_CATID#">
                                        <input type="hidden" name="Pumpa_cat" id="Pumpa_cat" value="#getC.HIERARCHY#">
                                        <input name="Pumpa_category_name" type="text" id="Pumpa_category_name" onfocus="AutoComplete_Create('Pumpa_category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','Pumpa_cat_id,Pumpa_cat','','3','200','','1');" value="#getC.PRODUCT_CAT#" autocomplete="off"><div id="category_name_div_2" name="category_name_div_2" class="completeListbox" autocomplete="on" style="width: 463px; max-height: 150px; overflow: auto; position: absolute; left: 487.5px; top: 145px; z-index: 159; display: none;"></div>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.Pumpa_cat_id&field_code=search_product.Pumpa_cat&field_name=search_product.Pumpa_category_name');"></span>
                                    </cfoutput>
                                    </div>

                                </div>
                            </td>                         
                        </tr>
                            <tr>
                                <td>
                                    <div class="form-group">
                                        <div class="checkbox checbox-switch">
                                            <label>
                                                <input type="checkbox" name="" checked="checked">
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                </tbody></table>
                <div style=" display: flex;bottom: 0px;position: absolute;margin-bottom: 10px;width: 100%;justify-content: flex-end;<cfif isDefined('hide_buttons') and hide_buttons eq 1>display:none</cfif>">
                <button type="button" style="margin-inline-end: auto;" class="btn btn-secondary" onclick="changeRotation(this)" id="btnRotate">Yön Değiştir</button>        
                <button type="button" class="btn btn-warning" onclick="Temizle()">Temizle</button>        
                <button type="button" style="margin-right:15px" class="btn btn-success" onclick="SaveForPump()">Kaydet</button>;
            </div>
                <!--- TODO: Ürün Gerçekse Direk Pompa Tablosuna Veri Atılacak Değilse Önce Ürün Oluştur Pompa Tablosuna Veri At----->
            </div>
        </cf_box>
    </div>
    <div style="width:68%;margin-left:2%">
        <cf_box title="Bozulacak Ürün(ler)" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_1">
                    <thead>
                        <tr>
                            <th>
                                Ürün Kodu 
                            </th>
                            <th>
                                Ürün Adı 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button  onclick="OpenBasketProducts(1,0)" <cfif isDefined("hide_buttons") and hide_buttons eq 1>style="display:none"</cfif> type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
</div>
<hr>
<div style="display:flex">
    <div style="width:50%;">
        <cf_box title="Artan Ürünler (Depoya Giren)" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_2">
                    <thead>
                        <tr>
                            <th>
                                Ürün Kodu 
                            </th>
                            <th>
                                Ürün Adı 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button onclick="OpenBasketProducts(2,0)" <cfif isDefined("hide_buttons") and hide_buttons eq 1>style="display:none"</cfif> type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
    <div style="width:50%;margin-left:2%">
        <cf_box title="Kullanılan Ürünler (Depodan Çıkan)" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_3">
                    <thead>
                        <tr>
                            <th>
                                Ürün Kodu 
                            </th>
                            <th>
                                Ürün Adı 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button onclick="OpenBasketProducts(3,0)" <cfif isDefined("hide_buttons") and hide_buttons eq 1>style="display:none"</cfif> type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>

            </div>
        </cf_box>
    </div>
</div>
</cfform>
<script src="/AddOns/Partner/production/js/make_pump.js"></script>
</cf_box>
