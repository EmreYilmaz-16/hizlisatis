
<cfquery name="GET_MONEY_CREDITS" datasource="#caller.dsn3#">
	UPDATE       
    	#caller.dsn3#.ORDER_ROW
	SET                
    PRODUCT_NAME2 = ( SELECT ORDER_DETAIL  FROM #caller.dsn3#.ORDERS WHERE ORDER_ID=#attributes.action_id#)
	WHERE        
    	ORDER_ID =#attributes.action_id#
</cfquery>


