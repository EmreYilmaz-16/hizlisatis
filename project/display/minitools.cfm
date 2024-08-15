<cfif attributes.tool_type eq "alternativeQuestion">
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
<cfelseif attributes.tool_type eq 'UE-TR'>
    <cfinclude template="miniToolsInc/AgacKarsilastir.cfm">
<cfelseif attributes.tool_type eq 'AddPurchasePrice'>
    <cf_box title="Alış Fiyatı" scroll="1" collapsable="1" resize="1" popup_box="1">
    <cfinclude template="miniToolsInc/AddPurchasePrice.cfm">
    </cf_box>
<cfelseif attributes.tool_type eq 'AddPurchasePriceHistory'>
    <cf_box title="Alış Fiyat Tarihçesi" scroll="1" collapsable="1" resize="1" popup_box="1">
    <cfinclude template="miniToolsInc/AddPurchasePriceHistory.cfm">
    </cf_box>
<cfelseif attributes.tool_type eq 'LeftMenu'>
    <cfinclude template="leftMenuAjax.cfm">
<cfelse> 
    Sistem Yönetici
</cfif>
