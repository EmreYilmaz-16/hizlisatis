
<cftry>
<cfsavecontent  variable="control5">
	<cfdump var="#arguments.FORM_DATA.header.order_id#">
	test
   </cfsavecontent>
   <cffile action="write" file = "c:\PBS\EMRE_YILMAZ_16.html" output="#control5#"></cffile>
<cfquery name="GET_MONEY_CREDITS" datasource="workcube_metosan_1">
	UPDATE       
    workcube_metosan_1.ORDER_ROW
	SET                
    PRODUCT_NAME2 = ( SELECT ORDER_DETAIL  FROM workcube_metosan_1.ORDERS WHERE ORDER_ID=#arguments.FORM_DATA.header.order_id#)
	WHERE        
    	ORDER_ID =#arguments.FORM_DATA.header.order_id#
</cfquery>
<cfcatch></cfcatch>
</cftry>