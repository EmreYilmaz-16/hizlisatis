<cf_box title="Üretim Emirleri">
	<cfquery name="getProductionOrders" datasource="#dsn3#">
		SELECT * FROM VIRTUAL_PRODUCTION_ORDERS
	</cfquery>
	<table>
	<cfoutput query="getProductionOrders">
	<tr>
		<td>
			<a href="/index.cfm?fuseaction=production.emptypopup_update_virtual_production_orders&VP_ORDER_ID=#VP_ORDER_ID#">#V_P_ORDER_NO#</a>
		</td>
	</tr>
	</cfoutput>
</table>
</cf_box>