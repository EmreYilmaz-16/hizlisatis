
<cfquery name="GET_DET_PO" datasource="#DSN3#"><!--- Her bir üretim emri tek tek döndürülüyor! --->
	SELECT 
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDERS.SPECT_VAR_ID,
		PRODUCTION_ORDERS.SPEC_MAIN_ID,
		STOCKS.STOCK_CODE,
		PRODUCTION_ORDERS.STOCK_ID, 
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.STATION_ID,
		PRODUCTION_ORDERS.START_DATE,
		PRODUCTION_ORDERS.FINISH_DATE,
		PRODUCTION_ORDERS.QUANTITY AMOUNT,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.LOT_NO,
		STOCKS.PROPERTY, 
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_UNIT_ID,
		STOCKS.IS_PRODUCTION,
		STOCKS.IS_PROTOTYPE,
		STOCKS.PRODUCT_NAME, 
		STOCKS.PRODUCT_ID,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE,
		STOCKS.BARCOD,		
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.MAIN_UNIT,
		0 IS_SEVK,
        (
        SELECT     
        	TOP (1) PORR.ACTION_START_DATE
		FROM         
        	PRODUCTION_OPERATION AS POR INNER JOIN
            PRODUCTION_OPERATION_RESULT AS PORR ON POR.P_OPERATION_ID = PORR.OPERATION_ID
		WHERE     
        	POR.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
		ORDER BY 
        	PORR.ACTION_START_DATE
        ) AS OP_START_DATE
	FROM
		PRODUCTION_ORDERS,
		STOCKS,
		PRODUCT_UNIT
	WHERE 
		PRODUCTION_ORDERS.P_ORDER_ID =  #PARTNER_P_ORDER_ID# AND 
		PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND	
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID							
</cfquery>
<cfif not len(GET_DET_PO.SPEC_MAIN_ID) and not len(GET_DET_PO.SPEC_MAIN_ID.SPECT_VAR_ID)>
	<script type="text/javascript">
		alert('Üretim Yapılabilmesi İçin Üretilen Ürüne Spec Seçmeniz Gerekmektedir!');
	</script>
	<cfabort>
</cfif>
<cf_papers paper_type="production_result"><!--- Üretim Sonucu Her Satır İçin Ekleniyor! --->
<cfquery name="GET_STATION_INFO" datasource="#dsn3#">
	SELECT 
		DEPARTMENT,
		STATION_NAME,
		EXIT_DEP_ID,
		EXIT_LOC_ID,
		ENTER_DEP_ID,
		ENTER_LOC_ID,
		PRODUCTION_DEP_ID,
		PRODUCTION_LOC_ID
	FROM 
		WORKSTATIONS 
	WHERE 
		STATION_ID = #pws_id#
</cfquery>
<cfset attributes.finish_date = now()>
<cfset account_action_date = Dateformat(now(),'YYYY-MM-DD')&' '&Timeformat(now(),'HH:mm:ss')&'.0'>
<cfscript>
	system_paper_no = paper_code & '-' & paper_number;
	system_paper_no_add = paper_number;
</cfscript>
<cfif len(GET_DET_PO.OP_START_DATE)>
	<cfscript>
		attributes.start_date = CreateODBCDateTime(GET_DET_PO.OP_START_DATE);
	</cfscript>
<cfelse>
	<cfset attributes.start_date = now()>
</cfif>
<!---<cfscript>
	system_paper_no = paper_code & '-' & paper_number;
	system_paper_no_add = paper_number;
	attributes.start_date = CreateODBCDateTime(GET_DET_PO.START_DATE);
	attributes.finish_date = CreateODBCDateTime(GET_DET_PO.FINISH_DATE);
	account_action_date=GET_DET_PO.FINISH_DATE; /*muhasebe isleminde kullanılıyor*/
</cfscript>--->
<cfquery name="get_production_orders_rel" datasource="#dsn3#"><!--- Emirlerler ilişkili Siparişleri Çekiyoruz. --->
	SELECT 
		(SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = POR.ORDER_ID) AS ORDER_NUMBER
	FROM 
		PRODUCTION_ORDERS_ROW POR
	WHERE
		POR.PRODUCTION_ORDER_ID = #PARTNER_P_ORDER_ID#
</cfquery>
<cfif get_production_orders_rel.recordcount><!--- Sipariş numarası --->
	<cfset attributes.order_no = get_production_orders_rel.ORDER_NUMBER>
<cfelse>
	<cfset attributes.order_no = ''>
</cfif>

<cfquery name="ADD_PRODUCTION_ORDER" datasource="#DSN3#"><!--- Üretim Sonucu Ekliyoruz. --->
	SET NOCOUNT ON
	INSERT INTO 
		PRODUCTION_ORDER_RESULTS 
	( 
		P_ORDER_ID,
		PROCESS_ID,
		START_DATE,
		FINISH_DATE,
		EXIT_DEP_ID,
		EXIT_LOC_ID,
		STATION_ID,
		PRODUCTION_ORDER_NO,
		RESULT_NO,
		ENTER_DEP_ID,
		ENTER_LOC_ID,
		ORDER_NO,
		POSITION_ID ,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		LOT_NO,
		PRODUCTION_DEP_ID,
		PRODUCTION_LOC_ID,
		PROD_ORD_RESULT_STAGE,
		IS_STOCK_FIS
	)
	VALUES
	(
		#PARTNER_P_ORDER_ID#,
		#attributes.process_cat#,
		<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		<cfif len(GET_STATION_INFO.EXIT_DEP_ID)>'#GET_STATION_INFO.EXIT_DEP_ID#'<cfelse>NULL</cfif>,<!--- len(attributes.exit_department) and --->
		<cfif len(GET_STATION_INFO.EXIT_LOC_ID)>'#GET_STATION_INFO.EXIT_LOC_ID#'<cfelse>NULL</cfif>,<!--- len(attributes.exit_department) and  --->
		<cfif len(attributes.station_id_)>#attributes.station_id_#<cfelse>NULL</cfif>,<!---  and len(attributes.station_name) --->
		<cfif len(GET_DET_PO.P_ORDER_NO)>'#GET_DET_PO.P_ORDER_NO#'<cfelse>NULL</cfif>,
		<cfif len(paper_full)>'#paper_full#'<cfelse>NULL</cfif>,
		<cfif len(GET_STATION_INFO.ENTER_DEP_ID)>'#GET_STATION_INFO.ENTER_DEP_ID#'<cfelse>NULL</cfif>,<!--- len(attributes.enter_department) and  --->
		<cfif len(GET_STATION_INFO.ENTER_LOC_ID)>'#GET_STATION_INFO.ENTER_LOC_ID#'<cfelse>NULL</cfif>,<!--- len(attributes.enter_department) and  --->
		<cfif len(attributes.order_no)>'#attributes.order_no#'<cfelse>NULL</cfif>,<!--- Sipariş numarası --->                
		#attributes.employee_id_#,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#',
		<cfif len(GET_DET_PO.LOT_NO)>'#GET_DET_PO.LOT_NO#'<cfelse>NULL</cfif>,
		<cfif len(GET_STATION_INFO.PRODUCTION_DEP_ID)>'#GET_STATION_INFO.PRODUCTION_DEP_ID#'<cfelse>NULL</cfif>,<!--- len(attributes.production_department) and  --->
		<cfif len(GET_STATION_INFO.PRODUCTION_LOC_ID)>'#GET_STATION_INFO.PRODUCTION_LOC_ID#'<cfelse>NULL</cfif>,<!---  len(attributes.production_department) and  --->
		#attributes.process_stage#,
		0
	)
	SELECT @@Identity AS MAX_ID      
	SET NOCOUNT OFF
</cfquery>
<CFSET RESULT_ID_PBS_ID= ADD_PRODUCTION_ORDER.MAX_ID>
<cfquery name="upd_prod_order" datasource="#dsn3#"><!--- 1 OLUNCA ÜRETİM BAŞLAMIŞ OLUYOR! --->
	UPDATE PRODUCTION_ORDERS SET IS_STAGE = 1 WHERE P_ORDER_ID =  #PARTNER_P_ORDER_ID#
</cfquery>
<cfscript>
	value_price = 0;
	value_price_extra = 0;
</cfscript>
<cfif isdefined("attributes.realized_amount_") and len(attributes.realized_amount_)>
	<cfset miktar_ = get_end_operation.REAL_OPERATION-get_end_operation.URETILEN>
<cfelse>
	<cfset miktar_ = GET_DET_PO.AMOUNT>
</cfif>
<cfset katsayi = miktar_/GET_DET_PO.AMOUNT>
<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#"><!--- SARFLAR --->
	SELECT
		'Spec' AS NAME,
		POS.SPECT_MAIN_ID RELATED_SPECT_ID,
		POS.AMOUNT,
		POS.IS_SEVK,
		POS.IS_PROPERTY,
		POS.SPECT_MAIN_ID,
		POS.IS_FREE_AMOUNT ,
		'' PRODUCT_COST_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_ID,
		STOCKS.BARCOD,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.MAIN_UNIT,
		STOCKS.IS_PRODUCTION,
		STOCKS.TAX,
		STOCKS.TAX_PURCHASE,
		STOCKS.PRODUCT_UNIT_ID,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.MONEY,
		STOCKS.PROPERTY,
		POS.TYPE
	FROM
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS,
		PRODUCT_UNIT,
		PRICE_STANDART
	WHERE
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
		PRICE_STANDART.PURCHASESALES = 1 AND
		PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
		STOCKS.STOCK_STATUS = 1	AND
		POS.P_ORDER_ID = #attributes.upd_id# AND
		POS.IS_PROPERTY IN(0,4) AND
		<cfif get_det_po.is_demontaj eq 1> POS.IS_SEVK = 0 AND</cfif>
		POS.STOCK_ID = STOCKS.STOCK_ID AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
		STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
</cfquery>

<!--- SARFLAR --->
<cfif GET_SUB_PRODUCTS.recordcount>
		<cfloop query="GET_SUB_PRODUCTS"><!--- Sarflan Döndürülüyor! --->
			<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="1"><!--- Maliyet --->
				SELECT
					PRODUCT_COST_ID,
					PURCHASE_NET,
					PURCHASE_NET_MONEY,
					PURCHASE_NET_SYSTEM,
					PURCHASE_NET_SYSTEM_MONEY,
					PURCHASE_EXTRA_COST,
					PURCHASE_EXTRA_COST_SYSTEM,
					PRODUCT_COST,
					MONEY 
				FROM 
					PRODUCT_COST 
				WHERE 
					PRODUCT_ID = #PRODUCT_ID# AND
					START_DATE <= #attributes.finish_date#
				ORDER BY 
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfscript>
				//maliyet
				if(GET_PRODUCT.RECORDCOUNT eq 0)
				{
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = session.ep.money;
					cost_price = 0;
					cost_price_money = session.ep.money;
					cost_price_system = 0;
					cost_price_system_money = session.ep.money;
					purchase_extra_cost_system = 0;
				}
				else
				{
					cost_id = get_product.product_cost_id;
					purchase_extra_cost = GET_PRODUCT.PURCHASE_EXTRA_COST;
					product_cost = GET_PRODUCT.PRODUCT_COST;
					product_cost_money = GET_PRODUCT.MONEY;
					cost_price = GET_PRODUCT.PURCHASE_NET;
					cost_price_money = GET_PRODUCT.PURCHASE_NET_MONEY;
					cost_price_system = GET_PRODUCT.PURCHASE_NET_SYSTEM;
					cost_price_system_money = GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY;
					purchase_extra_cost_system = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
				}
				//-maliyet
					
				//form_spect_var_id_exit = evaluate("attributes.spect_id_exit#st#");
				form_spec_main_id_exit = RELATED_SPECT_ID;
				form_barcode_exit = BARCOD;
				form_product_id_exit = PRODUCT_ID;
				form_stock_id_exit = STOCK_ID;
				form_amount_exit = AMOUNT*katsayi;
				form_unit_id_exit = PRODUCT_UNIT_ID;
				form_exit_product_name = PRODUCT_NAME;
				form_exit_unit = MAIN_UNIT;
				if(form_spec_main_id_exit gt 0){
				specNameSqlStr="SELECT SPECT_MAIN_NAME FROM SPECT_MAIN  WHERE SPECT_MAIN_ID =#form_spec_main_id_exit#";
				specNameSqlQuery = workcube_query(SQLString : specNameSqlStr, Datasource : dsn3);
					if(specNameSqlQuery.recordcount)
						form_spect_name_exit = specNameSqlQuery.SPECT_MAIN_NAME;
					else
						form_spect_name_exit ='';
				}
				else
					form_spect_name_exit ='';
				form_is_production_spect_exit = IS_PRODUCTION;//eğer sarfa spect seçilmemişse ve üretilen bir ürünse bu sarf,otomatik olarak spect oluşacak.
				//maliyet tanımlamaları.	
				form_cost_id_exit = cost_id;
				form_kdv_amount_exit=TAX;
				form_cost_price_system_exit=cost_price_system;
				form_purchase_extra_cost_system_exit=purchase_extra_cost_system;
				form_purchase_extra_cost_exit=purchase_extra_cost;
				form_money_system_exit = cost_price_system_money;
				form_cost_price_exit = cost_price;
				form_money_exit = cost_price_money;
			</cfscript>
			<!--- Üretilen fakat spect seçilmemiş ürünler için spect kontrolü --->
			<cfif not len(RELATED_SPECT_ID) and IS_PRODUCTION eq 1 ><!--- spect seçilmemiş ise ve ürün üretiliyor ise --->
				<cfscript>
					new_spec_value = get_main_spect_id(STOCK_ID);
					if(len(new_spec_value.SPECT_MAIN_ID) )
						form_spec_main_id_exit = new_spec_value.SPECT_MAIN_ID;
					else
						form_spec_main_id_exit = 0;
				</cfscript>
			</cfif>
			<!--- Sarf --->
			<cfquery name="ADD_ROW_ENTER_S" datasource="#dsn3#">
				INSERT
				INTO
					PRODUCTION_ORDER_RESULTS_ROW
					(
						TYPE,
						PR_ORDER_ID,
						BARCODE,
						STOCK_ID,
						PRODUCT_ID,
						AMOUNT,
						UNIT_ID,
						NAME_PRODUCT,
						UNIT_NAME,
						IS_SEVKIYAT,
						SPEC_MAIN_ID,
						SPECT_NAME,
						COST_ID,
						KDV_PRICE,
						PURCHASE_NET_SYSTEM,
						PURCHASE_NET_SYSTEM_MONEY,
						PURCHASE_EXTRA_COST_SYSTEM,
						PURCHASE_NET_SYSTEM_TOTAL,
						PURCHASE_NET,
						PURCHASE_NET_MONEY,
						PURCHASE_EXTRA_COST,
						PURCHASE_NET_TOTAL
					)
					VALUES
					(
						2,
						#ADD_PRODUCTION_ORDER.MAX_ID#,
						<cfif len(form_barcode_exit)>'#form_barcode_exit#'<cfelse>NULL</cfif>,
						<cfif len(form_stock_id_exit)>#form_stock_id_exit#<cfelse>NULL</cfif>,
						<cfif len(form_product_id_exit)>#form_product_id_exit#<cfelse>NULL</cfif>,
						<cfif len(form_amount_exit)>#form_amount_exit#<cfelse>NULL</cfif>,
						<cfif len(form_unit_id_exit)>#form_unit_id_exit#<cfelse>NULL</cfif>,
						'#left(form_exit_product_name,75)#',
						'#left(form_exit_unit,75)#',
						<cfif IS_SEVK eq 1 >1<cfelse>0</cfif>,
						<cfif len(form_spec_main_id_exit) and form_spec_main_id_exit gt 0>#form_spec_main_id_exit#<cfelse>NULL</cfif>,
						<cfif len(form_spect_name_exit)>'#left(form_spect_name_exit,50)#'<cfelse>NULL</cfif>,
						<cfif len(form_cost_id_exit) and (form_cost_id_exit neq 0)>#form_cost_id_exit#<cfelse>NULL</cfif>,
						<cfif len(form_kdv_amount_exit)>#form_kdv_amount_exit#<cfelse>0</cfif>,
						<cfif len(form_cost_price_system_exit)>#form_cost_price_system_exit#<cfelse>0</cfif>,
						<cfif len(form_money_system_exit)>'#form_money_system_exit#'<cfelse>'#session.ep.money#'</cfif>,
						<cfif len(form_purchase_extra_cost_system_exit)>#form_purchase_extra_cost_system_exit#<cfelse>0</cfif>,
						<cfif len(form_cost_price_system_exit) and len(form_amount_exit)>#form_cost_price_system_exit*form_amount_exit#<cfelse>0</cfif>,
						<cfif len(form_cost_price_exit)>#form_cost_price_exit#<cfelse>0</cfif>,
						<cfif len(form_money_exit)>'#form_money_exit#'<cfelse>'#session.ep.money#'</cfif>,
						<cfif len(form_purchase_extra_cost_exit)>#form_purchase_extra_cost_exit#<cfelse>0</cfif>,
						<cfif len(form_cost_price_exit)>#form_cost_price_exit*form_amount_exit#<cfelse>0</cfif>
					)				
			</cfquery>
			<cfscript>
				if(not len(form_amount_exit))form_amount_exit=0;
				if(not len(form_cost_price_system_exit))form_cost_price_system_exit=0;
				if(not len(form_purchase_extra_cost_system_exit))form_purchase_extra_cost_system_exit=0;
				value_price = value_price + form_cost_price_system_exit * form_amount_exit;
				value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
			</cfscript>
		</cfloop>
</cfif>
<!--- Ana Ürün --->
<cfif GET_DET_PO.recordcount gt 0>
	<cfscript>
		birim_cost=value_price/100;
		birim_cost_extra=value_price_extra/100;
	</cfscript>
	<!--- Ana Ürün Dönüyor! --->
	<cfloop query="GET_DET_PO">
		<cfquery name="GET_PRODUCT_M" datasource="#dsn3#" maxrows="1"><!--- Ana Ürün İçin Maliyet Çekiliyor. --->
			SELECT 
				PRODUCT_COST_ID,
				PURCHASE_NET,
				PURCHASE_NET_MONEY,
				PURCHASE_NET_SYSTEM,
				PURCHASE_NET_SYSTEM_MONEY,
				PURCHASE_EXTRA_COST,
				PURCHASE_EXTRA_COST_SYSTEM,
				PRODUCT_COST,
				MONEY 
			FROM 
				PRODUCT_COST 
			WHERE 
				PRODUCT_ID = #PRODUCT_ID# AND
				START_DATE <= #now()# 
			ORDER BY 
				START_DATE DESC,
				RECORD_DATE DESC
		</cfquery>
		<cfscript>
			if(GET_PRODUCT_M.RECORDCOUNT eq 0)
			{
				m_cost_id = 0;
				m_purchase_extra_cost = 0;
				m_product_cost = 0;
				m_product_cost_money = session.ep.money;
				m_cost_price = 0;
				m_cost_price_money = session.ep.money;
				m_cost_price_system = 0;
				m_cost_price_system_money = session.ep.money;
				m_purchase_extra_cost_system = 0;
			}
			else
			{
				m_cost_id = GET_PRODUCT_M.product_cost_id;
				m_purchase_extra_cost = GET_PRODUCT_M.PURCHASE_EXTRA_COST;
				m_product_cost = GET_PRODUCT_M.PRODUCT_COST;
				m_product_cost_money = GET_PRODUCT_M.MONEY;
				m_cost_price = GET_PRODUCT_M.PURCHASE_NET;
				m_cost_price_money = GET_PRODUCT_M.PURCHASE_NET_MONEY;
				m_cost_price_system = GET_PRODUCT_M.PURCHASE_NET_SYSTEM;
				m_cost_price_system_money = GET_PRODUCT_M.PURCHASE_NET_SYSTEM_MONEY;
				m_purchase_extra_cost_system = GET_PRODUCT_M.PURCHASE_EXTRA_COST_SYSTEM;
			}
		</cfscript>
		<cfscript>
			form_barcode = BARCOD;
			form_product_id = PRODUCT_ID;
			form_stock_id = STOCK_ID;
			form_amount = miktar_;
			form_is_production_spect_exit = IS_PRODUCTION;
			form_unit_id = PRODUCT_UNIT_ID;
			form_unit = MAIN_UNIT;
			form_kdv_amount = TAX;
			form_product_name = PRODUCT_NAME;
			form_spec_main_id = SPEC_MAIN_ID;
			form_spect_id = SPECT_VAR_ID;
			if(form_spec_main_id gt 0){
			specNameSqlStr="SELECT SPECT_MAIN_NAME FROM SPECT_MAIN  WHERE SPECT_MAIN_ID =#form_spec_main_id#";
			specNameSqlQuery = workcube_query(SQLString : specNameSqlStr, Datasource : dsn3);
				if(specNameSqlQuery.recordcount)
					form_spect_name = specNameSqlQuery.SPECT_MAIN_NAME;
				else
					form_spect_name ='';
			}
			else
				form_spect_name ='';
			form_cost_id = m_cost_id;
			form_product_cost=m_product_cost;
			form_product_cost_money=m_product_cost_money;
			form_cost_price_system = m_cost_price_system;
			form_purchase_extra_cost_system=m_purchase_extra_cost_system;
			form_purchase_extra_cost=m_purchase_extra_cost;
			form_money_system=m_cost_price_system_money;
			form_cost_price=m_cost_price;
			form_money=m_cost_price_money;
			if(GET_DET_PO.recordcount eq 1)form_cost_price_system=100;// sonuc ürünü tek satir oldugunda total_cost 100 atandıgı için burdada 100 atanıyor maliyetin tamamı bu ürüne yazıyor
			else if(not len(form_cost_price_system))form_cost_price_system=0;
			if(GET_DET_PO.recordcount eq 1)
			{//bir üretim soncu varsa maliyet adede bölünüyorki birim maliyet bulunsun
				deger_value_price=(birim_cost*form_cost_price_system)/form_amount;
				deger_value_price_extra=(birim_cost_extra*form_cost_price_system)/form_amount;
			}else{
				deger_value_price=(birim_cost*form_cost_price_system);
				deger_value_price_extra=(birim_cost_extra*form_cost_price_system);
			}
			deger_value_total_price = deger_value_price * form_amount;
		</cfscript>
		<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
			INSERT
			INTO
				PRODUCTION_ORDER_RESULTS_ROW
				(
					TYPE,
					PR_ORDER_ID,
					BARCODE,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT_ID,
					NAME_PRODUCT,
					UNIT_NAME,
					SPECT_ID,
					SPEC_MAIN_ID,
					SPECT_NAME,
					COST_ID,
					KDV_PRICE,
					PURCHASE_NET_SYSTEM,
					PURCHASE_NET_SYSTEM_MONEY,
					PURCHASE_EXTRA_COST_SYSTEM,
					PURCHASE_NET_SYSTEM_TOTAL,
					PURCHASE_NET,
					PURCHASE_NET_MONEY,
					PURCHASE_EXTRA_COST,
					PURCHASE_NET_TOTAL
				)
				VALUES
				(
					1,
					#ADD_PRODUCTION_ORDER.MAX_ID#,
					<cfif len(form_barcode)>'#form_barcode#',<cfelse>NULL,</cfif>
					<cfif len(form_stock_id)>#form_stock_id#,<cfelse>NULL,</cfif>
					<cfif len(form_product_id)>#form_product_id#,<cfelse>NULL,</cfif>
					<cfif len(form_amount)>#form_amount#,<cfelse>NULL,</cfif>
					<cfif len(form_unit_id)>#form_unit_id#,<cfelse>NULL,</cfif>
					'#left(form_product_name,75)#',
					'#left(form_unit,75)#',
					<cfif len(form_spect_id)>#form_spect_id#,<cfelse>NULL,</cfif>
					<cfif len(form_spec_main_id)>#form_spec_main_id#,<cfelse>NULL,</cfif>
					<cfif len(form_spect_name)>'#left(form_spect_name,50)#',<cfelse>NULL,</cfif>
					<cfif len(form_cost_id) and (form_cost_id neq 0)>#form_cost_id#<cfelse>NULL</cfif>,
					<cfif len(form_kdv_amount)>#form_kdv_amount#<cfelse>0</cfif>,
					<cfif len(deger_value_price)>#deger_value_price#<cfelse>0</cfif>,
					<cfif len(form_money_system)>'#form_money_system#'<cfelse>'#session.ep.money#'</cfif>,
					<cfif len(deger_value_price_extra)>#deger_value_price_extra#<cfelse>0</cfif>,
					<cfif len(deger_value_total_price)>#deger_value_total_price#<cfelse>0</cfif>,
					<cfif len(form_cost_price)>#form_cost_price#<cfelse>0</cfif>,
					<cfif len(form_money)>'#form_money#'<cfelse>'#session.ep.money#'</cfif>,
					<cfif len(form_purchase_extra_cost)>#form_purchase_extra_cost#<cfelse>0</cfif>,
					<cfif len(form_cost_price) and len(form_amount)>#form_cost_price*form_amount#<cfelse>0</cfif>
				)				
		</cfquery>
	</cfloop>
</cfif>
<!--- /üretim sonuçlandırma BİTTİ --->
<cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		PRODUCTION_RESULT_NUMBER = #system_paper_no_add#
	WHERE
		PRODUCTION_RESULT_NUMBER IS NOT NULL
</cfquery>


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    