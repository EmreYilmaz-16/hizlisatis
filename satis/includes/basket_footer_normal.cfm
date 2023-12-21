<div class="row formContentFooter">
    
    <div class="record_info" >
        <div id="dvv_r" style="display:none;text-align:center">
    <i class="fa fa-pencil"></i> 
    <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_emp_det&emp_id=103','medium');" class="tableyazi" id="record_member">EMRE YILMAZ</a><span id="record_inf_date">14/10/2022 17:59 </span>
        </div>
    <div id="dvv_ru" style="display:none;text-align:center">
    <i class="fa fa-refresh"></i>
    <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_emp_det&emp_id=103','medium');" class="tableyazi" id="update_member">EMRE YILMAZ</a><span id="update_inf_date">14/10/2022 17:59 </span>
    </div>
</div>
</div>
<div style="fixed:bottom">
<table  >
    <tr>
    <td>
        <table style="width:100%;display:none" cellspacing="0" border="0" class="CurrencyTable">
            <thead>
                <tr>
                    <th colspan="2">Toplam</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td >Top.</td>
                    <td  >
                        <div class="form-group">
                            <input type="text" name="subTotal" id="subTotal" class="prtMoneyBox moneybox pbs_v" readonly>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td >KDV</td>
                    <td >
                        <div class="form-group">
                            <input type="text" name="subTaxTotal" id="subTaxTotal" class="prtMoneyBox moneybox pbs_v" readonly>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td >KDV'li Top</td>
                    <td  >
                        <div class="form-group">
                            <input type="text" name="subWTax" id="subWTax" class="prtMoneyBox moneybox pbs_v" readonly>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>    
        <table  cellspacing="0" border="0" class="CurrencyTable">
            <tr>
                <td>
                    Toplam
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_total" id="txt_total" class="prtMoneyBox moneybox pbs_v" readonly>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Fatura Altı İndirim
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_disc" id="txt_disc" class="prtMoneyBox moneybox pbs_v" onchange="toplamHesapla_2()" value="<cfoutput>#tlformat(0,4)#</cfoutput>">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Toplam İndirim
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_disc_total" id="txt_disc_total" class="prtMoneyBox moneybox pbs_v" readonly>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Kdv'siz Toplam
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_nokdv_total" id="txt_nokdv_total" class="prtMoneyBox moneybox pbs_v" readonly>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Kdv Toplam
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_kdv_total" id="txt_kdv_total" class="prtMoneyBox moneybox pbs_v" readonly>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Kdv'li Toplam
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="txt_withkdv_total" id="txt_withkdv_total" class="prtMoneyBox moneybox pbs_v" readonly>
                    </div>
                </td>
            </tr>
        </table>

    </td>

    <td>
        
    <table  cellspacing="0" border="0" class="CurrencyTable" id="qs_basket">
    <thead>
    <tr>
    <th colspan="4">Döviz</th>
    </tr>
    </thead>
    <tbody>

    <cfif isDefined("GETOFFERmONEY")>
    <cfoutput query="GETOFFERmONEY">
        
    <tr>   
    <input type="hidden" id="_hidden_rd_money_#CurrentRow#" name="_hidden_rd_money_#CurrentRow#" value="#MONEY_TYPE#">
    <input type="hidden" id="_txt_rate1_#CurrentRow#" name="_txt_rate1_#CurrentRow#" value="#TLFormat(RATE1)#">
    <td nowrap="nowrap"><input type="radio" class="rdMoney" id="_rd_money" name="_rd_money" value="#CurrentRow#" <cfif GETOFFERmONEY.IS_SELECTED EQ 1>checked="yes"</cfif>></td>
    <td nowrap="nowrap">#MONEY_TYPE# </td>
    <td nowrap="nowrap">#RATE1#/</td>
    <td nowrap="nowrap">
    <div class="form-group">
    <input type="text" id="_txt_rate2_#CurrentRow#" name="_txt_rate2_#CurrentRow#"  value="#TLFormat(RATE2,4)#" class="prtMoneyBox"  onkeyup="return(FormatCurrency(this,event,4));" onblur="if((this.value.length == 0) || filterNum(this.value,4) <=0 ) this.value=commaSplit(1,4);" readonly="">
    </div>
    </td>
    </tr>
    </cfoutput> 
    <cfelse>

    <cfoutput query="getMoney">
    <tr>   
    <input type="hidden" id="_hidden_rd_money_#CurrentRow#" name="_hidden_rd_money_#CurrentRow#" value="#MONEY#">
    <input type="hidden" id="_txt_rate1_#CurrentRow#" name="_txt_rate1_#CurrentRow#" value="#TLFormat(RATE1)#">
    <td nowrap="nowrap"><input type="radio" class="rdMoney" id="_rd_money" name="_rd_money" value="#CurrentRow#" <cfif MONEY eq session.ep.money>checked="checked"</cfif>></td>
    <td nowrap="nowrap">#MONEY#</td>
    <td nowrap="nowrap">#RATE1#/</td>
    <td nowrap="nowrap">
    <div class="form-group">
    <input type="text" id="_txt_rate2_#CurrentRow#" name="_txt_rate2_#CurrentRow#"  value="#TLFormat(RATE2,4)#" class="prtMoneyBox"  onkeyup="return(FormatCurrency(this,event,4));" onblur="if((this.value.length == 0) || filterNum(this.value,4) <=0 ) this.value=commaSplit(1,4);" readonly="">
    </div>
    </td>
    </tr>
    </cfoutput> 
    </cfif>
    </tbody>
    </table>
    </td>
    </tr>
</table>
<div>
<button class="btn btn-success" id="btnsave" onclick="SaveOrder(this)" type="button">Kaydet</button>
<cfif attributes.event eq "UPD">
<button class="btn btn-danger" id="btnsil" onclick="window.location.href='/index.cfm?fuseaction=sales.emptypopup_delete_pbs_offer&offer_id=<cfoutput>#attributes.offer_id#</cfoutput>'" type="button">Sil</button>
</cfif>
</div>
</div>