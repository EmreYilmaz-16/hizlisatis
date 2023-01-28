<cffunction name="get_offer_list_fnc" returntype="query">
	<cfargument name="product_name" default="">
	<cfargument name="product_id" default="">
	<cfargument name="listing_type" default="">
	<cfargument name="offer_zone" default="">
	<cfargument name="keyword" default="">
    <cfargument name="keyword_offerno" default=""/>    
	<cfargument name="xml_offer_revision" default="">
	<cfargument name="OFFER_STATUS_CAT_ID" default="">
	<cfargument name="status" default="">
	<cfargument name="member_type" default="">
	<cfargument name="member_name" default="">
	<cfargument name="company_id" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="sales_emp_id" default="">
	<cfargument name="sales_partner" default="">
	<cfargument name="sales_partner_id" default="">
	<cfargument name="start_date" default="">
	<cfargument name="finish_date" default="">
	<cfargument name="sale_add_option" default="">
	<cfargument name="offer_stage" default="">
	<cfargument name="project_head" default="">
	<cfargument name="project_id" default="">
	<cfargument name="x_control_ims" default="">
	<cfargument name="x_multiple_filters" default="">
	<cfargument name="sales_emp" default="">
	<cfargument name="sort_type" default="4"/>
	<cfargument name="probability" default="">
	<cfargument name="sales_member_type" default=""/>
	<cfargument name="sales_member_name" default=""/>
	<cfargument name="sales_member_id" default=""/>
	<cfargument name="xml_sales_cari" default="">
	
    <cfset dsn_alias = this.dsn_alias>
	<cfif x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
		<cfinclude template="../../member/query/get_ims_control.cfm">
	</cfif>
    <cfquery name="GET_OFFER_LIST" datasource="#this.DSN3#">
        SELECT 
            <cfif (isdefined("arguments.product_name") and len(arguments.product_name) and len(arguments.product_id)) or (isDefined("arguments.listing_type") and arguments.listing_type eq 2)>
            DISTINCT
                OFR.UNIT,
                OFR.PRICE,
                OFR.PRODUCT_ID,
                OFR.PRODUCT_NAME,
                OFR.OTHER_MONEY,
                OFR.QUANTITY,
                OFR.OTHER_MONEY,
                OFR.IS_VIRTUAL,
                OFR.WRK_ROW_ID,
                OFR.STOCK_ID,
                S.STOCK_CODE,
                OFR.PRODUCT_ID,
                OFR.DISCOUNT_1,
                OFR.DISCOUNT_2,
                OFR.DISCOUNT_3,
                OFR.DISCOUNT_4,
                OFR.DISCOUNT_5,
                OFR.DISCOUNT_6,
                OFR.DISCOUNT_7,
                OFR.DISCOUNT_8,
                OFR.DISCOUNT_9,
                OFR.DISCOUNT_10,
               	ISNULL(OFR.EXTRA_PRICE_TOTAL,0) EXTRA_PRICE_TOTAL,
                ISNULL(OFR.DISCOUNT_COST,0) ROW_DISC_COST,
                OFR.OTHER_MONEY_VALUE,
                ISNULL((SELECT TOP 1 RATE2 FROM OFFER_MONEY WHERE ACTION_ID = OFR.OFFER_ID AND MONEY_TYPE = OFR.OTHER_MONEY COLLATE SQL_Latin1_General_CP1_CI_AI),1) RATE2,
            </cfif>	
          --  1 AS  RATE,
			ISNULL((SELECT TOP 1 RATE2 FROM OFFER_MONEY WHERE ACTION_ID = OFFER.OFFER_ID AND MONEY_TYPE = OFFER.OTHER_MONEY COLLATE SQL_Latin1_General_CP1_CI_AI ),1) RATE,
            OFFER.OFFER_ID,
            OFFER.CONSUMER_ID,
            OFFER.PARTNER_ID,
            OFFER.COMPANY_ID,		
            OFFER.OFFER_TO,
            OFFER.OFFER_TO_PARTNER,
            OFFER.SALES_EMP_ID,
            OFFER.SALES_PARTNER_ID,
			OFFER.SALES_CONSUMER_ID,
            OFFER.OFFER_NUMBER,
            OFFER.RECORD_DATE,
            OFFER.OFFER_HEAD,
            OFFER.PRICE,
            OFFER.OFFER_DESCRIPTION,
            OFFER.OTHER_MONEY,
            OFFER.OTHER_MONEY_VALUE,
            OFFER.OFFER_STATUS,
            OFFER.COMMETHOD_ID,
            OFFER.RECORD_MEMBER,
            OFFER.OFFER_CURRENCY,
            OFFER.OFFER_ZONE,
            OFFER.OFFER_DATE,
            OFFER.OFFER_STAGE,
            OFFER.PROJECT_ID,
            OFFER.OFFER_REVIZE_NO,
            OFFER.OPP_ID,
			OFFER.PROBABILITY,
            ISNULL(OFFER.NETTOTAL,0) NETTOTAL,
            ISNULL(OFFER.TAX,0) TAX,
            ISNULL(OFFER.OTV_TOTAL,0) OTV_TOTAL
        FROM 
            PBS_OFFER AS OFFER LEFT JOIN #this.dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = OFFER.PROJECT_ID
				  LEFT JOIN #this.dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = OFFER.SALES_EMP_ID	
				  LEFT JOIN #this.dsn_alias#.EMPLOYEES EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = OFFER.RECORD_MEMBER	
          <cfif (isdefined("arguments.product_name") and len(arguments.product_name) and len(arguments.product_id)) or (isDefined("arguments.listing_type") and arguments.listing_type eq 2)>
            ,PBS_OFFER_ROW OFR LEFT JOIN STOCKS S ON S.STOCK_ID = OFR.STOCK_ID 
          </cfif>		
        WHERE 1=1  
       <cfif isdefined("arguments.offer_zone") and 1 eq 0>
            <cfif not len(arguments.offer_zone)>
                AND   ( (OFFER.PURCHASE_SALES = 1 AND OFFER.OFFER_ZONE = 0)	OR (OFFER.PURCHASE_SALES = 0 AND OFFER.OFFER_ZONE = 1) )
            <cfelseif not arguments.offer_zone>
                AND   (OFFER.PURCHASE_SALES = 1 AND OFFER.OFFER_ZONE = 0)
            <cfelseif arguments.offer_zone>
                AND  (OFFER.PURCHASE_SALES = 0 AND OFFER.OFFER_ZONE = 1)
            </cfif>
        <cfelse>
            AND   ( (OFFER.PURCHASE_SALES = 1 AND OFFER.OFFER_ZONE = 0) OR (OFFER.PURCHASE_SALES = 0 AND OFFER.OFFER_ZONE = 1) )
        </cfif>
		<cfif isdefined("arguments.probability") and len(arguments.probability)>
			AND OFFER.PROBABILITY = #arguments.probability#
		</cfif>
        <cfif (isdefined("arguments.product_name") and len(arguments.product_name) and len(arguments.product_id)) or (isDefined("arguments.listing_type") and arguments.listing_type eq 2)>
            AND OFR.OFFER_ID = OFFER.OFFER_ID
            <cfif isdefined("arguments.product_name") and len(arguments.product_name) and len(arguments.product_id)>
                AND OFR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfif>
        </cfif>
           <cfif len(arguments.keyword)> 
            AND (OFFER.OFFER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                 OR OFFER.REF_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                 OR OFFER.OFFER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                <cfif isdefined('arguments.xml_offer_revision') and arguments.xml_offer_revision eq 1>
                    OR OFFER.OFFER_REVIZE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                )
          </cfif>
		<cfif arguments.x_multiple_filters eq 1 and isDefined("arguments.keyword_offerno") and len(arguments.keyword_offerno)>
        	AND OFFER.OFFER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.keyword_offerno)#">
        </cfif>

		<cfif isdefined("arguments.OFFER_STATUS_CAT_ID") and len(arguments.OFFER_STATUS_CAT_ID)>
        	AND OFFER.OFFER_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_status_cat_id#">
      	</cfif>
        <cfif isdefined("arguments.status") and len(arguments.status)>
            AND OFFER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.status#">
        </cfif>
        <cfif isdefined("arguments.member_type") and len(arguments.member_type) and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
            AND OFFER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfif>
        <cfif isdefined("arguments.member_type") and len(arguments.member_type) and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
            AND OFFER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
        </cfif>
         <cfif isdefined("arguments.sales_emp_id") and len(arguments.sales_emp_id) and isdefined("arguments.sales_emp") and  len(arguments.sales_emp)>
            AND OFFER.SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_emp_id#">
        </cfif>
        <cfif isdefined('arguments.start_date') and len(arguments.start_date)>
            AND OFFER.OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
        </cfif>
        <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
            AND OFFER.OFFER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
        </cfif>
       <cfif isdefined('arguments.sale_add_option') and len(arguments.sale_add_option)> 
            AND OFFER.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sale_add_option#">
        </cfif>
        <cfif isdefined('arguments.offer_stage') and len(arguments.offer_stage)> 
            AND OFFER.OFFER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_stage#">
        </cfif>
        <cfif isdefined("arguments.project_id") and len (arguments.project_id) and isdefined("arguments.project_head") and len (arguments.project_head)>
            AND OFFER.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfif>
		<cfif isdefined("arguments.sales_member_type") and (arguments.sales_member_type is 'consumer') and len(arguments.sales_member_id) and len(arguments.sales_member_name)>
			AND OFFER.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_member_id#">
		</cfif>
		<cfif isdefined("arguments.sales_member_type") and (arguments.sales_member_type is 'partner') and len(arguments.sales_member_id) and len(arguments.sales_member_name)>
			<cfif isdefined("arguments.xml_sales_cari") and arguments.xml_sales_cari eq 1>
				AND OFFER.SALES_PARTNER_ID IN 
						(SELECT 
							CP.PARTNER_ID
						FROM 
							#dsn_alias#.COMPANY_PARTNER CP,
							#dsn_alias#.COMPANY C
						WHERE 
							CP.COMPANY_ID = C.COMPANY_ID AND
							C.COMPANY_ID IN (SELECT CP.COMPANY_ID FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_member_id#">)
						)
			<cfelse>
				AND OFFER.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_member_id#">
			</cfif>
		</cfif>
        <cfif isdefined("arguments.x_control_ims") and arguments.x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
            AND
                (
                (OFFER.CONSUMER_ID IS NULL AND OFFER.COMPANY_ID IS NULL ) 
                OR ( OFFER.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) )
                OR ( OFFER.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
                )
        </cfif>
       ORDER BY
			<cfif arguments.sort_type eq 1>
				OFFER.DELIVERDATE ASC
			<cfelseif arguments.sort_type eq 2>
				OFFER.DELIVERDATE DESC
			<cfelseif arguments.sort_type eq 3>
				OFFER.OFFER_DATE ASC
			<cfelseif arguments.sort_type eq 4>
				OFFER.OFFER_DATE DESC
			<cfelseif arguments.sort_type eq 5>
				E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME ASC
			<cfelseif arguments.sort_type eq 6>
				E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME DESC
			<cfelseif arguments.sort_type eq 7>
				PP.PROJECT_HEAD ASC
			<cfelseif arguments.sort_type eq 8>
				PP.PROJECT_HEAD DESC
			<cfelseif arguments.sort_type eq 9>
				LEFT(OFFER.OFFER_NUMBER,2) ASC
			<cfelseif arguments.sort_type eq 10>
                CASE WHEN (CHARINDEX('-',OFFER.OFFER_NUMBER) = 0) THEN OFFER.OFFER_NUMBER ELSE CAST(SUBSTRING(OFFER.OFFER_NUMBER, (CHARINDEX('-', OFFER.OFFER_NUMBER) +1), LEN(OFFER.OFFER_NUMBER) ) as int) END DESC
			<cfelseif arguments.sort_type eq 11>
				EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME ASC
			<cfelseif arguments.sort_type eq 12>
				EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME DESC
			<cfelseif arguments.sort_type eq 13>
				OFFER.NETTOTAL ASC
			<cfelseif arguments.sort_type eq 14>
				OFFER.NETTOTAL DESC
			<cfelse>
				OFFER.OFFER_ID DESC
			</cfif>
            <cfif arguments.listing_type eq 2>
                , OFFER_ID
            </cfif>
    </cfquery>
    <cfreturn GET_OFFER_LIST>
</cffunction>
