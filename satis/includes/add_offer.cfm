
<cf_xml_page_edit fuseact="sales.form_add_offer">
<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='588.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=sales.list_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not isdefined('attributes.price') or not len(attributes.price)>
	<cfif isDefined("attributes.basket_net_total") and len(attributes.basket_net_total)>
		<cfset attributes.price = attributes.basket_net_total>
	<cfelse>
		<cfset attributes.price = 0>
	</cfif>
</cfif>
<cf_date tarih="attributes.offer_date">
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset offer_due_date = date_add("d",attributes.basket_due_value,attributes.offer_date)>
<cfelse>
	<cfset offer_due_date = "">
</cfif> 
<cfif len(attributes.deliverdate)><cf_date tarih="attributes.deliverdate"></cfif>
<cfif len(attributes.ship_date)><cf_date tarih="attributes.ship_date"></cfif>
<cfif len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cf_papers paper_type="offer" paper_type2="1">
<cfquery name="get_country" datasource="#dsn#">
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        SELECT 
            COUNTRY COUNTRY_ID,
            SALES_COUNTY SALES_ID
        FROM 
            COMPANY 
        WHERE 
            COMPANY_ID =#attributes.company_id#
    <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
        SELECT 
            SALES_COUNTY SALES_ID,
            TAX_COUNTRY_ID COUNTRY_ID
        FROM 
            CONSUMER 
        WHERE 
            CONSUMER_ID=#attributes.consumer_id#
    </cfif>
</cfquery>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>

		<cfquery name="ADD_OFFER" datasource="#DSN3#" result="GET_MAX_OFFER">
			INSERT INTO 
				PBS_OFFER 
			(
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
			<cfif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'partner'>
				REF_PARTNER_ID,
				REF_COMPANY_ID,				
			<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'consumer'>
				REF_CONSUMER_ID,
			<cfelse>
				REF_PARTNER_ID,
				REF_COMPANY_ID,
				REF_CONSUMER_ID,
			</cfif>
			<cfif isdefined("attributes.opp_id")>
				OPP_ID,
			</cfif>
				SALES_EMP_ID,
				SALES_PARTNER_ID,
				SALES_CONSUMER_ID,
				OFFER_CURRENCY,
				OFFER_STAGE,
				OFFER_DATE,
				<cfif isdefined("attributes.price") and  len(attributes.price)>
					PRICE,
				</cfif>
				PAYMETHOD,
				CARD_PAYMETHOD_ID,
				CARD_PAYMETHOD_RATE,
				DELIVERDATE,
				SHIP_DATE,
				FINISHDATE,
				OFFER_HEAD,
				OFFER_DETAIL,
			<cfif isdefined('attributes.basket_money') and len(attributes.basket_money)>
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
			</cfif>
				TAX,
				OTV_TOTAL,
                NETTOTAL,
				OFFER_NUMBER,
				OFFER_STATUS,
				PURCHASE_SALES,
				INCLUDED_KDV,
				OFFER_ZONE,
				SHIP_METHOD,
				SHIP_ADDRESS,
				SHIP_ADDRESS_ID,
				IS_PARTNER_ZONE,
				IS_PUBLIC_ZONE,
				PROJECT_ID,
				WORK_ID,
				DUE_DATE,
				REF_NO,
				CITY_ID,
				COUNTY_ID,
				SALES_ADD_OPTION_ID,
             	<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>CAMP_ID,</cfif>
				RELATION_OFFER_ID,
				RECORD_DATE,
				RECORD_IP,
				RECORD_MEMBER,
                COUNTRY_ID,
                SZ_ID,
				PROBABILITY ,
                EVENT_PLAN_ROW_ID,
                SA_DISCOUNT,
                PRICE_CAT_ID,
				OFFER_DESCRIPTION
			)
			VALUES 
			(
			<cfif len(attributes.member_name) and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.member_name) and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'partner'>
				#attributes.ref_member_id#,
				#attributes.ref_company_id#,					
			<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'consumer'>
				#attributes.ref_member_id#,
			<cfelse>
				NULL,
				NULL,
				NULL,				
			</cfif>
			<cfif isdefined("attributes.opp_id")>#attributes.opp_id#,</cfif>
			<cfif len(attributes.sales_emp_id) and len(attributes.sales_emp)>#attributes.sales_emp_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type) and attributes.sales_member_type eq 'partner'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type) and attributes.sales_member_type eq 'consumer'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
			-1,
			#attributes.process_stage#,
			<cfif len(attributes.offer_date)>#attributes.offer_date#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.price") and len(attributes.price)>#attributes.price#,</cfif>
			<cfif len(attributes.paymethod_id) and len(attributes.pay_method)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.card_paymethod_id) and len(attributes.pay_method)>#attributes.card_paymethod_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.commission_rate) and len(attributes.pay_method)>#attributes.commission_rate#<cfelse>NULL</cfif>,
			<cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
			<cfif len(attributes.ship_date)>#attributes.ship_date#<cfelse>NULL</cfif>,
			<cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,			
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.offer_head#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.offer_detail#">,
			<cfif isdefined('attributes.basket_money') and len(attributes.basket_money)>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
				#((attributes.basket_net_total*attributes.basket_rate1)/attributes.basket_rate2)#,
			</cfif>
            <cfif isdefined("attributes.basket_tax_total") and len(attributes.basket_tax_total)>#attributes.basket_tax_total#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.basket_net_total") and len(attributes.basket_net_total)>#attributes.basket_net_total#<cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_fulbs#">,
			<cfif isDefined("attributes.offer_status")>1<cfelse>0</cfif>,
				1,
			<cfif isdefined("attributes.included_kdv") and len(attributes.included_kdv)>1<cfelse>0</cfif>,
				0,
			<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#">,
			<cfif isDefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.is_partner_zone")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.is_public_zone")>1<cfelse>0</cfif>,
			<cfif len(attributes.project_head) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
			<cfif isdefined("offer_due_date") and len(offer_due_date)>#offer_due_date#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.city_id") and len(attributes.city_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.city_id#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.county_id") and len(attributes.county_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.county_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>
				<cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#,<cfelse>NULL,</cfif>
			</cfif>
			<cfif (isdefined('attributes.rel_offer_id') and len(attributes.rel_offer_id)) and (isdefined('attributes.rel_offer_head') and len(attributes.rel_offer_head))>#attributes.rel_offer_id#,<cfelse>NULL,</cfif>
				#now()#,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            #session.ep.userid#,
            <cfif isdefined("attributes.country_id") and len(attributes.country_id)>#attributes.country_id#<cfelseif isdefined("get_country") and len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>, 
            <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelseif isdefined("get_country") and len(get_country.sales_id)>#get_country.sales_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.probability")>#attributes.probability#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.event_plan_row_id') and len(attributes.event_plan_row_id)>#event_plan_row_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.genel_indirim") and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>#attributes.price_catid#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.OFFER_DESCRIPTION") and len(attributes.OFFER_DESCRIPTION)>'#attributes.OFFER_DESCRIPTION#'<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfset GET_MAX_OFFER.max_id = GET_MAX_OFFER.IDENTITYCOL>
        <cfset dsn_type=dsn3>

		<cfloop from="1" to="#attributes.rows_#" index="I">
			<cf_date tarih="attributes.deliver_date#i#">
			<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and (not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#')))>
				<cfif len(attributes.consumer_id)>
					<cfset attributes.consumer_id=attributes.consumer_id>
				<cfelse>
					<cfset attributes.consumer_id="">
				</cfif>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			</cfif>
			<cfquery name="ADD_OFFER_ROW" datasource="#DSN3#">
				INSERT INTO
					PBS_OFFER_ROW
				(
					OFFER_ID,
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					UNIT,
					UNIT_ID,					
				<cfif isdefined('attributes.price#i#') and len(evaluate('attributes.price#i#'))>
					PRICE,
				</cfif>
					TAX,
					DUEDATE,
					PRODUCT_NAME,
					DELIVER_DATE,
					DELIVER_DEPT,
					DELIVER_LOCATION,
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
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
				</cfif>
					PRICE_OTHER,
					NET_MALIYET,
					<!--- COST_ID, --->
					EXTRA_COST,
					MARJ,
					<!--- Yeni Eklenen Alanlar. Promosyon İle İlgili --->
					PROM_COMISSION,
					PROM_COST,
					DISCOUNT_COST,
					PROM_ID,
					IS_PROMOTION,
					PROM_STOCK_ID,
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
					DELIVERY_CONDITION,
					LIST_PRICE,
					LOT_NO,
					NUMBER_OF_INSTALLMENT,
					PRICE_CAT,
					CATALOG_ID,
					EK_TUTAR_PRICE,
					OTV_ORAN,
    				OTVTOTAL,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID,
                    RELATED_ACTION_ID,
                    RELATED_ACTION_TABLE,
					BASKET_EMPLOYEE_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID,
					KARMA_PRODUCT_ID,
					PBS_ID,
					ROW_WORK_ID,
					IS_VIRTUAL,
					SHELF_CODE,
					DESCRIPTION,
					PBS_OFFER_ROW_CURRENCY
					<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
					<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
					<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
					<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
					<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
					<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
					<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
					<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
					<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
					<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
					<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
					<cfif isdefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,WEIGHT</cfif>
					<cfif isdefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,SPECIFIC_WEIGHT</cfif>
					<cfif isdefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,VOLUME</cfif>
					<cfif isDefined('attributes.converted_sid#i#') and len(evaluate("attributes.converted_sid#i#"))>,CONVERTED_STOCK_ID</cfif>
				)
				VALUES
				(
					#get_max_offer.max_id#,
					#evaluate('attributes.product_id#i#')#,
					#evaluate('attributes.stock_id#i#')#,
					#evaluate('attributes.amount#i#')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
					#evaluate('attributes.unit_id#i#')#,
				<cfif len(evaluate('attributes.price#i#'))>#evaluate('attributes.price#i#')#,</cfif>
					#evaluate('attributes.tax#i#')#,
				<cfif isdefined("attributes.duedate#i#") and len(evaluate('attributes.duedate#i#'))>#evaluate('attributes.duedate#i#')#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
				<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
					#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
				</cfif>
				<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
				<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
				<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
				
				<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#,<cfelse>0,</cfif>			
				<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>
					#evaluate('attributes.promosyon_yuzde#i#')#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>
					#evaluate('attributes.promosyon_maliyet#i#')#,
				<cfelse>
					0,
				</cfif>
				<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>
					#evaluate('attributes.iskonto_tutar#i#')#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>
					#evaluate('attributes.row_promotion_id#i#')#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>
					#evaluate('attributes.is_promotion#i#')#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>
					#evaluate('attributes.prom_stock_id#i#')#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.delivery_condition#i#') and len(evaluate('attributes.delivery_condition#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_condition#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#evaluate('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.pbs_code#i#') and len(evaluate('attributes.pbs_code#i#')) and isdefined('attributes.pbs_id#i#') and len(evaluate('attributes.pbs_id#i#'))>#evaluate('attributes.pbs_id#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
					#evaluate('attributes.is_virtual#i#')#,
					'#evaluate('attributes.SHELF_CODE#i#')#',
					<cfif isdefined('attributes.description#i#') and len(evaluate('attributes.description#i#'))>'#evaluate('attributes.description#i#')#'<cfelse>NULL</cfif>,
					'#evaluate('attributes.PBS_OFFER_ROW_CURRENCY#i#')#'
					<cfif isDefined('attributes.converted_sid#i#') and len(evaluate("attributes.converted_sid#i#"))>,#evaluate("attributes.converted_sid#i#")#</cfif>
					<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
				<cfif isdefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_weight#i#')#"></cfif>
				<cfif isdefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_specific_weight#i#')#"></cfif>
				<cfif isdefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_volume#i#')#"></cfif>
				)
			</cfquery>
 
			<!--- urun asortileri --->			
			<cfquery name="GET_MAX_OFFER_ROW" datasource="#DSN3#">
				SELECT MAX(OFFER_ROW_ID) AS OFFER_ROW_ID FROM PBS_OFFER_ROW
			</cfquery>
	
			<cfset attributes.ROW_MAIN_ID = get_max_offer_row.offer_row_id>
			<cfset row_id = I>
			<cfset ACTION_TYPE_ID = 1>
			<cfset attributes.product_id = evaluate("attributes.product_id#i#")>
			<cfif not len(attributes.project_head) >
				<cfinclude template="save_virtual_production_orders.cfm">
			</cfif>
			<cfinclude template="add_price_offer.cfm">			
			<cfif evaluate("attributes.is_karma#i#") eq 1>
				<cfinclude template="addKarmaProducts.cfm">
			</cfif>
		</cfloop>

		<cfscript>
			basket_kur_ekle_pbs(action_id:get_max_offer.max_id,table_type_id:4,process_type:0);
		</cfscript>
        
	
	</cftransaction>
</cflock>
<cffunction name="basket_kur_ekle_pbs">
	<cfargument name="action_id" required="true">
	<cfargument name="table_type_id" required="true">
	<cfargument name="process_type" required="true">
	<cfargument name="basket_money_db" type="string" default="">
	<cfargument name="transaction_dsn">
	<!---
		by : Arzu BT 20031211
		notes : Basket_money tablosuna islemlere gore kur bilgilerini kaydeder.
		process_type:1 upd 0 add
		transaction_dsn : kullanılan sayfa içinde table dan farklı dsn tanımı olduğu durumlarda kullanılan dsn gönderilir.
		usage :
			invoice:1
			ship:2
			order:3
			offer:4
			servis:5
			stock_fis:6
			internmal_demand:7
			prroduct_catalog 8
			sale_quote:9
			subscription:13
		revisions : javascript version ergün koçak 20040209
		kullanim:
		<cfscript>
			basket_kur_ekle(action_id:MY_ID,table_type_id:1,process_type:0);
		</cfscript>		
	--->
	<cfscript>
		switch (arguments.table_type_id){
			case 1: fnc_table_name="INVOICE_MONEY"; fnc_dsn_name="#dsn2#";break;
			case 2: fnc_table_name="SHIP_MONEY"; fnc_dsn_name="#dsn2#"; break;
			case 3: fnc_table_name="ORDER_MONEY"; fnc_dsn_name="#dsn3#"; break;
			case 4: fnc_table_name="PBS_OFFER_MONEY"; fnc_dsn_name="#dsn3#"; break;
			case 5: fnc_table_name="SERVICE_MONEY"; fnc_dsn_name="#dsn3#";break;
			case 6: fnc_table_name="STOCK_FIS_MONEY"; fnc_dsn_name="#dsn2#"; break;
			case 7: fnc_table_name="INTERNALDEMAND_MONEY"; fnc_dsn_name="#dsn3#"; break;
			case 8: fnc_table_name="CATALOG_MONEY"; fnc_dsn_name="#dsn3#"; break;
			case 10: fnc_table_name="SHIP_INTERNAL_MONEY"; fnc_dsn_name="#dsn2#"; break;	
			case 11: fnc_table_name="PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
			case 12: fnc_table_name="VOUCHER_PAYROLL_MONEY"; fnc_dsn_name="#dsn2#"; break;
			case 13: fnc_table_name="SUBSCRIPTION_CONTRACT_MONEY"; fnc_dsn_name="#dsn3#"; break;			
			case 14: fnc_table_name="PRO_MATERIAL_MONEY"; fnc_dsn_name="#dsn#"; break;
		}
		if(len(arguments.basket_money_db))fnc_dsn_name = "#arguments.basket_money_db#";
	</cfscript>
	<cfif not (isdefined('arguments.transaction_dsn') and len(arguments.transaction_dsn))>
		<cfset arguments.transaction_dsn = fnc_dsn_name>
		<cfset arguments.action_table_dsn_alias = ''>
	<cfelse>
		<cfset arguments.action_table_dsn_alias = '#fnc_dsn_name#.'>
	</cfif>
	<cfif arguments.process_type eq 1>
		<cfquery name="del_money_obj_bskt" datasource="#arguments.transaction_dsn#">
			DELETE FROM 
				#arguments.action_table_dsn_alias##fnc_table_name#
			WHERE 
				ACTION_ID=#arguments.action_id#
		</cfquery>
	</cfif>
	<cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
		<cfquery name="add_money_obj_bskt" datasource="#arguments.transaction_dsn#">
			INSERT INTO #arguments.action_table_dsn_alias##fnc_table_name# 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#arguments.action_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#fnc_i#')#">,
				#evaluate("attributes.txt_rate2_#fnc_i#")#,
				#evaluate("attributes.txt_rate1_#fnc_i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.BASKET_MONEY>
					1
				<cfelse>
					0
				</cfif>					
			)
		</cfquery>
	</cfloop>
</cffunction>