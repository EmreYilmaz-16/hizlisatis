<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfquery name="getOrder" datasource="#dsn3#">
SELECT OFFER_ID FROM PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#FormData.UNIQUE_RELATION_ID#'
</cfquery>

<cfdump var="#getOrder#">