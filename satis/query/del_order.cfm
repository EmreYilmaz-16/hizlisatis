<cfdump var="#attributes#">
<!--- ilgili varlıklar db ve hdd den silinir --->
<cfset attributes.action_id=attributes.offer_id>
<cfset attributes.action_section="OFFER_ID">
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
    	<cfscript>
			add_relation_rows(
				action_type:'del',
				action_dsn : '#dsn3#',
				to_table:'PBS_OFFER',
				to_action_id : attributes.offer_id
				);
		</cfscript>
		<cfquery name="DEL_OFFER_PLUS" datasource="#DSN3#">
			DELETE FROM PBS_OFFER_PLUS WHERE OFFER_ID = #attributes.offer_id#
		</cfquery>
		<cfquery name="DEL_OFFER_PAGES" datasource="#DSN3#">
			DELETE FROM PBS_OFFER_PAGES WHERE OFFER_ID = #attributes.offer_id#
		</cfquery>		
		<cfquery name="DEL_OFFER_PRODUCTS" datasource="#DSN3#">
			DELETE FROM PBS_OFFER_ROW WHERE OFFER_ID = #attributes.offer_id#
		</cfquery>
		<cfquery name="DEL_OFFER" datasource="#DSN3#">
			DELETE FROM PBS_OFFER WHERE OFFER_ID = #attributes.offer_id#
		</cfquery>				
		<cfquery name="Del_History_Row" datasource="#dsn3#">
			DELETE FROM PBS_OFFER_ROW_HISTORY WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
		</cfquery>
		<cfquery name="Del_History" datasource="#dsn3#">
			DELETE FROM PBS_OFFER_HISTORY WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
		</cfquery>		
        </cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=sales.list_pbs_offer</cfoutput>";
   
</script>
