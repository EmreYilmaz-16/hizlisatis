﻿<cf_box title="İlişkili Belgeler">
    <cfquery name="getDocuments" datasource="#dsn3#">
        SELECT OFFER_ID AS ACTION_ID
        ,OFFER_NUMBER AS ACTION_NUMBER
        ,OFFER_HEAD ACTION_HEAD
        ,OFFER_DATE AS ACTION_DATE
        ,PRICE AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Teklifi'
            ELSE 'Alış Teklifi'
            END AS TIP
        ,'Teklif' AS MAIN_TIP
    FROM workcube_metosan_1.PBS_OFFER
    WHERE PROJECT_ID = #attributes.project_id#
    
    UNION
    
    SELECT ORDER_ID AS ACTION_ID
        ,ORDER_NUMBER AS ACTION_NUMBER
        ,ORDER_HEAD ACTION_HEAD
        ,ORDER_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Siparişi'
            ELSE 'Alış Siparişi'
            END AS TIP
        ,'Sipariş' AS MAIN_TIP
    FROM workcube_metosan_1.ORDERS
    WHERE PROJECT_ID = #attributes.project_id#
    
    UNION
    
    SELECT INVOICE_ID AS ACTION_ID
        ,INVOICE_NUMBER AS ACTION_NUMBER
        ,'Fatura' ACTION_HEAD
        ,INVOICE_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Faturası'
            ELSE 'Alış Faturası'
            END AS TIP
        ,'Fatura' AS MAIN_TIP
    FROM workcube_metosan_2023_1.INVOICE
    WHERE PROJECT_ID = #attributes.project_id#
    
    UNION
    
    SELECT SHIP_ID AS ACTION_ID
        ,SHIP_NUMBER AS ACTION_NUMBER
        ,'İrsaliye' ACTION_HEAD
        ,SHIP_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış İrsaliyesi'
            ELSE 'Alış İrsaliyesi'
            END AS TIP
        ,'İrsaliye' AS MAIN_TIP
    FROM workcube_metosan_2023_1.SHIP
    WHERE PROJECT_ID = #attributes.project_id#
    
    UNION
    
    SELECT ACTION_ID
        ,PAPER_NO AS ACTION_NUMBER
        ,ACTION_TYPE AS ACTION_HEAD
        ,ACTION_DATE
        ,ACTION_VALUE 
        ,CASE 
            WHEN (
                    ACTION_FROM_COMPANY_ID IS NOT NULL
                    OR ACTION_FROM_EMPLOYEE_ID IS NOT NULL
                    )
                THEN 'Banka Giren'
            ELSE 'Banka Çıkan'
            END AS TIP
        ,'Banka' AS MAIN_TIP
    FROM workcube_metosan_2023_1.BANK_ACTIONS
    WHERE PROJECT_ID = #attributes.project_id#
    
    UNION
    
    SELECT ACTION_ID
        ,PAPER_NO AS ACTION_NUMBER
        ,ACTION_TYPE AS ACTION_HEAD
        ,ACTION_DATE
        ,ACTION_VALUE 
        ,CASE 
            WHEN (
                    CASH_ACTION_FROM_CASH_ID IS NOT NULL
                    OR CASH_ACTION_FROM_COMPANY_ID IS NOT NULL
                    )
                OR (
                    CASH_ACTION_FROM_CONSUMER_ID IS NOT NULL
                    OR CASH_ACTION_FROM_EMPLOYEE_ID IS NOT NULL
                    )
                THEN 'Kasa Giren'
            ELSE 'Kasa Çıkan'
            END AS TIP
        ,'Kasa' AS MAIN_TIP
    FROM workcube_metosan_2023_1.CASH_ACTIONS
    WHERE PROJECT_ID = #attributes.project_id#
    </cfquery>
    
    <div>    
        <cf_big_list>
    <cfoutput query="getDocuments">        
        <tr>
            <td>#MAIN_TIP#</td>
            <td>#TIP#</td>        
            <td>#ACTION_NUMBER#</td>
            <td>#ACTION_HEAD#</td>
            <td>#ACTION_DATE#</td>
            <td>#ACTION_VALUE#</td>    
        </tr>
    
    
    </cfoutput>
    </cf_big_list>
    </div>
    </cf_box>