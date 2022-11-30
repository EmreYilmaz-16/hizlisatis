<cfquery name="GetOrders" datasource="#dsn3#">
	select * from ORDER_ROW where STOCK_ID=#attributes.stock_id# AND ORDER_ROW_CURRENCY = '-6'
</cfquery>
<cfdump var="#GetOrders#">