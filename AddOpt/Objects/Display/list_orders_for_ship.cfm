<!--- reserve durumu, kalan miktarı miktarı, yapılan rezerve miktarı, stok durumu kullanılabilir stok kendi reservesi haric,aşama bilgisi --->
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact ="objects.list_orders_for_ship">
<cfset attributes.is_sale_store = xml_is_sale_store>
<cfinclude template="/v16/objects/query/get_department2.cfm">
<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
	<cfset depo_id = attributes.dept_id>
<cfelseif len(listgetat(session.ep.user_location,1,'-')) and listfind(employee_dept_list_,listgetat(session.ep.user_location,1,'-'))>
	<cfset depo_id = listgetat(session.ep.user_location,1,'-')>
<cfelse>
	<cfset depo_id ="">
</cfif>
<cfparam name="attributes.is_return" default="0">
<cfparam name="attributes.department_id" default="#depo_id#">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.list_type" default="#x_list_type#">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.order_detail" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif attributes.list_type eq 2>
	<cfset attributes.order_list_type = 1>
</cfif>
<cfparam name="attributes.order_list_type" default="0">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">

<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 1><!--- alis  --->
		<cfinclude template="../query/get_order_list_purchase2.cfm">
	<cfelseif isdefined("attributes.is_purchase") and attributes.is_purchase eq 0><!--- satis --->
		<cfinclude template="/v16/objects/query/get_orders_sale.cfm">
	</cfif>
<cfelse>
	<cfset get_order_list.recordcount = 0>
</cfif>

<cfif get_order_list.recordcount>
	<cfset o_list = valuelist(get_order_list.order_id)>
	<cfset o_list = listdeleteduplicates(o_list)>
</cfif>

<cfset url_str="">
<cfif isdefined("attributes.order_id_liste")>
	<cfset url_str = "&order_id_liste=#attributes.order_id_liste#">
</cfif>
<cfif isdefined("attributes.is_from_invoice")>
	<cfset url_str = "&is_from_invoice=#attributes.is_from_invoice#">
</cfif>
<cfif isdefined("attributes.control")>
	<cfset url_str = "&control=#attributes.control#">
</cfif>
<cfif isdefined("attributes.order_date_liste")>
	<cfset url_str = "&order_date_liste=#attributes.order_date_liste#">
</cfif>
<cfif isdefined("attributes.order_system_id_list")>
	<cfset url_str = "&order_system_id_list=#attributes.order_system_id_list#">
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.consumer_id)>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.is_return") and len(attributes.is_return)>
	<cfset url_str = "#url_str#&is_return=#attributes.is_return#">
</cfif>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="" >
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#"> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>  
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32784.Siparişler'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#message#">
<cfform name="list_ship" method="post" action="#request.self#?fuseaction=objects.popup_list_orders_for_ship#url_str#&is_purchase=#attributes.is_purchase#">
	<input type="hidden" name="is_sale_store" id="is_sale_store" value="<cfif isDefined('attributes.is_sale_store') and len(attributes.is_sale_store)><cfoutput>#attributes.is_sale_store#</cfoutput></cfif>" />
	<cf_box_search>		
		<div class="form-group" id="item-keyword">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
			<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#message#">
		</div>
		<div class="form-group" id="item-list_type">
			<select name="list_type" id="list_type">
				<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
				<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
			</select>
		</div>
		<div class="form-group" id="item-sort_type">
			<select name="sort_type" id="sort_type">
				<option value="1"  <cfif attributes.sort_type eq 1>selected</cfif> ><cf_get_lang dictionary_id='40843.Teslim Tarihine Göre Artan'></option>
				<option value="2"  <cfif attributes.sort_type eq 2>selected</cfif> ><cf_get_lang dictionary_id='40844.Teslim Tarihine Göre Azalan'></option>
				<option value="3"  <cfif attributes.sort_type eq 3>selected</cfif> ><cf_get_lang dictionary_id='40845.Sipariş Tarihine Göre Artan'></option>
				<option value="4"  <cfif attributes.sort_type eq 4>selected</cfif> ><cf_get_lang dictionary_id='40846.Sipariş Tarihine Göre Azalan'></option>
			</select>			
		</div>
		<div class="form-group" id="item-is_form_submitted">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<select name="department_id" id="department_id">
				<option value=""><cf_get_lang dictionary_id='33242.Depo Seçiniz'></option>
				<cfoutput query="get_department">
					<option value="#department_id#"<cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
				</cfoutput>
			</select>
		</div>	
		<div class="form-group small">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
		</div>
		<div class="form-group">
			<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 1>
				<cf_wrk_search_button search_function='kontrol()' button_type="4">
			<cfelseif isdefined("attributes.is_purchase") and attributes.is_purchase eq 0>
				<cf_wrk_search_button button_type="4">
			</cfif>
		</div>
					
	</cf_box_search>
	<cf_box_search_detail>
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-product_id">
			<div class="input-group">
				<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name) and len(attributes.product_id)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
				<input type="text" name="product_name" id="product_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_name#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
				<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_ship.product_id&field_name=list_ship.product_name&keyword='+encodeURIComponent(document.list_ship.product_name.value),'list');"></span>
			</div>
		</div>	
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-spect_main_id">
			<div class="input-group">
				<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57647.Spekt'></cfsavecontent>
				<input type="text" name="spect_name" id="spect_name" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.spect_name#</cfoutput>">
				<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="product_control();"></span>
			</div>
		</div>
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-project_id">
			<div class="input-group">
				<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
				<input name="project_head" type="text" id="project_head" placeholder="<cfoutput>#message#</cfoutput>"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');"  value="<cfif len(attributes.project_id)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" autocomplete="off" >
				<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=list_ship.project_id&project_head=list_ship.project_head');"></span>                  
			</div>
		</div>	
		<cfif session.ep.our_company_info.subscription_contract eq 1>
			<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="">		
				<cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='110' fieldId='subscription_id' fieldName='subscription_no' form_name='list_ship'>
			</div>
		</cfif>
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="order_detail">
			<cfif attributes.list_type neq 2></cfif>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
			<input type="text" name="order_detail" id="order_detail" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.order_detail#</cfoutput>">
		</div>
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="start_date">
			<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
				<cfsavecontent variable="message_"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
				<cfinput type="text" name="start_date" maxlength="10" value="#DateFormat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" placeholder="#message_#">
				<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
			</div>
		</div>	
		<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="finish_date">
			<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
					<cfsavecontent variable="message_"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
				<cfinput type="text" name="finish_date" maxlength="10" value="#DateFormat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#" placeholder="#message_#">
				<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
			</div>
		</div>
	</cf_box_search_detail>
</cfform>
<cf_grid_list sort="0">
	<thead>
		<cfset x_col = 15>
		<tr> 
			<cfif attributes.list_type eq 1>
				<th width="30"></th><cfset ++x_col>
			</cfif>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<cfif x_show_order_detail eq 1><th><cf_get_lang dictionary_id='57480.Konu'></th><cfset ++x_col></cfif>
			<cfif x_show_order_date eq 1><th align="center"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th><cfset ++x_col></cfif>
			<cfif x_show_order_price eq 1><th><cf_get_lang dictionary_id='30024.KDVsiz'><cf_get_lang dictionary_id='57673.Tutar'></th><cfset ++x_col></cfif>
			<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<cfif xml_show_project eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th><cfset ++x_col></cfif>
			<cfif x_show_employee eq 1>
				<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 1>
					<th><cf_get_lang dictionary_id='57569.Görevli'></th>
					<cfset ++x_col>
				</cfif>
			</cfif>
			<cfif x_show_priority eq 1><th><cf_get_lang dictionary_id='57485.Öncelik'></th><cfset ++x_col></cfif>
			<cfif x_show_location eq 1><th><cf_get_lang dictionary_id='58763.Depo'></th><cfset ++x_col></cfif>
			<cfif attributes.list_type eq 2>
				<cfif x_show_stock_code eq 1><th><cf_get_lang dictionary_id='57518.Stok Kodu'></th><cfset ++x_col></cfif>
				<cfif x_show_company_product_code eq 1><th><cf_get_lang dictionary_id='44232.Üretici Ürün Kodu'></th><cfset ++x_col></cfif>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>		
				<cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><th><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57789.Özel Kodu'></th></cfif>	
				<cfif isDefined("x_show_spec_info") and x_show_spec_info><th width="55"><cf_get_lang dictionary_id='34299.Spec'></th><cfset ++x_col></cfif>
				<th width="55"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th width="55"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'></th>
				<cfif x_show_reserve eq 1><th width="55"><cf_get_lang dictionary_id='29750.Rezerve'> <cf_get_lang dictionary_id ='30111.Durumu'></th><cfset ++x_col></cfif>
				<th width="55" ><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
				<th width="55"  style="text-align:right;"><cf_get_lang dictionary_id='40235.Sipariş Miktarı'></th>
				<th width="55"  style="text-align:right;"><cf_get_lang dictionary_id='58816.İptal Edilen'></th>
				<th width="55"  style="text-align:right;"><cf_get_lang dictionary_id='60105.İrsaliyeye Çekilen Miktar'></th>
				<th width="55"  style="text-align:right;"><cf_get_lang dictionary_id='60106.Rezerve Edilen Miktar'></th>
				<th width="55"  style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
				<cfif xml_is_second_unit eq 1><th><cf_get_lang dictionary_id='30115.Unit 2'></th><cfset ++x_col></cfif>
				<th>Durum</th>
				<th>&nbsp;</th>
			</cfif>
			<th width="20"><a href="javascript://"><i class="fa fa-bus"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfscript>
			dept_id_list="";
			company_id_list="";
			consumer_id_list="";
			partner_id_list="";
			priority_list="";
			stock_id_list="";
		</cfscript>
		<cfif get_order_list.recordcount>
			<cfif attributes.list_type eq 2>
				<form name="ship_detail_1" action="" method="post">
				<input type="hidden" name="from_order_row" id="from_order_row" value="1">
				<input type="hidden" name="is_purchase" id="is_purchase" value="<cfoutput>#attributes.is_purchase#</cfoutput>">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
				<input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>">
				<input type="hidden" name="dept_id" id="dept_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
				<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
				<input type="hidden" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>">
				<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
				<input type="hidden" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>">
				<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
				<input type="hidden" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>">
				<input type="hidden" name="xml_order_row_deliverdate_copy_to_ship" id="xml_order_row_deliverdate_copy_to_ship" value="<cfoutput>#xml_order_row_deliverdate_copy_to_ship#</cfoutput>">
				<input type="hidden" name="x_send_order_detail" id="x_send_order_detail" value="<cfif x_send_order_detail eq 1><cfoutput>#x_send_order_detail#</cfoutput></cfif>">
			</cfif>
			<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(get_order_list.DELIVER_DEPT) and not listfind(dept_id_list,get_order_list.DELIVER_DEPT)>
					<cfset dept_id_list=listappend(dept_id_list,get_order_list.DELIVER_DEPT)>
				</cfif>
				<cfif len(get_order_list.CONSUMER_ID) and not listfind(consumer_id_list,get_order_list.CONSUMER_ID)>
					<cfset consumer_id_list=listappend(consumer_id_list,get_order_list.CONSUMER_ID)>
				</cfif>
				<cfif len(get_order_list.COMPANY_ID) and not listfind(company_id_list,get_order_list.COMPANY_ID)>
					<cfset company_id_list=listappend(company_id_list,get_order_list.COMPANY_ID)>
				</cfif>
				<cfif len(get_order_list.PARTNER_ID) and not listfind(partner_id_list,get_order_list.PARTNER_ID)>
					<cfset partner_id_list=listappend(partner_id_list,get_order_list.PARTNER_ID)>
				</cfif>
				<cfif len(get_order_list.PRIORITY_ID) and not listfind(priority_list,get_order_list.PRIORITY_ID)>
					<cfset priority_list=listappend(priority_list,get_order_list.PRIORITY_ID)>
				</cfif>
			</cfoutput>
			<cfif len(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
				<cfset company_id_list=listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_detail" datasource="#dsn#">
					SELECT CONSUMER_ID,COMPANY,CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset consumer_id_list=listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(priority_list)>
				<cfset priority_list=listsort(priority_list,"numeric","ASC",",")>
				<cfquery name="get_priority" datasource="#dsn#">
					SELECT PRIORITY_ID,PRIORITY,COLOR FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (#priority_list#) 		
				</cfquery>
				<cfset priority_list=listsort(listdeleteduplicates(valuelist(get_priority.priority_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(partner_id_list)>
				<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
				<cfquery name="partner_detail" datasource="#dsn#">
					SELECT
						CP.PARTNER_ID,
						CP.COMPANY_PARTNER_NAME,
						CP.COMPANY_PARTNER_SURNAME,						
						C.NICKNAME
					FROM 
						COMPANY_PARTNER CP,
						COMPANY C
					WHERE 
						CP.PARTNER_ID IN (#partner_id_list#) AND
						CP.COMPANY_ID=C.COMPANY_ID
					ORDER BY
						CP.PARTNER_ID
				</cfquery>
				<cfset partner_id_list=listsort(listdeleteduplicates(valuelist(partner_detail.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(dept_id_list)>
				<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
				<cfquery name="GET_ALL_DEPARTMENTS" datasource="#DSN#">
					SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#)ORDER BY DEPARTMENT_ID	
				</cfquery>
				<cfset dept_id_list=listsort(listdeleteduplicates(valuelist(GET_ALL_DEPARTMENTS.department_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(stock_id_list)>
				<cfset stock_id_list=listsort(stock_id_list,"numeric")>
				<cfquery name="get_prod_name" datasource="#dsn3#">
					SELECT STOCK_ID, PRODUCT_NAME+PROPERTY AS PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#) ORDER BY STOCK_ID
				</cfquery>
				<cfset stock_id_list=listsort(listdeleteduplicates(valuelist(get_prod_name.stock_id,',')),'numeric','ASC',',')>
			</cfif>
			
			<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onmouseover="this.className='color-row';" onmouseout="this.className='color-white';">
				<cfif attributes.list_type eq 2>
					<cfset attributes.order_id_ = order_id>
					<cfinclude template="/v16/objects/display/list_orders_for_ship_inner.cfm">
				</cfif>
				<cfif attributes.list_type eq 1>
				<td class="text-center">
					<input type="checkbox" name="company_order_" id="company_order_" value="#get_order_list.ORDER_ID#;<cfif len(get_order_list.COMPANY_ID)>#get_order_list.COMPANY_ID#<cfelse>#get_order_list.CONSUMER_ID#</cfif>;<cfif len(get_order_list.DELIVER_DEPT)>#get_order_list.DELIVER_DEPT#<cfelse>0</cfif>" onclick="javascript:if(this.checked){ send_selected_order('#get_order_list.ORDER_ID#;<cfif len(get_order_list.COMPANY_ID)>#get_order_list.COMPANY_ID#<cfelse>#get_order_list.CONSUMER_ID#</cfif>;<cfif len(get_order_list.DELIVER_DEPT)>#get_order_list.DELIVER_DEPT#<cfelse>0</cfif>',1);} else send_selected_order('#get_order_list.ORDER_ID#;<cfif len(get_order_list.COMPANY_ID)>#get_order_list.COMPANY_ID#<cfelse>#get_order_list.CONSUMER_ID#</cfif>;<cfif len(get_order_list.DELIVER_DEPT)>#get_order_list.DELIVER_DEPT#<cfelse>0</cfif>',2);">
				</td>
				</cfif>
				<td>
				<cfif attributes.list_type eq 1>
					<cfset is_from_invoice = isdefined("attributes.is_from_invoice") ? "&is_from_invoice=#attributes.is_from_invoice#" : "">
					<a href="javascript://" class="tableyazi" onclick="gizle_goster(ORDER_ROW_LIST#currentrow#);AjaxPageLoad('#request.self#?fuseaction=objects.ajax_popup_list_order_row_for_ship&order_id_=#ORDER_ID#&is_return=#attributes.is_return#&form_crntrow=#currentrow#&company_id=<cfif len(attributes.company_id)>#attributes.company_id#</cfif>&consumer_id=<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>&department_id=<cfif len(attributes.department_id)>#attributes.department_id#</cfif>&is_purchase=<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>1<cfelse>0</cfif>&x_show_product_code_2=#x_show_product_code_2#&x_show_spec_info=#x_show_spec_info#&x_send_order_detail=#x_send_order_detail#&xml_order_row_deliverdate_copy_to_ship=#xml_order_row_deliverdate_copy_to_ship#<cfif isdefined('attributes.control') and len(attributes.control)>&control=#attributes.control#</cfif>&keyword=#attributes.keyword#&#is_from_invoice#','ORDER_ROW_LIST#currentrow#_',1);">#order_number#</a>
				<cfelse>
					#order_number#
				</cfif>
				</td>
				<cfif x_show_order_detail eq 1><td>#order_head#</td></cfif>
				<cfif x_show_order_date eq 1><td align="center">#DateFormat(order_date,dateformat_style)#</td></cfif>
				<cfif x_show_order_price eq 1>
				<td  style="text-align:right;">
					<cfif attributes.list_type eq 2>#TLFormat(row_nettotal)# #session.ep.money#<cfelse><cfif len(nettotal) and len(taxtotal)>#TLFormat(nettotal-taxtotal)# #session.ep.money#</cfif></cfif>
				</td>
				</cfif>
				<td><cfif len(get_order_list.partner_id)>
						#partner_detail.nickname[listfind(partner_id_list,get_order_list.partner_id,',')]# - #partner_detail.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #partner_detail.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#
					<cfelseif len(get_order_list.company_id)>
						#get_company_detail.nickname[listfind(company_id_list,get_order_list.company_id,',')]#
					<cfelseif len(get_order_list.consumer_id)>
						#get_consumer_detail.company[listfind(consumer_id_list,consumer_id,',')]# - #get_consumer_detail.fullname[listfind(consumer_id_list,consumer_id,',')]#
					</cfif>
				</td>
				<cfif xml_show_project eq 1><td>#project_head#</td></cfif>
				<cfif x_show_employee eq 1>
				<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 1>
					<td>#employee_name# #employee_surname#</td>
				</cfif>
				</cfif>
				<cfif x_show_priority eq 1>
				<td><cfif len(get_order_list.priority_id) and isnumeric(get_order_list.priority_id)>
						<font color="#get_priority.color[listfind(priority_list,get_order_list.priority_id,',')]#">#get_priority.priority[listfind(priority_list,get_order_list.priority_id,',')]#</font>
					</cfif>
				</td>
				</cfif>
				<cfif x_show_location eq 1>
				<td><cfif len(DELIVER_DEPT) and isnumeric(DELIVER_DEPT)>
						#GET_ALL_DEPARTMENTS.DEPARTMENT_HEAD[listfind(dept_id_list,get_order_list.DELIVER_DEPT,",")]#
					</cfif>
				</td>
				</cfif>
				<cfif attributes.list_type eq 2>
					<cfif x_show_stock_code eq 1><td>#STOCK_CODE#</td></cfif>
					<cfif x_show_company_product_code eq 1><td>#product_manufact_code#</td></cfif>
					<td>#PRODUCT_NAME#</td>
					<cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td>#PRODUCT_CODE_2#</td></cfif>
					<cfif isDefined("x_show_spec_info") and x_show_spec_info><td width="55">#SPECT_VAR_NAME#</td></cfif>
					<td width="55">#PRODUCT_NAME2#</td>
					<td width="55" >
						<cfswitch expression = "#ORDER_ROW_CURRENCY#">
							<cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'></cfcase>
							<cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'></cfcase>
							<cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'></cfcase>
							<cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'></cfcase>
							<cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'></cfcase>
							<cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'></cfcase>
							<cfcase value="-2"><cf_get_lang dictionary_id='29745.Tedarik'></cfcase>
							<cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'></cfcase>
						</cfswitch>
					</td>
					<cfif x_show_reserve eq 1>
					<td width="55" >
						<cfswitch expression = "#RESERVE_TYPE#">
							<cfcase value="-4"><cf_get_lang dictionary_id='29753.Rezerve Kapatıldı'></cfcase>
							<cfcase value="-3"><cf_get_lang dictionary_id='29752.Rezerve Degil'></cfcase>
							<cfcase value="-2"><cf_get_lang dictionary_id='29751.Kısmi Rezerve'></cfcase>
							<cfcase value="-1"><cf_get_lang dictionary_id='29750.Rezerve'></cfcase>
						</cfswitch>
					</td>
					</cfif>
					<td width="55"><cfif len(SATIR_TESLIM)>#dateformat(SATIR_TESLIM,dateformat_style)#</cfif></td>
					<td width="55"  style="text-align:right;">#TLFormat(QUANTITY)#</td>
					<td width="55"  style="text-align:right;">#TLFormat(CANCEL_AMOUNT)#</td>
					<td width="55"  nowrap="nowrap" style="text-align:right;"><cfif isdefined('row_dsp_amount_')>#TLFormat(row_dsp_amount_)#</cfif></td>
					<td width="55"  style="text-align:right;">
						<cfif isdefined('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#') and len(evaluate('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#'))>
							<cfif isdefined('non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
								<cfset temp_c=evaluate('non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
							<cfelse>
								<cfset temp_c=evaluate('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')> <!--- kalan toplam reserve miktarı --->
							</cfif>
							<cfif temp_c gte QUANTITY>
								#TLFormat(abs(QUANTITY))#
								<cfset 'non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#' = temp_c-QUANTITY>
							<cfelseif temp_c lt evaluate('add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
								#TLFormat(abs(temp_c))#
								<cfset 'is_full_reserved_#STOCK_ID#_#SPECT_VAR_ID#'=1>
							</cfif>
						</cfif>
					</td>
					<td  nowrap style="text-align:right;">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz!'></cfsavecontent>
					<input type="text" name="order_add_amount_#order_id#_#ORDER_ROW_ID#" id="order_add_amount_#order_id#_#ORDER_ROW_ID#" onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="moneybox" value="<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0>#TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'),4)#<cfelse>#TLFormat(0)#</cfif>" range="0,#QUANTITY#" message=<cfoutput>#message#</cfoutput>>
					</td>
					<cfif xml_is_second_unit eq 1>
						<td width="55" >
							#UNIT2#
						</td>
					</cfif>
					<td><cfif LEFT(WRK_ROW_RELATION_ID,3) eq "PBS">
						<span style="color:red">Satış</span>
					<cfelseif LEFT(WRK_ROW_RELATION_ID,3) eq "WRK">
						<span style="color:blue">Stok</span>
					<cfelse>
					</cfif></td>
					<td class="text-center">				
						<input type="hidden" value="#ORDER_ID#" name="row_order_id" id="row_order_id">
						<input type="hidden" value="#ORDER_ROW_ID#" name="row_order_row_id" id="row_order_row_id">
						<cfif len(COMPANY_ID)>
							<input type="Checkbox" name="company_order_" id="company_order_" value="#order_id#;#ORDER_ROW_ID#;#COMPANY_ID#;<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>0</cfif>" <cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') lte 0>disabled</cfif> >
						<cfelse>
							<input type="Checkbox" name="cons_order_" id="cons_order_" value="#order_id#;#ORDER_ROW_ID#;#consumer_id#;<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>0</cfif>" <cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') lte 0>disabled</cfif> >
						</cfif> 
					</td>
				</cfif>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_order_receive_rate&order_id=#get_order_list.order_id#','list');"><i class="fa fa-bus" border="0" title="<cf_get_lang dictionary_id='32721.Sipariş Karşılama Raporu'>"></i></a></td>
			</tr>
			<cfif attributes.list_type eq 1>
				<tr id="ORDER_ROW_LIST#currentrow#" style="display:none;">
					<td colspan="11"><div id="ORDER_ROW_LIST#currentrow#_"></div></td>
				</tr>
			</cfif>
			</cfoutput> 
			<cfif attributes.list_type eq 2></form></cfif>
		<cfelse>
			<tr>
				<td colspan="<cfoutput>#x_col#</cfoutput>"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>

<cfif get_order_list.recordcount>
	<div class="ui-info-bottom flex-end">
		<cfif attributes.list_type eq 2>
			<div id="ORDER_ROWS_MESSAGE"></div>
		<div><input type="button" onclick="control_ship_amounts();" value="Ekle"></div>
		<cfelse>
			<div id="ORDER_MESSAGE"></div>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='58989.Sipariş Ekle'></cfsavecontent>
				<div><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' insert_alert='' add_function='gonder()'></div>
		</cfif>
	</div>
</cfif>
<cfif isdefined("attributes.order_detail")>
	<cfset url_str = "#url_str#&order_detail=#attributes.order_detail#">
</cfif>
<cfif isdefined("attributes.is_sale_store")>
	<cfset url_str = "#url_str#&is_sale_store=#attributes.is_sale_store#">
</cfif>
<cfif isdefined('attributes.department_id')>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
</cfif>
<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
	<cfset url_str = "#url_str#&subscription_id=#attributes.subscription_id#">
</cfif>
<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id) and isdefined("attributes.spect_name") and len(attributes.spect_name)>
	<cfset url_str = "#url_str#&spect_main_id=#attributes.spect_main_id#&spect_name=#attributes.spect_name#">
</cfif>
<cfset url_str = "#url_str#&list_type=#attributes.list_type#">
<cfset url_str = "#url_str#&sort_type=#attributes.sort_type#">
<cfif attributes.totalrecords gt attributes.maxrows>
<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_orders_for_ship&keyword=#attributes.keyword#&is_purchase=#attributes.is_purchase#&is_form_submitted=1#url_str#">
			
</cfif>
</cf_box>
</div>
<form name="add_order_" method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship#url_str#&is_purchase=#attributes.is_purchase#</cfoutput>">
	<cfoutput>
	<input type="hidden" name="dept_id" id="dept_id" value="#attributes.department_id#">
	<input type="hidden" name="keyword" id="keyword" value="#attributes.keyword#">
	<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_id)>#attributes.product_id#</cfif>">
	<input type="hidden" name="product_name" id="product_name" value="<cfif len(attributes.product_name)>#attributes.product_name#</cfif>">
	<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif len(attributes.spect_main_id)>#attributes.spect_main_id#</cfif>">
	<input type="hidden" name="spect_name" id="spect_name" value="<cfif len(attributes.spect_name)>#attributes.spect_name#</cfif>">	
	<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
	<input type="hidden" name="x_send_order_detail" id="x_send_order_detail" value="<cfif x_send_order_detail eq 1>#x_send_order_detail#</cfif>">
	<input type="hidden" name="x_cost_price_info" id="x_cost_price_info" value="<cfif x_cost_price_info eq 1>#x_cost_price_info#</cfif>">
	<input type="hidden" name="xml_order_row_deliverdate_copy_to_ship" id="xml_order_row_deliverdate_copy_to_ship" value="#xml_order_row_deliverdate_copy_to_ship#">
	<input type="hidden" name="order_system_id_list" id="order_system_id_list" value="<cfif isdefined("attributes.order_system_id_list")>#attributes.order_system_id_list#</cfif>">
	</cfoutput>
	<input type="hidden" name="invoice_date" id="invoice_date" value="">
	<input type="hidden" name="company_order_" id="company_order_" value=""><!--- bu alanlar siparis secildikce dolduruluyor --->
</form>

<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	<!---<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 1>
		if(document.list_ship.department_id.options[document.list_ship.department_id.selectedIndex].value=="")
		{
			alert("<cf_get_lang no='852.Depo Seçiniz'>!");
			return false;
		}
	</cfif>--->
	<!---kapatıyorum zorunlu olmasını 250515 PY  --->
	return true;
}
function product_control()/*Ürün seçmeden spect seçemesin.*/
{
	if(document.list_ship.product_id.value=="" || document.list_ship.product_name.value=="" )
	{
	alert("Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir");
	return false;
	}
	else
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_ship.spect_main_id&field_name=list_ship.spect_name&is_display=1&product_id='+document.list_ship.product_id.value,'list');
}
function gonder()
{
<cfif attributes.list_type eq 1>
	kontrol();
	send_order_info();
</cfif>
}
<cfif attributes.list_type eq 2>
	function control_ship_amounts(form_row_no)
		{
			form_row_no = 1;
			satir_var = 0;
			
			if(eval('document.ship_detail_1.company_order_')!= undefined)
				var checked_item_= eval('document.ship_detail_1.company_order_');
			else if(eval('document.ship_detail_1.cons_order_') != undefined)
				var checked_item_= eval('document.ship_detail_1.cons_order_');
			
			if(checked_item_.length != undefined)
			{
				for(var xx=0; xx < checked_item_.length; xx++)
				{
					if(checked_item_[xx].checked)
					{
						ship_ = eval('document.ship_detail_1.row_order_id[' + xx + '].value');
						ship_row_id_ = eval('document.ship_detail_1.row_order_row_id[' + xx + '].value');
						eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value=filterNum(eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value,4);
						satir_var = 1;
					}
				}
			}
			else if(checked_item_.checked)
			{
				ship_row_id_ = eval('document.ship_detail_1.row_order_row_id.value');
				ship_ = eval('document.ship_detail_1.row_order_id.value');
				eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value=filterNum(eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value,4);
				satir_var = 1;
			}
			if(satir_var==1)
				{
					
				ship_detail_1.action='<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship#url_str#&is_purchase=#attributes.is_purchase#&list_type=#attributes.list_type#</cfoutput>';	
				
					if(ship_detail_1.action.includes("list_type")) {
						ship_detail_1.action='<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship#url_str#&is_purchase=#attributes.is_purchase#</cfoutput>';
					}	
					
				ship_detail_1.submit();							
				}
			else
				{
				alert("<cf_get_lang dictionary_id='30050.Satır Seçmelisiniz'>!");
				return false;
				}
		}
</cfif>

function send_order_info()
{
	add_order_.action = '<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship#url_str#&is_purchase=#attributes.is_purchase#&list_type=#attributes.list_type#</cfoutput>';
	add_order_.submit();
}	
function send_selected_order(order_info,info_type)
{
	if(info_type==1)
	{
		if(add_order_.company_order_.value=='')
			add_order_.company_order_.value = order_info;
		else
			add_order_.company_order_.value = add_order_.company_order_.value+','+order_info;
	}
	else if(info_type==2)
	{
		var old_order_info= add_order_.company_order_.value;
		add_order_.company_order_.value='';
		for (var m=0; m<=list_len(old_order_info); m++)
		{
			if(list_getat(old_order_info,m)!=order_info)
			{
				if(add_order_.company_order_.value=='')
					add_order_.company_order_.value = list_getat(old_order_info,m);
				else
					add_order_.company_order_.value = add_order_.company_order_.value+','+list_getat(old_order_info,m);
			}
		}
	}
}
</script>
