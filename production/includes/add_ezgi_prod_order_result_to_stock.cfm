<cfquery name="GET_ROW_RESULT" datasource="#DSN3#">
	SELECT
		PRODUCTION_ORDER_RESULTS.ORDER_NO,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_ORDER_NO,
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.PROCESS_ID,
		PRODUCTION_ORDER_RESULTS.FINISH_DATE,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
		PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
		PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID,
		PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID,
		PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
		PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
		PRODUCTION_ORDER_RESULTS.POSITION_ID,
		PRODUCTION_ORDER_RESULTS.LOT_NO,
		PRODUCTION_ORDER_RESULTS_ROW.TYPE,
		PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
		PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
		PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
		PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID,
		PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,
		PRODUCTION_ORDER_RESULTS_ROW.NAME_PRODUCT,
		PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
		PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.COST_ID,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM AMOUNT_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM_TOTAL TOTAL_PRICE,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_MONEY OTHER_MONEY_CURRENCY,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET OTHER_MONEY,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_TOTAL OTHER_MONEY_TOTAL,
		PRODUCTION_ORDER_RESULTS_ROW.UNIT_NAME,
		PRODUCTION_ORDER_RESULTS_ROW.SPECT_NAME,
		PRODUCTION_ORDER_RESULTS_ROW.IS_SEVKIYAT,
		PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM PURCHASE_EXTRA_COST,
		PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS
	FROM
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDER_RESULTS_ROW
	WHERE
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #attributes.pr_order_id# AND
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
</cfquery>
<cfif GET_ROW_RESULT.IS_STOCK_FIS eq 1><!--- fis kesildi ise geri geldiginde tekrar kayıt yapmasın diye --->
 	<script type="text/javascript">
		history.go(-1);
	</script>   
</cfif>
<cfquery name="GET_ROW" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 1
</cfquery>
<cfquery name="GET_ROW_EXIT" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 2 AND IS_SEVKIYAT = 0
</cfquery>
<cfquery name="GET_ROW_OUTAGE" dbtype="query">
	SELECT * FROM GET_ROW_RESULT WHERE TYPE = 3
</cfquery>
<cfquery name="GET_MONEY_FIS" datasource="#dsn3#">
	SELECT * FROM #dsn2_alias#.SETUP_MONEY<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
</cfquery>

<cfset deliver_name = get_emp_info(session.ep.userid,0,0)>
<!---<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>--->
	<cfquery name="GET_PROCESS_TYPE_URT" datasource="#DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_STOCK_ACTION,
			IS_COST
		 FROM 
			SETUP_PROCESS_CAT
		WHERE 
			PROCESS_TYPE = <cfif is_demontaj>119<cfelse>110</cfif>
	</cfquery>
	<cfquery name="GET_PROCESS_TYPE_SARF" datasource="#DSN3#">
		SELECT 
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_STOCK_ACTION
		 FROM 
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_TYPE = 111
	</cfquery>
   	<cfquery name="GET_PROCESS_TYPE_FIRE" datasource="#DSN3#">
			SELECT 
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				IS_STOCK_ACTION
			 FROM 
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_TYPE = 112
		</cfquery>
        <cfquery name="GET_PROCESS_TYPE_DEP_ARASI" datasource="#dsn3#">
			SELECT 
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				IS_STOCK_ACTION
			 FROM 
				SETUP_PROCESS_CAT 
			WHERE 
				PROCESS_TYPE = 81
		</cfquery>
	<!--- üretimden giriş --->
	<cf_papers paper_type="stock_fis">
	<cfscript>
		value_finish_date = now();
		attributes.system_paper_no = paper_code & '-' & paper_number;
		attributes.system_paper_no_add = paper_number;
		attributes.fis_no = attributes.system_paper_no;
		attributes.fis_type = GET_PROCESS_TYPE_URT.PROCESS_TYPE;
	</cfscript>
	
	<!--- Uretim --->
	<cfquery name="ADD_STOCK_FIS_1" datasource="#DSN3#">
		INSERT INTO 
			#dsn2_alias#.STOCK_FIS
		(
			FIS_TYPE,
			PROCESS_CAT,
			FIS_NUMBER,
			DEPARTMENT_IN,
			LOCATION_IN,
			PROD_ORDER_RESULT_NUMBER,
			PROD_ORDER_NUMBER,
			EMPLOYEE_ID,
			FIS_DATE,
			PROJECT_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			REF_NO
		)
		VALUES
		(
			#attributes.fis_type#,
			#GET_PROCESS_TYPE_URT.PROCESS_CAT_ID#,
		   '#attributes.fis_no#',
			#get_row.production_dep_id#,
			#get_row.production_loc_id#,
			#get_row.pr_order_id#,
			#get_row.p_order_id#,
			<cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
			#value_finish_date#,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
		   '#cgi.remote_addr#',
		   '#get_row.order_no#'
		)
	</cfquery>
	<cfquery name="GET_ID" datasource="#DSN3#">
		SELECT

			MAX(FIS_ID) MAX_ID
		FROM
			#dsn2_alias#.STOCK_FIS STOCK_FIS
	</cfquery>
	<cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
		<cfquery name="ADD_FIS_MONEY" datasource="#dsn3#">
			INSERT INTO
				#dsn2_alias#.STOCK_FIS_MONEY
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#GET_ID.MAX_ID#,
					'#GET_MONEY_FIS.MONEY#',
					#GET_MONEY_FIS.RATE2#,
					#GET_MONEY_FIS.RATE1#,
					<cfif GET_MONEY_FIS.MONEY eq session.ep.money2>1<cfelse>0</cfif>
				)
		</cfquery>
	</cfoutput>
	<cfoutput query="get_row">
		<cfscript>
			amount_rw = get_row.amount;
			_form_products_id_ = get_row.product_id;
			_form_stocks_id_ = get_row.stock_id;
			form_spect_id = get_row.spect_id;
			form_spect_name = get_row.spect_name;
			form_spec_main_id = get_row.SPEC_MAIN_ID;
			form_unit_id = get_row.unit_id;
			form_unit2 =  get_row.unit2;
			_form_amounts_ = get_row.amount;
			form_amount2 = get_row.amount2;
			form_amount_price = get_row.amount_price;
			form_tax = get_row.kdv_price;
			//form_total_price = get_row.total_price
			form_other_money = get_row.other_money;
			form_other_money_currency = get_row.other_money_currency;
			form_extra_cost = get_row.PURCHASE_EXTRA_COST;
		</cfscript>
		<cfquery name="GET_UNIT" datasource="#DSN3#">
			SELECT 
				ADD_UNIT,
				MULTIPLIER,
				MAIN_UNIT,
				PRODUCT_UNIT_ID
			FROM
				PRODUCT_UNIT 
			WHERE 
				PRODUCT_ID = #_form_products_id_# AND
				PRODUCT_UNIT_ID = '#form_unit_id#'
		</cfquery>
		<cfif get_unit.recordcount and len(get_unit.multiplier)>
			<cfset multi = get_unit.multiplier*amount_rw>
		<cfelse>
			<cfset multi = amount_rw>
		</cfif>
        <cfif len(form_spec_main_id) and form_spec_main_id gt 0 and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
			<cfscript>
            //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
            main_to_spect = specer(
                        dsn_type:dsn3,
                        spec_type:1,
                        main_spec_id:form_spec_main_id,
                        add_to_main_spec:1
                );
            </cfscript>
            <cfset form_spect_id = listgetat(main_to_spect,2,',')>
		</cfif>
        
		<cfquery name="ADD_STOCK_FIS_ROW_1" datasource="#DSN3#">
			INSERT INTO 
				#dsn2_alias#.STOCK_FIS_ROW
			(
				FIS_ID,
				FIS_NUMBER,
				STOCK_ID,
				AMOUNT,
                AMOUNT2,
				UNIT,
                UNIT2,					
				UNIT_ID,
				PRICE,
				TAX,
				TOTAL,
				TOTAL_TAX,
				NET_TOTAL,
				SPECT_VAR_ID,
                SPEC_MAIN_ID,
				SPECT_VAR_NAME,
				LOT_NO,
				OTHER_MONEY,
				PRICE_OTHER,
				COST_PRICE,
				EXTRA_COST
			)
			VALUES
			(
				#get_id.max_id#,
				'#attributes.fis_no#',						
				#_form_stocks_id_#,
				#amount_rw#,
                <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
				'#get_unit.main_unit#',
                <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
				#form_unit_id#,
				#form_amount_price#,
				#form_tax#,
				#amount_rw*form_amount_price#,
				#(amount_rw*form_amount_price*form_tax)/100#,
				#amount_rw*form_amount_price#,																						
				<cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
				<cfif len(form_spec_main_id) and form_spec_main_id gt 0 >#form_spec_main_id#<cfelse>NULL</cfif>,
				<cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
				<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>,
				'#form_other_money_currency#',
				#form_other_money#,
				#form_amount_price#,
				<cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>
			)
		</cfquery>
        
		<cfquery name="ADD_STOCK_ROW" datasource="#DSN3#">
			INSERT INTO
				#dsn2_alias#.STOCKS_ROW
			(
				UPD_ID,
				PRODUCT_ID,
				STOCK_ID,
				PROCESS_TYPE,
				STOCK_IN,
				STORE,
				STORE_LOCATION,
				PROCESS_DATE,
				SPECT_VAR_ID,
				LOT_NO
			)
			VALUES
			(
				#get_id.max_id#,
				#_form_products_id_#,
				#_form_stocks_id_#,
				#attributes.fis_type#,
				#multi#,
				#get_row.production_dep_id#,
				#get_row.production_loc_id#,
				#value_finish_date#,
				<cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>,
				<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfoutput>
	
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
		WHERE
			STOCK_FIS_NUMBER IS NOT NULL
	</cfquery>
	
	<!--- sarf fisi--->
	<cf_papers paper_type="stock_fis">
	<cfscript>
		attributes.system_paper_no = paper_code & '-' & paper_number;
		attributes.system_paper_no_add = paper_number;
		attributes.fis_no = attributes.system_paper_no;
		attributes.fis_type = GET_PROCESS_TYPE_SARF.PROCESS_TYPE;
	</cfscript>
	<cfquery name="ADD_STOCK_FIS_2" datasource="#DSN3#">
		INSERT INTO 
			#dsn2_alias#.STOCK_FIS
		(
			FIS_TYPE,
			PROCESS_CAT,
			FIS_NUMBER,
			DEPARTMENT_OUT,
			LOCATION_OUT,
			PROD_ORDER_RESULT_NUMBER,
			PROD_ORDER_NUMBER,
			EMPLOYEE_ID,
			FIS_DATE,
			PROJECT_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			REF_NO
		)
		VALUES
		(
			#attributes.fis_type#,
			#GET_PROCESS_TYPE_SARF.PROCESS_CAT_ID#,
		   '#attributes.fis_no#',
			#get_row.exit_dep_id#,
			#get_row.exit_loc_id#,
			#get_row.pr_order_id#,
			#attributes.p_order_id#,
			<cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
			#value_finish_date#,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
		   '#cgi.remote_addr#',
		   '#get_row.order_no#'
		)
	</cfquery>
    
	<cfquery name="GET_ID_EXIT" datasource="#DSN3#">
		SELECT
			MAX(FIS_ID) MAX_ID
		FROM
			#dsn2_alias#.STOCK_FIS STOCK_FIS
	</cfquery>
	<cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
		<cfquery name="ADD_FIS_MONEY" datasource="#dsn3#">
			INSERT INTO
				#dsn2_alias#.STOCK_FIS_MONEY
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#GET_ID_EXIT.MAX_ID#,
					'#GET_MONEY_FIS.MONEY#',
					#GET_MONEY_FIS.RATE2#,
					#GET_MONEY_FIS.RATE1#,
					<cfif GET_MONEY_FIS.MONEY eq session.ep.money2>1<cfelse>0</cfif>
				)
		</cfquery>
	</cfoutput>
	<cfoutput query="get_row_exit">
		<cfscript>
			amount_rw = get_row_exit.amount;
			_form_products_id_ = get_row_exit.product_id;
			_form_stocks_id_ = get_row_exit.stock_id;
			form_spect_id = get_row_exit.spect_id;
			form_spect_name = get_row_exit.SPECT_NAME;
			form_spec_main_id = get_row_exit.spec_main_id;
			form_unit_id = get_row_exit.unit_id;
			form_unit2 = get_row_exit.unit2;
			_form_amounts_ = get_row_exit.amount;
			form_amount2 = get_row_exit.amount2;
			form_amount_price = get_row_exit.amount_price;
			form_tax = get_row_exit.kdv_price;
			form_total_price = get_row_exit.total_price;
			//form_kdv_price = get_row_exit.total_kdv;
			form_other_money = get_row_exit.other_money;
			form_other_money_currency = get_row_exit.other_money_currency;
			form_extra_cost = get_row_exit.PURCHASE_EXTRA_COST;
			form_cost_id = get_row_exit.COST_ID;
		</cfscript>
		<cfquery name="getShelvesStc" datasource="#dsn3#">
			select PPR.PRODUCT_PLACE_ID,PP.SHELF_CODE from PRODUCT_PLACE_ROWS AS PPR
			LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
			WHERE  PP.STORE_ID=#get_row.exit_dep_id# AND PP.LOCATION_ID=#get_row.exit_loc_id#
		AND STOCK_ID=#_form_stocks_id_#
		</cfquery>
		<cfset shelf_id="">
		<cfset shelf_number="">
		<cfif getShelvesStc.recordCount>
			<cfset shelf_number=getShelvesStc.PRODUCT_PLACE_ID>
			<cfset shelf_id=getShelvesStc.SHELF_CODE>
		</cfif>
		<cfsavecontent  variable="control5">
			
			
			
		   </cfsavecontent>
		   <cffile action="write" file = "c:\PBS\getShelvesStc_#currentrow#.html" output="#control5#"></cffile>
		<cfquery name="GET_UNIT" datasource="#DSN3#">
			SELECT 
				ADD_UNIT,
				MULTIPLIER,
				MAIN_UNIT,
				PRODUCT_UNIT_ID
			FROM
				PRODUCT_UNIT 
			WHERE 
				PRODUCT_ID = #_form_products_id_# AND
				PRODUCT_UNIT_ID = '#form_unit_id#' AND
                PRODUCT_UNIT_STATUS = 1
		</cfquery>
		<cfif get_unit.recordcount and len(get_unit.multiplier)>
			<cfset multi = get_unit.multiplier*amount_rw>
		<cfelse>
			<cfset multi = amount_rw>
		</cfif>
        <cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
			<cfscript>
            //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
            main_to_spect = specer(
                        dsn_type:dsn3,
                        spec_type:1,
                        main_spec_id:form_spec_main_id,
                        add_to_main_spec:1
                );
            </cfscript>
            <cfset form_spect_id = listgetat(main_to_spect,2,',')>
		</cfif>

		<cfquery name="ADD_STOCK_FIS_ROW_2" datasource="#DSN3#">
			INSERT INTO 
				#dsn2_alias#.STOCK_FIS_ROW
			(
				FIS_ID,
				FIS_NUMBER,
				STOCK_ID,
				AMOUNT,
                AMOUNT2,
				UNIT,
                UNIT2,
				UNIT_ID,					
				PRICE,
				TAX,
				TOTAL,
				TOTAL_TAX,
				NET_TOTAL,
				SPECT_VAR_ID,
                SPEC_MAIN_ID,
				SPECT_VAR_NAME,
				
				LOT_NO,
				OTHER_MONEY,
				PRICE_OTHER,
				COST_PRICE,
				EXTRA_COST,
				SHELF_NUMBER
			)
			VALUES
			(
				#get_id_exit.max_id#,
				'#attributes.fis_no#',							
				#_form_stocks_id_#,
				#amount_rw#,
                <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
				'#get_unit.main_unit#',
                <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
				#form_unit_id#,
				#form_amount_price#,
				#form_tax#,
				#amount_rw*form_amount_price#,
				#(amount_rw*form_amount_price*form_tax)/100#,
				#amount_rw*form_amount_price#,																						
				<cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>,
				<cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
				<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>,
				'#form_other_money_currency#',
				#form_other_money#,
				#form_amount_price#,
				<cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>,
					<cfif len(shelf_number)>#shelf_number#<cfelse>NULL</cfif>
				<!--- ,<cfif len(form_cost_id)>#form_cost_id#<cfelse>NULL</cfif> --->
			)
		</cfquery>
		
		<cfquery name="ADD_STOCK_ROW_2" datasource="#DSN3#">
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
				SPECT_VAR_ID,
				LOT_NO,
				SHELF_NUMBER
			)
			VALUES
			(
				#get_id_exit.max_id#,
				#_form_products_id_#,
				#_form_stocks_id_#,
				#attributes.fis_type#,
				#multi#,
				#get_row_exit.exit_dep_id#,
				#get_row_exit.exit_loc_id#,
				#value_finish_date#,
				<cfif len(form_spec_main_id) and  form_spec_main_id gt 0>#form_spec_main_id#,<cfelse>NULL,</cfif>
				<cfif len(get_row_exit.lot_no)>'#get_row_exit.lot_no#'<cfelse>NULL</cfif>,
				<cfif len(shelf_number)>'#shelf_number#'<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfoutput>
	
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
		WHERE
			STOCK_FIS_NUMBER IS NOT NULL
	</cfquery>
	
	<!---fire--->
	<cfif get_row_outage.recordcount>
		<cf_papers paper_type="stock_fis">
		<cfscript>
			attributes.system_paper_no = paper_code & '-' & paper_number;
			attributes.system_paper_no_add = paper_number;
			attributes.fis_no = attributes.system_paper_no;
			attributes.fis_type = GET_PROCESS_TYPE_FIRE.PROCESS_TYPE;
		</cfscript>
		<cfquery name="ADD_STOCK_FIS_2" datasource="#DSN3#">
			INSERT INTO 
				#dsn2_alias#.STOCK_FIS
			(
				FIS_TYPE,
				PROCESS_CAT,
				FIS_NUMBER,
				DEPARTMENT_OUT,
				LOCATION_OUT,
				PROD_ORDER_RESULT_NUMBER,
				PROD_ORDER_NUMBER,
				EMPLOYEE_ID,
				FIS_DATE,
				PROJECT_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				REF_NO
			)
			VALUES
			(
				#attributes.fis_type#,
				#GET_PROCESS_TYPE_FIRE.PROCESS_CAT_ID#,
			   '#attributes.fis_no#',
				#get_row_outage.exit_dep_id#,
				#get_row_outage.exit_loc_id#,
				#get_row_outage.pr_order_id#,
				#attributes.p_order_id#,
				<cfif len(get_row_outage.position_id)>#get_row_outage.position_id#<cfelse>NULL</cfif>,
				#value_finish_date#,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
			   '#cgi.remote_addr#',
			   '#get_row.order_no#'
			)
		</cfquery>
		<cfquery name="GET_ID_OUTAGE" datasource="#DSN3#">
			SELECT
				MAX(FIS_ID) MAX_ID
			FROM
				#dsn2_alias#.STOCK_FIS STOCK_FIS
		</cfquery>
		<cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
			<cfquery name="ADD_FIS_MONEY" datasource="#dsn3#">
				INSERT INTO
					#dsn2_alias#.STOCK_FIS_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#GET_ID_OUTAGE.MAX_ID#,
						'#GET_MONEY_FIS.MONEY#',
						#GET_MONEY_FIS.RATE2#,
						#GET_MONEY_FIS.RATE1#,
						<cfif GET_MONEY_FIS.MONEY eq session.ep.money2>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfoutput>
        
		<cfoutput query="get_row_outage">
			<!--- stok fisine spect id yaziliyor ancak stock_row tablosuna main spect yazilmali--->
			<cfset form_spect_main_id="">		
			<cfscript>
				amount_rw = get_row_outage.amount;
				_form_products_id_ = get_row_outage.product_id;
				_form_stocks_id_ = get_row_outage.stock_id;
				form_spect_id = get_row_outage.spect_id;
				form_spec_main_id = get_row_outage.spec_main_id;
				form_unit_id = get_row_outage.unit_id;
				form_unit2 = get_row_outage.unit2;
				_form_amounts_ = get_row_outage.amount;
				form_amount2 = get_row_outage.amount2;
				form_amount_price = get_row_outage.amount_price;
				form_tax = get_row_outage.kdv_price;
				form_total_price = get_row_outage.total_price;
				form_spect_name = get_row_outage.spect_name;
				form_other_money = get_row_outage.other_money;
				form_other_money_currency = get_row_outage.other_money_currency;
				form_extra_cost = get_row_outage.purchase_extra_cost;
				form_cost_id = get_row_outage.cost_id;
			</cfscript>
			<cfquery name="GET_UNIT" datasource="#DSN3#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					PRODUCT_UNIT 
				WHERE 
					PRODUCT_ID = #_form_products_id_# AND
					PRODUCT_UNIT_ID = '#form_unit_id#'
			</cfquery>
			<cfif get_unit.recordcount and len(get_unit.multiplier)>
				<cfset multi = get_unit.multiplier*amount_rw>
			<cfelse>
				<cfset multi = amount_rw>
			</cfif>
			<cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
				<cfscript>
                //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                main_to_spect = specer(
                            dsn_type:dsn3,
                            spec_type:1,
                            main_spec_id:form_spec_main_id,
                            add_to_main_spec:1
                    );
                </cfscript>
                <cfset form_spect_id = listgetat(main_to_spect,2,',')>
            </cfif>

			<cfquery name="ADD_STOCK_FIS_ROW_2" datasource="#DSN3#">
				INSERT INTO 
					#dsn2_alias#.STOCK_FIS_ROW
				(
					FIS_ID,
					FIS_NUMBER,
					STOCK_ID,
					AMOUNT,
                    AMOUNT2,
					UNIT,
                    UNIT2,
					UNIT_ID,					
					PRICE,
					TAX,
					TOTAL,
					TOTAL_TAX,
					NET_TOTAL,
					SPECT_VAR_ID,
                    SPEC_MAIN_ID,
					SPECT_VAR_NAME,
					LOT_NO,
					OTHER_MONEY,
					PRICE_OTHER,
					COST_PRICE,
					EXTRA_COST,
					SHELF_NUMBER
					<!--- ,COST_ID --->
				)
				VALUES
				(
					#GET_ID_OUTAGE.max_id#,
					'#attributes.fis_no#',							
					#_form_stocks_id_#,
					#amount_rw#,
                    <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
					'#get_unit.main_unit#',
                    <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
					#form_unit_id#,
					#form_amount_price#,
					#form_tax#,
					#amount_rw*form_amount_price#,
					#(amount_rw*form_amount_price*form_tax)/100#,
					#amount_rw*form_amount_price#,																						
					<cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
					<cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#,<cfelse>null,</cfif>
					<cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
					<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>,
					'#form_other_money_currency#',
					#form_other_money#,
					#form_amount_price#,
					#form_extra_cost#,
					<cfif len(shelf_number)>'#shelf_number#'<cfelse>NULL</cfif>
					<!--- ,<cfif len(form_cost_id)>#form_cost_id#<cfelse>NULL</cfif> --->
				)
			</cfquery>
			
			<cfquery name="ADD_STOCK_ROW_2" datasource="#DSN3#">
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
					SPECT_VAR_ID,
					LOT_NO,
					SHELF_NUMBER

				)
				VALUES
				(
					#GET_ID_OUTAGE.max_id#,
					#_form_products_id_#,
					#_form_stocks_id_#,
					#attributes.fis_type#,
					#multi#,
					#get_row_outage.exit_dep_id#,
					#get_row_outage.exit_loc_id#,
					#value_finish_date#,
					<cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#,<cfelse>null,</cfif>
					<cfif len(get_row_exit.lot_no)>'#get_row_outage.lot_no#'<cfelse>null</cfif>,
						<cfif len(shelf_number)>'#shelf_number#'<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfoutput>
		
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS
			SET
				STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
			WHERE
				STOCK_FIS_NUMBER IS NOT NULL
		</cfquery>
	</cfif>
	
	<!--- Sevkiyat --->
	<cfif len(get_row.production_dep_id) and len(get_row.enter_dep_id)>
    	
			<cfset sonuc_sira=''>
 			<cfquery name="GET_ROW_RESULT_COUNT" datasource="#DSN3#">
				SELECT
					PR_ORDER_ID
				FROM
					PRODUCTION_ORDER_RESULTS
				WHERE
					P_ORDER_ID=#get_row.P_ORDER_ID#
				ORDER BY
					PR_ORDER_ID
			</cfquery>
			<cfif GET_ROW_RESULT_COUNT.RECORDCOUNT GT 1>
				<cfloop query="GET_ROW_RESULT_COUNT">
					<cfif GET_ROW_RESULT_COUNT.PR_ORDER_ID eq get_row.pr_order_id>
						<cfset sonuc_sira='-#currentrow#'>
					</cfif>
				</cfloop>
			</cfif>
			<!--- <cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
				SELECT 
					PROCESS_CAT_ID,
					PROCESS_TYPE,
					IS_STOCK_ACTION
				 FROM 
					SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_TYPE = 81
			</cfquery> --->
			<cfscript>
				basket_net_total = 0;
				basket_gross_total = 0;
				basket_tax_total = 0;
			</cfscript>
			<cfloop query="get_row">
				<cfscript>
					basket_net_total = basket_net_total + get_row.amount_price;
					basket_gross_total = basket_gross_total + get_row.total_price;
					basket_tax_total = basket_tax_total +((get_row.total_price*form_tax)/100);
				</cfscript>
			</cfloop>
			<cfif len(session.ep.money2)>
				<cfquery name="GET_MONEY2" datasource="#dsn3#">
					SELECT MONEY, RATE1, RATE2 FROM #dsn2_alias#.SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY = '#session.ep.money2#'
				</cfquery>
			<cfelse><!--- 2. parabirimi seçili olmayan şirket olursa diye --->
				<cfset get_money2.rate1=1>
				<cfset get_money2.rate2=1>
				<cfset get_money2.money=session.ep.money>
			</cfif>
			<cfset irs_no='#get_row.production_order_no##sonuc_sira#'>
           
			<cfquery name="ADD_SALE" datasource="#dsn3#">
				INSERT 
				INTO 
					#dsn2_alias#.SHIP
					(
						PURCHASE_SALES,
						SHIP_NUMBER,
						SHIP_TYPE,
						PROCESS_CAT,
						SHIP_DATE,
						DELIVER_DATE,
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
						RECORD_DATE,
						RECORD_EMP,
						PROD_ORDER_NUMBER,
						PROD_ORDER_RESULT_NUMBER,
                        PROJECT_ID,
                        IS_DELIVERED,
                        DELIVER_EMP,
                      	DELIVER_EMP_ID
					)
				VALUES
					(
						1,
						'#irs_no#',
						#GET_PROCESS_TYPE_DEP_ARASI.PROCESS_TYPE#,
						#GET_PROCESS_TYPE_DEP_ARASI.PROCESS_CAT_ID#,
						#value_finish_date#,
						#value_finish_date#,
						0,
						#basket_net_total#,
						#basket_gross_total#,
						#basket_tax_total#,
						'#get_money2.money#',
						#((basket_net_total*get_money2.rate1)/get_money2.rate2)#,
						#get_row.production_dep_id#,
						#get_row.production_loc_id#,
						#get_row.enter_dep_id#,
						#get_row.enter_loc_id#,
						'#get_row.order_no#',
						#now()#,
						#session.ep.userid#,
						#get_row.p_order_id#,
						#get_row.pr_order_id#,
                        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                        1,
                        '#deliver_name#',
                        #session.ep.userid#
					)
			</cfquery>	
			<cfquery name="GET_ID" datasource="#dsn3#">
				SELECT MAX(SHIP_ID) AS MAX_ID FROM #dsn2_alias#.SHIP
			</cfquery>
			<cfoutput query="get_row">
				<cfscript>
					_form_products_id_ = get_row.product_id;
					_form_stocks_id_ = get_row.stock_id;
					_form_amounts_ = get_row.amount;
					form_amount2 = get_row.amount2;
					form_name_product = get_row.name_product;
					form_unit_id = get_row.unit_id;
					form_unit_name = get_row.unit_name;
					form_spect_name = get_row.spect_name;
					form_kdv_price = get_row.kdv_price;
					form_amount_price = get_row.amount_price;
					form_total_price = get_row.total_price;
					//form_total_kdv = get_row.total_kdv;
					form_spect_id = get_row.spect_id;
					form_spec_main_id = get_row.SPEC_MAIN_ID;
					form_spect_name = get_row.spect_name;
					form_other_money_currency = get_row.other_money_currency;
					form_other_money = get_row.other_money;
					form_other_total_money = get_row.other_money_total;
					form_extra_cost = get_row.PURCHASE_EXTRA_COST;
				</cfscript>
				<!--- <cfif not len(form_spec_main_id) and len(form_spect_id)><!--- Main spec yoksa ancak spect id varsa --->
					<cfquery name="GET_MAIN_SPECT" datasource="#DSN3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
					</cfquery>
				</cfif> --->
               <cfif len(form_spec_main_id) and form_spec_main_id gt 0  and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
					<cfscript>
                    //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                    main_to_spect = specer(
                                dsn_type:dsn3,
                                spec_type:1,
                                main_spec_id:form_spec_main_id,
                                add_to_main_spec:1
                        );
                    </cfscript>
                    <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                </cfif>
                 
				<cfquery name="ADD_SHIP_ROW" datasource="#dsn3#">
					INSERT 
					INTO
						#dsn2_alias#.SHIP_ROW
						(
							NAME_PRODUCT,
							SHIP_ID,
							STOCK_ID,
							PRODUCT_ID,
							AMOUNT,
                            AMOUNT2,
							UNIT,
                            UNIT2,
							UNIT_ID,
							TAX,
							PRICE,
							PURCHASE_SALES,
							DISCOUNTTOTAL,
							GROSSTOTAL,
							NETTOTAL,
							TAXTOTAL,
							DELIVER_DATE,
							DELIVER_DEPT,
							DELIVER_LOC,
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
							LOT_NO,
							OTHER_MONEY,
							PRICE_OTHER,
							OTHER_MONEY_VALUE,
							OTHER_MONEY_GROSS_TOTAL,
							IS_PROMOTION,
							COST_PRICE,
							EXTRA_COST
						)
					VALUES
						(
						   '#left(form_name_product,75)#',
							#get_id.max_id#,
							#_form_stocks_id_#,
							#_form_products_id_#,
							#_form_amounts_#,
                            <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
						   '#form_unit_name#',
                           <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
							#form_unit_id#,
							#form_kdv_price#,
							#form_amount_price#,
							1,
							0,
							#form_total_price#,<!--- *form_amount --->
							#form_amount_price*_form_amounts_#,
							#(form_total_price*_form_amounts_)*form_kdv_price/100#,
							#value_finish_date#,
							#get_row.production_dep_id#,
							#get_row.production_loc_id#,
							<cfif len(form_spect_id)>#form_spect_id#,<cfelse>NULL,</cfif>
							<cfif len(form_spect_name)>'#form_spect_name#',<cfelse>NULL,</cfif>
						   '#get_row.lot_no#',
						   '#form_other_money_currency#',
							#form_other_money#,
							#form_other_money*_form_amounts_#,
							#form_other_total_money#,<!--- *form_amount --->
							0,
							<cfif len(form_amount_price)>#form_amount_price#<cfelse>0</cfif>,
							<cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>
						)
				</cfquery>
                
				<cfif GET_PROCESS_TYPE_DEP_ARASI.IS_STOCK_ACTION eq 1>
                	
					<cfquery name="GET_UNIT" datasource="#dsn3#">
						SELECT ADD_UNIT, MULTIPLIER, MAIN_UNIT, PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = #_form_products_id_# AND ADD_UNIT = '#form_unit_id#'
					</cfquery>
					<cfif get_unit.recordcount and len(get_unit.multiplier)>
						<cfset multi=get_unit.multiplier*_form_amounts_>
					<cfelse>
						<cfset multi=_form_amounts_>
					</cfif>
					<cfquery name="ADD_STOCK_OUT_ROW" datasource="#dsn3#">
						INSERT
						INTO
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
								SPECT_VAR_ID,
								LOT_NO
							)
							VALUES
							(
								#get_id.max_id#,
								#_form_products_id_#,
								#_form_stocks_id_#,
								#GET_PROCESS_TYPE_DEP_ARASI.PROCESS_TYPE#,
								#multi#,
								#get_row.production_dep_id#,
								#get_row.production_loc_id#,
								#value_finish_date#,
								<cfif len(form_spec_main_id)>#form_spec_main_id#,<cfelse>NULL,</cfif>
							   <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
							)
					</cfquery>
                    <cfquery name="ADD_STOCK_IN_ROW" datasource="#dsn3#">
						INSERT
						INTO
							#dsn2_alias#.STOCKS_ROW
							(
								UPD_ID,
								PRODUCT_ID,
								STOCK_ID,
								PROCESS_TYPE,
								STOCK_IN,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
								SPECT_VAR_ID,
								LOT_NO
							)
							VALUES
							(
								#get_id.max_id#,
								#_form_products_id_#,
								#_form_stocks_id_#,
								#GET_PROCESS_TYPE_DEP_ARASI.PROCESS_TYPE#,
								#multi#,
								#get_row.enter_dep_id#,
								#get_row.enter_loc_id#,
								#value_finish_date#,
								<cfif len(form_spec_main_id)>#form_spec_main_id#,<cfelse>NULL,</cfif>
							   <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
        
		<!--- Eğer xml den operasyonlara sonuç girildi seçilmişse operasyon sonuçları kaydediliyor --->
		
  <!---</cftransaction>
</cflock>--->
<!--- fis kayıt edildiği zaman IS_STOCK_FIS 1 set ediliyor --->
<cfoutput> #attributes.pr_order_id#</cfoutput>

<cfquery name="UPD_RESULT" datasource="#DSN3#">
	UPDATE
		PRODUCTION_ORDER_RESULTS
	SET
		IS_STOCK_FIS=1
	WHERE
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #attributes.pr_order_id#
</cfquery>
<!--- su ana kadar emire girilen sonuçlardan stok fisi kesilenler toplam emirdeki miktarı karsılıyorsa rezerveyi kaldırıyoruz --->
<cfquery name="GET_P_O_R" datasource="#DSN3#">
	SELECT 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT),
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDER_RESULTS_ROW
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID=PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID=#GET_ROW_RESULT.P_ORDER_ID# AND
		PRODUCTION_ORDERS.STOCK_ID=PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
		PRODUCTION_ORDER_RESULTS_ROW.TYPE=<cfif is_demontaj eq 0>1<cfelse>2</cfif> AND
		PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS=1
	GROUP BY
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	HAVING 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT)>=PRODUCTION_ORDERS.QUANTITY
</cfquery>
<cfif GET_P_O_R.RECORDCOUNT>
	<cfquery name="UPD_PROD_ORDER" datasource="#dsn3#">
		UPDATE 
			PRODUCTION_ORDERS
		SET
			IS_STOCK_RESERVED = 0,
            IS_STAGE = 2<!--- üRETİM sONUÇLANDIRILDI YANİ STOK FİŞLERİ KESİLDİ! BİTTİ --->
		WHERE
			P_ORDER_ID =  #GET_ROW_RESULT.P_ORDER_ID#
	</cfquery>
</cfif>


