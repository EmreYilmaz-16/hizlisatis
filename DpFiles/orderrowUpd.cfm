
<cfquery name="GET_MONEY_CREDITS" datasource="#dsn3#">
	UPDATE       
    	#dsn3#.ORDER_ROW
	SET                
    PRODUCT_NAME2 = ( SELECT ORDER_DETAIL  FROM #dsn3#.ORDERS WHERE ORDER_ID=#attributes.action_id#)
	WHERE        
    	ORDER_ID =#attributes.action_id#
</cfquery>


