<cf_papers paper_type="stock_fis">
<!--- İşlem tipi--->
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#">
	SELECT 
		PROCESS_TYPE,
		PROCESS_CAT_ID,
		IS_CARI,
		IS_ACCOUNT,
		IS_STOCK_ACTION,
		IS_ACCOUNT_GROUP,
		IS_PROJECT_BASED_ACC,
		IS_COST,
		ACTION_FILE_NAME,
		ACTION_FILE_SERVER_ID,
		ACTION_FILE_FROM_TEMPLATE		
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = 364
</cfquery>
<!--- /İşlem tipi --->
<cfset multi="">
<cfset session_list="">
<cfparam name="attributes.fis_date" default="#DateFormat(Now(),'dd/mm/yyyy')#">
<cfif isdefined("paper_full") and isdefined("paper_number")>
  <cfset system_paper_no = paper_full>
  <cfset system_paper_no_add = paper_number>
  <cfelse>
  <cfset system_paper_no = "">
  <cfset system_paper_no_add = "">
</cfif>
<cfset attributes.department_in = ListFirst(URL.department_in,'-')>
<cfset attributes.location_in = ListLast(URL.department_in,'-')>
<cf_date tarih = 'attributes.fis_date'>
<cfset attributes.location_out = "NULL">
<cfset attributes.department_out = "NULL">
<cf_papers paper_type="STOCK_FIS">
<cfset paper_code = "PDA">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfset attributes.FIS_NO= system_paper_no>
<cfset attributes.PROCESS_CAT = 364>
<cfset attributes.FIS_TYPE = 110>
<cffunction name="get_stock_amount">
  <cfargument name="stock_id">
  <cfquery name="get_pro_stock" datasource="#DSN2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
		FROM
			#dsn_alias#.DEPARTMENT D,
			#dsn3_alias#.PRODUCT P,
			#dsn3_alias#.STOCKS S,
			STOCKS_ROW SR
		WHERE
			P.PRODUCT_ID = S.PRODUCT_ID AND
			S.STOCK_ID = SR.STOCK_ID AND
			D.DEPARTMENT_ID = SR.STORE AND
			D.DEPARTMENT_ID=#attributes.department_in# AND
			S.STOCK_ID = #attributes.stock_id#
		GROUP BY
			P.PRODUCT_ID, 
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.PROPERTY, 
			S.BARCOD, 
			D.DEPARTMENT_ID, 
			D.DEPARTMENT_HEAD
	</cfquery>
  <cfreturn get_pro_stock.product_stock>
</cffunction>
<cfquery name="ADD_STOCK_FIS" datasource="#DSN2#">
	INSERT INTO
		STOCK_FIS
	(
		FIS_TYPE,
		PROCESS_CAT,
        FIS_NUMBER,
		DEPARTMENT_OUT,
		LOCATION_OUT,
		DEPARTMENT_IN,
		LOCATION_IN,
		EMPLOYEE_ID,
		FIS_DATE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		#attributes.FIS_TYPE#,
		#attributes.PROCESS_CAT#,
        '#attributes.FIS_NO#',
		 #attributes.department_out#,
		 #attributes.location_out#,
		 #attributes.department_in#,
		 #attributes.location_in#,
		#session.pda.userid#,
		#attributes.FIS_DATE#,
		#now()#,
		#session.pda.userid#,
		'#cgi.remote_addr#'
	)
</cfquery>
<cfquery name="GET_ID" datasource="#DSN2#">
	SELECT 
		MAX(FIS_ID) MAX_ID
	FROM
		STOCK_FIS
</cfquery>
<cfquery name="add_paper_number" datasource="#dsn3#">
UPDATE 
		GENERAL_PAPERS
	SET
		STOCK_FIS_NUMBER = #system_paper_no_add#
	WHERE
		STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<cfquery name="get_fis_rate" datasource="#dsn#">
	SELECT
		MONEY, RATE1, RATE2
	FROM
		SETUP_MONEY
	WHERE
		(COMPANY_ID = #session.pda.our_company_id#) AND (PERIOD_ID = #session.pda.period_id#)
</cfquery>
<cfloop query="get_fis_rate">
  <cfquery name="add_spec_money" datasource="#dsn2#">
		INSERT INTO STOCK_FIS_MONEY 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#get_id.max_id#,
				'#money#',
				#rate2#,
				#rate1#,
				<cfif money eq '#session.pda.money#'>1<cfelse>0</cfif>
			)
</cfquery>
</cfloop>
<!--- dongu baslangıcı --->
<cfset satir = ListToArray(attributes.action_id,',')>
<cfset satir_toplam = ArrayLen(satir)>
<!--- <cfset attributes.kur_say = 3><!------ tl usd eur------------> --->
<cfset 'attributes.basket_money' = #session.pda.money#>
<cfloop from="1" to="#satir_toplam#" index="i">
  <cfset 'attributes.stock_id#i#' = trim(ListFirst(satir[i],'-'))>
  <cfset deger = mid(satir[i],len(evaluate("attributes.stock_id#i#"))+2,len(satir[i])-len(evaluate("attributes.stock_id#i#"))+2)>
  <cfset 'attributes.spectmainid#i#' = trim(ListFirst(deger,'-'))>
  <cfset 'attributes.amount#i#' = trim(ListLast(deger,'-'))>
  <cfset 'attributes.hidden_rd_money_#i#' = #session.pda.money#>
  <cfset 'attributes.txt_rate1_#i#' = '1'>
  <cfset 'attributes.txt_rate2_#i#' = '1'>
  <cfquery name="get_product_id" datasource="#dsn1#">
		SELECT
			TOP 1
			PRODUCT.PRODUCT_ID, PRODUCT.PRODUCT_NAME, PRODUCT_UNIT.UNIT_ID, PRODUCT_UNIT.ADD_UNIT, PRODUCT_UNIT.PRODUCT_UNIT_ID, #Evaluate('attributes.spectmainid#i#')# AS SPECT_MAIN_ID, #dsn3_alias#.SPECTS.SPECT_VAR_ID, #dsn3_alias#.SPECTS.SPECT_VAR_NAME
		FROM
			STOCKS LEFT OUTER JOIN  #dsn3_alias#.SPECTS ON STOCKS.STOCK_ID = #dsn3_alias#.SPECTS.STOCK_ID LEFT OUTER JOIN PRODUCT_UNIT ON STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID LEFT OUTER JOIN PRODUCT ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
		WHERE
			(PRODUCT.IS_PRODUCTION = 1) AND (STOCKS.STOCK_ID = #evaluate("attributes.stock_id#i#")#)
		ORDER BY 
			#dsn3_alias#.SPECTS.SPECT_VAR_ID DESC
</cfquery>
  <cfset 'attributes.product_id#i#'  = get_product_id.product_id>
  <cfset 'attributes.product_name#i#'  = get_product_id.product_name>
  <cfset 'attributes.spect_var_id#i#' = get_product_id.spect_var_id>
  <cfquery name="add_stock_row" datasource="#DSN2#">
		INSERT INTO 
			STOCK_FIS_ROW
				(
					FIS_ID,
					FIS_NUMBER,
					STOCK_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,							
					PRICE,
					PRICE_OTHER,
					TAX,
					DISCOUNT1,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					TOTAL,
					TOTAL_TAX,
					NET_TOTAL,
					DELIVER_DATE,
					RESERVE_DATE,
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
					LOT_NO,
					OTHER_MONEY,
					COST_PRICE,
					DISCOUNT_COST,
					EXTRA_COST,
					UNIQUE_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EXTRA_PRICE_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					ROW_INTERNALDEMAND_ID,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID
				)
		VALUES
				(
					#GET_ID.MAX_ID#,
					'#attributes.FIS_NO#',							
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					'#get_product_id.add_unit#',
					'#get_product_id.product_unit_id#',							
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					NULL,
					NULL,
					'#get_product_id.spect_var_id#',
					'#get_product_id.product_name#',
					NULL,
					'TL',
					0,
					0,
					0,
					NULL,
					NULL,
					NULL,
					NULL,
					0,
					0,
					NULL,
					NULL,
					NULL,
					NULL,
                    NULL
				)
	</cfquery>
  <cfquery name="get_product_tree#i#" datasource="#dsn3#">
		SELECT 
			STOCKS.PRODUCT_ID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT_TREE.PRODUCT_TREE_ID,
			PRODUCT_TREE.RELATED_ID,
			PRODUCT_TREE.HIERARCHY,
			PRODUCT_TREE.IS_TREE,
			PRODUCT_TREE.AMOUNT,
			PRODUCT_TREE.UNIT_ID,
			PRODUCT_TREE.STOCK_ID,
			PRODUCT_TREE.IS_CONFIGURE,
			PRODUCT_TREE.IS_SEVK,
            PRODUCT_TREE.SPECT_MAIN_ID,
            PRODUCT_TREE.LINE_NUMBER
		FROM 
			PRODUCT_TREE,
			STOCKS
		WHERE 
			PRODUCT_TREE.STOCK_ID=#evaluate("attributes.stock_id#i#")# AND
			PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID
</cfquery>
  <cfquery name="add_spects" datasource="#dsn3#">
		INSERT
				INTO
					SPECTS
					(
						SPECT_MAIN_ID,
						SPECT_VAR_NAME,
						SPECT_TYPE,
						PRODUCT_ID,
						STOCK_ID,
						TOTAL_AMOUNT,
						OTHER_MONEY_CURRENCY,
						OTHER_TOTAL_AMOUNT,
						PRODUCT_AMOUNT,
						PRODUCT_AMOUNT_CURRENCY,
						IS_TREE,
						FILE_NAME,
						FILE_SERVER_ID,
						MARJ_TOTAL_AMOUNT,
						MARJ_OTHER_TOTAL_AMOUNT,
						MARJ_AMOUNT,
						MARJ_PERCENT,
						DETAIL,
						RECORD_IP,
						RECORD_EMP,
						RECORD_DATE
					)
					VALUES
					(
						<!--- <cfif Len(get_product_id.spect_main_id) gt 0>#get_product_id.spect_main_id#<cfelse>NULL</cfif>, --->
						#evaluate("attributes.spectmainid#i#")#,
						'#get_product_id.product_name#',
						1,
						#get_product_id.product_id#,
						#evaluate("attributes.stock_id#i#")#,
						0,
						'TL',
						0,
						0,
						'TL',
						1,
						NULL,
						NULL,
						0,
						0,
						0,
						0,
						NULL,
						'#CGI.REMOTE_ADDR#',
						#session.pda.userid#,
						#now()#
					)
</cfquery>
<cfif Len(get_product_id.spect_var_id)>
<cfquery name="money_varmi" datasource="#dsn3#">
SELECT
	*
FROM
	SPECT_MONEY
WHERE
	ACTION_ID = #get_product_id.spect_var_id#
</cfquery>
<cfloop query="get_fis_rate">
<cfquery name="add_spec_money2" datasource="#dsn3#">
INSERT INTO SPECT_MONEY 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#get_product_id.spect_var_id#,
				'#money#',
				#rate2#,
				#rate1#,
				<cfif money eq '#session.pda.money#'>1<cfelse>0</cfif>
								
			)
</cfquery>
</cfloop>
</cfif>
  <cfquery name="get_spec_max_id#i#" datasource="#dsn3#">
SELECT MAX(SPECT_VAR_ID) AS MAX_ID FROM SPECTS
</cfquery>
  <cfloop query="get_product_tree#i#">
    <cfquery name="add_sub_spect" datasource="#dsn3#">
INSERT
				INTO
					SPECTS_ROW
					(
						SPECT_ID,
						PRODUCT_ID,
						STOCK_ID,
						AMOUNT_VALUE,
						TOTAL_VALUE,
						MONEY_CURRENCY,
						PRODUCT_NAME,
						IS_PROPERTY,
						IS_CONFIGURE,
						DIFF_PRICE,
						PROPERTY_ID,
						VARIATION_ID,
						TOTAL_MIN,
						TOTAL_MAX,
						TOLERANCE,
						IS_SEVK,
						PRODUCT_SPACE,
						PRODUCT_DISPLAY,
						PRODUCT_RATE,
						PRODUCT_LIST_PRICE,
						CALCULATE_TYPE,
						RELATED_SPECT_ID,
                        LINE_NUMBER

					)
					VALUES
					(
						#evaluate("get_spec_max_id#i#.max_id")#,
						#product_id#,
						#stock_id#,
						#amount#,
						0,
						'TL',
						'#product_name#',
						0,
						0,
						0,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						0,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						#related_id#,
   						NULL
                        
					)
</cfquery>
  </cfloop>
<cfset 'attributes.unit#i#' = 'get_product_id.add_unit#i#'>
<cfinclude template="../../../stock/query/get_unit_add_fis.cfm">
<cfscript>
if(isdefined("attributes.amount#i#"))amount_rw=evaluate("attributes.amount#i#"); else amount_rw=0;
</cfscript>
<cfif get_unit.recordcount and len(get_unit.multiplier)>
		<cfset multi=get_unit.multiplier*amount_rw>
	<cfelse>
		<cfset multi=amount_rw>
	</cfif>
<cfif isdefined('get_product_id.spect_id#i#') and len(evaluate('get_product_id.spect_id#i#'))>
			<cfset form_spect_id="#evaluate('get_product_id.spect_id#i#')#">
			<cfif len(form_spect_id) and len(form_spect_id)>
				<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
					SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
				</cfquery>
				<cfif GET_MAIN_SPECT.RECORDCOUNT>
					<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
				</cfif>
			</cfif>
		</cfif>
<cfquery name="ADD_STOCKS_ROW" datasource="#dsn2#">
			INSERT INTO 
				STOCKS_ROW
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
					LOT_NO,
					DELIVER_DATE,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,				
					AMOUNT2,
					UNIT2
				)
				VALUES
				(
					#GET_ID.MAX_ID#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.stock_id#i#")#,
					#attributes.FIS_TYPE#,
					#MULTI#,
					#attributes.department_in#,
					#attributes.location_in#,
					#attributes.FIS_DATE#,
					#evaluate("attributes.spectmainid#i#")#,
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>
				)
		</cfquery>
</cfloop>
<cflocation addtoken="no" url="#request.self#?fuseaction=pda.form_add_stok_fis">