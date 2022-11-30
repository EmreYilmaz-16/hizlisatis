<cf_box title="Partner Siparişler">
<cfquery name="getOffers" datasource="#dsn3#">
select 
C.COMPANY_ID,C.FULLNAME,CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS NN,
CP.PARTNER_ID,EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS EMPLOS ,
PO.RECORD_DATE,PO.OFFER_HEAD,PO.OFFER_NUMBER,OFFER_ID,PO.NETTOTAL,PO.OTHER_MONEY
from #dsn3#.PBS_OFFER AS PO
LEFT JOIN #dsn#.COMPANY AS C ON PO.COMPANY_ID=C.COMPANY_ID
LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID=PO.PARTNER_ID
LEFT JOIN #dsn#.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID=PO.RECORD_MEMBER
</cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th><span onclick="window.location.href='/index.cfm?fuseaction=sales.emptypopup_form_add_upd_fast_sale_partner&event=add'" class="fa fa-plus"></span></th>
            <th>Teklif No</th>
            <th>Teklif Başlığı</th>
            <th>Müşteri</th>
            <th>Yetkili</th>
            <th>Teklif Tutarı</th>
            <th>Kayıt Tarih</th>
            <th>Kaydeden</th>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="getOffers">
        <tr>
            <td>#currentrow#</td>
            <td><a href="/index.cfm?fuseaction=sales.emptypopup_form_add_upd_fast_sale_partner&event=upd&offer_id=#OFFER_ID#">#OFFER_NUMBER#</a></td>
            <td>#OFFER_HEAD#</td>
            <td>#FULLNAME#</td>
            <td>#NN#</td>
            <td>#tlformat(NETTOTAL)# #OTHER_MONEY#</td>
            <td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>
            <td>#EMPLOS#</td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>