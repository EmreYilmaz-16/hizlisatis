<cfsetting showdebugoutput="yes">
<cfif listlen(attributes.stock_id_list)>
	<cfquery name="DELETE_PACKAGE_LIST" datasource="#DSN3#">
		DELETE PRTOTM_SHIPPING_PACKAGE_LIST WHERE SHIPPING_ID = #attributes.SHIP_ID# AND TYPE = #attributes.is_type#
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
                    CONTROL_STATUS,
                    TYPE,
                    RECORD_DATE,
                    RECORD_EMP
                )
         	VALUES
                (
                    #attributes.SHIP_ID#,
                    #sid#,
                    #Evaluate('attributes.amount#sid#')#,
                    <cfif len(Evaluate('attributes.control_amount#sid#'))>#Evaluate('attributes.control_amount#sid#')#<cfelse>0</cfif>,
                    #kontrol_status#,
                    #attributes.is_type#,
                    #now()#,
                    #session.ep.userid#
                )
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('session.ep')>
	<cflocation url="#request.self#?fuseaction=epda.prtotm_svk_kontrol&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&is_form_submitted=1&kontrol_status=#kontrol_status#" addtoken="no">  
</cfif>