<cf_xml_page_edit fuseact="service.list_service">
    <cfset list_subid="">
    <cfparam name="attributes.task_par_id" default="">
    <cfparam name="attributes.task_cmp_id" default="">
    <cfparam name="attributes.task_employee_id" default="">
    <cfparam name="attributes.task_person_name" default="">
    <cfparam name="attributes.service_add_option" default="">
    <cfparam name="attributes.adress_keyword" default="">
    <cfparam name="attributes.related_company_id" default="">
    <cfparam name="attributes.related_company" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.service_branch_id" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.product_cat_id" default="">
    <cfparam name="attributes.service_substatus_id" default="">
    <cfparam name="attributes.start_date2" default="">
    <cfparam name="attributes.finish_date2" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.service_status" default="1">
    <cfparam name="attributes.accessory" default="">
    <cfparam name="attributes.accessory_select" default="">
    <cfparam name="attributes.physical" default="">
    <cfparam name="attributes.physical_select" default="">
    <cfparam name="attributes.sales_zone_id" default="">
    <cfparam name="attributes.keyword" default=''>
    <cfparam name="attributes.keyword_no" default=''>
    <cfparam name="attributes.keyword_detail" default=''>
    <cfparam name="attributes.serial_no" default="">
    <cfparam name="attributes.doc_number" default="">
    
    <cfif isdefined("session.service_reply")>
        <cfscript>structdelete(session,"service_reply");</cfscript>
    </cfif>
    <cfif isdefined("session.service_task")>
        <cfscript>structdelete(session,"service_task");</cfscript>
    </cfif>
    <cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
        SELECT SERVICE_SUBSTATUS_ID,SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS 
    </cfquery>
        <cfquery name="get_sale_zones" datasource="#dsn#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
        </cfquery>
    <cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
            PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
            PROCESS_TYPE PT WITH (NOLOCK)
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
        ORDER BY 
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
        SELECT SERVICECAT,SERVICECAT_ID FROM SERVICE_APPCAT ORDER BY SERVICECAT
    </cfquery>
    <!---<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
        SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
    </cfquery>--->
    <cfquery name="GET_SERVICE_ADD_OPTION" datasource="#DSN3#">
        SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
    </cfquery>
        <cfquery name="GET_ACCESSORY" datasource="#DSN3#">
            SELECT ACCESSORY_ID,ACCESSORY FROM SERVICE_ACCESSORY
        </cfquery>
        <cfquery name="GET_PHY_DAM" datasource="#DSN3#">
            SELECT PHYSICAL_DAMAGE_ID,PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
        </cfquery>
    <cfinclude template="../query/get_priority.cfm">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = "">
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = "">
    </cfif>
    <cfif isdefined("attributes.start_date1") and isdate(attributes.start_date1)>
        <cf_date tarih = "attributes.start_date1">
    <cfelse>
        <cfset attributes.start_date1 = "">
    </cfif>
    <cfif isdefined("attributes.finish_date1") and isdate(attributes.finish_date1)>
        <cf_date tarih = "attributes.finish_date1">
    <cfelse>
        <cfset attributes.finish_date1 = "">
    </cfif>
    <cfif isdefined("attributes.start_date2") and isdate(attributes.start_date2)>
        <cf_date tarih = "attributes.start_date2">
    <cfelse>
        <cfset attributes.start_date2 = "">
    </cfif>
    <cfif isdefined("attributes.finish_date2") and isdate(attributes.finish_date2)>
        <cf_date tarih = "attributes.finish_date2">
    <cfelse>
        <cfset attributes.finish_date2 = "">
    </cfif>
        <cfinclude template="../query/get_branch.cfm">
        <cfset branch_list = valuelist(get_branch.branch_id)>
    
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfif isdefined("attributes.form_submitted")>
        <cfset serviceAction = createObject("component","V16.service.cfc.ServiceAction")>
        <cfset GET_SERVICE = serviceAction.list_service(   
                                                            brand_id : '#IIf(IsDefined("attributes.brand_id") and len(attributes.brand_id),"attributes.brand_id",DE(""))#',
                                                            brand_name : '#IIf(IsDefined("attributes.brand_name") and len(attributes.brand_name),"attributes.brand_name",DE(""))#',
                                                            product_cat_id : '#IIf(IsDefined("attributes.product_cat_id") and len(attributes.product_cat_id),"attributes.product_cat_id",DE(""))#',
                                                            product_cat : '#IIf(IsDefined("attributes.product_cat") and len(attributes.product_cat),"attributes.product_cat",DE(""))#',
                                                            keyword : '#IIf(IsDefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',
                                                            branch_list : '#IIf(IsDefined("branch_list") and len(branch_list),"branch_list",DE(""))#',
                                                            service_branch_id : '#IIf(IsDefined("attributes.service_branch_id") and len(attributes.service_branch_id),"attributes.service_branch_id",DE(""))#',
                                                            x_related_company_team : '#IIf(IsDefined("attributes.x_related_company_team") and len(attributes.x_related_company_team),"attributes.x_related_company_team",DE(0))#',
                                                            service_product_id : '#IIf(IsDefined("attributes.service_product_id") and len(attributes.service_product_id),"attributes.service_product_id",DE(""))#',
                                                            servicecat_id : '#IIf(IsDefined("attributes.servicecat_id") and len(attributes.servicecat_id),"attributes.servicecat_id",DE(""))#',
                                                            start_date : '#IIf(IsDefined("attributes.start_date") and len(attributes.start_date),"attributes.start_date",DE(""))#',
                                                            finish_date : '#IIf(IsDefined("attributes.finish_date") and len(attributes.finish_date),"attributes.finish_date",DE(""))#',
                                                            start_date1 : '#IIf(IsDefined("attributes.start_date1") and len(attributes.start_date1),"attributes.start_date1",DE(""))#',
                                                            finish_date1 : '#IIf(IsDefined("attributes.finish_date1") and len(attributes.finish_date1),"attributes.finish_date1",DE(""))#',
                                                            start_date2 : '#IIf(IsDefined("attributes.start_date2") and len(attributes.start_date2),"attributes.start_date2",DE(""))#',
                                                            finish_date2 : '#IIf(IsDefined("attributes.finish_date2") and len(attributes.finish_date2),"attributes.finish_date2",DE(""))#',
                                                            task_employee_id : '#IIf(IsDefined("attributes.task_employee_id") and len(attributes.task_employee_id),"attributes.task_employee_id",DE(""))#',
                                                            task_person_name : '#IIf(IsDefined("attributes.task_person_name") and len(attributes.task_person_name),"attributes.task_person_name",DE(""))#',
                                                            service_code : '#IIf(IsDefined("attributes.service_code") and len(attributes.service_code),"attributes.service_code",DE(""))#',
                                                            service_code_id : '#IIf(IsDefined("attributes.service_code_id") and len(attributes.service_code_id),"attributes.service_code_id",DE(""))#',
                                                            keyword_detail : '#IIf(IsDefined("attributes.keyword_detail") and len(attributes.keyword_detail),"attributes.keyword_detail",DE(""))#',
                                                            keyword_no : '#IIf(IsDefined("attributes.keyword_no") and len(attributes.keyword_no),"attributes.keyword_no",DE(""))#',
                                                            serial_no : '#IIf(IsDefined("attributes.serial_no") and len(attributes.serial_no),"attributes.serial_no",DE(""))#',
                                                            doc_number : '#IIf(IsDefined("attributes.doc_number") and len(attributes.doc_number),"attributes.doc_number",DE(""))#',
                                                            product : '#IIf(IsDefined("attributes.product") and len(attributes.product),"attributes.product",DE(""))#',
                                                            product_id : '#IIf(IsDefined("attributes.product_id") and len(attributes.product_id),"attributes.product_id",DE(""))#',
                                                            made_application : '#IIf(IsDefined("attributes.made_application") and len(attributes.made_application),"attributes.made_application",DE(""))#',
                                                            partner_id_ : '#IIf(IsDefined("attributes.partner_id_") and len(attributes.partner_id_),"attributes.partner_id_",DE(""))#',
                                                            consumer_id_ : '#IIf(IsDefined("attributes.consumer_id_") and len(attributes.consumer_id_),"attributes.consumer_id_",DE(""))#',
                                                            service_status : '#IIf(IsDefined("attributes.service_status") and len(attributes.service_status),"attributes.service_status",DE(1))#',
                                                            process_stage : '#IIf(IsDefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#',
                                                            priority : '#IIf(IsDefined("attributes.priority") and len(attributes.priority),"attributes.priority",DE(""))#',
                                                            adress_keyword : '#IIf(IsDefined("attributes.adress_keyword") and len(attributes.adress_keyword),"attributes.adress_keyword",DE(""))#',
                                                            ismyhome : '#IIf(IsDefined("attributes.ismyhome") and len(attributes.ismyhome),"attributes.ismyhome",DE(""))#',
                                                            company_id : '#IIf(IsDefined("attributes.company_id") and len(attributes.company_id),"attributes.company_id",DE(""))#',
                                                            consumer_id : '#IIf(IsDefined("attributes.consumer_id") and len(attributes.consumer_id),"attributes.consumer_id",DE(""))#',
                                                            other_service_app : '#IIf(IsDefined("attributes.other_service_app") and len(attributes.other_service_app),"attributes.other_service_app",DE(""))#',
                                                            partner_id : '#IIf(IsDefined("attributes.partner_id") and len(attributes.partner_id),"attributes.partner_id",DE(""))#',
                                                            service_id : '#IIf(IsDefined("attributes.service_id") and len(attributes.service_id),"attributes.service_id",DE(""))#',
                                                            employee_id : '#IIf(IsDefined("attributes.employee_id") and len(attributes.employee_id),"attributes.employee_id",DE(""))#',
                                                            subscription_id : '#IIf(IsDefined("attributes.subscription_id") and len(attributes.subscription_id),"attributes.subscription_id",DE(""))#',
                                                            subscription_no : '#IIf(IsDefined("attributes.subscription_no") and len(attributes.subscription_no),"attributes.subscription_no",DE(""))#',
                                                            service_add_option : '#IIf(IsDefined("attributes.service_add_option") and len(attributes.service_add_option),"attributes.service_add_option",DE(""))#',
                                                            related_company_id : '#IIf(IsDefined("attributes.related_company_id") and len(attributes.related_company_id),"attributes.related_company_id",DE(""))#',
                                                            related_company : '#IIf(IsDefined("attributes.related_company") and len(attributes.related_company),"attributes.related_company",DE(""))#',
                                                            other_company_id : '#IIf(IsDefined("attributes.other_company_id") and len(attributes.other_company_id),"attributes.other_company_id",DE(""))#',
                                                            other_company_name : '#IIf(IsDefined("attributes.other_company_name") and len(attributes.other_company_name),"attributes.other_company_name",DE(""))#',
                                                            member_name : '#IIf(IsDefined("attributes.member_name") and len(attributes.member_name),"attributes.member_name",DE(""))#',
                                                            service_substatus_id : '#IIf(IsDefined("attributes.service_substatus_id") and len(attributes.service_substatus_id),"attributes.service_substatus_id",DE(""))#',
                                                            product_code : '#IIf(IsDefined("attributes.product_code") and len(attributes.product_code),"attributes.product_code",DE(""))#',
                                                            service_county_id : '#IIf(IsDefined("attributes.service_county_id") and len(attributes.service_county_id),"attributes.service_county_id",DE(""))#',
                                                            service_county_name : '#IIf(IsDefined("attributes.service_county_name") and len(attributes.service_county_name),"attributes.service_county_name",DE(""))#',
                                                            service_city_id : '#IIf(IsDefined("attributes.service_city_id") and len(attributes.service_city_id),"attributes.service_city_id",DE(""))#',
                                                            project_id : '#IIf(IsDefined("attributes.project_id") and len(attributes.project_id),"attributes.project_id",DE(""))#',
                                                            project_head : '#IIf(IsDefined("attributes.project_head") and len(attributes.project_head),"attributes.project_head",DE(""))#',
                                                            record_emp_id : '#IIf(IsDefined("attributes.record_emp_id") and len(attributes.record_emp_id),"attributes.record_emp_id",DE(""))#',
                                                            record_emp_name : '#IIf(IsDefined("attributes.record_emp_name") and len(attributes.record_emp_name),"attributes.record_emp_name",DE(""))#',
                                                            accessory : '#IIf(IsDefined("attributes.accessory") and len(attributes.accessory),"attributes.accessory",DE(""))#',
                                                            accessory_select : '#IIf(IsDefined("attributes.accessory_select") and len(attributes.accessory_select),"attributes.accessory_select",DE(""))#',
                                                            physical : '#IIf(IsDefined("attributes.physical") and len(attributes.physical),"attributes.physical",DE(""))#',
                                                            physical_select : '#IIf(IsDefined("attributes.physical_select") and len(attributes.physical_select),"attributes.physical_select",DE(""))#',
                                                            x_control_ims : '#IIf(IsDefined("attributes.x_control_ims") and len(attributes.x_control_ims),"attributes.x_control_ims",DE(""))#',
                                                            startrow : '#IIf(IsDefined("attributes.startrow") and len(attributes.startrow),"attributes.startrow",DE(""))#',
                                                            maxrows : '#IIf(IsDefined("attributes.maxrows") and len(attributes.maxrows),"attributes.maxrows",DE(""))#'
                                                        )>
    <cfelse>
          <cfset get_service.recordcount = 0>	
        <cfset get_service.QUERY_COUNT = 0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_service.QUERY_COUNT#">
    
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="list_service" method="post" action="#request.self#?fuseaction=service.list_service">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <cf_box_search>
                    <div class="form-group">
                        <cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Konu',57480)#" maxlength="50" value="#attributes.keyword#" style="width:80px;">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="keyword_no" id="keyword_no" placeholder="#getLang('','No',57487)#" maxlength="50" value="#attributes.keyword_no#" style="width:80px;">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="keyword_detail" id="keyword_detail" placeholder="#getLang('','Açıklama',57629)#" maxlength="50" value="#attributes.keyword_detail#" style="width:80px;">
                    </div>
                    <cfif session.ep.our_company_info.guaranty_followup eq 1>
                    <div class="form-group">
                        <cfinput type="text" name="serial_no" id="serial_no" placeholder="#getLang('','Seri No',57637)#" maxlength="50" value="#attributes.serial_no#" style="width:80px;">
                    </div>
                    </cfif>
                    <div class="form-group">
                        <select name="process_stage" id="process_stage">
                        <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                            <cfoutput query="get_process_stage">
                                <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="service_status" id="service_status">
                            <option value="2" <cfif isdefined("attributes.service_status") and attributes.service_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1" <cfif isdefined("attributes.service_status") and attributes.service_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                            <option value="0" <cfif isdefined("attributes.service_status") and attributes.service_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='kontrol()'>
                    </div>
                </cf_box_search>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-adress_keyword">
                            <label class="col col-12"><cf_get_lang dictionary_id='41729.Servis Adresi'></label>
                            <div class="col col-12">
                                <cfinput type="text"  name="adress_keyword" id="adress_keyword" value="#attributes.adress_keyword#" maxlength="50" style="width:80px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-service_add_option">
                            <label class="col col-12"><cf_get_lang dictionary_id='41655.Özel Tanım'></label>
                            <div class="col col-12">
                                <select name="service_add_option" id="service_add_option" style="width:135px;">
                                    <option value=""><cf_get_lang dictionary_id='41655.Özel Tanım'></option>
                                    <cfoutput query="get_service_add_option">
                                        <option value="#service_add_option_id#" <cfif attributes.service_add_option eq service_add_option_id>selected</cfif>>#service_add_option_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-doc_number">
                            <label class="col col-12"><cf_get_lang dictionary_id='41821.Kabul Belge No'></label>
                            <div class="col col-12">
                                <cfinput type="text" name="doc_number" id="doc_number" value="#attributes.doc_number#" maxlength="255" style="width:80px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-made_application">
                            <label class="col col-12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id_" id="employee_id_" value="<cfif isdefined("attributes.employee_id_")><cfoutput>#attributes.employee_id_#</cfoutput></cfif>">
                                    <input type="hidden" name="partner_id_" id="partner_id_" value="<cfif isdefined("attributes.partner_id_")><cfoutput>#attributes.partner_id_#</cfoutput></cfif>">
                                    <input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined("attributes.consumer_id_")><cfoutput>#attributes.consumer_id_#</cfoutput></cfif>">
                                    <input name="made_application" type="text" id="made_application" style="width:80px;" onfocus="AutoComplete_Create('made_application','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,CONSUMER_ID','partner_id_,consumer_id_','','3','250');" onchange="alan_kontrol();" value="<cfif isdefined("attributes.made_application")><cfoutput>#attributes.made_application#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                                    <cfif get_module_user(47)>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_location=service&field_emp_id=list_service.employee_id_&field_partner=list_service.partner_id_&field_consumer=list_service.consumer_id_&field_name=list_service.made_application&select_list=7,8&keyword='+encodeURIComponent(document.list_service.made_application.value));"></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-record_emp_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                    <input name="record_emp_name" type="text" id="record_emp_name" style="width:80px;" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','','3','135');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=list_service.record_emp_name&field_emp_id=list_service.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-related_company">
                            <label class="col col-12"><cf_get_lang dictionary_id='41664.İş Ortağı'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="related_company_id" id="related_company_id" value="<cfif isdefined("attributes.related_company_id")><cfoutput>#attributes.related_company_id#</cfoutput></cfif>">
                                    <input type="text" name="related_company" id="related_company" style="width:80px;" value="<cfif isdefined("attributes.related_company")><cfoutput>#attributes.related_company#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('related_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','related_company_id','','3','250');" autocomplete="off">
                                    <cfif get_module_user(47)>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_location=service&field_comp_id=list_service.related_company_id&field_comp_name=list_service.related_company&select_list=7&keyword='+encodeURIComponent(document.list_service.related_company.value));"></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-product_cat">
                            <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif isDefined("attributes.product_cat_id")><cfoutput>#attributes.product_cat_id#</cfoutput></cfif>">
                                    <input type="hidden" name="product_code" id="product_code" value="<cfif isDefined("attributes.product_code")><cfoutput>#attributes.product_code#</cfoutput></cfif>">
                                    <input type="text" name="product_cat" id="product_cat" style="width:80px; " value="<cfif isDefined("attributes.product_cat")><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_service.product_cat_id&field_code=list_service.product_code&field_name=list_service.product_cat</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-service_code">
                            <label class="col col-12"><cf_get_lang dictionary_id='58934.Arıza Kodu'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="service_defect_code" id="service_defect_code" value="<cfif isdefined("attributes.service_defect_code")><cfoutput>#attributes.service_defect_code#</cfoutput></cfif>">
                                    <input type="hidden" name="service_code_id" id="service_code_id" value="<cfif isdefined("attributes.service_code_id")><cfoutput>#attributes.service_code_id#</cfoutput></cfif>">
                                    <input type="text" name="service_code" id="service_code" value="<cfif isdefined("attributes.service_code")><cfoutput>#attributes.service_code#</cfoutput></cfif>" style="width:80px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=service.popup_service_defect_codes&service_code_id=list_service.service_code_id&service_code=list_service.service_code&service_defect_code=list_service.service_defect_code&keyword='+encodeURIComponent(document.list_service.service_code.value));"></span>
                                </div>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.subscription_contract eq 1>
                        <div class="form-group" id="item-subscription_no">
                            <label class="col col-12"><cf_get_lang dictionary_id='29502.Sistem'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
                                    <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:80px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','100');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=list_service.subscription_id&field_no=list_service.subscription_no'</cfoutput>);"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-service_branch_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12">
                                <cf_wrkdepartmentbranch fieldid='service_branch_id' is_branch='1' width='135' is_deny_control='1' selected_value='#attributes.service_branch_id#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-product">
                            <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id")><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
                                    <input type="text" name="product" id="product" style="width:80px;" onfocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" value="<cfif isdefined("attributes.product")><cfoutput>#attributes.product#</cfoutput></cfif>" autocomplete="off">
                                    <cfif get_module_user(47)>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=list_service.stock_id&product_id=list_service.product_id&field_name=list_service.product&keyword='+encodeURIComponent(document.list_service.product.value));"></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-servicecat_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-12">
                                <select name="servicecat_id" id="servicecat_id" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                                    <cfoutput query="get_service_appcat">
                                        <option value="#get_service_appcat.servicecat_id#" <cfif isdefined("attributes.servicecat_id") and attributes.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                    </cfoutput>			  
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-service_substatus_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
                            <div class="col col-12">
                                <select name="service_substatus_id" id="service_substatus_id" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id='58973.Alt Aşama'></option>
                                    <cfoutput query="get_service_substatus">
                                        <option value="#service_substatus_id#" <cfif isdefined("attributes.service_substatus_id") and attributes.service_substatus_id eq service_substatus_id> selected</cfif>>#service_substatus#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-priority">
                            <label class="col col-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                            <div class="col col-12">
                                <cfquery name="GET_PRIORITIES" datasource="#DSN#">
                                    SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY_ID
                                </cfquery>
                                <select name="priority" id="priority" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id='57485.Öncelik'></option>
                                    <cfoutput query="get_priorities">
                                        <option value="#priority_id#" <cfif isDefined("attributes.priority") and attributes.priority eq priority_id>selected</cfif>>#priority#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-sales_zone_id">
                                    <label class="col col-12"><cf_get_lang dictionary_id ='57659.Satis bolgesi'></label>
                                    <div class="col col-12">
                                        <select name="sales_zone_id" id="sales_zone_id" style="width:100px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_sale_zones">
                                                <option value="#sz_id#" <cfif attributes.sales_zone_id eq sz_id>selected</cfif>>#sz_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-other_company_name">
                                    <label class="col col-12"><cf_get_lang dictionary_id='41647.İlgili Bayi'></label>
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <input type="hidden" name="other_company_id" id="other_company_id" value="<cfif isdefined("attributes.other_company_id")><cfoutput>#attributes.other_company_id#</cfoutput></cfif>">
                                            <input type="text" name="other_company_name" id="other_company_name" style="width:80px;" value="<cfif isdefined("attributes.other_company_name")><cfoutput>#attributes.other_company_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('other_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','other_company_id','','3','250');" autocomplete="off">
                                            <cfif get_module_user(47)>
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_location=service&field_comp_id=list_service.other_company_id&field_comp_name=list_service.other_company_name&select_list=7&keyword='+encodeURIComponent(document.list_service.other_company_name.value));"></span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <cfquery name="GET_CITY" datasource="#DSN#">
                                    SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
                                </cfquery>
                                <div class="form-group" id="item-service_city_id">
                                    <label class="col col-12"><cf_get_lang dictionary_id='58608.İl'></label>
                                    <div class="col col-12">
                                        <select name="service_city_id" id="service_city_id" style="width:100px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_city">
                                                <option value="#city_id#" <cfif isdefined("attributes.service_city_id") and attributes.service_city_id eq city_id>selected</cfif>>#city_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-service_county_name">
                                    <label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)>
                                                <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_county_id#">
                                                    </cfquery>
                                                <cfset county_ = get_county.county_name>
                                            <cfelse>
                                                <cfset county_ = "">
                                            </cfif>
                                            <input type="text" name="service_county_name" id="service_county_name" value="<cfoutput>#county_#</cfoutput>" style="width:80px;">
                                            <input type="hidden" name="service_county_id" id="service_county_id" value="<cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)><cfoutput>#attributes.service_county_id#</cfoutput></cfif>">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac();"></span>
                                        </div>
                                    </div>
                                </div>
                        <div class="form-group" id="item-brand_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="brand_id" id="brand_id" value="<cfif isDefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
                                    <input type="text" name="brand_name" id="brand_name" style="width:80px;" value="<cfif isDefined("attributes.brand_name")><cfoutput>#attributes.brand_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=list_service.brand_id&brand_name=list_service.brand_name');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-physical">
                            <label class="col col-12"><cf_get_lang dictionary_id="41870.Fiz Hasar"></label>
                            <div class="col col-12">
                                    <cf_multiselect_check 
                                        option_text=#getLang('service',228)#
                                        query_name="GET_PHY_DAM"  
                                        name="physical_select"
                                        width="140" 
                                        height="150"
                                        option_value="PHYSICAL_DAMAGE_ID"
                                        option_name="PHYSICAL_DAMAGE" value="#attributes.physical_select#">
                            </div>
                        </div>
                        <div class="form-group" id="item-start_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
                                    <cfif session.ep.our_company_info.unconditional_list>
                                        <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">				
                                    <cfelse>
                                        <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
                                    </cfif>										
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-task_person_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input name="task_person_name" type="text" id="task_person_name" style="width:80px;"  onfocus="AutoComplete_Create('task_person_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','task_employee_id','','3','125','return_company()');" value="<cfif len(attributes.task_person_name) and (len(attributes.task_employee_id) or len(attributes.task_cmp_id))><cfoutput>#attributes.task_person_name#</cfoutput></cfif>" autocomplete="off">
                                    <input type="hidden" name="task_par_id" id="task_par_id" value="<cfif len(attributes.task_par_id)><cfoutput>#attributes.task_par_id#</cfoutput></cfif>">
                                    <input type="hidden" name="task_cmp_id" id="task_cmp_id" value="<cfif len(attributes.task_cmp_id)><cfoutput>#attributes.task_cmp_id#</cfoutput></cfif>">
                                    <input type="hidden" name="task_employee_id" id="task_employee_id" style="width:100px;" value="<cfif len(attributes.task_employee_id)><cfoutput>#attributes.task_employee_id#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=list_service.task_par_id&field_comp_id=list_service.task_cmp_id&field_name=list_service.task_person_name&field_emp_id=list_service.task_employee_id&select_list=1</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-start_date2">
                            <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-12">
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
                                        <cfinput type="text" name="start_date2" id="start_date2" value="#dateformat(attributes.start_date2,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:65px;" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date2"></span>
                                    </div>
                                </div>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfinput type="text" name="finish_date2" id="finish_date2" value="#dateformat(attributes.finish_date2,dateformat_style)#" validate="#validate_style#" style="width:65px;" message="#message#" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date2"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-start_date1">
                            <label class="col col-12"><cf_get_lang dictionary_id='41672.Kabul Tarihi'></label>
                            <div class="col col-12">
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(attributes.start_date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date1"></span>
                                    </div>
                                </div>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="finish_date1" id="finish_date1" value="#dateformat(attributes.finish_date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date1"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">	
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                    <input name="member_name" type="text" id="member_name"  style="width:80px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=list_service.consumer_id&field_comp_id=list_service.company_id&field_member_name=list_service.member_name&field_type=list_service.member_type">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.list_service.member_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_head">
                            <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input name="project_head" type="text" id="project_head" style="width:80px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','120');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');" title="<cf_get_lang dictionary_id ='58797.Proje Seçiniz'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finish_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
                                    <cfif session.ep.our_company_info.unconditional_list>
                                        <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
                                    <cfelse>
                                        <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
                                    </cfif>									
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_search_detail>
            </cfform>
        </cf_box>
        <cfsavecontent variable="head"><cf_get_lang dictionary_id='30039.Servis Başvurular'></cfsavecontent>
        <cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_service_id', print_type : 51 }#">
            <form name="send_print">
                <cf_grid_list>
                    <thead id="servis_listesi">
                        <tr>
                            <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='41821.Kabul Belge No'></th>
                            <th><cf_get_lang dictionary_id='29502.Sistem No'></th>
                            <th><cf_get_lang dictionary_id='29514.Başvuru Sahibi'></th>
                            <th><cf_get_lang dictionary_id='57480.Konu'></th>
                                <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                                <th><cf_get_lang dictionary_id='58973.Alt Aşama'></th>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='58608.İl'></th>
                            <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                            <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <th><cf_get_lang dictionary_id='57482.Aşama'></th> 
                            <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                            <th title="<cf_get_lang dictionary_id='57700.Bitiş Tarihi'> - <cf_get_lang dictionary_id='49293.Kabul Tarihi'>" style="text-align:left;"><cf_get_lang dictionary_id='41684.Bitiş Süresi (Saat)'></th>
                            <th><cf_get_lang dictionary_id='57416.Proje'></th>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th> 
                            <!-- sil -->
                            <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_service&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                            <!-- sil -->    
                                <cfif isdefined("attributes.form_submitted") and get_service.recordcount>   
                                    <th width="20" class="text-center header_icn_none">
                                        <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_service_id');">
                                </cfif>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif get_service.recordcount>
                        <cfoutput query="get_service">
                                <tr>
                                    <td>#ROWNUM#</td>
                                    <td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#&service_no=#get_service.service_no#" class="tableyazi">#get_service.service_no#</a></td>
                                    <td>#get_service.doc_no#</td>
                                        <td><cfif len(subscription_id)>#subscription_no#</cfif></td> 
                                    <td>
                                      <!---   <cfif len(applicator_comp_name)>
                                            <cfif len(service_company_id) and (service_company_id neq 0)>
                                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#service_company_id#','medium');" class="tableyazi">#applicator_comp_name#</a> -
                                            <cfelse>
                                                #applicator_comp_name# - 
                                            </cfif>
                                        </cfif> --->
                                        <cfif len(service_consumer_id) and (service_consumer_id neq 0)>
                                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#service_consumer_id#','medium');" class="tableyazi">#get_cons_info(service_consumer_id,1,1,0)#</a>
                                        <cfelseif len(service_partner_id) and (service_partner_id neq 0)>
                                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#service_partner_id#','medium');" class="tableyazi">#get_par_info(service_partner_id,0,1,0)#</a>
                                        <cfelseif len(service_employee_id) and (service_employee_id neq 0)>
                                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#service_employee_id#','medium');" class="tableyazi">#applicator_name#</a>
                                        <cfelse>
                                            #applicator_name#
                                        </cfif>
                                    </td>
                                    <td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi"> #service_head#</a></td>
                                    <td>#servicecat#<cfif len(service_substatus_id)>#SERVICE_SUBSTATUS#</cfif></td>
                                    <td><cfif len(service_substatus_id)>#SERVICE_SUBSTATUS#</cfif></td>
                                    <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product&pid=#get_service.service_product_id#','medium');" class="tableyazi">#get_service.product_name#</a></td>
                                    <td>#pro_serial_no#</td>
                                    </cfif> 
                                    <td><cfif len(service_city_id)>#city_name#</cfif></td>
                                    <td><cfif len(service_county_id)>#county_name#</cfif></td>
                                    <td><cfif len(service_branch_id)>#branch_name#</cfif></td>
                                    <td><font color="#color#">#stage#</font></td>
                                    <td>
                                        <cfif len(record_member)>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_member#','medium');" class="tableyazi"> 
                                            #employee_name# #employee_surname#</a> 
                                        </cfif>
                                    
                                        <cfif len(record_par)>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#record_par#','medium');" class="tableyazi"> 
                                            #company_partner_name# #company_partner_surname#</a> 
                                        </cfif>
                                    </td>
                                        <td style="text-align:center;">
                                            <cfif len(get_service.start_date) and get_service.start_date lt get_service.finish_date>
                                                <cfset startdate=date_add("H",session.ep.time_zone,get_service.start_date)>
                                                <cfif len(get_service.finish_date)>
                                                    <cfset finishdate=date_add("H",session.ep.time_zone,get_service.finish_date)>
                                                    <cfif len(startdate) and len(finishdate)>
                                                        <cfset saat=DATEDIFF('h',startdate,finishdate)>
                                                        <cfset minute_=DATEDIFF('N',startdate,finishdate) mod 60>
                                                        <cfset saat_ = minute_ / 60>
                                                        <cfset toplam_saat = saat + saat_>
                                                    </cfif>
                                                    <cfif len(startdate) and len(finishdate)>#tlformat(toplam_saat)#</cfif>
                                                </cfif>
                                            <cfelse>
                                                -
                                            </cfif>
                                        </td>
                                        <td>
                                            <cfif isdefined("get_service.project_id") and len(get_service.project_id)>
                                                <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a></td>
                                            <cfelse>
                                                <cf_get_lang dictionary_id='58459.projesiz'>
                                            </cfif>
                                        </td>
                                    <td>
                                        <cfif Len(apply_date)>
                                            <cfset adate=date_add("H",session.ep.time_zone,apply_date)>
                                            <cfset ahour=datepart("H",adate)>
                                            <cfset aminute=datepart("N",adate)>
                                            #dateformat(adate,dateformat_style)#
                                            #timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#
                                        </cfif>
                                    </td>
                                    <cfset COL=COLOR>
                                    <!-- sil -->
                                    <td style="text-align:center">
                                        <a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#service_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    </td>
                                    <!-- sil -->
                                    <td style="text-align:center"><input type="checkbox" name="print_service_id" id="print_service_id" value="#service_id#"></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <cfset colspan = 22>
                            <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <tr>
                                <td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td>
                            </tr>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </form>
    <cfset adres="service.list_service">
    <cfif len(attributes.keyword)>
        <cfset adres="#adres#&keyword=#URLEncodedFormat(attributes.keyword)#">
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset adres="#adres#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif isdefined("attributes.vergi_no") and len(attributes.vergi_no)>
        <cfset adres="#adres#&vergi_no=#attributes.vergi_no#">
    </cfif>
    <cfif isdefined("attributes.service_status") and len(attributes.service_status)>
        <cfset adres="#adres#&service_status=#attributes.service_status#">
    </cfif>
    <cfif isdefined("attributes.service_substatus_id") and len(attributes.service_substatus_id)>
        <cfset adres="#adres#&service_substatus_id=#attributes.service_substatus_id#">
    </cfif>
    <cfif isdefined("attributes.service_branch_id") and len(attributes.service_branch_id)>
        <cfset adres="#adres#&service_branch_id=#attributes.service_branch_id#">
    </cfif>
    <cfif isdefined("attributes.servicecat_id") and len(attributes.servicecat_id)>
        <cfset adres="#adres#&servicecat_id=#attributes.servicecat_id#">
    </cfif>
    <cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
        <cfset adres="#adres#&serial_no=#attributes.serial_no#">
    </cfif>
    <cfif isdefined("attributes.doc_number") and len(attributes.doc_number)>
        <cfset adres="#adres#&doc_number=#attributes.doc_number#">
    </cfif>
    <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
        <cfset adres="#adres#&process_stage=#attributes.process_stage#">
    </cfif>
    <cfif isdefined("attributes.priority") and len(attributes.priority)>
        <cfset adres="#adres#&priority=#attributes.priority#">
    </cfif>
    <cfif isdefined("attributes.service_add_option") and len(attributes.service_add_option)>
        <cfset adres = "#adres#&service_add_option=#attributes.service_add_option#">
    </cfif>		
    <cfif isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
        <cfset adres="#adres#&subscription_id=#attributes.subscription_id#">
        <cfset adres="#adres#&subscription_no=#attributes.subscription_no#">
    </cfif>
    <cfif isdefined("attributes.product") and len(attributes.product)>
        <cfset adres="#adres#&product_id=#attributes.product_id#">
        <cfset adres="#adres#&stock_id=#attributes.stock_id#">
        <cfset adres="#adres#&product=#attributes.product#">
    </cfif>
    <cfif isDefined('attributes.start_date') and len(attributes.start_date)>
        <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
    </cfif>
    <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>
        <cfset adres="#adres#&sales_zone_id=#attributes.sales_zone_id#">
    </cfif>
    <cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
        <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
    </cfif>
    <cfif isDefined('attributes.start_date1') and len(attributes.start_date1)>
        <cfset adres = "#adres#&start_date1=#dateformat(attributes.start_date1,dateformat_style)#" >
    </cfif>
    <cfif isDefined('attributes.finish_date1') and len(attributes.finish_date1)>
        <cfset adres = "#adres#&finish_date1=#dateformat(attributes.finish_date1,dateformat_style)#" >
    </cfif>
    <cfif isDefined('attributes.start_date2') and len(attributes.start_date2)>
        <cfset adres = "#adres#&start_date2=#dateformat(attributes.start_date2,dateformat_style)#" >
    </cfif>
    <cfif isDefined('attributes.finish_date2') and len(attributes.finish_date2)>
        <cfset adres = "#adres#&finish_date2=#dateformat(attributes.finish_date2,dateformat_style)#" >
    </cfif>
    <cfif isdefined("attributes.made_application") and len(attributes.made_application)>
        <cfset adres="#adres#&made_application=#attributes.made_application#">
        <cfif isdefined("attributes.partner_id_") and len(attributes.partner_id_)>
            <cfset adres="#adres#&partner_id_=#attributes.partner_id_#">
        </cfif>
        <cfif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
            <cfset adres="#adres#&consumer_id_=#attributes.consumer_id_#">
        </cfif>
    </cfif>
    <cfif len(attributes.task_person_name)>
        <cfset adres="#adres#&task_person_name=#attributes.task_person_name#">
        <cfif len(attributes.task_par_id)>
            <cfset adres="#adres#&task_par_id=#attributes.task_par_id#">
        </cfif>
        <cfif len(attributes.task_cmp_id)>
            <cfset adres="#adres#&task_cmp_id=#attributes.task_cmp_id#">
        </cfif>
        <cfif len(attributes.task_employee_id)>
            <cfset adres="#adres#&task_employee_id=#attributes.task_employee_id#">
        </cfif>
    </cfif>
    <cfif isDefined("attributes.service_code") and len(attributes.service_code)>
        <cfset adres="#adres#&service_defect_code=#attributes.service_defect_code#&service_code_id=#attributes.service_code_id#&service_code=#attributes.service_code#">
    </cfif>
    <cfif isdefined("attributes.company_id") and len(company_id) and isdefined("attributes.member_name") and len(attributes.member_name)>
        <cfset adres = "#adres#&company_id=#attributes.company_id#&member_name=#attributes.member_name#">
    </cfif>	
    <cfif isdefined("attributes.consumer_id") and len(consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name)>
        <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&member_name=#attributes.member_name#">
    </cfif>	
    <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
        <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
    </cfif>	
    
    <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
        <cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
    </cfif>	
    <cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id) and isdefined("attributes.product_cat") and len(attributes.product_cat)>
        <cfset adres = "#adres#&product_cat_id=#attributes.product_cat_id#&product_cat=#attributes.product_cat#">
    </cfif>	
    <cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id) and isdefined("attributes.related_company") and len(attributes.related_company)>
        <cfset adres = "#adres#&related_company_id=#attributes.related_company_id#&related_company=#attributes.related_company#">
    </cfif>
    <cfif isdefined("attributes.other_company_id") and len(attributes.other_company_id) and isdefined("attributes.other_company_name") and len(attributes.other_company_name)>
        <cfset adres = "#adres#&other_company_id=#attributes.other_company_id#&other_company_name=#attributes.other_company_name#">
    </cfif>	
    <cfif isDefined('attributes.accessory') and len(attributes.accessory)>
        <cfset adres = "#adres#&accessory=#attributes.accessory#">
    </cfif>
    <cfif isDefined('attributes.accessory_select') and len(attributes.accessory_select)>
        <cfset adres = "#adres#&accessory_select=#attributes.accessory_select#">
    </cfif>
    <cfif isDefined('attributes.physical') and len(attributes.physical)>
        <cfset adres = "#adres#&physical=#attributes.physical#">
    </cfif>
    <cfif isDefined('attributes.physical_select') and len(attributes.physical_select)>
        <cfset adres = "#adres#&physical_select=#attributes.physical_select#">
    </cfif>
    <cfif isdefined("attributes.service_county_id")>
        <cfset adres = "#adres#&service_city_id=#attributes.service_city_id#">
        <cfset adres = "#adres#&service_county_id=#attributes.service_county_id#">
        <cfset adres = "#adres#&service_county_name=#attributes.service_county_name#">
    </cfif>
    <cfif isDefined('attributes.record_emp_name') and len(attributes.record_emp_name)>
        <cfset adres = '#adres#&record_emp_id=#attributes.record_emp_id#'>
        <cfset adres = '#adres#&record_emp_name=#attributes.record_emp_name#'>
    </cfif>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#">
    </cf_box>
    </div>
    <script type="text/javascript">
        document.getElementById('keyword').focus();
            function pencere_ac(no)
            {
                if (document.list_service.service_city_id[document.list_service.service_city_id.selectedIndex].value == "")
                    alert("<cf_get_lang dictionary_id='34431.İlk Olarak İl Seçiniz!'>");
                else
                    openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=list_service.service_county_id&field_name=list_service.service_county_name&city_id=' + document.list_service.service_city_id.value);
            }
        function send_services_print()
        {
            <cfif not get_service.recordcount>
                alert("<cf_get_lang dictionary_id='41688.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>");
                return false;
            </cfif>
            <cfif get_service.recordcount eq 1>
                if(document.send_print.service_id_list.checked == false)
                    {
                    alert("<cf_get_lang dictionary_id='41688.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>");
                    return false;
                    }
                else
                    {
                    service_list_ = document.send_print.service_id_list.value;
                    }
            </cfif>
            <cfif get_service.recordcount gt 1>
                service_list_ = "";
                for (i=0; i < document.send_print.service_id_list.length; i++)
                {
                    if(document.send_print.service_id_list[i].checked == true)
                        {
                        service_list_ = service_list_ + document.send_print.service_id_list[i].value + ',';
                        }	
                }
                if(service_list_.length == 0)
                    {
                    alert("<cf_get_lang dictionary_id='41688.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>");
                    return false;
                    }
            </cfif>
            
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=51&iid='+service_list_,'page');
        }
        function return_company()
        {
            var emp_id=document.getElementById('task_employee_id').value;
            var GET_COMPANY=wrk_safe_query('srv_get_cmpny','dsn',0,emp_id);
            document.getElementById('task_cmp_id').value=GET_COMPANY.COMP_ID;
        }
        function alan_kontrol()
        {
            document.list_service.partner_id_.value='';
            document.list_service.consumer_id_.value='';
        }
        function kontrol()
        {
            if( !date_check(document.list_service.start_date, document.list_service.finish_date, "<cf_get_lang dictionary_id='41884.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
                return false;
            else
                return true;
        }
    </script>
    