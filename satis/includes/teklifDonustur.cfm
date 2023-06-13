
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
            setProjects('#FormData.project_id#','#FormData.project_name#')
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
                            'TL',
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
        <cfif FormData.is_show_tree eq "OFF">
<cfelse>
<cfloop array="#FormData.ProductList#" item="it">
<cfif it.isVirtual eq 1>
    <cfquery name="getProductInfo" datasource="#dsn3#">
        SELECT VP.VIRTUAL_PRODUCT_ID as PRODUCT_ID
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
    ,'' SHELF_CODE
    ,0  STOCK_ID
    ,'' STOCK_CODE
    ,PB.BRAND_ID
    ,PB.BRAND_NAME
    ,PC.DETAIL
    ,'' AS PROPERTY1
    ,0 AS LAST_COST
FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP
LEFT JOIN workcube_metosan_1.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS PCP ON PCP.PRODUCT_CATID = VP.PRODUCT_CATID
LEFT JOIN workcube_metosan_1.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=VP.PRODUCT_CATID
LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=491
WHERE VP.VIRTUAL_PRODUCT_ID = #it.product_id#
    </cfquery>
    <cfelse>
<cfquery name="getProductInfo" datasource="#dsn3#">
SELECT S.PRODUCT_ID,S.PRODUCT_NAME,S.STOCK_ID,S.PRODUCT_CODE AS STOCK_CODE,S.TAX,S.TAX_PURCHASE,S.BRAND_ID,S.IS_PRODUCTION,PP.SHELF_CODE,PC.DETAIL,PB.BRAND_NAME,-6 as PORCURRENCY,PIP.PROPERTY1,PU.MAIN_UNIT AS PRODUCT_UNIT,'' PRODUCT_NAME2,'' DETAIL_INFO_EXTRA
,ISNULL((  SELECT TOP 1
                    IR.PRICE-(IR.DISCOUNTTOTAL/2) AS PRICE
                FROM
                    #dsn2#.INVOICE I
                    LEFT JOIN #dsn2#.INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
                WHERE
                    ISNULL(I.PURCHASE_SALES,0) = 0 AND
                    IR.PRODUCT_ID = S.PRODUCT_ID
                    AND I.PROCESS_CAT<>35
                ORDER BY
                    I.INVOICE_DATE DESC),0) AS LAST_COST
 FROM workcube_metosan_1.STOCKS AS S 
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
left JOIN workcube_metosan_1.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=S.BRAND_ID
LEFT JOIN workcube_metosan_1.PRODUCT_INFO_PLUS AS PIP ON PIP.PRODUCT_ID=S.PRODUCT_ID
LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID
WHERE S.PRODUCT_ID=#it.product_id#
</cfquery>
</cfif>
<cfset EMANUEL=0>
<CFIF getProductInfo.PROPERTY1 EQ "MANUEL">
    <CFSET EMANUEL=1>
</CFIF>
<cftry>
           AddRow(
                            #getProductInfo.PRODUCT_ID#,
                            #getProductInfo.STOCK_ID#,
                            '#getProductInfo.STOCK_CODE#',
                            '#getProductInfo.BRAND_NAME#',
                            <cfif len(it.isVirtual)>#it.isVirtual#<cfelse>0</cfif>,
                            #it.AMOUNT#,
                            <cfif len(it.price)>#it.price#<cfelse>0</cfif>,
                            '#getProductInfo.PRODUCT_NAME#',
                            #getProductInfo.TAX#,
                            <cfif len(it.discount)>#it.discount#<cfelse>0</cfif>,
                            '#getProductInfo.DETAIL#',
                            '#getProductInfo.SHELF_CODE#',
                            '<cfif (isdefined("it.money") and len(it.money)) and it.money neq 'undefined'>#it.money#<cfelse>TL</cfif>',
                            <cfif len(it.price)>#it.price#<cfelse>0</cfif>,
                            #getProductInfo.PORCURRENCY#,
                            #EMANUEL#,
                            #getProductInfo.LAST_COST#,
                            '#getProductInfo.PRODUCT_UNIT#',
                            '#getProductInfo.PRODUCT_NAME2#',
                            '#getProductInfo.DETAIL_INFO_EXTRA#',
                            1,
                            0,
                            '',
                            #getProductInfo.IS_PRODUCTION#,
                            '',
                            ''

        )
        <cfcatch>
            console.log('<cfdump var="#cfcatch.message#">')
        </cfcatch>
    </cftry>
</cfloop>
</cfif>

    </cfoutput>
    })
</script>


