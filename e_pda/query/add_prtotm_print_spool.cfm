<cftransaction>
	<cfif len(attributes.stock_id_list)>
    	<cfloop list="#attributes.stock_id_list#" index="i">
         	<cfset stock_id = ListGetAt(i,1,'_')>
            <cfset amount = ListGetAt(i,2,'_')>
            <cfquery name="del_spool" datasource="#dsn3#">
                DELETE FROM PRTOTM_PDA_PRINT_SPOOL WHERE SHIP_ID = #attributes.ship_id# AND STOCK_ID = #stock_id# AND IS_TYPE = #attributes.is_type#
            </cfquery>
            <cfquery name="add_spool" datasource="#dsn3#">
                INSERT INTO              
                    PRTOTM_PDA_PRINT_SPOOL
                    (
                    SHIP_ID, 
                    STOCK_ID, 
                    STATUS, 
                    AMOUNT,
                    RECORD_EMP, 
                    RECORD_DATE,
                    IS_TYPE
                    )
                VALUES
                    (
                    #attributes.ship_id#,
                    #stock_id#,
                    0,
                    #amount#,
                    #session.ep.userid#,
                    #now()#,
                    #attributes.is_type#
                    )
            </cfquery>
    	</cfloop>
    </cfif>
</cftransaction>
<script type="text/javascript">
	alert('Havuza İşlemi Tamamlanmıştır!');
	window.location.href = '<cfoutput>#request.self#?fuseaction=epda.upd_prtotm_ambar_fis&department_in_id=#attributes.department_in_id#&department_out_id=#attributes.department_out_id#&keyword=#attributes.keyword#&date1=#attributes.date1#&date2=#attributes.date2#&deliver_paper_no=#attributes.deliver_paper_no#&is_type=#attributes.is_type#&ship_id=#attributes.ship_id#</cfoutput>';
</script>