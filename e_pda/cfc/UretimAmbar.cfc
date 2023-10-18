<cfcomponent>
    <cffunction name="saveBelge"  httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfset e=structKeyArray(arguments)>
        <cfdump var="#e#">
    </cffunction>
</cfcomponent>