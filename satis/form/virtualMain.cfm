
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

<cfif attributes.type eq 3>
    <cfif len(attributes.id)>
        <cfinclude template="../includes/upd_virtual_hydrolic.cfm">
    <cfelse>
        <cfinclude template="../includes/add_virtual_hydrolic.cfm">
    </cfif>
</cfif>

<cfif attributes.type eq 4>
    <cfif len(attributes.id)>
        <cfinclude template="../includes/upd_virtual_offer_product.cfm">
    <cfelse>
        <cfinclude template="../includes/add_virtual_offer_product.cfm">
    </cfif>
</cfif>

<cfif attributes.type eq 5>
    <cfif len(attributes.id)>
        <cfinclude template="../includes/upd_virtual_pump.cfm">
    <cfelse>
        <cfinclude template="../includes/add_virtual_pump.cfm">
    </cfif>
</cfif>