<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.stock_id_list)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN2#">
		DELETE PRTOTM_SHIP_PACKAGE_LIST WHERE SHIP_ID = #attributes.SHIP_ID# AND REF_STOCK_ID=#f_stock_id#
	</cfquery>
	<cfloop list="#attributes.stock_id_list#" index="sid">
    <br/>
    
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn2#">
			INSERT INTO 
			PRTOTM_SHIP_PACKAGE_LIST
			(
				SHIP_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT,
                REF_STOCK_ID,
                CONTROL_STATUS
			)
			VALUES
			(
				#attributes.SHIP_ID#,
				#sid#,
				#Evaluate('attributes.amount#sid#')#,
				#Evaluate('attributes.control_amount#sid#')#,
                #f_stock_id#,
                #kontrol_status#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.pda')>
	<cflocation url="#request.self#?fuseaction=pda.form_ship_control_fis&ship_id=#attributes.SHIP_ID#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#" addtoken="no">  
</cfif>
