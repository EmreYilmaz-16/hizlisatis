<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="sales">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.select_year" default="#session.ep.period_year#">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.sales_departments" default="">
<cfparam name="attributes.sort_type" default="5">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.t_point" default="0">
<cfparam name="attributes.SHIP_METHOD_ID" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.form_varmi" default="1">
<cfset ay = month(now())>
<cfparam name="attributes.select_month" default="#ay#">
<cfset son_gun = daysinmonth('01/#attributes.select_month#/#session.ep.period_year#')>
<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif isdefined("attributes.form_varmi")>
	<cfset t_puan = 0>
	<cfset t_tutar = 0>
   	<cfset t_tax_tutar = 0>
	<cfloop from="1" to="#son_gun#" index="i">
        <cfquery name="GET_SHIPPING" datasource="#dsn3#"><!---Sevk Planları ve Sevk Talepleri Listeleniyor--->
            SELECT
            	PUAN AS SATIR_PUAN,
                QUANTITY,
                NETTOTAL AS SATIR_NET_TOTAL,
                (NETTOTAL+(NETTOTAL*TAX/100)) AS SATIR_TAX_TOTAL,
                REPORT_DAY,
                REPORT_MONTH
            FROM
                (
                <cfif attributes.listing_type neq 3>
                    <cfif not len(attributes.branch_id)>
                        SELECT
                        	ISNULL(
                            (
                            SELECT 
                                TOP (1) PROPERTY1
                            FROM
                                PRODUCT_INFO_PLUS
                            WHERE
                                PRODUCT_ID = ORDER_ROW.PRODUCT_ID     
                            )
                            ,0) AS PUAN,     
                            ESR.DELIVERY_DATE, 
                            ESR.DEPARTMENT_ID, 
                            ESR.COMPANY_ID, 
                            ESR.CONSUMER_ID, 
                            ESR.OUT_DATE, 
                            ESR.IS_TYPE, 
                            ESR.LOCATION_ID, 
                            ESR.SHIP_METHOD_TYPE, 
                            ORDER_ROW.STOCK_ID, 
                            ORDER_ROW.PRODUCT_ID, 
                            ISNULL(ORDER_ROW.QUANTITY,0) AS QUANTITY, 
                            ORDER_ROW.ORDER_ROW_CURRENCY, 
                            ORDER_ROW.ORDER_ROW_ID, 
                            ORDER_ROW.ORDER_ID,
                            ISNULL(ORDER_ROW.NETTOTAL,0) AS NETTOTAL,
                            ISNULL(ORDER_ROW.TAX,0) AS TAX,
                            SC.CITY_NAME,
                            SCO.COUNTY_NAME,
                            DAY(ESR.OUT_DATE) AS REPORT_DAY,
                            MONTH(ESR.OUT_DATE) AS REPORT_MONTH
                        FROM         
                            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                            #dsn_alias#.SHIP_METHOD AS SM ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID INNER JOIN
                            #dsn_alias#.EMPLOYEES AS E ON ESR.DELIVER_EMP = E.EMPLOYEE_ID INNER JOIN
                            #dsn_alias#.DEPARTMENT AS D ON ESR.DEPARTMENT_ID = D.DEPARTMENT_ID INNER JOIN
                            PRTOTM_SHIP_RESULT_ROW ON ESR.SHIP_RESULT_ID = PRTOTM_SHIP_RESULT_ROW.SHIP_RESULT_ID INNER JOIN
                            ORDER_ROW ON PRTOTM_SHIP_RESULT_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID INNER JOIN
                            ORDERS AS O ON ORDER_ROW.ORDER_ID = O.ORDER_ID LEFT OUTER JOIN
                            #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID LEFT OUTER JOIN
                            #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID
                        WHERE     
                            ESR.IS_TYPE = 1 
                          	AND DAY(ESR.OUT_DATE)= #i#
                            AND MONTH(ESR.OUT_DATE)= #attributes.select_month#
                            AND YEAR(ESR.OUT_DATE)= #session.ep.period_year#
                            <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                                AND ESR.DEPARTMENT_ID = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                                AND ESR.LOCATION_ID = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                            </cfif>
                            <cfif attributes.listing_type eq 1>      
                                UNION ALL
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif attributes.listing_type neq 2>
                        SELECT 
                        	ISNULL(
                            (
                            SELECT 
                                TOP (1) PROPERTY1
                            FROM
                                PRODUCT_INFO_PLUS
                            WHERE
                                PRODUCT_ID = ORR.PRODUCT_ID     
                            )
                            ,0) AS PUAN,
                            SI.SHIP_DATE AS DELIVERY_DATE,
                            SI.DEPARTMENT_IN AS DEPARTMENT_ID,
                            O.COMPANY_ID, 
                            O.CONSUMER_ID, 
                            SI.DELIVER_DATE AS OUT_DATE,
                            2 AS IS_TYPE, 
                            SI.LOCATION_IN AS LOCATION_ID,
                            SI.SHIP_METHOD AS SHIP_METHOD_TYPE,
                            ORR.STOCK_ID, 
                            ORR.PRODUCT_ID, 
                            ISNULL(ORR.QUANTITY,2) AS QUANTITY, 
                            ORR.ORDER_ROW_CURRENCY, 
                            ORR.ORDER_ROW_ID, 
                            ORR.ORDER_ID,
                            ISNULL(ORR.NETTOTAL,2) AS NETTOTAL,
                            ISNULL(ORR.TAX,2) AS TAX, 
                            SC.CITY_NAME,
                            sco.COUNTY_NAME,
                            DAY(SI.DELIVER_DATE) AS REPORT_DAY,
                            MONTH(SI.DELIVER_DATE) AS REPORT_MONTH
                        FROM         
                            #dsn_alias#.SHIP_METHOD AS SM RIGHT OUTER JOIN
                            #dsn_alias#.SETUP_COUNTY AS sco RIGHT OUTER JOIN
                            ORDER_ROW AS ORR INNER JOIN
                            ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID INNER JOIN
                            #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON ORR.ORDER_ROW_ID = SIR.ROW_ORDER_ID INNER JOIN
                            #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON sco.COUNTY_ID = O.COUNTY_ID LEFT OUTER JOIN
                            #dsn_alias#.EMPLOYEES AS E ON SI.RECORD_EMP = E.EMPLOYEE_ID LEFT OUTER JOIN
                            #dsn_alias#.DEPARTMENT AS D ON SI.DEPARTMENT_IN = D.DEPARTMENT_ID ON SM.SHIP_METHOD_ID = SI.SHIP_METHOD LEFT OUTER JOIN
                            #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID
                        WHERE
                            DAY(SI.DELIVER_DATE)= #i#
                            AND MONTH(SI.DELIVER_DATE)= #attributes.select_month#
                            AND YEAR(SI.DELIVER_DATE) = #session.ep.period_year#
                            <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                                AND SI.DEPARTMENT_OUT = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                                AND SI.LOCATION_OUT = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                            </cfif>
                            <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                                AND SI.DEPARTMENT_IN IN
                                                        (
                                                        SELECT     
                                                            DEPARTMENT_ID
                                                        FROM         
                                                            #dsn_alias#.DEPARTMENT
                                                        WHERE     
                                                            BRANCH_ID = #attributes.branch_id#
                                                        )
                            </cfif>
                    </cfif>       
                )TBL
            WHERE
                1=1
                    <cfif isdefined('attributes.product_id') and len(attributes.product_id)>
                        AND PRODUCT_ID = #attributes.product_id#
                    </cfif>
                    <cfif isdefined('attributes.prod_cat') and len(attributes.prod_cat)>
                        AND PRODUCT_ID IN
                                        (
                                        SELECT     
                                            PRODUCT_ID
                                        FROM         
                                            STOCKS
                                        WHERE     
                                            PRODUCT_CODE LIKE '#attributes.prod_cat#%'
                                        )
                    </cfif>
                    <cfif isdefined('attributes.city_name') and len(attributes.city_name)>
                        AND CITY_NAME ='#attributes.city_name#' 
                    </cfif>
                    <cfif isdefined('attributes.SHIP_METHOD_ID') and len(attributes.SHIP_METHOD_ID)>
                        AND SHIP_METHOD_TYPE ='#attributes.SHIP_METHOD_ID#' 
                    </cfif>
                    <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                        AND COMPANY_ID =#attributes.company_id#
                    </cfif>
                    <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                        AND CONSUMER_ID =#attributes.consumer_id# 
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
        </cfquery>
        <cfset 't_puan_#i#' = 0>
		<cfset 't_tutar_#i#' = 0>
        <cfset 't_tax_tutar_#i#' = 0>
		<cfoutput query="GET_SHIPPING">
        	<cfif isnumeric(SATIR_PUAN) and len(SATIR_PUAN)>
        		<cfset 't_puan_#i#' = Evaluate('t_puan_#i#' )+(SATIR_PUAN*quantity)>
            </cfif>
            <cfset 't_tutar_#i#' = Evaluate('t_tutar_#i#')+SATIR_NET_TOTAL>
            <cfset 't_tax_tutar_#i#' = Evaluate('t_tax_tutar_#i#')+SATIR_TAX_TOTAL>
        </cfoutput>
   	</cfloop>     
    <cfset arama_yapilmali = 0>
    <cfset attributes.totalrecords = GET_SHIPPING.recordcount>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_order_list.recordcount = 0>
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
	ORDER BY
		D.DEPARTMENT_HEAD,
		SL.COMMENT
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_kur" datasource="#dsn#">
	SELECT (RATE2/RATE1) RATE,MONEY,RECORD_DATE FROM MONEY_HISTORY ORDER BY MONEY_HISTORY_ID DESC
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD ORDER BY SHIP_METHOD
</cfquery>
<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="Sevkiyat İşlemleri">
    <cf_big_list_search_area>
        <cf_object_main_table>
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                <cf_object_tr id="form_ul_keyword" title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                    <cf_object_td>
                        <cfinput type="text" name="keyword" maxlength="50" style="width:100px;" value="#attributes.keyword#">                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,165">
                <cfsavecontent variable="header_"><cf_get_lang_main no='247.Satis Bölgesi'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                        <select name="zone_id" id="zone_id" style="width:160px;height:20px">
						<option value=""><cf_get_lang_main no='247.Satis Bölgesi'></option>
						<cfoutput query="sz">
							<option value="#SZ_HIERARCHY#" <cfif attributes.zone_id eq SZ_HIERARCHY>selected</cfif>>#sz_name#</option>
						</cfoutput>
					</select>                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="115">
              	<cfsavecontent variable="header_">Şube</cfsavecontent>
               	<cf_object_tr id="form_ul_branch_id" title="#header_#">
                 	<cf_object_td>
                    	<select name="branch_id" id="branch_id" style="width:110px;height:20px">
                        	<option value=""><cf_get_lang_main no='41.Sube'></option>
                         	<cfoutput query="get_branch">
                           		<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                   		</select>        
              		</cf_object_td>
           		</cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="135">
                <cfsavecontent variable="header_">Liste Tipi</cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="listing_type" id="sort_type" style="width:130px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>>Tümü</option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>>Sevk Planları</option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>>Sevk Talepler</option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="135">
                <cfsavecontent variable="header_">Ay</cfsavecontent>
                <cf_object_tr id="form_ul_month" title="#header_#">
                    <cf_object_td>
                    	<select name="select_month" style="width:130px;height:20px">
                        	<option value="1" <cfif attributes.select_month eq '1'>selected</cfif>>Ocak</option>
                            <option value="2" <cfif attributes.select_month eq '2'>selected</cfif>>Şubat</option>
                            <option value="3" <cfif attributes.select_month eq '3'>selected</cfif>>Mart</option>
                            <option value="4" <cfif attributes.select_month eq '4'>selected</cfif>>Nisan</option>
                            <option value="5" <cfif attributes.select_month eq '5'>selected</cfif>>Mayıs</option>
                            <option value="6" <cfif attributes.select_month eq '6'>selected</cfif>>Haziran</option>
                            <option value="7" <cfif attributes.select_month eq '7'>selected</cfif>>Temmuz</option>
                            <option value="8" <cfif attributes.select_month eq '8'>selected</cfif>>Ağustos</option>
                            <option value="9" <cfif attributes.select_month eq '9'>selected</cfif>>Eylül</option>
                            <option value="10" <cfif attributes.select_month eq '10'>selected</cfif>>Ekim</option>
                            <option value="11" <cfif attributes.select_month eq '11'>selected</cfif>>Kasım</option>
                            <option value="12" <cfif attributes.select_month eq '12'>selected</cfif>>Aralık</option>
                        </select>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>    
            
            <cf_object_table column_width_list="90">
                <cf_object_tr id="">
                    <cf_object_td>
                        <cf_wrk_search_button search_function='input_control()'>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>        
        </cf_object_main_table>
    </cf_big_list_search_area>
   
</cf_big_list_search>
</cfform>
<table class="big_list">
	<thead>
            <tr height="35">
                <th rowspan="2" style="width:100px"><cf_get_lang_main no='74.Kategori'></th>
                <th colspan="<cfoutput>#son_gun#</cfoutput>" style="text-align:center"><cf_get_lang_main no ='1260.Aylar'></th>
                <th rowspan="2" style="width:110px"><cf_get_lang_main no='80.Toplam'></th>
          	</tr>
            <tr height="10">
            	<cfloop from="1" to="#son_gun#" index="i">
                	<th style="text-align:center;width:60px"><cfoutput>#i#</cfoutput></th>
            	</cfloop>
            </tr>
        </thead>
	<tbody>
    	<cfif isdefined("attributes.form_varmi")>
        	<cfoutput>
            <tr>
        		<td><strong>Puan</strong></td>
            	<cfloop from="1" to="#son_gun#" index="i">
        			<td style="text-align:right">#Tlformat(Evaluate('t_puan_#i#'),2)#</td>
                    <cfset t_puan = t_puan + Evaluate('t_puan_#i#')>
				</cfloop>
                <td style="text-align:right"><strong>#Tlformat(t_puan,2)#</strong></td>            
            </tr>
            <tr>
            	<td><strong>Tutar(*1000)</strong></td>
            	<cfloop from="1" to="#son_gun#" index="i">
        			<td style="text-align:right">#Tlformat(Evaluate('t_tutar_#i#')/1000,2)#</td>
                    <cfset t_tutar = t_tutar + Evaluate('t_tutar_#i#')>
				</cfloop>
                <td style="text-align:right"><strong>#Tlformat(t_tutar/1000,2)#</strong></td>            
            </tr>
            <tr>
            	<td><strong>Tutar+KDV(*1000)</strong></td>
            	<cfloop from="1" to="#son_gun#" index="i">
        			<td style="text-align:right">#Tlformat(Evaluate('t_tax_tutar_#i#')/1000,2)#</td>
                    <cfset t_tax_tutar = t_tax_tutar + Evaluate('t_tax_tutar_#i#')>
				</cfloop>
                <td style="text-align:right"><strong>#Tlformat(t_tax_tutar/1000,2)#</strong></td>            
            </tr>
        	</cfoutput>    
            <tfoot>
                <tr>
                	<cfset son_col = son_gun+2>
                    <td style="text-align:left;" colspan="<cfoutput>#son_col#</cfoutput>">
                        <cfset color_count = 0>
                        <cfset color_list = "gray,purple,fuchsia,green,lime,olive,yellow,gold,orange,blue,navy,teal,aqua">
                        <!--- Aylık --->
                        <cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg" chartwidth="1200" chartheight="300" >
                            <cfchartseries type="bar" itemcolumn="Sevk Planı Tutarı (KDV Dahil) * 1000" seriescolor="blue"> 
                                <cfloop from="1" to="#son_gun#" index="i">
                                    <cfif isdefined('t_tax_tutar_#i#')>
                                        <cfchartdata item="#i#" value="#Evaluate('t_tax_tutar_#i#')/1000#">
                                    <cfelse>
                                        <cfchartdata item="#i#" value="0">
                                    </cfif>
                                </cfloop>
                            </cfchartseries>
                        </cfchart>
                        <!--- //Aylık --->
                    </td>     
                </tr>
			</tfoot>
        <cfelse>
        	<tr>
           		<td colspan="14"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
         	</tr>
       	</cfif>	
	</tbody>
</table>
<script language="javascript">
	function input_control()
		{
			if(document.all.branch_id.value !='' && document.all.listing_type.value ==2)
			{
				alert('Liste Tipi Sevk Planları İle Şubeyi Birlikte Seçemezsiniz!!!.');
				return false
			}
			else
			{
				return true
			}
		}
</script>		