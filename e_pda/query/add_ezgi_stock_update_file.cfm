<cfif attributes.row_count gt 0>
	<cfset satirlar = queryNew("id, amount","integer, Decimal") />
    <cfoutput>
    <cfloop from="1" to="#attributes.row_count#" index="i">
    	<cfif Evaluate('attributes.CALC_AMOUNT#i#') neq 0>
        	<cfset Temp = QueryAddRow(satirlar)>
        	<cfset amount_ = Evaluate('attributes.CALC_AMOUNT#i#')>
            <cfset stock_id_ = Evaluate('attributes.STOCK_ID#i#')>
    		<cfset Temp = QuerySetCell(satirlar, "id", stock_id_)> 
            <cfset Temp = QuerySetCell(satirlar, "amount", amount_)>
        </cfif>
   	</cfloop>
   	</cfoutput>
</cfif>
<cfquery name="satirlar_sayim" dbtype="query">
	SELECT * FROM satirlar WHERE AMOUNT > 0
</cfquery>
<cfquery name="satirlar_fire" dbtype="query">
	SELECT * FROM satirlar WHERE AMOUNT < 0
</cfquery>
<cfif satirlar_sayim.recordcount>
	<cfset attributes.process_cat = attributes.sayim_process_cat_id>
    <cfset attributes.action_id = ''>
    <cfset attributes.is_mobile = 1>
    <cfset attributes.tersfis = 1>
    <cfset attributes.dep_out = attributes.department_in_id>
	<cfset attributes.dep_in = attributes.department_in_id>
    <cfloop query="satirlar_sayim">
    SAYIM
		<cfset attributes.action_id = ListAppend(attributes.action_id,'#satirlar_sayim.currentrow#-#satirlar_sayim.id#-#satirlar_sayim.amount#-#attributes.raf#')>
    </cfloop>
    <cfinclude template="add_ambar_fis.cfm">
</cfif>
<cfif satirlar_fire.recordcount>
	<cfset attributes.process_cat = attributes.fire_process_cat_id>
    <cfset attributes.action_id = ''>
    <cfset attributes.is_mobile = 1>
    <cfset attributes.tersfis = 1>
    <cfset attributes.dep_out = attributes.department_in_id>
	<cfset attributes.dep_in = attributes.department_in_id>
    <cfloop query="satirlar_fire">
     FİRE
		<cfset attributes.action_id = ListAppend(attributes.action_id,'#satirlar_fire.currentrow#-#satirlar_fire.id#-#satirlar_fire.amount#-#attributes.raf#')>
    </cfloop>
    <cfinclude template="add_ambar_fis.cfm">
</cfif>

<cflocation url="#request.self#?fuseaction=epda.emptypopup_prtotm_welcome" addtoken="No">
