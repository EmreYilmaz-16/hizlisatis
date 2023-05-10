<style>
        .CurrencyTable{
        background-color: #f9f9f9;
        border: 1px solid #eaeaea;
        margin-top:1px;
        padding:1px 1px;
    }
    .CurrencyTable thead tr th{
        line-height: 30px;
        color: #525e64 !important;
        text-align: left;
        font-size: 10px;
        font-weight: 500;
    }
    .CurrencyTable tbody tr td{
        padding:1px;
    }
    .subTotals{
        padding-left:5px !important;
    }
    .ajax_list > tbody > tr > td, .ajax_list > tfoot > tr > td {
    font-size: 12px;
    padding: 0px;
    height: 20px;
    color: #555;
    white-space: nowrap;
}
</style>
<!-----
    ##pbs
    ----->
<div >
    <div style="float:left">
    <div class="form-group">
        <div class="input-group">
        <cfoutput><input type="text" name="barcode" id="barcode" value="" onkeyup="getProductWithBarcode(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#')" placeholder="Barkod"></cfoutput>
        <span class="input-group-addon icon-ellipsis btnPoniter" onclick="pencere_ac_product();"></span>
        
    </div>
    </div>

    <!------
        <span class="input-group-addon icon-ellipsis btnPoniter" title="Ürün Kategorisi Ekle  !" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&amp;field_id=form_upd_product.product_catid&amp;field_name=form_upd_product.product_cat&amp;field_min=form_upd_product.MIN_MARGIN&amp;field_max=form_upd_product.MAX_MARGIN');"></span>------->
</div>
    <div style="align-self: self-end;float:right">
        <button class="btn btn-primary" id="hoseBtn" onclick="openHose('')" type="button">T</button>
        <button class="btn btn-danger" id="hydBtn" onclick="openHydrolic('')" type="button">H</button>
        <button class="btn btn-warning" id="pumpBtn" onclick="openPump('')" type="button">P</button>
        <button class="btn btn-success" id="vpBtn" onclick="openVirtualProduct('')" type="button">VP</button>
        
    </div>
</div>
<div style="clear:both"></div>

<cfquery name="getMoney" datasource="#dsn#">
   SELECT 
(SELECT RATE1 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
(SELECT RATE2 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
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
<cfoutput query="getMoney">
    <input type="hidden" id="hidden_rd_money_#CurrentRow#" name="hidden_rd_money_#CurrentRow#" value="#MONEY#">
    <input type="hidden" id="txt_rate1_#CurrentRow#" name="txt_rate1_#CurrentRow#" value="#RATE1#">
    <input type="hidden" id="txt_rate2_#CurrentRow#" name="txt_rate2_#CurrentRow#" value="#RATE2#">
</cfoutput>
<cf_ajax_list>
    <thead>
        <tr>
            <th>#</th>            
            <th>Ürün</th>
            <th>Miktar</th>            
            <th>Fiyat</th>
           
            <th>Tutar<th>
        </tr>
    </thead>
    <tbody id="tbl_basket">
    </tbody>
  
</cf_ajax_list>
<div style="border-top: 1px solid #eaeaea;position: fixed;bottom: 0;width: 100%;margin-left: 0;left: 0;">
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

