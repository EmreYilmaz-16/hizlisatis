<!--- Bu sayfanın aynısından add_fast_sale_order adıyla taksitli satış ekranı için yapılmıştır.
LÜTFEN BU SAYFADA YAPTIĞINIZ DEĞİŞİKLİKLERİ ORDA DA YAPINIZ !!!!!!!!!!!!!!!!1  SM20080124--->
<cfif not isdefined("is_from_import")>
	<cf_get_lang_set module_name="sales">
</cfif>
<cfif not isdefined("is_from_import") and isDefined("session.ep.company_id") and attributes.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='588.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order</cfoutput>';
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
<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cf_date tarih="attributes.order_date">
<cf_date tarih="attributes.basket_due_value_date_">
<cfif len(attributes.deliverdate)><cf_date tarih="attributes.deliverdate"></cfif>
<cfif len(attributes.ship_date)><cf_date tarih="attributes.ship_date"></cfif>
<cfif not isdefined("is_from_import") and not isdefined("add_relation_rows")><!--- İmportta fonksiyonlar kendi sayfasında çağrılıyor --->
	<!---<cfinclude template="../../objects/functions/add_relation_rows.cfm">---><!--- sip,irs,fat satırlarının birbiri ile ilişkileri.. --->
</cfif>
<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn3_group#">
		SELECT
			SALES_COUNTY,
			COMPANY_VALUE_ID AS CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID,
            COUNTRY COUNTRY_ID
		FROM
			#dsn_alias#.COMPANY
		WHERE
			COMPANY_ID=#attributes.company_id#
	</cfquery>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_customer_info" datasource="#new_dsn3_group#">
		SELECT
			SALES_COUNTY,
			CUSTOMER_VALUE_ID,
			RESOURCE_ID,
			IMS_CODE_ID,
            TAX_COUNTRY_ID COUNTRY_ID
		FROM
			#dsn_alias#.CONSUMER
		WHERE
			CONSUMER_ID=#attributes.consumer_id#
	</cfquery>
</cfif>
<cfif not (isdefined("attributes.order_number") and len(attributes.order_number))>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="get_gen_paper" datasource="#new_dsn3_group#"><!--- siparis no transaction içine alındı --->
				SELECT 
					* 
				FROM 
					GENERAL_PAPERS 
				WHERE 
					ZONE_TYPE = 0 AND PAPER_TYPE = 0
			</cfquery>
			<cfset paper_code = evaluate('get_gen_paper.ORDER_NO')>
			<cfset paper_number = evaluate('get_gen_paper.ORDER_NUMBER') +1>
			<cfset paper_full = '#paper_code#-#paper_number#'>
			<cfquery name="SET_MAX_PAPER" datasource="#new_dsn3_group#">
				UPDATE
					GENERAL_PAPERS
				SET
					ORDER_NUMBER = ORDER_NUMBER+1
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 0
			</cfquery>
		</cftransaction>
	</cflock>
<cfelse>
	<cfset paper_full = attributes.order_number>
</cfif>
<cfif not isDefined("wrk_id")><!--- pda vs yerlerde set edilyor zaten --->
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
</cfif>
<cflock name="#CREATEUUID()#" timeout="90">
	<cftry>
		<cfquery name="ADD_ORDER" datasource="#new_dsn3_group#">
			INSERT INTO
				ORDERS
			(
				WRK_ID,
				ZONE_ID,
                COUNTRY_ID,
				RESOURCE_ID,
				IMS_CODE_ID,
				CUSTOMER_VALUE_ID,
				COMPANY_ID,
				PARTNER_ID,
				CONSUMER_ID,
			<cfif attributes.ref_member_type is 'partner'>
				REF_PARTNER_ID,
				REF_COMPANY_ID,				
			<cfelseif attributes.ref_member_type is 'consumer'>
				REF_CONSUMER_ID,
			<cfelse>
				REF_PARTNER_ID,
				REF_COMPANY_ID,
				REF_CONSUMER_ID,
			</cfif>	
				CONSUMER_REFERENCE_CODE,
				PARTNER_REFERENCE_CODE,		
				ORDER_NUMBER,
				ORDER_STAGE,
				ORDER_DATE,
				ORDER_STATUS,
				PRIORITY_ID, 
				COMMETHOD_ID,			
				DELIVERDATE,
				SHIP_DATE,
				DELIVER_DEPT_ID,
				LOCATION_ID,
				PAYMETHOD,
				OFFER_ID,
				ORDER_EMPLOYEE_ID,
				SALES_PARTNER_ID,
				SALES_CONSUMER_ID,
				SHIP_ADDRESS,
				SHIP_ADDRESS_ID,
				CITY_ID,
				COUNTY_ID,
				ORDER_HEAD,
				ORDER_DETAIL,
				GROSSTOTAL,
				TAXTOTAL,
				OTV_TOTAL,
				DISCOUNTTOTAL,
				NETTOTAL,
				INCLUDED_KDV,
			<cfif isdefined("attributes.basket_money")>
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
			</cfif>
				PURCHASE_SALES,
				ORDER_ZONE,
				SHIP_METHOD,
				RESERVED,
				PROJECT_ID,
				WORK_ID,
				DUE_DATE,
				REF_NO,
				SA_DISCOUNT,
				GENERAL_PROM_ID,
				GENERAL_PROM_LIMIT,
				GENERAL_PROM_AMOUNT,
				GENERAL_PROM_DISCOUNT, 
				FREE_PROM_ID,
				FREE_PROM_LIMIT,
				FREE_PROM_AMOUNT,
				FREE_PROM_COST,
				FREE_PROM_STOCK_ID,
				FREE_STOCK_PRICE,
				FREE_STOCK_MONEY,
				CARD_PAYMETHOD_ID,
				CARD_PAYMETHOD_RATE,
				SALES_ADD_OPTION_ID,
				DELIVER_COMP_ID,
				DELIVER_CONS_ID,
				FRM_BRANCH_ID,
				SUBSCRIPTION_ID,
				<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>CAMP_ID,</cfif>
				<cfif isdefined("attributes.IS_RECEIVED_WEBSERVICE") and len(attributes.IS_RECEIVED_WEBSERVICE)>IS_RECEIVED_WEBSERVICE,</cfif>
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				<cfqueryparam value="#wrk_id#" cfsqltype="cf_sql_varchar" >,
				<cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelseif isdefined("get_customer_info.SALES_COUNTY") and len(get_customer_info.SALES_COUNTY)>#get_customer_info.sales_county#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.country_id1") and len(attributes.country_id1)>#attributes.country_id1#<cfelseif isdefined("get_customer_info") and len(get_customer_info.country_id)>#get_customer_info.country_id#<cfelse>NULL</cfif>,
				<cfif isdefined("get_customer_info.RESOURCE_ID") and len(get_customer_info.RESOURCE_ID)>#get_customer_info.RESOURCE_ID#<cfelse>NULL</cfif>,
				<cfif isdefined("get_customer_info.IMS_CODE_ID") and len(get_customer_info.IMS_CODE_ID)>#get_customer_info.IMS_CODE_ID#<cfelse>NULL</cfif>,
				<cfif isdefined("get_customer_info.CUSTOMER_VALUE_ID") and len(get_customer_info.CUSTOMER_VALUE_ID)>#get_customer_info.CUSTOMER_VALUE_ID#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					#attributes.company_id#,
					<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelse>
					NULL,
					NULL,
					#attributes.consumer_id#,
				</cfif>
				<cfif attributes.ref_member_type is 'partner'>
					#attributes.ref_member_id#,
					#attributes.ref_company_id#,					
				<cfelseif attributes.ref_member_type is 'consumer'>
					#attributes.ref_member_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,				
				</cfif>
				<cfif isdefined('attributes.consumer_reference_code') and len(attributes.consumer_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_reference_code#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.partner_reference_code') and len(attributes.partner_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partner_reference_code#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
					19,
				<cfif len(attributes.order_date)>#attributes.order_date#<cfelse>NULL</cfif>,
					1,
				<cfif isdefined("attributes.priority_id")>#attributes.priority_id#<cfelse>NULL</cfif>, 
				<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
				<cfif len(attributes.ship_date)>#attributes.ship_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id) and len(attributes.deliver_dept_name)>
					#attributes.deliver_dept_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id) and len(attributes.deliver_dept_name)>
					#attributes.deliver_loc_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.offer_id") and len(attributes.offer_id) and len(attributes.offer_head)>#attributes.offer_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.order_employee_id) and len(attributes.order_employee)>#attributes.order_employee_id#<cfelse>NULL</cfif>, 
				<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and isdefined("attributes.sales_member_type") and(attributes.sales_member_type eq "PARTNER")>
					#attributes.sales_member_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and isdefined("attributes.sales_member_type") and (attributes.sales_member_type eq "CONSUMER")>
					#attributes.sales_member_id#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_head#">,
				<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_gross_total") and len(attributes.basket_gross_total)>#attributes.basket_gross_total#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_tax_total") and len(attributes.basket_tax_total)>#attributes.basket_tax_total#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_discount_total") and len(attributes.basket_discount_total)>#attributes.basket_discount_total#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_net_total") and len(attributes.basket_net_total)>#attributes.basket_net_total#<cfelse>NULL</cfif>,
				<cfif isdefined('included_kdv')>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.basket_money")>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,
					#((attributes.basket_net_total*attributes.basket_rate1)/attributes.basket_rate2)#,
				</cfif>
					1,
					0,
				<cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,				
				<cfif isdefined('attributes.reserved')>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.basket_due_value_date_") and len(attributes.basket_due_value_date_)>#attributes.basket_due_value_date_#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.genel_indirim") and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_cost") and len(attributes.free_prom_cost)>#attributes.free_prom_cost#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.free_stock_money#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
					#attributes.card_paymethod_id#,
					<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
						#attributes.commission_rate#,
					<cfelse>
						NULL,
					</cfif>
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif isDefined('attributes.sales_add_option') and len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,	
				<cfif isDefined('attributes.deliver_comp_id') and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#<cfelse>NULL</cfif>,	
				<cfif isDefined('attributes.deliver_cons_id') and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#<cfelse>NULL</cfif>,	
				<cfif isDefined('attributes.frm_branch_id') and len(attributes.frm_branch_id)>#attributes.frm_branch_id#<cfelseif len(ListGetAt(session.ep.user_location,2,"-"))>#ListGetAt(session.ep.user_location,2,"-")#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id) and isDefined("attributes.subscription_no") and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>
					<cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#,<cfelse>NULL,</cfif>
				</cfif>
				<cfif isdefined("attributes.IS_RECEIVED_WEBSERVICE") and len(attributes.IS_RECEIVED_WEBSERVICE)>1,</cfif>
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isDefined("session.pda")>#session.pda.userid#<cfelse>#session.ep.userid#</cfif><!--- pda den gelen kayıtlar için --->
			)
		</cfquery>
		<cfquery name="GET_MAX_ORDER" datasource="#new_dsn3_group#">
			SELECT MAX(ORDER_ID) AS MAX_ID FROM ORDERS WHERE WRK_ID = '#wrk_id#'
		</cfquery>
       <cfif isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and not isdefined("GetProductConf")><!--- Eğerki spec ismi configüre edilen ürünlerden yada özelliklerden oluşsun denilmiş ise,2.isdefined kontrolü 1 kere yüklesin diye --->
           <!---  <cfinclude template="../../objects/functions/get_conf_components.cfm">--->
        </cfif>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cf_date tarih="attributes.deliver_date#i#">
		<cf_date tarih="attributes.reserve_date#i#">
		<cfif isDefined("session.ep")><!--- pda den gelen siparişler için --->
			 <!--- XML tanımlamalarında seçilmiş ise --->
			 <cfif isdefined('attributes.is_auto_spec_create') and attributes.is_auto_spec_create eq 1 or (not isdefined('attributes.is_auto_spec_create'))>
				<cfif session.ep.our_company_info.spect_type  and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not (isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')))>
					<cftransaction>
                    	<cfset dsn_type=new_dsn3_group>
						<cfinclude template="../../objects/query/add_basket_spec.cfm">
					</cftransaction>
				</cfif>
			</cfif>
			<cfif isDefined("session.ep.our_company_info.spect_type") and session.ep.our_company_info.spect_type eq 5 and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			<!--- metal icin yapilan spec icin secilen stock_row satirlarini  STOCKS_ROW_RESERVED tablosuna kaydedecek... --->
				<cfquery name="get_spect" datasource="#new_dsn3_group#">
					SELECT
						SPECTS_ROW.RELATED_SPECT_ID,
						SPECTS_ROW.AMOUNT_VALUE,
						SPECTS_ROW.PRODUCT_ID,
						SPECTS_ROW.STOCK_ID,
						SPECTS_ROW.PRODUCT_MANUFACT_CODE,
						SPECTS_ROW.SHELF_NUMBER
					FROM
						SPECTS,
						SPECTS_ROW
					WHERE
						SPECTS.SPECT_VAR_ID=#evaluate('attributes.spect_id#i#')# AND
						SPECTS.SPECT_VAR_ID=SPECTS_ROW.SPECT_ID AND
						SPECTS_ROW.AMOUNT_VALUE >0
				</cfquery>
				<!--- rezerve edilecek stok --->
				<cfquery name="ADD_STOCK_RESERVED" datasource="#new_dsn3_group#">
                    INSERT INTO
						#dsn2_alias#.STOCKS_ROW_RESERVED
						(
							PRODUCT_ID,
							STOCK_ID,
							STOCK_OUT_RESERVED,
							<!--- STORE,
							STORE_LOCATION, --->
							SPECT_VAR_ID,
							ORDER_ID,
							PRODUCT_MANUFACT_CODE,
							SHELF_NUMBER
						)
						VALUES
						(
							<cfif len(get_spect.PRODUCT_ID)>#get_spect.PRODUCT_ID#<cfelse>NULL</cfif>,
							<cfif len(get_spect.STOCK_ID)>#get_spect.STOCK_ID#<cfelse>NULL</cfif>,
							<cfif len(get_spect.AMOUNT_VALUE)>#get_spect.AMOUNT_VALUE#<cfelse>0</cfif>,
							<!---<cfif len(form_store)>#form_store#<cfelse>NULL</cfif>,
							<cfif len(form_store_location)>#form_store_location#<cfelse>NULL</cfif>, --->
							<cfif len(get_spect.RELATED_SPECT_ID)>#get_spect.RELATED_SPECT_ID#<cfelse>NULL</cfif>,
							<cfif len(get_max_order.max_id)>#get_max_order.max_id#<cfelse>NULL</cfif>,
							<cfif len(get_spect.PRODUCT_MANUFACT_CODE)>#get_spect.PRODUCT_MANUFACT_CODE#<cfelse>NULL</cfif>,
							<cfif len(get_spect.SHELF_NUMBER)>#get_spect.SHELF_NUMBER#<cfelse>NULL</cfif>
							
						)
				</cfquery>
			</cfif>
		</cfif>
		<cfif isDefined("attributes.related_action_id_main") and Len(attributes.related_action_id_main)><cfset 'attributes.related_action_id#i#' = attributes.related_action_id_main></cfif>
		<cfif isDefined("attributes.related_action_table_main") and Len(attributes.related_action_table_main)><cfset 'attributes.related_action_table#i#' = attributes.related_action_table_main></cfif>
		<cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
			<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
		<cfelse>
			<cfset reasonCode = ''>
		</cfif>
		<cfquery name="ADD_ORDER_ROW" datasource="#new_dsn3_group#" >
			INSERT INTO
				ORDER_ROW
			(
				ORDER_ID,
				PRODUCT_ID, 
				STOCK_ID,
				QUANTITY,
				UNIT,
				UNIT_ID,
				<cfif len(evaluate("attributes.price#i#"))>PRICE,</cfif>
				TAX,
				NETTOTAL,
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
				LOT_NO,
				PRICE_OTHER,
				COST_PRICE,
				EXTRA_COST,
				MARJ,
				PROM_COMISSION,
				PROM_COST,
				DISCOUNT_COST,
				PROM_ID,
				IS_PROMOTION,
				PROM_STOCK_ID,
				IS_COMMISSION,
				ORDER_ROW_CURRENCY,
				RESERVE_TYPE,
				RESERVE_DATE,
				UNIQUE_RELATION_ID,
				PROM_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EK_TUTAR_PRICE,<!--- iscilik birim tutar --->
				EXTRA_PRICE_TOTAL,
				EXTRA_PRICE_OTHER_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
                DETAIL_INFO_EXTRA,
				ROW_PRO_MATERIAL_ID,
				PRICE_CAT,
				CATALOG_ID,
				LIST_PRICE,
				NUMBER_OF_INSTALLMENT,
				BASKET_EMPLOYEE_ID,
				KARMA_PRODUCT_ID,
				OTV_ORAN,
				OTVTOTAL,
                WRK_ROW_ID,
                WRK_ROW_RELATION_ID,
                RELATED_ACTION_ID,
                RELATED_ACTION_TABLE,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID,
				PAYMETHOD_ID,
				DESCRIPTION ,
				ROW_WORK_ID,
				REASON_CODE,
            	REASON_NAME,
            	GTIP_NUMBER
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>            
				<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
				<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
				<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,OTV_TYPE</cfif>
				<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,OTV_DISCOUNT</cfif>
			)
			VALUES
			(
				#get_max_order.max_id#,
				#evaluate("attributes.product_id#i#")#, 
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
			<cfif len(evaluate("attributes.price#i#"))>
				#evaluate("attributes.price#i#")#,
			</cfif>
				#evaluate("attributes.tax#i#")#,
			<cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
			<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.deliver_dept_id') and len(attributes.deliver_dept_id)>
				#attributes.deliver_dept_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.deliver_loc_id') and len(attributes.deliver_loc_id)>
				#attributes.deliver_loc_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>1</cfif>,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				<cfif isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('configure_spec_name') and len(configure_spec_name)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(configure_spec_name,499)#">,
				<cfelse>
    	            <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
				</cfif>
			</cfif>
			<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
			<cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>-1</cfif>,
			<cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#")) and isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#")) and evaluate("attributes.order_currency#i#") eq -9>-3<cfelseif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>-1</cfif>,
			<cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined('attributes.row_ship_id#i#') and len(evaluate('attributes.row_ship_id#i#'))>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
            <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
            <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif> ,
			<cfif isdefined('attributes.row_paymethod_id#i#') and len(evaluate('attributes.row_paymethod_id#i#'))>#evaluate('attributes.row_paymethod_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.description#i#') and len(evaluate('attributes.description#i#'))>'#evaluate('attributes.description#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
			<cfif len(reasonCode) and reasonCode contains '*'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
			<cfelse>
				NULL,
				NULL
			</cfif>
			,<cfif isdefined("attributes.gtip_number#i#") and len(evaluate("attributes.gtip_number#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.gtip_number#i#')#"><cfelse>NULL</cfif>
			<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_type#i#')#"></cfif>
			<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_discount#i#')#"></cfif>
			)
		</cfquery>
		<cfquery name="GET_MAX_ORDER_ROW" datasource="#new_dsn3_group#">
			SELECT
				MAX(ORDER_ROW_ID) AS ORDER_ROW_ID
			FROM
				ORDER_ROW
			WHERE
				ORDER_ID=#GET_MAX_ORDER.MAX_ID#
		</cfquery>
		<CFSET "ORDER_ROW_ID_PBS#i#"=GET_MAX_ORDER_ROW.ORDER_ROW_ID>
		 <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#')) and evaluate('attributes.related_action_table#i#') eq 'ORDER_DEMANDS'>
			<cfquery name="UPD_DEMAND" datasource="#new_dsn3_group#">
				UPDATE ORDER_DEMANDS SET GIVEN_AMOUNT = GIVEN_AMOUNT + #evaluate("attributes.amount#i#")# WHERE DEMAND_ID = #evaluate('attributes.related_action_id#i#')#
			</cfquery>
			<cfquery name="ADD_DEMAND_ROW" datasource="#new_dsn3_group#">
				INSERT INTO
					ORDER_DEMANDS_ROW
					(
						DEMAND_ID,
						ORDER_ID,
						ORDER_ROW_ID,
						QUANTITY
					)
				VALUES
					(
						#evaluate('attributes.related_action_id#i#')#,
						#GET_MAX_ORDER.MAX_ID#,
						#GET_MAX_ORDER_ROW.ORDER_ROW_ID#,
						#evaluate("attributes.amount#i#")#
					)
			</cfquery>
		</cfif>
		<!---  urun asortileri --->			
		<cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
            <cfscript>
                add_relation_rows(
                    action_type:'add',
                    action_dsn : '#new_dsn3_group#',
                    to_table:'ORDERS',
                    from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                    to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                    from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                    amount : Evaluate("attributes.amount#i#"),
                    to_action_id : get_max_order.max_id,
                    from_action_id :Evaluate("attributes.related_action_id#i#")
                    );
            </cfscript>
        </cfif>	
		<cfset attributes.ROW_MAIN_ID = get_max_order_row.order_row_id>
	
		<!--- //  urun asortileri --->
	</cfloop>
	<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)><!--- sistemden sipariş ekleme --->
		<cfquery name="ADD_SUBSCRIPTION_ORDER" datasource="#new_dsn3_group#">
			INSERT INTO
				SUBSCRIPTION_CONTRACT_ORDER
			(						
				SUBSCRIPTION_ID,
				ORDER_ID
			)
			VALUES
			(
				#attributes.subscription_id#,
				#get_max_order.max_id#
			)
		</cfquery>
	</cfif>
	<cfscript>
		basket_kur_ekle(action_id:GET_MAX_ORDER.MAX_ID,table_type_id:3,process_type:0,basket_money_db:new_dsn3_group);
		if(not isdefined("is_from_import") and not isdefined("add_reserve_row"))//importdan geliyorsa fonksiyon tanımlanmasın
		/*	include('add_order_row_reserved_stock.cfm','\objects\functions'); //rezerve edilen satırlar icin ORDER_ROW_RESERVED'a kayıt atıyor.
		add_reserve_row(
			reserve_order_id:GET_MAX_ORDER.MAX_ID,
			reserve_action_type:0,
			is_order_process:0,
			is_purchase_sales:1,
			process_db : dsn3,
			process_db_alias : "#new_dsn3_group#."
			);*/
			writeDump("ReserveEtmişOlmamLazım");
	if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
	{
		if(not isdefined("is_from_import") and not isdefined("add_paper_relation"))//importdan geliyorsa fonksiyon tanımlanmasın
			include('add_paper_relation.cfm','\objects\functions'); 
		add_paper_relation(
			to_paper_id :GET_MAX_ORDER.MAX_ID,
			to_paper_table : 'ORDERS',
			to_paper_type :1,
			from_paper_table : 'PRO_MATERIAL',
			from_paper_type :2,
			relation_type : 1,
			action_status:0
			);
	}
	</cfscript>
	<cfset last_order_id = get_max_order.max_id>
	<!---Ek Bilgiler--->
    <cfset attributes.info_id = GET_MAX_ORDER.MAX_ID>
    <cfset attributes.is_upd = 0>
	<cfset attributes.info_type_id = -7>
    <cfinclude template="/v16/objects/query/add_info_plus2.cfm">
    <!---Ek Bilgiler--->
	<cfif isDefined("session.ep") and not isdefined("is_from_import")><!--- pda den gelen kayıtlar için --->
		<cf_workcube_process
			is_upd='1' 
			new_comp_id='#new_comp_id#'
			data_source='#new_dsn3_group#'
			old_process_line='0'
			process_stage='#attributes.process_stage#'
			record_member='#session.ep.userid#'
			record_date='#now()#'
			action_table='ORDERS'
			action_column='ORDER_ID'
			action_id='#last_order_id#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=upd&order_id=#get_max_order.max_id#'
			warning_description="#getLang('','Sipariş',57611)# : #paper_full#"
			paper_no = '#paper_full#'>
	</cfif>
	<cfif not isdefined("first_order_id")>
		<cfset first_order_id = get_max_order.max_id>
	</cfif>
	<cfset add_order_error=0>
	<cfcatch>
		<cfdump var="#cfcatch#">
		<cfset add_order_error=1>
		<cfif isdefined('GET_MAX_ORDER.MAX_ID')>
			<cfset attributes.order_id=GET_MAX_ORDER.MAX_ID>
			<cfinclude template="del_order.cfm">
		</cfif>
		<cfif not isdefined("is_from_import")><!--- İmportdan geliyorsa hataları yazmasın --->
			<!--- işlemler sırasında hata alındığında --->
			<cfoutput>#getLang('','Hata oluştu yapılan işlemler geri alınıyor',64676)#</cfoutput>
			<cfset hata=11>
			<cfset hata_mesaj = "#getLang('','Sipariş Kayıt İşleminde Hata',64675)#">
			<cfoutput><cfinclude template='../../dsp_hata.cfm'></cfoutput>
			<cfabort>
		</cfif>
 	 </cfcatch>
	</cftry>
</cflock>

