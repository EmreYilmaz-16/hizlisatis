<cfquery name="getPor" datasource="#dsn3#">
    SELECT PO.OFFER_NUMBER,PO.OFFER_ID,POR.UNIQUE_RELATION_ID,C.NICKNAME,C.COMPANY_ID,workcube_metosan.getEmployeeWithId(PO.RECORD_MEMBER) RECORD_MEMBER,PO.RECORD_DATE,POR.PBS_OFFER_ROW_CURRENCY,
	PO.RECORD_MEMBER AS RECORD_MEMBER_ID,POR.PRODUCT_ID,POR.STOCK_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,POR.CONVERTED_STOCK_ID,PC.DETAIL AS KKD
	 FROM workcube_metosan_1.PBS_OFFER_ROW AS POR 
        LEFT JOIN workcube_metosan_1.PBS_OFFER AS PO ON PO.OFFER_ID=POR.OFFER_ID
        LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PO.COMPANY_ID
        LEFT JOIN workcube_metosan.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID=PO.EMPLOYEE_ID
		LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
        LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
		WHERE POR.PBS_OFFER_ROW_CURRENCY=1        
</cfquery>
<table>
    <cfoutput>
<cfloop query="getPor">
<tr>
    <td>
        #OFFER_NUMBER#
    </td>
    <td>
        #NICKNAME#
    </td>
    <td>
        #PRODUCT_CODE#
    </td>
    <td>
        #PRODUCT_NAME#
    </td>
    <td>
        #KKD#
    </td>
</tr>
</cfloop>
</cfoutput>
</table>