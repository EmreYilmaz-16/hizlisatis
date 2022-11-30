
<!---

---->

<cfif attributes.type eq 1>
    <cfif len(attributes.id)>
        <cfinclude template="../includes/upd_tube.cfm">
    <cfelse>
        <cfinclude template="../includes/add_tube.cfm">
    </cfif>
</cfif>

<cfif attributes.type eq 2>
    <cfif len(attributes.id)>
        <cfinclude template="../includes/upd_virtual_hydrolic.cfm">
    <cfelse>
        <cfinclude template="../includes/add_virtual_hydrolic.cfm">
    </cfif>
</cfif>