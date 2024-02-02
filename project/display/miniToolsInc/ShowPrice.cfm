<cf_box title="Fiyat Göster" scroll="1" collapsable="1" resize="1" popup_box="1">
        
        <cfset FData=deserializeJSON(attributes.data)>
        <cfdump var="#FData#">
        <table>
            <tr>
                <td>
                    Müşteri Fiyatı
                </td>
                <td>
                    <input class="form-control" type="text" id="fy_0001" readonly value="<cfoutput>#FData.Price#</cfoutput>">
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
                <td>
                    İndirimsiz Fiyat 
                  </td>
                  <td>
                      <input class="form-control" type="text" id="fy_0002" readonly value="<cfoutput>#FData.Price+((FData.Price*FData.Discount)/100)#</cfoutput>">
                  </td>
                <td>
                  Net Fiyat 
                </td>
                <td>
                    <input class="form-control" type="text" id="fy_0003" onkeyup="fiyatHesaplaPoppi(0)"  value="<cfoutput>#FData.Price#</cfoutput>">
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
        </table>
        <button type="button" class="btn btn-outline-success" onclick="SetPrice(<cfoutput>#FData.idb#,'#attributes.modal_id#'</cfoutput>)">Fiyat Kaydet</button>
</cf_box>
