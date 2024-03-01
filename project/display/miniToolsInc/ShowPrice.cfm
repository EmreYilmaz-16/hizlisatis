<cf_box title="Fiyat Göster" scroll="1" collapsable="1" resize="1" popup_box="1">
        <cfdump var="#attributes#">
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
                    <input type="text" class="form-control" name="SP_Fiyat" id="SP_Fiyat" value="<cfoutput>#tlformat(FData.Price)#</cfoutput>">
                </td>
            </tr>
            <tr>
                <td>
                    Miktar
                </td>
                <td>
                    <input type="text" class="form-control" name="SP_Miktar" id="SP_Miktar" value="<cfoutput>#tlformat(FData.miktar)#</cfoutput>"> 
                </td>            
            </tr>
            <tr>
                <td>
                    İndirim
                </td>
                <td>
                    <input type="text" class="form-control" name="SP_Discount" id="SP_Discount" value="<cfoutput>#tlformat(FData.Discount)#</cfoutput>">
                </td>            
            </tr>
            <tr>
                <td>
                    Net Fiyat
                </td>
                <td>
                    <input type="text" class="form-control" name="SP_NetPrice" id="SP_NetPrice" readonly>
                </td>            
            </tr>
        </table>
    </td>
    <td>
        <table>
            <tr>
                <th colspan="2">
                    Para Birimi
                </th>
            </tr>
        <cfloop array="#FData.moneyArr#" item="it">
            <tr <cfif FData.OtherMoney eq it.MONEY>style="background:#0080005e"</cfif>>
                <td>
                    <cfoutput>#it.MONEY#</cfoutput>
                </td>
                <td>
                    <cfoutput>#it.RATE1#</cfoutput><input type="text" name="RATE2_<cfoutput>#it.Money#</cfoutput>" class="form-control" value="<cfoutput>#it.RATE2#</cfoutput>">
                </td>
            </tr>
        </cfloop>
    </table>
    </td>
</tr>
</table>
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
