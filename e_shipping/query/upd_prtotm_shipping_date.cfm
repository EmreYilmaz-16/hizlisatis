<cfset shipping_id_list_1 =''>
<cfset shipping_id_list_2 =''>
<cf_date tarih='attributes.send_date'>
<cfloop list="#attributes.shipping_id_list#" index="ii">
	<cfif listgetat(ii,1,'-') eq 1>
		<cfset shipping_id_list_1 = ListAppend(shipping_id_list_1, listgetat(ii,2,'-'))>
   	<cfelseif listgetat(ii,1,'-') eq 2> 
    	<cfset shipping_id_list_2 = ListAppend(shipping_id_list_2, listgetat(ii,2,'-'))>
    </cfif>
</cfloop>
<cflock timeout="60">
  	<cftransaction>
    	<cfif Listlen(shipping_id_list_1)>
            <cfquery name="UPD_SHIP_RESULT" datasource="#DSN3#">
                UPDATE
                    PRTOTM_SHIP_RESULT
                SET
                    OUT_DATE = #attributes.send_date#,
                    DELIVERY_DATE = #attributes.send_date#,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_IP = '#cgi.remote_addr#',
                    UPDATE_DATE = #now()#
                WHERE
                    SHIP_RESULT_ID IN (#shipping_id_list_1#)
            </cfquery>
        </cfif>
        <cfif Listlen(shipping_id_list_2)>
            <cfquery name="UPD_SHIP_INTERNAL" datasource="#DSN3#">
                UPDATE       
                    #dsn2_alias#.SHIP_INTERNAL
                SET                
                    DELIVER_DATE = #attributes.send_date#, 
                    UPDATE_EMP = #session.ep.userid#, 
                    UPDATE_DATE = #now()#
                WHERE        
                    DISPATCH_SHIP_ID IN (#shipping_id_list_2#)
            </cfquery>
        </cfif>
  	</cftransaction>
</cflock>
<script language="javascript">
	wrk_opener_reload();
   	window.close();
</script>
