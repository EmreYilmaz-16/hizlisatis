<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

<cfinclude template="../includes/upperMenu.cfm">
<cf_box title="İlişkili Belgeler">
    <cfquery name="getDocuments" datasource="#dsn3#">
        SELECT 0 AS ALVER, OFFER_ID AS ACTION_ID
        ,OFFER_NUMBER AS ACTION_NUMBER
        ,OFFER_HEAD ACTION_HEAD
        ,OFFER_DATE AS ACTION_DATE
        ,PRICE AS ACTION_VALUE
        ,PURCHASE_SALES 
        ,'index.cfm?fuseaction=sales.list_pbs_offer&event=upd&offer_id=' AS PAGE_ACTION
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
        ,CASE WHEN PURCHASE_SALES =1
        THEN 'index.cfm?fuseaction=sales.list_order&event=upd&order_id='
        ELSE 
        'purchase.list_order&event=upd&order_id='
        END AS PAGE_ACTION
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
        ,CASE WHEN PURCHASE_SALES =1
        THEN 'index.cfm?fuseaction=invoice.form_add_bill&event=upd&iid='
        ELSE 
        'index.cfm?fuseaction=invoice.form_add_bill_purchase&event=upd&iid='
        END AS PAGE_ACTION
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış Faturası'
        ELSE 'Alış Faturası'
        END AS TIP
        ,'Fatura' AS MAIN_TIP
        FROM #dsn2#.INVOICE
        WHERE PROJECT_ID = #attributes.project_id#

        UNION

        SELECT 0 AS ALVER,SHIP_ID AS ACTION_ID
        ,SHIP_NUMBER AS ACTION_NUMBER
        ,'İrsaliye' ACTION_HEAD
        ,SHIP_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,PURCHASE_SALES
        ,CASE WHEN PURCHASE_SALES =1
        THEN 'index.cfm?fuseaction=stock.form_add_sale&event=upd&ship_id='
        ELSE 
        'index.cfm?fuseaction=stock.form_add_purchase&event=upd&ship_id='
        END AS PAGE_ACTION
        ,CASE
        WHEN PURCHASE_SALES = 1
        THEN 'Satış İrsaliyesi'
        ELSE 'Alış İrsaliyesi'
        END AS TIP
        ,'İrsaliye' AS MAIN_TIP
        FROM #dsn2#.SHIP
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
        ,'' AS PAGE_ACTION
        ,CASE
        WHEN (
        ACTION_FROM_COMPANY_ID IS NOT NULL
        OR ACTION_FROM_EMPLOYEE_ID IS NOT NULL
        )
        THEN 'Banka Giren'
        ELSE 'Banka Çıkan'
        END AS TIP
        ,'Banka' AS MAIN_TIP
        FROM #dsn2#.BANK_ACTIONS
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
        ,'' AS PAGE_ACTION
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
        FROM #dsn2#.CASH_ACTIONS
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
            <td><a onclick="windowopen('#PAGE_ACTION#','page')">#ACTION_NUMBER#</a></td>
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
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>