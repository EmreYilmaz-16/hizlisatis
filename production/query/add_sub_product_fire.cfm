<!--- Üretim emrinde sarf ve fire oluşturma hgul--->
<cflock name="#CreateUUID()#" timeout="30">
<cftransaction>
	<cfif not isdefined("attributes.is_alternative")><!--- üretim emri eklenirken bu kısma girer. --->
		<!--- SARFLAR --->
		<cfif len(attributes.record_num_exit) and attributes.record_num_exit neq "">
			<cfquery name="del_prod_sarf" datasource="#dsn3#">
				DELETE FROM PRODUCTION_ORDERS_STOCKS WHERE TYPE = 2 AND P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.p_order_id,1,',')#">
			</cfquery> 
			<cfloop from="1" to="#attributes.record_num_exit#" index="st">
				<cfif isdefined("attributes.row_kontrol_exit#st#") and evaluate("attributes.row_kontrol_exit#st#")>
					<cfscript>
						form_spec_main_id_exit = evaluate("attributes.spec_main_id_exit#st#");
						if(isdefined("attributes.spect_main_row_exit#st#"))
							form_spect_main_row_exit = evaluate("attributes.spect_main_row_exit#st#");
						else
							form_spect_main_row_exit = '';
						if(isdefined("attributes.spect_id_exit#st#"))
							form_spect_id_exit = evaluate("attributes.spect_id_exit#st#");
						else
							form_spect_id_exit = '';
						form_product_id_exit = evaluate("attributes.product_id_exit#st#");
						form_stock_id_exit = evaluate("attributes.stock_id_exit#st#");
						form_amount_exit = filternum(evaluate("attributes.amount_exit#st#"),8);
						form_unit_id_exit = evaluate("attributes.unit_id_exit#st#");
						form_is_phantom_exit = evaluate("attributes.is_phantom_exit#st#");
						form_is_sevk_exit = evaluate("attributes.is_sevk_exit#st#");
						form_is_property_exit = evaluate("attributes.is_property_exit#st#");
						form_is_free_amount_exit = evaluate("attributes.is_free_amount_exit#st#");
						if(isdefined("attributes.line_number_exit#st#"))
						{
							form_line_number_exit = evaluate("attributes.line_number_exit#st#");
						}
						else
						{
							form_line_number_exit = 0;
						}
						if(isdefined("attributes.wrk_row_id_exit#st#"))
						{
							form_wrk_row_id_exit = evaluate("attributes.wrk_row_id_exit#st#");
						}
						else
						{
							form_wrk_row_id_exit = '';
						}
						if(isdefined("attributes.fire_amount_exit#st#"))
						{
							form_fire_amount_exit = evaluate("attributes.fire_amount_exit#st#");
						}
						else
						{
							form_fire_amount_exit = 0;
						}
						if(isdefined("attributes.fire_rate_exit#st#"))
						{
							form_fire_rate_exit = evaluate("attributes.fire_rate_exit#st#");
						}
						else
						{
							form_fire_rate_exit = 0;
						}
						if(isdefined("attributes.lot_no_exit#st#"))
						{
							form_lot_no_exit = evaluate("attributes.lot_no_exit#st#");
						}
						else
						{
							form_lot_no_exit = '';
						}
					</cfscript>
					<cfif (len(form_is_free_amount_exit) or len(form_fire_rate_exit)) and form_spec_main_id_exit gt 0>
						<cfquery name="get_product_info" datasource="#dsn3#">
							SELECT ISNULL(IS_FREE_AMOUNT,0) IS_FREE_AMOUNT,IS_SEVK,IS_PROPERTY,ISNULL(IS_PHANTOM,0) IS_PHANTOM,FIRE_AMOUNT,FIRE_RATE,ISNULL(LINE_NUMBER,0) LINE_NUMBER FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = #form_spec_main_id_exit#
						</cfquery>
					<cfelse>
						<cfset get_product_info.is_free_amount = 0>
						<cfset get_product_info.IS_PROPERTY = 0>
						<cfset get_product_info.IS_SEVK = 0>
						<cfset get_product_info.IS_PHANTOM = 0>
						<cfset get_product_info.FIRE_AMOUNT = 0>
						<cfset get_product_info.FIRE_RATE = 0>
                        <cfset get_product_info.LINE_NUMBER = 0>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.row_kontrol_exit#st#") and evaluate("attributes.row_kontrol_exit#st#") eq 1>
                	<cfif len(form_wrk_row_id_exit)>
                    	<cfset wrk_id_new_sarf = form_wrk_row_id_exit>
                    <cfelse>
						<cfset wrk_id_new_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#ListGetAt(attributes.p_order_id,1,',')#S#form_stock_id_exit#'>
                    </cfif>
					<cfquery name="add_sarf" datasource="#dsn3#">
						INSERT INTO
							PRODUCTION_ORDERS_STOCKS
						(
							P_ORDER_ID,
							PRODUCT_ID,
							STOCK_ID,
							SPECT_MAIN_ID,
							AMOUNT,
							TYPE,
							PRODUCT_UNIT_ID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							IS_PHANTOM,
							IS_SEVK,
							IS_PROPERTY,
							IS_FREE_AMOUNT,
							FIRE_AMOUNT,
							FIRE_RATE,
                            LINE_NUMBER,
							SPECT_MAIN_ROW_ID,
							IS_FLAG,
							WRK_ROW_ID,
                            LOT_NO,
                            SPECT_VAR_ID
						)
						VALUES
						(
							#ListGetAt(attributes.p_order_id,1,',')#,
							<cfif len(form_product_id_exit)>#form_product_id_exit#<cfelse>NULL</cfif>,
							<cfif len(form_stock_id_exit)>#form_stock_id_exit#<cfelse>NULL</cfif>,
							<cfif len(form_spec_main_id_exit) and form_spec_main_id_exit gt 0>#form_spec_main_id_exit#<cfelse>NULL</cfif>,
							<cfif len(form_amount_exit)>#form_amount_exit#<cfelse>NULL</cfif>,
							2,
							<cfif len(form_unit_id_exit)>#form_unit_id_exit#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#CGI.REMOTE_ADDR#',
							<cfif len(form_is_property_exit)>
								#form_is_phantom_exit#,
								#form_is_sevk_exit#,
								#form_is_property_exit#,
								<cfif len(form_is_free_amount_exit)>#form_is_free_amount_exit#<cfelse>NULL</cfif>,
								<cfif len(form_fire_amount_exit)>#form_fire_amount_exit#<cfelse>NULL</cfif>,
								<cfif len(form_fire_rate_exit)>#form_fire_rate_exit#<cfelse>NULL</cfif>,
								<cfif len(form_line_number_exit)>#form_line_number_exit#<cfelse>0</cfif>,
							<cfelse>
								#get_product_info.IS_PHANTOM#,
								#get_product_info.IS_SEVK#,
								#get_product_info.IS_PROPERTY#,
								<cfif len(get_product_info.is_free_amount)>#get_product_info.is_free_amount#<cfelse>NULL</cfif>,
								<cfif len(get_product_info.FIRE_AMOUNT)>#get_product_info.FIRE_AMOUNT#<cfelse>NULL</cfif>,
								<cfif len(get_product_info.FIRE_RATE)>#get_product_info.FIRE_RATE#<cfelse>NULL</cfif>,
                                <cfif len(get_product_info.LINE_NUMBER)>#get_product_info.LINE_NUMBER#<cfelse>0</cfif>,
							</cfif>
							<cfif len(form_spect_main_row_exit)>#form_spect_main_row_exit#<cfelse>NULL</cfif>,
							1,
							'#wrk_id_new_sarf#',
                            <cfif len(form_lot_no_exit)>'#form_lot_no_exit#'<cfelse>NULL</cfif>,
                            <cfif len(form_spect_id_exit)>#form_spect_id_exit#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- FİRELER --->
		<cfif len(attributes.record_num_outage) and attributes.record_num_outage neq "">
			<cfquery name="del_prod_fire" datasource="#dsn3#">
				DELETE FROM PRODUCTION_ORDERS_STOCKS WHERE TYPE = 3 AND P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.p_order_id,1,',')#">
			</cfquery> 
			<cfloop from="1" to="#attributes.record_num_outage#" index="st">
				<cfif isdefined("attributes.row_kontrol_outage#st#") and evaluate("attributes.row_kontrol_outage#st#")>
					<cfscript>
						form_spec_main_id_outage = evaluate("attributes.spec_main_id_outage#st#");
						if(isdefined("attributes.spect_main_row_outage#st#"))
							form_spect_main_row_outage = evaluate("attributes.spect_main_row_outage#st#");
						else
							form_spect_main_row_outage = '';
						if(isdefined("attributes.spect_id_outage#st#"))
							form_spect_id_outage = evaluate("attributes.spect_id_outage#st#");
						else
							form_spect_id_outage = '';
						form_product_id_outage = evaluate("attributes.product_id_outage#st#");
						form_stock_id_outage = evaluate("attributes.stock_id_outage#st#");
						form_amount_outage = filternum(evaluate("attributes.amount_outage#st#"),8);
						form_unit_id_outage = evaluate("attributes.unit_id_outage#st#");
						form_is_phantom_outage = evaluate("attributes.is_phantom_outage#st#");
						form_is_sevk_outage = evaluate("attributes.is_sevk_outage#st#");
						form_is_property_outage = evaluate("attributes.is_property_outage#st#");
						form_is_free_amount_outage = evaluate("attributes.is_free_amount_outage#st#");
						if(isdefined("attributes.line_number_outage#st#"))
						{
							form_line_number_outage = evaluate("attributes.line_number_outage#st#");
						}
						else
						{
							form_line_number_outage = 0;
						}
						if(isdefined("attributes.wrk_row_id_outage#st#"))
						{
							form_wrk_row_id_outage = evaluate("attributes.wrk_row_id_outage#st#");
						}
						else
						{
							form_wrk_row_id_outage = '';
						}
						if(isdefined("attributes.fire_amount_outage#st#"))
						{
							form_fire_amount_outage = evaluate("attributes.fire_amount_outage#st#");
						}
						else
						{
							form_fire_amount_outage = 0;
						}
						if(isdefined("attributes.fire_rate_outage#st#"))
						{
							form_fire_rate_outage = evaluate("attributes.fire_rate_outage#st#");
						}
						else
						{
							form_fire_rate_outage = 0;
						}
						if(isdefined("attributes.lot_no_outage#st#"))
						{
							form_lot_no_outage = evaluate("attributes.lot_no_outage#st#");
						}
						else
						{
							form_lot_no_outage = '';
						}
					</cfscript>
					<cfif len(form_is_free_amount_outage) and form_spec_main_id_outage gt 0>
						<cfquery name="get_product_info" datasource="#dsn3#">
							SELECT ISNULL(IS_FREE_AMOUNT,0) IS_FREE_AMOUNT,IS_SEVK,IS_PROPERTY,ISNULL(IS_PHANTOM,0) IS_PHANTOM,FIRE_AMOUNT,FIRE_RATE,ISNULL(LINE_NUMBER,0) LINE_NUMBER FROM SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = #form_spec_main_id_outage#
						</cfquery>
					<cfelse>
						<cfset get_product_info.is_free_amount = 0>
						<cfset get_product_info.IS_PROPERTY = 0>
						<cfset get_product_info.IS_SEVK = 0>
						<cfset get_product_info.IS_PHANTOM = 0>
						<cfset get_product_info.FIRE_AMOUNT = 0>
						<cfset get_product_info.FIRE_RATE = 0>
                        <cfset get_product_info.LINE_NUMBER = 0>
					</cfif>
				</cfif>
				<cfif isdefined("attributes.row_kontrol_outage#st#") and evaluate("attributes.row_kontrol_outage#st#") eq 1>
					<cfif len(form_wrk_row_id_outage)>
                    	<cfset wrk_id_new_fire = form_wrk_row_id_outage>
                    <cfelse>
						<cfset wrk_id_new_fire = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#ListGetAt(attributes.p_order_id,1,',')#F#form_stock_id_outage#'>
					</cfif>
                    <cfquery name="add_fire" datasource="#dsn3#">
						INSERT INTO
							PRODUCTION_ORDERS_STOCKS
						(
							P_ORDER_ID,
							PRODUCT_ID,
							STOCK_ID,
							SPECT_MAIN_ID,
							AMOUNT,
							TYPE,
							PRODUCT_UNIT_ID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							IS_PHANTOM,
							IS_SEVK,
							IS_PROPERTY,
							IS_FREE_AMOUNT,
							FIRE_AMOUNT,
							FIRE_RATE,
                            LINE_NUMBER,
							SPECT_MAIN_ROW_ID,
							IS_FLAG,
							WRK_ROW_ID,
                            LOT_NO,
                            SPECT_VAR_ID
						)
						VALUES
						(
							#ListGetAt(attributes.p_order_id,1,',')#,
							<cfif len(form_product_id_outage)>#form_product_id_outage#<cfelse>NULL</cfif>,
							<cfif len(form_stock_id_outage)>#form_stock_id_outage#<cfelse>NULL</cfif>,
							<cfif len(form_spec_main_id_outage) and form_spec_main_id_outage gt 0>#form_spec_main_id_outage#<cfelse>NULL</cfif>,
							<cfif len(form_amount_outage)>#form_amount_outage#<cfelse>NULL</cfif>,
							3,
							<cfif len(form_unit_id_outage)>#form_unit_id_outage#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#CGI.REMOTE_ADDR#',
							<cfif len(form_is_property_outage)>
								#form_is_phantom_outage#,
								#form_is_sevk_outage#,
								#form_is_property_outage#,
								<cfif len(form_is_free_amount_outage)>#form_is_free_amount_outage#<cfelse>NULL</cfif>,
								<cfif len(form_fire_amount_outage)>#form_fire_amount_outage#<cfelse>NULL</cfif>,
								<cfif len(form_fire_rate_outage)>#form_fire_rate_outage#<cfelse>NULL</cfif>,
                                <cfif len(form_line_number_outage)>#form_line_number_outage#<cfelse>0</cfif>,
							<cfelse>
								#get_product_info.IS_PHANTOM#,
								#get_product_info.IS_SEVK#,
								#get_product_info.IS_PROPERTY#,
								<cfif len(get_product_info.is_free_amount)>#get_product_info.is_free_amount#<cfelse>NULL</cfif>,
								<cfif len(get_product_info.FIRE_AMOUNT)>#get_product_info.FIRE_AMOUNT#<cfelse>NULL</cfif>,
								<cfif len(get_product_info.FIRE_RATE)>#get_product_info.FIRE_RATE#<cfelse>NULL</cfif>,
								<cfif len(get_product_info.LINE_NUMBER)>#get_product_info.LINE_NUMBER#<cfelse>0</cfif>,
							</cfif>
							<cfif len(form_spect_main_row_outage)>#form_spect_main_row_outage#<cfelse>NULL</cfif>,
							1,
							'#wrk_id_new_fire#',
                            <cfif len(form_lot_no_outage)>'#form_lot_no_outage#'<cfelse>NULL</cfif>,
                            <cfif len(form_spect_id_outage)>#form_spect_id_outage#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	<cfelse><!--- malzeme ihtiyaçları tablosunda satrıdaki sarf alternatif ürünüyle değiştirilmek istendiğinde bu kısma girer ve ilgili sarf yerine radio buttondan seçilen ürün sarf olarak kaydedilir. --->
		<cfset form_stock_id = listgetat(evaluate('attributes.alter_product#attributes.crtrow#'),1,'-')>
		<cfset form_product_id = listgetat(evaluate('attributes.alter_product#attributes.crtrow#'),2,'-')>
		<cfset form_unit_id = listgetat(evaluate('attributes.alter_product#attributes.crtrow#'),3,'-')>
		<cfquery name="upd_sarf" datasource="#dsn3#">
			UPDATE 
				PRODUCTION_ORDERS_STOCKS
			SET
				PRODUCT_ID = #form_product_id#,
				STOCK_ID = #form_stock_id#,
				PRODUCT_UNIT_ID = <cfif len(form_unit_id)>#form_unit_id#<cfelse>NULL</cfif>
			WHERE
				PRODUCT_ID = #attributes.sarf_product_id# AND
				STOCK_ID = #attributes.sarf_stock_id# AND
				TYPE = 2
		</cfquery>
		<!--- alternatif ürün değiştirildiğinde sarf güncellenirken, firesini siliyoruz. --->
		<cfquery name="get_fire" datasource="#dsn3#">
			SELECT PRODUCT_ID FROM PRODUCTION_ORDERS_STOCKS WHERE PRODUCT_ID = #attributes.sarf_product_id# AND STOCK_ID = #attributes.sarf_stock_id# AND TYPE = 3
		</cfquery>
		<cfif get_fire.recordcount>
			<cfquery name="upd_sarf" datasource="#dsn3#">
				UPDATE 
					PRODUCTION_ORDERS_STOCKS
				SET
					PRODUCT_ID = #form_product_id#,
					STOCK_ID = #form_stock_id#,
					PRODUCT_UNIT_ID = <cfif len(form_unit_id)>#form_unit_id#<cfelse>NULL</cfif>
				WHERE
					PRODUCT_ID = #attributes.sarf_product_id# AND
					STOCK_ID = #attributes.sarf_stock_id# AND
					TYPE = 3
			</cfquery>
		</cfif>
	</cfif>
</cftransaction>
</cflock>
