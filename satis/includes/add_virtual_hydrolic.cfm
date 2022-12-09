<style>
        .prtMoneyBox{
        text-align:right !important;
        padding:0 !important;
    }
</style>
<script>
    var hydRowCount = 0;
</script>
<cf_box title="Make Hydrolic" scroll="1" collapsable="1" resize="1" popup_box="1">
    
    <div class="form-group">
        <input type="text" onkeyup="findHydrolic(event,this)"  name="pp_barcode" id="pp_barcode" onkeyup="">
    </div>
    <cfform name="HydrolicForm">
        <cfoutput><input type="hidden" name="dsn3" value="#dsn3#"></cfoutput>
        <div class="form-group">
            <label>Uretim</label>
            <input type="checkbox" name="IsProduction" checked value="1">
        </div>
        <div style="height:50vh;overflow-y: scroll;">
            <cf_big_list id="tblBaskHyd">
            <tr>
                <th></th>
                <th>Ürün</th>
                <th>Miktar</th>
                <th>Fiyat</th>
                <th>Doviz</th>
                <th>Doviz T</th>
                <th>Tutar</th>
            </tr>
            </cf_big_list>
        </div>
        <input type="hidden" name="hydRwc" id="hydRwc" value="">
        <input type="hidden" name="hydProductName" id="hydProductName" value="" onchange="">
        <div style="display:flex">
            <div class="form-group" style="margin-right:10px">
                <label>Marj</label>
                <input type="text" id="marjHyd" name="marjHyd" onchange="CalculateHydSub()" value="<cfoutput>#tlformat(0)#</cfoutput>" style="text-align:right;padding:0" >
            </div>
            <div class="form-group">
                <label>Toplam</label>
                <input type="text" id="hydSubTotal" name="hydSubTotal" style="text-align:right;padding:0" value="<cfoutput>#tlformat(0)#</cfoutput>">
            </div>
        </div>
        <button type="button" onclick="saveVirtualHydrolic('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-primary">Sanal Ürün Kaydet</button>
        <button type="button" class="btn btn-success">Ürün Kaydet</button>
        <button type="button" class="btn btn-danger">Kapat</button>
    </cfform>
</cf_box>