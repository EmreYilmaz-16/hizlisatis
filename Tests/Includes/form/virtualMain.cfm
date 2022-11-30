
<!---

---->

<cfif attributes.type eq 1>
    <cfif len(attributes.id)>
        <cfinclude template="upd_tube.cfm">
    <cfelse>
        <cfinclude template="add_tube.cfm">
    </cfif>
</cfif>