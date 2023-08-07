<cfquery name="GET_ORDER_LIST" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		ORDERS.ORDER_ID,
		<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
		ORR.PRODUCT_NAME2,
		ORR.ORDER_ROW_ID,
		ORR.ORDER_ROW_CURRENCY,
		ORR.PRODUCT_ID,
		ORR.STOCK_ID,
		ISNULL(ORR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
		ORR.QUANTITY,
		ISNULL(ORR.CANCEL_AMOUNT,0) AS CANCEL_AMOUNT,
		ORR.RESERVE_TYPE,
		ISNULL(ORR.DELIVER_DATE,ORDERS.DELIVERDATE) AS SATIR_TESLIM,
		ORR.WRK_ROW_ID,
		ORR.UNIQUE_RELATION_ID,
		ORR.PRODUCT_NAME,
		ORR.WRK_ROW_RELATION_ID,

		ORR.NETTOTAL ROW_NETTOTAL,
		S.MANUFACT_CODE PRODUCT_MANUFACT_CODE,
		S.PRODUCT_CODE AS STOCK_CODE,
		S.PRODUCT_CODE_2,
		ORR.SPECT_VAR_NAME,
		ORD.DEPARTMENT_ID AS DELIVER_DEPT,
		ORD.LOCATION_ID,
		ISNULL(ORR.DELIVER_DATE,ORDERS.DELIVERDATE),
		ORR.PRODUCT_NAME2,
		PROJECT_HEAD = ISNULL((SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE ORR.ROW_PROJECT_ID  = PP.PROJECT_ID),(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE ORDERS.PROJECT_ID  = PP.PROJECT_ID)),
		<cfelse>
		ORDERS.DELIVER_DEPT_ID AS DELIVER_DEPT,
		ORDERS.LOCATION_ID,
		ORDERS.DELIVERDATE DELIVER_DATE,
		</cfif>
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.COMPANY_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_DATE,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.NETTOTAL,
		ORDERS.TAXTOTAL,		
		ORDERS.GROSSTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.RECORD_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		ORDERS.DELIVER_DEPT_ID,
		PROJECT_HEAD = (SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE ORDERS.PROJECT_ID  = PP.PROJECT_ID),
		EMP.EMPLOYEE_NAME, 
		EMP.EMPLOYEE_EMAIL, 
		EMP.EMPLOYEE_SURNAME	
	FROM 
		ORDERS,
		/* LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON ORDERS.PROJECT_ID  = PP.PROJECT_ID, */
		ORDER_ROW ORR
		LEFT JOIN ORDER_ROW_DEPARTMENTS ORD ON ORD.ORDER_ROW_ID= ORR.ORDER_ROW_ID,
		STOCKS S,
		#dsn_alias#.EMPLOYEES AS EMP
	WHERE	
		ORR.STOCK_ID = S.STOCK_ID AND	
		ORDERS.ORDER_ID = ORR.ORDER_ID AND
		ORDERS.ORDER_STATUS = 1 
		<cfif not isdefined("attributes.is_return") or (isdefined("attributes.is_return") and attributes.is_return eq 0)>
			AND(
				( ORR.ORDER_ROW_CURRENCY IN (-6,-7) AND ORDERS.IS_PROCESSED = 1 ) OR
				( ORR.ORDER_ROW_CURRENCY = -6 AND ORDERS.IS_PROCESSED = 0 )
			)
		<cfelseif (isdefined("attributes.is_return") and attributes.is_return eq 1)>
			AND ORR.ORDER_ROW_CURRENCY IN (-10,-7,-8,-3)
		</cfif>
		AND ORDERS.RECORD_EMP = EMP.EMPLOYEE_ID 
		<cfif len(attributes.department_id)>
        	<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
				AND ORD.DEPARTMENT_ID = #attributes.department_id#
            <cfelse>
				AND ORDERS.DELIVER_DEPT_ID = #attributes.department_id#
            </cfif>
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and  isdefined ("attributes.project_head")and len(attributes.project_head)>
			AND ORDERS.PROJECT_ID =#attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and  isdefined ("attributes.subscription_no")and len(attributes.subscription_no)>
			AND ORDERS.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
		AND	ORDERS.PURCHASE_SALES = 0
		AND ORDERS.ORDER_ZONE = 0 
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				EMP.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
				EMP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR
				ORDERS.ORDER_NUMBER LIKE '%#attributes.keyword#%' OR
				ORR.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
				S.STOCK_CODE LIKE '%#attributes.keyword#%' OR
				S.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
				S.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%' OR
				S.MANUFACT_CODE LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif isDefined("attributes.product_name") and len(attributes.product_name) and isDefined("attributes.product_id") and len(attributes.product_id)>
			AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			AND ORDERS.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND ORDERS.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif isdefined('attributes.list_type') and attributes.list_type eq 2>
			<cfif isdefined("attributes.order_detail") and len(attributes.order_detail)>
				AND ORR.PRODUCT_NAME2 LIKE '%#attributes.order_detail#%'
			</cfif>
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ORDERS.ORDER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND ORDERS.ORDER_DATE >= #attributes.start_date#
		<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND ORDERS.ORDER_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and isdefined('attributes.spect_name') and len(attributes.spect_name)>
			AND ORR.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = #attributes.spect_main_id#)
		</cfif>
		ORDER BY
			<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
				<cfif attributes.sort_type eq 1>
					ISNULL(ORR.DELIVER_DATE,ORDERS.DELIVERDATE) ASC
				<cfelseif attributes.sort_type eq 2>
					ISNULL(ORR.DELIVER_DATE,ORDERS.DELIVERDATE) DESC
				<cfelseif attributes.sort_type eq 3>
					ORDERS.ORDER_DATE ASC
				<cfelseif attributes.sort_type eq 4>
					ORDERS.ORDER_DATE DESC
				</cfif>
			<cfelse>
				<cfif attributes.sort_type eq 1>
					ORDERS.DELIVERDATE ASC
				<cfelseif attributes.sort_type eq 2>
					ORDERS.DELIVERDATE DESC
				<cfelseif attributes.sort_type eq 3>
					ORDERS.ORDER_DATE ASC
				<cfelseif attributes.sort_type eq 4>
					ORDERS.ORDER_DATE DESC
				</cfif>
			</cfif>
</cfquery>
