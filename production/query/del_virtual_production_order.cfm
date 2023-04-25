<cfquery name="up2" datasource="#dsn3#">   
    update #dsn3#.ORDER_ROW set ORDER_ROW_CURRENCY=-1 WHERE UNIQUE_RELATION_ID=(select UNIQUE_RELATION_ID from #dsn3#.VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#)
</cfquery>

<cfquery name="del" datasource="#dsn3#">
    DELETE FROM   #dsn3#.VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>

<cfquery name="del2" datasource="#dsn3#">
    DELETE FROM VIRTUAL_PRODUCTION_ORDERS_RESULT WHERE P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>

<script>
    window.location.href="/index.cfm?fuseaction=production.emptypopup_list_virtual_production_orders"
</script>