<style>
    .alert > p, .alert > ul {
    margin-bottom: 0;
}
</style>
<cfparam name="attributes.show_alert" default="1">

<cfset url_str = ''>
<cfif isDefined('attributes.style') and len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif isDefined('attributes.design_id') and len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
<cfif isDefined('attributes.is_special') and len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
<cfif isDefined('attributes.action_type') and len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif isDefined('attributes.is_delete') and len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
<cfif isDefined('attributes.action_section') and len(attributes.action_section)><cfset url_str =url_str&'&action_section=#attributes.action_section#'></cfif>
<cfif isDefined('attributes.action_id') and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif isDefined('attributes.is_open_det') and len(attributes.is_open_det)><cfset url_str =url_str&'&is_open_det=#attributes.is_open_det#'></cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)><cfset url_str =url_str&'&period_id=#attributes.period_id#'></cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfset url_str =url_str&'&company_id=#attributes.company_id#'></cfif>
<cfquery name="GET_NOTE" datasource="#DSN#">
	SELECT
		*,
        #dsn#.getEmployeeWithId(RECORD_EMP) KAYDEDEN
	FROM
		NOTES
	WHERE
		ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#">
	<cfif attributes.action_type eq 0>
		AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	<cfelse>
		AND ACTION_VALUE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_id#">
	<cfif isdefined("attributes.action_id_2")>
        AND	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">
    </cfif>
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfif>
	<cfif isDefined('attributes.period_id') and len(attributes.period_id)>
            AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
    </cfif>
		AND
		(
			IS_SPECIAL = 0
		  <cfif isdefined("session.ep")>
			OR (IS_SPECIAL = 1 AND (RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">))
		  <cfelseif isDefined('session.pp')>
			OR (IS_SPECIAL = 1 AND (RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">))
		  <cfelseif isDefined('session.ww')>
			OR (IS_SPECIAL = 1 AND (RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR UPDATE_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">))
		  </cfif>
		)
	ORDER BY
		RECORD_DATE
</cfquery>



<cfset color_list="##e8736bcc,##dcf7838c,##83dcf763,##e895fc6b,##fc95ad7d,##fc9595bf">

<cfset ix=0>
<cfset iy=0>
<div style="background:white">
   <cfoutput> <div style="text-align:right;padding:3px;background:darkslategrey"><button onclick="closeBoxDraggable('#attributes.modal_id#')" class="btn btn-danger">X</button></div></cfoutput>
<div style="padding:5px;">
   <cfoutput query="GET_NOTE">
    <cfif ix gte listLen(color_list)>
        <cfset ix=1>
    <cfelse>
        <cfset ix=ix+1>
    </cfif>
    <cfset iy=iy+1>
    <div class="alert" style="background:#listGetAt(color_list,3)#;margin-bottom:0;<cfif iy neq 1>margin-top: 5px</cfif>">
        <h3 style="text-transform:uppercase">#NOTE_HEAD#</h3>
        
        #NOTE_BODY#
        <br><code><i class="fa fa-save"></i>&nbsp;&nbsp;#KAYDEDEN# #dateFormat(RECORD_DATE,"dd/mm/yyyy")#</code>
    </div>
    
</cfoutput>
</div>
</div>