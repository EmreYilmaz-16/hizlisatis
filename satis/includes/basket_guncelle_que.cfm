<cfquery name="getRows" datasource="#dsn3#">
    SELECT OFFER_ID FROM PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#datam.uniqRelationId#'

    
</cfquery>