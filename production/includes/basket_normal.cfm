<cfdump var="#getProductionOrders#">
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
    SELECT *,PU.MAIN_UNIT FROM PRODUCT_TREE AS PT 
    LEFT JOIN #dsn3#.STOCKS AS S ON PT.RELATED_ID = S.STOCK_ID
    LEFT JOIN #dsn3#.PRODUCT_UNIT as PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND IS_MAIN=1
    WHERE PT.STOCK_ID =#gets.STOCK_ID#
</cfquery>
    <cfquery name="getQUESTIONS" datasource="#dsn3#">
        SELECT *
        FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
        WHERE QUESTION_PRODUCT_TYPE = #gets.PRODUCT_TYPE#
    </cfquery>

<cfif gets.PRODUCT_TYPE eq 1 >
    <cfinclude template="basket_tube.cfm">
<cfelseif gets.PRODUCT_TYPE EQ 2>
<cfelseif gets.PRODUCT_TYPE EQ 3>
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