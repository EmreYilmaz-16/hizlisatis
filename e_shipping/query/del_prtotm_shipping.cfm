<cfquery name="DEL_ROW" datasource="#DSN3#">
        DELETE FROM 
        	PRTOTM_SHIP_RESULT_ROW
		WHERE  
        	<cfif attributes.type eq 1>   
        		SHIP_RESULT_ROW_ID = #attributes.ship_result_row_id#
            <cfelse>
            	SHIP_RESULT_ID = #attributes.ship_result_id#
            </cfif>
</cfquery>
<cfif attributes.type eq 1> 
	<cflocation url="#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping&iid=#attributes.ship_result_id#" addtoken="no">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>    
