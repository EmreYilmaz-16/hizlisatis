<cfquery name="get_shippng_plan" datasource="#dsn3#">
	<cfif attributes.is_type eq 1>
        SELECT     
            ESR.SHIP_RESULT_ID, 
            ESR.DELIVER_EMP, 
            ESR.NOTE, 
            ESR.DELIVER_PAPER_NO, 
            ESR.REFERENCE_NO, 
            ESR.OUT_DATE, 
            SM.SHIP_METHOD,
            SM.SHIP_METHOD SHIP_METHOD_TYPE,
            ESR.DELIVERY_DATE, 
            ESR.DEPARTMENT_ID,
            ESR.LOCATION_ID, 
            ESR.SHIP_STAGE, 
            ESR.COMPANY_ID, 
            ESR.PARTNER_ID, 
            ESR.CONSUMER_ID ,
            ISNULL(ESR.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR
        FROM         
            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
            #dsn_alias#.SHIP_METHOD AS SM ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
        WHERE     
            ESR.SHIP_RESULT_ID = #attributes.iid#
  	<cfelse>
    	SELECT     
        	SI.DISPATCH_SHIP_ID, 
            SI.DELIVER_EMP,  
            SI.DETAIL NOTE,
            SI.DISPATCH_SHIP_ID DELIVER_PAPER_NO,
            '' as REFERENCE_NO,
            SI.DELIVER_DATE OUT_DATE,
            SM.SHIP_METHOD,
            SM.SHIP_METHOD SHIP_METHOD_TYPE,
            DateAdd(d,1,SI.DELIVER_DATE) DELIVERY_DATE,
            SI.LOCATION_OUT LOCATION_ID, 
            SI.DEPARTMENT_OUT DEPARTMENT_ID ,
            SI.PROCESS_STAGE SHIP_STAGE, 
         	SI.DEPARTMENT_IN, 
            SI.LOCATION_IN,
            ISNULL(SI.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR
		FROM         
        	#dsn2_alias#.SHIP_INTERNAL AS SI LEFT OUTER JOIN
       		#dsn_alias#.SHIP_METHOD AS SM ON SI.SHIP_METHOD = SM.SHIP_METHOD_ID
		WHERE     
        	SI.DISPATCH_SHIP_ID = #attributes.iid#
    </cfif>
</cfquery>
<cfif get_shippng_plan.recordcount>
	<cfparam name="attributes.reference_no" default="#get_shippng_plan.REFERENCE_NO#">
    <cfparam name="attributes.ship_method_id" default="#get_shippng_plan.SHIP_METHOD_TYPE#">
    <cfparam name="attributes.ship_method_name" default="#get_shippng_plan.SHIP_METHOD#">
  	<cfquery name="get_default_department" datasource="#dsn#">
    	SELECT DEFAULT_MK_TO_RF_DEP, DEFAULT_MK_TO_RF_LOC FROM PRTOTM_PDA_DEPARTMENT_DEFAULTS WHERE EPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfif get_default_department.recordcount>
    	<cfset default_dep = ListGetAt(get_default_department.DEFAULT_MK_TO_RF_DEP,2)>
        <cfset default_loc = ListGetAt(get_default_department.DEFAULT_MK_TO_RF_LOC,2)>
    <cfelse>
    	<cfset default_dep =''>
        <cfset default_loc =''>
    </cfif>
    <cfquery name="get_department" datasource="#dsn#">
		SELECT     
        	DEPARTMENT.DEPARTMENT_HEAD, 
            DEPARTMENT.BRANCH_ID, 
            DEPARTMENT.DEPARTMENT_ID, 
            STOCKS_LOCATION.LOCATION_ID, 
            STOCKS_LOCATION.COMMENT
		FROM         
    		DEPARTMENT INNER JOIN
        	STOCKS_LOCATION ON DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID
  	  	WHERE     
        	DEPARTMENT.DEPARTMENT_ID = #get_shippng_plan.DEPARTMENT_ID# AND 
            STOCKS_LOCATION.LOCATION_ID = #get_shippng_plan.LOCATION_ID#    
	</cfquery>
    <cfif attributes.is_type eq 2>
        <cfquery name="get_department_in" datasource="#dsn#">
            SELECT     
                DEPARTMENT.DEPARTMENT_HEAD, 
                DEPARTMENT.BRANCH_ID, 
                DEPARTMENT.DEPARTMENT_ID, 
                STOCKS_LOCATION.LOCATION_ID, 
                STOCKS_LOCATION.COMMENT
            FROM         
                DEPARTMENT INNER JOIN
                STOCKS_LOCATION ON DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID
            WHERE     
                DEPARTMENT.DEPARTMENT_ID = #get_shippng_plan.DEPARTMENT_IN# AND 
                STOCKS_LOCATION.LOCATION_ID = #get_shippng_plan.LOCATION_IN#    
        </cfquery>
   	</cfif>
    <cfparam name="attributes.branch_id" default="#get_department.BRANCH_ID#">
    <cfparam name="attributes.department_id" default="#get_department.DEPARTMENT_ID#">
    <cfparam name="attributes.location_id" default="#get_department.LOCATION_ID#">
    <cfparam name="attributes.department_name" default="#get_department.DEPARTMENT_HEAD#-#get_department.COMMENT#">
    <cfquery name="get_order_det" datasource="#DSN3#">
    	SELECT     
            TBL2.TYPE, 
            TBL2.ORDER_ROW_ID, 
            TBL2.DELIVER_DATE, 
            TBL2.ORDER_DATE AS SV_ORDER_DATE, 
            TBL2.COMPANY_ID AS SV_COMPANY_ID, 
            TBL2.ORDER_NUMBER AS SV_ORDER_NUMBER, 
            TBL2.ORDER_ID AS SV_ORDER_ID, 
            TBL2.DURUM, 
            TBL.IS_TYPE, 
            TBL.SHIP_RESULT_ID, 
            TBL.OUT_DATE, 
            TBL.SHIP_METHOD_TYPE, 
            TBL.DELIVER_PAPER_NO, 
            TBL.LOCATION_ID, 
            TBL.DEPARTMENT_ID, 
            TBL.DEPARTMENT_IN, 
            ORR4.SPECT_VAR_ID,
            ORR4.STOCK_ID, 
            ORR4.QUANTITY, 
            ORR4.PRODUCT_NAME2,
            ORR4.ORDER_ROW_CURRENCY,
            ORR4.UNIT BIRIM, 
            ORR4.ORDER_ROW_ID AS SA_ORDER_ROW_ID,
            ORR4.WRK_ROW_ID,
            O4.ORDER_ID AS SA_ORDER_ID, 
            O4.COMPANY_ID AS SA_COMPANY_ID, 
            O4.EMPLOYEE_ID AS SA_EMPLOYEE_ID, 
            O4.CONSUMER_ID AS SA_CONSUMER_ID, 
            O4.ORDER_DETAIL AS SA_ORDER_DETAIL, 
            O4.ORDER_NUMBER AS SA_ORDER_NUMBER, 
            O4.ORDER_DATE AS SA_ORDER_DATE, 
            O4.REF_NO,
            O4.IS_INSTALMENT,
            (
        	SELECT     
          		STOCK_CODE
			FROM         
            	STOCKS
			WHERE     
          		 STOCK_ID=ORR4.STOCK_ID
       		) AS STOCK_CODE,
            (
        	SELECT     
          		STOCK_CODE_2
			FROM         
            	STOCKS
			WHERE     
          		 STOCK_ID=ORR4.STOCK_ID
       		) AS STOCK_CODE_2,
            (
        	SELECT     
          		PRODUCT_NAME
			FROM         
            	STOCKS
			WHERE     
          		 STOCK_ID=ORR4.STOCK_ID
       		) AS PRODUCT_NAME,
            (
            SELECT     
            	SPECT_MAIN_ID
			FROM         
            	SPECTS
			WHERE     
            	SPECT_VAR_ID = ORR4.SPECT_VAR_ID
            ) AS SPECT_MAIN_ID,
            (
            	SELECT       
                	SUM(REAL_STOCK) AS REAL_STOCK
				FROM            
                	#dsn2_alias#.GET_STOCK_LAST_LOCATION
				WHERE  
                	<cfif len(default_dep) and len(default_loc)>     
                        LOCATION_ID = #default_loc# AND 
                        DEPARTMENT_ID = #default_dep# AND 
                    </cfif>
                    STOCK_ID = ORR4.STOCK_ID
           	) AS DEPO
        FROM         
            (
            SELECT     
                1 AS TYPE, 
                EORR.ORDER_ROW_ID, 
                ORR1.STOCK_ID, 
                ORR1.DELIVER_DATE, 
                O1.ORDER_DATE, 
                O1.COMPANY_ID, 
                O1.ORDER_NUMBER, 
                O1.ORDER_ID, 
                EORR.O_DURUM1 AS DURUM
            FROM          
                PRTOTM_ORDER_REL_RESULT AS EORR INNER JOIN
                ORDER_ROW AS ORR1 ON EORR.ORDER_ROW_ID1 = ORR1.ORDER_ROW_ID INNER JOIN
                ORDERS AS O1 ON ORR1.ORDER_ID = O1.ORDER_ID
            UNION ALL
            SELECT     
                2 AS TYPE, 
                EORR.ORDER_ROW_ID, 
                ORR2.STOCK_ID, 
                ORR2.DELIVER_DATE, 
                O2.ORDER_DATE, 
                O2.COMPANY_ID, 
                O2.ORDER_NUMBER, 
                O2.ORDER_ID, 
                EORR.O_DURUM2 AS DURUM
            FROM         
                ORDERS AS O2 INNER JOIN
                ORDER_ROW AS ORR2 ON O2.ORDER_ID = ORR2.ORDER_ID INNER JOIN
                PRTOTM_ORDER_REL_RESULT AS EORR ON ORR2.ORDER_ROW_ID = EORR.ORDER_ROW_ID2
            UNION ALL
            SELECT     
                3 AS TYPE, 
                EORR.ORDER_ROW_ID, 
                PO.STOCK_ID, 
                PO.FINISH_DATE AS DELIVER_DATE, 
                PO.START_DATE AS ORDER_DATE, 
                PO.STATION_ID AS COMPANY_ID, 
                PO.LOT_NO AS ORDER_NUMBER, 
                PO.P_ORDER_ID AS ORDER_ID, 
                EORR.P_DURUM AS DURUM
            FROM         
                PRODUCTION_ORDERS AS PO INNER JOIN
                PRTOTM_ORDER_REL_RESULT AS EORR ON PO.P_ORDER_ID = EORR.P_ORDER_ID
            ) AS TBL2 RIGHT OUTER JOIN
            (
            <cfif is_type eq 1>
            SELECT     
                ESR.IS_TYPE, 
                ESR.SHIP_RESULT_ID, 
                ESR.OUT_DATE, 
                ESR.SHIP_METHOD_TYPE, 
                ESR.DELIVER_PAPER_NO, 
                ESR.LOCATION_ID, 
                ESR.DEPARTMENT_ID, 
                ESR.DEPARTMENT_ID AS DEPARTMENT_IN, 
                ESRR.ORDER_ROW_ID,
                ESR.IS_SEVK_EMIR
            FROM         
                PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID
            WHERE      
                ESR.SHIP_RESULT_ID = #attributes.iid#
            <cfelse>
            SELECT     
                2 AS IS_TYPE, 
                SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID, 
                SI.DELIVER_DATE AS OUT_DATE, 
                SI.SHIP_METHOD AS SHIP_METHOD_TYPE, 
                CAST(SI.DISPATCH_SHIP_ID AS VARCHAR(50)) AS DELIVER_PAPER_NO, 
                SI.LOCATION_OUT AS LOCATION_ID, 
                SI.DEPARTMENT_OUT AS DEPARTMENT_ID, 
                SI.DEPARTMENT_IN, 
                SIR.ROW_ORDER_ID AS ORDER_ROW_ID,
                0 AS IS_SEVK_EMIR
            FROM         
                #dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
                #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID
            WHERE     
                SI.DISPATCH_SHIP_ID = #attributes.iid#
          	</cfif>
            ) AS TBL ON TBL2.ORDER_ROW_ID = TBL.ORDER_ROW_ID INNER JOIN
            ORDER_ROW AS ORR4 ON TBL.ORDER_ROW_ID = ORR4.ORDER_ROW_ID INNER JOIN
            ORDERS AS O4 ON ORR4.ORDER_ID = O4.ORDER_ID
      	WHERE
        	SHIP_RESULT_ID =  #attributes.iid# 
	</cfquery>
    <!---<cfdump expand="yes" var="#get_order_det#">
    <CFABORT>--->
    <cfset order_row_id_list = Valuelist(get_order_det.ORDER_ROW_ID)>
</cfif>
<cfif isdefined('attributes.type') and attributes.type eq 1>
	<cfset PRTOTM_header = 'Detay Göster'>
<cfelse>
	<cfset PRTOTM_header = 'Sevkiyat Planı Ekle'>
</cfif>
<cf_popup_box title="<cfoutput>#PRTOTM_header#</cfoutput>">
	<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=sales.emptypopup_upd_PRTOTM_shipping&iid=#attributes.iid#">
    	<cfoutput>
		<table>
			<tr>
				<td width="130"></td>
				<td width="210"></td>
				<td width="130"><strong>Sevkiyat No :<strong> </td>
				<td>#get_shippng_plan.DELIVER_PAPER_NO#</td>
			</tr>
			<tr>
            	<cfif attributes.is_type eq 1>
                    <td><strong><cf_get_lang_main no='107.Cari Hesap'> :<strong> </td>
                    <td>#get_par_info(get_shippng_plan.company_id,1,0,0)# #get_cons_info(get_shippng_plan.consumer_id,1,0,0)#</td>
               	<cfelse>
                	<td><strong>Sevkedilecek Şube :<strong> </td>
                    <td>#get_department_in.DEPARTMENT_HEAD#</td>
                </cfif>
                <td><strong><cf_get_lang_main no='1382.Referans No'> :<strong> </td>
				<td>#attributes.reference_no#</td>
			</tr>
			<tr>
				<td><strong><cf_get_lang_main no='166.Yetkili'> :<strong> </td>
				<td>
                	<cfif attributes.is_type eq 1>
						#get_par_info(get_shippng_plan.partner_id,0,-1,0)#
                  	</cfif>
				</td>
                <td><strong><cf_get_lang_main no='1631.Çıkış Depo'> :<strong> </td>
				<td>#attributes.department_name#</td>
			</tr>
			<tr>
				<td><strong><cf_get_lang_main no='1703.Sevk Yöntemi'> :<strong> </td>
				<td>#attributes.ship_method_name#</td>
				<td><strong>Depo Çıkış Tarihi :<strong> </td>
				<td>#dateformat(get_shippng_plan.OUT_DATE,'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td rowspan="2" valign="top"><strong><cf_get_lang_main no='217.Açıklama'> :<strong> </td>
				<td rowspan="2" valign="top">#get_shippng_plan.NOTE#</td>
				<td><strong><cf_get_lang_main no='233.Teslim Tarih'> :<strong> </td>
				<td>#dateformat(get_shippng_plan.DELIVERY_DATE,'dd/mm/yyyy')#</td>
			</tr>
			<tr>
				<td><strong>Sevk Planlayan :<strong> </td>
				<td>#get_emp_info(get_shippng_plan.DELIVER_EMP,0,0)#</td>
			</tr>
            
		</table>
       	</cfoutput>
		<cf_form_list>
			<thead>
				<tr> 
                	<th style="width:80px">Sipariş No</th>
                	<th style="width:100px">Üretici Kodu</th>
					<th style="width:220px"><cf_get_lang_main no='245.Ürün'></th>
					<th style="width:80px">Depo</th>
					<th style="text-align:right; width:60px"><cf_get_lang_main no='199.Sipariş'></th>
                    <th style="text-align:center; width:60px">Aşama</th>
                    <th style="text-align:center; width:15px">
						<cfif isdefined('attributes.type') and attributes.type eq 1>
                        	DRM
                        <cfelse>
                        	<input type="checkbox" alt="Hepsini Seç" onClick="grupla(-1);">
                 		</cfif>
                    </th>
				</tr>
			</thead>
			<tbody id="table2">
            	<cfset irs_top=0>
            	<cfif get_order_det.recordcount>
                    <cfoutput query="get_order_det">
                    	<cfif len(ORDER_ROW_ID)>
                    		<cfif left(STOCK_CODE,9) eq '01.152.02'>
                            	<cfquery name="get_product_order" datasource="#dsn3#">
                                	SELECT     
                                    	IS_STAGE,
                                        P_ORDER_ID
									FROM         
                                    	PRODUCTION_ORDERS
									WHERE     
                                    	P_ORDER_ID IN
                          							(
                                                    	SELECT     
                                                        	PRODUCTION_ORDER_ID
                            							FROM          
                                                        	PRODUCTION_ORDERS_ROW
                            							WHERE      
                                                        	ORDER_ROW_ID = #ORDER_ROW_ID#
                                                            
                                                   	) 
                                    	AND PRODUCTION_LEVEL = N'0'
                                </cfquery>
                                <cfif get_product_order.recordcount and  get_product_order.IS_STAGE neq 2>
                                    <cfquery name="get_order_uretim_durum" datasource="#dsn3#">
                                        SELECT     
                                            *, 
                                            CASE
                                                WHEN OPERASYON_5 >0 AND OPERASYON_5 <5
                                                THEN 5
                                                WHEN OPERASYON_4 >0 AND OPERASYON_4 <5
                                                THEN 4
                                                WHEN OPERASYON_3 >0 AND OPERASYON_3 <5
                                                THEN 3
                                                WHEN OPERASYON_2 >0 AND OPERASYON_2 <5
                                                THEN 2
                                                WHEN OPERASYON_1 >0 AND OPERASYON_1 <5
                                                THEN 1
                                                ELSE 0
                                            END
                                                AS DURUM
                                        FROM         
                                            PRTOTM_PRODUCTION_A
                                        WHERE     
                                            P_ORDER_ID =#get_product_order.P_ORDER_ID#
                                                        
                                    </cfquery>
                                    <cfset lot_list = Valuelist(get_order_uretim_durum.LOT_NO)>
                                    <cfif Listlen(lot_list)>
                                        <cfquery name="get_period" datasource="#dsn3#">
                                                SELECT     
                                                    PERIOD_ID
                                                FROM         
                                                    PRTOTM_METARIAL_RELATIONS
                                                WHERE     
                                                    TYPE = 2 AND 
                                                    LOT_NO IN (#lot_list#)
                                                GROUP BY
                                                    PERIOD_ID      
                                        </cfquery>
                                        <cfif get_period.recordcount>
                                                <cfset period_list = ValueList(get_period.PERIOD_ID)>
                                                <cfquery name="get_period_ship_dsns" datasource="#dsn3#">
                                                    SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#)
                                                </cfquery>
                                        </cfif>
                                	<cfelse>
                                    
                                    </cfif>
                                    <cfif get_order_uretim_durum.recordcount>
                                        <cfif get_order_uretim_durum.durum neq 0>
                                            <cfloop query="get_order_uretim_durum">
                                                <cfif Evaluate('OPERASYON_#durum#') eq 1>
                                                    <cfset durum_1 = 'Devam Ediyor'>
                                                <cfelseif Evaluate('OPERASYON_#durum#') eq 3>
                                                    <cfset durum_1 = 'Tamamlandı'>
                                                <cfelseif Evaluate('OPERASYON_#durum#') eq 0>
                                                    <cfset durum_1 = 'Başlamadı'>     
                                                </cfif>
                                            </cfloop>
                                        <cfelse>
                                            <cfquery name="get_kontrol_0" datasource="#dsn3#"> <!---Optimizasyona ve Var-yok a giren emirler soruluyor--->
                                                SELECT DISTINCT 
                                                    POS.STOCK_ID, 
                                                    POS.AMOUNT,
                                                    EMC.STATUS
                                                FROM         
                                                    PRTOTM_METARIAL_CONTROL AS EMC INNER JOIN
                                                    PRODUCTION_ORDERS_STOCKS AS POS ON EMC.POR_STOCK_ID = POS.POR_STOCK_ID
                                                WHERE     
                                                    EMC.LOT_NO = N'#get_order_uretim_durum.lot_no#' 
                                            </cfquery> 
                                            <cfquery name="get_PRTOTM_metarial_control_0" dbtype="query"> <!---Optimizasyondan Geçen heşey guruplanıyor--->
                                                SELECT
                                                    STOCK_ID, 
                                                    SUM(AMOUNT) AS AMOUNT
                                                FROM         
                                                    get_kontrol_0
                                                GROUP BY 
                                                    STOCK_ID
                                            </cfquery>
                                            <cfif isdefined('period_list') and listlen(period_list) and period_list neq 0>
                                                <cfquery name="get_control_ambar_fis" datasource="#DSN3#">
                                                    SELECT 
                                                        STOCK_ID,
                                                        SUM(AMOUNT) AMOUNT
                                                    FROM
                                                        (
                                                        <cfloop query="get_period_ship_dsns">
                                                            SELECT     
                                                                SFR.STOCK_ID, 
                                                                SFR.AMOUNT
                                                            FROM         
                                                                PRTOTM_METARIAL_RELATIONS INNER JOIN
                                                                #dsn#_#get_period_ship_dsns.PERIOD_YEAR#_#get_period_ship_dsns.OUR_COMPANY_ID#.dbo.STOCK_FIS_ROW AS SFR ON PRTOTM_METARIAL_RELATIONS.ACTION_ID = SFR.FIS_ID
                                                            WHERE     


                                                                PRTOTM_METARIAL_RELATIONS.TYPE = 2 AND 
                                                                PRTOTM_METARIAL_RELATIONS.PERIOD_ID = #get_period_ship_dsns.period_id# AND 
                                                                PRTOTM_METARIAL_RELATIONS.LOT_NO = N'#get_order_uretim_durum.lot_no#'
                                                            <cfif currentrow neq get_period_ship_dsns.recordcount> UNION ALL </cfif> 
                                                        </cfloop>
                                                        ) TBL
                                                    GROUP BY
                                                        STOCK_ID 			
                                                </cfquery>
                                                
                                                <cfif get_control_ambar_fis.recordcount>
                                                
                                                    <cfif get_control_ambar_fis.recordcount neq get_PRTOTM_metarial_control_0.recordcount>
                                                        <cfset durum_1 = 'Devam Ediyor'>		
                                                    <cfelse>
                                                        <cfset durum_1 = 'Tamamlandı'>
                                                    </cfif>
                                                <cfelse>
                                                    <cfset durum_1 = 'Başlamadı'>
                                                </cfif>
                                            <cfelse>
                                            	<cfset durum_1 = 'Başlamadı'>
                                            </cfif>    
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                	<cfquery name="get_purchase_order" datasource="#dsn3#">
                                	SELECT     
                                    	ORDER_ROW_1.DELIVER_AMOUNT, 
                                        ORDER_ROW_1.ORDER_ROW_CURRENCY
									FROM         
                                    	ORDER_ROW INNER JOIN
                      					ORDER_ROW AS ORDER_ROW_1 ON ORDER_ROW.WRK_ROW_ID = ORDER_ROW_1.WRK_ROW_RELATION_ID
									WHERE     
                                    	ORDER_ROW.ORDER_ROW_ID = #ORDER_ROW_ID#
									</cfquery>
                                </cfif>
                       		</cfif>
                        </cfif>
                        <cfset stock_id=get_order_det.STOCK_ID>
                        <tr>
                        	<td>
                            	<cfif attributes.is_type eq 1>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.list_order&event=upd&order_id=#get_order_det.sa_order_id#','longpage');" class="tableyazi" title="Satış Siparişine Git">
                                    	#get_order_det.SA_ORDER_NUMBER#
                                    </a>
                                <cfelse>
                                	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_det.sa_order_id#','wide');" class="tableyazi" title="Satış Siparişine Git">
                                    	#get_order_det.SA_ORDER_NUMBER#
                                    </a>
                                </cfif>
                           	</td>
                        	<td>#get_order_det.STOCK_CODE_2#</td>
                            <td>#get_order_det.PRODUCT_NAME#</td>
                            <td style="text-align:right;">#AmountFormat(get_order_det.DEPO)#</td>
                            <td style="text-align:right;">#AmountFormat(get_order_det.QUANTITY)#</td>
                            <td>
                            	<cfif isdefined('attributes.type') and attributes.type eq 1>
                                	<cfif TYPE eq 1 or TYPE eq 2>
										<cfif isdefined('DURUM') and len(DURUM)>
                                            <cfif DURUM eq -8><cf_get_lang_main no ='1952.Fazla Teslimat'>
                                            <cfelseif DURUM eq -7><cf_get_lang_main no ='1951.Eksik Teslimat'>
                                            <cfelseif DURUM eq -6><cf_get_lang_main no='1349.Sevk'>
                                            <cfelseif DURUM eq -5><cf_get_lang_main no ='44.Üretim'>
                                            <cfelseif DURUM eq -4><cf_get_lang_main no ='1950.Kismi Üretim'>
                                            <cfelseif DURUM eq -3><cf_get_lang_main no ='1949.Kapatildi'>
                                            <cfelseif DURUM eq -2><cf_get_lang_main no ='1948.Tedarik'>
                                            <cfelseif DURUM eq -1><cf_get_lang_main no='1305.Açık'>
                                            <cfelseif DURUM eq -9><cf_get_lang_main no ='1094.İptal'>
                                            <cfelseif DURUM eq -10>Kapatıldı(Manuel)
                                            </cfif>	
                                        </cfif>
                                    <cfelse>
                                    	<cfif len(ORDER_ROW_ID)>
											<cfif left(STOCK_CODE,9) eq '01.152.02'>
                                                    <cfif get_product_order.recordcount>
                                                        <cfif get_product_order.IS_STAGE eq 2>
                                                            <font color="green">
                                                            Üretim<br>Tamamlandı
                                                            </font>
                                                        <cfelse>
                                                            <cfif get_order_uretim_durum.recordcount>
                                                                <cfif get_order_uretim_durum.plan_type eq 1>
                                                                    <font color="orange">
                                                                        Üretim<br>Planlanıyor
                                                                        </font>
                                                                <cfelse>
                                                                    <cfloop query="get_order_uretim_durum">
                                                                        <cfif durum eq 5>Ambalaj</cfif>
                                                                        <cfif durum eq 4>K.Kontrol</cfif>
                                                                        <cfif durum eq 3>Döşeme</cfif>
                                                                        <cfif durum eq 2>Konfeksiyon</cfif>
                                                                        <cfif durum eq 1>Kesim</cfif>
                                                                        <cfif durum eq 0>Kumaş-Depo</cfif>
                                                                    </cfloop>
                                                                    <br>
                                                                    #durum_1#
                                                                </cfif>	
                                                            </cfif>
                                                        </cfif>
                                                    <cfelse>
                                                        <cfif get_purchase_order.recordcount>
                                                            <cfif get_purchase_order.ORDER_ROW_CURRENCY eq -3 or get_purchase_order.ORDER_ROW_CURRENCY eq -10 or get_purchase_order.ORDER_ROW_CURRENCY eq -9 or get_purchase_order.ORDER_ROW_CURRENCY eq -8>
                                                                <font color="green">
                                                                    Tedarik Tamamlandı
                                                                </font>
                                                            <cfelse>
                                                                <font color="blue">
                                                                    Tedarik Ediliyor
                                                                </font>
                                                            </cfif>
                                                        <cfelse>
                                                            <font color="red">
                                                                Üretim Bekleniyor
                                                            </font>
                                                        </cfif>
                                                    </cfif>
                                            <cfelse>
                                                <cfif DURUM eq 0><font color="red">Operatöre Gönderildi</font>
                                                <cfelseif DURUM eq 1><font color="red">Üretiliyor</font>
                                                <cfelseif DURUM eq 2><font color="green">Üretim Tamamlandı</font>
                                                <cfelseif DURUM eq 4><font color="red">Üretim Planı Yapılmadı</font>
                                                </cfif>
                                            </cfif>
                                        <cfelse>
                                        	<font color="gray">Rezerve Edilmemiş</font>
                                        </cfif>
                                	</cfif>
                                <cfelse>
									<cfif order_row_currency eq -8><cf_get_lang_main no ='1952.Fazla Teslimat'>
                                        <cfelseif order_row_currency eq -7><cf_get_lang_main no ='1951.Eksik Teslimat'>
                                        <cfelseif order_row_currency eq -6><cf_get_lang_main no='1349.Sevk'>
                                        <cfelseif order_row_currency eq -5><cf_get_lang_main no ='44.Üretim'>
                                        <cfelseif order_row_currency eq -4><cf_get_lang_main no ='1950.Kismi Üretim'>
                                        <cfelseif order_row_currency eq -3><cf_get_lang_main no ='1949.Kapatildi'>
                                        <cfelseif order_row_currency eq -2><cf_get_lang_main no ='1948.Tedzarik'>
                                        <cfelseif order_row_currency eq -1><cf_get_lang_main no='1305.Açık'>
                                        <cfelseif order_row_currency eq -9><cf_get_lang_main no ='1094.İptal'>
                                        <cfelseif order_row_currency eq -10>Kapatıldı(Manuel)
                                    </cfif>	
                               	</cfif>			
                       		</td>
                            
                            <td style="text-align:center;">
                           		<cfif isdefined('attributes.type') and attributes.type eq 1>
                                	<cfif len(ORDER_ROW_ID)>
                                        <cfquery name="get_confirm" datasource="#dsn3#">
                                            SELECT  
                                            	TOP (1)   
                                                CONFIRM_ANSWER
                                            FROM         
                                                PRTOTM_ORDER_ROW_CONFIRM
                                            WHERE     
                                                ORDER_ROW_ID = #ORDER_ROW_ID# AND 
                                                CONFIRM_TYPE = #attributes.is_type#
                                           	ORDER BY
                                            	CONFIRM_ID DESC
                                        </cfquery>
                                        <cfif DURUM eq -1 or DURUM eq -10 or DURUM eq -2 or DURUM eq -4 or DURUM eq -5 or DURUM eq -6 or DURUM eq -7 or DURUM eq -9 or DURUM eq 0 or DURUM eq 1 or DURUM eq 4>
                                            <cfif len(get_confirm.CONFIRM_ANSWER)>
                                                <cfif get_confirm.CONFIRM_ANSWER eq 1>
                                                	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_PRTOTM_confirm&order_row_id=#SA_ORDER_ROW_ID#','small');" class="tableyazi">
                                                        <img src="/images/yesil_top.png" title="Onay Verildi">
                                                   	</a>
                                                <cfelse>
                                                	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_PRTOTM_confirm&order_row_id=#SA_ORDER_ROW_ID#','small');" class="tableyazi">
                                                        <img src="/images/siyah.png" title="Onaylanmadı">
                                                  	</a>
                                                </cfif>
                                            <cfelse>
                                                    <img src="/images/gri.png" title="Onay Bekliyor">
                                            </cfif>
                                        <cfelse>
                                            <img src="/images/red_glob.gif" title="Hazır">
                                        </cfif>
                                    
                                    <cfelse>
                                  		<img src="/images/beyaz_top.png" title="Rezerve Edilmemiş"> 
                                    </cfif>
                                <cfelse>
                                	<cfif order_row_currency eq -8 or order_row_currency eq -9 or order_row_currency eq -10 or order_row_currency eq -3>
                                    	<img src="/images/b_ok.gif" border="0" title="İşlem Yapılamaz" />
                                  	<cfelseif order_row_currency eq -6>
                                    	<img src="/images/c_ok.gif" border="0" title="Sevk Emri Verildi" />
                                	<cfelse>
                                	<input type="checkbox" name="select_production" value="#WRK_ROW_ID#">
                                	</cfif>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
				</cfif>
                <tfoot>
                	<tr>
                    	<cfif isdefined('attributes.type') and attributes.type eq 1>
                        	<td colspan="8"></td>
                        <cfelse>
                        	<td colspan="5" align="right">
                            	<select name="select_name" id="select_name" onchange="degisim();">
                                	<option value="1" <cfif get_shippng_plan.IS_SEVK_EMIR eq 1>selected</cfif>>Sevkiyata Emir Verildi</option>
                                    <option value="0" <cfif get_shippng_plan.IS_SEVK_EMIR eq 0>selected</cfif>>Sevkiyata Emir Verilmedi</option>
                            	</select>
                            </td>
            				<td colspan="3" align="right"><input type="button" value="Sevk Et" onClick="grupla();"></td>
                        </cfif>
            		</tr>
                </tfoot>
            </tbody>
		</cf_form_list>
		
	</cfform>  
</cf_popup_box>      
<script language="javascript">
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
			order_row_id_list = '';
			chck_leng = document.getElementsByName('select_production').length;
			for(ci=0;ci<chck_leng;ci++)
			{
				var my_objets = document.all.select_production[ci];
				if(chck_leng == 1)
					var my_objets =document.all.select_production;
				if(type == -1)
				{//hepsini seç denilmişse	
					if(my_objets.checked == true)
						my_objets.checked = false;
					else
						my_objets.checked = true;
				}
				else
				{
					if(my_objets.checked == true)

						order_row_id_list +=my_objets.value+',';
				}
			}
			order_row_id_list = order_row_id_list.substr(0,order_row_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(order_row_id_list!='')
			{
			window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=eshipping.emptypopup_upd_prtotm_order_row&order_row_id_list='+order_row_id_list);
			}
	}
	function degisim()
	{
		sevk_emir = document.getElementById('select_name').value;
		window.open('<cfoutput>#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_sevk_emir&upd_id=#attributes.iid#&is_type=#attributes.is_type#</cfoutput>&sevk_emir='+sevk_emir);
	}
</script>