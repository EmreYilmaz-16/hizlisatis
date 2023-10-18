<cfcomponent>
    <cffunction name="saveBelge"  httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfset e=structKeyArray(arguments)>
        <cfdump var="#e#">
        <cfset FormData=deserializeJSON(e[0])>
        <cfdump var="#FormData#">
    </cffunction>
</cfcomponent>