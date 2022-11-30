<cfsetting showdebugoutput="no"><!---bu sayfa toplu ödeme performansdan ajaxla çağrıldıgı zaman debug kapatılması gerekiyor..AE --->
<cfif not isdefined("is_make_age_date")>
    <cfset is_make_age_date = 0>
</cfif>
<cfif isdefined("attributes.is_make_age_date") and attributes.is_make_age_date eq 1>
    <cfset is_make_age_date = 1>
</cfif>
<cfif isdefined("attributes.is_pay_cheque") and attributes.is_pay_cheque eq 1><!--- Toplu ödeme performansından gelen parametre --->
    <cfset attributes.is_pay_cheques = 1>
</cfif>
<cfif isDefined("session.pp.money")>
    <cfset session_base_money = session.pp.money>
<cfelseif isDefined("session.ww.money")>
    <cfset session_base_money = session.ww.money>
<cfelse>
    <cfset session_base_money = session.ep.money>
</cfif>
<cfif isdefined("attributes.is_ajax_popup")>
    <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
        <cf_date tarih = "attributes.date1">
    </cfif>
    <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
        <cf_date tarih = "attributes.date2">
    </cfif>
</cfif>
<cfif not isdefined("attributes.acc_type_id")>
    <cfset attributes.acc_type_id = "">
</cfif>
<cfquery name="GET_SETUP_MONEY" datasource="#dsn2#">
    SELECT * FROM SETUP_MONEY <cfif not isDefined("attributes.is_doviz_group")>WHERE MONEY = '<cfoutput>#session_base_money#</cfoutput>'<cfelseif isdefined("attributes.other_money") and len(attributes.other_money)>WHERE MONEY = '#attributes.other_money#'</cfif>
</cfquery>
<cfif (isDefined("attributes.company_id") and len(attributes.company_id)) or (isDefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))>
    <!--- Hesaplamalar --->  
    <cfif not (isdefined("attributes.detail_type") and len(attributes.detail_type) and attributes.detail_type eq 3)>
        <cfloop query="GET_SETUP_MONEY">
            <cfquery name="GET_COMP_REMAINDER" datasource="#dsn2#">
                SELECT
                ROUND(SUM(BORC-ALACAK),2) AS BAKIYE
                FROM
                (
                SELECT
                <cfif isDefined("attributes.is_doviz_group")>
                SUM(OTHER_CASH_ACT_VALUE) BORC,
                <cfelse>
                SUM(ACTION_VALUE) BORC,
                </cfif>
                0 ALACAK
                FROM
                CARI_ROWS
                WHERE
                1 = 1 AND
                <cfif isDefined("attributes.is_doviz_group")>
                ACTION_TYPE_ID NOT IN (48,49,46,45) AND
                OTHER_CASH_ACT_VALUE > 0 AND
                </cfif>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                TO_CMP_ID = #attributes.company_id#
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                TO_CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                TO_EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                </cfif>
                <cfif isdefined("is_show_store_acts")> 
                <cfif is_show_store_acts eq 0>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>	
                </cfif>	
                <cfelse>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>
                </cfif>
                <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                AND PROJECT_ID = #attributes.project_id#
                <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
                AND PROJECT_ID IS NULL						
                </cfif>
                <cfif isdefined("attributes.is_pay_cheques")>
                AND
                (
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                )
                <cfelse>
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                </cfif>
                <cfif isdefined("attributes.is_pay_bankorders")>
                AND
                (
                CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
                OR
                CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
                )
                </cfif>
                UNION ALL
                SELECT
                0 BORC,
                <cfif isDefined("attributes.is_doviz_group")>
                SUM(OTHER_CASH_ACT_VALUE) ALACAK
                <cfelse>
                SUM(ACTION_VALUE) ALACAK
                </cfif>
                FROM
                CARI_ROWS
                WHERE
                1 = 1 AND
                <cfif isDefined("attributes.is_doviz_group")>
                ACTION_TYPE_ID NOT IN (48,49,46,45) AND
                OTHER_CASH_ACT_VALUE > 0 AND
                </cfif>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                FROM_CMP_ID = #attributes.company_id#
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                FROM_CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                FROM_EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                </cfif>
                <cfif isdefined("is_show_store_acts")> 
                <cfif is_show_store_acts eq 0>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>	
                </cfif>	
                <cfelse>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>
                </cfif>
                <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                AND PROJECT_ID = #attributes.project_id#
                <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
                AND PROJECT_ID IS NULL						
                </cfif>
                <cfif isdefined("attributes.is_pay_cheques")>
                AND
                (
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                )
                <cfelse>
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                </cfif>
                <cfif isdefined("attributes.is_pay_bankorders")>
                AND
                (
                CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
                OR
                CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
                )
                </cfif>
                ) AS COMP_REMAINDER
            </cfquery>
            <cfquery name="GET_REVENUE" datasource="#DSN2#">
                SELECT 
                FROM_CMP_ID,
                ACTION_VALUE AS TOTAL,
                ACTION_DATE OLD_ACTION_DATE,
                ISNULL(PAPER_ACT_DATE,ACTION_DATE) ACTION_DATE,
                <cfif isdefined("attributes.is_cheque_duedate")>
                <!--- Çek ve senetler tahsil tarihlerine göre hesaplansın seçiliyse --->
                CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
                (
                ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
                )
                ELSE
                (
                CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
                ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
                ELSE
                DUE_DATE
                END
                )
                END AS DUE_DATE,
                <cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
                CASE WHEN (ACTION_TYPE_ID = 241) THEN
                ACTION_DATE
                ELSE
                DUE_DATE	
                END AS DUE_DATE,
                <cfelse>
                DUE_DATE,	
                </cfif>
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
                <cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                FROM_CMP_ID = #attributes.company_id#
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                FROM_CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                FROM_EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                <cfelse>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                TO_CMP_ID = #attributes.company_id#
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                TO_CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                TO_EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                AND ACTION_TYPE_ID NOT IN (48,49,46,45) 
                AND	OTHER_CASH_ACT_VALUE > 0 
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                </cfif>
                <cfif isdefined("is_show_store_acts")> 
                <cfif is_show_store_acts eq 0>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>	
                </cfif>	
                <cfelse>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>
                </cfif>
                <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                AND PROJECT_ID = #attributes.project_id#
                <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
                AND PROJECT_ID IS NULL						
                </cfif>
                <cfif isdefined("attributes.is_pay_cheques")>
                AND
                (
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                )
                <cfelse>
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                </cfif>
                <cfif isdefined("attributes.is_pay_bankorders")>
                AND
                (
                CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
                OR
                CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
                )
                </cfif>
                ORDER BY
                <cfif isdefined("attributes.is_cheque_duedate")>
                CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
                (
                ISNULL(ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
                )
                ELSE
                (
                CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
                ISNULL(ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
                ELSE
                ISNULL(DUE_DATE,ACTION_DATE)
                END
                )
                END
                <cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
                CASE WHEN (ACTION_TYPE_ID = 241) THEN
                ACTION_DATE
                ELSE
                ISNULL(DUE_DATE,ACTION_DATE)	
                END
                <cfelse>
                ISNULL(DUE_DATE,ACTION_DATE)
                </cfif>
            </cfquery>
            <cfquery name="get_invoice" datasource="#DSN2#">
                SELECT 
                ACTION_VALUE TOTAL,
                OTHER_CASH_ACT_VALUE OTHER_MONEY_VALUE,
                OTHER_MONEY,
                PAPER_NO INVOICE_NUMBER,
                ACTION_DATE OLD_ACTION_DATE,
                ISNULL(PAPER_ACT_DATE,ACTION_DATE) INVOICE_DATE,
                ACTION_TYPE_ID,
                PROJECT_ID,
                ACTION_NAME,
                <cfif isdefined("attributes.is_cheque_duedate")>
                <!--- Çek ve senetler tahsil tarihlerine göre hesaplansın seçiliyse --->
                CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
                (
                ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
                )
                ELSE
                (
                CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
                ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE)
                ELSE
                DUE_DATE
                END
                )
                END AS DUE_DATE,
                <cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
                CASE WHEN (ACTION_TYPE_ID = 241) THEN
                ACTION_DATE
                ELSE
                DUE_DATE	
                END AS DUE_DATE,
                <cfelse>
                DUE_DATE,	
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                (ACTION_VALUE/ISNULL(OTHER_CASH_ACT_VALUE,ACTION_VALUE)) INV_RATE,
                <cfelse>
                1 INV_RATE,
                </cfif>
                CARI_ACTION_ID,
                ACTION_TABLE,
                PROCESS_CAT
                FROM
                CARI_ROWS
                WHERE

                <cfif isDefined("attributes.is_doviz_group")>
                OTHER_CASH_ACT_VALUE > 0
                AND ACTION_TYPE_ID NOT IN (48,49,46,45) 
                <cfelse>
                ACTION_VALUE > 0
                </cfif>
                <cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                AND TO_CMP_ID = #attributes.company_id# 
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                AND TO_CONSUMER_ID = #attributes.consumer_id# 
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                AND TO_EMPLOYEE_ID = #attributes.employee_id# 
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                <cfelse>
                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                AND FROM_CMP_ID = #attributes.company_id# 
                <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                AND FROM_CONSUMER_ID = #attributes.consumer_id# 
                <cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id)>
                AND FROM_EMPLOYEE_ID = #attributes.employee_id# 
                </cfif>
                <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                AND ISNULL(ACC_TYPE_ID,0) = #attributes.acc_type_id#
                </cfif>
                </cfif>
                <cfif isDefined("attributes.is_doviz_group")>
                AND OTHER_MONEY = '#GET_SETUP_MONEY.MONEY#'
                </cfif>
                <cfif isdefined("is_show_store_acts")> 
                <cfif is_show_store_acts eq 0>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>	
                </cfif>	
                <cfelse>
                <cfif session.ep.isBranchAuthorization>
                AND	(FROM_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# OR TO_BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                </cfif>
                </cfif>
                <cfif isdefined('attributes.project_id') and isDefined("attributes.project_head") and len(attributes.project_head) and len(attributes.project_id)>
                AND PROJECT_ID = #attributes.project_id#
                <cfelseif isdefined('attributes.project_id') and not len(attributes.project_id) and isdefined("attributes.is_ajax_popup") and isdefined("attributes.is_project_group") and attributes.is_project_group eq 1>
                AND PROJECT_ID IS NULL						
                </cfif>
                <cfif isdefined("attributes.is_pay_cheques")>
                AND
                (
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT CH.ACT_DATE FROM CHEQUE_HISTORY CH,CHEQUE C WHERE CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.STATUS IN(3,7)) AND C.CHEQUE_ID = CARI_ROWS.ACTION_ID AND C.CHEQUE_ID = CH.CHEQUE_ID AND C.CHEQUE_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR
                (	
                CARI_ROWS.ACTION_TABLE = 'CHEQUE' 
                AND CARI_ROWS.ACTION_ID IN (SELECT CHEQUE_ID FROM CHEQUE WHERE CHEQUE_ID = CARI_ROWS.ACTION_ID AND CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT C.CHEQUE_DUEDATE FROM CHEQUE C WHERE C.CHEQUE_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID IN (3,7))
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT VH.ACT_DATE FROM VOUCHER_HISTORY VH,VOUCHER V WHERE VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.STATUS IN(3,7)) AND V.VOUCHER_ID = CARI_ROWS.ACTION_ID AND V.VOUCHER_ID = VH.VOUCHER_ID AND V.VOUCHER_STATUS_ID IN (3,7)) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE = 'VOUCHER' 
                AND CARI_ROWS.ACTION_ID IN (SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_ID = CARI_ROWS.ACTION_ID AND VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">)
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                AND (SELECT V.VOUCHER_DUEDATE FROM VOUCHER V WHERE V.VOUCHER_ID = CARI_ROWS.ACTION_ID) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                OR 
                (
                CARI_ROWS.ACTION_TABLE <> 'CHEQUE' 
                AND CARI_ROWS.ACTION_TABLE <> 'VOUCHER' 
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                )
                )
                <cfelse>
                <cfif is_make_age_date>
                <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                </cfif>
                <cfif isdefined("attributes.date2") and isdate(attributes.date2)>	
                AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                </cfif>
                </cfif>
                </cfif>
                <cfif isdefined("attributes.is_pay_bankorders")>
                AND
                (
                CARI_ROWS.ACTION_TYPE_ID IN (250,251) AND CARI_ROWS.ACTION_ID IN (SELECT BANK_ORDER_ID FROM BANK_ORDERS WHERE IS_PAID = 1)
                OR
                CARI_ROWS.ACTION_TYPE_ID NOT IN (250,251)
                )
                </cfif>
                ORDER BY
                <cfif isdefined("attributes.is_cheque_duedate")>
                CASE WHEN (ACTION_TABLE = 'CHEQUE') THEN 
                (
                ISNULL(ISNULL((SELECT ACT_DATE FROM CHEQUE_HISTORY WHERE STATUS = 3 AND CHEQUE_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
                )
                ELSE
                (
                CASE WHEN (ACTION_TABLE = 'VOUCHER') THEN 
                ISNULL(ISNULL((SELECT ACT_DATE FROM VOUCHER_HISTORY WHERE STATUS = 3 AND VOUCHER_ID = CARI_ROWS.ACTION_ID AND HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = CARI_ROWS.ACTION_ID)),DUE_DATE),ACTION_DATE)
                ELSE
                ISNULL(DUE_DATE,ACTION_DATE)
                END
                )
                END
                <cfelseif isdefined("is_revenue_duedate") and is_revenue_duedate eq 1>
                CASE WHEN (ACTION_TYPE_ID = 241) THEN
                ACTION_DATE
                ELSE
                ISNULL(DUE_DATE,ACTION_DATE)	
                END 
                <cfelse>
                ISNULL(DUE_DATE,ACTION_DATE)
                </cfif>
            </cfquery>
            <cfset process_cat_id_list = ''>
            <cfif isdefined('attributes.list_type') and listfind(attributes.list_type,7)>
                <cfoutput query="get_revenue">
                    <cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
                        <cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
                    </cfif>
                </cfoutput>
                <cfoutput query="get_invoice">
                    <cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
                        <cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
                    </cfif>
                </cfoutput>  	
                <cfif len(process_cat_id_list)>
                <cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
                    <cfquery name="get_process_cat" datasource="#DSN3#">
                        SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
                    </cfquery>
                    <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
                </cfif>
            </cfif>
            <cfset row_of_query = 0>
            <cfset row_of_query_2 = 0>
            <cfset ALL_INVOICE = QueryNew("INVOICE_NUMBER,TOTAL_SUB,TOTAL_OTHER_SUB,T_OTHER_MONEY,INVOICE_DATE,OLD_ACTION_DATE,ROW_COUNT,DUE_DATE,INV_RATE,ACTION_TYPE_ID,PROJECT_ID,CARI_ACTION_ID,ACTION_TABLE,PROCESS_CAT","VarChar,Double,Double,VarChar,Date,Date,integer,Date,Double,integer,integer,integer,VarChar,integer")>
            <cfoutput query="get_invoice">
                <cfscript>
                    tarih_inv = CreateODBCDateTime(get_invoice.INVOICE_DATE);
                    total_pesin = 0;
                    en_genel_toplam = 0;
                    kalan_pesin = TOTAL - total_pesin;
                    en_genel_toplam = en_genel_toplam + total_pesin;

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
            </cfoutput>
            <!--- //Hesaplamalar --->
            <cfif GET_REVENUE.recordcount and get_invoice.recordcount>
                <cfset TOPLAM_VALUE = 0>
                <cfset TOPLAM_GUN_TUTARLARI=0>
                <cfset TOPLAM_AGIRLIK=0>
                <cfset TOPLAM_AGIRLIK_AVG=0>
                <cfset total_money=0>
                <cfset total_kur_farki=0>
                <cfset cari_toplam_tutar=0>
                <cfset cari_toplam_islem_tutar=0>
                <cfif GET_REVENUE.recordcount>
                    <cfoutput query="GET_REVENUE">
                        <cfif isDefined("attributes.is_doviz_group")>
                            <cfset TOPLAM_VALUE = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                            <cfset TOPLAM_VALUE_ = GET_REVENUE.OTHER_MONEY_VALUE[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                        <cfelse>
                            <cfset TOPLAM_VALUE = GET_REVENUE.TOTAL[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                            <cfset TOPLAM_VALUE_ = GET_REVENUE.TOTAL[currentrow]><!--- adim adim fatura tutarlari kadar indirilecek tahsilat tutari --->
                        </cfif>
                        <cfquery name="GET_INV_RECORD" dbtype="query">
                            SELECT
                                TOTAL_SUB,
                                TOTAL_OTHER_SUB,
                                INVOICE_NUMBER,
                                INVOICE_DATE,
                                T_OTHER_MONEY,
                                ROW_COUNT,
                                DUE_DATE,
                                INV_RATE,
                                ACTION_TYPE_ID,
                                PROJECT_ID,
                                PROCESS_CAT
                            FROM
                                ALL_INVOICE
                            WHERE
                                <cfif isDefined("attributes.is_doviz_group")>
                                    TOTAL_OTHER_SUB IS NOT NULL AND 
                                    TOTAL_OTHER_SUB <> 0
                                <cfelse>
                                    TOTAL_SUB IS NOT NULL AND 
                                    TOTAL_SUB <> 0
                                </cfif>
                            ORDER BY
                                DUE_DATE
                        </cfquery>
                        <cfif GET_INV_RECORD.recordcount>
                            <cfset a_index=0>
                            <cfloop condition="a_index lt GET_INV_RECORD.recordcount">
                                <cfset a_index=a_index+1>
                                <cfif isDefined("attributes.is_doviz_group")>
                                    <cfset TOPLAM_VALUE_ = TOPLAM_VALUE_ - GET_INV_RECORD.TOTAL_OTHER_SUB[a_index] >
                                <cfelse>
                                    <cfset TOPLAM_VALUE_ = TOPLAM_VALUE_ - GET_INV_RECORD.TOTAL_SUB[a_index] >
                                </cfif>
                                <cfif not TOPLAM_VALUE_ gt 0>
                                    <cfbreak>
                                </cfif>
                            </cfloop>
                        </cfif>
                        <cfset a_index = a_index+1>

                        <cfif len(GET_REVENUE.OTHER_MONEY_VALUE[currentrow]) and GET_REVENUE.OTHER_MONEY_VALUE[currentrow] gt 0>
                            <cfset kur_cari_row = wrk_round(GET_REVENUE.TOTAL[currentrow]/GET_REVENUE.OTHER_MONEY_VALUE[currentrow],4)>
                        <cfelse>
                            <cfset kur_cari_row = 0>
                        </cfif>

                        <!---<td colspan="<cfif isDefined("attributes.is_doviz_group")>9<cfelse>8</cfif>">--->
                        <cfquery name="GET_INV_RECORD" dbtype="query">
                            SELECT
                                TOTAL_SUB,
                                TOTAL_OTHER_SUB,
                                INVOICE_NUMBER,
                                INVOICE_DATE,
                                T_OTHER_MONEY,
                                ROW_COUNT,
                                DUE_DATE,
                                INV_RATE,
                                ACTION_TYPE_ID,
                                PROJECT_ID,
                                PROCESS_CAT
                            FROM
                                ALL_INVOICE
                            WHERE
                                <cfif isDefined("attributes.is_doviz_group")>
                                    TOTAL_OTHER_SUB IS NOT NULL AND 
                                    TOTAL_OTHER_SUB <> 0
                                <cfelse>
                                    TOTAL_SUB IS NOT NULL AND 
                                    TOTAL_SUB <> 0
                                </cfif>
                            ORDER BY
                                DUE_DATE
                        </cfquery> 
                        <!--- <table width="100%">sfdfd --->
                        <cfif GET_INV_RECORD.recordcount>
                            <cfset i_index=0>
                            <cfloop condition="i_index lt GET_INV_RECORD.recordcount">
                                <cfset i_index=i_index+1>
                                <!--- Vade Tarihi Farkı/Gun --->
                                <cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                    <cfif GET_COMP_REMAINDER.BAKIYE	gt 0>
                                        <cfset GUN_FARKI = DateDiff("d",GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.DUE_DATE[i_index])>
                                    <cfelse>
                                        <cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                    </cfif>
                                <cfelse>
                                    <cfset GUN_FARKI = DateDiff("d",GET_INV_RECORD.DUE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
                                </cfif>
                                <cfif len(GET_REVENUE.TO_branch_id)  and GET_COMP_REMAINDER.BAKIYE lte 0>
                                    <cfif len(GET_INV_RECORD.DUE_DATE[i_index])>
                                        <cfset GUN_FARKI_AVG = DateDiff("d",GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.DUE_DATE[i_index])>
                                    <cfelse>
                                        <cfset GUN_FARKI_AVG = DateDiff("d",GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow],GET_INV_RECORD.INVOICE_DATE[i_index])>
                                    </cfif>
                                <cfelse>
                                    <cfif len(GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                        <cfset GUN_FARKI_AVG = DateDiff("d",GET_INV_RECORD.INVOICE_DATE[i_index],GET_REVENUE.DUE_DATE[GET_REVENUE.currentrow])>
                                    <cfelse>
                                        <cfset GUN_FARKI_AVG = DateDiff("d",GET_INV_RECORD.INVOICE_DATE[i_index],GET_REVENUE.ACTION_DATE[GET_REVENUE.currentrow])>
                                    </cfif>
                                </cfif>
                                <cfif GUN_FARKI eq 0><cfset GUN_FARKI=1></cfif>
                                <cfif GUN_FARKI_AVG eq 0><cfset GUN_FARKI_AVG=1></cfif>
                                <cfset TOPLAM_TEMP = TOPLAM_VALUE>
                                <cfif isDefined("attributes.is_doviz_group")>
                                    <cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_OTHER_SUB[i_index] >
                                <cfelse>
                                    <cfset TOPLAM_VALUE = TOPLAM_VALUE - GET_INV_RECORD.TOTAL_SUB[i_index] >
                                </cfif>
                                <cfif TOPLAM_VALUE gt 0>
                                    <cfif isDefined("attributes.is_doviz_group")>
                                        <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]>
                                    <cfelse>
                                        <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]>
                                    </cfif>
                                <cfelse>
                                    <cfif isDefined("attributes.is_doviz_group")>
                                        <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]+TOPLAM_VALUE>
                                    <cfelse>
                                        <cfset GUN_TUTARI = GET_INV_RECORD.TOTAL_SUB[i_index]+TOPLAM_VALUE>
                                    </cfif>
                                </cfif>
                                <!--- vade agirlikli ortalama toplam hesabi --->
                                <cfset TOPLAM_GUN_TUTARLARI = TOPLAM_GUN_TUTARLARI + GUN_TUTARI><!--- gun tutarlari toplami --->
                                <cfset TOPLAM_AGIRLIK = TOPLAM_AGIRLIK + (GUN_TUTARI*GUN_FARKI)><!--- gun agirliklari toplami --->
                                <cfset TOPLAM_AGIRLIK_AVG = TOPLAM_AGIRLIK_AVG + (GUN_TUTARI*GUN_FARKI_AVG)><!--- gun agirliklari toplami --->
                                <cfif TOPLAM_VALUE gt 0>
                                    <cfif isDefined("attributes.is_doviz_group")>
                                        <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
                                    <cfelse>
                                        <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",0,GET_INV_RECORD.ROW_COUNT[i_index])>
                                    </cfif>
                                <cfelse>
                                    <cfif isDefined("attributes.is_doviz_group")>
                                        <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_OTHER_SUB",GET_INV_RECORD.TOTAL_OTHER_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
                                    <cfelse>
                                        <cfset INVOICE_TEMP = QuerySetCell(ALL_INVOICE,"TOTAL_SUB",GET_INV_RECORD.TOTAL_SUB[i_index]-TOPLAM_TEMP,GET_INV_RECORD.ROW_COUNT[i_index])>
                                    </cfif>
                                    <cfbreak>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </cfoutput>
                </cfif>
                <cfif (isdefined("attributes.detail_type") and ((len(attributes.detail_type) and attributes.detail_type eq 1) or not len(attributes.detail_type)) or not isdefined('attributes.detail_type'))>
                    <cfoutput>
                        <cfif TOPLAM_GUN_TUTARLARI neq 0>
                            <cfset VADE2 = WRK_ROUND(TOPLAM_AGIRLIK_AVG/TOPLAM_GUN_TUTARLARI)>
                        </cfif>
                    </cfoutput>
                </cfif>
            </cfif>
        </cfloop>
    </cfif>
</cfif>