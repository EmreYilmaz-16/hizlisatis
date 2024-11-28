

<cf_date tarih='attributes.order_date'>
<cfif (not len(attributes.process_stage))>
	<script type="text/javascript">
		alert("Lütfen Yetki Tanımlayınız!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfset order_row_id_list_ = ''>
<cfloop list="#order_row_id_list#" index="i">
	<cfif isdefined("select_order_row_#i#")>
    	<cfset order_row_id_list_ = ListAppend(order_row_id_list_,i)>
        <cfset "amount_#i#" = Evaluate('select_order_row_#i#')>
    </cfif>
</cfloop>
<cfif (not len(order_row_id_list_))>
	<script type="text/javascript">
		alert("Seçim Yapınız");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cf_papers paper_type="ship_fis" form_name="add_packet_ship" form_field="new_number">
<cfset attributes.transport_no1 = paper_code & '-' & paper_number>
<cfif isdefined("attributes.action_date") and len(attributes.action_date)><cf_date tarih='attributes.action_date'></cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)><cf_date tarih='attributes.deliver_date'></cfif>
<cfset attributes.action_date_value = createdatetime(year(attributes.action_date),month(attributes.action_date),day(attributes.action_date),attributes.start_h,attributes.start_m,0)>
<cfif len(attributes.deliver_date)>
	<cfset attributes.deliver_date_value = createdatetime(year(attributes.deliver_date),month(attributes.deliver_date),day(attributes.deliver_date),attributes.deliver_h,attributes.deliver_m,0)>
<cfelse>
	<cfset attributes.deliver_date_value = "NULL">
</cfif>
<cf_papers paper_type="ship_fis">
<cflock timeout="60">
  	<cftransaction>
		<cfquery name="ADD_SHIP_RESULT" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				PRTOTM_SHIP_RESULT
				(
				IS_TYPE,
			  <cfif len(attributes.company_id)>
				COMPANY_ID,
				PARTNER_ID,
			  <cfelse>
				CONSUMER_ID,
			  </cfif>		
				SHIP_METHOD_TYPE,
				NOTE,
				DELIVER_PAPER_NO,
				REFERENCE_NO,
                OUT_DATE,
				DELIVERY_DATE,
                DELIVER_EMP,
				DEPARTMENT_ID,
                LOCATION_ID,
				SHIP_STAGE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				IS_PARCALI
                )
			VALUES
				(
				1,
			  <cfif len(attributes.company_id)>
				#attributes.company_id#,
				<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			  <cfelse>
				#attributes.consumer_id#,
			  </cfif>		
				<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
				'#attributes.note#',
				'#attributes.transport_no1#',
				'#attributes.reference_no#',
				<cfif len(attributes.action_date_value)>#attributes.action_date_value#<cfelse>NULL</cfif>,
				<cfif len(attributes.deliver_date_value)>#attributes.deliver_date_value#<cfelse>NULL</cfif>,
				<cfif len(attributes.deliver_id2)>#attributes.deliver_id2#<cfelse>NULL</cfif>,
				<cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#,
				#attributes.IS_PARCALI#
				)
		</cfquery>
        <!--- Belge numarasi update ediliyor. --->
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS
			SET
				SHIP_FIS_NUMBER = #paper_number#
			WHERE
				SHIP_FIS_NUMBER IS NOT NULL
		</cfquery>
        <cfloop list="#order_row_id_list_#" index="i">
            <cfquery name="ADD_SHIP_RESULT_ROW" datasource="#DSN3#">
                INSERT INTO
                    PRTOTM_SHIP_RESULT_ROW
                (
                    SHIP_RESULT_ID,
                    ORDER_ID, 
                    ORDER_ROW_ID, 
                    ORDER_ROW_AMOUNT,
					ROW_DETAIL
                )
                VALUES
                (
                    #MAX_ID.IDENTITYCOL#,
                    #attributes.order_id#,
                    #i#,
                    #Filternum(Evaluate('attributes.row_amount_#i#'))#
					'#evaluate("attributes.DETAIL_#i#")#'
                )
            </cfquery>
            <cfquery name="UPD_ORDER_ROW_DELIVER_DATE" datasource="#DSN3#">
                UPDATE    
                    ORDER_ROW
                SET              
                    DELIVER_DATE = #attributes.action_date_value#
                WHERE     
                    ORDER_ROW_ID = #i#
            </cfquery>
        </cfloop>
  	</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='PRTOTM_SHIP_RESULT'
	action_column='PRTOTM_SHIP_RESULT_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=sales.popup_add_PRTOTM_shipping&order_id=#attributes.order_id#'
	warning_description = 'Sevkiyat Plan No : #attributes.transport_no1#'>
<!---<cflocation url="#request.self#?fuseaction=sales.popup_add_PRTOTM_shipping&order_id=#attributes.order_id#" addtoken="No">--->

<script type="text/javascript">
	alert('Kayıt Tamamlandı');
	<cfif isDefined("attributes.reffferr") and findNoCase("list_pbs_offer", attributes.reffferr)>
		window.opener.location.href="<cfoutput>#attributes.reffferr#</cfoutput>&defaultOpen=sayfa_4"
	<cfelse>
wrk_opener_reload();
	</cfif>
	
	window.close();
</script>