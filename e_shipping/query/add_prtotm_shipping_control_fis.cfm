<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.convert_stocks_id)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN3#">
		DELETE PRTOTM_SHIPPING_PACKAGE_LIST WHERE SHIPPING_ID = #attributes.SHIP_ID# AND TYPE = #attributes.is_type#
	</cfquery>
    <cfset row_i = listLen(attributes.convert_stocks_id)>
	<cfloop from="1" to="#row_i#" index="sid">
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn3#">
			INSERT INTO 
			PRTOTM_SHIPPING_PACKAGE_LIST
			(
				SHIPPING_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT,
                CONTROL_STATUS,
                TYPE,
                RECORD_DATE,
		RECORD_EMP
			)
			VALUES
			(
				#attributes.SHIP_ID#,
				#ListGetAt(attributes.convert_stocks_id,sid,',')#,
				#ListGetAt(attributes.convert_stocks_id,sid,',')#,
                #ListGetAt(attributes.convert_amount_stocks_id,sid,',')#,
                #kontrol_status#,
                #attributes.is_type#,
                #now()#,
				#session.ep.userid#
			)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined('session.pda')>
	<cflocation url="#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping_term_control&ship_id=271&is_type=1&kontrol_status=#attributes.kontrol_status#" addtoken="no">  
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>   