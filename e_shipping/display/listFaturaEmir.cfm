<cfquery name="GetEmirs" datasource="#dsn3#">
SELECT 
C.NICKNAME
,FP.EMIR_DATE
,FP.INVOICE_ID
,FP.FATURA_DATE
,FP.INVOICE_PERIOD_ID
,FP.SVK_ID
,PS.DELIVER_PAPER_NO
,workcube_metosan.getEmployeeWithId(EMIR_EMP) AS TALEP_EDEN 
,workcube_metosan.getEmployeeWithId(INVOICE_EMP) AS FATURALAYAN 
,I.INVOICE_NUMBER
,SM.SHIP_METHOD
,SC.CITY_NAME
,(SELECT CONVERT(DECIMAL(18,2),BAKIYE3) BAKIYE3,OTHER_MONEY FROM #DSN2#.COMPANY_REMAINDER_MONEY  CRM WHERE  CRM.COMPANY_ID=PS.COMPANY_ID FOR JSON PATH) AS BAKBIL
FROM workcube_metosan_1.FATURA_EMIR_PBS FP
	LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT AS PS  ON PS.SHIP_RESULT_ID=FP.SVK_ID	
	LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PS.COMPANY_ID
	LEFT JOIN (
		SELECT *,3 AS PERIOD_ID FROM #DSN2#.INVOICE
		UNION ALL
		SELECT *,2 AS PERIOD_ID FROM workcube_metosan_2023_1.INVOICE
	) AS I ON I.INVOICE_ID=FP.INVOICE_ID AND I.PERIOD_ID=FP.INVOICE_PERIOD_ID
	LEFT JOIN workcube_metosan.SHIP_METHOD AS SM  ON SM.SHIP_METHOD_ID=PS.SHIP_METHOD_TYPE
	LEFT JOIN workcube_metosan.SETUP_CITY AS SC ON SC.CITY_ID=C.CITY
	
where IS_FATURA=0
</cfquery>

<cf_big_list>
    <thead>
        <tr>
            <th>

            </th>
            <th>
                No
            </th>
            <th>
                Talep Eden
            </th>
            <th>
                Talep Tarihi
            </th>
            <th>
                Müşteri
            </th>
            <th>
                Bakiye
            </th>
            <th>
                Şehir
            </th>
            <th>
                Sevk Yöntemi
            </th>
            <th>
                Fatura No
            </th>
            <th>
                Fatura Tarihi
            </th>
            <th>
                Faturalayan
            </th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="GetEmirs">
            <tr>
                <td>
                    #currentrow#
                </td>
                <td>
                    #DELIVER_PAPER_NO#
                </td>
                <td>
                    #TALEP_EDEN#
                </td>
                <td>
                    #dateFormat(EMIR_DATE,"dd/mm/yyyy")#
                </td>
                <td>
                    #NICKNAME#
                </td>
                <td>
                  <cftry>  <cfset JsonData=deserializeJSON(BAKBIL)>
                    <cfloop array="#JsonData#" item="it">
                        #tlformat(it.BAKIYE3)# #it.OTHER_MONEY# <br>
                    </cfloop>
                    <cfcatch></cfcatch>
                </cftry>
                </td>
                <td>
                    #CITY_NAME#
                </td>
                <td>
                    #SHIP_METHOD#
                </td>
                <td>
                    #INVOICE_NUMBER#
                </td>
                <td>
                    #dateFormat(FATURA_DATE,"dd/mm/yyyy")#
                </td>
                <td>
                    #FATURALAYAN#
                </td>
                <td></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_big_list>

<script>
    $(document).ready(function () {
        setTimeout(function(){
    window.location.reload()
},30000)
    })
</script>