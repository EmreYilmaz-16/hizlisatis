<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.stock_id_list)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN3#">
		DELETE PRTOTM_SHIPPING_PACKAGE_LIST WHERE SHIPPING_ID = #attributes.SHIP_ID# AND REF_STOCK_ID=#attributes.f_stock_id# AND TYPE = #attributes.is_type#
	</cfquery>
	<cfloop list="#attributes.stock_id_list#" index="sid">
		<cfquery name="ADD_PACKAGE_LIST" datasource="#dsn3#">
			INSERT INTO 
			PRTOTM_SHIPPING_PACKAGE_LIST
			(
				SHIPPING_ID,
				STOCK_ID,
				AMOUNT,
				CONTROL_AMOUNT,
                REF_STOCK_ID,
                CONTROL_STATUS,
                TYPE
			)
			VALUES
			(
				#attributes.SHIP_ID#,
				#sid#,
				#Evaluate('attributes.amount#sid#')#,
				#Evaluate('attributes.control_amount#sid#')#,
                #f_stock_id#,
                #kontrol_status#,
                #attributes.is_type#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.pda')>
	<cflocation url="#request.self#?fuseaction=epda.prtotm_shipping_control_fis&ship_id=#attributes.SHIP_ID#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#" addtoken="no">  
</cfif>
