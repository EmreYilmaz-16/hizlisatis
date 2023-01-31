<cfsetting showdebugoutput="yes">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.order_employee" default="#get_emp_info(session.ep.userid,0,0)# ">
<cfparam name="attributes.order_employee_id" default="#session.ep.userid#">
<cfparam name="attributes.listing_type" default="2">
<cfparam name="attributes.sort_type" default="3">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.report_type_id" default="3">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.t_point" default="0">
<cfparam name="attributes.SHIP_METHOD_ID" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.totalrecords" default="0">

<cfinclude template="eshiping_queries.cfm">

<cf_box title="Sevkiyat İşlemleri">
    <cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <input name="form_varmi" id="form_varmi" value="1" type="hidden">
        <cf_box_search>
            <div class="form-group">
                <label>Filtre</label>
                <cfinput type="text" name="keyword" maxlength="50"  value="#attributes.keyword#">    
            </div>
            <div class="form-group">
                <select name="report_type_id" id="report_type_id" style="width:120px;height:20px">
                    <option value="" <cfif attributes.report_type_id eq ''>selected</cfif>>Tümü</option>
                    <option value="1" <cfif attributes.report_type_id eq '1'>selected</cfif>>Açık Sevkler</option>
                    <option value="2" <cfif attributes.report_type_id eq '2'>selected</cfif>>Kapalı Sevkler</option>
                    <option value="3" <cfif attributes.report_type_id eq '3'>selected</cfif>>Hazır Sevkler</option>
                    <option value="4" <cfif attributes.report_type_id eq '4'>selected</cfif>>Kısmi Hazır Sevkler</option>
                </select>                   
            </div>
            <div class="form-group">
                <label>Satış Bölgesi</label>
                <select name="zone_id" id="zone_id" style="width:100px;height:20px">
                    <option value=""><cf_get_lang_main no='247.Satis Bölgesi'></option>
                    <cfoutput query="sz">
                        <option value="#SZ_HIERARCHY#" <cfif attributes.zone_id eq SZ_HIERARCHY>selected</cfif>>#sz_name#</option>
                    </cfoutput>
                </select>  
            </div>
            <div class="form-group">
                <label>Sıralama</label>
                <select name="sort_type" id="sort_type" style="width:160px;height:20px">
                    <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>>Teslim Tarihine Göre Artan</option>
                    <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Teslim Tarihine Göre Azalan</option>
                    <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Belge Numarasına Göre Artan</option>
                    <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Belge Numarasına Göre Azalan</option>
                    <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Şirket Adına Göre Artan</option>
                </select> 
            </div>
        </cf_box_search>
    </cfform>
</cf_box>


<cfabort>


<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="#getLang('main',1445)#" collapsed="0">
    <cf_big_list_search_area>
        <cf_object_main_table>
           
            <cf_object_table column_width_list="50,150">

                <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                <cf_object_tr id="form_ul_keyword" title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                    <cf_object_td>
                                        
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='296.Tümü'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                         
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='247.Satis Bölgesi'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                      
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
           
            <cf_object_table column_width_list="165">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1512.Sıralama'></cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                          
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="95">
                <cfsavecontent variable="header_"><cf_get_lang_main no='3284.Liste Tipi'></cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="listing_type" id="listing_type" style="width:90px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>>Tümü</option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>>Sevk Planları</option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>>Sevk Talepleri</option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="90">
                <cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>
                <cf_object_tr id="form_ul_start_date" title="#header_#">
                    <cf_object_td>
                        <cfif session.ep.our_company_info.unconditional_list>
                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                        <cfelse>
                            <cfsavecontent variable="message"><cf_get_lang_main no='2325.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
                            <cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                        </cfif>
                        <cf_wrk_date_image date_field="start_date">                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90">
                <cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>
                <cf_object_tr id="form_ul_finish_date" title="#header_#">
                    <cf_object_td>
                        <cfif session.ep.our_company_info.unconditional_list>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                        <cfelse>
                            <cfsavecontent variable="message"><cf_get_lang_main no='2326.Bitiş Tarihini Kontrol Ediniz'></cfsavecontent>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                        </cfif>
                        <cf_wrk_date_image date_field="finish_date">                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>    
            
            <cf_object_table column_width_list="170">
                <cf_object_tr id="">
                    <cf_object_td>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=eshipping.popup_list_prtotm_shipping_graph</cfoutput>','longpage');" class="tableyazi">
                        	<img src="../../../images/graph.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='3522.Sevkiyat Perspektif'>" />
                      	</a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_list_ezgi_shipping_deliver</cfoutput>','longpage');" class="tableyazi">
                        	<img src="../../../images/target_customer.gif" align="absmiddle" border="0" title="<cf_get_lang_main no='3523.Sevk Planı Açılacak Siparişler'>" />
                      	</a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_list_ezgi_shipping_control</cfoutput>','wide');" class="tableyazi">
                        	<img src="../../../images/pos_credit.gif" align="absmiddle" border="0" title="<cfoutput>#getLang('stock',348)# #getLang('stock',181)#</cfoutput>" />
                      	</a>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        <input type="submit">
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>        
        </cf_object_main_table>
    </cf_big_list_search_area>
    <cf_big_list_search_detail_area collapsed="0">
        <cf_object_main_table>
            <cf_object_table column_width_list="100,140">
                <cfsavecontent variable="header_"><cfoutput>#getLang('report',1380)#</cfoutput></cfsavecontent>
                <cf_object_tr id="form_ul_order_employee" title="#header_#">
                    <cf_object_td type="text" td_style="text-align:right;"><cfoutput>#getLang('report',1380)#</cfoutput></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee_id#</cfoutput></cfif>">
                        <input name="order_employee" type="text" id="order_employee" style="width:115px;" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id)><cfoutput>#attributes.order_employee#</cfoutput></cfif>" autocomplete="off">	
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=order_form.order_employee_id&field_name=order_form.order_employee&is_form_submitted=1&select_list=1','list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>		   
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90,140">
                <cfsavecontent variable="header_"><cf_get_lang_main no='107.Cari Hesap'></cfsavecontent>
                <cf_object_tr id="form_ul_member_name" title="#header_#">
                    <cf_object_td  td_style="text-align:right;" type="text"><cf_get_lang_main no='107.Cari Hesap'></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                        <input name="member_name" type="text" id="member_name" style="width:115px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                        <cfset str_linke_ait="&field_consumer=order_form.consumer_id&field_comp_id=order_form.company_id&field_member_name=order_form.member_name&field_type=order_form.member_type">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif fusebox.circuit eq "store">&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.order_form.member_name.value),'list');">
                            <img src="/images/plus_thin.gif" style="vertical-align:bottom">
                        </a>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,145">
                <cfsavecontent variable="header_"><cf_get_lang_main no='245.Ürün'></cfsavecontent>
                <cf_object_tr id="form_ul_product_name" title="#header_#">
                    <cf_object_td td_style="text-align:right;" type="text"><cf_get_lang_main no='245.Ürün'></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                        <input name="product_name" type="text" id="product_name" style="width:120px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=order_form.product_id&field_name=order_form.product_name&keyword='+encodeURIComponent(document.order_form.product_name.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,145">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1604.rn Kategorileri'></cfsavecontent>
                <cf_object_tr id="form_ul_prod_cat" title="#header_#">
                    <cf_object_td>
                        <select name="prod_cat" id="prod_cat" style="width:140px;height:20px">
                            <option value=""><cf_get_lang_main no='1604.rn Kategorileri'></option>
                            <cfoutput query="GET_PRODUCT_CATS">
                            	<cfif listlen(hierarchy,".") gte 4>
                                <option value="#hierarchy#"<cfif (attributes.prod_cat eq hierarchy) and len(attributes.prod_cat) eq len(hierarchy)> selected</cfif>>#product_cat#</option>
                                </cfif>
                            </cfoutput>
                        </select>                       
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
             <cf_object_table column_width_list="75">
              	<cfsavecontent variable="header_"><cf_get_lang_main no='41.Şube'></cfsavecontent>
               	<cf_object_tr id="form_ul_branch_id" title="#header_#">
                 	<cf_object_td>
                    	<select name="branch_id" id="branch_id" style="width:70px;height:20px">
                        	<option value=""><cf_get_lang_main no='41.Sube'></option>
                         	<cfoutput query="get_branch">
                           		<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
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
            <cf_object_table column_width_list="105">
                <cfsavecontent variable="header_"><cf_get_lang_main no='559.Şehir'></cfsavecontent>
                <cf_object_tr id="form_city_name" title="#header_#">
                    <cf_object_td>
                        <select name="city_name" id="city_name" style="width:100px;height:20px">
                            <option value=""><cf_get_lang_main no='559.Şehir'></option>
                            <cfoutput query="get_city">
                                <option value="#city_name#" <cfif isdefined("attributes.city_name") and attributes.city_name is '#city_name#'>selected</cfif>>#city_name#</option>
                            </cfoutput>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>   
         	<cf_object_table column_width_list="105">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yöntemi'></cfsavecontent>
                <cf_object_tr id="form_ship_method" title="#header_#">
                    <cf_object_td>
                        <select name="SHIP_METHOD_ID" id="SHIP_METHOD_ID" style="width:100px;height:20px">
                            <option value=""><cf_get_lang_main no='1703.Sevk Yöntemi'></option>
                            <cfoutput query="GET_SHIP_METHOD">
                                <option value="#SHIP_METHOD_ID#" <cfif isdefined("attributes.SHIP_METHOD_ID") and attributes.SHIP_METHOD_ID eq SHIP_METHOD_ID>selected</cfif>>#SHIP_METHOD#</option>
                            </cfoutput>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
        </cf_object_main_table>                               
    </cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
	<table class="big_list">
		<thead>
			<tr height="15">
				<th rowspan="2" style="width:30px;text-align:center" class="header_icn_txt"><cf_get_lang_main no='1165.Sira'></th>
				<th rowspan="2" style="width:55px;text-align:center"><cf_get_lang_main no='75.no'></th>
				<th rowspan="2" style="width:60px;text-align:center"><cf_get_lang_main no='330.tarih'></th>
				<th rowspan="2" style="text-align:center"><cf_get_lang_main no='162.sirket'></th>
                <cfif ListFind(session.ep.user_level,25)>
                	<th rowspan="2" style="width:80px;text-align:center"><cf_get_lang_main no='1203.üye bakiyesi'></th>
                </cfif>
				<th rowspan="2" style="width:100px;text-align:center"><cf_get_lang_main no='487.Kaydeden'></th>
				<th rowspan="2" style="width:100px;text-align:center"><cf_get_lang_main no='1703.Sevk Yöntemi'></th>
                <th colspan="<cfif attributes.e_shipping_type eq 1>5<cfelse>4</cfif>" style="width:100px;text-align:center"><cfoutput>#getLang('main',1447)# #getLang('account',134)#</cfoutput></th>
				<th rowspan="2" style="width:100px;text-align:center"><cfoutput>#getLang('prod',253)#</cfoutput></th>
                <!---<th rowspan="2" style="width:50px;text-align:center">S.Puan</th>--->
                <th rowspan="2" style="width:90px;text-align:center"><cf_get_lang_main no='559.Şehir'></th> 
				<th rowspan="2" style="width:180px;text-align:center"><cf_get_lang_main no='217.Açıklama'></th>
				<!-- sil -->
				<th rowspan="2" style="width:20px" class="header_icn_none" nowrap="nowrap">
                	
                	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=79&action_id=#lnk_str#</cfoutput>','wide');"><img src="/images/print_plus.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>">
               		</a>
                </th>
                <th rowspan="2" style="width:20px;text-align:center"><input type="checkbox" alt="<cf_get_lang_main no='559.Şehir'>" onClick="grupla(-1);"></th>
				<!-- sil -->


			</tr>
            <tr height="10">
                <th style="width:20px;text-align:center">SVK</th>
                <cfif attributes.e_shipping_type eq 1>
                <th style="width:20px;text-align:center">HZR</th>
                </cfif>
                <th style="width:20px;text-align:center">KNT</th>
                <th style="width:20px;text-align:center">İRS</th>
                <th style="width:20px;text-align:center">FTR</th>

            </tr>
		</thead>
		<tbody>
        	<cfset t_point =#attributes.t_point#>
        	<cfif isdefined("attributes.form_varmi") and GET_SHIPPING.recordcount>
            	<cfif hata_kontrol.recordcount or cari_kontrol.recordcount> <!---Hatalı İşlemler Varsa Listeleniyor--->
					<cfoutput query="GET_SHIPPING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    	<tr>
                    		<td>#currentrow#</td>
                            <td style="text-align:center">
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.popup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','page');" class="tableyazi" title="<cf_get_lang_main no='3528.Sevk Fişine Git'>">
	                                #DELIVER_PAPER_NO#
                                </a>
							</td>
                            <td style="text-align:center">#DateFormat(OUT_DATE,'dd/mm/yyyy')#</td>
                            <td>
                            	<cfif len(company_id)>
                                	#get_par_info(COMPANY_ID,1,1,0)#
                                <cfelseif len(consumer_id)>
									#get_cons_info(CONSUMER_ID,0,0)#
                                <cfelseif len(employee_id)>
									#get_emp_info(EMPLOYEE_ID,0,0)# 
								</cfif>
                            </td>
                            <td>
                            	<cfif tip eq 2>
                                	<cfif len(comp_id)>
                                        #get_par_info(COMP_ID,1,1,0)#
                                    <cfelseif len(cons_id)>
                                        #get_cons_info(CONS_ID,0,0)#
                                    </cfif>
                                </cfif>
                            </td>
                            <cfif ListFind(session.ep.user_level,25)>
                            	<td style="text-align:right"></td>
                            </cfif>
                            <td>#SHIP_METHOD#<br>
                                <cfquery name="getPm" datasource="#dsn#">
                                        SELECT SP.PAYMETHOD FROM workcube_metosan.COMPANY_CREDIT AS CC 
                                        INNER JOIN workcube_metosan.SETUP_PAYMETHOD AS SP ON CC.PAYMETHOD_ID=SP.PAYMETHOD_ID
                                        WHERE CC.COMPANY_ID=#COMP_ID#
                                </cfquery>
                                #getPm.PAYMETHOD#
                            </td>
                            <td align="center" colspan="5">
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.detail_order&order_id=#order_id#','wide');" class="tableyazi" title="Satış Siparişine Git">
                                    #ORDER_NUMBER#
                              	</a>
                                <a onclick="windowopen('/index.cfm?fuseaction=eshipping.emptypopup_add_prtotm_shipping&order_id=#order_id#','page')">Plan</a>
                            </td>
                            <td style="text-align:center">#CITY_NAME#<br />#COUNTY_NAME#</td>
                            <td colspan="4"><font color="red">
                            	<strong><cf_get_lang_main no='129.Hata'> #tip# : </strong>
                            	<cfif tip eq 1>
                                	<cf_get_lang_main no='3529.Birleştirme İşleminden Sonra Teslim Yeri veya Sevk Yöntemi Değiştirilen Sipariş Hatası'></font>
                          		<cfelseif tip eq 2>
                            		<cf_get_lang_main no='3530.Sevk Planlama İşleminden Sonra Cari Hesap Değiştirilen Sipariş Hatası'>
                            	</cfif>
                            </td>
                    </cfoutput>
                <cfelse>
					<cfoutput query="GET_SHIPPING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif IS_TYPE eq 1>	
                            <cfquery name="GET_PUAN" datasource="#DSN3#"> <!---Satış Puanları Toplanıyor--->
                                SELECT
                                	ORR.ORDER_ID,
                                    ORR.STOCK_ID, 
                                    ORR.PRODUCT_ID, 
                                    ORR.QUANTITY,
                                    ORR.ORDER_ID FIS_ID,
                                    ORR.ORDER_ROW_ID FIS_ROW_ID,
                                    ISNULL(PIP.PROPERTY1, 0) AS PUAN
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
                                    PRODUCT_INFO_PLUS AS PIP ON ORR.PRODUCT_ID = PIP.PRODUCT_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
                            </cfquery>
                        <cfelse>
                            <cfquery name="GET_PUAN" datasource="#DSN2#">
                                SELECT     
                                    ISNULL(PIP.PROPERTY1, 0) AS PUAN, 
                                    SIR.AMOUNT AS QUANTITY, 
                                    SIR.PRODUCT_ID, 
                                    SIR.STOCK_ID, 
                                    SI.DISPATCH_SHIP_ID, 
                                    SIR.SHIP_ROW_ID, 
                                    ORR.ORDER_ID AS FIS_ID, 
                                    ORR.ORDER_ID,
                                    ORR.ORDER_ROW_ID AS FIS_ROW_ID
                                FROM
                                    SHIP_INTERNAL AS SI INNER JOIN
                                    SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                                    #dsn3_alias#.ORDER_ROW AS ORR ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
                                    #dsn3_alias#.PRODUCT_INFO_PLUS AS PIP ON SIR.PRODUCT_ID = PIP.PRODUCT_ID
                                WHERE     
                                    SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                            </cfquery>
                        </cfif>
                        <cfset row_point = 0>
                        <cfquery name="get_order_id_list" dbtype="query">
                            SELECT
                                FIS_ID
                            FROM
                                GET_PUAN
                            GROUP BY
                                FIS_ID
                        </cfquery>
                        <cfset order_id_list = Valuelist(get_order_id_list.FIS_ID)>
                        <cfset order_row_id_list = Valuelist(GET_PUAN.FIS_ROW_ID)>
                        <cfloop query="GET_PUAN">
                            <cfif len(GET_PUAN.puan) and isnumeric(GET_PUAN.puan)>
                                <cfset row_point = row_point + GET_PUAN.puan*GET_PUAN.QUANTITY>
                                <cfset t_point =t_point+GET_PUAN.puan*GET_PUAN.QUANTITY>
                            </cfif>
                        </cfloop>
                        <cfif listlen(order_row_id_list)>
                            <cfset last_year = session.ep.period_year -1>
                            <cfquery name="get_invoice_durum" datasource="#dsn3#">
                            		SELECT        
                                	SUM(ORR.QUANTITY) - SUM(TBLB.AMOUNT) AS KALAN
								FROM            
                                	ORDER_ROW AS ORR LEFT OUTER JOIN
                             		(
                                    	SELECT        
                                        	WRK_ROW_RELATION_ID, 
                                            SUM(AMOUNT) AS AMOUNT
                               			FROM            
                                        	(
                                            	SELECT        
                                            		AMOUNT, 
                                                    WRK_ROW_RELATION_ID
                                           		FROM            
                                                	#dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW
                                                    LEFT JOIN  #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID=INVOICE_ROW.INVOICE_ID WHERE I.PURCHASE_SALES=1
                                            	UNION ALL
                                             	SELECT        
                                                	IR.AMOUNT, 
                                                    IR.WRK_ROW_RELATION_ID
                                             	FROM            
                                                	#dsn#_#session.ep.period_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                                                 	#dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID
                                                     LEFT JOIN #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE AS ı ON I.INVOICE_ID = IR.INVOICE_ID WHERE I.PURCHASE_SALES=1
                                              	<cfif get_period_id.recordcount>
                                                	UNION ALL
                                                    SELECT        
                                                        AMOUNT, 
                                                        WRK_ROW_RELATION_ID
                                                    FROM            
                                                        #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW
                                                        LEFT JOIN  #dsn#_#last_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID=INVOICE_ROW.INVOICE_ID WHERE I.PURCHASE_SALES=1
                                                    UNION ALL
                                                    SELECT        
                                                        IR.AMOUNT, 
                                                        IR.WRK_ROW_RELATION_ID
                                                    FROM            
                                                        #dsn#_#last_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                                                        #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID
                                                        LEFT JOIN #dsn#_#last_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID = IR.INVOICE_ID WHERE I.PURCHASE_SALES=1
                                                </cfif>
                                          	) AS TBLA
                               			GROUP BY 
                                         	WRK_ROW_RELATION_ID
                               		) AS TBLB ON ORR.WRK_ROW_ID = TBLB.WRK_ROW_RELATION_ID
								WHERE        
                                	ORR.ORDER_ROW_ID IN (#order_row_id_list#)
                            </cfquery>
                       	<cfelse>
                        	<cfset get_invoice_durum.recordcount =0>
                     	</cfif>
                            <tr>
                                <td>#currentrow#</td>
                                <td style="text-align:center">
                                    <cfif IS_TYPE eq 1>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','list');" class="tableyazi" title="<cf_get_lang_main no='3528.Sevk Fişine Git'>">
                                        #DELIVER_PAPER_NO#
                                        </a>
                                    <cfelse>
                                        <strong>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.add_dispatch_internaldemand&event=upd&ship_id=#DELIVER_PAPER_NO#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3531.Sevk Talebine Git'>">
                                                #DELIVER_PAPER_NO#
                                            </a>
                                        </strong>
                                        <br>
                                        <cfset fuse_type = 'sales'>
                                        <cfif IS_INSTALMENT eq 1>
                                       	 	<cfset page_type = 'list_order_instalment&event=upd'>
                                        <cfelse>
                                        	<cfset page_type = 'list_order&event=upd'>
                                        </cfif>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#order_id_list#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3532.Satış Siparişine Git'>">
                                        #SHIP_FIS_NO#
                                        </a>
                                    </cfif>        
                                </td>
                                <td style="text-align:center">#DateFormat(OUT_DATE,'dd/mm/yyyy')#</td>
                                <td>
                                    <cfif IS_TYPE eq 1>
                                        #UNVAN#
                                    <cfelse>
                                        <strong>        
                                        #DEPARTMENT_HEAD#<br>
                                        </strong>
                                        (#UNVAN#)
                                    </cfif>
                                </td>
                                <cfif ListFind(session.ep.user_level,25)>
                                    <td style="text-align:right">
                                    	<cfif IS_TYPE eq 1>
                                        	<cfset bak.rc =0>
                                        	<cfif len(company_id)>
                                            	<cfquery name="get_bakiye" datasource="#dsn2#">
                                                	SELECT        
                                                    	BAKIYE3, 
                                                        OTHER_MONEY
													FROM      
                                                    	COMPANY_REMAINDER_MONEY
													WHERE        
                                                    	COMPANY_ID = #company_id#
                                                </cfquery>
                                            <cfelseif len(consumer_id)>
                                            	<cfquery name="get_bakiye" datasource="#dsn2#">
                                                	SELECT        
                                                    	BAKIYE3, 
                                                        OTHER_MONEY
													FROM      
                                                    	CONSUMER_REMAINDER_MONEY
													WHERE        
                                                    	CONSUMER_ID = #consumer_id#
                                                </cfquery>
                                            </cfif>
                                            <cfset bak.rc=get_bakiye.recordCount>
                                            <cfif bak.rc>
                                            	<cfloop query="get_bakiye">
                                                <font style="color:<cfif bakiye3 lte 0>blue<cfelse>red</cfif>">
                                                	#TlFormat(BAKIYE3,2)# #OTHER_MONEY# 
                                               	</font><cfif bak.rc gt get_bakiye.currentrow><br/></cfif>
                                                </cfloop>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                                <td>#get_emp_info(DELIVER_EMP,0,0)#</td>
                                <td>#SHIP_METHOD#
                                    <br>
                                <cfquery name="getPm" datasource="#dsn#">
                                        SELECT SP.PAYMETHOD FROM workcube_metosan.COMPANY_CREDIT AS CC 
                                        INNER JOIN workcube_metosan.SETUP_PAYMETHOD AS SP ON CC.PAYMETHOD_ID=SP.PAYMETHOD_ID
                                        WHERE CC.COMPANY_ID=#company_id#
                                </cfquery>
                                <b>Ö.Y:(#getPm.PAYMETHOD#)</b>
                                </td>
                                <cfif listlen(order_row_id_list)>
                                    <cfquery name="get_sevk_durum" datasource="#dsn3#"> <!---Rezerve edilen üretim planları veya satınalma siparişlerinin depoya girişleri kontrol ediliyor--->
                                        SELECT     
                                            SUM(SEVK_DURUM) AS SEVK_DURUM
                                        FROM         
                                            (
                                            SELECT     
                                                SEVK_DURUM
                                            FROM          
                                                (
                                                SELECT     
                                                    CASE 
                                                        WHEN ORDER_ROW_CURRENCY = - 6 THEN 4 
                                                        WHEN ORDER_ROW_CURRENCY = - 9 THEN 1 
                                                        WHEN ORDER_ROW_CURRENCY = - 8 THEN 1 
                                                        WHEN ORDER_ROW_CURRENCY = - 3 THEN 1 
                                                        WHEN ORDER_ROW_CURRENCY = - 10 THEN 1 
                                                        ELSE 2 
                                                    END AS SEVK_DURUM
                                                FROM          
                                                    ORDER_ROW
                                                WHERE      
                                                    ORDER_ROW_ID IN (#order_row_id_list#) 
                                                ) AS TBL1
                                            GROUP BY 
                                                SEVK_DURUM
                                            ) AS TBL2
                                    </cfquery>
                                <cfelse>
                                    <cfset get_sevk_durum.sevk_durum = 4>
                                </cfif>
                                <td style="text-align:center"> <!---Sevk Indicator--->
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_ezgi_shipping_sevk&iid=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3533.Sevk Emri Ver'>">
                                        <cfif  get_sevk_durum.sevk_durum eq 2>
                                            <img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='1305.Açık'>" />
                                        <cfelseif  get_sevk_durum.sevk_durum eq 1>
                                            <img src="../../../images/red_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='3272.Kapalı'>" />
                                        <cfelseif  get_sevk_durum.sevk_durum eq 6>
                                            <img src="../../../images/green_glob.gif" border="0"title="<cf_get_lang_main no='3534.Kısmi Sevk'>" />
                                        <cfelseif  get_sevk_durum.sevk_durum eq 4>
                                            <img src="../../../images/blue_glob.gif" border="0"title="<cf_get_lang_main no='3535.Tüm Ürünler Hazır'>" />
                                        <cfelseif  get_sevk_durum.sevk_durum eq 5>
                                            <img src="../../../images/black_glob.gif" border="0"title="<cf_get_lang_main no='3536.Düzeltilmesi Gereken Sevk Talebi'>" />
                                        </cfif>
                                    </a>
                                </td>

                                <cfif attributes.e_shipping_type eq 1>
									<cfif IS_TYPE eq 1>    
                                        <cfquery name="AMBAR_CONTROL" datasource="#DSN3#">
                                            SELECT     
                                                ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                                ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                            FROM         
                                                (
                                                SELECT     
                                                    PAKET_SAYISI AS PAKETSAYISI, 
                                                    PAKET_ID AS STOCK_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME,
                                                    (
                                                    SELECT 
                                                        SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                                                    FROM
                                                        ( 
                                                        SELECT        
                                                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                        FROM            
                                                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                        WHERE        
                                                            SF.FIS_TYPE = 113 AND 
                                                            SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                            SFR.STOCK_ID = TBL.PAKET_ID
                                                        <cfif get_period_id.recordcount>
                                                            UNION ALL
                                                            SELECT        
                                                                SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                            FROM            
                                                                #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                                #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                            WHERE        
                                                                SF.FIS_TYPE = 113 AND 
                                                                SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                                SFR.STOCK_ID = TBL.PAKET_ID
                                                        </cfif>
                                                        ) AS TBL_5
                                                    ) AS CONTROL_AMOUNT
                                                FROM         
                                                    (
                                                    SELECT
                                                        SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                                                        PAKET_ID, 
                                                        BARCOD, 
                                                        STOCK_CODE, 
                                                        PRODUCT_NAME, 
                                                        PRODUCT_TREE_AMOUNT, 
                                                        SHIP_RESULT_ID
                                                    FROM
                                                        (     
                                                        SELECT     
                                                            CASE 
                                                                WHEN 
                                                                    S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                                THEN 
                                                                    S.PRODUCT_TREE_AMOUNT 
                                                                ELSE 
                                                                    SUM(ORR.QUANTITY * EPS.PAKET_SAYISI)
                                                            END 
                                                                AS PAKET_SAYISI, 
                                                            EPS.PAKET_ID, 
                                                            S.BARCOD, 
                                                            S.STOCK_CODE, 
                                                            S.PRODUCT_NAME, 
                                                            S.PRODUCT_TREE_AMOUNT, 
                                                            ESR.SHIP_RESULT_ID,
                                                            ESRR.ORDER_ROW_ID
                                                        FROM          
                                                            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                                            PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                                                            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                            PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                                                            STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                                                        WHERE      
                                                            ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
                                                        GROUP BY 
                                                            EPS.PAKET_ID, 
                                                            S.BARCOD, 
                                                            S.STOCK_CODE, 
                                                            S.PRODUCT_NAME, 
                                                            S.PRODUCT_TREE_AMOUNT, 
                                                            ESR.SHIP_RESULT_ID,
                                                            ESRR.ORDER_ROW_ID
                                                        ) AS TBL1
                                                    GROUP BY
                                                        PAKET_ID, 
                                                        BARCOD, 
                                                        STOCK_CODE, 
                                                        PRODUCT_NAME, 
                                                        PRODUCT_TREE_AMOUNT, 
                                                        SHIP_RESULT_ID
                                                    ) AS TBL
                                                ) AS TBL2
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="AMBAR_CONTROL" datasource="#DSN3#">
                                            SELECT     
                                                ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                                ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                            FROM         
                                                (		
                                                SELECT     
                                                    PAKET_SAYISI AS PAKETSAYISI, 
                                                    PAKET_ID AS STOCK_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME,
                                                    (
                                                      SELECT 
                                                        SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                                                    FROM
                                                        ( 
                                                        SELECT        
                                                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                        FROM            
                                                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                        WHERE        
                                                            SF.FIS_TYPE = 113 AND 
                                                            SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                            SFR.STOCK_ID = TBL.PAKET_ID
                                                        <cfif get_period_id.recordcount>
                                                            UNION ALL
                                                            SELECT        
                                                                SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                            FROM            
                                                                #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                                #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                            WHERE        
                                                                SF.FIS_TYPE = 113 AND 
                                                                SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                                SFR.STOCK_ID = TBL.PAKET_ID
                                                        </cfif>
                                                        ) AS TBL_5
                                                    ) AS CONTROL_AMOUNT, SHIP_RESULT_ID
                                                FROM         
                                                    (
                                                    SELECT     
                                                        SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                                                        PAKET_ID, 
                                                        BARCOD, 
                                                        STOCK_CODE, 
                                                        PRODUCT_NAME, 
                                                        PRODUCT_TREE_AMOUNT, 
                                                        SHIP_RESULT_ID
                                                    FROM          
                                                        (
                                                        SELECT     
                                                            CASE 
                                                                WHEN 
                                                                    S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                                THEN 
                                                                    S.PRODUCT_TREE_AMOUNT 
                                                                ELSE 
                                                                    SUM(SIR.AMOUNT * EPS.PAKET_SAYISI)
                                                            END 
                                                                AS PAKET_SAYISI, 
                                                            EPS.PAKET_ID, 
                                                            S.BARCOD, 
                                                            S.STOCK_CODE, 
                                                            S.PRODUCT_NAME, 
                                                            S.PRODUCT_TREE_AMOUNT, 
                                                            SIR.SHIP_ROW_ID, 
                                                            SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                                                        FROM          
                                                            STOCKS AS S INNER JOIN
                                                            PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                                                            #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                                                            #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                                                        WHERE      
                                                            SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                                                        GROUP BY 
                                                            EPS.PAKET_ID, 
                                                            S.BARCOD, 
                                                            S.STOCK_CODE, 
                                                            S.PRODUCT_NAME, 
                                                            S.PRODUCT_TREE_AMOUNT, 
                                                            SIR.SHIP_ROW_ID, 
                                                            SI.DISPATCH_SHIP_ID
                                                        ) AS TBL1
                                                    GROUP BY 
                                                        PAKET_ID, 
                                                        BARCOD, 
                                                        STOCK_CODE, 
                                                        PRODUCT_NAME, 
                                                        PRODUCT_TREE_AMOUNT, 
                                                        SHIP_RESULT_ID
                                                    ) AS TBL
                                                ) AS TBL2
                                        </cfquery> 
                                    </cfif>
                                    <td style="text-align:center"> <!---Hazırlama Indicator--->
                                        <cfif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.PAKET_SAYISI eq 0 and AMBAR_CONTROL.CONTROL_AMOUNT eq 0>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/plus_ques.gif" border="0" title="<cf_get_lang_main no='2178.Barkod Yok'>">
                                            </a>
                                         <cfelseif AMBAR_CONTROL.recordcount AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/red_glob.gif" border="0" title="<cf_get_lang_main no='3137.Sevk Edildi'>.">
                                            </a>
                                         <cfelseif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.CONTROL_AMOUNT eq 0>
                                            <cfif IS_SEVK_EMIR eq 1>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/blue_glob.gif" border="0" title="<cf_get_lang_main no='3538.Sevk Emri Verildi.'>">
                                                </a>
                                            <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3138.Sevk Edilmedi'>.">
                                                </a>
                                            </cfif>
                                         <cfelseif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.PAKET_SAYISI gt AMBAR_CONTROL.CONTROL_AMOUNT>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/green_glob.gif" border="0" title="<cf_get_lang_main no='3139.Eksik Sevkiyat'>.">
                                            </a>
                                         <cfelseif AMBAR_CONTROL.recordcount AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) lt ceiling(AMBAR_CONTROL.CONTROL_AMOUNT)>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/black_glob.gif" border="0" title="<cf_get_lang_main no='3140.Fazla Sevkiyat'>">  
                                            </a>
                                         </cfif>
                                    </td>
                                <cfelse>
                                	<cfset AMBAR_CONTROL.recordcount = 0>
                                    <cfset AMBAR_CONTROL.PAKET_SAYISI =0>
                                    <cfset AMBAR_CONTROL.CONTROL_AMOUNT = 0>
                                </cfif>
                                <cfif IS_TYPE eq 1>    
                                    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#"> <!---Paket Kontrolü kontrol ediliyor--->
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                        FROM         
                                            (
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 1 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT
                                            FROM         
                                                (
                                                SELECT
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM
                                                    (     
                                                    SELECT     
                                                   		round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    FROM 
                                                    	SPECTS AS SP INNER JOIN
                     									PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                     									PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                      									ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID ON SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID INNER JOIN
                     									STOCKS AS S INNER JOIN
                     									PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID ON SP.SPECT_MAIN_ID = 0 INNER JOIN
                                                        STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID   
                                                    WHERE      
                                                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID# AND
                                                        ISNULL(S1.IS_PROTOTYPE,0) = 1
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                 	UNION ALL
                                                    SELECT     
                                                   		round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    FROM          
                                                        PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                                        PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                                                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                                                        STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                                                        STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                                                    WHERE      
                                                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID# AND
                                                        ISNULL(S1.IS_PROTOTYPE,0) = 0
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    ) AS TBL1
                                                GROUP BY
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME,
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#">
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                        FROM         
                                            (		
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 2 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT, SHIP_RESULT_ID
                                            FROM         
                                                (
                                                SELECT     
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM          
                                                    (
                                                    SELECT     
                                                        CASE 
                                                            WHEN 
                                                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                            THEN 
                                                                S.PRODUCT_TREE_AMOUNT 
                                                            ELSE 
                                                                round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),2)
                                                        END 
                                                            AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                                                    FROM          
                                                        STOCKS AS S INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                                                    WHERE      
                                                        SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID
                                                    ) AS TBL1
                                                GROUP BY 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery>
                                </cfif>
                                
                                <td style="text-align:center"> <!---El Terminali 1 Kontrol Indicator--->
                                    <cfif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI eq 0 and PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                                            <img src="/images/plus_ques.gif" border="0" title="<cf_get_lang_main no='2178.Barkod Yok'>." />
                                        </a>
                                    <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI - PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                                            <img src="/images/red_glob.gif" border="0" title="<cf_get_lang_main no='3133.Kontrol Edildi'>.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                                            <img src="/images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3134.Kontrol Edilmedi'>.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI gt PACKEGE_CONTROL.CONTROL_AMOUNT>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">	
                                            <img src="/images/green_glob.gif" border="0" title="<cf_get_lang_main no='3135.Kontrol Eksik'>."> 
                                        </a>  
                                     <cfelse>
                                     	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">	
                                            <img src="/images/black_glob.gif" border="0" title="<cf_get_lang_main no='3539.Teslimat Miktarı Düşürülmüş.'>"> 
                                        </a> 
                                     </cfif>
                                </td>
                                <td style="text-align:center"> <!---İrsaliye Indicator--->
                                    <cfif IS_TYPE eq 1>
                                        <cfif DURUM eq 1>
                                        	<cfif (attributes.e_shipping_type eq 1 and ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0) or attributes.e_shipping_type neq 1>
                                            	<cfif Listlen(order_id_list) eq 1>
                                                	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_sale&order_id=#order_id_list#&order_row_id=#order_row_id_list#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3540.Satış İrsaliyesi Oluştur'>">
                                                <cfelse>
                                                	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_sale&order_id=#ListGetAt(order_id_list,1)#&ezgi_order_row_id=#order_row_id_list#&order_row_id=0','longpage');" class="tableyazi" title="<cf_get_lang_main no='3540.Satış İrsaliyesi Oluştur'>">
                                                </cfif>
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='1305.Açık'>" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3541.Kontrol Tamamlanmamış Sevkiyat'>" />
                                            </cfif>
                                        <cfelseif DURUM eq 2>
                                            <img src="../../../images/red_glob.gif" border="0" title="<cfoutput>#getLang('prod',183)# #getLang('main',3137)#</cfoutput>" />
                                        <cfelseif DURUM eq 3>
                                        	 <cfif ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_sale&<cfif Listlen(order_id_list) eq 1>order_id=#order_id_list#&order_row_id=#order_row_id_list#<cfelse></cfif>','longpage');" class="tableyazi" title="Satış İrsaliyesi Oluştur">
                                                    <img src="../../../images/green_glob.gif" border="0"title="<cf_get_lang_main no='3542.Kısmi Kapandı'>" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/green_glob.gif" border="0"title="<cf_get_lang_main no='3542.Kısmi Kapandı'>" />
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfif DURUM eq 1>
                                        	<cfif (attributes.e_shipping_type eq 1 and ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0) or attributes.e_shipping_type neq 1>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.add_ship_dispatch&dispatch_ship_id=#SHIP_RESULT_ID#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3543.Depolararası Sevk İrsaliyesi Oluştur'>">
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='1305.Açık'>" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3541.Kontrol Tamamlanmamış Sevkiyat'>" />
                                            </cfif>
                                        <cfelseif DURUM eq 2>

                                            <img src="../../../images/red_glob.gif" border="0" title="<cfoutput>#getLang('prod',183)# #getLang('main',3137)#</cfoutput>" />
                                        </cfif>
                                    </cfif>
                                </td>
                                <td style="text-align:center">
                                	<cfif get_invoice_durum.recordcount and len(get_invoice_durum.kalan)>
                                    	<cfif get_invoice_durum.kalan lt 0>
                                    		<img src="../../../images/green_glob.gif" border="0" title="<cfoutput>#getLang('main',3544)# #getLang('report',404)#</cfoutput> " />
                                       	<cfelse>
                                        	<img src="../../../images/red_glob.gif" border="0" title="<cfoutput>#getLang('report',404)#</cfoutput> " />
                                        </cfif>
                                    <cfelse>
                                    	<cfif DURUM eq 1>
                                        	<cfif attributes.e_shipping_type eq 1 and (ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0) or attributes.e_shipping_type neq 1>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.form_add_bill&<cfif Listlen(order_id_list) eq 1>order_id=#order_id_list#&order_row_id=#order_row_id_list#<cfelse>order_id=#ListGetAt(order_id_list,1)#</cfif>','longpage');" class="tableyazi" title="<cf_get_lang_main no='3545.Toptan Satış Faturası Oluştur'>">
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="<cfoutput>#getLang('main',296)# #getLang('sales',479)#</cfoutput> " />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3546.Önce Ambar Fişi Oluşturun'>" />
                                            </cfif>
                                       	<cfelse>
                                        	<img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3547.Fatura Emirlerden Kesilebilir'> " />
                                        </cfif>
                                    </cfif>
                                </td> <!---Fatura Indicator--->
                                <cfquery name="get_control_emp" datasource="#dsn3#">
                                	SELECT DISTINCT RECORD_EMP FROM PRTOTM_SHIPPING_PACKAGE_LIST WHERE SHIPPING_ID = #SHIP_RESULT_ID# AND TYPE = #IS_TYPE#
                                </cfquery>
								<td>#get_emp_info(get_control_emp.RECORD_EMP,0,0)#</td>
                                <!---<td style="text-align:right"><cfif isnumeric(GET_PUAN.puan)><cfif GET_PUAN.puan eq 0><font color="red">#Tlformat(row_point,2)#</font><cfelse>#Tlformat(row_point,2)#</cfif><cfelse><font color="red">-</font></cfif></td>--->
                                <td style="text-align:center">#SEHIR#<br />#ILCE#</td>
                                <td title="#NOTE#">#left(NOTE,70)#<cfif len(NOTE) gt 70>...</cfif></td>
                                
                                <td style="text-align:center;<cfif DURUM neq 1>background-color:red</cfif>"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=32&action_id=#is_type#-#SHIP_RESULT_ID#','page');"><img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>">
                                </td>
                                <td style="text-align:right">
                                	<cfset birlesme_izni = 0>
                                    <cfif IS_TYPE eq 1>
                                        <cfif (attributes.e_shipping_type eq 1 and ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0 and DURUM eq 1  and get_invoice_durum.kalan lt 0) or attributes.e_shipping_type neq 1 >
                                            <cfquery name="get_shipping_group" dbtype="query">
                                                SELECT
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID,
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID,
                                                    </cfif>
                                                    SEHIR,
                                                    ILCE,
                                                    SHIP_METHOD_TYPE,
                                                    DELIVER_EMP,
                                                    COUNT(*) AS SAYI
                                                FROM
                                                    GET_SHIPPING
                                                WHERE
                                                    IS_TYPE = 1 AND
                                                    SHIP_METHOD_TYPE = #SHIP_METHOD_TYPE# AND
                                                    SEHIR = '#SEHIR#' AND
                                                    ILCE = '#ILCE#' AND
                                                    DELIVER_EMP = #DELIVER_EMP# AND
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID = #COMPANY_ID#
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID = #CONSUMER_ID#
                                                    </cfif>
                                                GROUP BY
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID,
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID,
                                                    </cfif>
                                                    SEHIR,
                                                    ILCE,
                                                    DELIVER_EMP,
                                                    SHIP_METHOD_TYPE
                                            </cfquery>
                                            <cfif get_shipping_group.SAYI gt 1>
                                                <cfset birlesme_izni = 1>
                                            <cfelse>       
                                            </cfif>
                                        <cfelse>      
                                        </cfif>
                                    <cfelse>
                                    </cfif>
                                    <cfif DURUM eq 1>
                                        <input type="checkbox" name="select_production" value="#IS_TYPE#-#SHIP_RESULT_ID#-#birlesme_izni#">
                                    </cfif>
                                    <cfif birlesme_izni eq 1>
                                        <img src="/images/starton.gif" border="0" title="<cf_get_lang_main no='3548.Birleşebilir'>" />
                                    <cfelse>
                                    	<img src="/images/stop.gif" border="0" title="<cf_get_lang_main no='3549.Birleşemez'>" />
                                    </cfif>
                                </td>
                            </tr>
                            <cfset son_row = currentrow>
                    </cfoutput>
              	</cfif>      
            <cfelse>
			<tr>
				<td colspan="17"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
			</tr>
            </cfif>	
		</tbody>
        <cfif isdefined("attributes.form_varmi")>
            <tfoot>
            	<form name="button_form" method="post" action="">
                <tr>
                	<cfif isdefined('tip')>
                    	<td colspan="17">
                        	<font color="red">
                            	<cf_get_lang_main no='3550.Önce Hataları Düzeltmelisiniz!!!'>
                            </font>
                      	</td>      
                  	<cfelse>
						<cfif attributes.totalrecords gt son_row>
                            <cfoutput>
                                <td style="text-align:left;" colspan="<cfif attributes.e_shipping_type eq 1>13<cfelse>12</cfif>"><cfoutput>#getLang('report',462)#</cfoutput></td>
                                <!---<td style="text-align:right;" >#Tlformat(t_point,2)#</td>--->
                                <td style="text-align:right;" colspan="4">
                               		<input type="text" name="send_date" id="send_date" value="#dateformat(DateAdd('d',1,now()),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                    <cf_wrk_date_image date_field="send_date">
                                    <input type="button" name="gonder" value="Gönder" onClick="grupla(-4);">
                                	<input type="button" name="birles" value="Birleştir" onClick="grupla(-3);">
                                    <input type="button" value="Toplu Yazdır" onClick="grupla(-2);">
                                </td>
                            </cfoutput>
                        <cfelse>
                            <cfoutput>
                                <td style="text-align:left;" colspan="<cfif attributes.e_shipping_type eq 1>13<cfelse>12</cfif>"><cf_get_lang_main no='268.Genel Toplam'></td>
                                <!---<td style="text-align:right;" >#Tlformat(t_point,2)#</td>--->
                                <td style="text-align:right;" colspan="4">
                                	<input type="text" name="send_date" id="send_date" value="#dateformat(DateAdd('d',1,now()),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                    <cf_wrk_date_image date_field="send_date">
                                    <input type="button" name="gonder" value="Gönder" onClick="grupla(-4);">
                                    <input type="button" name="birles" value="Birleştir" onClick="grupla(-3);">
                                    <input type="button" value="Toplu Yazdır" onClick="grupla(-2);">
                                </td>
                            </cfoutput>
                         </cfif>     
                	</cfif>
                </tr>
                </form>
            </tfoot>
        </cfif>
	</table>
<cfset url_str = 'eshipping.list_partner_shipping'>
<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
	<cfset url_str = url_str & "&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset url_str = url_str & "&company_id=#attributes.company_id#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset url_str = url_str & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and isdefined("attributes.short_code_name") and len(attributes.short_code_name)>
	<cfset url_str = url_str & "&short_code_id=#attributes.short_code_id#&short_code_name=#attributes.short_code_name#">
</cfif>
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
	<cfset url_str = url_str & "&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
</cfif>

<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
	<cfset url_str = url_str & "&prod_cat=#attributes.prod_cat#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
	<cfset url_str = url_str & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#">
</cfif>
<!---<cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)> 
	<cfset url_str = url_str & "&order_employee_id=#attributes.order_employee_id#&order_employee=#attributes.order_employee#">
</cfif>--->
<cfif isdefined("attributes.sales_member_id") and len(attributes.sales_member_id)>
	<cfset url_str = url_str & "&sales_member_id=#attributes.sales_member_id#&sales_member_name=#attributes.sales_member_name#">
</cfif>
<cfif isdefined("attributes.sales_departments") and len(attributes.sales_departments)>
	<cfset url_str = "#url_str#&sales_departments=#attributes.sales_departments#">
</cfif>
<cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>

	<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
</cfif>

<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
	<cfset url_str = "#url_str#&zone_id=#attributes.zone_id#">
</cfif>
<cfif isdefined("attributes.city_name") and len(attributes.city_name)>

	<cfset url_str = "#url_str#&city_name=#attributes.city_name#">
</cfif>
<cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>
	<cfset url_str = "#url_str#&ship_method_id=#attributes.ship_method_id#">
</cfif>

<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined('attributes.report_type_id')>
	<cfset url_str = url_str & "&report_type_id=#attributes.report_type_id#">
</cfif>
<cfif len(t_point)>
	<cfset url_str = url_str & "&t_point=#t_point#">
</cfif>
<cfset url_str = url_str & "&order_employee_id=#attributes.order_employee_id#&order_employee=#attributes.order_employee#">
<cfset url_str = url_str & "&sort_type=#attributes.sort_type#">
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#attributes.fuseaction#&#url_str#&form_varmi=1">
<script language="javascript">
	function input_control()
		{
			if(document.all.branch_id.value !='' && document.all.listing_type.value ==2)
			{
				alert("<cf_get_lang_main no='3552.Liste Tipi Olarak Sevk Planları İle Şubeyi Birlikte Seçemezsiniz'>!!!.");
				return false
			}
			else
			{
				return true
			}
		}
	function grupla(type)
		{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
			shipping_id_list = '';
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
						shipping_id_list +=my_objets.value+',';
				}
			}
			shipping_id_list = shipping_id_list.substr(0,shipping_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(shipping_id_list!='')
			{
				if(type == -3)
				{
					var soru = confirm("<cf_get_lang_main no='3553.Birleştirilen Sevk Planını Tekrar Geri Alamazsınız'>. <cf_get_lang_main no='1176.Emin misiniz ?'>");
					if(soru==true)
					{
						window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_upd_ezgi_shipping_row&shipping_id_list='+shipping_id_list);
					}
				}
				else if(type == -4)
				{
					var soru = confirm("<cf_get_lang_main no='3554.Sevkiyatları ilgili Tarihe Gönderiyorum.'> <cf_get_lang_main no='1176.Emin misiniz ?'>");
					if(soru==true)
					{
						send_date = document.getElementById('send_date').value;
						if(send_date.length>0)
						window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_upd_ezgi_shipping_date&shipping_id_list='+shipping_id_list+'&send_date='+send_date);
						else
						{
							alert("<cf_get_lang_main no='3555.Gönderilecek Tarih Boş Olamaz !'>");
							return false;
						}
					}
				}
				else if(type == -2)
				{
					window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=32&action_id='+shipping_id_list);		
				}
			}
		}
</script>