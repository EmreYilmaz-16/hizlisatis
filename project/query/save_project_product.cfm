<cfdump var="#attributes#">
<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cffunction name="createProduct">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PRODUCT_CAT">
    
</cffunction>