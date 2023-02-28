
<cf_date tarih="attributes.start_date">
<cf_date tarih="attributes.finish_date">
    <cfset attributes.expected_budget=0>
    <cfset attributes.expected_cost=0>
    <cfset attributes.START_MINUTE=0>
    <cfset attributes.START_MINUTE=0>
    <cfset attributes.COST_CURRENCY="TL">
    <cfset attributes.BUDGET_CURRENCY="TL">
    <cfparam name="attributes.project_detail" default="">
    <cfparam name="attributes.priority_cat" default="1">
    <cfparam name="attributes.EXPENSE_CODE" default="">
    <cfparam name="attributes.PROJECT_TARGET" default="">
    <cfparam name="attributes.RELATED_PROJECT_ID" default="">
    <cfparam name="attributes.project_folder " default="">
    <cfparam name="attributes.branchId" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
<cfset attributes.main_process_cat =attributes.projectCat>
<cfscript>
    attributes.pro_h_start = attributes.start_date;
	attributes.pro_h_finish = attributes.finish_date;
</cfscript>
<cfdump var="#attributes#">
<cfinclude template="../includes/save_project.cfm">

