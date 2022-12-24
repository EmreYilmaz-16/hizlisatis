<cfquery name="getProduct" datasource="#dsn3#">
    select * from VIRTUAL_PRODUCTS_PRT WHERE  VIRTUAL_PRODUCT_ID=#attributes.id#
</cfquery>
<style>
    .prtMoneyBox{
    text-align:right !important;
    padding:0 !important;
}
</style>
<script>
var hydRowCount = 0;
</script>
<cf_box title="Sanal Teklif Ürünü" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfquery name="getUnits" datasource="#dsn#">
    select UNIT_ID,UNIT,UNIT_CODE,UNECE_NAME from SETUP_UNIT
</cfquery>
<cfform name="OfferProductForm">
    <cfoutput>
    <input type="hidden" name="PRODUCT_CAT" id="PRODUCT_CAT" readonly value="">
    <input type="hidden" name="PRODUCT_CATID" id="PRODUCT_CATID" value="#getProduct.PRODUCT_CATID#">
    <input type="hidden" name="HIEARCHY" id="HIEARCHY" value="">
    <input type="hidden" name="vp_id" id="vp_id" value="#attributes.id#">
    <input type="hidden" name="row_id" id="row_id" value="#attributes.row_id#">
</cfoutput>
<div id="sonuc_div">
    <table>
        <tr>
            <td>
                <div class="form-group">
                    <label>Ürün Adı</label>
                    <input type="text" name="PRODUCT_NAME" id="PRODUCT_NAME" value="<cfoutput>#getProduct.PRODUCT_NAME#</cfoutput>">
                </div>                    
            </td>
            <td>
                <div class="form-group">
                    <label>Birim</label>
                    <select name="MAIN_UNIT" id="MAIN_UNIT">
                        <cfoutput query="getUnits">
                            <option <cfif getProduct.PRODUCT_UNIT eq UNIT>selected</cfif> value="#UNIT#">#UNIT#</option>
                        </cfoutput>
                    </select>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="form-group">
                    <label>Açıklama</label>
                    <textarea name="PRODUCT_DESCRIPTION" id="PRODUCT_DESCRIPTION"><cfoutput>#getProduct.PRODUCT_NAME#</cfoutput></textarea>
                </div>                    
            </td>
        </tr>
    </table>
</div>
<button type="button" class="btn btn-warning" onclick="UpdateVirtualOfferProduct(<cfoutput>'#attributes.modal_id#'</cfoutput>)">Sanal Ürün Kaydet</button>
<button type="button" class="btn btn-success" onclick="saveProduct(<cfoutput>'#attributes.modal_id#'</cfoutput>)">Ürün Kaydet</button>
</cfform>
</cf_box>

