<cfset Sayfa="">
<cfswitch expression="#attributes.page#">
    <cfcase value="1">
        <cfset sayfa="display/hizli_satis_pda.cfm">
    </cfcase>
    <cfcase value="2">
        <cfset sayfa="display/getCompanyPopup.cfm">
    </cfcase>
    <cfcase value="3">
        <cfset sayfa="form/virtualMain.cfm">
    </cfcase>
    <cfcase value="4">
        <cfset sayfa="query/add_virtual_tube.cfm">
    </cfcase>
    <cfcase value="5">
        <cfset sayfa="display/row_data.cfm">
    </cfcase>
    <cfcase value="6">
        <cfset sayfa="display/basket_guncelle_que.cfm">
    </cfcase>
    <cfdefaultcase></cfdefaultcase>
</cfswitch>

<cfif Sayfa neq "">
    <cfinclude template="/AddOns/Partner/Tests/Includes/#Sayfa#">
</cfif>

