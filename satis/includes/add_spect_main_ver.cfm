

<!--- spect ekleme sayfasından aynı isimli spect eklenemesin parametresi alınıyor --->
<cfquery name="get_position_list_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'objects.popup_add_spect_list' AND
		PROPERTY_NAME = 'is_add_same_name_spect'
</cfquery>
<cfif (get_position_list_xml.recordcount and get_position_list_xml.property_value eq 0) or get_position_list_xml.recordcount eq 0><cfset is_add_same_name_spect = 0><cfelse><cfset is_add_same_name_spect = 1></cfif>
<cfquery name="GET_TREE_STOCKS" datasource="#DSN3#">
	SELECT
    	0 AS PROPERTY_TYPE, 
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.PROPERTY,
		PRODUCT_TREE.PRODUCT_TREE_ID,
		PRODUCT_TREE.RELATED_ID AS _STOCK_ID_,
		PRODUCT_TREE.HIERARCHY,
		PRODUCT_TREE.IS_TREE,
		PRODUCT_TREE.AMOUNT,
		PRODUCT_TREE.UNIT_ID,
		PRODUCT_TREE.STOCK_ID,
		PRODUCT_TREE.IS_CONFIGURE,
		PRODUCT_TREE.IS_SEVK,
		PRODUCT_TREE.LINE_NUMBER,
        PRODUCT_TREE.SPECT_MAIN_ID,
        ISNULL(PRODUCT_TREE.QUESTION_ID,0) AS QUESTION_ID,
        ISNULL(PRODUCT_TREE.IS_PHANTOM,0) AS IS_PHANTOM,
		ISNULL(PRODUCT_TREE.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
		ISNULL(PRODUCT_TREE.FIRE_AMOUNT,0) AS FIRE_AMOUNT,
		ISNULL(PRODUCT_TREE.FIRE_RATE,0) AS FIRE_RATE,
        ISNULL(PRODUCT_TREE.STATION_ID,0) AS STATION_ID,
		PRODUCT_TREE.DETAIL
	FROM 
		PRODUCT_TREE,
		STOCKS
	WHERE 
		PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID
        AND PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	<cfif isdefined('attributes.operation_tree_id_list') and len(attributes.operation_tree_id_list)>
	UNION ALL   
		SELECT
			4 AS PROPERTY_TYPE, <!--- OPERASYONUN ALTINDAN GELEN BİRLEŞENLERİ 4 OLARAK KAYDEDİYORUZ.. --->
			STOCKS.PRODUCT_ID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY,
			PRODUCT_TREE.PRODUCT_TREE_ID,
			PRODUCT_TREE.RELATED_ID AS _STOCK_ID_,
			PRODUCT_TREE.HIERARCHY,
			PRODUCT_TREE.IS_TREE,
			PRODUCT_TREE.AMOUNT,
			PRODUCT_TREE.UNIT_ID,
			PRODUCT_TREE.STOCK_ID,
			PRODUCT_TREE.IS_CONFIGURE,
			PRODUCT_TREE.IS_SEVK,
			PRODUCT_TREE.LINE_NUMBER,
			PRODUCT_TREE.SPECT_MAIN_ID,
			ISNULL(PRODUCT_TREE.QUESTION_ID,0) AS QUESTION_ID,
			ISNULL(PRODUCT_TREE.IS_PHANTOM,0) AS IS_PHANTOM,
			ISNULL(PRODUCT_TREE.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
			ISNULL(PRODUCT_TREE.FIRE_AMOUNT,0) AS FIRE_AMOUNT,
			ISNULL(PRODUCT_TREE.FIRE_RATE,0) AS FIRE_RATE,
			ISNULL(PRODUCT_TREE.STATION_ID,0) AS STATION_ID,
			PRODUCT_TREE.DETAIL
		FROM 
			PRODUCT_TREE,
			STOCKS
		WHERE 
			PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID
			AND PRODUCT_TREE.PRODUCT_TREE_ID IN (#attributes.operation_tree_id_list#)
	</cfif>	
</cfquery>
<cfquery name="GET_TREE_OPERATIONS" datasource="#dsn3#">
	SELECT 
    	3 AS PROPERTY_TYPE, 
		OT.OPERATION_TYPE_ID,
		OT.OPERATION_TYPE,
		PT.PRODUCT_TREE_ID,
        PT.RELATED_PRODUCT_TREE_ID,
		PT.AMOUNT,
		PT.RELATED_ID AS _STOCK_ID_,
		0 AS SPECT_MAIN_ID,
        ISNULL(PT.IS_PHANTOM,0) IS_PHANTOM,
        ISNULL(PT.IS_SEVK,0) IS_SEVK,
		ISNULL(PT.IS_FREE_AMOUNT,0) IS_FREE_AMOUNT,
        ISNULL(PT.FIRE_AMOUNT,0) FIRE_AMOUNT,
        ISNULL(PT.FIRE_RATE,0) FIRE_RATE,
        ISNULL(PT.LINE_NUMBER,0) LINE_NUMBER,
        ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
        ISNULL(PT.STATION_ID,0) AS STATION_ID,
		PT.DETAIL
	FROM 
		OPERATION_TYPES OT ,
		PRODUCT_TREE PT
	WHERE 
		OT.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID
        AND PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	<cfif isdefined('attributes.operation_tree_id_list') and len(attributes.operation_tree_id_list)>
		UNION ALL
			SELECT 
				4 AS PROPERTY_TYPE, <!--- OPERASYONUN ALTINDAN GELEN BİRLEŞENLERİ 4 OLARAK KAYDEDİYORUZ.. --->
				OT.OPERATION_TYPE_ID,
				OT.OPERATION_TYPE,
				PT.PRODUCT_TREE_ID,
				PT.RELATED_PRODUCT_TREE_ID,
				PT.AMOUNT,
				PT.RELATED_ID AS _STOCK_ID_,
				0 AS SPECT_MAIN_ID,
				ISNULL(PT.IS_PHANTOM,0) IS_PHANTOM,
                ISNULL(PT.IS_SEVK,0) IS_SEVK,
                ISNULL(PT.IS_FREE_AMOUNT,0) IS_FREE_AMOUNT,
                ISNULL(PT.FIRE_AMOUNT,0) FIRE_AMOUNT,
                ISNULL(PT.FIRE_RATE,0) FIRE_RATE,
                ISNULL(PT.LINE_NUMBER,0) LINE_NUMBER,
				ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
				ISNULL(PT.STATION_ID,0) AS STATION_ID,
				PT.DETAIL
			FROM 
				OPERATION_TYPES OT ,
				PRODUCT_TREE PT
			WHERE 
				OT.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID
				AND PT.PRODUCT_TREE_ID IN (#attributes.operation_tree_id_list#)
    </cfif>
</cfquery>

<cfset total_records = GET_TREE_STOCKS.RECORDCOUNT + GET_TREE_OPERATIONS.RECORDCOUNT>
<cfquery name="GET_MAIN_PROD" datasource="#dsn3#">
	SELECT PRODUCT_ID,PRODUCT_NAME,PROPERTY,IS_PROTOTYPE FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfscript>
	main_stock_id=attributes.stock_id;
	main_product_id=GET_MAIN_PROD.PRODUCT_ID;
	spec_name='#GET_MAIN_PROD.PRODUCT_NAME# #GET_MAIN_PROD.PROPERTY#';
	row_count=total_records;
	stock_id_list="";
	related_tree_id_list='';
	operation_type_id_list='';
	product_id_list="";
	product_name_list="";
	amount_list="";
	sevk_list="";
	configure_list="";
	is_property_list="";
	property_id_list = "";
	variation_id_list = "";
	total_min_list = "";
	total_max_list = "";
	tolerance_list = "";
	line_number_list ="";
	related_spect_main_id_list ="";
	question_id_list ="";
	station_id_list ="";
	product_tree_id_list ="";
	detail_list = "";
	for(i=1;i lte GET_TREE_STOCKS.RECORDCOUNT;i=i+1)
	{
		product_tree_id_list = listappend(product_tree_id_list,GET_TREE_STOCKS.PRODUCT_TREE_ID[i],',');
		if(GET_TREE_STOCKS._STOCK_ID_[i] gt 0)
			stock_id_list = listappend(stock_id_list,GET_TREE_STOCKS._STOCK_ID_[i],',');
		else
			stock_id_list = listappend(stock_id_list,0,',');
		if(GET_TREE_STOCKS.PRODUCT_ID[i] gt 0)
			product_id_list = listappend(product_id_list,GET_TREE_STOCKS.PRODUCT_ID[i],',');
		else
			product_id_list = listappend(product_id_list,0,',');
		amount_list = listappend(amount_list,GET_TREE_STOCKS.AMOUNT[i],',');
		if(len(GET_TREE_STOCKS.PRODUCT_NAME[i]))
			product_name_list = listappend(product_name_list,'#GET_TREE_STOCKS.PRODUCT_NAME[i]# #GET_TREE_STOCKS.PROPERTY[i]#','@');
		if(GET_TREE_STOCKS.IS_SEVK[i] eq 1)
			sevk_list = listappend(sevk_list,1,',');
		else
			sevk_list = listappend(sevk_list,0,',');
		if(GET_TREE_STOCKS.IS_CONFIGURE[i] eq 1)
			configure_list = listappend(configure_list,1,',');
		else
			configure_list = listappend(configure_list,0,',');
		if(len(GET_TREE_STOCKS.SPECT_MAIN_ID[i]) and GET_TREE_STOCKS.SPECT_MAIN_ID[i] gt 0)	
		related_spect_main_id_list  = ListAppend(related_spect_main_id_list,GET_TREE_STOCKS.SPECT_MAIN_ID[i],',');
		else
		related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
		is_property_list=listappend(is_property_list,GET_TREE_STOCKS.PROPERTY_TYPE[i],',');//0 ise sarf 1 ise özellik 2 ise fire 3 ise operasyon 4 ise operasyon altından gelen stock yada operasyon..
		property_id_list = listappend(property_id_list,0,',');
		variation_id_list = listappend(variation_id_list,0,',');
		total_min_list = listappend(total_min_list,'-',',');
		total_max_list = listappend(total_max_list,'-',',');
		tolerance_list = listappend(tolerance_list,'-',',');
		related_tree_id_list = listappend(related_tree_id_list,GET_TREE_STOCKS.PRODUCT_TREE_ID[i],','); //.....................
		operation_type_id_list = listappend(operation_type_id_list,0,',');
		if(isdefined('attributes.is_show_line_number') and attributes.is_show_line_number eq 1 and len(GET_TREE_STOCKS.LINE_NUMBER[i]))
			line_number_list = listappend(line_number_list,GET_TREE_STOCKS.LINE_NUMBER[i],',');
		else
			line_number_list = listappend(line_number_list,0,',');
		question_id_list = 	listappend(question_id_list,GET_TREE_STOCKS.QUESTION_ID[i],',');
		station_id_list = 	listappend(station_id_list,GET_TREE_STOCKS.STATION_ID[i],',');
		if(len(GET_TREE_STOCKS.DETAIL[i]))
			detail_list = listappend(detail_list,GET_TREE_STOCKS.DETAIL[i],',');
		else
			detail_list = listappend(detail_list,'-',',');
	}
	for(j=1;j lte GET_TREE_OPERATIONS.RECORDCOUNT;j=j+1)
	{
		product_tree_id_list = listappend(product_tree_id_list,GET_TREE_OPERATIONS.PRODUCT_TREE_ID[j],',');
		stock_id_list = listappend(stock_id_list,0,',');
		product_id_list = listappend(product_id_list,0,',');
		amount_list = listappend(amount_list,GET_TREE_OPERATIONS.AMOUNT[j],',');
		product_name_list = listappend(product_name_list,'#GET_TREE_OPERATIONS.OPERATION_TYPE[j]#','@');
		sevk_list = listappend(sevk_list,0,',');
		configure_list = listappend(configure_list,1,',');
		related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
		is_property_list=listappend(is_property_list,GET_TREE_OPERATIONS.PROPERTY_TYPE[j],',');//0 ise sarf 1 ise özellik 2 ise fire 3 ise operasyon 4 ise operasyon altından gelen stock yada operasyon..
		property_id_list = listappend(property_id_list,0,',');
		variation_id_list = listappend(variation_id_list,0,',');
		total_min_list = listappend(total_min_list,'-',',');
		total_max_list = listappend(total_max_list,'-',',');
		tolerance_list = listappend(tolerance_list,'-',',');
		related_tree_id_list = listappend(related_tree_id_list,GET_TREE_OPERATIONS.PRODUCT_TREE_ID[j],',');
		operation_type_id_list = listappend(operation_type_id_list,GET_TREE_OPERATIONS.OPERATION_TYPE_ID[j],',');
		if(isdefined('attributes.is_show_line_number') and attributes.is_show_line_number eq 1 and len(GET_TREE_OPERATIONS.LINE_NUMBER[j]))
			line_number_list = listappend(line_number_list,GET_TREE_OPERATIONS.LINE_NUMBER[j],',');
		else
			line_number_list = listappend(line_number_list,0,',');
		question_id_list = 	listappend(question_id_list,GET_TREE_OPERATIONS.QUESTION_ID[j],',');
		station_id_list = 	listappend(station_id_list,GET_TREE_OPERATIONS.STATION_ID[j],',');
		if(len(GET_TREE_OPERATIONS.DETAIL[i]))
			detail_list = listappend(detail_list,GET_TREE_OPERATIONS.DETAIL[i],',');
		else
			detail_list = listappend(detail_list,'-',',');
	}
</cfscript>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
		new_spec_cre=specer(
				dsn_type: dsn3,
				spec_type: 1,
				spec_is_tree: 1,
				only_main_spec: 0,
				main_stock_id: main_stock_id,
				main_product_id: main_product_id,
				spec_name: spec_name,
				spec_row_count: row_count,
				stock_id_list: stock_id_list,
				product_id_list: product_id_list,
				product_name_list: product_name_list,
				amount_list: amount_list,
				is_sevk_list: sevk_list,	
				is_configure_list: configure_list,
				is_property_list: is_property_list,
				property_id_list: property_id_list,
				variation_id_list: variation_id_list,
				total_min_list: total_min_list,
				total_max_list : total_max_list,
				tolerance_list : tolerance_list,
				related_spect_id_list : related_spect_main_id_list,
				line_number_list : line_number_list,
				detail_list : detail_list,
				upd_spec_main_row:1,
				related_tree_id_list : related_tree_id_list,
				operation_type_id_list:operation_type_id_list,
				question_id_list:question_id_list,
				station_id_list:station_id_list,
				is_add_same_name_spect : is_add_same_name_spect,
				is_control_spect_name : is_add_same_name_spect
			);
		new_cre_main_spec_id =ListGetAt(new_spec_cre,1,',');
		spec_main_id_list = ListAppend(spec_main_id_list,ListGetAt(new_spec_cre,1,','));	
		</cfscript>
	</cftransaction>
</cflock>
<cfif new_cre_main_spec_id eq attributes.old_main_spec_id><!-- Eğerki Ürün Ağaçı Değişmemiş ise,SPEC_MAIN_ID üzerinden bir değişiklik olmayacağı için.is_confgüre alanlarını değiştiricez..Neden değişmediği durum diye sorulucak olursa,zaten yeni main_spec_id oluşursa is_configure alanları doğru oluşur.. -->
    <cfloop from="1" to="#listlen(stock_id_list,',')#" index="rind">
            <cfquery name="upd_main_spect_row_conf" datasource="#dsn3#">
                UPDATE 
                	SPECT_MAIN_ROW 
                SET 
                	IS_CONFIGURE = #listgetat(configure_list,rind,',')#,
                    LINE_NUMBER = #listgetat(line_number_list,rind,',')#,
                    STATION_ID = #listgetat(station_id_list,rind,',')#,
                    QUESTION_ID = #listgetat(question_id_list,rind,',')#
                WHERE 
                    SPECT_MAIN_ID = #attributes.old_main_spec_id# AND 
                    ((RELATED_TREE_ID IS NOT NULL AND RELATED_TREE_ID = #listgetat(product_tree_id_list,rind,',')#) OR RELATED_TREE_ID IS NULL) AND
                    <cfif listgetat(stock_id_list,rind,',') gt 0>
	                    STOCK_ID = #listgetat(stock_id_list,rind,',')#
                    <cfelse>
                    	OPERATION_TYPE_ID = #listgetat(operation_type_id_list,rind,',')#
                    </cfif>
            </cfquery>
    </cfloop>
</cfif>
<cfquery name="get_stocks_for_main_spec" datasource="#dsn3#"><!--- BU ÜRÜNÜN KULLANILDIĞI TÜM MAİN_SPEC'LERİN LİSTESİNİ ALIYORUZ ÖNCE... --->
	SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfset spect_main_id_list = ValueList(get_stocks_for_main_spec.SPECT_MAIN_ID,',')>
<!--- eğer halayet ürün ağacı kullanılıyorsa ağaçta yapılan değişiklikte halayet seçilen yada seçilmeyen ürünlerin speclreide güncellenecek.. --->
<cfif len(spect_main_id_list)><!--- spec'i var ise... --->
	<cfoutput query="GET_TREE_STOCKS"><!--- DAHA SONRA  ÜRÜN AĞACINI DÖNDÜREREK İÇİNDEKİ YARI MAMUL OLANLARIN PHANTOM OLUP OLMADIĞINI ÜRÜNÜN DAHA ÖNCEKİ SPECLERİNDE DE DEĞİŞTİRİYORUZ...BUNU ŞU SEBEBLE YAPIYORUZ..PHANTOM ÜRÜN AĞACI SEÇENİNN SPEC'İ DEĞİŞTİRMEMESİ İSTENİYOR,EĞER SPEC'E KAYDETMEZSEK TE ÜRETİMDE DOĞRU BİLGİLERE ULAŞAMIYORUZ,BURDA TÜM MAIN SPEC ROE SATIRLARININ SATIRLARININ GÜNCELLEYEREK ÜRETİMİ DOĞRU YAPMAYA ÇALIŞIYORUZ..--->
		<cfquery name="upd_spec_main_row" datasource="#dsn3#">
			UPDATE 
				SPECT_MAIN_ROW 
			SET 
				IS_FREE_AMOUNT = #IS_FREE_AMOUNT#,
                IS_SEVK = #IS_SEVK#,
				FIRE_AMOUNT = #FIRE_AMOUNT#,
				FIRE_RATE = #FIRE_RATE#,
				QUESTION_ID = #QUESTION_ID#
				<cfif X_IS_PHANTOM_TREE eq 1><!--- Phantom yani hayalet ürün ağacı kullanılsın denilmiş ise.. --->
					,IS_PHANTOM = #IS_PHANTOM# 
				</cfif>
			WHERE 
            	 ((RELATED_TREE_ID IS NOT NULL AND RELATED_TREE_ID = #PRODUCT_TREE_ID#) OR RELATED_TREE_ID IS NULL) AND
				SPECT_MAIN_ID IN (#spect_main_id_list#) 
                AND STOCK_ID = #_STOCK_ID_#
		</cfquery>
	</cfoutput>
    <cfoutput query="GET_TREE_OPERATIONS"><!--- DAHA SONRA  ÜRÜN AĞACINI DÖNDÜREREK İÇİNDEKİ YARI MAMUL OLANLARIN PHANTOM OLUP OLMADIĞINI ÜRÜNÜN DAHA ÖNCEKİ SPECLERİNDE DE DEĞİŞTİRİYORUZ...BUNU ŞU SEBEBLE YAPIYORUZ..PHANTOM ÜRÜN AĞACI SEÇENİNN SPEC'İ DEĞİŞTİRMEMESİ İSTENİYOR,EĞER SPEC'E KAYDETMEZSEK TE ÜRETİMDE DOĞRU BİLGİLERE ULAŞAMIYORUZ,BURDA TÜM MAIN SPEC ROE SATIRLARININ SATIRLARININ GÜNCELLEYEREK ÜRETİMİ DOĞRU YAPMAYA ÇALIŞIYORUZ..--->
		<cfquery name="upd_spec_main_row" datasource="#dsn3#">
            UPDATE 
				SPECT_MAIN_ROW 
			SET 
				IS_FREE_AMOUNT = #IS_FREE_AMOUNT#,
                IS_SEVK = #IS_SEVK#,
				FIRE_AMOUNT = #FIRE_AMOUNT#,
				FIRE_RATE = #FIRE_RATE#,
				QUESTION_ID = #QUESTION_ID#
				<cfif X_IS_PHANTOM_TREE eq 1><!--- Phantom yani hayalet ürün ağacı kullanılsın denilmiş ise.. --->
					,IS_PHANTOM = #IS_PHANTOM# 
				</cfif>
			WHERE 
            	((RELATED_TREE_ID IS NOT NULL AND RELATED_TREE_ID = #PRODUCT_TREE_ID#) OR RELATED_TREE_ID IS NULL) AND
				SPECT_MAIN_ID IN (#spect_main_id_list#) 
                AND OPERATION_TYPE_ID = #OPERATION_TYPE_ID#
		</cfquery>
	</cfoutput>
</cfif>
<cfquery name="GET_PRO_TREE_ID" datasource="#DSN3#">
  SELECT 
  	PT.PRODUCT_TREE_ID,
    PT.RECORD_DATE,
    PT.UPDATE_DATE,
    PT.RECORD_EMP,
    (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.UPDATE_EMP) AS UPDATE_NAME,
    (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.RECORD_EMP) AS RECORD_NAME,
    UPDATE_EMP ,
	PROCESS_STAGE
 FROM 
 	PRODUCT_TREE  PT
 WHERE 
 	STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STOCK_ID#">
</cfquery>
<cfif get_pro_tree_id.recordcount>
	<cfquery name="upd_row" datasource="#dsn3#">
		UPDATE PRODUCT_TREE SET PROCESS_STAGE = #attributes.process_stage# WHERE PRODUCT_TREE_ID = #get_pro_tree_id.PRODUCT_TREE_ID#
	</cfquery>
	<!----<cf_workcube_process is_upd='1' 
		data_source='#dsn3#' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='index.cfm?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.STOCK_ID#' 
		action_id='#GET_PRO_TREE_ID.PRODUCT_TREE_ID#'
		action_table='PRODUCT_TREE'
		action_column='PRODUCT_TREE_ID'
		warning_description='Ürün Ağacı : #attributes.STOCK_ID#'>---->
</cfif>
<cfif isdefined('is_upd_prod_order') and is_upd_prod_order eq 1 and get_main_prod.is_prototype eq 0><!--- xmlde üretim emirleri güncellensin evet seçili ise ve ürün özelleştirilebilir değilse buraya girer. hgul 20130306 --->
	<cfinclude template="upd_prod_order_stocks.cfm">
</cfif>
<cfif len(product_tree_id_list)>
    <cfquery name="upd_product_tree" datasource="#dsn3#">
        UPDATE 
        	PRODUCT_TREE 
		SET 
        	SPECT_MAIN_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =PRODUCT_TREE.RELATED_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
		WHERE 
        	PRODUCT_TREE_ID IN (#product_tree_id_list#)
    </cfquery>
</cfif>
<!----
<script type="text/javascript">
//	AjaxPageLoad('<cfoutput>index.cfm?fuseaction=prod.emptypopupajax_function_product_tree&pro_tree_id=#attributes.pro_tree_id#&stock_id=#attributes.stock_id#<cfif isdefined("attributes.main_stock_id")>&main_stock_id=#attributes.main_stock_id#</cfif></cfoutput>','SHOW_PRODUCT_TREE',1);
</script>----->