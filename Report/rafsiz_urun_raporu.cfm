<cfparam name="attributes.report_id" default="0">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.display_cost" default="">

<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=det&report_id=#attributes.report_id#" name="rapor">
    <table><cfoutput>
        <tr>
            <td>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"> Kategori </label>
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="product_code" id="product_code" value="#attributes.product_code#">
                            <input type="text" name="product_cat" id="product_cat" style="width:135px;" value="#attributes.product_cat#" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_code','','3','200');" autocomplete="off"><div id="product_cat_div_2" name="product_cat_div_2" class="completeListbox" autocomplete="on" style="width: 458px; max-height: 150px; overflow: auto; position: absolute; left: 25px; top: 113px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.product_code&field_name=rapor.product_cat&keyword='+encodeURIComponent(document.rapor.product_cat.value));"></span>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label class="col col-12 col-xs-12"> Marka </label>
                    <div class="col col-12">
                        <div class="input-group">
                                
                                <input type="hidden" name="brand_id" id="brand_id" value="#attributes.brand_id#">
                                <input type="text" name="brand_name" id="brand_name" style="width:135px;" value="#attributes.brand_name#" maxlength="255" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','135');" autocomplete="off"><div id="brand_name_div_2" name="brand_name_div_2" class="completeListbox" autocomplete="on" style="width: 458px; max-height: 150px; overflow: auto; position: absolute; left: 25px; top: 349px; z-index: 159; display: none;"></div>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_product_brands&brand_id=rapor.brand_id&brand_name=rapor.brand_name&keyword='+encodeURIComponent(document.rapor.brand_name.value),'small');"></span>
                            
                        </div>	
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group">										
                    <label> Yalnızca Stoğu Olanlar GElsin 
                        <input type="checkbox" name="display_cost" id="display_cost" <cfif attributes.display_cost eq 1>checked="true"</cfif> value="1">												
                    </label>																							
                </div>
            </td>
            <td>
                <input type="hidden" name="is_submit">
                <input type="submit">
            </td>
        </tr></cfoutput>
    </table>
</cfform>

<cfquery name="Products" datasource="#dsn3#">
    SELECT * FROM workcube_metosan_1.STOCKS AS S 
	LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
	<cfif attributes.display_cost eq 1>
    LEFT JOIN (
	SELECT SUM(STOCK_IN-STOCK_OUT) AS BKY ,STOCK_ID,STORE,STORE_LOCATION FROM workcube_metosan_2023_1.STOCKS_ROW GROUP BY STOCK_ID,STORE,STORE_LOCATION
	) AS SR  ON SR.STOCK_ID=S.STOCK_ID</cfif>
	WHERE PPR.PRODUCT_PLACE_ID IS NULL <cfif attributes.display_cost eq 1> AND SR.BKY>0</cfif> 
    <cfif len(attributes.product_cat)>
        AND S.PRODUCT_CODE LIKE '%#attributes.product_code#%'
    </cfif>
    <cfif len(attributes.product_cat)>
        AND S.BRAND_ID =#attributes.brand_id#
    </cfif>
</cfquery>