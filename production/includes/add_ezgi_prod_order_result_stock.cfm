<cfparam name="is_stock_control_with_spec" default="1">
<cfparam name="attributes.type" default="2">
<cfset popup_spec_type=is_stock_control_with_spec>
<!--- Toplu Sonuç Girme Ekranı --->
<!--- İlk Önce Toplam Ürün İhtiyaçlarını stok_id ve spec_main id bazında almak için 
gruplayarak query'imizi çekiyoruz, 0 stock kontrelleri bu miktarlar üzerinden yapılacak...  --->
<cfif attributes.type eq 2 or attributes.type eq 3><!--- Stok fişi oluştur denildi ise yada stok kontrolü yapılıyorsa! --->
    <cfquery name="get_production_order_results_groups" datasource="#dsn3#">
        <cfif attributes.type eq 2><!--- Stok fişi oluştur deniliyorsa zaten üretim emri kaydedilmiştir... --->
        SELECT 
            SUM(PORR.AMOUNT) AS TOTAL_AMOUNT,
            PORR.STOCK_ID,
            <cfif popup_spec_type neq 1>0 SPEC_MAIN_ID<cfelse>ISNULL(PORR.SPEC_MAIN_ID,0) AS SPEC_MAIN_ID</cfif><!--- Üretim Emrinin XML ayarlarından Stok Kontrolü Speclere göre yapılsın denildiyse Speclere göre yoksa ürünün genel stoğuna göre çekiyoruz query'i --->
        FROM 
            PRODUCTION_ORDER_RESULTS POR,
            PRODUCTION_ORDER_RESULTS_ROW PORR
        WHERE 
            POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
            POR.P_ORDER_ID IN (#attributes.upd_id#) AND
	    POR.IS_STOCK_FIS <> 1 AND	
            PORR.TYPE = 2 <!--- SADECE SARFLAR STOK KONTROLÜNE GİRECEK. --->
        GROUP BY
                AMOUNT,
                PORR.STOCK_ID,
                PORR.SPEC_MAIN_ID
		<cfelseif attributes.type eq 3><!--- Stok kontrolü yapılıyorsa var olan üreim emirlerinden çekilcek... --->
           SELECT * FROM 
           (
                    SELECT
                        0 AS SPEC_MAIN_ID,
                        RELATED_ID AS STOCK_ID,
                        SUM(AMOUNT)*(SELECT QUANTITY FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind#) AS TOTAL_AMOUNT
                    FROM 
                        PRODUCT_TREE WHERE 
                    STOCK_ID IN(SELECT DISTINCT STOCK_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind# )
                    GROUP BY RELATED_ID
            UNION 
                    SELECT
                        <cfif popup_spec_type neq 1>0 AS SPEC_MAIN_ID<cfelse>ISNULL(RELATED_MAIN_SPECT_ID,0) AS SPEC_MAIN_ID</cfif>,
                        STOCK_ID, 
                        SUM(AMOUNT)*(SELECT QUANTITY FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind#) AS TOTAL_AMOUNT
                    FROM 
                        SPECT_MAIN_ROW SMR WHERE 
                    SMR.SPECT_MAIN_ID IN(SELECT DISTINCT SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID =#pind# )
                    AND SMR.STOCK_ID IS NOT NULL
                    GROUP BY STOCK_ID,RELATED_MAIN_SPECT_ID 
           ) TABLE_PRODUCTION 
		</cfif>
    </cfquery>
    <cfset stock_id_list = 0 >
    <cfset spec_main_id_list = 0>
    <cfquery name="get_production_order_results_groups_specsiz" dbtype="query">
        SELECT * FROM get_production_order_results_groups WHERE SPEC_MAIN_ID = 0 AND STOCK_ID IS NOT NULL
    </cfquery>
    <cfif get_production_order_results_groups_specsiz.recordcount>
        <cfset stock_id_list = ValueList(get_production_order_results_groups_specsiz.STOCK_ID,',')>
        <cfloop query="get_production_order_results_groups_specsiz">
            <cfset 'gerekli_miktar_stock#STOCK_ID#' =TOTAL_AMOUNT>
        </cfloop>
    </cfif>
    <cfquery name="get_production_order_results_groups_specli" dbtype="query">
        SELECT * FROM get_production_order_results_groups WHERE SPEC_MAIN_ID > 0
    </cfquery>
    <cfif get_production_order_results_groups_specli.recordcount>
        <cfset spec_main_id_list = ValueList(get_production_order_results_groups_specli.SPEC_MAIN_ID)>
        <cfloop query="get_production_order_results_groups_specli">
            <cfset 'gerekli_miktar_spec#SPEC_MAIN_ID#' =TOTAL_AMOUNT>
        </cfloop>
    </cfif>
    <cfset attributes.exit_department_id = GET_STATION_INFO.EXIT_DEP_ID>
	<cfset attributes.exit_location_id = GET_STATION_INFO.EXIT_LOC_ID>
    <cfscript>
        user_info = '';
        dep_id = attributes.exit_department_id;
        loc_id = attributes.exit_location_id;
        is_update = 0;
        stock_type = 0;
    </cfscript>
    <cfquery name="GET_ZERO_STOCK_CONTROL" datasource="#dsn3#">
         SELECT 
            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK,
            S.PRODUCT_NAME AS PRODUCT_NAME,
            0 SPECT_MAIN_ID,
            S.STOCK_ID
            
        FROM 
            STOCKS S, 
            #dsn2_alias#.STOCKS_ROW SR
        WHERE 
            SR.STOCK_ID = S.STOCK_ID AND 
            SR.STOCK_ID IN (#stock_id_list#) AND 
            S.IS_ZERO_STOCK = 0 AND
            SR.STORE_LOCATION = #loc_id# AND
            SR.STORE = #dep_id#
        GROUP BY 
            S.STOCK_ID,
            S.PRODUCT_NAME
    UNION ALL  
        SELECT 
            SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_TOTAL_STOCK, 
            SM.SPECT_MAIN_NAME AS PRODUCT_NAME,
            SM.SPECT_MAIN_ID,
            0 STOCK_ID
        FROM 
            #dsn2_alias#.STOCKS_ROW AS SR, 
            SPECT_MAIN AS SM,
            STOCKS S
        WHERE
            S.STOCK_ID = SM.STOCK_ID AND
            S.STOCK_ID = SR.STOCK_ID AND
            S.IS_ZERO_STOCK = 0 AND
            SR.PROCESS_TYPE IS NOT NULL AND
            SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID AND 
            SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND 
            UPD_ID NOT IN (0)  AND 
            SR.STORE_LOCATION = #loc_id# AND
            SR.STORE = #dep_id#
        GROUP BY 
            SM.SPECT_MAIN_NAME,SM.SPECT_MAIN_ID
    </cfquery>
	<cfif GET_ZERO_STOCK_CONTROL.recordcount>
        <cfscript>
            for(zi=1;zi lte GET_ZERO_STOCK_CONTROL.recordcount;zi=zi+1){
            _spect_main_id_ = GET_ZERO_STOCK_CONTROL.SPECT_MAIN_ID[zi];
            _stock_id_ = GET_ZERO_STOCK_CONTROL.STOCK_ID[zi];
            _mevcut_stok_ = GET_ZERO_STOCK_CONTROL.PRODUCT_TOTAL_STOCK[zi];
            _product_name_ = GET_ZERO_STOCK_CONTROL.PRODUCT_NAME[zi];
                if(_stock_id_ gt 0){
                    if(isdefined("gerekli_miktar_stock#_stock_id_#") and Evaluate("gerekli_miktar_stock#_stock_id_#") gt _mevcut_stok_)
                        user_info ='#user_info#<tr height="25" class="color-list"><td>#_product_name_#</td><td align="center">-</td><td align="right">#Evaluate("gerekli_miktar_stock#_stock_id_#")#</td><td align="right">#_mevcut_stok_#</td><td align="right">#Evaluate("gerekli_miktar_stock#_stock_id_#")-_mevcut_stok_#</td></tr>';
                }
                else if(_spect_main_id_ gt 0){
                    if(isdefined("gerekli_miktar_spec#_spect_main_id_#") and Evaluate("gerekli_miktar_spec#_spect_main_id_#") gt _mevcut_stok_)
                        user_info ='#user_info#<tr height="25" class="color-list"><td>#_product_name_#</td><td align="center">#_spect_main_id_#</td><td align="right">#Evaluate("gerekli_miktar_spec#_spect_main_id_#")#</td><td align="right">#_mevcut_stok_#</td><td align="right">#Evaluate("gerekli_miktar_spec#_spect_main_id_#")-_mevcut_stok_#</td></tr>';
                }
            }
        </cfscript>
    <cfelse>
        <cfset user_info = '<tr class="color-list" height="30"><td colspan="5" class="txtbold">Eksik Stok Bulunamadı!</td></tr>'>    
    </cfif>
</cfif>

<cfif (isdefined('user_info') and len(user_info) and not user_info contains 'Eksik Stok Bulunamadı!') or isdefined('attributes.stock_control')><!--- Eğer bu bloğa girerse Stokta Sıkıntı Var Demektir yada kullanıcı stok kontrolü yapmak istemiştir!--->
	<table width="100%" class="color-border" cellpadding="2" cellspacing="1">
		<tr class="color-row">
			<td class="txtbold" colspan="5"><font color="FF0000">Üretimi Sonuçlandırmak İçin Aşağıdaki Ürünlerde Yeterli Stok Miktarı Bulunmamaktadır!</font></td>
		</tr>
		<tr class="color-header" height="30">
			<td class="form-title" width="150">Ürün Adı</td>
			<td class="form-title" width="40">Spec M</td>
			<td width="80" align="right" class="form-title" style="text-align:right;">Gerekli Miktar</td>
			<td width="120"align="right" class="form-title" style="text-align:right;">Stok Miktarı</td>
			<td width="80" align="right" class="form-title" style="text-align:right;">Eksik Miktar</td>
		</tr>
		<cfoutput>#user_info#</cfoutput>
	</table>
	<cfabort>
<cfelse>
	<cfset attributes.p_order_id = #attributes.upd_id#>
	<cfset attributes.is_multi = 1 >             
	<cfset is_demontaj = 0>
	<cfinclude template="add_ezgi_prod_order_result_to_stock.cfm">
</cfif>