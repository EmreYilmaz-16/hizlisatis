<cfinclude template="LogKaydet.cfm">
<!---<cfdump expand="yes" var="#attributes#">
<cfabort>--->
<cfif isdefined("attributes.action_date") and len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
<cfset attributes.action_date_value = createdatetime(year(attributes.action_date),month(attributes.action_date),day(attributes.action_date),attributes.start_h,attributes.start_m,0)>
<cfif len(attributes.deliver_date)>
	<cfset attributes.deliver_date_value = createdatetime(year(attributes.deliver_date),month(attributes.deliver_date),day(attributes.deliver_date),attributes.deliver_h,attributes.deliver_m,0)>
<cfelse>
	<cfset attributes.deliver_date_value = "NULL">
</cfif>
<cflock timeout="60">
  	<cftransaction>
		<cfquery name="UPD_SHIP_RESULT" datasource="#DSN3#">
			UPDATE
				PRTOTM_SHIP_RESULT
			SET
				SHIP_METHOD_TYPE = <cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				NOTE = '#attributes.note#',
				REFERENCE_NO = '#attributes.reference_no#',
                OUT_DATE = <cfif len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
				DELIVERY_DATE = <cfif len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
                DELIVER_EMP = <cfif len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
                LOCATION_ID = <cfif len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
				SHIP_STAGE = #attributes.process_stage#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				IS_PARCALI=#attributes.IS_PARCALI#
         	WHERE
            	SHIP_RESULT_ID = #attributes.ship_result_id#
		</cfquery>
  	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#attributes.ship_result_id#" addtoken="no">
