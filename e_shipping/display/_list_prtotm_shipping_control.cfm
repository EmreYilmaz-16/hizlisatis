<cfsetting showdebugoutput="no">
<cfset depo = 110> <!---Dikkat Firmaya Göre Değişir--->
<cfset arama_yapilmali = 0>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.date1" default="#DateFormat(now(),'DD/MM/YYYY')#">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfset son_row = 0>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2
		AND D.DEPARTMENT_STATUS = 1 
		<cfif isdefined("x_bring_to_response") and x_bring_to_response eq 1>
			AND B.BRANCH_ID IN
				(SELECT 
					BRANCH_ID 
				 FROM  
					EMPLOYEE_POSITION_BRANCHES 
				 WHERE 
					POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
<cfoutput query="GET_DEPARTMENT">
	<cfset 'DEPARTMENT_HEAD_#DEPARTMENT_ID#' = DEPARTMENT_HEAD>
</cfoutput>
<cfset cmp = "">
<cfquery name="get_money" datasource="#dsn#"><!--- Onceki Donemlerin Para Birimleri De Gerektiginden Dsnden Cekiliyor FBS --->
	SELECT MONEY FROM SETUP_MONEY GROUP BY MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'total_grosstotal_doviz_#money#' = 0>
</cfoutput>
<cfset branch_dep_list=valuelist(get_department.department_id,',')>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_total_purchase_e" datasource="#DSN2#">
        SELECT     
            COLLECT_ID, 
            DEPARTMENT_IN,
            SHIP_METHOD,
            DEPARTMENT_OUT,
            SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
            ISNULL(
            (
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
           	FROM         
            	#dsn3_alias#.PRTOTM_SHIPPING_PACKAGE_LIST_COLLECT_STORE
          	WHERE     
            	COLLECT_ID = TBL2.COLLECT_ID
           	), 0) AS CONTROL_AMOUNT,
            SUM(CONTROL_AMOUNT1) AS CONTROL_AMOUNT1,
            (
            SELECT     
            	SHIP_METHOD
			FROM         
            	#dsn_alias#.SHIP_METHOD
			WHERE     
            	SHIP_METHOD_ID = TBL2.SHIP_METHOD
            ) as SHIP_METHOD_A
        FROM         
            (
            SELECT     
                DISPATCH_SHIP_ID, 
                PAKET_ID, 
                COLLECT_ID, 
                DEPARTMENT_IN,
                SHIP_METHOD,
                DEPARTMENT_OUT,
                PAKET_SAYISI,
               	ISNULL((
				SELECT     
                	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
              	FROM          
               		#dsn3_alias#.PRTOTM_SHIPPING_PACKAGE_LIST
               	WHERE      
                 	TYPE = 2 AND 
              	STOCK_ID = TBL.PAKET_ID AND 
                 	SHIPPING_ID = TBL.DISPATCH_SHIP_ID
            	),0) AS CONTROL_AMOUNT1
            FROM          
                (
                    SELECT     
                        EC.DISPATCH_SHIP_ID, 
                        EPS.PAKET_ID, 
                        EC.COLLECT_ID, 
                        EC.DEPARTMENT_IN,
                        EC.SHIP_METHOD,
                        EC.DEPARTMENT_OUT,
                        SUM(EPS.PAKET_SAYISI * SIR.AMOUNT) AS PAKET_SAYISI
                    FROM          
                        PRTOTM_SHIP_INTERNAL_COLLECT AS EC INNER JOIN
                        SHIP_INTERNAL_ROW AS SIR ON EC.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                        #dsn3_alias#.PRTOTM_PAKET_SAYISI AS EPS ON SIR.STOCK_ID = EPS.MODUL_ID
                    WHERE      
                        EC.DEPARTMENT_OUT = #depo#
                        <cfif len(attributes.ship_method_id)>
                        	AND EC.SHIP_METHOD = #attributes.ship_method_id#
                        </cfif>
                        <cfif len(attributes.branch_id)>
                        	AND EC.DEPARTMENT_IN IN
                            				(
                                            SELECT     
                                            	DEPARTMENT_ID
											FROM         
                                            	#dsn_alias#.DEPARTMENT
											WHERE     
                                            	DEPARTMENT_STATUS = 1 AND 
                                                BRANCH_ID = #attributes.branch_id#
                                            )
                            
                            
                            
                        </cfif>
                        <cfif len(attributes.date1)>
                        	AND SUBSTRING(EC.COLLECT_ID,5,2)+'/'+SUBSTRING(EC.COLLECT_ID,3,2)+'/20'+left(EC.COLLECT_ID,2) = '#attributes.date1#' 
                        </cfif> 
                    GROUP BY 
                        EC.DISPATCH_SHIP_ID, 
                        EPS.PAKET_ID, 
                        EC.COLLECT_ID,
                        EC.DEPARTMENT_IN,
                        EC.SHIP_METHOD,
                        EC.DEPARTMENT_OUT
                ) AS TBL
            ) AS TBL2
        GROUP BY 
            COLLECT_ID,
            DEPARTMENT_IN,
            SHIP_METHOD,
            DEPARTMENT_OUT
      	ORDER BY
        	DEPARTMENT_OUT,
        	DEPARTMENT_IN,
            SHIP_METHOD
 	</cfquery>
<cfelse>
	<cfset get_total_purchase_e.recordcount = 0>
    <cfset arama_yapilmali = 1>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_total_purchase_e.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_total_purchase.recordcount>
</cfif>

<cfquery name="get_branch_" datasource="#dsn#">
	SELECT 
		BRANCH_NAME,BRANCH_ID
	FROM
		BRANCH
	WHERE
		COMPANY_ID = #session.ep.company_id#
		AND BRANCH_STATUS = 1
        and BRANCH_ID IN
				(SELECT 
					BRANCH_ID 
				 FROM  
					EMPLOYEE_POSITION_BRANCHES 
				 WHERE 
					POSITION_CODE = #session.ep.position_code#
                    )
</cfquery>
<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="Sevk Talebi PDA Kontrol">
    <cf_big_list_search_area>
        <cf_object_main_table>
        	<input type="hidden" name="form_submitted" id="form_submitted" value="">
            <cf_object_table column_width_list="50,180">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yöntemi'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                <cf_object_td type="text"><cf_get_lang_main no='1703.Sevk Yöntemi'></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:160px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=order_form.ship_method_name&field_id=order_form.ship_method_id','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>				                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,100">
                <cfsavecontent variable="header_">Şube</cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                	<cf_object_td type="text">Şube</cf_object_td>
                    <cf_object_td>
                        <select name="branch_id" id="branch_id" style="width:100px;">
                            <option value="">Tüm Şubeler</option>
                            <cfoutput query="get_branch_">
                                <option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_">Termin</cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                	<cf_object_td type="text">Termin</cf_object_td>
                    <cf_object_td>
                       <cfsavecontent variable="message1"><cf_get_lang_main no='370.Tarih Degerini Kontrol Ediniz !'></cfsavecontent>
                        <cfinput value="#attributes.date1#" type="text" maxlength="10" name="date1" style="width:65px; vertical-align:top" required="yes" message="#message1#" validate="eurodate">
                        <cf_wrk_date_image date_field="date1">                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90">
                <cf_object_tr id="">
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        <cf_wrk_search_button search_function='input_control()'>
                        <!---<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>--->
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>        
        </cf_object_main_table>
    </cf_big_list_search_area>
</cfform>
<table class="big_list">
		<thead>
			<tr>
				<th width="25" style="text-align:center;">S.No</th>
				<th>Çıkış Depo</th>
				<th>Giriş Depo</th>
              	<th width="150">Sevk Yöntemi</th>
               	<th width="85" style="text-align:right;">Toplam Paket Sayısı</th>
				<th width="85" style="text-align:right;">Çıkış Depo Paket Kontrol</th>
				<th width="85" style="text-align:right;">Giriş Depo Paket Kontrol</th>
			</tr>
		</thead>
		<tbody>
        	<cfif get_total_purchase_e.recordcount>
            	<cfoutput query="get_total_purchase_e">
                	 <tr>
                     	<td>#currentrow#</td>
                      	<td>#Evaluate('DEPARTMENT_HEAD_#DEPARTMENT_OUT#')#</td>
                      	<td>#Evaluate('DEPARTMENT_HEAD_#DEPARTMENT_IN#')#</td>
                      	<td>#SHIP_METHOD_A#</td>
                     	<td style="text-align:right;">
                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_PRTOTM_shipping_term_control_store&collect_id=#COLLECT_ID#','page');" class="tableyazi" title="Detay Göster">
                         		#PAKET_SAYISI#
                          	</a>
                        </td>
                    	<td style="text-align:right;">#CONTROL_AMOUNT1#</td>
                      	<td style="text-align:right;">#CONTROL_AMOUNT#</td>
                   	</tr>
            	</cfoutput>
            <cfelse>
            	<tr>
                    <td colspan="7"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
            </cfif>
		</tbody>
</table>
<script language="javascript">
	function input_control()
		{
			if(document.all.date1.value =='')
			{
				alert('Tarih Değeri Giriniz!!!.');
				return false
			}
			else
			{
				return true
			}
		}
</script>