<cf_box title="Fiyat Göster" scroll="1" collapsable="1" resize="1" popup_box="1">
        
        <cfset FData=deserializeJSON(attributes.data)>
        <table>
            <tr>
                <td>
        
        <table>
            <tr>
                <td>
                    Fiyat
                </td>
                <td>
                    <div class="input-group">
                    <input type="text" class="form-control" name="SP_Fiyat" id="SP_Fiyat" onchange="spHesaplayalim(this)" value="<cfoutput>#tlformat(FData.Price)#</cfoutput>">
                    <span class="input-group-text"><cfoutput>#FData.OtherMoney#</cfoutput></span>   
                </div>
                </td>
            </tr>
            <tr>
                <td>
                    Miktar
                </td>
                <td>
                    <input type="text" class="form-control" name="SP_Miktar" id="SP_Miktar" onchange="spHesaplayalim(this)" value="<cfoutput>#tlformat(FData.miktar)#</cfoutput>"> 
                </td>            
            </tr>
            <tr>
                <td>
                    İndirim
                </td>
                <td>
                    <input type="text" class="form-control" name="SP_Discount" onchange="spHesaplayalim(this)" id="SP_Discount" value="<cfoutput>#tlformat(FData.Discount)#</cfoutput>">
                </td>            
            </tr>
            <tr>
                <td>
                    Net Fiyat
                </td>
                <td>
                    <div class="input-group">
                    <input type="text" class="form-control" name="SP_NetPrice" id="SP_NetPrice" readonly>
                    <span class="input-group-text"><cfoutput>#FData.OtherMoney#</cfoutput></span>   
                </div>
                </td>            
            </tr>
            <tr>
                <td>
                   Tutar
                </td>
                <td>
                    <div >
                    <div class="input-group">
                        <input type="text" class="form-control" name="SP_NetTutar" id="SP_NetTutar" readonly>
                    <span class="input-group-text">TL</span>
                    </div>
                </div>
                </td>            
            </tr>
        </table>
    </td>
    <td>
        <table>
            <tr>
                <th colspan="2">
                    Para Birimi
                    <input type="hidden" value="<cfoutput>#FData.OtherMoney#</cfoutput>" id="SP_SelectedMoney">
                </th>
            </tr>
        <cfloop array="#FData.moneyArr#" item="it">
            <tr <cfif FData.OtherMoney eq it.MONEY>style="background:#0080005e"</cfif>>
                <td>
                    <cfoutput>#it.MONEY#</cfoutput>
                </td>
                <td>
                    <div style="display:flex;align-content: center;align-items: center;">
                        <h4 style="margin: 0;"><cfoutput>#it.RATE1#</cfoutput>/</h4>
                        <input type="text" name="RATE2_<cfoutput>#it.Money#</cfoutput>" readonly id="RATE2_<cfoutput>#it.Money#</cfoutput>" class="form-control" value="<cfoutput>#tlformat(it.RATE2)#</cfoutput>">
                    </div>                    
                </td>
            </tr>
        </cfloop>
    </table>
    </td>
</tr>
</table>
<script>
    function spHesaplayalim(el) {
        if(el.value.length==0){
            el.value=0;
        }
         el.value=commaSplit(filterNum(el.value))
         var SP_SelectedMoney=document.getElementById("SP_SelectedMoney").value;
        var SP_Fiyat=document.getElementById("SP_Fiyat").value;        
        var SP_Miktar=document.getElementById("SP_Miktar").value;
        var SP_Discount=document.getElementById("SP_Discount").value;
        var RATE2=document.getElementById("RATE2_"+SP_SelectedMoney).value
        SP_Fiyat=filterNum(SP_Fiyat);
        SP_Miktar=filterNum(SP_Miktar);
        SP_Discount=filterNum(SP_Discount);
        RATE2=filterNum(RATE2);
        
        var Sp_Indirimli_Fiyat=SP_Fiyat-((SP_Fiyat*SP_Discount)/100)
        var Sp_Tutar=Sp_Indirimli_Fiyat*SP_Miktar*RATE2
        
        var O={
            SP_SelectedMoney:SP_SelectedMoney,
            SP_Fiyat:SP_Fiyat,
            SP_Miktar:SP_Miktar,
            SP_Discount:SP_Discount,
            Sp_Indirimli_Fiyat:Sp_Indirimli_Fiyat,
            Sp_Tutar:Sp_Tutar,
            RATE2:RATE2,
        }
        console.table(O);
        
        document.getElementById("SP_NetPrice").value=commaSplit(Sp_Indirimli_Fiyat);
        document.getElementById("SP_NetTutar").value=commaSplit(Sp_Tutar);



    }
</script>
        <!------
        <table>
            <tr>
                <td>
                    Fiyat
                </td>
                <td>
                    <input class="form-control" type="text" id="fy_0001"  value="<cfoutput>#FData.StandartPrice#</cfoutput>">
                </td>
                </tr>
                <tr>
                <td>
                    Müşteri İndirim
                </td>
                <td>
                    <input class="form-control" type="text" id="fdy_0001" onkeyup="fiyatHesaplaPoppi(1)" value="<cfoutput>#FData.Discount#</cfoutput>">
                </td>
            </tr>
            <tr>
                <td style="display:none">
                   İndirimli Fiyat 
                  </td>
                  <td style="display:none">
                      <input class="form-control" type="text" id="fy_0002" readonly value="<cfoutput>#FData.Price#</cfoutput>">
                  </td>
                <td>
                  Net Fiyat 
                </td>
                <td>
                    <input class="form-control" type="text" readonly id="fy_0003" onkeyup="fiyatHesaplaPoppi(0)"  value="<cfoutput>#FData.Price#</cfoutput>">
                </td>
            </tr>
            <tr>
                <td>
                   Para Birimi
                </td>
                <td>
                    <select class="form-control" id="Omfy_0001">
                        
                        <cfloop array="#FData.moneyArr#" item="it">
                        <cfoutput><option <cfif FData.OtherMoney eq it.MONEY>selected</cfif> value="#it.MONEY#">#it.MONEY#</option></cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
        </table>----->
        <button type="button" class="btn btn-outline-success" onclick="SetPrice(<cfoutput>#FData.idb#,'#attributes.modal_id#'</cfoutput>)">Fiyat Kaydet</button>
</cf_box>
