<cfif IS_TYPE eq 1>	
    <cfquery name="GET_PUAN" datasource="#DSN3#"> <!---Satış Puanları Toplanıyor--->
        SELECT
            ORR.ORDER_ID,
            ORR.STOCK_ID, 
            ORR.PRODUCT_ID, 
            ORR.QUANTITY,
            ORR.ORDER_ID FIS_ID,
            ORR.ORDER_ROW_ID FIS_ROW_ID,
            ISNULL(PIP.PROPERTY1, 0) AS PUAN
        FROM         
            PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
            PRODUCT_INFO_PLUS AS PIP ON ORR.PRODUCT_ID = PIP.PRODUCT_ID
        WHERE     
            ESRR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
    </cfquery>
<cfelse>
    <cfquery name="GET_PUAN" datasource="#DSN2#">
        SELECT     
            ISNULL(PIP.PROPERTY1, 0) AS PUAN, 
            SIR.AMOUNT AS QUANTITY, 
            SIR.PRODUCT_ID, 
            SIR.STOCK_ID, 
            SI.DISPATCH_SHIP_ID, 
            SIR.SHIP_ROW_ID, 
            ORR.ORDER_ID AS FIS_ID, 
            ORR.ORDER_ID,
            ORR.ORDER_ROW_ID AS FIS_ROW_ID
        FROM
            SHIP_INTERNAL AS SI INNER JOIN
            SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
            #dsn3_alias#.ORDER_ROW AS ORR ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
            #dsn3_alias#.PRODUCT_INFO_PLUS AS PIP ON SIR.PRODUCT_ID = PIP.PRODUCT_ID
        WHERE     
            SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
    </cfquery>
</cfif>