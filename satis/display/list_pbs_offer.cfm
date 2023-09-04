<cfset IS_SHOW_SALES_EMP=1>
<cfset XML_PROBABILITY =0>
<cfset XML_OFFER_REVISION  =0>
<cfset X_SHOW_ORDER_PRICE   =0>
<cfset X_SHOW_OTHER_MONEY_VALUE   =1>
<cfset XML_STOCK_CODE    =1>
<cf_xml_page_edit fuseact ="sales.list_pbs_offer" default_value="1">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_offerno" default="">
    <cfparam name="attributes.offer_status_cat_id" default="">
    <cfparam name="attributes.offer_zone" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.form_varmi" default="">
    <cfparam name="attributes.offer_stage" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.listing_type" default="1">
    <cfparam name="attributes.status" default="1">
    <cfparam name="attributes.sort_type" default="4">
    <cfparam name="attributes.probability" default="">
    <cfparam name="attributes.sales_member_name" default="">
    <cfparam name="attributes.sales_member_id" default="">
    <cfparam name="attributes.sales_member_type" default="">
    <cfparam name="attributes.IsSiparis" default="">
    <cfif not isdefined("attributes.sales_emp_id") and attributes.form_varmi neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp_id = "#session.ep.userid#">
    </cfif>
    <cfif not isdefined("attributes.sales_emp") and attributes.form_varmi neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp = "#session.ep.name# #session.ep.surname#">
    </cfif>
    <cfif len(attributes.form_varmi)>
        <cfif len(attributes.start_date)>
            <cf_date tarih="attributes.start_date">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cf_date tarih="attributes.finish_date">
        </cfif>
        <cfscript>
            get_offer_list_action = createObject("component", "AddOns.partner.satis.cfc.get_offer_list");
            get_offer_list_action.dsn3 = dsn3;
            get_offer_list_action.dsn_alias = dsn_alias;
            get_offer_list = get_offer_list_action.get_offer_list_fnc
                (
                    product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                    product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                    listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                    offer_zone : '#IIf(IsDefined("form.offer_zone"),"form.offer_zone",DE(""))#',
                    keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                    keyword_offerno : '#IIf(IsDefined("attributes.keyword_offerno"),"attributes.keyword_offerno",DE(""))#',
                    xml_offer_revision : '#IIf(IsDefined("xml_offer_revision"),"xml_offer_revision",DE(""))#',
                    OFFER_STATUS_CAT_ID : '#IIf(IsDefined("OFFER_STATUS_CAT_ID"),"OFFER_STATUS_CAT_ID",DE(""))#',
                    status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
                    member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
                    member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                    company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                    consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                    sales_emp_id : '#IIf(IsDefined("attributes.sales_emp_id"),"attributes.sales_emp_id",DE(""))#',
                    start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                    finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                    sale_add_option : '#IIf(IsDefined("attributes.sale_add_option"),"attributes.sale_add_option",DE(""))#',
                    offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(""))#',
                    project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                    project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                    x_control_ims : '#IIf(IsDefined("x_control_ims"),"x_control_ims",DE(""))#',
                    x_multiple_filters : '#IIf(IsDefined("x_multiple_filters"),"x_multiple_filters",DE("0"))#',
                    sales_emp= '#IIf(IsDefined("attributes.sales_emp"),"attributes.sales_emp",DE(""))#',
                    sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE("4"))#',
                    probability : '#IIf(IsDefined("attributes.probability"),"attributes.probability",DE("4"))#',
                    sales_member_type : '#IIf(IsDefined("attributes.sales_member_type"),"attributes.sales_member_type",DE(""))#',
                    sales_member_name : '#IIf(IsDefined("attributes.sales_member_name"),"attributes.sales_member_name",DE(""))#',
                    sales_member_id : '#IIf(IsDefined("attributes.sales_member_id"),"attributes.sales_member_id",DE(""))#',
                    IsSiparis : '#IIf(IsDefined("attributes.IsSiparis"),"attributes.IsSiparis",DE(""))#',
                    xml_sales_cari : '#IIf(IsDefined("xml_sales_cari"),"xml_sales_cari",DE(""))#'
                    );
        </cfscript>
    <cfelse>
        <cfset get_offer_list.recordcount = 0>
    </cfif>
    
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_pbs_offer%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="list_offer" method="post" action="#request.self#?fuseaction=sales.list_pbs_offer">
                <input name="form_varmi" id="form_varmi" value="1" type="hidden">
                <cf_box_search>
                    <cfoutput>
                        <div class="form-group">
                            <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="#attributes.keyword#" maxlength="50">
                        </div>
                        <cfif isdefined("x_multiple_filters") and x_multiple_filters eq 1>
                            <div class="form-group">
                                <input type="text" name="keyword_offerno" placeholder="<cf_get_lang dictionary_id='57487.No'>" id="keyword_offerno" value="#attributes.keyword_offerno#" maxlength="50">
                            </div>
                        </cfif>
                        <div class="form-group">
                            <select name="offer_stage" id="offer_stage">
                                <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                                <cfloop query="get_process_type">
                                    <option value="#process_row_id#"<cfif attributes.offer_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="form-group">
                            <select name="status" id="status">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif isdefined("attributes.status") and (attributes.status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0" <cfif isdefined("attributes.status") and (attributes.status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                        <div class="form-group">
                            <select name="listing_type" id="listing_type">
                                <option value="1" <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                                <option value="2" <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                <cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <select name="IsSiparis">
                                <option value="">Sipariş Durumu</option>
                                <option <cfif attributes.IsSiparis eq 1>selected</cfif> value="1">Siparişe Dönenler</option>
                                <option <cfif attributes.IsSiparis eq 0>selected</cfif> value="0">Siparişe Dönmemiş</option>
                            </select>
                        </div>
                        <div class="form-group small">
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                        </div>
                        <div class="form-group">
                          <button class="ui-btn ui-btn-success" type="submit"><i class="fa fa-search"></i></button>
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </div>
                    </cfoutput>
                </cf_box_search>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_head">
                            <label class="col col-12"><cf_get_lang dictionary_id ='57416.proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                                </div>
                            </div>
                        </div>
                       
                        <div class="form-group" id="item-member_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>						
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                    <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=list_offer.consumer_id&field_comp_id=list_offer.company_id&field_member_name=list_offer.member_name&field_type=list_offer.member_type">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3&keyword='+encodeURIComponent(document.list_offer.member_name.value));"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-offer_zone">
                            <label class="col col-12"><cf_get_lang dictionary_id='29472.Yöntem'></label>
                            <div class="col col-12">
                            <select name="offer_zone" id="offer_zone">
                                <option value=""<cfif not len(attributes.offer_zone)> selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="0"<cfif attributes.offer_zone is "0"> selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
                                <option value="1"<cfif attributes.offer_zone is "1"> selected</cfif>><cf_get_lang dictionary_id='40888.Partner Portal'></option>
                            </select>
                            </div>
                        </div>
                            <div class="form-group" id="item-sales_emp">
                            <label class="col col-12"><cf_get_lang dictionary_id='40903.Satış Yapan'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfif isDefined("attributes.sales_emp") and len(attributes.sales_emp) and isdefined("attributes.sales_emp_id") and  len(attributes.sales_emp_id)><cfoutput>#attributes.sales_emp_id#</cfoutput></cfif>">
                                    <input name="sales_emp" type="text" id="sales_emp" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','120');" value="<cfif isDefined("attributes.sales_emp") and len(attributes.sales_emp) and len(attributes.sales_emp_id)><cfoutput>#attributes.sales_emp#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_offer.sales_emp_id&field_name=list_offer.sales_emp&select_list=1');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-sort_type">
                            <label class="col col-12"><cfoutput>#getLang('ehesap',715)#</cfoutput></label>
                            <div class="col col-12">
                            <select name="sort_type" id="sort_type">
                                <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40843.Teslim Tarihine Göre Artan'></option>
                                <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='40844.Teslim Tarihine Göre Azalan'></option>
                                <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='40909.Teklif Tarihine Göre Artan'></option>
                                <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id="40911.Teklif Tarihine Göre Azalan"></option>
                                <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id="40918.Görevliye Göre Artan"></option>
                                <option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang dictionary_id="40920.Görevliye Göre Azalan"></option>
                                <option value="7" <cfif attributes.sort_type eq 7>selected</cfif>><cf_get_lang dictionary_id="40921.Projeye Göre Artan"></option>
                                <option value="8" <cfif attributes.sort_type eq 8>selected</cfif>><cf_get_lang dictionary_id="40925.Projeye Göre Azalan"></option>
                                <option value="9" <cfif attributes.sort_type eq 9>selected</cfif>><cf_get_lang dictionary_id="40928.Teklif Noya Göre Artan"></option>
                                <option value="10" <cfif attributes.sort_type eq 10>selected</cfif>><cf_get_lang dictionary_id="40929.Teklif Noya  Göre Azalan"></option>
                                <option value="11" <cfif attributes.sort_type eq 11>selected</cfif>><cf_get_lang dictionary_id="40930.Kaydedene Göre Artan"></option>
                                <option value="12" <cfif attributes.sort_type eq 12>selected</cfif>><cf_get_lang dictionary_id="40931.Kaydedene Göre Azalan"></option>
                                <option value="13" <cfif attributes.sort_type eq 13>selected</cfif>><cf_get_lang dictionary_id="40932.Tutara Göre Artan"></option>
                                <option value="14" <cfif attributes.sort_type eq 14>selected</cfif>><cf_get_lang dictionary_id="40934.Tutara Göre Azalan"></option>
                            </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sales_member_id">						
                            <label class="col col-12"><cf_get_lang dictionary_id='40904.Satis Ortagi'></label>			
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfoutput>#attributes.sales_member_id#</cfoutput>">
                                    <input type="hidden" name="sales_member_type" id="sales_member_type" value="<cfif attributes.sales_member_type is 'partner'>partner<cfelseif attributes.sales_member_type is 'consumer'>consumer</cfif>"> 
                                    <input name="sales_member_name" type="text" id="sales_member_name" onfocus="AutoComplete_Create('sales_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID2,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" value="<cfoutput>#attributes.sales_member_name#</cfoutput>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=list_offer.sales_member_id&field_name=list_offer.sales_member_name&field_type=list_offer.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-product_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                    <input name="product_name" type="text" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_offer.product_id&field_name=list_offer.product_name&keyword='+encodeURIComponent(document.list_offer.product_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <cfif xml_probability eq 1>
                            <div class="form-group" id="item-probability">
                                <div class="col col-12">
                                <label class="col col-12">%(<cf_get_lang dictionary_id='40896.Yüzde'>)</label>
                                    <div class="input-group">
                                        <select name="probability" id="probability">
                                            <option value=""><cfoutput><cf_get_lang dictionary_id='57734.Seçiniz'></cfoutput></option>
                                            <cfoutput>
                                                <cfloop from="0" to="100" index="i" step="5">
                                                    <option value="#i#" <cfif attributes.probability eq i>selected</cfif> >#i#</option>
                                                </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                </cf_box_search_detail>
            </cfform>
        </cf_box>
        <cfset send_member_ = "">
        <cfif Len(attributes.company_id) and Len(attributes.member_name)>
            <cfset send_member_ = "&company_id=#attributes.company_id#">
        <cfelseif Len(attributes.consumer_id) and Len(attributes.member_name)>
            <cfset send_member_ = "&consumer_id=#attributes.consumer_id#">
        </cfif>
    
        <cfsavecontent variable="head"><cf_get_lang dictionary_id='40806.Teklifler'></cfsavecontent>
        <cf_box title="#head#" uidrop="1" hide_table_column="1">
            <cfform name="sale_order_relation" action="#request.self#?fuseaction=sales.list_order&event=add#send_member_#">
                <input type="hidden" name="event" value="addOrder">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <cfif xml_offer_revision eq 1>
                                <th><cf_get_lang dictionary_id="40935.Revize"><cf_get_lang dictionary_id='57487.No'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                            <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                            <th><cf_get_lang dictionary_id='57574.Sirket'> - <cf_get_lang dictionary_id='57578.Yetkili'></th>
                                <th>Açıklama</th>
                                <th>Sipariş</th>
                            <cfif x_show_order_price eq 1 and attributes.listing_type eq 1>
                            <th><cf_get_lang dictionary_id='30024.KDVsiz'><cfif attributes.listing_type eq 1><cf_get_lang dictionary_id='57673.Tutar'><cfelse><cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                            </cfif>
                            <th><cfif attributes.listing_type eq 1><cf_get_lang dictionary_id='57673.Tutar'><cfelse><cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                            <th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
                            <cfif x_show_other_money_value eq 1 and attributes.listing_type eq 1>
                            <th><cf_get_lang dictionary_id='30024.KDVsiz'><cf_get_lang dictionary_id='57677.Döviz'><cfif attributes.listing_type eq 1><cf_get_lang dictionary_id='57673.Tutar'><cfelse><cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57677.Döviz'><cfif attributes.listing_type eq 1><cf_get_lang dictionary_id='57673.Tutar'><cfelse><cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                            <th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                            <th><cf_get_lang dictionary_id='40903.Satış Calışan'></th>
                            <th><cf_get_lang dictionary_id='57416.Proje'></th>
                            <th><cf_get_lang dictionary_id='57612.Fırsat'></th>
                            <th><cf_get_lang dictionary_id='29472.yontem'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='58859.Surec'></th>
                            <cfif xml_probability eq 1>
                            <th><cf_get_lang dictionary_id='58652.Olasılık'></th>
                            </cfif>
                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                <cfif xml_stock_code eq 1>
                                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                            </cfif>
                            <!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_pbs_offer&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                        </tr>
                    </thead>
                        <cfif isdefined("attributes.form_varmi") and get_offer_list.recordcount>
                            <tbody>
                                <cfset partner_id_list=''>
                                <cfset company_id_list=''>
                                <cfset consumer_id_list=''>
                                <cfset emp_id_list=''>
                                <cfset offer_stage_list=''>
                                <cfset project_name_list = ''>
                                <cfset opp_name_list = ''>
                                <cfset offer_id_list =''>
                                <cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif len(offer_id) and not listFindnocase(offer_id_list,offer_id)>
                                        <cfset offer_id_list = listappend(offer_id_list,offer_id)>
                                    </cfif>
                                    <cfif len(partner_id) and not listFindnocase(partner_id_list,partner_id)>
                                        <cfset partner_id_list = listappend(partner_id_list,partner_id)>
                                    </cfif>
                                    <cfif len(company_id) and not listFindnocase(company_id_list,company_id)>
                                        <cfset company_id_list=listappend(company_id_list,company_id)>
                                    </cfif>
                                    <cfif len(consumer_id) and not listFindnocase(consumer_id_list,consumer_id)>
                                        <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                                    </cfif>
                                    <cfif Listlen(OFFER_TO_PARTNER,',')>
                                        <cfset partner_id_list=listappend(partner_id_list,OFFER_TO_PARTNER)>
                                    </cfif>
                                    <cfif len(sales_emp_id) and not listfind(emp_id_list,sales_emp_id)>
                                        <cfset emp_id_list = Listappend(emp_id_list,sales_emp_id)>
                                    </cfif>
                                    <cfif len(offer_stage) and not listfind(offer_stage_list,offer_stage)>
                                        <cfset offer_stage_list=listappend(offer_stage_list,offer_stage)>
                                    </cfif>
                                    <cfset partner_id_list = ListSort(ListDeleteDuplicates(partner_id_list),'Numeric','ASC',',')>
                                    <cfif len(project_id) and not listfind(project_name_list,project_id)>
                                        <cfset project_name_list = Listappend(project_name_list,project_id)>
                                    </cfif>
                                    <cfif len(opp_id) and not listfind(opp_name_list,opp_id)>
                                        <cfset opp_name_list = Listappend(opp_name_list,opp_id)>
                                    </cfif>
                                </cfoutput>
                                <cfif listlen(partner_id_list)>
                                    <cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
                                    <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                                        SELECT
                                            CP.COMPANY_PARTNER_NAME,
                                            CP.COMPANY_PARTNER_SURNAME,
                                            CP.PARTNER_ID,
                                            C.FULLNAME,
                                            C.NICKNAME,
                                            C.COMPANY_ID
                                        FROM
                                            COMPANY_PARTNER CP,
                                            COMPANY C
                                        WHERE
                                            CP.PARTNER_ID IN (#partner_id_list#) AND
                                            CP.COMPANY_ID=C.COMPANY_ID
                                        ORDER BY
                                            CP.PARTNER_ID
                                    </cfquery>
                                    <cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif listlen(company_id_list)>
                                    <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                                    <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                                        SELECT NICKNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                                    </cfquery>
                                    <cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif listlen(consumer_id_list)>
                                    <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                                    <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                                        SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                                    </cfquery>
                                    <cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif len(emp_id_list)>
                                    <cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
                                    <cfquery name="GET_POSITION" datasource="#DSN#">
                                        SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
                                    </cfquery>
                                    <cfset emp_id_list2=ValueList(get_position.EMPLOYEE_ID,',')>
                                </cfif>
                                <cfif len(offer_stage_list)>
                                    <cfset offer_stage_list=listsort(offer_stage_list,"numeric","ASC",",")>
                                    <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                                        SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#offer_stage_list#) ORDER BY PROCESS_ROW_ID
                                    </cfquery>
                                    <cfset offer_stage_list = listsort(listdeleteduplicates(valuelist(PROCESS_TYPE.PROCESS_ROW_ID,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif len(project_name_list)>
                                    <cfquery name="offer_pro" datasource="#dsn#">
                                        SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
                                    </cfquery>
                                    <cfset project_name_list = listsort(listdeleteduplicates(valuelist(offer_pro.project_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfif len(opp_name_list)>
                                    <cfquery name="offer_opp" datasource="#dsn3#">
                                        SELECT OPP_HEAD, OPP_ID FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_name_list#) ORDER BY OPP_ID
                                    </cfquery>
                                    <cfset opp_name_list = listsort(listdeleteduplicates(valuelist(offer_opp.opp_id,',')),'numeric','ASC',',')>
                                </cfif>
                                <cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <tr>
                                        <td width="35">#currentrow#</td>
                                        <td><a href="#request.self#?fuseaction=sales.list_pbs_offer&event=upd&offer_id=#offer_id#" class="tableyazi">#offer_number#</a></td>
                                        <cfif xml_offer_revision eq 1>
                                            <td><cfif len(offer_revize_no)>#offer_revize_no#<cfelse>#offer_number#-00</cfif></td>
                                        </cfif>
                                        <td>#dateformat(offer_date,dateformat_style)#</td>
                                        <td width="150"><a href="#request.self#?fuseaction=sales.list_pbs_offer&event=upd&offer_id=#offer_id#" class="tableyazi">#left(offer_head,40)#<cfif len(offer_head) gt 40>...</cfif></a></td>
                                        <td>
                                            <cfif len(company_id) and not Listlen(offer_to_partner)>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">#get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]# </a>
                                            <cfelseif len(consumer_id)>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,consumer_id,',')]#</a>
                                            <cfelseif Listlen(offer_to_partner)>
                                                <cfloop list="#offer_to_partner#" index="i">
                                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_detail.company_id[listfind(partner_id_list,i,',')]#','medium');">#get_partner_detail.nickname[listfind(partner_id_list,i,',')]#</a> -
                                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#i#','medium');">#get_partner_detail.company_partner_name[listfind(partner_id_list,i,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,i,',')]#</a>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                        <td>#OFFER_DESCRIPTION#</td>
                                        <td>#ORDER_NUMBER#</td>
                                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                            <cfif len(discount_1)><cfset indirim1 = discount_1><cfelse><cfset indirim1 =0></cfif>
                                            <cfif len(discount_2)><cfset indirim2 = discount_2><cfelse><cfset indirim2 =0></cfif>
                                            <cfif len(discount_3)><cfset indirim3 = discount_3><cfelse><cfset indirim3 =0></cfif>
                                            <cfif len(discount_4)><cfset indirim4 = discount_4><cfelse><cfset indirim4 =0></cfif>
                                            <cfif len(discount_5)><cfset indirim5 = discount_5><cfelse><cfset indirim5 =0></cfif>
                                            <cfif len(discount_6)><cfset indirim6 = discount_6><cfelse><cfset indirim6 =0></cfif>
                                            <cfif len(discount_7)><cfset indirim7 = discount_7><cfelse><cfset indirim7 =0></cfif>
                                            <cfif len(discount_8)><cfset indirim8 = discount_8><cfelse><cfset indirim8 =0></cfif>
                                            <cfif len(discount_9)><cfset indirim9 = discount_9><cfelse><cfset indirim9 =0></cfif>
                                            <cfif len(discount_10)><cfset indirim10 = discount_10><cfelse><cfset indirim10 =0></cfif>
                                            <cfset indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)>
                                            <cfset row_total = (quantity * price) + extra_price_total>
                                            <cfset row_nettotal = (row_total/100000000000000000000) * indirim_carpan>
                                        </cfif>
                                        <cfif x_show_order_price eq 1 and attributes.listing_type eq 1>
                                        <td align="right" style="text-align:right;">
                                            #TLFormat(NETTOTAL-TAX-OTV_TOTAL)#
                                        </td>
                                        </cfif>
                                        <td align="right" style="text-align:right;">
                                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                                #TLFormat(row_nettotal/quantity)#
                                            <cfelseif price neq "0" and attributes.listing_type eq 1>
                                                #TLFormat(price)#
                                            <cfelse>
                                                #TLFormat(NETTOTAL)#
                                            </cfif>
                                        </td>
                                        <td>#session.ep.money#</td>
                                        <cfif x_show_other_money_value eq 1 and attributes.listing_type eq 1>
                                        <td align="right" style="text-align:right;">
                                            #TLFormat((NETTOTAL/rate)-(TAX/RATE)-(OTV_TOTAL/RATE))#
                                        </td>
                                        </cfif>
                                        <td align="right" style="text-align:right;">
                                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                                #TLFormat((row_nettotal/quantity)/RATE2)#
                                            <cfelse>
                                                #TLformat(other_money_value,2)#
                                            </cfif>
                                        </td>
                                        <td>
                                            <cfif len(other_money_value)>
                                                <cfif session.ep.period_year gte 2009 and len(OTHER_MONEY) and OTHER_MONEY is 'YTL'>
                                                    #session.ep.money#
                                                <cfelseif session.ep.period_year lt 2009 and len(OTHER_MONEY) and OTHER_MONEY is 'TL'>
                                                    #session.ep.money#
                                                <cfelse>
                                                    #OTHER_MONEY#
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                                            <td><cfif len(sales_emp_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.employee_id[listfind(emp_id_list2,get_offer_list.sales_emp_id,',')]#','medium');">#get_position.employee_name[listfind(emp_id_list2,get_offer_list.sales_emp_id,',')]#&nbsp;#get_position.employee_surname[listfind(emp_id_list2,get_offer_list.sales_emp_id,',')]#</a></cfif></td>
                                            <td><cfif isdefined("get_offer_list.project_id") and len(get_offer_list.project_id)>
                                                    <a href="#request.self#?fuseaction=project.projects&event=det&id=#offer_pro.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#offer_pro.project_head[listfind(project_name_list,project_id,',')]#</a></td>
                                                <cfelse>
                                                    <cf_get_lang dictionary_id='58459.projesiz'>
                                                </cfif>
                                            </td>
                                            <td><cfif isdefined("get_offer_list.opp_id") and len(get_offer_list.opp_id)>
                                                    <a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#offer_opp.opp_id[listfind(opp_name_list,opp_id,',')]#" class="tableyazi" target="_blank">#offer_opp.opp_head[listfind(opp_name_list,opp_id,',')]#</a>
                                                </cfif>
                                            </td>
                                            <td><cfif offer_zone eq 0><cf_get_lang dictionary_id='58490.verilen'>
                                                <cfelseif offer_zone eq 1><cf_get_lang dictionary_id='58885.Partner'>
                                                <cfelseif offer_zone eq 2><cf_get_lang dictionary_id='40847.public'>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <td><cfif len(offer_stage)>#process_type.stage[listfind(offer_stage_list,offer_stage,',')]#</cfif></td>
                                        <cfif xml_probability eq 1>
                                        <td><cfif len(probability)>% #probability#</cfif></td>
                                        </cfif>
                                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                            <cfquery name="get_used_amount" datasource="#dsn3#">
                                                SELECT
                                                    SUM(QUANTITY) QUANTITY
                                                FROM
                                                    ORDER_ROW
                                                WHERE
                                                    WRK_ROW_RELATION_ID = '#wrk_row_id#' AND
                                                    STOCK_ID = #stock_id# AND
                                                    PRODUCT_ID = #product_id#
                                            </cfquery>
                                    
                                            <cfif len(get_used_amount.quantity)>
                                                <cfset 'used_amount_#offer_id#_#wrk_row_id#' = get_used_amount.quantity>
                                            <cfelse>
                                                <cfset 'used_amount_#offer_id#_#wrk_row_id#' = 0>
                                            </cfif>
                                            <input type="hidden" name="offer_amount_list" id="offer_amount_list" value="">
                                            <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = get_offer_list.quantity>
                                            <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = Evaluate('offer_amount_#offer_id#_#wrk_row_id#') - Evaluate('used_amount_#offer_id#_#wrk_row_id#')>
                                            <cfif xml_stock_code eq 1>
                                            <td align="right">#stock_code#</td>
                                            </cfif>
                                            <td>
                                            <cfif IS_VIRTUAL EQ 1>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_virtual_product&pid=#product_id#','medium');">#product_name#</a>
                                            <cfelse>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#product_name#</a>
                                            </cfif>
                                            </td>
                                            <td align="right">#quantity# #unit#</td>
                                            <td align="right">
                                                <cfif attributes.fuseaction contains 'autoexcel'>
                                                    #TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'),4)#
                                                <cfelse>
                                                    <input type="text" name="offer_amount_#offer_id#_#wrk_row_id#" id="offer_amount_#offer_id#_#wrk_row_id#" onBlur="myfunction(this,'#evaluate("offer_amount_#offer_id#_#wrk_row_id#")#', '#TLFormat(evaluate("offer_amount_#offer_id#_#wrk_row_id#"))#');" 
                                                        onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="box" value="#TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'),4)#" range="0,#evaluate('offer_amount_#offer_id#_#wrk_row_id#')#" style="width:100%" message="Miktarı Kontrol Ediniz!" <cfif Evaluate('offer_amount_#offer_id#_#wrk_row_id#') lte 0>disabled</cfif>>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <!-- sil -->
                                        <td width="%1" align="center">
                                            <cfif Len(attributes.listing_type) and attributes.listing_type eq 2 and len(attributes.member_name) and (len(attributes.company_id) or len(attributes.consumer_id))>
                                                <!--- Satir bazinda olup cari filtrelenmisse siparis olusturulabilir --->
                                                <input type="checkbox" name="offer_row_check_info" id="offer_row_check_info" value="#offer_id#_#wrk_row_id#" <cfif Evaluate('offer_amount_#offer_id#_#wrk_row_id#') lte 0>disabled</cfif>>
                                            <cfelse>
                                                <a href="#request.self#?fuseaction=sales.list_pbs_offer&event=upd&offer_id=#offer_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                            </cfif>
                                        </td>
                                        <!-- sil -->
                                    </tr>
                                </cfoutput>
                                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2 and len(attributes.member_name) and (len(attributes.company_id) or len(attributes.consumer_id))>
                                    <!--- Satir bazinda olup cari filtrelenmisse siparis olusturulabilir --->
                                    <tr>
                                        <td colspan="19" style="text-align:right;">
                                            <cf_workcube_buttons is_upd='0' is_cancel='0' add_function="addOrder()" insert_info='Satış Siparişi Oluştur' insert_alert=''>
                                        </td>
                                    </tr>
                                </cfif>
                            </tbody>
                        <cfelse>
                            <tbody>
                                <tr>
                                    <td colspan="19"><cfif len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                                </tr>
                            </tbody>
                        </cfif>
                </cf_grid_list>
            </cfform>
            <cfset url_str = "sales.list_pbs_offer">
            <cfif isdefined("attributes.form_varmi")>
                <cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#" >
            </cfif>
            <cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
              <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined ("attributes.keyword_offerno") and len(attributes.keyword_offerno)>
              <cfset url_str = "#url_str#&keyword_offerno=#attributes.keyword_offerno#">
            </cfif>
            <cfif len(attributes.company_id)>
              <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
            </cfif>
            <cfif len(attributes.company)>
              <cfset url_str = "#url_str#&company=#attributes.company#">
            </cfif>
            <cfif len(attributes.consumer_id)>
              <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
            </cfif>
            <cfif len(attributes.member_name)>
              <cfset url_str = "#url_str#&member_name=#attributes.member_name#">
            </cfif>
            <cfif len(attributes.member_type)>
              <cfset url_str = "#url_str#&member_type=#attributes.member_type#">
            </cfif>
            <cfif len(attributes.product_id)>
              <cfset url_str = "#url_str#&product_id=#attributes.product_id#">
            </cfif>
            <cfif len(attributes.product_name)>
              <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
            </cfif>
            <cfif len(attributes.offer_stage)>
              <cfset url_str = "#url_str#&offer_stage=#attributes.offer_stage#">
            </cfif>
            <cfif len(attributes.offer_zone)>
              <cfset url_str = "#url_str#&offer_zone=#attributes.offer_zone#">
            </cfif>
            <cfif len(attributes.listing_type)>
              <cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
            </cfif>
            <cfif len(attributes.offer_status_cat_id)>
              <cfset url_str = "#url_str#&offer_status_cat_id=#attributes.offer_status_cat_id#">
            </cfif>
            <cfif isdefined("attributes.sale_add_option") and len(attributes.sale_add_option)>
                <cfset url_str = "#url_str#&sale_add_option=#attributes.sale_add_option#">
            </cfif>
            <cfif len(attributes.start_date)>
                <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.finish_date)>
                <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif isDefined("attributes.sales_emp_id") and len(attributes.sales_emp_id) and len(attributes.sales_emp)>
                <cfset url_str = url_str & "&sales_emp_id=#attributes.sales_emp_id#&sales_emp=#attributes.sales_emp#">
            </cfif>
            <cfif isdefined("attributes.status")>
              <cfset url_str = "#url_str#&status=#attributes.status#">
            </cfif>
            <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
              <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
            </cfif>
            <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
              <cfset url_str = "#url_str#&project_head=#attributes.project_head#">
            </cfif>
            <cfif isdefined("attributes.sort_type")>
              <cfset url_str = "#url_str#&sort_type=#attributes.sort_type#">
            </cfif>
            <cfif isdefined("attributes.probability")>
              <cfset url_str = "#url_str#&probability=#attributes.probability#">
            </cfif>
            <cfif isdefined("attributes.sales_member_id") and len(attributes.sales_member_id) and  isdefined("attributes.sales_member_name") and len(attributes.sales_member_name)
            and  isdefined("attributes.sales_member_type") and len(attributes.sales_member_type)>
                <cfset url_str = url_str & "&sales_member_id=#attributes.sales_member_id#&sales_member_name=#attributes.sales_member_name#&sales_member_type=#attributes.sales_member_type#">
            </cfif>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#">
        </cf_box>
    </div>
    <script type="text/javascript">
        document.getElementById('keyword').focus();
        function addOrder(){
            document.sale_order_relation.submit();
        }
        function input_control(){
            if(!date_check(list_offer.start_date,list_offer.finish_date,'<cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>'))
            return false;
            <cfif not session.ep.our_company_info.unconditional_list>
                if(document.getElementById('keyword').value.length == 0 && document.getElementById('keyword_offerno').value.length == 0 &&(document.getElementById('member_name').value.length == 0 || document.getElementById('company_id').value.length == 0) && document.getElementById('consumer_id').value.length == 0 && (document.getElementById('sales_emp_id').value.length == 0 || document.getElementById('sales_emp').value.length == 0)&&(document.getElementById('start_date').value.length ==0 && document.getElementById('finish_date').value.length ==0) )
                    {
                        alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
                        return false;
                    }
                else return true;
            <cfelse>
                return true;
            </cfif>
        }
        <cfoutput>
            function myfunction(element,shade){
                if(filterNum(element.value,4)=='' || filterNum(element.value,4)==0)
                    element.value=commaSplit(1);
                if(filterNum(element.value,4)> shade)
                    {
                    alert("<cf_get_lang dictionary_id='58883.Maksimum Kalan Miktar'> : "+ shade + "\!");
                    element.value= shade;
                }
            }  
        </cfoutput> 
    </script>
    