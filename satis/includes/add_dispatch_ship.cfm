<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cfinclude template="/v16/stock/query/check_our_period.cfm">
	<cfif attributes.rows_ eq 0>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz !'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	<cfif isdefined('attributes.from_ship_delivery')><!--- mal alım irsaliyesinden sevk irsaliyesi oluşturulmak istendiğinde... --->
		<cfinclude template="add_dispatch_ship_from_ship.cfm">
	<cfelse>
		<cfif not isDefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
		<cfinclude template="/v16/stock/query/get_process_cat.cfm">
		<cf_date tarih = 'attributes.deliver_date_frm'>
		<cf_date tarih = 'attributes.ship_date' >
		<cfset attributes.deliver_date_frm = createdatetime(year(attributes.deliver_date_frm),month(attributes.deliver_date_frm),day(attributes.deliver_date_frm),attributes.deliver_date_h,attributes.deliver_date_m,0)>	
		<cfif not len(attributes.location_id)><cfset attributes.location_id = "NULL"></cfif>
		<cfif not len(attributes.location_in_id)><cfset attributes.location_in_id = "NULL"></cfif>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
			<cfquery name="ADD_SALE" datasource="#new_dsn2#" result="MAX_ID">
				INSERT INTO
					#dsn2_alias#.SHIP
				(
					WRK_ID,
					PURCHASE_SALES,
					SHIP_NUMBER,
					DISPATCH_SHIP_ID,
					SHIP_TYPE,
					PROCESS_CAT,
					<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>SHIP_METHOD,</cfif>
					SHIP_DATE,
					<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					DELIVER_STORE_ID,
					LOCATION,
					DEPARTMENT_IN,
					LOCATION_IN,
					REF_NO,
					PROJECT_ID,
					PROJECT_ID_IN,
					WORK_ID,
					RECORD_DATE,
					RECORD_EMP,
					SHIP_DETAIL,
					IS_RECEIVED_WEBSERVICE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#SHIP_NUMBER#">,
					<cfif isdefined("attributes.dispatch_ship_id") and Len(attributes.dispatch_ship_id)>#attributes.dispatch_ship_id#<cfelse>NULL</cfif>,
					#get_process_type.process_type#,
					#form.process_cat#,
					<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#,</cfif>
					#attributes.ship_date#,
					<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,</cfif>
					<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>0#attributes.BASKET_DISCOUNT_TOTAL#<cfelse>0</cfif>,
					<cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#<cfelse>0</cfif>,
					<cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#<cfelse>0</cfif>,
					<cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#<cfelse>0</cfif>,
					'TL',
					0,
					#attributes.department_id#,
					#attributes.location_id#,
					#attributes.department_in_id#,
					#attributes.location_in_id#,
					<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.project_id") and len(attributes.project_id) and Len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and Len(attributes.project_head_in)>#attributes.project_id_in#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					<cfif isdefined('attributes.ship_detail') and len(attributes.ship_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_detail#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.webService')>1<cfelse>0</cfif>
				)
			</cfquery>
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfif Len(Evaluate("attributes.stock_id#i#")) and Len(Evaluate("attributes.product_id#i#"))><!--- FBS 20120502 Bu kontrol action file ile olusan irsaliye kaydi icin eklenmistir --->
					<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
						<cfset dsn_type=new_dsn2>
						<cfinclude template="/V16/objects/query/add_basket_spec.cfm">
					</cfif>
					<cf_date tarih = 'attributes.deliver_date#i#'>
					<cfinclude template="/v16/stock/query/get_dis_amount.cfm">
					<!---<cfif isdefined("attributes.is_delivered")>
						<cfif len(attributes.DELIVER_DATE_FRM)>
							<cfset my_date = attributes.DELIVER_DATE_FRM>
						<cfelse>
							<cfset my_date = attributes.SHIP_DATE>
						</cfif>
						<cfquery name="get_stock_age" datasource="#dsn2#">
							SELECT * FROM
								(
									SELECT 
										I.SHIP_ID,
										S.PRODUCT_ID,
										ISNULL(I.DELIVER_DATE,I.SHIP_DATE) AS ISLEM_TARIHI,
										ISNULL(DATEDIFF(day,I.DELIVER_DATE,#my_date#),DATEDIFF(day,I.SHIP_DATE,#my_date#))  AS GUN_FARKI,
										IR.AMOUNT
									FROM 
										SHIP I WITH (NOLOCK),
										SHIP_ROW IR WITH (NOLOCK),
										#dsn3_alias#.STOCKS S
									WHERE 
										I.SHIP_ID = IR.SHIP_ID AND
										S.STOCK_ID=IR.STOCK_ID AND	
										I.SHIP_TYPE IN(76,87) AND
										I.IS_SHIP_IPTAL = 0 AND
										I.SHIP_DATE <= #now()#
										AND S.STOCK_ID = #evaluate("attributes.stock_id#i#")#
									UNION ALL
									SELECT 
										I.FIS_ID SHIP_ID,
										S.PRODUCT_ID,
										I.FIS_DATE ISLEM_TARIHI,
										DATEDIFF(day,FIS_DATE,#my_date#) + ISNULL(DUE_DATE,0) GUN_FARKI,
										IR.AMOUNT
									FROM 
										STOCK_FIS I,
										STOCK_FIS_ROW IR,
										#dsn3_alias#.STOCKS S
									WHERE 
										I.FIS_ID = IR.FIS_ID AND
										S.STOCK_ID=IR.STOCK_ID AND
										I.FIS_TYPE IN (110,114,115,119) AND
										I.FIS_DATE <= #now()#
										AND S.STOCK_ID = #evaluate("attributes.stock_id#i#")#
								) T1
								ORDER BY
									ISLEM_TARIHI DESC,
									SHIP_ID DESC
						</cfquery>
						<cfif get_stock_age.recordcount>
							<cfquery name="get_total_stock" datasource="#dsn2#">
								SELECT 
									SUM(STOCK_IN-STOCK_OUT) TOTAL_STOCK
								FROM
									STOCKS_ROW
								WHERE
									PRODUCT_ID = #evaluate("attributes.product_id#i#")#
									AND PROCESS_DATE <= #NOW()#	
									AND PROCESS_TYPE NOT IN (81,811)
							</cfquery>
							<cfset genel_agirlikli_toplam=0>
							<cfset toplam_donem_sonu_stok=0>
							<cfif get_total_stock.recordcount>
								<cfquery name="get_product_detail" dbtype="query">
									SELECT 
										AMOUNT AS PURCHASE_AMOUNT,
										GUN_FARKI
									FROM 
										GET_STOCK_AGE 
									WHERE 
										PRODUCT_ID = #evaluate("attributes.product_id#i#")#
								</cfquery>
								<cfset donem_sonu_stok=get_total_stock.TOTAL_STOCK>
								<cfset toplam_donem_sonu_stok = toplam_donem_sonu_stok + donem_sonu_stok>
								<cfset agirlikli_toplam=0>
								<cfset kalan = donem_sonu_stok>
								<cfloop query="get_product_detail">
									<cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
										<cfset kalan = kalan - PURCHASE_AMOUNT>
										<cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
									<cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
										<cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
										<cfset kalan = 0>
									</cfif>
								</cfloop>
							</cfif>	
							<cfif toplam_donem_sonu_stok gt 0><cfset 'attributes.set_duedate#i#' = agirlikli_toplam/toplam_donem_sonu_stok></cfif>
						</cfif> 
					<!--- <pre>
						<cfdump var="#get_stock_age#">
						<cfdump var="#get_total_stock#">
						<cfdump var="#get_product_detail#">
						
						<cfabort>--->
					</cfif>--->
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>
						<cfset product_name_other_ = evaluate('attributes.product_name_other#i#')>
					</cfif>
					<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#"> 
						INSERT INTO
							#dsn2_alias#.SHIP_ROW
						(
							NAME_PRODUCT,
							PAYMETHOD_ID,
							SHIP_ID,
							STOCK_ID,
							PRODUCT_ID,
							AMOUNT,
							UNIT,
							UNIT_ID,
							TAX,
						  <cfif len(evaluate("attributes.price#i#"))>
							PRICE,
						  </cfif>
							DISCOUNT,
							PURCHASE_SALES,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							DISCOUNT6,
							DISCOUNT7,
							DISCOUNT8,
							DISCOUNT9,
							DISCOUNT10,
							DISCOUNTTOTAL,
							GROSSTOTAL,
							NETTOTAL,
							TAXTOTAL,
							DELIVER_DATE,
							DELIVER_DEPT,
							DELIVER_LOC,
						  <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
						  </cfif>
							LOT_NO,
							PRICE_OTHER,
							OTHER_MONEY_GROSS_TOTAL,
							IS_PROMOTION,
							OTHER_MONEY,
							OTHER_MONEY_VALUE,
							UNIQUE_RELATION_ID,
							PRODUCT_NAME2,
							AMOUNT2,
							UNIT2,
							EXTRA_PRICE,
							EXTRA_PRICE_TOTAL,
							SHELF_NUMBER,
							TO_SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE,
							BASKET_EXTRA_INFO_ID,
							SELECT_INFO_EXTRA,
							DETAIL_INFO_EXTRA,
							ROW_INTERNALDEMAND_ID,
							CATALOG_ID,
							OTV_ORAN,
							OTVTOTAL,
							DARA,
							DARALI,
							WRK_ROW_ID,
							WRK_ROW_RELATION_ID,
							WIDTH_VALUE,
							DEPTH_VALUE,
							HEIGHT_VALUE,
							ROW_PROJECT_ID,
							EXTRA_COST,
							COST_PRICE,
							DUE_DATE,
							  ROW_WORK_ID
							<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
							<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
							<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
							<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),250)#">,
							<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>NULL</cfif>,
							#MAX_ID.IDENTITYCOL#,
							#evaluate("attributes.stock_id#i#")#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.amount#i#")#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
							#evaluate("attributes.unit_id#i#")#,
							#evaluate("attributes.tax#i#")#,
						  <cfif len(evaluate("attributes.price#i#"))>
							#evaluate("attributes.price#i#")#,
						  </cfif>
							#0#,
							1,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							#0#,
							0,
							0,
							0,
						<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
							#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
						<cfelseif isdefined('attributes.department_in_id') and len(attributes.department_in_id)>
							#attributes.department_in_id#,
						<cfelse>
							NULL,
						</cfif>
						<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
							#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
						<cfelseif isdefined('attributes.location_in_id') and len(attributes.location_in_id)>
							#attributes.location_in_id#,
						<cfelse>
							NULL,
						</cfif>
						  <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
							#evaluate('attributes.spect_id#i#')#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">,
						  </cfif>
						<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.price_other#i#") and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
							0,
						<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_name_other_#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.to_shelf_number#i#') and len(evaluate('attributes.to_shelf_number#i#')) and isdefined('attributes.to_shelf_number_txt#i#') and len(evaluate('attributes.to_shelf_number_txt#i#'))>#evaluate('attributes.to_shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
						<!--- <cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#')) neq 0>#evaluate('attributes.row_ship_id#i#')#<cfelse>NULL</cfif>, --->
						<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
						<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
						<cfif isdefined('attributes.set_duedate#i#') and len(evaluate('attributes.set_duedate#i#'))>#evaluate('attributes.set_duedate#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
						<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
						)
					</cfquery> 
			
					<cfif get_process_type.is_stock_action eq 1><!--- Stok hareketi yapılsın --->
						<cfif evaluate('attributes.is_inventory#i#') eq 1>
							<cfinclude template="/V16/stock/query/get_unit_add_fis.cfm">
							<cfif get_unit.recordcount and len(get_unit.multiplier)>
								<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
							<cfelse>
								<cfset multi=evaluate("attributes.amount#i#")>
							</cfif>
							<cfset form_spect_main_id="">
							<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
								<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
								<cfif len(form_spect_id) and len(form_spect_id)>
									<cfquery name="GET_MAIN_SPECT" datasource="#new_dsn2#">
										SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
									</cfquery>
									<cfif GET_MAIN_SPECT.RECORDCOUNT>
										<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
									</cfif>
								</cfif>
							</cfif>
							<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
								SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#evaluate("attributes.product_id#i#")#) AND IS_KARMA = 1
							</cfquery>
							<cfif GET_KARMA_PRODUCTS.recordcount>
								<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
									SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID =#evaluate("attributes.product_id#i#")#
								</cfquery>
								<cfif GET_KARMA_PRODUCT.recordcount>
										<cfloop query="GET_KARMA_PRODUCT">
										<cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)><!--- karma koli satırındaki urun için spec seçilmisse, hem o ürün hem de sevkte birleştirilen urunleri için stok hareketi yazılır --->
													<cfquery name="GET_SPEC_PRODUCT" datasource="#dsn2#">
														SELECT 
															PRODUCT_ID,
															STOCK_ID,
															AMOUNT,
															RELATED_MAIN_SPECT_ID
														FROM
															#dsn3_alias#.SPECT_MAIN_ROW
														WHERE
															IS_SEVK = 1 AND
															STOCK_ID IS NOT NULL AND
															PRODUCT_ID IS NOT NULL AND
															SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCT.SPEC_MAIN_ID#">
													</cfquery>
												<cfif GET_SPEC_PRODUCT.recordcount>
													<cfloop query="GET_SPEC_PRODUCT">
														   <cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
																INSERT INTO 
																	#dsn2_alias#.STOCKS_ROW
																(
																	UPD_ID,
																	PRODUCT_ID,
																	STOCK_ID,
																	PROCESS_TYPE,
																	STOCK_OUT,
																	STORE,
																	STORE_LOCATION,
																	PROCESS_DATE,
																	PROCESS_TIME,
																	<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
																		SPECT_VAR_ID,
																	</cfif>
																	AMOUNT2,
																	UNIT2,
																	DELIVER_DATE,
																	SHELF_NUMBER,
																	DEPTH_VALUE,
																	WIDTH_VALUE,
																	HEIGHT_VALUE
																)
																VALUES
																(
																	#MAX_ID.IDENTITYCOL#,
																	#GET_SPEC_PRODUCT.product_id#,
																	#GET_SPEC_PRODUCT.stock_id#,
																	#get_process_type.process_type#,
																	#multi*GET_SPEC_PRODUCT.product_amount#,
																	#attributes.department_id#,
																	#attributes.location_id#,
																	#attributes.ship_date#,
																	#attributes.deliver_date_frm#,
																	<cfif isdefined('form_spect_id') and len(form_spect_id)>
																		<cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_KARMA_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
																	</cfif>
																	<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
																	<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
																)
														</cfquery>
													</cfloop>
												</cfif>
										</cfif> 
												<cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
													INSERT INTO 
														#dsn2_alias#.STOCKS_ROW
													(
														UPD_ID,
														PRODUCT_ID,
														STOCK_ID,
														PROCESS_TYPE,
														STOCK_OUT,
														STORE,
														STORE_LOCATION,
														PROCESS_DATE,
														PROCESS_TIME,
														<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
															SPECT_VAR_ID,
														</cfif>
														AMOUNT2,
														UNIT2,
														DELIVER_DATE,
														SHELF_NUMBER,
														DEPTH_VALUE,
														WIDTH_VALUE,
														HEIGHT_VALUE
													)
													VALUES
													(
														#MAX_ID.IDENTITYCOL#,
														#GET_KARMA_PRODUCT.product_id#,
														#GET_KARMA_PRODUCT.stock_id#,
														#get_process_type.process_type#,
														#multi*GET_KARMA_PRODUCT.product_amount#,
														#attributes.department_id#,
														#attributes.location_id#,
														#attributes.ship_date#,
														#attributes.deliver_date_frm#,
														<cfif isdefined('form_spect_id') and len(form_spect_id)>
															   <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
														</cfif>
														<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
														<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
														<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
														<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
														<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
														<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
														<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
													)
											</cfquery>
										  </cfloop>
								   </cfif>
							<cfelse>                        
								<cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
								INSERT INTO 
									#dsn2_alias#.STOCKS_ROW
								(
									UPD_ID,
									PRODUCT_ID,
									STOCK_ID,
									PROCESS_TYPE,
									STOCK_OUT,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE,
									PROCESS_TIME,
									<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
										SPECT_VAR_ID,
									</cfif>
									LOT_NO,
									PRODUCT_MANUFACT_CODE,				
									AMOUNT2,
									UNIT2,
									DELIVER_DATE,
									SHELF_NUMBER,
									DEPTH_VALUE,
									WIDTH_VALUE,
									HEIGHT_VALUE
								)
								VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									#evaluate("attributes.product_id#i#")#,
									#evaluate("attributes.stock_id#i#")#,
									#get_process_type.process_type#,
									#multi#,
									#attributes.department_id#,
									#attributes.location_id#,
									#attributes.ship_date#,
									#attributes.deliver_date_frm#,
									<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
										#form_spect_main_id#,
									</cfif>
									<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
									<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>
								)
							</cfquery>
							</cfif>				
						</cfif>
					</cfif>
				</cfif>
				<!--- Burasi eklemede satir bazinda girilen serilerin belge numaralarini guncellemeyi sagliyor --->
				<cfquery name="upd_serial" datasource="#dsn2#">
					UPDATE
						#dsn3_alias#.SERVICE_GUARANTY_NEW
					SET
						PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
						SPECT_ID = <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#<cfelse>NULL</cfif>,
						PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number#">,
						PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">,
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					WHERE
						WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#">
						AND PROCESS_ID = 0
				</cfquery>
			</cfloop>
			<cfscript>
				if( len(attributes.location_in_id) and len(attributes.department_in_id)) //giris deposu kontrol ediliyor
				{
					LOCATION_IN=cfquery(datasource:"#new_dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_in_id# AND SL.LOCATION_ID=#attributes.location_in_id#");
					location_type_in = LOCATION_IN.LOCATION_TYPE;
					is_scrap_in = LOCATION_IN.IS_SCRAP;
					branch_id_in=LOCATION_IN.BRANCH_ID;
				}
				else
				{
					location_type_in =''; branch_id_in=''; is_scrap_in='';
				}
				if( len(attributes.location_id) and len(attributes.department_id)) //cikis deposu kontrol ediliyor
				{	
					LOCATION_OUT=cfquery(datasource:"#new_dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_id# AND SL.LOCATION_ID=#attributes.location_id#");
					location_type_out = LOCATION_OUT.LOCATION_TYPE;
					is_scrap_out = LOCATION_OUT.IS_SCRAP;
					branch_id_out= LOCATION_OUT.BRANCH_ID;
				}
				else
				{
					location_type_out = ''; branch_id_out=''; is_scrap_out='';
				}
					
				/*1-Hammadde,2-Mal,3-Mamul,4-Konsinye*/
				if(get_process_type.is_account eq 1 and (location_type_in neq location_type_out or is_dept_based_acc eq 1))
				{
					include('ship_account_process.cfm');
					muhasebeci(
						action_id : MAX_ID.IDENTITYCOL,
						workcube_process_type : get_process_type.process_type,
						workcube_process_cat:form.process_cat,
						account_card_type : 13,
						islem_tarihi : attributes.ship_date,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : borc_alacak_tutar,
						other_amount_borc : str_dovizli_tutarlar,
						other_currency_borc : str_doviz_currency,
						borc_miktarlar : str_miktar,
						borc_birim_tutar : str_tutar,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : borc_alacak_tutar,
						other_amount_alacak : str_dovizli_tutarlar,
						other_currency_alacak :str_doviz_currency,
						alacak_miktarlar : str_miktar,
						alacak_birim_tutar : str_tutar,
						fis_detay : "DEPO SEVK İRSALİYESİ",
						fis_satir_detay : satir_detay_list,
						belge_no : SHIP_NUMBER,
						from_branch_id : branch_id_out,
						to_branch_id : branch_id_in,
						is_account_group : get_process_type.is_account_group,
						currency_multiplier : currency_multiplier,
						acc_project_list_alacak : acc_project_list_alacak,
						acc_project_list_borc : acc_project_list_borc
					);			
				}
				basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0,transaction_dsn:new_dsn2);
				
				if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //depo sevk ic talepten olusturulmussa
				{
					add_internaldemand_row_relation(
						to_related_action_id:MAX_ID.IDENTITYCOL,
						to_related_action_type:1,
						action_status:0,
						process_db:new_dsn2
						);
				}
			</cfscript>	
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#MAX_ID.IDENTITYCOL#"
				action_table="SHIP"
				action_column="SHIP_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#MAX_ID.IDENTITYCOL#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#new_dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
	
				<cfif not isdefined("attributes.webService")> 
					<cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name="#attributes.ship_number# Eklendi" paper_no="#attributes.ship_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
				</cfif>  
			</cftransaction>
		</cflock>
	</cfif>
	
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfif isdefined("attributes.is_serial_no#i#")>
			<cfif isdefined("attributes.guaranty_purchasesales#i#") and len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1) >
				 <cfscript>
					add_serial_no(
						session_row : i,
						is_insert : true,
						action_id : MAX_ID.IDENTITYCOL,
						action_type : 2,
						action_number  : '#SHIP_NUMBER#',
						is_sale : true,
						dpt_id : attributes.department_in_id,
						loc_id : attributes.location_in_id
					);
				 </cfscript>
				 <cfscript>
					add_serial_no(
						session_row : i,
						is_insert : false,
						dpt_id : attributes.department_id,
						loc_id : attributes.location_id
					);
				 </cfscript>
				 
			</cfif>
		</cfif>
	</cfloop> 		
	 <cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>
		<cfquery name="UPD_PAPERS" datasource="#new_dsn2#">
			UPDATE
				#dsn3_alias#.PAPERS_NO
			SET
				SHIP_NUMBER = #attributes.paper_number#
			WHERE
			<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
				PRINTER_ID = #attributes.paper_printer_id#
			<cfelse>
				EMPLOYEE_ID = #SESSION.EP.USERID#
			</cfif>
		</cfquery>
	</cfif> 
	<cfif not isdefined('attributes.webService')>
		<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
			<cfif get_module_user(13)>
				<script type="text/javascript">
					document.location.href = '<cfoutput>#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
				</script>
			<cfelse>
				<script type="text/javascript">
					alert("<cf_get_lang no ='521.İrsaliye Başarıyla Oluşturuldu'>!");
					document.location.href = '<cfoutput>#request.self#?fuseaction=service.service_ship</cfoutput>';
				</script>
			</cfif>
		<cfelse>
			<script type="text/javascript">
				document.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
			</script>
		</cfif>
	</cfif> 
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"> <!--- sayfanin en ustunde acilisi var --->
	
	