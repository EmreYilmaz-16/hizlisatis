<cf_box scroll="1" collapsable="1" resize="1" popup_box="1">
        <cfdump var="#attributes#">
        <cfset FData=deserializeJSON(attributes.data)>
        <cfdump var="#FData#">
        <table>
            <tr>
                <td>
                    Müşteri Fiyatı
                </td>
                <td>
                    <input type="text" readonly value="<cfoutput>#FData.Price#</cfoutput>">
                </td>
                </tr>
                <tr>
                <td>
                    Müşteri İndirim
                </td>
                <td>
                    <input type="text" readonly value="<cfoutput>#FData.Discount#</cfoutput>">
                </td>
            </tr>
            <tr>
                <td>
                   Fiyat
                </td>
                <td>
                    <input type="text"  value="<cfoutput>#FData.Price#</cfoutput>">
                </td>
            </tr>
            <tr>
                <td>
                   Para Birimi
                </td>
                <td>
                    <select id="OM">
                        
                        <cfloop array="#FData.moneyArr#" item="it">
                        <cfoutput><option <cfif FData.OtherMoney eq MONEY>selected</cfif> value="#MONEY#">#MONEY#</option></cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
        </table>
        <button type="button" class="btn btn-outline-success">Fiyat Kaydet</button>
</cf_box>
