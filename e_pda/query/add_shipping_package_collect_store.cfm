<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.stock_id_list)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN3#">
		DELETE PRTOTM_SHIPPING_PACKAGE_LIST_COLLECT_STORE WHERE COLLECT_ID = '#attributes.ship_collect_id#'
	</cfquery>
	<cfloop list="#attributes.stock_id_list#" index="sid">
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn3#">
			INSERT INTO 
			PRTOTM_SHIPPING_PACKAGE_LIST_COLLECT_STORE
			(
				COLLECT_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT,
                RECORD_DATE,
				RECORD_EMP
			)
			VALUES
			(
				'#attributes.ship_collect_id#',
				#sid#,
				#Evaluate('attributes.amount#sid#')#,
				#Evaluate('attributes.control_amount#sid#')#,
                #now()#,
				#session.pda.userid#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.pda')>
	<cflocation url="#request.self#?fuseaction=pda.list_shipping_collect_store" addtoken="no">  
</cfif>