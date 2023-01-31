<cfif listlen(order_row_id_list)>
    <cfquery name="get_sevk_durum" datasource="#dsn3#"> <!---Rezerve edilen üretim planları veya satınalma siparişlerinin depoya girişleri kontrol ediliyor--->
        SELECT     
            SUM(SEVK_DURUM) AS SEVK_DURUM
        FROM         
            (
            SELECT     
                SEVK_DURUM
            FROM          
                (
                SELECT     
                    CASE 
                        WHEN ORDER_ROW_CURRENCY = - 6 THEN 4 
                        WHEN ORDER_ROW_CURRENCY = - 9 THEN 1 
                        WHEN ORDER_ROW_CURRENCY = - 8 THEN 1 
                        WHEN ORDER_ROW_CURRENCY = - 3 THEN 1 
                        WHEN ORDER_ROW_CURRENCY = - 10 THEN 1 
                        ELSE 2 
                    END AS SEVK_DURUM
                FROM          
                    ORDER_ROW
                WHERE      
                    ORDER_ROW_ID IN (#order_row_id_list#) 
                ) AS TBL1
            GROUP BY 
                SEVK_DURUM
            ) AS TBL2
    </cfquery>
<cfelse>
    <cfset get_sevk_durum.sevk_durum = 4>
</cfif>