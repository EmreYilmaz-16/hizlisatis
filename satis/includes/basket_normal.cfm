
<div >


</div>
<div style="clear:both"></div>

<cfquery name="getMoney" datasource="#dsn#">
    SELECT MONEY,RATE1, EFFECTIVE_SALE AS RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
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
<cfoutput query="getMoney">
    <input type="hidden" id="hidden_rd_money_#CurrentRow#" name="hidden_rd_money_#CurrentRow#" value="#MONEY#">
    <input type="hidden" id="txt_rate1_#CurrentRow#" name="txt_rate1_#CurrentRow#" value="#RATE1#">
    <input type="hidden" id="txt_rate2_#CurrentRow#" name="txt_rate2_#CurrentRow#" value="#RATE2#">
</cfoutput>
<div id="basketArea">
<cf_ajax_list>
    <thead>
        <tr style="position: sticky;top: 0;z-index: 1;background: white;">
            <th>#</th>            
            <th></th>
            <th>Stok Kodu
                <input type="text" onkeyup="searchCode(this,event)" class="ui-form" placeholder="search">
            </th>       
            <th>Ürün Adı<input type="text" id="filter1" onkeyup="searchName(this,event)" class="ui-form" placeholder="search"></th>
            <th>Marka</th>
            <th>Depo</th>
            <th>Aşama</th>
            <th style="text-align:right">Miktar</th>
            
            <th>Birim</th>
            <th>Döviz</th>
            <th style="text-align:right">Döviz Fiyat</th>            
            <th style="text-align:right">Fiyat</th>
            <th style="text-align:right">İndirim(%)</th>
            <th style="text-align:right">Satır Net Tutar</th>
            <th>Malzeme Adı</th>
            <th>Ölçü</th>
            <th>Teslim Tarihi</th>
        </tr>
    </thead>
    <tbody id="tbl_basket">
    </tbody>
  <tfoot>
    <tr style="position: sticky;bottom: 0;background: white;z-index: 1;">
        <th colspan="12">
            <table>
                <tr>
                    <td colspan="2">
                        <div style="display:flex">
                        <div class="form-group" style="margin-right: 5px;border-right: 1px solid #ccc;padding-right: 5px;">
                            
                        <input type="checkbox" value="1" name="is_snl" checked id="snl_teklif" required onclick="snl_teklif_chek(this)">
                        <label style="display: inline;">Sanal Teklif</label>
                        </div>
                       
                        <div class="form-group" style="margin-right: 5px;border-right: 1px solid #ccc;padding-right: 5px;">            
                        <input type="checkbox" value="2" name="is_siparis" id="siparis" onclick="siparis_check(this)">
                        <label style="display: inline;">Sipariş</label>
                        </div>
                        
                        <div class="form-group" style="margin-right: 5px;border-right: 1px solid #ccc;padding-right: 5px;">       
                            
                        <input style="display:none" type="checkbox" value="3" name="is_sevkiyat" id="sevkiyat" readonly  onclick="isChCntPbs(this)">
                        <label style="display:none !important;">Hazırlama</label>
                        </div>
                        <div class="form-group" id="sales_type_m" style="display:none">
                            
                            <input style="display:none;" type="checkbox" value="4" name="sales_type" readonly id="sales_type_1" >
                            <label style="display:none !important;">Sevkiyat</label>
                            </div>
                         
                    </div>
                    </td>
                </tr>
             </table>
        </th>
        <th>İndirim</th>
        <th><input type="text" id="basket_bottom_discount" id="basket_bottom_discount" readonly></th>
        <th>Toplam</th>
        <th><input type="text" id="basket_bottom_total" id="basket_bottom_total" readonly></th>
        <th><button type="button" id="btnsave2" class="btn btn-success" onclick="SaveOrder()">Kaydet</button></th>
    </tr>
  </tfoot>
</cf_ajax_list>
</div>

<div style="border-top: 1px solid #eaeaea;position: fixed;bottom: 0;width: 100%;margin-left: 0;left: 0;display:none">
    <table style="width:100%;text-align:center">
        <tr>
            <td  id="RemoveButtonCell" style="display:none">
    <div class="form-group">
        
    <button type="button" class="btn btn-danger" id="RemoveButton" onclick="RemSelected()"><span class="icn-md icon-times"></span></button><br>
    <label>Sil</label>
    </div>
</td>
<td  id="UpdateButtonCell" style="display:none">
    <div class="form-group">
    <button type="button" class="btn btn-warning" id="UpdateRow" onclick="UpdateSelected()"><span class="icn-md icon-refresh"></span></button><br>
    <label>Güncelle</label>    
</div>
</td>
<td  id="TubeGroupButtonCell" style="display:none">
    <div class="form-group">
    <button type="button" class="btn btn-primary"  id="MakeTubeGroup" onclick="MakeTubeGroup()"><span class="icn-md icon-cogs"></span></button><br>
    <label>Hortum Takimı</label>    
</div>
</td>
</tr>
</table>

&nbsp;</div>

