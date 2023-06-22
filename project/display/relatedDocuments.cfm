<cf_box title="İlişkili Belgeler">
    <cfquery name="getDocuments" datasource="#dsn3#">
        SELECT 0 AS ALVER, OFFER_ID AS ACTION_ID
        ,OFFER_NUMBER AS ACTION_NUMBER
        ,OFFER_HEAD ACTION_HEAD
        ,OFFER_DATE AS ACTION_DATE
        ,PRICE AS ACTION_VALUE
        ,PURCHASE_SALES 
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış Teklifi'
        ELSE 'Alış Teklifi'
        END AS TIP
        ,'Teklif' AS MAIN_TIP
        FROM #DSN3#.PBS_OFFER
    WHERE PROJECT_ID = #attributes.project_id#

        UNION

        SELECT 0 AS ALVER, ORDER_ID AS ACTION_ID
        ,ORDER_NUMBER AS ACTION_NUMBER
        ,ORDER_HEAD ACTION_HEAD
        ,ORDER_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,PURCHASE_SALES
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış Siparişi'
        ELSE 'Alış Siparişi'
        END AS TIP
        ,'Sipariş' AS MAIN_TIP
        FROM #DSN3#.ORDERS
    WHERE PROJECT_ID = #attributes.project_id#

        UNION

        SELECT 1 AS ALVER,INVOICE_ID AS ACTION_ID
        ,INVOICE_NUMBER AS ACTION_NUMBER
        ,'Fatura' ACTION_HEAD
        ,INVOICE_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,PURCHASE_SALES
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış Faturası'
        ELSE 'Alış Faturası'
        END AS TIP
        ,'Fatura' AS MAIN_TIP
        FROM workcube_metosan_2023_1.INVOICE
        WHERE PROJECT_ID = #attributes.project_id#

        UNION

        SELECT 0 AS ALVER,SHIP_ID AS ACTION_ID
        ,SHIP_NUMBER AS ACTION_NUMBER
        ,'İrsaliye' ACTION_HEAD
        ,SHIP_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,PURCHASE_SALES
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış İrsaliyesi'
        ELSE 'Alış İrsaliyesi'
        END AS TIP
        ,'İrsaliye' AS MAIN_TIP
        FROM workcube_metosan_2023_1.SHIP
        WHERE PROJECT_ID = #attributes.project_id#

        UNION

        SELECT 1 AS ALVER,ACTION_ID
        ,PAPER_NO AS ACTION_NUMBER
        ,ACTION_TYPE AS ACTION_HEAD
        ,ACTION_DATE
        ,ACTION_VALUE
        ,CASE WHEN (ACTION_FROM_COMPANY_ID IS NOT NULL
        OR ACTION_FROM_EMPLOYEE_ID IS NOT NULL)
        THEN 1 ELSE 0 END AS PURCHASE_SALES
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

        SELECT 1 AS ALVER, ACTION_ID
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
        THEN 1
        ELSE 0
        END AS PURCHASE_SALES
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
    
    <div style="height:90vh">    
        <cf_big_list>
            <CFSET toplamGider=0>
            <CFSET toplamGelir=0>
    <cfoutput query="getDocuments" group="MAIN_TIP">   
        <tr>
            <td colspan="5">#MAIN_TIP#</td>
        </tr>
        <cfoutput>
        <tr>
            
            <td>#TIP#</td>        
            <td>#ACTION_NUMBER#</td>
            <td>#ACTION_HEAD#</td>
            <td>#ACTION_DATE#</td>
            <td>#ACTION_VALUE#</td>
            <cfif PURCHASE_SALES EQ 1 AND ALVER EQ 1>
                <CFSET toplamGelir=toplamGelir+ACTION_VALUE>
            </cfif>
                <cfif PURCHASE_SALES EQ 0 AND ALVER EQ 1>
                    <CFSET toplamGider=toplamGider+ACTION_VALUE>
                </cfif>
        </tr>
    </cfoutput>
    
    
    </cfoutput>
    </cf_big_list>

    <div style="display:flex;position:absolute;bottom:0;right:0;">
        <div class="alert alert-success">
            <cfoutput>#tlformat(toplamGelir)#</cfoutput>
        </div>
        <div class="alert alert-danger">
        <cfoutput>#tlformat(toplamGider)#</cfoutput>
        </div>
        <cfset dng="success">
        <cfif toplamGelir lt toplamGider>
            <cfset dng="danger">
        </cfif>
        <div class="alert alert-<cfoutput>#dng#</cfoutput>">
        <cfoutput>#tlformat(toplamGider)#</cfoutput>
        </div>
    </div>
    </div>

    </cf_box>