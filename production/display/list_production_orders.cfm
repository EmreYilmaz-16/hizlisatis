<cf_box title="Üretim Emirleri">
	<cfquery name="getProductionOrders">
		SELECT * FROM VIRTUAL_PRODUCTION_ORDERS
	</cfquery>
	<table>
	<cfoutput query="getProductionOrders">
	<tr>
		<td>
			#V_P_ORDER_NO#
		</td>
	</tr>
	</cfoutput>
</table>
</cf_box>