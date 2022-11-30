<cftransaction>
    <cfloop list="#attributes.order_row_id_list#" index="i">
        <cfquery name="upd_order_row" datasource="#dsn3#">
            UPDATE    
                ORDER_ROW
            SET  
            	<cfif isdefined('type') and type eq 2>
                	ORDER_ROW_CURRENCY = -2
                <cfelse>            
                	ORDER_ROW_CURRENCY = -6
                </cfif>
            where     
                WRK_ROW_ID = '#i#'
        </cfquery>
    </cfloop>
</cftransaction>
<script language="javascript">
   window.close();
   wrk_opener_reload();
</script>
