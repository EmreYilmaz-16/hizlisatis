﻿<cfif isDefined("attributes.OfferrowUniqId") and len(attributes.OfferrowUniqId)>
    <cfquery name="getPor" datasource="#dsn3#">
        SELECT PO.OFFER_NUMBER,PO.OFFER_ID,POR.UNIQUE_RELATION_ID,C.NICKNAME,C.COMPANY_ID,workcube_metosan.getEmployeeWithId(PO.RECORD_MEMBER) RECORD_MEMBER,PO.RECORD_DATE,POR.PBS_OFFER_ROW_CURRENCY,
        PO.RECORD_MEMBER AS RECORD_MEMBER_ID,POR.PRODUCT_ID,POR.STOCK_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,POR.CONVERTED_STOCK_ID,PC.DETAIL AS KKD,PPROR.IS_ACCCEPTED,PPROR.ID,workcube_metosan.getEmployeeWithId(PPROR.PRICE_EMP) as PRICE_EMP,PPROR.PRICE as OFFERED_PRICE,PRICE_MONEY
         FROM PBS_OFFER_ROW_PRICE_OFFER AS PPROR
            LEFT JOIN workcube_metosan_1.PBS_OFFER_ROW AS POR ON PPROR.UNIQUE_RELATION_ID=POR.UNIQUE_RELATION_ID
            LEFT JOIN workcube_metosan_1.PBS_OFFER AS PO ON PO.OFFER_ID=POR.OFFER_ID
            LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PO.COMPANY_ID
            LEFT JOIN workcube_metosan.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID=PO.EMPLOYEE_ID
            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
            LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
            WHERE PPROR.UNIQUE_RELATION_ID='#attributes.OfferrowUniqId#'
    </cfquery>
<cf_box title="Hesaplanan Fiyatlar" scroll="1" collapsable="1" resize="1" popup_box="1">
<cf_grid_list>
    <cfoutput query="getPor">
<tr>
    <td>
#PRICE_EMP#
    </td>
    <td>
        <a onclick="setFiyatA(#attributes.row_id#,#OFFERED_PRICE#,'#PRICE_MONEY#','#attributes.modal_id#')">#OFFERED_PRICE# #PRICE_MONEY#</a>
    </td>
</tr>
</cfoutput>
</cf_grid_list>
</cf_box>
<cfelse>
<cfquery name="getPor" datasource="#dsn3#">
    SELECT PO.OFFER_NUMBER,PO.OFFER_ID,POR.UNIQUE_RELATION_ID,C.NICKNAME,C.COMPANY_ID,workcube_metosan.getEmployeeWithId(PO.RECORD_MEMBER) RECORD_MEMBER,PO.RECORD_DATE,POR.PBS_OFFER_ROW_CURRENCY,
	PO.RECORD_MEMBER AS RECORD_MEMBER_ID,POR.PRODUCT_ID,POR.STOCK_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,POR.CONVERTED_STOCK_ID,PC.DETAIL AS KKD,PPROR.IS_ACCCEPTED,PPROR.ID
	 FROM PBS_OFFER_ROW_PRICE_OFFER AS PPROR
        LEFT JOIN workcube_metosan_1.PBS_OFFER_ROW AS POR ON PPROR.UNIQUE_RELATION_ID=POR.UNIQUE_RELATION_ID
        LEFT JOIN workcube_metosan_1.PBS_OFFER AS PO ON PO.OFFER_ID=POR.OFFER_ID
        LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PO.COMPANY_ID
        LEFT JOIN workcube_metosan.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID=PO.EMPLOYEE_ID
		LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
        LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
		WHERE PPROR.ID=#attributes.id#
</cfquery>

<cfset attributes.isfrom_price_offer=1>
<cfinclude template="../includes/main_price_offer.cfm">

</cfif> 
