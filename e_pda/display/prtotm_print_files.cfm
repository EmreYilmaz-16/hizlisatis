<cfsetting showdebugoutput="no">
<cfquery name="GET_DET_FORM" datasource="#iif(fusebox.use_period,'dsn3','dsn')#">
SELECT SPF.IS_XML
	,SPF.TEMPLATE_FILE
	,SPF.PROCESS_TYPE
	,SPF.FORM_ID
	,SPF.IS_DEFAULT
	,SPF.NAME
	,SPF.PROCESS_TYPE
	,SPF.MODULE_ID
	,SPFC.PRINT_NAME
FROM SETUP_PRINT_FILES SPF
	,#dsn#.SETUP_PRINT_FILES_CATS SPFC
	,#dsn#.WRK_MODULE MOD
WHERE SPF.ACTIVE = 1
	AND SPF.MODULE_ID = MOD.MODULE_ID
	AND SPFC.PRINT_TYPE = SPF.PROCESS_TYPE
	AND SPFC.PRINT_TYPE = #attributes.print_type#
ORDER BY SPF.IS_XML
	,SPF.NAME
</cfquery>
<cfdump  var="#GET_DET_FORM#">
<cfif get_det_form.recordcount>
	<cfquery name="GET_DEFAULT_" dbtype="query">
		SELECT FORM_ID FROM GET_DET_FORM WHERE IS_DEFAULT = 1
	</cfquery>
	<cfset attributes.form_type = get_default_.form_id>
</cfif>
<cfset adres = "epda.emptypopup_prtotm_print_files_inner">
<cfif isdefined("attributes.iid") and len(attributes.iid)>
	<cfset adres = "#adres#&iid=#attributes.iid#">
</cfif>

<!--- Silme !!! Tatmetal icin eklendi. Bizdede gerekirse ikinci degiskenler icin kullanilabilir. BK 20081218 --->
<cfif isdefined("attributes.iiid") and len(attributes.iiid)>
	<cfset adres = "#adres#&iiid=#attributes.iiid#">
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset adres = "#adres#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
	<cfset adres = "#adres#&action_type=#attributes.action_type#">
</cfif>
<cfif isdefined("attributes.action_table") and len(attributes.action_table)>
	<cfset adres = "#adres#&action_table=#attributes.action_table#">
</cfif>
<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
	<cfset adres = "#adres#&action_row_id=#attributes.action_row_id#">
</cfif>
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfset adres = "#adres#&date1=#attributes.date1#">
</cfif>
<cfif isdefined("attributes.date2") and len(attributes.date2)>
	<cfset adres = "#adres#&date2=#attributes.date2#">
</cfif>
<cfif isdefined("attributes.action_date1") and len(attributes.action_date1)>
	<cfset adres = "#adres#&action_date1=#attributes.action_date1#">
</cfif>
<cfif isdefined("attributes.action_date2") and len(attributes.action_date2)>
	<cfset adres = "#adres#&action_date2=#attributes.action_date2#">
</cfif>
<cfif isdefined("attributes.money_info") and len(attributes.money_info)>
	<cfset adres = "#adres#&money_info=#attributes.money_info#">
</cfif>
<cfif isdefined("attributes.money_type_info") and len(attributes.money_type_info)>
	<cfset adres = "#adres#&money_type_info=#attributes.money_type_info#">
</cfif>
<cfif isdefined("attributes.is_pay_cheques") and len(attributes.is_pay_cheques)>
	<cfset adres = "#adres#&is_pay_cheques=#attributes.is_pay_cheques#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.print_type") and len(attributes.print_type)>
	<cfset adres = "#adres#&print_type=#attributes.print_type#">
</cfif>
<cfif isdefined("attributes.row_consumer") and len(attributes.row_consumer)>
	<cfset adres = "#adres#&row_consumer=#attributes.row_consumer#">
</cfif>
<cfif isdefined("attributes.row_company") and len(attributes.row_company)>
	<cfset adres = "#adres#&row_company=#attributes.row_company#">
</cfif>
<cfif isdefined("attributes.checked_value") and len(attributes.checked_value)><!--- Banka talimatları listesindeki toplu printde kullanılıyor silmeyiniz --->
	<cfset adres = "#adres#&checked_value=#attributes.checked_value#">
</cfif>
<cfparam name="attributes.form_kontrol" default="">
<!-- sil -->
<cfsavecontent variable="right">
<cfform name="page_print" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files&is_special=1">
    <select name="form_type" id="form_type" style="width:200px;"  onchange="javascript:iframe_gonder();">
        <option value=""><cf_get_lang_main no='380.Modül İçi Yazıcı Belgeleri'></option>
        <cfoutput query="get_det_form">
            <option <cfif IS_XML eq 1>style="color:0000FF"</cfif> value="<cfif IS_XML eq 1>1<cfelse>0</cfif>,#form_id#" <cfif IS_DEFAULT eq 1>selected</cfif> >#name# - #print_name#</option> 
        </cfoutput>
    </select>
    <a href="javascript://" onclick="iframe_yazdir();"><img src="/images/print.gif" border="0"></a>
    <cfif isdefined("attributes.print_type") and len(attributes.print_type) and (attributes.print_type eq 321 or attributes.print_type eq 320)><!--- Eğitim yönetimi modülünden çağrılmışsa mail adreslerini formdan alıyor --->
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' extra_parameters="mail_list.mails">
    <cfelseif isdefined("attributes.print_type") and len(attributes.print_type) and isdefined("attributes.action_id") and len(attributes.action_id)>
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' print_type="#attributes.print_type#"  action_id="#attributes.action_id#" simple="1">
    <cfelse>
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' simple="1">
    </cfif>
</cfform>
</cfsavecontent>

<cf_popup_box right_images="#right#">
    <cfif isdefined("attributes.form_type") and len(attributes.form_type)>
        <iframe scrolling="auto" name="auto_print_page" id="auto_print_page" width="100%" height="450" frameborder="0" src="<cfoutput>#request.self#?fuseaction=#adres#&form_type=#attributes.form_type#&iframe=1</cfoutput>" onload="autoResize('auto_print_page');"></iframe>
    <cfelse>
        <iframe scrolling="auto" name="auto_print_page" id="auto_print_page" width="100%" height="450" frameborder="0" src="<cfoutput>#request.self#?fuseaction=#adres#&iframe=1</cfoutput>" onload="autoResize('auto_print_page');"></iframe>
    </cfif>
</cf_popup_box>
<!-- sil -->
<script type="text/javascript">
	function iframe_gonder()
	{	
		is_xml = list_getat(document.page_print.form_type.value,1,',');//1 ise XML 
		secilen_ = list_getat(document.page_print.form_type.value,2,',');
		if(secilen_!= '')
			auto_print_page.location.href='<cfoutput>#request.self#?fuseaction=#adres#&iframe=1&form_type=</cfoutput>' + secilen_+'&is_xml='+is_xml+'';	
	}
	
	function iframe_yazdir()
	{
		parent.auto_print_page.focus(); 
		parent.auto_print_page.print();
	}
	$(window).resize(function()
		{
		autoResize('auto_print_page');
		});
	function autoResize(id){
		if(document.body.scrollHeight < 540)
			document.getElementById(id).height = "420px";
		else
			document.getElementById(id).height= document.body.scrollHeight - 80 + "px";
	}
</script>