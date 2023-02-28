
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
    

<cfscript>
    attributes.pro_h_start = attributes.start_date;
	attributes.pro_h_finish = attributes.finish_date;
</cfscript>

<cfinclude template="../includes/save_project.cfm">