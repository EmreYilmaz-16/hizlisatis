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
    <div id="sonuc_div">
        <table>
            <tr>
                <td>
                    <div class="form-group">
                        <label>Ürün Adı</label>
                        <input type="text" name="PRODUCT_NAME" id="PRODUCT_NAME">
                    </div>                    
                </td>
                <td>
                    <div class="form-group">
                        <label>Birim</label>
                        <select name="MAIN_UNIT" id="MAIN_UNIT">
                            <cfoutput query="getUnits">
                                <option value="#UNIT#">#UNIT#</option>
                            </cfoutput>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="form-group">
                        <label>Açıklama</label>
                        <textarea name="PRODUCT_DESCRIPTION" id="PRODUCT_DESCRIPTION"></textarea>
                    </div>                    
                </td>
            </tr>
        </table>
    </div>
    <button type="button" class="btn btn-warning" onclick="saveProduct()">Sanal Ürün Kaydet</button>
    <button type="button" class="btn btn-success" onclick="saveVirtualOfferProduct()">Ürün Kaydet</button>
</cfform>
</cf_box>

