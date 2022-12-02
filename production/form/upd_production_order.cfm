	<cfquery name="getProductionOrders" datasource="#dsn3#">
		SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.VP_ORDER_ID#
	</cfquery>

	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT * FROM  PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
	</cfquery>

<cfform method="post">
	<cfoutput>
		<input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
		<cfif getProductionOrders.IS_FROM_VIRTUAL EQ 1>
		<cfquery name="getVirtualProduct"  datasource="#dsn3#">
			SELECT * FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#getProductionOrders.STOCK_ID#
		</cfquery>
			<cfif getVirtualProduct.product_type eq 1>
				<cfinclude template="../includes/basket_tube.cfm">
			<cfelseif getVirtualProduct.product_type eq 2>
				<cfinclude template="../includes/basket_hydrolik.cfm">
			<cfelseif getVirtualProduct.product_type eq 3>
				<cfinclude template="../includes/basket_pump.cfm">
			</cfif>
		<cfelse>
			<cfinclude template="../includes/bakset_normal.cfm">
		</cfif>		

	</cfoutput>
</cfform>
