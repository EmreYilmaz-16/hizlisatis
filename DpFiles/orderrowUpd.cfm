
<cfquery name="GET_MONEY_CREDITS" datasource="workcube_metosan_1">
	UPDATE       
    workcube_metosan_1.ORDER_ROW
	SET                
    PRODUCT_NAME2 = ( SELECT ORDER_DETAIL  FROM workcube_metosan_1.ORDERS WHERE ORDER_ID=#attributes.order_id#)
	WHERE        
    	ORDER_ID =#attributes.order_id#
</cfquery>


