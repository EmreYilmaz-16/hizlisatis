
<cfquery name="gets" datasource="#dsn3#">
    SELECT S.PRODUCT_ID
        ,S.STOCK_ID
        ,PRODUCT_NAME
        ,PC.PRODUCT_CATID
        ,PS.PRICE
        ,0 as MARJ
        ,PRODUCT_DETAIL AS PRODUCT_DESCRIPTION
        ,PC.DETAIL AS PRODUCT_TYPE
        ,1 AS IS_CONVERT_REAL
        ,#dsn#.getEmployeeWithId(S.RECORD_EMP) RECORD_EMP
        ,S.RECORD_DATE
        ,#dsn#.getEmployeeWithId(S.UPDATE_EMP) UPDATE_EMP
        ,S.UPDATE_DATE
        ,PC.PRODUCT_CAT
        
    FROM #dsn3#.STOCKS AS S
    LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID
    LEFT JOIN #DSN1#.PRICE_STANDART AS PS ON PS.PRODUCT_ID=S.PRODUCT_ID AND PRICESTANDART_STATUS=1  AND PURCHASESALES=1
    WHERE S.PRODUCT_ID = #getPo.STOCK_ID# 
</cfquery>

<cfquery name="getsTree" datasource="#dsn3#">
   SELECT *
	,PU.MAIN_UNIT
	,(
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
				PCE.COMPANY_ID = #getOfferMain.COMPANY_ID#
				OR PCE.COMPANY_ID IS NULL
				)
			AND P.PRODUCT_ID = S.PRODUCT_ID
			AND ISNULL(PC.IS_SALES, 0) = 1
			AND PCE.ACT_TYPE NOT IN (
				2
				,4
				)
			AND PC.PRICE_CATID = #getOfferMain.PRICE_CAT_ID#
		) AS DISCOUNT
FROM #DSN3#.VIRTUAL_PRODUCTION_ORDERS_STOCKS AS PT
LEFT JOIN #DSN3#.STOCKS AS S ON PT.STOCK_ID = S.STOCK_ID
LEFT JOIN #DSN3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
	AND IS_MAIN = 1
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
		AND P.PRICE_CATID = #getOfferMain.PRICE_CAT_ID#
		AND (
			P.STARTDATE <= getdate()
			AND (
				P.FINISHDATE >= getdate()
				OR P.FINISHDATE IS NULL
				)
			)
		AND ISNULL(P.SPECT_VAR_ID, 0) = 0
	) AS GPA ON GPA.PRODUCT_ID = S.PRODUCT_ID
	AND GPA.UNIT = PU.PRODUCT_UNIT_ID
WHERE PT.V_P_ORDER_ID = #attributes.VP_ORDER_ID#
   
   <!-----------
    SELECT *,PU.MAIN_UNIT FROM PRODUCT_TREE AS PT 
    LEFT JOIN #dsn3#.STOCKS AS S ON PT.RELATED_ID = S.STOCK_ID
    LEFT JOIN #dsn3#.PRODUCT_UNIT as PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND IS_MAIN=1
    LEFT JOIN ( SELECT
                        P.UNIT,
                        P.PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID,
                        P.CATALOG_ID,
                        P.PRICE_DISCOUNT
                    FROM
                        #DSN3#.PRICE P,
                        #DSN3#.PRODUCT PR
                    WHERE
                        P.PRODUCT_ID = PR.PRODUCT_ID
                        AND P.PRICE_CATID = #getOfferMain.PRICE_CAT_ID#
                        AND
                        (
                            P.STARTDATE <= getdate()
                            AND
                            (
                                P.FINISHDATE >= getdate() OR
                                P.FINISHDATE IS NULL
                            )
                        )
                        AND ISNULL(P.SPECT_VAR_ID, 0) = 0 ) AS GPA ON GPA.PRODUCT_ID=S.PRODUCT_ID AND GPA.UNIT=PU.PRODUCT_UNIT_ID
    WHERE PT.STOCK_ID =#gets.STOCK_ID#-------->
</cfquery>
    <cfquery name="getQUESTIONS" datasource="#dsn3#">
        SELECT *
        FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
        WHERE QUESTION_PRODUCT_TYPE = #gets.PRODUCT_TYPE#
    </cfquery>

<cfif gets.PRODUCT_TYPE eq 1 >
    <cfinclude template="basket_tube.cfm">
<cfelseif gets.PRODUCT_TYPE EQ 2>
    <cfinclude template="basket_hydrolik.cfm">
<cfelseif gets.PRODUCT_TYPE EQ 3>
    <cfinclude template="basket_pump.cfm">
<CFELSE>
    BİLEMEDİM
</cfif>

<cfquery name="getVirtualProduct" datasource="#dsn3#">
    SELECT S.PRODUCT_ID
        ,S.STOCK_ID
        ,PRODUCT_NAME
        ,PC.PRODUCT_CATID
        ,PS.PRICE
        ,0 as MARJ
        ,PRODUCT_DETAIL AS PRODUCT_DESCRIPTION
        ,PC.DETAIL AS PRODUCT_TYPE
        ,1 AS IS_CONVERT_REAL
        ,#dsn#.getEmployeeWithId(S.RECORD_EMP) RECORD_EMP
        ,S.RECORD_DATE
        ,#dsn#.getEmployeeWithId(S.UPDATE_EMP) UPDATE_EMP
        ,S.UPDATE_DATE
        ,PC.PRODUCT_CAT
        
    FROM #dsn3#.STOCKS AS S
    LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID
    LEFT JOIN #DSN1#.PRICE_STANDART AS PS ON PS.PRODUCT_ID=S.PRODUCT_ID AND PRICESTANDART_STATUS=1  AND PURCHASESALES=1
    WHERE S.PRODUCT_ID = #getPo.STOCK_ID# 
</cfquery>