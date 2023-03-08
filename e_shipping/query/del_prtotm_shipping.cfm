
<CFSET B_YEAR=year(NOW())-1>
<cfquery name="isHvSvk" datasource="#dsn3#">
	SELECT * FROM 
(select * from #dsn2#.STOCK_FIS 
UNION
SELECT * FROM #dsn#_#B_YEAR#_#session.ep.COMPANY_ID#.STOCK_FIS) AS T
where REF_NO=(SELECT DELIVER_PAPER_NO FROM workcube_metosan_1.PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID=#attributes.ship_result_id#))
</cfquery>

<cfif isHvSvk.recordCount>
	<script>
		alert("Önce Hazırlama Fişini Silmelisiniz");
		window.history.back()

	</script>
	<cfabort>
</cfif>

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
