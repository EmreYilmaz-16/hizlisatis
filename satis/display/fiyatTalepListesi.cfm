<cf_box title="Fiyat Talebi">
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
		   <cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
        WHERE PO.OFFER_ID=#attributes.OFFER_ID#
           </cfif>
</cfquery>
<cf_grid_list>
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
        <cfif KKD eq 1>
            Hortum
        <cfelseif KKD eq 3>
            Dönüştürelebilir Ürün            
        <cfelse>
            Normal Ürün
        </cfif>                
    </td>
    <td>
        #RECORD_MEMBER#
    </td>
    <td>
    <cfif IS_ACCCEPTED eq 1>
        Fiyat Kabul Edildi
    </cfif>
    </td>
    <td>
        <a href="#request.self#?fuseaction=sales.emptypopup_add_pbs_offer_price_offerings&ID=#ID#">Düzenle</a>
    </td>
</tr>
</cfloop>
</cfoutput>
</cf_grid_list>
</cf_box>