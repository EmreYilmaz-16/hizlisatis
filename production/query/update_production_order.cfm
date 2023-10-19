<cfdump var="#attributes#">
<cfset FORM.P_ORDER_ID=attributes.p_order_id>
<cfinclude template="add_sub_product_fire.cfm">
<cfdump var="#getHTTPRequestData()#">
<script>
    //window.location.href="/index.cfm?fuseaction=production.emptypopup_update_real_production_order&P_ORDER_ID=<cfoutput>#attributes.p_order_id#</cfoutput>"
    window.location.href='<cfoutput>#getHTTPRequestData().headers.referer#</cfoutput>';
</script>