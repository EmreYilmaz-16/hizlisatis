<cfquery name="OFFER" datasource="#DSN3#">
	SELECT 
    	OFFER_ID, 
        OPP_ID, 
        OFFER_NUMBER, 
        OFFER_STATUS, 
        OFFER_CURRENCY, 
        PURCHASE_SALES, 
        OFFER_ZONE, 
        PRIORITY_ID, 
        OFFER_HEAD, 
        OFFER_DETAIL, 
        GUEST, 
        COMPANY_CAT, 
        CONSUMER_CAT, 
        OFFER_TO, 
        OFFER_TO_PARTNER, 
        OFFER_TO_CONSUMER, 
        CONSUMER_ID, 
        COMPANY_ID, 
        PARTNER_ID, 
        EMPLOYEE_ID, 
        SALES_PARTNER_ID, 
        SALES_CONSUMER_ID, 
        NETTOTAL, 
        STARTDATE, 
        FINISHDATE, 
        DELIVERDATE, 
        DELIVER_PLACE, 
        LOCATION_ID, 
        PRICE, 
        TAX, 
        OTV_TOTAL, 
        OTHER_MONEY, 
        OTHER_MONEY_VALUE, 
        PAYMETHOD, 
        COMMETHOD_ID, 
        IS_PROCESSED, 
        IS_PARTNER_ZONE, 
        IS_PUBLIC_ZONE, 
        INCLUDED_KDV, 
        OFFER_STAGE, 
        REF_COMPANY_ID, 
        REF_PARTNER_ID, 
        REF_CONSUMER_ID, 
        SHIP_METHOD, 
        SHIP_ADDRESS, 
        PROJECT_ID, 
        WORK_ID, 
        FOR_OFFER_ID, 
        SHIP_DATE, 
        OFFER_DATE, 
        OFFER_FINISHDATE, 
        DUE_DATE, 
        REF_NO, 
        CITY_ID, 
        COUNTY_ID, 
        CARD_PAYMETHOD_ID, 
        CARD_PAYMETHOD_RATE, 
        SALES_ADD_OPTION_ID, 
        SALES_EMP_ID, 
        CAMP_ID, 
        RELATION_OFFER_ID, 
        OFFER_REVIZE_NO, 
        RECORD_MEMBER, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_PAR, 
        RECORD_CONS, 
        UPDATE_MEMBER, 
        UPDATE_DATE, 
        UPDATE_IP, 
        COUNTRY_ID, 
        SZ_ID 
    FROM 
	    PBS_OFFER 
    WHERE 
    	OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfquery name="OFFER_ROWS" datasource="#DSN3#">
	SELECT * FROM PBS_OFFER_ROW WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfif len(offer.startdate)>
	<cfset attributes.history_start_date = dateformat(offer.startdate,dateformat_style)>
	<cf_date tarih="attributes.history_start_date">
</cfif>
<cfif len(offer.deliverdate)>
	<cfset attributes.history_deliver_date = dateformat(offer.deliverdate,dateformat_style)>
	<cf_date tarih="attributes.history_deliver_date">
</cfif>
<cfif len(offer.finishdate)>
	<cfset attributes.history_finish_date = dateformat(offer.finishdate,dateformat_style)>
	<cf_date tarih="attributes.history_finish_date">
</cfif>
<cfif len(offer.offer_date)>
	<cfset attributes.history_offer_date = dateformat(offer.offer_date,dateformat_style)>
	<cf_date tarih="attributes.history_offer_date">
</cfif>
<cfquery name="ADD_OFFER_HISTORY" datasource="#DSN3#">
	INSERT INTO
	PBS_OFFER_HISTORY
	(
		OFFER_ID,
		OPP_ID,
		OFFER_NUMBER,
		OFFER_STATUS,
		OFFER_CURRENCY,
		PURCHASE_SALES,
		OFFER_ZONE,
		PRIORITY_ID,
		OFFER_HEAD,
		OFFER_DETAIL,
		GUEST,
		COMPANY_CAT,
		CONSUMER_CAT,
		OFFER_TO,
		OFFER_TO_PARTNER,
		CONSUMER_ID,
		COMPANY_ID,
		PARTNER_ID,
		EMPLOYEE_ID,
		SALES_PARTNER_ID,
		SALES_CONSUMER_ID,
		SALES_EMP_ID,
		NETTOTAL,
		OFFER_DATE,
		STARTDATE,
		DELIVERDATE,
		DELIVER_PLACE,
		FINISHDATE,
		PRICE,
		TAX,
		OTV_TOTAL,
		OTHER_MONEY,
		CARD_PAYMETHOD_ID,
		CARD_PAYMETHOD_RATE,
		PAYMETHOD,
		COMMETHOD_ID,
		IS_PROCESSED,
		IS_PARTNER_ZONE,
		IS_PUBLIC_ZONE,
		INCLUDED_KDV,
		SHIP_METHOD,
		SHIP_ADDRESS,
		PROJECT_ID,
		RELATION_OFFER_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		OFFER_STAGE		
	)
	VALUES
	(
		#attributes.offer_id#,
		<cfif len(offer.opp_id)>#offer.opp_id#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.offer_number#">,
		#offer.offer_status#,
		<cfif len(offer.offer_currency)>#offer.offer_currency#<cfelse>NULL</cfif>,
		#offer.purchase_sales#,
		#offer.offer_zone#,
		<cfif len(offer.priority_id)>#offer.priority_id#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.offer_head#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.offer_detail#">,
		<cfif len(offer.guest)>#offer.guest#<cfelse>NULL</cfif>,
		<cfif len(offer.company_cat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.company_cat#"><cfelse>NULL</cfif>,
		<cfif len(offer.consumer_cat)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.consumer_cat#"><cfelse>NULL</cfif>,
		<cfif len(offer.offer_to)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.offer_to#"><cfelse>NULL</cfif>,
		<cfif len(offer.offer_to_partner)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.offer_to_partner#"><cfelse>NULL</cfif>,
		<cfif len(offer.consumer_id)>#offer.consumer_id#<cfelse>NULL</cfif>,
		<cfif len(offer.company_id)>#offer.company_id#<cfelse>NULL</cfif>,
		<cfif len(offer.partner_id)>#offer.partner_id#<cfelse>NULL</cfif>,
		<cfif len(offer.employee_id)>#offer.employee_id#<cfelse>NULL</cfif>,
		<cfif len(offer.sales_partner_id)>#offer.SALES_PARTNER_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.sales_consumer_id)>#offer.SALES_CONSUMER_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.sales_emp_id)>#offer.SALES_EMP_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.nettotal)>#offer.NETTOTAL#<cfelse>NULL</cfif>,
		<cfif len(offer.offer_date)>#attributes.history_offer_date#<cfelse>NULL</cfif>,
		<cfif len(offer.startdate)>#attributes.history_start_date#<cfelse>NULL</cfif>,
		<cfif len(offer.deliverdate)>#attributes.history_deliver_date#<cfelse>NULL</cfif>,
		<cfif len(offer.deliver_place)>#offer.DELIVER_PLACE#<cfelse>NULL</cfif>,
		<cfif len(offer.finishdate)>#attributes.history_finish_date#,<cfelse>NULL,</cfif>
		<cfif len(offer.price)>#offer.PRICE#<cfelse>NULL</cfif>,
		<cfif len(offer.tax)>#offer.TAX#<cfelse>NULL</cfif>,
		<cfif len(offer.otv_total)>#offer.otv_total#<cfelse>NULL</cfif>,
		<cfif len(offer.other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.OTHER_MONEY#"><cfelse>NULL</cfif>,
		<cfif len(offer.CARD_PAYMETHOD_ID)>#offer.CARD_PAYMETHOD_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.CARD_PAYMETHOD_RATE)>#offer.CARD_PAYMETHOD_RATE#<cfelse>NULL</cfif>,
		<cfif len(offer.paymethod)>#offer.PAYMETHOD#<cfelse>NULL</cfif>,
		<cfif len(offer.commethod_id)>#offer.COMMETHOD_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.is_processed)>#offer.is_processed#<cfelse>NULL</cfif>,
		<cfif len(offer.is_partner_zone)>#offer.IS_PARTNER_ZONE#<cfelse>NULL</cfif>,
		<cfif len(offer.is_public_zone)>#offer.IS_PUBLIC_ZONE#<cfelse>NULL</cfif>,
		<cfif len(offer.included_kdv)>#offer.INCLUDED_KDV#<cfelse>NULL</cfif>,
		<cfif len(offer.ship_method)>#offer.SHIP_METHOD#<cfelse>NULL</cfif>,
		<cfif len(offer.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#OFFER.SHIP_ADDRESS#"><cfelse>NULL</cfif>,
		<cfif len(offer.project_id)>#offer.PROJECT_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.relation_offer_id)>#offer.relation_offer_id#<cfelse>NULL</cfif>,
		<cfif len(offer.update_member)>#offer.update_member#<cfelseif len(offer.record_member)>#offer.record_member#<cfelse>NULL</cfif>,
		<cfif len(offer.update_date)>#CreateODBCDateTime(offer.update_date)#<cfelseif len(offer.record_date)>#CreateODBCDateTime(offer.record_date)#<cfelse>NULL</cfif>,
		<cfif len(offer.update_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.update_ip#"><cfelseif len(offer.record_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#offer.record_ip#"><cfelse>NULL</cfif>,
		<cfif len (offer.offer_stage)>#offer.offer_stage#<cfelse>NULL</cfif>

	)
</cfquery>
<cfquery name="GET_OFFER_HISTORY_ID" datasource="#DSN3#">
	SELECT MAX(OFFER_HISTORY_ID) OFFER_HISTORY_ID FROM PBS_OFFER_HISTORY
</cfquery>
<cfloop query="offer_rows">
	<cfquery name="ADD_OFFER_ROW_HISTORY" datasource="#DSN3#">
		INSERT INTO
		PBS_OFFER_ROW_HISTORY
		(
			O_HISTORY_ID,
			OFFER_ID,
			OFFER_ROW_ID,
			PRODUCT_ID,
			STOCK_ID,
			QUANTITY,
			UNIT,
			PRICE,
			TAX,
			DUEDATE,
			PRODUCT_NAME,
			DESCRIPTION,
			PAY_METHOD_ID,
			PARTNER_ID,
			DELIVER_DATE,
			DELIVER_DEPT,
			DISCOUNT_1,
			DISCOUNT_2,
			DISCOUNT_3,
			DISCOUNT_4,
			DISCOUNT_5,
			DISCOUNT_6,
			DISCOUNT_7,
			DISCOUNT_8,
			DISCOUNT_9,
			DISCOUNT_10,
		<cfif len(DISCOUNT_COST)>
			DISCOUNT_COST,
		</cfif>
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			PRICE_OTHER,
			NET_MALIYET,
			MARJ,
			UNIQUE_RELATION_ID,
			PRODUCT_NAME2,
			AMOUNT2,
			UNIT2,
			EXTRA_PRICE,
			EXTRA_PRICE_TOTAL,
			EXTRA_PRICE_OTHER_TOTAL,
			SHELF_NUMBER,
			PRODUCT_MANUFACT_CODE,
			BASKET_EXTRA_INFO_ID,
			SELECT_INFO_EXTRA,
            DETAIL_INFO_EXTRA,
			LIST_PRICE,
			NUMBER_OF_INSTALLMENT,
			PRICE_CAT,
			CATALOG_ID,
			KARMA_PRODUCT_ID,
			OTV_ORAN,
			OTVTOTAL,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID
		)
		VALUES
		(
			#get_offer_history_id.offer_history_id#,
			#attributes.offer_id#,
			#OFFER_ROW_ID#,
			#PRODUCT_ID#,
			#STOCK_ID#,
			#QUANTITY#,
			<cfif len(UNIT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UNIT#"><cfelse>NULL</cfif>,
			<cfif len(PRICE)>#PRICE#<cfelse>NULL</cfif>,
			<cfif len(TAX)>#TAX#<cfelse>NULL</cfif>,
			<cfif len(DUEDATE)>#DUEDATE#<cfelse>NULL</cfif>,
			<cfif len(PRODUCT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_NAME#"><cfelse>NULL</cfif>,
			<cfif len(DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DESCRIPTION#"><cfelse>NULL</cfif>,
			<cfif len(PAY_METHOD_ID)>#PAY_METHOD_ID#<cfelse>NULL</cfif>,
			<cfif len(PARTNER_ID)>#PARTNER_ID#<cfelse>NULL</cfif>,
			<cfif len(DELIVER_DATE)>#createodbcdatetime(DELIVER_DATE)#<cfelse>NULL</cfif>,
			<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>NULL</cfif>,
			<cfif len(DISCOUNT_1)>#DISCOUNT_1#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_2)>#DISCOUNT_2#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_3)>#DISCOUNT_3#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_4)>#DISCOUNT_4#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_5)>#DISCOUNT_5#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_6)>#DISCOUNT_6#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_7)>#DISCOUNT_7#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_8)>#DISCOUNT_8#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_9)>#DISCOUNT_9#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_10)>#DISCOUNT_10#<cfelse>0</cfif>,
			<cfif len(DISCOUNT_COST)>#DISCOUNT_COST#,</cfif>
			<cfif len(OTHER_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#OTHER_MONEY#"><cfelse>NULL</cfif>,
			<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
			<cfif len(PRICE_OTHER)>#PRICE_OTHER#<cfelse>0</cfif>,
			<cfif len(NET_MALIYET)>#NET_MALIYET#<cfelse>0</cfif>,
			<cfif len(MARJ)>#MARJ#<cfelse>0</cfif>	,
			<cfif len(UNIQUE_RELATION_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UNIQUE_RELATION_ID#"><cfelse>NULL</cfif>,	
			<cfif len(PRODUCT_NAME2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_NAME2#"><cfelse>NULL</cfif>,
			<cfif len(AMOUNT2)>#AMOUNT2#<cfelse>NULL</cfif>,	
			<cfif len(UNIT2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#UNIT2#"><cfelse>NULL</cfif>,	
			<cfif len(EXTRA_PRICE)>#EXTRA_PRICE#<cfelse>NULL</cfif>,	
			<cfif len(EXTRA_PRICE_TOTAL)>#EXTRA_PRICE_TOTAL#<cfelse>NULL</cfif>,
			<cfif len(EXTRA_PRICE_OTHER_TOTAL)>#EXTRA_PRICE_OTHER_TOTAL#<cfelse>NULL</cfif>,	
			<cfif len(SHELF_NUMBER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#SHELF_NUMBER#"><cfelse>NULL</cfif>,
			<cfif len(PRODUCT_MANUFACT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_MANUFACT_CODE#"><cfelse>NULL</cfif>,
			<cfif len(BASKET_EXTRA_INFO_ID)>#BASKET_EXTRA_INFO_ID#<cfelse>NULL</cfif>,
			<cfif len(SELECT_INFO_EXTRA)>#SELECT_INFO_EXTRA#<cfelse>NULL</cfif>,
			<cfif len(DETAIL_INFO_EXTRA)>'#DETAIL_INFO_EXTRA#'<cfelse>NULL</cfif>,
			<cfif len(LIST_PRICE)>#LIST_PRICE#<cfelse>NULL</cfif>,
			<cfif len(NUMBER_OF_INSTALLMENT)>#NUMBER_OF_INSTALLMENT#<cfelse>NULL</cfif>,
			<cfif len(PRICE_CAT)>#PRICE_CAT#<cfelse>NULL</cfif>,
			<cfif len(CATALOG_ID)>#CATALOG_ID#<cfelse>NULL</cfif>,
			<cfif len(KARMA_PRODUCT_ID)>#KARMA_PRODUCT_ID#<cfelse>NULL</cfif>,
			<cfif len(OTV_ORAN)>#OTV_ORAN#<cfelse>NULL</cfif>,
			<cfif len(OTVTOTAL)>#OTVTOTAL#<cfelse>NULL</cfif>,
			<cfif len(WIDTH_VALUE)>#WIDTH_VALUE#<cfelse>NULL</cfif>,
			<cfif len(DEPTH_VALUE)>#DEPTH_VALUE#<cfelse>NULL</cfif>,
			<cfif len(HEIGHT_VALUE)>#HEIGHT_VALUE#<cfelse>NULL</cfif>,
			<cfif len(ROW_PROJECT_ID)>#ROW_PROJECT_ID#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfloop>
