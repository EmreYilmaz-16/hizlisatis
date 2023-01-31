<cfif IS_TYPE eq 1>    
    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#"> <!---Paket Kontrolü kontrol ediliyor--->
        SELECT     
            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
        FROM         
            (
            SELECT     
                PAKET_SAYISI AS PAKETSAYISI, 
                PAKET_ID AS STOCK_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME,
                (
                SELECT     
                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                FROM          
                    PRTOTM_SHIPPING_PACKAGE_LIST
                WHERE      
                    TYPE = 1 AND 
                    STOCK_ID = TBL.PAKET_ID AND 
                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                ) AS CONTROL_AMOUNT
            FROM         
                (
                SELECT
                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME, 
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID
                FROM
                    (     
                    SELECT     
                           round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID
                    FROM 
                        SPECTS AS SP INNER JOIN
                         PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                         PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                          ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID ON SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID INNER JOIN
                         STOCKS AS S INNER JOIN
                         PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID ON SP.SPECT_MAIN_ID = 0 INNER JOIN
                        STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID   
                    WHERE      
                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID# AND
                        ISNULL(S1.IS_PROTOTYPE,0) = 1
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID
                     UNION ALL
                    SELECT     
                           round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID
                    FROM          
                        PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                        PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                        PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                        STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                        STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                    WHERE      
                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID# AND
                        ISNULL(S1.IS_PROTOTYPE,0) = 0
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID
                    ) AS TBL1
                GROUP BY
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME,
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID
                ) AS TBL
            ) AS TBL2
    </cfquery>
<cfelse>
    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#">
        SELECT     
            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
        FROM         
            (		
            SELECT     
                PAKET_SAYISI AS PAKETSAYISI, 
                PAKET_ID AS STOCK_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME,
                (
                SELECT     
                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                FROM          
                    PRTOTM_SHIPPING_PACKAGE_LIST
                WHERE      
                    TYPE = 2 AND 
                    STOCK_ID = TBL.PAKET_ID AND 
                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                ) AS CONTROL_AMOUNT, SHIP_RESULT_ID
            FROM         
                (
                SELECT     
                    SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME, 
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID
                FROM          
                    (
                    SELECT     
                        CASE 
                            WHEN 
                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                            THEN 
                                S.PRODUCT_TREE_AMOUNT 
                            ELSE 
                                round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),2)
                        END 
                            AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                        SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                    FROM          
                        STOCKS AS S INNER JOIN
                        PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                        #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                    WHERE      
                        SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                        SI.DISPATCH_SHIP_ID
                    ) AS TBL1
                GROUP BY 
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME, 
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID
                ) AS TBL
            ) AS TBL2
    </cfquery>
</cfif>