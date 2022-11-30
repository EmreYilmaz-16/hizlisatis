<!--- Açık Faturalar --->
<cfquery name="get_invoice" datasource="#dsn2#">
    SELECT
        ACTION_VALUE TOTAL,
        OTHER_CASH_ACT_VALUE OTHER_MONEY_VALUE,
        OTHER_MONEY,
        PAPER_NO INVOICE_NUMBER,
        ACTION_DATE OLD_ACTION_DATE,
        ISNULL(PAPER_ACT_DATE, ACTION_DATE) INVOICE_DATE,
        ACTION_TYPE_ID,
        PROJECT_ID,
        ACTION_NAME,
        CASE
            WHEN (ACTION_TYPE_ID = 241) THEN ACTION_DATE
            ELSE DUE_DATE
        END AS DUE_DATE,
        1 INV_RATE,
        CARI_ACTION_ID,
        ACTION_TABLE,
        PROCESS_CAT
    FROM
        CARI_ROWS
    WHERE
        ACTION_VALUE > 0
        AND TO_CMP_ID = #attributes.company_id#
    ORDER BY
        CASE
            WHEN (ACTION_TYPE_ID = 241) THEN ACTION_DATE
            ELSE ISNULL(DUE_DATE, ACTION_DATE)
        END
</cfquery>
<cfset row_of_query = 0>
<cfset ALL_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,OLD_ACTION_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,CARI_ACTION_ID,ACTION_TABLE,PROCESS_CAT","VarChar,Double,Double,VarChar,Date,Date,integer,Date,Double,integer,integer,integer,VarChar,integer")>
<cfloop query="get_invoice">
    <cfscript>
        tarih_inv = CreateODBCDateTime(get_invoice.INVOICE_DATE);
        total_pesin = TOTAL;
        row_of_query = row_of_query + 1 ;
        QueryAddRow(ALL_INVOICE,1);
        QuerySetCell(ALL_INVOICE,"INVOICE_NUMBER","#INVOICE_NUMBER#",row_of_query);
        QuerySetCell(ALL_INVOICE,"TOTAL_SUB","#total_pesin#",row_of_query);
        QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB","#OTHER_MONEY_VALUE#",row_of_query);
        QuerySetCell(ALL_INVOICE,"T_OTHER_MONEY","#OTHER_MONEY#",row_of_query);
        QuerySetCell(ALL_INVOICE,"INVOICE_DATE","#tarih_inv#",row_of_query);
        QuerySetCell(ALL_INVOICE,"OLD_ACTION_DATE","#OLD_ACTION_DATE#",row_of_query);
        QuerySetCell(ALL_INVOICE,"ROW_COUNT","#row_of_query#",row_of_query);
        if(len(DUE_DATE))
            QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(DUE_DATE)#",row_of_query);
        else
            QuerySetCell(ALL_INVOICE,"DUE_DATE","#CreateODBCDateTime(INVOICE_DATE)#",row_of_query);
        QuerySetCell(ALL_INVOICE,"INV_RATE","#INV_RATE#",row_of_query);
        QuerySetCell(ALL_INVOICE,"ACTION_TYPE_ID","#ACTION_TYPE_ID#",row_of_query);
        QuerySetCell(ALL_INVOICE,"PROJECT_ID","#PROJECT_ID#",row_of_query);
        QuerySetCell(ALL_INVOICE,"CARI_ACTION_ID","#CARI_ACTION_ID#",row_of_query);
        QuerySetCell(ALL_INVOICE,"ACTION_TABLE","#ACTION_TABLE#",row_of_query);
        QuerySetCell(ALL_INVOICE,"PROCESS_CAT","#PROCESS_CAT#",row_of_query);
    </cfscript>
</cfloop>
<cfquery name="getRevenue" datasource="#dsn2#">
    SELECT
        FROM_CMP_ID,
        ACTION_VALUE AS TOTAL,
        ACTION_DATE OLD_ACTION_DATE,
        ISNULL(PAPER_ACT_DATE, ACTION_DATE) ACTION_DATE,
        CASE
            WHEN (ACTION_TYPE_ID = 241) THEN ACTION_DATE
            ELSE DUE_DATE
        END AS DUE_DATE,
        ACTION_TYPE_ID,
        PROJECT_ID,
        OTHER_CASH_ACT_VALUE AS OTHER_MONEY_VALUE,
        OTHER_MONEY,
        PAPER_NO,
        CARI_ACTION_ID,
        ACTION_TABLE,
        PROCESS_CAT,
        FROM_BRANCH_ID,
        TO_BRANCH_ID
    FROM
        CARI_ROWS
    WHERE
        FROM_CMP_ID = #attributes.company_id#
    ORDER BY
        CASE
            WHEN (ACTION_TYPE_ID = 241) THEN ACTION_DATE
            ELSE ISNULL(DUE_DATE, ACTION_DATE)
        END
</cfquery>
<cfloop query="getRevenue">
    <cfset toplam_odeme = TOTAL>
    <cfquery name="lastInvoices" dbtype="query">
        SELECT
            TOTAL_SUB,
            TOTAL_OTHER_SUB,
            T_OTHER_MONEY,
            INVOICE_NUMBER,
            INVOICE_DATE,
            ROW_COUNT,
            DUE_DATE,
            INV_RATE,
            ACTION_TYPE_ID,
            PROJECT_ID,
            CARI_ACTION_ID,
            PROCESS_CAT
        FROM
            ALL_INVOICE
        WHERE
            TOTAL_SUB IS NOT NULL AND
            TOTAL_SUB <> 0
        ORDER BY
            DUE_DATE
    </cfquery>
    <cfloop from="1" to="#lastInvoices.RecordCount#" index="i_index">
        <cfset temp_toplam_odeme = toplam_odeme>
        <cfset toplam_odeme -= lastInvoices.TOTAL_SUB[i_index]>
        <cfif toplam_odeme gt 0>
            <cfset QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,lastInvoices.ROW_COUNT[i_index])>
        <cfelse>
            <cfset QuerySetCell(ALL_INVOICE,"TOTAL_SUB",lastInvoices.TOTAL_SUB[i_index]-temp_toplam_odeme,lastInvoices.ROW_COUNT[i_index])>
            <cfbreak>
        </cfif>
    </cfloop>
</cfloop>
<cfquery name="lastInvoices" dbtype="query">
    SELECT
        TOTAL_SUB,
        TOTAL_OTHER_SUB,
        T_OTHER_MONEY,
        INVOICE_NUMBER,
        INVOICE_DATE,
        ROW_COUNT,
        DUE_DATE,
        INV_RATE,
        ACTION_TYPE_ID,
        PROJECT_ID,
        CARI_ACTION_ID,
        PROCESS_CAT
    FROM
        ALL_INVOICE
    WHERE
        TOTAL_SUB IS NOT NULL AND
        TOTAL_SUB <> 0 AND
        DUE_DATE < #Now()#
    ORDER BY
        DUE_DATE
</cfquery>
<cfset toplam_gun = 0>
<cfset islem_tar_acik_fat_toplam = 0>
<cfset islem_tar_acik_fat_toplam_agirlik = 0>
<cfset acik_toplam = 0>
<cfoutput>
<cfloop query="lastInvoices">
    <cfset acik_toplam += TOTAL_SUB>
</cfloop>
<cfset VADE_TOPLAMI = #acik_toplam#>
</cfoutput>
<!--- Açık Faturalar --->