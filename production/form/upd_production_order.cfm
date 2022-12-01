	<cfquery name="getProductionOrders" datasource="#dsn3#">
		SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.VP_ORDER_ID#
	</cfquery>

	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT * FROM  PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
	</cfquery>

<cfform method="post">
	<cfoutput>
		<input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
	</cfoutput>
</cfform>
