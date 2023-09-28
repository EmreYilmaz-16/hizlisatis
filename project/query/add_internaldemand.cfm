<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
	<cfif isdefined("attributes.target_date") and isdate(attributes.target_date)>
		<cf_date tarih="attributes.target_date">
	</cfif>
	<cfif isdefined('attributes.is_demand') and  isdefined('attributes.process_cat') and len(attributes.process_cat) and attributes.is_demand eq 1>
		<cfscript>
			attributes.currency_multiplier = '';
			paper_currency_multiplier ='';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
						paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		</cfscript>
		<cfquery name="get_type" datasource="#dsn3#">
			SELECT PROCESS_TYPE,PROCESS_CAT_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_BUDGET_RESERVED_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
		</cfquery>
	</cfif>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfif isdefined('attributes.is_demand') and len(attributes.is_demand) and attributes.is_demand eq 1>
				<cfquery name="get_gen_paper" datasource="#dsn3#">
					SELECT PURCHASEDEMAND_NO, PURCHASEDEMAND_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
				</cfquery>
				<cfset paper_code = evaluate('get_gen_paper.PURCHASEDEMAND_NO')>
				<cfset paper_number = evaluate('get_gen_paper.PURCHASEDEMAND_NUMBER') +1>
				<cfset paper_full = '#paper_code#-#paper_number#'>
				<cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
					UPDATE GENERAL_PAPERS SET PURCHASEDEMAND_NUMBER = PURCHASEDEMAND_NUMBER+1 WHERE PAPER_TYPE IS NULL
				</cfquery>
			<cfelse>
				<cfquery name="get_gen_paper" datasource="#dsn3#">
					SELECT INTERNAL_NO, INTERNAL_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
				</cfquery>
				<cfset paper_code = evaluate('get_gen_paper.INTERNAL_NO')>
				<cfset paper_number = evaluate('get_gen_paper.INTERNAL_NUMBER') +1>
				<cfset paper_full = '#paper_code#-#paper_number#'>
				<cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
					UPDATE GENERAL_PAPERS SET INTERNAL_NUMBER = INTERNAL_NUMBER+1 WHERE PAPER_TYPE IS NULL
				</cfquery>
			</cfif>
			<cfquery name="ADD_INTERNALDEMAND" datasource="#dsn3#" result="MAX_ID">
				   INSERT INTO
					INTERNALDEMAND
					(
						SERVICE_ID,
						INTERNAL_NUMBER,
						TO_POSITION_CODE,
						<cfif len(attributes.from_position_code) and len(attributes.from_position_name)>FROM_POSITION_CODE,</cfif>
						<cfif isdefined("attributes.target_date") and isdate(attributes.target_date)>TARGET_DATE,</cfif>
						TOTAL,
						DISCOUNT,
						TOTAL_TAX,
						OTV_TOTAL,
						NET_TOTAL,
						SUBJECT,
						PRIORITY,
						INTERNALDEMAND_STATUS,
						IS_ACTIVE,
						NOTES,
						PROJECT_ID,
						PROJECT_ID_OUT,
						INTERNALDEMAND_STAGE,
						DEPARTMENT_IN,
						LOCATION_IN,
						DEPARTMENT_OUT,
						LOCATION_OUT,
						REF_NO,
						SHIP_METHOD,
						WORK_ID,
					<cfif isdefined('form.basket_money')>
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
					</cfif>
						DPL_ID,
						OFFER_ID,
						DEMAND_TYPE,
						RECORD_EMP,
						RECORD_DATE,
						FROM_COMPANY_ID,
						FROM_PARTNER_ID,
						FROM_CONSUMER_ID,
						PROCESS_CAT,
						DEPARTMENT_ID
				)
					VALUES
				(
						<cfif isDefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
						#attributes.TO_POSITION_CODE#,
						<cfif len(attributes.from_position_code) and len(attributes.from_position_name)>#attributes.from_position_code#,</cfif>
						<cfif isdefined("attributes.target_date") and isdate(attributes.target_date)>#attributes.target_date#,</cfif>
						<cfif isdefined("attributes.basket_gross_total") and len(attributes.basket_gross_total)>#attributes.basket_gross_total#<cfelse>0</cfif>,
						<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL") and len(attributes.BASKET_DISCOUNT_TOTAL)>#attributes.BASKET_DISCOUNT_TOTAL#<cfelse>0</cfif>,
						<cfif isdefined("attributes.basket_tax_total") and len(attributes.basket_tax_total)>#attributes.basket_tax_total#<cfelse>0</cfif>,
						<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>0</cfif>,
						<cfif isdefined("attributes.basket_net_total") and len(attributes.basket_net_total)>#attributes.basket_net_total#<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subject#">,
						<cfif isdefined('attributes.priority') and len(attributes.priority)>#attributes.priority#<cfelse>NULL</cfif>,
						0,
						<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.notes#">,
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.project_id_out') and len(attributes.project_id_out)>#attributes.project_id_out#<cfelse>NULL</cfif>,
						#attributes.process_stage#,
						<cfif isdefined('attributes.department_in_id') and len(attributes.department_in_id) and len(department_in_txt)>#attributes.department_in_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.location_in_id') and len(attributes.location_in_id) and len(department_in_txt)>#attributes.location_in_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.department_id') and len(attributes.department_id) and len(txt_departman_)>#attributes.department_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.location_id') and len(attributes.location_id) and len(txt_departman_)>#attributes.location_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
						<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
							#SHIP_METHOD#
						<cfelse>
							NULL
						</cfif>,
						<cfif isdefined('attributes.work_id') and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
						<cfif isdefined('form.basket_money')>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
							#((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
						</cfif>
						<cfif isdefined('attributes.dpl_id') and len(attributes.dpl_id) and isdefined('attributes.dpl_no') and len(attributes.dpl_no)>#attributes.dpl_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.offer_id') and len(attributes.offer_id)>#attributes.offer_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_demand') and len(attributes.is_demand)>#attributes.is_demand#<cfelse>NULL</cfif>,
						#SESSION.EP.USERID#,
						#now()#,
						<cfif isdefined("attributes.from_company_id") and len(attributes.from_company_id)>#attributes.from_company_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.from_partner_id") and len(attributes.from_partner_id)>#attributes.from_partner_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.from_consumer_id") and len(attributes.from_consumer_id)>#attributes.from_consumer_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>#attributes.process_cat#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.emp_department_id') and len(attributes.emp_department_id) and len(emp_department)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_department_id#"><cfelse>NULL</cfif>
	
				)
			</cfquery>
			<cfif attributes.rows_  neq 0>
				<cfloop from="1" to="#attributes.rows_#" index="i">
					<cfif isDefined("attributes.stock_id#i#") and Len(Evaluate("attributes.stock_id#i#")) and isDefined("attributes.product_id#i#") and Len(Evaluate("attributes.product_id#i#"))><!--- FBS 20120522 Bu kontrol action file ile olusan irsaliye kaydi icin eklenmistir --->
						<cf_date tarih="attributes.deliver_date#i#">
						<cf_date tarih="attributes.reserve_date#i#">
						<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and (not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#')))>
							<cfset dsn_type=dsn3>
							<cfinclude template="../../objects/query/add_basket_spec.cfm">
						</cfif>
						<cfset product_name_ = evaluate("attributes.product_name#i#")>
						<cfquery name="ADD_INTERNALDEMAND_ROW" datasource="#DSN3#">
							INSERT INTO
								INTERNALDEMAND_ROW
								(
									I_ID,
									PRODUCT_ID,
									STOCK_ID,
									QUANTITY,
									UNIT,
									UNIT_ID,
									PRICE,
									PRICE_OTHER,
									OTHER_MONEY,
									OTHER_MONEY_VALUE,
									TAX,
									DUEDATE,
									PRODUCT_NAME,
									PAY_METHOD_ID,
									DELIVER_DATE,
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
									TAXTOTAL,
									NETTOTAL,
									OTV_ORAN,
									OTVTOTAL,
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
									UNIQUE_RELATION_ID,
									PROM_RELATION_ID,
									AMOUNT2,
									UNIT2,
									EXTRA_PRICE,
									EK_TUTAR_PRICE,
									EXTRA_PRICE_TOTAL,
									EXTRA_PRICE_OTHER_TOTAL,
									SHELF_NUMBER,
									BASKET_EXTRA_INFO_ID,
									SELECT_INFO_EXTRA,
									DETAIL_INFO_EXTRA,
									PRICE_CAT,
									CATALOG_ID,
									LIST_PRICE,
									NUMBER_OF_INSTALLMENT,
									BASKET_EMPLOYEE_ID,
									KARMA_PRODUCT_ID,
									RESERVE_DATE,
									PRODUCT_NAME2,
									PRODUCT_MANUFACT_CODE,
									WRK_ROW_ID,
									WRK_ROW_RELATION_ID,
									PRO_MATERIAL_ID,
									WIDTH_VALUE,
									DEPTH_VALUE,
									HEIGHT_VALUE,
									ROW_PROJECT_ID,
									ROW_WORK_ID,
									PBS_ID,
									DELIVER_DEPT,
									DELIVER_LOCATION
									<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
									,SPECT_VAR_ID
									,SPECT_VAR_NAME
									</cfif>,
									LOT_NO
									<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
									<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
									<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
									<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
									<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE </cfif>
									<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
								)
							VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									#evaluate("attributes.product_id#i#")#,
									#evaluate("attributes.stock_id#i#")#,
									#evaluate("attributes.amount#i#")#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
									#evaluate("attributes.unit_id#i#")#,
									<cfif isdefined('attributes.price#i#') and len(trim(evaluate('attributes.price#i#')))>#evaluate("attributes.price#i#")#,<cfelse>0,</cfif>
									<cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#")) and isNumeric(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#")) and isNumeric(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.tax#i#') and len(trim(evaluate('attributes.tax#i#')))>#evaluate("attributes.tax#i#")#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
									'#left(product_name_,250)#',
									<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
									<cfif isdefined('attributes.row_taxtotal#i#') and len(evaluate("attributes.row_taxtotal#i#"))>#evaluate("attributes.row_taxtotal#i#")#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_nettotal#i#') and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
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
									<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0>#ListFirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.pbs_code#i#') and len(evaluate('attributes.pbs_code#i#')) and isdefined('attributes.pbs_id#i#') and len(evaluate('attributes.pbs_id#i#'))>#evaluate('attributes.pbs_id#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
										#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
									<cfelseif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>
										#attributes.department_in_id#,
									<cfelse>
										NULL,
									</cfif>
									<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
										#listlast(evaluate("attributes.deliver_dept#i#"),"-")#
									<cfelseif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>
										#attributes.location_in_id#
									<cfelse>
										NULL
									</cfif>
									<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_id#i#')#">
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">
									</cfif>,
									<cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>
									<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
									<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
									<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
									<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
									<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
									<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
								)
						</cfquery>
						<cfquery name="GET_MAX_INV_ROW" datasource="#DSN3#">
							SELECT MAX(I_ROW_ID) ROW_MAX_ID FROM INTERNALDEMAND_ROW WHERE I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
						</cfquery>
					</cfif>
					<!--- bütçe rezerve kontrolü --->
					<cfif isdefined('attributes.is_demand') and  isdefined('attributes.process_cat') and len(attributes.process_cat) and attributes.is_demand eq 1 and isdefined("get_type.IS_BUDGET_RESERVED_CONTROL") and get_type.IS_BUDGET_RESERVED_CONTROL eq 1>
						<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>
							<cfset other_money_val = evaluate('attributes.other_money_value_#i#')>
						<cfelse>
							<cfset other_money_val =''>
						</cfif>
						<cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))>
							<cfset other_money = evaluate('attributes.other_money_#i#')>
						<cfelse>
							<cfset other_money = ''>
						</cfif>
						
					</cfif>
				</cfloop>
			</cfif>
			
	
			<cfscript>
				if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //iç talepten satınalma talebi oluşmuşsa
				{
					add_internaldemand_row_relation(
						to_related_action_id:MAX_ID.IDENTITYCOL,
						to_related_action_type:4,
						action_status:0,
						process_db:dsn3
						);
				}
				if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
				{
					add_paper_relation(
						to_paper_id :MAX_ID.IDENTITYCOL,
						to_paper_table : 'INTERNALDEMAND',
						to_paper_type :3,
						from_paper_table : 'PRO_MATERIAL',
						from_paper_type :2,
						relation_type : 1,
						action_status:0
						);
				}
				
			</cfscript>
			<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>
				<cfset page_type = 'list_purchasedemand&event=upd'>
				<cfset page_name = 'Satınalma Talebi'>
			<cfelse>
				<cfset page_type = 'list_internaldemand&event=upd'>
				<cfset page_name = 'İç Talep'>
			</cfif>
			<cfif fusebox.circuit eq 'myhome'>
				<cfset internal_id_ = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
			<cfelse>
				<cfset internal_id_ = MAX_ID.IDENTITYCOL>
			</cfif>
			<!---Ek Bilgiler--->
				<cfset attributes.info_id = MAX_ID.IDENTITYCOL>
				<cfset attributes.is_upd = 0>
				<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>
					<cfset attributes.info_type_id = -28>
				<cfelse>
					<cfset attributes.info_type_id = -29>
				</cfif>
			
			<!---Ek Bilgiler--->
			<cfif not isDefined("attributes.not_process")>
				<!--- Satinalma Siparisi vb yerlerden action file ile olusacak talepler icin bu sayfa include ediliyor, surec icinde surec calismamasi icin eklendi FBS 20120524 --->
				<cf_workcube_process
					is_upd='1'
					data_source='#dsn3#'
					old_process_line='0'
					process_stage='#attributes.process_stage#'
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='INTERNALDEMAND'
					action_column='INTERNAL_ID'
					action_id='#MAX_ID.IDENTITYCOL#'
					action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#page_type#&id=#internal_id_#'
					warning_description='#page_name#: #paper_full#'
					paper_no='#paper_full#'>
			</cfif>
			<cfif isdefined('attributes.is_demand') and  isdefined('attributes.process_cat') and len(attributes.process_cat) and attributes.is_demand eq 1>
				<cf_workcube_process_cat 
					process_cat="#attributes.process_cat#"
					action_id = "#MAX_ID.IDENTITYCOL#"
					action_table="INTERNALDEMAND"
					action_column="INTERNAL_ID"
					is_action_file = 1
					action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#page_type#&id=#internal_id_#'
					action_file_name='#get_type.action_file_name#'
					action_db_type = '#dsn3#'
					is_template_action_file = '#get_type.action_file_from_template#'>
			</cfif>
		</cftransaction>
	</cflock>
	
	