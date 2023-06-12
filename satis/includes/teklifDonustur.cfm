
<cfset FormData=deserializeJSON(attributes.data)>

<cfset attributes.type_id=FormData.company_id>
<cfset attributes.q_type="CompanyInfo">
<cfinclude template="../includes/getCompInfoQuery.cfm">

<cfset FirmaDatasi=InfoArray[1]>
<cfquery name="getProductData" datasource="#dsn3#">
SELECT VP.VIRTUAL_PRODUCT_ID
	,VP.PRODUCT_NAME
	,VP.PRODUCT_CATID
	,VP.PRODUCT_TYPE
	,VP.IS_PRODUCTION
	,PCP.PRODUCT_UNIT
	,VP.PORCURRENCY
	,PCP.PRODUCT_UNIT
	,PCP.TAX
	,PCP.TAX_PURCHASE
	,'' PRODUCT_NAME2
	,'' DETAIL_INFO_EXTRA
FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP
LEFT JOIN workcube_metosan_1.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS PCP ON PCP.PRODUCT_CATID = VP.PRODUCT_CATID
WHERE VP.VIRTUAL_PRODUCT_ID = #FormData.vp_id#
</cfquery>


<script>
    $(document).ready(function(){
        <cfoutput>
            setCompany(#FormData.COMPANY_ID#, '#FirmaDatasi.FULLNAME#',#FirmaDatasi.MANAGER_PARTNER_ID#,'#FirmaDatasi.MANAGER#')       
        
        <cfif FirmaDatasi.PAYMETHOD_ID neq 0 and len(FirmaDatasi.PAYMETHOD_ID)>
            var pm=generalParamsSatis.PAY_METHODS.filter(p=>p.PAYMETHOD_ID==#FirmaDatasi.PAYMETHOD_ID#);
            setOdemeYontem(pm[0].PAYMETHOD_ID, pm[0].PAYMETHOD, pm[0].DUE_DAY)
        </cfif>
        <cfif FirmaDatasi.SHIP_METHOD_ID neq 0 and len(FirmaDatasi.SHIP_METHOD_ID)>
            var sm=generalParamsSatis.SHIP_METHODS.filter(p=>p.SHIP_METHOD_ID==#FirmaDatasi.SHIP_METHOD_ID#)
            setSevkYontem(sm[0].SHIP_METHOD_ID, sm[0].SHIP_METHOD)
        </cfif>
        AddRow(
                            #getProductData.VIRTUAL_PRODUCT_ID#,
                            0,
                            '',
                            '',
                            1,
                            1,
                            #FormData.Maliyet#,
                            '#getProductData.PRODUCT_NAME#',
                            #getProductData.TAX#,
                            0,
                            #getProductData.PRODUCT_TYPE#,
                            '',
                            'TL,
                            #FormData.Maliyet#,
                            #getProductData.PORCURRENCY#,
                            0,
                            #FormData.Maliyet#,
                            '#getProductData.PRODUCT_UNIT#',
                            '#getProductData.PRODUCT_NAME2#',
                            '#getProductData.DETAIL_INFO_EXTRA#',
                            1,
                            0,
                            '',
                            #getProductData.IS_PRODUCTION#,
                            '',
                            ''

        )

    </cfoutput>
    })
</script>