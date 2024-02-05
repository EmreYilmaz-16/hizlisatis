
<div style="display:block">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfif FormData.is_virtual eq 1>
    <cfinclude template="../includes/svVrt.cfm">
<cfelse>
    <cfinclude template="../includes/svRlt.cfm">
</cfif>
<cfabort>
</div>