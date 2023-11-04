<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<cftry>
<cfquery name="GETSER" datasource="#DSN3#">
    SELECT SERVICE_HEAD
	,C.NICKNAME AS CK
	,C2.NICKNAME AS OK
	,E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS SE
	,SM.SHIP_METHOD
	,C2.COMPANY_ADDRESS
	,CITY.CITY_NAME
	,COUNTY.COUNTY_NAME
	,COUNTRY.COUNTRY_NAME
	,SERVICE_NO
	,SS.PRODUCT_NAME
    ,S.RECORD_DATE
    ,S.SERVICE_DETAIL
FROM #DSN3#.SERVICE AS S
LEFT JOIN #DSN#.COMPANY AS C ON S.SERVICE_COMPANY_ID = C.COMPANY_ID
LEFT JOIN #DSN#.COMPANY AS C2 ON S.OTHER_COMPANY_ID = C2.COMPANY_ID
LEFT JOIN #DSN#.EMPLOYEES AS E ON E.EMPLOYEE_ID = S.SERVICE_EMPLOYEE_ID
LEFT JOIN #DSN#.SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID = S.SHIP_METHOD
LEFT JOIN #DSN#.SETUP_CITY AS CITY ON CITY.CITY_ID = C2.CITY
LEFT JOIN #DSN#.SETUP_COUNTY AS COUNTY ON COUNTY.COUNTY_ID = C2.COUNTY
LEFT JOIN #DSN#.SETUP_COUNTRY AS COUNTRY ON COUNTRY.COUNTRY_ID = C2.COUNTRY
LEFT JOIN #DSN3#.STOCKS AS SS ON SS.PRODUCT_ID = S.SERVICE_PRODUCT_ID
WHERE SERVICE_ID = #attributes.action_id#
</cfquery>
<table border="1" cellspacing="0" cellpadding="0" class="table table-sm table-stripped">
    <tr>
        <th style="text-align:left">
            İlgili Bayi
        </th>
        <td>
            <cfoutput>#GETSER.OK#</cfoutput>
        </td>
        <td>

        </td>
        <th style="text-align:left">
            Tarih
        </th>
        <td>
            <cfoutput>#DATEFORMAT(GETSER.RECORD_DATE,"dd/mm/yyyy")#</cfoutput>
        </td>
    </tr>
    <tr>
        <th style="text-align:left">
            Adres
        </th>
        <td>
            <cfoutput>#GETSER.COMPANY_ADDRESS# #GETSER.COUNTY_NAME#/#GETSER.CITY_NAME# #GETSER.COUNTRY_NAME#</cfoutput>
        </td>
        <td>

        </td>
        <th style="text-align:left">
            Form No
        </th>
        <td>
            <cfoutput>#GETSER.SERVICE_NO#</cfoutput>
        </td>
    </tr>
    <tr>
        <th style="text-align:left">
            Sevk Yöntemi
        </th>
        <td>
            <cfoutput>#GETSER.SHIP_METHOD#</cfoutput>
        </td>
        <td>

        </td>
        <th style="text-align:left">
            Satış Temsilcisi
        </th>
        <td>
            <cfoutput>#GETSER.SE#</cfoutput>
        </td>
    </tr>
    <tr>
        <th style="text-align:left">
            Müşteri
        </th>
        <td>
            <cfoutput>#GETSER.CK#</cfoutput>
        </td>
        <td>

        </td>
        <th style="text-align:left">
            Konu
        </th>
        <td>
            <cfoutput>#GETSER.SERVICE_HEAD#</cfoutput>
        </td>
    </tr>
    <tr>
        <th style="text-align:left">
            Ürün
        </th>
        <td>
            <cfoutput>#GETSER.PRODUCT_NAME#</cfoutput>
        </td>
        <td>

        </td>
        <td>
            
        </td>
        <td>
            
        </td>
    </tr>
    <tr>
        <th style="text-align:left">
            Açıklama
        </th>
        <td>
            <cfoutput>#GETSER.SERVICE_DETAIL#</cfoutput>
        </td>
        <td>

        </td>
        <th style="text-align:left">
            Ürün Servis Açılaması
        </th>
        <td>
<cfquery name="gets" datasource="#dsn3#">
    select * from #DSN3#.SERVICE_PLUS WHERE SERVICE_ID=#attributes.action_id#
</cfquery>        
<cfloop  query="gets">
    <cfoutput>
        #gets.PLUS_CONTENT#
    </cfoutput>
</cfloop>   
        </td>
    </tr>
</table>

<h3>
    !LÜTFEN SERVİS TALEP FORMUNU İLGİLİ ÜRÜN İLE BİRLİKTE GERİ GÖNDERİNİZ! 	
</h3>
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>