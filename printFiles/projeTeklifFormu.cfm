

<cfquery name="getOfferRow" datasource="#DSN3#">
    SELECT * FROM PBS_OFFER_ROW WHERE OFFER_ID=#attributes.ACTION_ID#
</cfquery>
<cfif getOfferRow.recordCount eq 1>
    <cfif getOfferRow.IS_VIRTUAL eq 1>
        <CFSET PRINT_TYPE = 'VIRTUAL'>
    <cfelse>
        <CFSET PRINT_TYPE = 'NORMAL'>
    </cfif>
<cfelseif getOfferRow.recordCount gt 1>
    <CFSET PRINT_TYPE = 'MULTI'>
</cfif>
<CFSET attributes.offer_id = getOfferRow.OFFER_ID>
<cfinclude template="teklif_header.cfm">
<cftry>
<cfinclude template="teklif_header_table.cfm">
<cfdump var="#PRINT_TYPE#" abort="true">
<cfcatch>
    <cfdump var="#cfcatch#" abort="true">
</cfcatch>

</cftry>







<!-------------------




<cftry>

<cfif PRINT_TYPE eq 'VIRTUAL'>
    <cfinclude template="virtual_teklif_print.cfm">
<cfelseif PRINT_TYPE eq 'NORMAL'>
  <cfinclude template="normal_teklif_print.cfm">
<cfelseif PRINT_TYPE eq 'MULTI'>
    <cfinclude template="multi_teklif_print.cfm">
</cfif>
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>

</cftry>
----->