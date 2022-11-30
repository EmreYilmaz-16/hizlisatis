<cfquery name="UPD_SEVKIYAT_KONTROL" datasource="#dsn3#">
    INSERT INTO 
        EZGI_SHIPPING_PACKAGE_LIST
        (
        SHIPPING_ID, 
        STOCK_ID, 
        AMOUNT, 
        CONTROL_AMOUNT, 
        CONTROL_STATUS, 
        TYPE, 
        RECORD_EMP, 
        RECORD_DATE
        )
    SELECT        
        E.SHIP_RESULT_ID, 
        ORR.STOCK_ID, 
        ORR.QUANTITY, 
        ORR.QUANTITY AS A, 
        2 AS B, 
        1 AS C, 
        #session.ep.userid#,
        #now()#
    FROM            
        EZGI_SHIP_RESULT_ROW AS E INNER JOIN
        ORDER_ROW AS ORR ON E.ORDER_ROW_ID = ORR.ORDER_ROW_ID
    WHERE        
        E.SHIP_RESULT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>