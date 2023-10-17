<cfif attributes.tool_type eq "alternativeQuestion">
    <cfinclude template="miniToolsInc/alternativeQuestion.cfm">
<cfelseif attributes.tool_type eq 'showMessage'>
    <cfinclude template="miniToolsInc/showMessage.cfm">
<cfelseif attributes.tool_type eq 'ListVP'>
    <cfinclude template="miniToolsInc/ListVP.cfm">
<cfelseif attributes.tool_type eq 'ShowPrice'>
    <cfinclude template="miniToolsInc/ShowPrice.cfm">
<cfelse> 
    Sistem Yönetici
</cfif>
