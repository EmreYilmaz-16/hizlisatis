<cftransaction>
	<cfif attributes.is_type eq 1>
        <cfquery name="upd_spect_main" datasource="#dsn3#">
            UPDATE       
                PRTOTM_SHIP_RESULT
            SET                
                SEVK_EMP = #attributes.sevk_emp_id#, 
                SEVK_DATE = #now()#
            WHERE        
                SHIP_RESULT_ID = #attributes.action_id#
        </cfquery>
	<cfelse>    
    	<cfquery name="upd_spect_main" datasource="#dsn2#">
        	UPDATE       
            	SHIP_INTERNAL
			SET                
            	SEVK_EMP =#attributes.sevk_emp_id#,
                SEVK_DATE = #now()#
			WHERE        
            	DISPATCH_SHIP_ID = #attributes.action_id#
    	</cfquery>
    </cfif>
</cftransaction>
<script language="javascript">
   window.close();
   wrk_opener_reload();
</script>
