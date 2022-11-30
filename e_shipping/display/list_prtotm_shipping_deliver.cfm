<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="sales">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.totalrecords" default="0">
<!---<cfparam name="attributes.form_varmi" default="1">--->
<cfparam name="attributes.listing_type" default="2">

<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_locations" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID
  	FROM 
    	EMPLOYEE_POSITION_BRANCHES 
  	WHERE  
    	POSITION_CODE = #session.ep.POSITION_CODE# AND 
        LOCATION_CODE IS NOT NULL AND
        BRANCH_ID IN
        			(
        				SELECT        
                        	BRANCH_ID
						FROM            
                        	BRANCH
						WHERE        
                        	BRANCH_STATUS = 1 AND 
                            COMPANY_ID = #session.ep.COMPANY_ID#
        			)
</cfquery>
<cfif not get_locations.recordcount>
	<script type="text/javascript">
     	alert("Bu Şirket İçin Tanımlanmış Depo ve Lokasyon Bulunamamıştır!");
     	history.go(-1);
  	</script>
 	<cfabort>
<cfelse>
	<cfset condition_departments_list = ValueList(get_locations.DEPARTMENT_ID)>
    <cfset condition_departments_list = ListDeleteDuplicates(condition_departments_list,',')>
</cfif>
<cfquery name="get_department_name" datasource="#DSN#">
	SELECT 
		SL.LOCATION_ID,
		SL.COMMENT,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID
	FROM
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE 
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#)
        AND D.DEPARTMENT_ID IN (#condition_departments_list#)
	ORDER BY
		D.DEPARTMENT_HEAD,
		SL.COMMENT
</cfquery>

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
	</cfif>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
    <cfquery name="GET_SHIPPING" datasource="#dsn3#">
    	SELECT      
        	*
            ,
            CASE
           		WHEN TBL.COMPANY_ID IS NOT NULL THEN
                   (
                    SELECT     
                      	NICKNAME
					FROM         
                    	#dsn_alias#.COMPANY
					WHERE     
                   		COMPANY_ID = TBL.COMPANY_ID
                  	)
          		WHEN TBL.CONSUMER_ID IS NOT NULL THEN      
                   	(	
                  	SELECT     
                     	CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
					FROM         
                      	#dsn_alias#.CONSUMER
					WHERE     
                		CONSUMER_ID = TBL.CONSUMER_ID
               		)
            	WHEN TBL.EMPLOYEE_ID IS NOT NULL THEN
                  	(
                   	SELECT     
                    	EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
					FROM         
                  		#dsn_alias#.EMPLOYEES
					WHERE     
                     	EMPLOYEE_ID = TBL.EMPLOYEE_ID
                 	)
      		END
             	AS UNVAN,
          	(
            SELECT     
            	PRODUCT_NAME
			FROM         
            	STOCKS
			WHERE     
            	PRODUCT_ID = TBL.PRODUCT_ID
            ) AS PRODUCT_NAME
		FROM         
        	(
                SELECT   
                    1 AS IS_TYPE,   
                    O.ORDER_ID, 
                    ORR.ORDER_ROW_ID, 
                    O.DELIVERDATE, 
                    O.IS_INSTALMENT,
                    O.ORDER_NUMBER, 
                    O.ORDER_DATE, 
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID, 
                    ORR.STOCK_ID, 
                    ORR.PRODUCT_ID, 
                    ORR.QUANTITY, 
                    ORR.NETTOTAL, 
                    ORR.RESERVE_TYPE,
                    ORR.ORDER_ROW_CURRENCY, 
                    ORR.DELIVER_AMOUNT
                FROM          
                    PRTOTM_SHIP_RESULT_ROW AS ESRR RIGHT OUTER JOIN
                    ORDERS AS O INNER JOIN
                    ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
                WHERE      
                    O.ORDER_STATUS = 1 AND 
                    O.IS_INSTALMENT IS NULL AND 
                    O.RESERVED = 1 AND 
                    (
                    ORR.ORDER_ROW_CURRENCY = - 1 OR
                    ORR.ORDER_ROW_CURRENCY = - 2 OR
                    ORR.ORDER_ROW_CURRENCY = - 4 OR
                    ORR.ORDER_ROW_CURRENCY = - 5 OR
                    ORR.ORDER_ROW_CURRENCY = - 6 OR
                    ORR.ORDER_ROW_CURRENCY = - 7
                    ) AND 
                    ESRR.SHIP_RESULT_ROW_ID IS NULL AND 
                    O.PURCHASE_SALES = 1 AND 
                    O.ORDER_ZONE = 0
                    <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                      	AND O.DELIVER_DEPT_ID = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                    	AND O.LOCATION_ID = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
               		</cfif>
                    UNION ALL
                SELECT     
                    2 AS IS_TYPE, 
                    O.ORDER_ID, 
                    ORR.ORDER_ROW_ID, 
                    O.DELIVERDATE,
                    O.IS_INSTALMENT,
                    O.ORDER_NUMBER, 
                    O.ORDER_DATE, 
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID, 
                    ORR.STOCK_ID, 
                    ORR.PRODUCT_ID, 
                    ORR.QUANTITY, 
                    ORR.NETTOTAL, 
                    ORR.RESERVE_TYPE,
                    ORR.ORDER_ROW_CURRENCY, 
                    ORR.DELIVER_AMOUNT
                FROM         
                    ORDERS AS O INNER JOIN
                    ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID LEFT OUTER JOIN
                    PRTOTM_ORDER_TESHIR AS EOT ON ORR.ORDER_ROW_ID = EOT.ORDER_ROW_ID LEFT OUTER JOIN
                    (
                    SELECT     
                        ROW_ORDER_ID
                    FROM          
                        #dsn2_alias#.SHIP_INTERNAL_ROW
                    WHERE      
                        ROW_ORDER_ID IS NOT NULL
                    ) AS SUB_TBL1 ON ORR.ORDER_ROW_ID = SUB_TBL1.ROW_ORDER_ID
                WHERE     
                    O.ORDER_STATUS = 1 AND 
                    O.RESERVED = 1 AND 
                    (
                    ORR.ORDER_ROW_CURRENCY = - 1 OR
                    ORR.ORDER_ROW_CURRENCY = - 2 OR
                    ORR.ORDER_ROW_CURRENCY = - 4 OR
                    ORR.ORDER_ROW_CURRENCY = - 5 OR
                    ORR.ORDER_ROW_CURRENCY = - 6 OR
                    ORR.ORDER_ROW_CURRENCY = - 7
                    ) AND 
                    O.PURCHASE_SALES = 1 AND 
                    O.ORDER_ZONE = 0 AND 
                    SUB_TBL1.ROW_ORDER_ID IS NULL AND 
                    EOT.ORDER_ROW_ID IS NULL
                    <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                      	AND O.DELIVER_DEPT_ID = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                    	AND O.LOCATION_ID = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
               		</cfif>
          	) AS TBL
		WHERE
        	1=1
            <cfif attributes.listing_type eq 2>
            	AND IS_TYPE =1
            <cfelseif attributes.listing_type eq 3>
            	AND IS_TYPE =2
            </cfif>
            <cfif len(attributes.zone_id)>  
                	AND (
                    	COMPANY_ID IN 	
                    				(
                                        SELECT     
                                        	COMPANY_ID
										FROM         
                                        	#dsn_alias#.COMPANY
										WHERE     
                                        	SALES_COUNTY IN
                          									(
                                                            	SELECT     
                                                                	SZ_ID
                            									FROM          
                                                                	#dsn_alias#.SALES_ZONES
                            									WHERE      
                                                                	SZ_HIERARCHY LIKE '#attributes.zone_id#%'
                                                           	) 
                                   	)
                       	OR
                   		CONSUMER_ID IN 	
                    				(
                                        SELECT     
                                        	CONSUMER_ID
										FROM         
                                        	#dsn_alias#.CONSUMER
										WHERE     
                                        	SALES_COUNTY IN
                          									(
                                                            	SELECT     
                                                                	SZ_ID
                            									FROM          
                                                                	#dsn_alias#.SALES_ZONES
                            									WHERE      
                                                                	SZ_HIERARCHY LIKE '#attributes.zone_id#%'
                                                           	) 
                                   	)
                                    
                  		)  
              	</cfif>
     	ORDER BY
        	ORDER_NUMBER
    </cfquery>
    <cfset attributes.totalrecords = GET_SHIPPING.recordcount>
<cfelse>
	<cfset arama_yapilmali = 1>
</cfif>
<cfset t_tutar = 0>
<cfset s_tutar = 0>

<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="<cf_get_lang_main no='1445.Sevkiyat İşlemleri'>">
    <cf_big_list_search_area>
        <cf_object_main_table>
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='247.Satis Bölgesi'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                        <select name="zone_id" id="zone_id" style="width:160px; height:20px">
						<option value=""><cf_get_lang_main no='247.Satis Bölgesi'></option>
						<cfoutput query="sz">
							<option value="#SZ_HIERARCHY#" <cfif attributes.zone_id eq SZ_HIERARCHY>selected</cfif>>#sz_name#</option>
						</cfoutput>
					</select>                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="95">
                <cfsavecontent variable="header_"><cf_get_lang_main no='3284.Liste Tipi'></cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="listing_type" id="listing_type" style="width:90px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>>Sevk Planları</option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>>Sevk Talebi</option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="50,135">
                <cfsavecontent variable="header_"><cf_get_lang_main no='2234.Lokasyon'></cfsavecontent>
                <cf_object_tr id="form_ul_sales_departments" title="#header_#">
                    <cf_object_td>
                        <select name="sales_departments" id="sales_departments" style="width:130px;height:20px">
                            <option value=""><cf_get_lang_main no='2234.Lokasyon'></option>
                            <cfoutput query="get_department_name">
                                <option value="#department_id#-#location_id#" <cfif isdefined("attributes.sales_departments") and attributes.sales_departments is '#department_id#-#location_id#'>selected</cfif>>#department_head#-#comment#</option>
                            </cfoutput>
                        </select>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90">
                <cf_object_tr id="">
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        <cf_wrk_search_button>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>        
        </cf_object_main_table>
    </cf_big_list_search_area>
</cfform>
	<table class="big_list">
		<thead>
			<tr>
				<th class="header_icn_txt" style="text-align:center"; width="30px"><cf_get_lang_main no='1165.Sira'></th>
				<th style="text-align:center"; width="60px"><cf_get_lang_main no='799.Sipariş No'></th>
				<th style="text-align:center"; width="80px"><cf_get_lang_main no='1704.Sipariş Tarihi'></th>
				<th style="text-align:center"; width="80px"><cf_get_lang_main no='3093.Termin Tarihi'></th>
				<th style="text-align:center"; width="180px"><cf_get_lang_main no='45.Müşteri'></th>
				<th style="text-align:center";><cf_get_lang_main no='245.Ürün'></th>
				<th style="text-align:center"; width="80px"><cf_get_lang_main no='223.Miktar'></th>   
				<th style="text-align:center"; width="100px"><cf_get_lang_main no='261.tutar'></th>
				<th style="text-align:center"; width="70px"><cf_get_lang_main no='70.Asama'></th>
				<th style="text-align:center"; width="80px"><cf_get_lang_main no='1953.Rezerve'></th> 
				<th style="text-align:center"; width="80px"><cf_get_lang_main no='3297.Teslim'> <cf_get_lang_main no='223.Miktar'></th>
			</tr>
		</thead>
		<tbody>
        <cfif isdefined("attributes.form_varmi")>
        	<cfif GET_SHIPPING.recordcount>
				<cfoutput query="GET_SHIPPING">
                    <cfset t_tutar = t_tutar + NETTOTAL>
                </cfoutput>
            	<cfoutput query="GET_SHIPPING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                	<tr>
                    	<td style="text-align:center">#currentrow#</td>
                        <td style="text-align:center">
                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#','longpage');" class="tableyazi">
								#ORDER_NUMBER#
							</a>
                        </td>
                        <td style="text-align:center">#DateFormat(ORDER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center">#DateFormat(DELIVERDATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:left">
                        	<cfif len(COMPANY_ID)>
                           		<a href="javascript://"  class="tableyazi" onclick"window.open('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#')">
                                	#UNVAN#
                                </a>
                           	<cfelseif len(CONSUMER_ID)>
                          		<a href="javascript://"  class="tableyazi" onclick="window.open('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#')">
                                	#UNVAN#
                                </a>
                        	</cfif>
                        </td>
                        <td style="text-align:left">
                        	<a href="javascript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#');">
                           		#PRODUCT_NAME#
                        	</a>
                        </td>
                        <td style="text-align:right">#AmountFormat(QUANTITY)#</td>
                        <td style="text-align:right">#TlFormat(NETTOTAL)#</td>
                        <td style="text-align:center">
                        	<cfif order_row_currency eq -8><cf_get_lang_main no ='1952.Fazla Teslimat'>
                           	<cfelseif order_row_currency eq -7><cf_get_lang_main no ='1951.Eksik Teslimat'>
                        	<cfelseif order_row_currency eq -6><cf_get_lang_main no='1349.Sevk'>
                          	<cfelseif order_row_currency eq -5><cf_get_lang_main no ='44.Üretim'>
                           	<cfelseif order_row_currency eq -4><cf_get_lang_main no ='1950.Kismi Üretim'>
                       		<cfelseif order_row_currency eq -3><cf_get_lang_main no ='1949.Kapatildi'>
                          	<cfelseif order_row_currency eq -2><cf_get_lang_main no ='1948.Tedarik'>
                          	<cfelseif order_row_currency eq -1><cf_get_lang_main no='1305.Açık'>
                          	<cfelseif order_row_currency eq -9><cf_get_lang_main no ='1094.İptal'>
                           	<cfelseif order_row_currency eq -10><cf_get_lang_main no='1211.Kapatıldı (Manuel)'>
                         	</cfif>	
                        </td>
                        <td style="text-align:center">
                        	<cfif RESERVE_TYPE eq -1><cf_get_lang_main no='1953.Rezerve'>
                            <cfelseif RESERVE_TYPE eq -2><cf_get_lang_main no='1954.Kısmi Rezerve'>
                            <cfelseif RESERVE_TYPE eq -3><font color="red"><strong><cf_get_lang_main no='1955.Rezerve Değil'></strong></font>
                            <cfelseif RESERVE_TYPE eq -4><font color="red"><strong><cf_get_lang_main no='1956.Rezerve Kapatıldı'></strong></font>
                            </cfif>
                        </td>
                        <td style="text-align:right">#AmountFormat(DELIVER_AMOUNT)#</td>
                    </tr>
                    <cfset son = currentrow>
                    <cfset s_tutar = s_tutar + NETTOTAL>
                </cfoutput>
                <cfif son lt attributes.totalrecords>
                	<cfoutput>
                    <tfoot>
                        <tr>
                            <td style="text-align:left" colspan="7"><strong><cfoutput>#getLang('ehesap',961)#</cfoutput></strong></td>
                            <td style="text-align:right"><strong>#Tlformat(s_tutar)#</strong></td>
                            <td style="text-align:left" colspan="3"></td>
                        </tr>
                    </tfoot>
                    </cfoutput>
                <cfelse>
                	<cfoutput>
                	<tfoot>
                        <tr>
                            <td style="text-align:left" colspan="7"><strong><cfoutput>#getLang('main',268)#</cfoutput></strong></td>
                            <td style="text-align:right"><strong>#Tlformat(t_tutar)#</strong></td>
                            <td style="text-align:left" colspan="3"></td>
                        </tr>
                    </tfoot>
                    </cfoutput>
                </cfif>
            <cfelse>
            	<tr>
                    <td colspan="15"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
            </cfif>
       	</cfif>
		</tbody>
	</table>
<cfset url_str = 'sales.list_PRTOTM_shipping'>
<cfif isdefined("attributes.totalrecords") and len(attributes.totalrecords)>
	<cfset url_str = url_str & "&totalrecords=#attributes.totalrecords#">
</cfif>
<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
	<cfset url_str = url_str & "&zone_id=#attributes.zone_id#">
</cfif>
<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction#&#url_str#&form_varmi=1">

