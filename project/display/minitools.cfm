﻿<cfif attributes.tool_type eq "alternativeQuestion">
    <cfinclude template="miniToolsInc/alternativeQuestion.cfm">
<cfelseif attributes.tool_type eq 'showMessage'>
    <cfinclude template="miniToolsInc/showMessage.cfm">
<cfelseif attributes.tool_type eq 'ListVP'>
    <cfinclude template="miniToolsInc/ListVP.cfm">
<cfelseif attributes.tool_type eq 'ShowPrice'>
    <cfinclude template="miniToolsInc/ShowPrice.cfm">
<cfelseif attributes.tool_type eq 'showSarf'>
    <cf_box title="Üretim Ağacı" scroll="1" collapsable="1" resize="1" popup_box="1">
    <cfinclude template="../../GeneralUsage/Production/SarfBasket.cfm">
    </cf_box>
<cfelse> 
    Sistem Yönetici
</cfif>
