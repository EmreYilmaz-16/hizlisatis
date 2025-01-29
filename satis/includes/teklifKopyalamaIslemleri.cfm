
   
    <cfif isDefined("attributes.from_offer_id") and len(attributes.from_offer_id)>
    <cfelse>
        <cfabort>
    </cfif>
    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
    <cfelse>
        <script>
            alert("Cari Seçmeden Kopyalama Yapamazsınız")
        </script>
        <cfabort>
    </cfif>

    

    <cfquery name="getOfferRow" datasource="#dsn3#">
        DECLARE @COMPANY_ID INT = #attributes.company_id#
        DECLARE @PRICE_CAT_ID INT = #attributes.price_catid#

        SELECT POR.PRICE_OTHER AS PRICE_OTHER_
            ,POR.QUANTITY
            ,POR.OTHER_MONEY_VALUE
            ,POR.PBS_OFFER_ROW_CURRENCY
            ,ISNULL(GPA.MONEY,POR.OTHER_MONEY) as OTHER_MONEY
            ,POR.DISCOUNT_1 AS DISCOUNT_1_
            ,S.STOCK_ID
            ,S.PRODUCT_CODE
            ,S.STOCK_CODE
            ,S.PRODUCT_NAME
            ,S.PRODUCT_ID
            ,PB.BRAND_NAME
            ,POR.IS_VIRTUAL
            ,S.TAX
            ,POR.SHELF_CODE
            ,PIP.PROPERTY1
            ,POR.DETAIL_INFO_EXTRA
            ,POR.DELIVER_DATE
            ,CASE 
                WHEN POR.IS_VIRTUAL = 1
                    THEN 1
                ELSE S.IS_PRODUCTION
                END AS IS_PRODUCTION
            ,POR.PRODUCT_NAME2
            ,'' AS UNIQUE_RELATION_ID
            ,POR.DESCRIPTION
            ,CASE 
                WHEN POR.IS_VIRTUAL = 1
                    THEN POR.UNIT COLLATE SQL_Latin1_General_CP1_CI_AS
                ELSE PU.MAIN_UNIT
                END AS MAIN_UNIT
            ,ISNULL(PC.DETAIL, 0) AS PRODUCT_TYPE
            ,ISNULL(GPA.PRICE, 0) AS PRICE
            ,ISNULL(GPA.PRICE, 0) AS PRICE_OTHER
            ,ISNULL((
                    SELECT TOP 1 PCE.DISCOUNT_RATE
                    FROM #DSN3#.PRODUCT P
                        ,#DSN3#.PRICE_CAT_EXCEPTIONS PCE
                    LEFT JOIN #DSN3#.PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                    WHERE (
                            PCE.PRODUCT_ID = P.PRODUCT_ID
                            OR PCE.PRODUCT_ID IS NULL
                            )
                        AND (
                            PCE.BRAND_ID = P.BRAND_ID
                            OR PCE.BRAND_ID IS NULL
                            )
                        AND (
                            PCE.PRODUCT_CATID = P.PRODUCT_CATID
                            OR PCE.PRODUCT_CATID IS NULL
                            )
                        AND (
                            PCE.COMPANY_ID = @COMPANY_ID
                            OR PCE.COMPANY_ID IS NULL
                            )
                        AND P.PRODUCT_ID = s.PRODUCT_ID
                        AND ISNULL(PC.IS_SALES, 0) = 1
                        AND PCE.ACT_TYPE NOT IN (
                            2
                            ,4
                            )
                        AND PC.PRICE_CATID = @PRICE_CAT_ID
                    ORDER BY PCE.COMPANY_ID DESC
                        ,PCE.PRODUCT_CATID DESC
                    ), 0) AS DISCOUNT_1
            ,(
                SELECT TOP 1 RATE2
                FROM (
                    SELECT MONEY
                        ,RATE2
                        ,VALIDATE_DATE
                    FROM workcube_metosan.MONEY_HISTORY
                    
                    UNION ALL
                    
                    SELECT 'TL' AS MONEY
                        ,1 AS RATE2
                        ,CONVERT(DATE, GETDATE()) AS VALIDATE_DATE
                    ) AS TT
                WHERE VALIDATE_DATE = CONVERT(DATE, GETDATE())
                    AND MONEY = ISNULL(GPA.MONEY, 'TL')
                ) AS R2
            ,GPA.*
        FROM #DSN3#.PBS_OFFER_ROW AS POR
        LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
        LEFT JOIN #DSN1#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = S.BRAND_ID
        LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID and IS_MAIN=1
        OUTER APPLY(
SELECT TOP 1 PROPERTY1 FROM workcube_metosan_1.PRODUCT_INFO_PLUS AS PIP WHERE PIP.PRODUCT_ID=S.PRODUCT_ID
) AS PIP
        LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID
        LEFT JOIN (
            SELECT P.UNIT
                ,P.PRICE
                ,P.PRICE_KDV
                ,P.PRODUCT_ID
                ,P.MONEY
                ,P.PRICE_CATID
                ,P.CATALOG_ID
                ,P.PRICE_DISCOUNT
            FROM #DSN3#.PRICE P
                ,#DSN3#.PRODUCT PR
            WHERE P.PRODUCT_ID = PR.PRODUCT_ID
                AND P.PRICE_CATID = @PRICE_CAT_ID
                AND (
                    P.STARTDATE <= GETDATE()
                    AND (
                        P.FINISHDATE >= GETDATE()
                        OR P.FINISHDATE IS NULL
                        )
                    )
                AND ISNULL(P.SPECT_VAR_ID, 0) = 0
            ) AS GPA ON GPA.PRODUCT_ID = S.PRODUCT_ID
            AND GPA.UNIT = S.PRODUCT_UNIT_ID
        WHERE OFFER_ID = #attributes.from_offer_id#
        ORDER BY POR.OFFER_ROW_ID
    </cfquery>
    
    <cfquery name="getComp" datasource="#dsn3#">
        SELECT C.NICKNAME
            ,C.FULLNAME
            ,C.MANAGER_PARTNER_ID
            ,C.COMPANY_ID
            ,ISNULL(CC.PAYMETHOD_ID, 0) AS PAYMETHOD_ID
            ,CC.PRICE_CAT
            ,ISNULL(CC.SHIP_METHOD_ID, 0) AS SHIP_METHOD_ID
            ,SPM.PAYMETHOD
            ,SM.SHIP_METHOD
            ,CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS NN
        FROM workcube_metosan.COMPANY AS C
        LEFT JOIN workcube_metosan.COMPANY_CREDIT AS CC ON CC.COMPANY_ID = C.COMPANY_ID
        LEFT JOIN workcube_metosan.SETUP_PAYMETHOD AS SPM ON SPM.PAYMETHOD_ID = CC.PAYMETHOD_ID
        LEFT JOIN workcube_metosan.SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID = CC.SHIP_METHOD_ID
        LEFT JOIN workcube_metosan.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID
        WHERE C.COMPANY_ID = #attributes.company_id#
    </cfquery>
    <cfquery name="getOffer" datasource="#dsn3#">
        SELECT PO.OFFER_NUMBER
            ,PO.OFFER_DESCRIPTION
            ,C.COMPANY_ID
            ,C.FULLNAME
            ,CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS NN
            ,CP.PARTNER_ID
            ,PO.OFFER_HEAD
            ,PO.OFFER_DATE
            ,ISNULL(PO.SHIP_METHOD, 0) SHIP_METHOD
            ,ISNULL(PO.PAYMETHOD, 0) PAYMETHOD
            ,PO.RECORD_DATE
            ,PO.UPDATE_DATE
            ,#dsn#.getEmployeeWithId(PO.RECORD_MEMBER) AS RECORD_MEMBER
            ,#dsn#.getEmployeeWithId(PO.UPDATE_MEMBER) AS UPDATE_MEMBER
            ,PO.OFFER_DETAIL
            ,ISNULL(PO.SA_DISCOUNT, 0) SA_DISCOUNT
        FROM PBS_OFFER AS PO
        LEFT JOIN #dsn#.COMPANY AS C ON PO.COMPANY_ID = C.COMPANY_ID
        LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = PO.PARTNER_ID
        WHERE OFFER_ID = #attributes.from_offer_id#
    </cfquery>
    <script>
    $(document).ready(function () {          
        <cfoutput>
            setCompany(#getComp.COMPANY_ID#, '#getComp.FULLNAME#',#getComp.MANAGER_PARTNER_ID#,'#getComp.NN#')       
        
        <cfif getComp.PAYMETHOD_ID neq 0>
            var pm=generalParamsSatis.PAY_METHODS.filter(p=>p.PAYMETHOD_ID==#getComp.PAYMETHOD_ID#);
            setOdemeYontem(pm[0].PAYMETHOD_ID, pm[0].PAYMETHOD, pm[0].DUE_DAY)
        </cfif>
        <cfif getComp.SHIP_METHOD_ID neq 0>
            var sm=generalParamsSatis.SHIP_METHODS.filter(p=>p.SHIP_METHOD_ID==#getComp.SHIP_METHOD_ID#)
            setSevkYontem(sm[0].SHIP_METHOD_ID, sm[0].SHIP_METHOD)
        </cfif>
        document.getElementById("offer_head").value="#getOffer.OFFER_HEAD#"
        document.getElementById("offer_date").value=date_format("#getOffer.OFFER_DATE#")
        document.getElementById("txt_disc").value=commaSplit(#getOffer.SA_DISCOUNT#)
        
        document.getElementById("offer_desc").value='#EncodeForJavaScript(getOffer.OFFER_DESCRIPTION)#'
        <cfloop query="getOfferRow">
                        <CFSET EMANUEL=0>
                        <cfset lastCost = 0>
                        <cfset Pname="">
                        
          <CFIF getOfferRow.IS_VIRTUAL neq 1>
                        
            <cfquery name="getLastCost" datasource="#dsn2#">
                SELECT TOP 1
                    IR.PRICE-(IR.DISCOUNTTOTAL/2) AS PRICE
                FROM
                    INVOICE I
                    LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
                WHERE
                    ISNULL(I.PURCHASE_SALES,0) = 0 AND
                    IR.PRODUCT_ID = #PRODUCT_ID#
                    AND I.PROCESS_CAT<>35
                ORDER BY
                    I.INVOICE_DATE DESC
            </cfquery>
            <cfif getLastCost.RecordCount AND Len(getLastCost.PRICE)>
                <cfset lastCost = getLastCost.PRICE>
            </cfif>
                        
                            <CFIF getOfferRow.PROPERTY1 EQ "MANUEL">
                                <CFSET EMANUEL=1>
                            </CFIF>
        </cfif>
                        console.log("#PRODUCT_NAME#");
                        AddRow(
                            #PRODUCT_ID#,
                            #STOCK_ID#,
                            '#STOCK_CODE#',
                            '#getOfferRow.BRAND_NAME#',
                            #getOfferRow.IS_VIRTUAL#,
                            #getOfferRow.QUANTITY#,
                            #getOfferRow.PRICE#,
                            '#getOfferRow.PRODUCT_NAME#',
                            #getOfferRow.TAX#,
                            #getOfferRow.DISCOUNT_1#,
                            <cfif len(getOfferRow.PRODUCT_TYPE)>#getOfferRow.PRODUCT_TYPE#<cfelse>0</cfif>,
                            '#getOfferRow.SHELF_CODE#',
                            '#getOfferRow.OTHER_MONEY#',
                            #getOfferRow.PRICE_OTHER#,
                            #getOfferRow.PBS_OFFER_ROW_CURRENCY#,
                            #EMANUEL#,
                            #lastCost#,
                            '#getOfferRow.MAIN_UNIT#',
                            '#getOfferRow.PRODUCT_NAME2#',
                            '#getOfferRow.DETAIL_INFO_EXTRA#',
                            1,
                            0,
                            '#dateFormat(getOfferRow.DELIVER_DATE,"yyyy-mm-dd")#',
                            #getOfferRow.IS_PRODUCTION#,
                            '#getOfferRow.UNIQUE_RELATION_ID#',
                            '#DESCRIPTION#'
                        )                                                                    
                    </cfloop>

    </cfoutput>
    RowControlForVirtual();
                    setDoom();
})
    </script>

