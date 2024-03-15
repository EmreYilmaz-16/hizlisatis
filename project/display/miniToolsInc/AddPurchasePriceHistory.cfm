<cfif session.ep.userid neq 1146 >Yapım Aşamasında
<cfabort></cfif>
<cfquery name="ishv" datasource="#dsn3#">
    SELECT PP_ID
	,UNIQUE_RELATION_ID
	,PP.COMPANY_ID
	,PRICE
	,OTHER_MONEY
	,PRICE_OTHER
	,PP_DATE
	,PP.RECORD_DATE
	,workcube_metosan.getEmployeeWithId(PP.RECORD_EMP) AS RECORD_EMP_
	,PP.RECORD_EMP
	,PP.UPDATE_DATE
    ,workcube_metosan.getEmployeeWithId(PP.UPDATE_EMP) AS UPDATE_EMP_
	,PP.UPDATE_EMP
	,C.NICKNAME
FROM PBS_OFFER_ROW_PURCHASE_PRICES_HISTORY AS PP
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID = PP.COMPANY_ID WHERE PP_ID='#attributes.PP_ID#'
</cfquery>

<cfoutput query="ishv">
    <cf_seperator title="#dateFormat(UPDATE_DATE,'dd/mm/yyyy')#" id="item_#currentrow#" style="display:none;">
        <div class="ui-info-text" id="item_#currentrow#">
    <table>
        <tr>
            <td>
                Tedarikçi 
            </td>
            <td>#NICKNAME#</td>
        </tr>
        <tr>
            <td>Alış Fiyat Tarihi</td>            
            <td>#dateformat(ishv.PP_DATE,"yyyy-mm-dd")#</td>
        </tr>
        <tr>
            <td>
                Alış Fiyatı
            </td>       
            <td>
                Para Birimi
            </td>      
        </tr>
        <tr>
            <td>#tlformat(ishv.PRICE_OTHER)#</td>
            <td>#ishv.OTHER_MONEY#</td>
        </tr>
    </table>
    <div>     
        <cfif len(ishv.UPDATE_EMP_)>
          Güncelleyen :<code style="color:orange">#ishv.UPDATE_EMP_# <br>#dateFormat(UPDATE_DATE,"dd/mm/yyyy")#</code>
        </cfif>
    </div>
</div>
</cfoutput>
