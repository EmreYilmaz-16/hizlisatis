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

</style>
<div >
    <div style="float:left">
    <div class="form-group">
        <cfoutput><input type="text" name="barcode" id="barcode" value="30012020935" onkeyup="getProductWithBarcode(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#')" placeholder="Barkod"></cfoutput>
    </div>
</div>
    <div style="align-self: self-end;float:right">
        <button class="btn btn-primary" onclick="openHose('')" type="button">T</button>
        <button class="btn btn-danger" type="button">H</button>
        <button class="btn btn-warning" type="button">P</button>
    </div>
</div>

<cfquery name="getMoney" datasource="#dsn#">
    SELECT MONEY,RATE1, EFFECTIVE_SALE AS RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
</cfquery>
<script>
    var moneyArr=[
        <cfoutput query="getMoney">
            {
                MONEY:"#MONEY#"
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
            <th>Adet</th>            
            <th>Fiyat</th>
            <th>D.Fiyat</th>
            <th>Döviz</th>
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
    <table cellspacing="0" border="0" class="CurrencyTable">
        <thead>
            <tr>
                <th colspan="6">Toplam</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="width:5% !important">Top.</td>
                <td  ><input type="text" name="subTotal" id="subTotal" class="box moneybox pbs_v" readonly></td>
          
                <td style="width:5% !important">KDV</td>
                <td ><input type="text" name="subTaxTotal" id="subTaxTotal" class="box moneybox pbs_v" readonly></td>
   
                <td style="width:5% !important">KDV'li Top</td>
                <td  ><input type="text" name="subWTax" id="subWTax" class="box moneybox pbs_v" readonly></td>
            </tr>
        </tbody>
    </table>
<br>
<table cellspacing="0" border="0" class="CurrencyTable" id="qs_basket">
    <thead>
        <tr>
            <th colspan="4">Döviz</th>
        </tr>
    </thead>
    <tbody>
        
            <tr><cfoutput query="getMoney">
                <input type="hidden" id="_hidden_rd_money_#CurrentRow#" name="_hidden_rd_money_#CurrentRow#" value="#MONEY#">
                <input type="hidden" id="_txt_rate1_#CurrentRow#" name="_txt_rate1_#CurrentRow#" value="#TLFormat(RATE1)#">
                <td nowrap="nowrap"><input type="radio" class="rdMoney" id="_rd_money" name="_rd_money" value="#CurrentRow#" <cfif MONEY eq session.ep.money>checked="checked"</cfif>></td>
                <td nowrap="nowrap">#MONEY#</td>
                <td nowrap="nowrap">#RATE1#/</td>
                <td nowrap="nowrap"><input type="text" id="_txt_rate2_#CurrentRow#" name="_txt_rate2_#CurrentRow#" value="#TLFormat(RATE2,4)#" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,4));" onblur="if((this.value.length == 0) || filterNum(this.value,4) <=0 ) this.value=commaSplit(1,4);" readonly=""></td>
            </cfoutput> </tr>
        
    </tbody>
</table>
&nbsp;</div>

