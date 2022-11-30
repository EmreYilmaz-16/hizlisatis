<cftransaction>
	<cfquery name="del_packing" datasource="#dsn3#">
		DELETE FROM 
        	PRTOTM_PACKING
		WHERE     
        	PACKING_ID = #attributes.packing_id#
    </cfquery>
   	<cfquery name="del_packing_row" datasource="#dsn3#">
		DELETE FROM 
        	PRTOTM_PACKING_ROW
		WHERE     
        	PACKING_ID = #attributes.packing_id#
   	</cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=sales.popup_list_PRTOTM_packing_packets&ship_id=#attributes.ship_id#&deliver_paper_no=#attributes.deliver_paper_no#&type=#attributes.type#" addtoken="No">