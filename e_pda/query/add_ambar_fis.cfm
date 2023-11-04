<cfset current_row_list = ''>
<cfset stock_id_list = ''>
<cfset form.process_cat = attributes.process_cat>
<cfloop list="#attributes.action_id#" index="i">
	<cfset current_row_list = ListAppend(current_row_list,Listgetat(i,1,'-'))>
    <cfset stock_id_list = ListAppend(stock_id_list,Listgetat(i,2,'-'))>
    <cfset 'STOCK_ID_#Listgetat(i,1,'-')#' = Listgetat(i,2,'-')>
    <cfset 'AMOUNT_#Listgetat(i,1,'-')#' = Listgetat(i,3,'-')>
    <cfset 'SHELF_#Listgetat(i,1,'-')#' = Listgetat(i,4,'-')>
    <cfquery name="get_shelf_id" datasource="#dsn3#">
    	SELECT        
        	PRODUCT_PLACE_ID
		FROM            
        	PRODUCT_PLACE
		WHERE        
        	SHELF_CODE = '#Listgetat(i,4,'-')#'
    </cfquery>
    <cfset 'SHELF_ID_#Listgetat(i,1,'-')#' = get_shelf_id.PRODUCT_PLACE_ID>
    <cfif isdefined('attributes.change_shelf_fis')> <!---Raf Değiştirme Fişinden Geliyorsa--->
    	<cfset 'SHELF_OTHER_#Listgetat(i,1,'-')#' = Listgetat(i,5,'-')>
        <cfquery name="get_shelf_id" datasource="#dsn3#">
            SELECT        
                PRODUCT_PLACE_ID
            FROM            
                PRODUCT_PLACE
            WHERE        
                SHELF_CODE = '#Listgetat(i,5,'-')#'
        </cfquery>
    	<cfset 'SHELF_OTHER_ID_#Listgetat(i,1,'-')#' = get_shelf_id.PRODUCT_PLACE_ID>
    </cfif>
    <cfquery name="GET_LOT_K_KONT_ID" datasource="#dsn3#">
        SELECT     
            PU.PRODUCT_UNIT_ID, 
            PU.MAIN_UNIT, 
            PS.PRICE, 
            PS.MONEY,
            S.BARCOD,
            S.PRODUCT_NAME, 
            S.TAX, 
            S.STOCK_ID, 
            S.PRODUCT_ID,
            S.STOCK_CODE
        FROM         
            STOCKS AS S INNER JOIN
            PRICE_STANDART AS PS ON S.PRODUCT_ID = PS.PRODUCT_ID INNER JOIN
            PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID
        WHERE     
            PU.IS_MAIN = 1 AND 
            PS.PRICESTANDART_STATUS = 1 AND 
            PS.PURCHASESALES = 0 AND
            S.STOCK_ID = #Evaluate('STOCK_ID_#Listgetat(i,1,'-')#')#
        ORDER BY 	
            S.PRODUCT_NAME
    </cfquery>
    <cfquery name="get_spect" datasource="#dsn3#">
    	SELECT        
        	SPECT_VAR_ID, 
            SPECT_VAR_NAME
		FROM            
        	SPECTS
		WHERE        
        	SPECT_VAR_ID IN
                         	(
                            	SELECT        
                                	MAX(SPECT_VAR_ID) AS SPECT_VAR_ID
                               	FROM            
                                	SPECTS AS SPECTS_1
                               	WHERE        
                                	STOCK_ID = #Evaluate('STOCK_ID_#Listgetat(i,1,'-')#')#
                          	)
    </cfquery>
    <cfoutput query="GET_LOT_K_KONT_ID">
    	<cfset 'PRODUCT_UNIT_ID_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.PRODUCT_UNIT_ID>
        <cfset 'MAIN_UNIT_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.MAIN_UNIT>
        <cfset 'PRICE_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.PRICE>
        <cfset 'MONEY_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.MONEY>
        <cfset 'BARCOD_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.BARCOD>
        <cfset 'TAX_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.TAX>
        <cfset 'PRODUCT_ID_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.PRODUCT_ID>
        <cfset 'PRODUCT_NAME_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.PRODUCT_NAME>
        <cfset 'STOCK_CODE_#Listgetat(i,1,'-')#' = GET_LOT_K_KONT_ID.STOCK_CODE>
    </cfoutput>
    <cfif get_spect.recordcount>
		<cfoutput query="get_spect">
            <cfset 'SPECT_ID#Listgetat(i,1,'-')#' = get_spect.SPECT_VAR_ID>
            <cfset 'SPECT_NAME#Listgetat(i,1,'-')#' = get_spect.SPECT_VAR_NAME>
        </cfoutput>
    <cfelse>
    	<cfset 'SPECT_ID#Listgetat(i,1,'-')#' = ''>
        <cfset 'SPECT_NAME#Listgetat(i,1,'-')#' = ''>
    </cfif>
</cfloop>
<cfset session.ep.our_company_info.is_cost = 1><!---Dikkat Firmaya Göre Değişir--->



<cfif ListLen(current_row_list)>
    <cf_papers paper_type="stock_fis">
    <cfif isdefined("paper_full") and isdefined("paper_number")>
        <cfset system_paper_no = paper_full>
    <cfelse>
        <cfset system_paper_no = "">
    </cfif>
<cfdump var="#system_paper_no#">
<cfdump var="#paper_full#">
<cfquery name="isHvUsed" datasource="#dsn2#">
  SELECT * FROM STOCK_FIS WHERE FIS_NUMBER='#paper_full#'
</cfquery>
<cfif isHvUsed.recordCount>
    burda
    <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
        UPDATE 
            GENERAL_PAPERS
        SET
            STOCK_FIS_NUMBER = STOCK_FIS_NUMBER+1
        WHERE
            STOCK_FIS_NUMBER IS NOT NULL
    </cfquery>
    <cf_papers paper_type="stock_fis">
        <cfif isdefined("paper_full") and isdefined("paper_number")>
            <cfset system_paper_no = paper_full>
        <cfelse>
            <cfset system_paper_no = "">
        </cfif>
</cfif>
<cfdump var="#system_paper_no#">
<cfdump var="#paper_full#">


    <cfset attributes.ROWS_ = listlen(stock_id_list)>
    <cfset attributes.FIS_DATE_H = hour(now())>
    <cfset attributes.FIS_DATE_M = minute(now())>
    <cfset attributes.DEPARTMENT_OUT = Listgetat(attributes.dep_out,1,'-')>
    <cfset attributes.LOCATION_OUT = Listgetat(attributes.dep_out,2,'-')> 
    <cfset attributes.DEPARTMENT_IN = Listgetat(attributes.dep_in,1,'-')>
    <cfset attributes.LOCATION_IN = Listgetat(attributes.dep_in,2,'-')> 
    <cfset attributes.ACTIVE_PERIOD = session.ep.period_id>
    <cfset attributes.EMPLOYEE_ID = session.ep.userid>
    <cfset attributes.DETAIL = ''> 
    <cfset attributes.BASKET_DISCOUNT_TOTAL = 0>
    <cfset attributes.BASKET_EMPLOYEE1 = ''>  
    <cfset attributes.BASKET_EMPLOYEE_ID1 = ''> 
    <cfset attributes.BASKET_EXTRA_INFO1 = -1>  
    <cfset attributes.BASKET_GROSS_TOTAL = 0>  
    <cfset attributes.BASKET_ID = 12> 
    <cfset attributes.BASKET_MEMBER_PRICECAT = '' > 
    <cfset attributes.BASKET_MONEY = 'TL'>
    <cfset attributes.BASKET_NET_TOTAL = 0>  
    <cfset attributes.BASKET_OTV_1 = 0> 
    <cfset attributes.BASKET_OTV_COUNT = 1>  
    <cfset attributes.BASKET_OTV_FROM_TAX_PRICE = 0>
    <cfset attributes.BASKET_OTV_TOTAL = 0>
    <cfset attributes.BASKET_OTV_VALUE_1 = 0>
    <cfset attributes.BASKET_TAX_1 = 0>
    <cfset attributes.BASKET_TAX_VALUE_1 = 0>
    <cfset attributes.BASKET_PRICE_ROUND_NUMBER = 4>  
    <cfset attributes.BASKET_RATE1 = 1>
    <cfset attributes.BASKET_RATE2 = 1> 
    <cfset attributes.BASKET_RATE_ROUND_NUMBER_ =4>
    <cfset attributes.BASKET_SPECT_TYPE =0> 
    <cfset attributes.BASKET_TOTAL_ROUND_NUMBER_ = 2>
    <cfset attributes.BASKET_TAX_COUNT = 1>  
    <cfset attributes.BASKET_TAX_TOTAL = 0> 
    <cfset attributes.COMPANY_ID = ''>  
    <cfset attributes.CONSUMER_ID = ''> 
    <cfset attributes.CONTROL_FIELD_VALUE =-1>
    <cfset attributes.HIDDEN_RD_MONEY_1 = 'TL' >
    <cfset attributes.EXTRA_COST_RATE =''> 
    <cfset attributes.FIS_DATE = now()>
    <cfset attributes.FIS_NO_ = system_paper_no> 
    <cfset attributes.INDIRIM_TOTAL = 0>
    <cfset attributes.INTERNALDEMAND_ID_LIST = ''>
    <cfset attributes.IS_BASKET_HIDDEN = 0>  
    <cfset attributes.IS_GENERAL_PROM = 0> 
    <cfset attributes.KUR_SAY = 1> 
    <cfset attributes.MEMBER_NAME = get_emp_info(session.ep.userid,0,0)>  
    <cfset attributes.MEMBER_TYPE = 'employee'>  
    <cfset attributes.OLD_GENERAL_PROM_AMOUNT = ''>  
    <cfset attributes.OTHER_MONEY_VALUE_1 = 0> 
    <cfset attributes.OTHER_MONEY_1 = 'TL'>
    <cfset attributes.PARTNER_ID = ''>  
    <cfset attributes.PROD_ORDER = ''>  
    <cfset attributes.PROD_ORDER_NUMBER = ''>  
    <cfset attributes.PROJECT_HEAD = ''> 
    <cfset attributes.PROJECT_HEAD_IN = ''>  
    <cfset attributes.PROJECT_ID = ''>  
    <cfset attributes.PROJECT_ID_IN = ''>  
    <cfset attributes.RD_MONEY = 1>  
    <cfset attributes.REF_NO = ''> 
    <cfset attributes.ROW_COST_TOTAL =0>
    <cfset attributes.SALE_PRODUCT = ''>  
    <cfset attributes.SEARCH_PROCESS_DATE = 'fis_date'>
    <cfset attributes.SERVICE_ID = ''>  
    <cfset attributes.SERVICE_NAME = ''>
    <cfset attributes.TODAY_DATE_ = now()>
    <cfset attributes.TXT_RATE1_1 = 1>
    <cfset attributes.TXT_RATE2_1 =1>  
    <cfset attributes.USE_BASKET_PROJECT_DISCOUNT_ = 0>   
    <cfset attributes.WORK_HEAD = 0>  
    <cfset attributes.WORK_ID = 0> 
    <cfset attributes.WRK_SUBMIT_BUTTON = 'Kaydet'> 
    <cfset attributes.X_COST_ACC = 1>
    <cfset BASKET_KUR_EKLE = 0>
    <cfset 	attributes.XML_MULTIPLE_COUNTING_FIS =1>
    
    <cfloop list="#current_row_list#" index="k">
    	<cfset 'attributes.UNIT#k#' = Evaluate('MAIN_UNIT_#k#')>
        <cfset 'attributes.UNIT_ID#k#' = Evaluate('PRODUCT_UNIT_ID_#k#') > 
        <cfset 'attributes.STOCK_CODE#k#' = Evaluate('STOCK_CODE_#k#') > 
        <cfset 'attributes.STOCK_ID#k#' = Evaluate('STOCK_ID_#k#') >  
        <cfset 'attributes.PRODUCT_ID#k#' = Evaluate('PRODUCT_ID_#k#') > 
        <cfset 'attributes.PRODUCT_NAME#k#' = Evaluate('PRODUCT_NAME_#k#') > 
        <cfset 'attributes.AMOUNT#k#' = Evaluate('AMOUNT_#k#')>
        <cfset 'attributes.AMOUNT_OTHER#k#' = Evaluate('AMOUNT_#k#')>
        <cfset 'attributes.ACTION_ROW_ID#k#' = 0>
        <cfset 'attributes.BARCOD#k#' = Evaluate('BARCOD_#k#') >
		<cfset 'attributes.BASKET_ROW_DEPARTMAN#k#' = ''>  
        <cfset 'attributes.DARA#k#' = 0>  
        <cfset 'attributes.DARALI#k#' = 1>  
        <cfset 'attributes.DELIVER_DATE#k#' = ''>  
        <cfset 'attributes.DELIVER_DEPT#k#' = ''> 
        <cfset 'attributes.DUEDATE#k#' = ''>  
        <cfset 'attributes.EK_TUTAR#k#' = ''>  
        <cfset 'attributes.EK_TUTAR_COST#k#' = ''>  
        <cfset 'attributes.EK_TUTAR_MARJ#k#' = ''>  
        <cfset 'attributes.EK_TUTAR_OTHER_TOTAL#k#' = 0>  
        <cfset 'attributes.EK_TUTAR_PRICE#k#' = ''>  
        <cfset 'attributes.EK_TUTAR_TOTAL#k#' = 0>
        <cfset 'attributes.EXTRA_COST#k#' = 0> 
        <cfset 'attributes.INDIRIM10#k#' = 0>  
        <cfset 'attributes.INDIRIM1#k#' = 0>  
        <cfset 'attributes.INDIRIM2#k#' = 0>  
        <cfset 'attributes.INDIRIM3#k#' = 0>  
        <cfset 'attributes.INDIRIM4#k#' = 0>  
        <cfset 'attributes.INDIRIM5#k#' = 0>  
        <cfset 'attributes.INDIRIM6#k#' = 0>  
        <cfset 'attributes.INDIRIM7#k#' = 0>  
        <cfset 'attributes.INDIRIM8#k#' = 0>  
        <cfset 'attributes.INDIRIM9#k#' = 0>  
        <cfset 'attributes.ISKONTO_TUTAR#k#' = 0>  
        <cfset 'attributes.IS_COMMISSION#k#' = 0>
        <cfset 'attributes.IS_INVENTORY#k#' = 1>
        <cfset 'attributes.KARMA_PRODUCT_ID#k#' = ''>
        <cfset 'attributes.IS_PRODUCTION#k#' = 0>  
        <cfset 'attributes.IS_PROMOTION#k#' = 0> 
        <cfset 'attributes.LIST_PRICE#k#' = 0> 
        <cfset 'attributes.LOT_NO#k#' = ''> 
        <cfset 'attributes.LIST_PRICE_DISCOUNT#k#' = ''> 
        <cfset 'attributes.MANUFACT_CODE#k#' = ''>  
        <cfset 'attributes.MARJ#k#' = ''> 
        <cfset 'attributes.NET_MALIYET#k#' = 0>  
        <cfset 'attributes.NUMBER_OF_INSTALLMENT#k#' = 0>  
        <cfset 'attributes.ORDER_CURRENCY#k#' = -1>  
        <cfset 'attributes.OTHER_MONEY_GROSS_TOTAL#k#' = 0> 
        <cfset 'attributes.OTHER_MONEY#k#' = 'TL'>
        <cfset 'attributes.OTHER_MONEY_#k#' = 'TL'>
        <cfset 'attributes.OTV_ORAN#k#' = 0>  
        <cfset 'attributes.PBS_CODE#k#' = ''>  
        <cfset 'attributes.PBS_ID#k#' = ''>  
        <cfset 'attributes.PRICE#k#' = 0> 
        <cfset 'attributes.PRICE_CAT#k#' = ''>  
        <cfset 'attributes.PRICE_NET#k#' = 0>  
        <cfset 'attributes.PRICE_NET_DOVIZ#k#' = 0> 
        <cfset 'attributes.PRICE_OTHER#k#' = 0>  
        <cfset 'attributes.PRODUCT_NAME_OTHER#k#' =''>
        <cfset 'attributes.PROMOSYON_MALIYET#k#' = ''>  
        <cfset 'attributes.PROMOSYON_YUZDE#k#' = ''>  
        <cfset 'attributes.PROM_RELATION_ID#k#' = ''>  
        <cfset 'attributes.PROM_STOCK_ID#k#' = ''>  
        <cfset 'attributes.RELATED_ACTION_ID#k#' = ''>  
        <cfset 'attributes.RELATED_ACTION_TABLE#k#' = ''>  
        <cfset 'attributes.RESERVE_DATE#k#' = ''>  
        <cfset 'attributes.RESERVE_TYPE#k#' = -3> 
        <cfset 'attributes.ROW_CATALOG_ID#k#' = ''>  
        <cfset 'attributes.ROW_HEIGHT#k#' = ''>  
        <cfset 'attributes.ROW_LASTTOTAL#k#' = 0>  
        <cfset 'attributes.ROW_NETTOTAL#k#' = 0>  
        <cfset 'attributes.ROW_OTVTOTAL#k#' = 0>  
        <cfset 'attributes.ROW_PAYMETHOD_ID#k#' = ''>  
        <cfset 'attributes.ROW_PROJECT_ID#k#' = ''>  
        <cfset 'attributes.ROW_PROJECT_NAME#k#' = ''>  
        <cfset 'attributes.ROW_PROMOTION_ID#k#' = ''>  
        <cfset 'attributes.ROW_SERVICE_ID#k#' = ''>  
        <cfset 'attributes.ROW_SHIP_ID#k#' = 0>  
        <cfset 'attributes.ROW_TAXTOTAL#k#' = 0>  
        <cfset 'attributes.ROW_TOTAL#k#' = 0>  
        <cfset 'attributes.ROW_UNIQUE_RELATION_ID#k#' = ''>  
        <cfset 'attributes.ROW_WIDTH#k#' = ''>
        <cfset 'attributes.ROW_DEPTH#k#' = ''>
        <cfif isdefined('attributes.change_shelf_fis')> <!---Raf Değiştirme Fişinden Geliyorsa--->
        	<cfset 'attributes.SHELF_NUMBER#k#' = Evaluate('SHELF_ID_#k#')>  
          	<cfset 'attributes.SHELF_NUMBER_TXT#k#' = Evaluate('SHELF_#k#')> 
           	<cfset 'attributes.TO_SHELF_NUMBER#k#' = Evaluate('SHELF_OTHER_ID_#k#')>  
          	<cfset 'attributes.TO_SHELF_NUMBER_TXT#k#' = Evaluate('SHELF_OTHER_#k#')>
        <cfelse>
			<cfif isdefined('attributes.tersfis')> <!---Ambardan Mal Kabule Fişinden Geliyorsa--->
                <cfset 'attributes.SHELF_NUMBER#k#' = Evaluate('SHELF_ID_#k#')>  
                <cfset 'attributes.SHELF_NUMBER_TXT#k#' = Evaluate('SHELF_#k#')> 
                <cfset 'attributes.TO_SHELF_NUMBER#k#' = ''>  
                <cfset 'attributes.TO_SHELF_NUMBER_TXT#k#' = ''>
            <cfelse> <!---Mal Kabulden Ambara Fişinden Geliyorsa--->
                <cfset 'attributes.SHELF_NUMBER#k#' = ''>  
                <cfset 'attributes.SHELF_NUMBER_TXT#k#' = ''> 
                <cfset 'attributes.TO_SHELF_NUMBER#k#' = Evaluate('SHELF_ID_#k#') >  
                <cfset 'attributes.TO_SHELF_NUMBER_TXT#k#' = Evaluate('SHELF_#k#')>
            </cfif>
       	</cfif>
        <cfset 'attributes.SPECIAL_CODE#k#' = ''>  
        <cfset 'attributes.SPECT_ID#k#' = Evaluate('SPECT_ID#k#')>  
        <cfset 'attributes.TAX_PRICE#k#' = ''>  
        <cfset 'attributes.UNIT_OTHER#k#' = ''>  
        <cfset 'attributes.WRK_ROW_RELATION_ID#k#' = ''>
        <cfset 'attributes.TAX#k#' = 0>
        <cfset 'attributes.SPECT_NAME#k#' = Evaluate('SPECT_NAME#k#')>
    	<cfset 'attributes.WRK_ROW_ID#k#' = 'EZG'&#DateFormat(Now(),'YYYYMMDD')# & #TimeFormat(Now(),'HHmmssL')#>
    </cfloop>
</cfif>
<cfdump  var="#attributes#">
<cfinclude template="../../../../v16/stock/query/check_our_period.cfm"> 
<cfinclude template="../../../../v16/stock/query/get_process_cat.cfm">
<cfset attributes.fis_type = get_process_type.PROCESS_TYPE> 
 kontroller  & tanimlamalar 
<cfinclude template="../../../../v16/stock/query/add_ship_fis_1.cfm">
  // kontroller & tanimlamalar 
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfinclude template="../../../../v16/stock/query/add_ship_fis_2.cfm">
		<cfif isdefined("attributes.rows_")>
			<cfinclude template="../../../../v16/stock/query/add_ship_fis_3.cfm">
			<cfinclude template="../../../../v16/stock/query/add_ship_fis_4.cfm">
			<cfif listfind("111,112,113",attributes.fis_type)> sarf,fire,ambar fisleri icin muhasebeleştirme işlemi  
				<cfinclude template="../../../../v16/stock/query/add_ship_fis_6.cfm">
			</cfif>
		<cfelse>
			<cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
				INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
			</cfquery>
		</cfif>
		Ek Bilgiler
        <cfset attributes.info_id = GET_ID.MAX_ID>
        <cfset attributes.is_upd = 0>
        <cfset attributes.info_type_id=-22>
        <cfinclude template="../../../../v16/objects/query/add_info_plus2.cfm">
        Ek Bilgiler
		 secilen islem kategorisine bir action file eklenmisse 
			<cf_workcube_process_cat 
				process_cat="#attributes.process_cat#"
				action_id = "#GET_ID.MAX_ID#"
				action_table="STOCK_FIS"
				action_column="FIS_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_fis&upd_id=#GET_ID.MAX_ID#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		STOCK_FIS_NUMBER = #system_paper_no_add#
	WHERE
		STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<cfif  isDefined("attributes.fire_fisi_kaydet") and isDefined("fire_fisi_gerekiyor") and len(session_list)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			STOCK_FIS_NUMBER = #system_paper_no_add_fire#
		WHERE
			STOCK_FIS_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<cfif not isdefined("attributes.is_mobile")>
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1> sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor 
	<cfscript>
		cost_action(action_type:3,action_id:GET_ID.MAX_ID,query_type:1);
	</cfscript>
	<script type="text/javascript">
    <cfif isDefined("attributes.psk") and attributes.psk eq 1>
    
		window.location.href="<cfoutput>#request.self#?fuseaction=objects.emptypopup_pbs_print&printType=STOK_FIS&ACTION_ID=#GET_ID.MAX_ID#</cfoutput>"
    <cfelse>
        window.location.href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>";
    </cfif>
	</script>
<cfelse>
    <script type="text/javascript">
		<cfif isDefined("attributes.psk") and attributes.psk eq 1>
    
			window.location.href="<cfoutput>#request.self#?fuseaction=objects.emptypopup_pbs_print&printType=STOK_FIS&ACTION_ID=#GET_ID.MAX_ID#</cfoutput>"	
<cfelse>
    window.location.href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>";
</cfif>
	</script>
</cfif>
</cfif>
