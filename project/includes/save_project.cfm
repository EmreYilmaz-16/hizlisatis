<cfif isDefined("attributes.project_number") and len(attributes.project_number)>
	<cfquery name="GET_PROJECT_NUMBER" datasource="#dsn#">
		SELECT PROJECT_ID FROM PRO_PROJECTS WHERE  PROJECT_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.project_number)#">
	</cfquery>
	<cfif get_project_number.recordcount gte 1>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:Proje No <cf_get_lang_main no='781.tekrarı'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cf_date tarih="attributes.pro_h_start">
<cf_date tarih="attributes.pro_h_finish">
<cfscript>
	attributes.expected_budget=filterNum(attributes.expected_budget);
	attributes.expected_cost=filterNum(attributes.expected_cost);
	
</cfscript>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PROJECT" datasource="#dsn#" result="PRO_ID">
			INSERT INTO 
				PRO_PROJECTS
			(
			  <cfif len(attributes.company_id) and len(attributes.partner_id)>
				COMPANY_ID,
				PARTNER_ID,
			  <cfelseif not len(attributes.company_id) and len(attributes.consumer_id)>
				CONSUMER_ID,
			  </cfif>
			  <cfif len(attributes.project_emp_id)>
				PROJECT_EMP_ID,		
				PROJECT_POS_CODE,
			  <cfelseif len(attributes.TASK_COMPANY_ID)>
				OUTSRC_CMP_ID,
				OUTSRC_PARTNER_ID,
			  </cfif>
				PROJECT_HEAD,
				PROJECT_DETAIL,
				TARGET_START,
				TARGET_FINISH,
				PRO_CURRENCY_ID,
				PRO_PRIORITY_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				EXPENSE_CODE,
			  <cfif len(attributes.EXPECTED_BUDGET)>
				EXPECTED_BUDGET,
			  </cfif>
			  <cfif len(attributes.EXPECTED_COST)>
				EXPECTED_COST,
			  </cfif>
			  <cfif len(attributes.BUDGET_CURRENCY)>BUDGET_CURRENCY,</cfif>
			  <cfif len(attributes.COST_CURRENCY)>COST_CURRENCY,</cfif>	
				PROJECT_TARGET,
				RELATED_PROJECT_ID,
				PROJECT_STATUS,
				PROCESS_CAT,
				PROJECT_FOLDER,
				AGREEMENT_NO,
				WORKGROUP_ID,
                PRODUCT_ID,
				BRANCH_ID,
                DEPARTMENT_ID,
                LOCATION_ID,
                COUNTRY_ID,
                SALES_ZONE_ID,
                SPECIAL_DEFINITION_ID,
                CITY_ID,
                COUNTY_ID,
                COORDINATE_1,
                COORDINATE_2,
				LANGUAGE_ID,
                GOOGLE_PROJECT_FOLDER_ID
			)
			VALUES
			(
				<cfif len(attributes.company_id) and len(attributes.partner_id)>
					<cfif isdefined("attributes.COMPANY_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COMPANY_ID#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.PARTNER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PARTNER_ID#">,<cfelse>NULL,</cfif>
				<cfelseif not len(attributes.company_id) and len(attributes.consumer_id)>
					<cfif isdefined("attributes.CONSUMER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CONSUMER_ID#">,<cfelse>NULL,</cfif>
				</cfif>
				<cfif isdefined('attributes.project_emp_id') and len(attributes.project_emp_id)>
					<cfif isdefined("attributes.PROJECT_EMP_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_EMP_ID#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.PROJECT_POS_CODE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_POS_CODE#">,<cfelse>NULL,</cfif>
				<cfelseif len(attributes.TASK_COMPANY_ID)>
					<cfif isdefined("attributes.TASK_COMPANY_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TASK_COMPANY_ID#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.TASK_PARTNER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TASK_PARTNER_ID#">,<cfelse>NULL,</cfif>
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_HEAD#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_DETAIL#">,
					<cfif len(attributes.PRO_H_START)>#attributes.PRO_H_START#<cfelse>NULL</cfif>,
					<cfif len(attributes.PRO_H_FINISH)>#attributes.PRO_H_FINISH#<cfelse>NULL</cfif>,
					#attributes.process_stage#,
					#attributes.PRIORITY_CAT#,
					#NOW()#,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					NULL,
				<cfif len(attributes.expected_budget)>
					#attributes.expected_budget#,
				</cfif>
				<cfif len(attributes.expected_cost)>
					#attributes.expected_cost#,
				</cfif>
				<cfif len(attributes.BUDGET_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BUDGET_CURRENCY#">,</cfif>
				<cfif len(attributes.COST_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COST_CURRENCY#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_TARGET#">,
				<cfif len(ATTRIBUTES.RELATED_PROJECT_ID)>#ATTRIBUTES.RELATED_PROJECT_ID#,<CFELSE>NULL,</cfif>
					1,
					#attributes.main_process_cat#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.project_folder#">,
					<cfif isdefined("attributes.agreement_no")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.agreement_no#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>#attributes.workgroup_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.product_id") and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.location_id) and  len(attributes.department_id)>#listfirst(attributes.department_id,'-')#<cfelse>NULL</cfif>,
                    <cfif len(attributes.department_id) and len(attributes.location_id)>#listlast(attributes.location_id,'-')#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.country_id") and len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>#attributes.special_definition#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>'#attributes.dictionary_id#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.projectFolderId") and len(attributes.projectFolderId)>'#attributes.projectFolderId#'<cfelse>NULL</cfif>
                    
				)
		</cfquery>
      	<cfquery name="GET_LAST_PRO" datasource="#dsn#">
			SELECT MAX(PROJECT_ID) AS PRO_ID FROM PRO_PROJECTS
		</cfquery>
        
        <!--- History tablosuna kayıt yapılacak--->
        <!---<cf_wrk_get_history  datasource='#DSN#' source_table= 'PRO_PROJECTS' target_table= 'PRO_HISTORY' record_id= '#get_last_pro.PRO_ID#' record_name='PROJECT_ID'>--->
		<cfquery name="ADD_PROJECT_TO_HISTORY" datasource="#dsn#">
			INSERT INTO 
				PRO_HISTORY
				(
				<cfif len(attributes.company_id) and len(attributes.partner_id)>
					COMPANY_ID,
					PARTNER_ID,
				<cfelseif not len(attributes.company_id) and len(attributes.consumer_id)>
					CONSUMER_ID,
				</cfif>	
					PROJECT_ID,
					UPDATE_DATE,
				<cfif len(attributes.project_emp_id)>
					PROJECT_EMP_ID,	
					PROJECT_POS_CODE,
				<cfelseif len(attributes.TASK_COMPANY_ID)>
					OUTSRC_CMP_ID,
					OUTSRC_PARTNER_ID,
				</cfif>
					TARGET_START,
					TARGET_FINISH,
					PRO_CURRENCY_ID,
					PRO_PRIORITY_ID,
					UPDATE_AUTHOR,
					AGREEMENT_NO,
					BRANCH_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID,
					COUNTRY_ID,
	                SALES_ZONE_ID,
                    SPECIAL_DEFINITION_ID,
                    PROJECT_STATUS              
				)
			VALUES
				(
				<cfif len(attributes.company_id) and len(attributes.partner_id)>
					<cfif isdefined("attributes.COMPANY_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COMPANY_ID#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.PARTNER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PARTNER_ID#">,<cfelse>NULL,</cfif>
				<cfelseif not len(attributes.company_id) and len(attributes.consumer_id)>
					<cfif isdefined("attributes.CONSUMER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CONSUMER_ID#">,<cfelse>NULL,</cfif>
				</cfif>
					#get_last_pro.pro_id#,
					#now()#,
				<cfif isdefined('attributes.project_emp_id') and len(attributes.project_emp_id)>
					<cfif isdefined("attributes.PROJECT_EMP_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_EMP_ID#">,<cfelse>NULL,</cfif>					
					<cfif isdefined("attributes.PROJECT_POS_CODE")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROJECT_POS_CODE#">,<cfelse>NULL,</cfif>
				<cfelseif len(attributes.TASK_COMPANY_ID)>
					<cfif isdefined("attributes.TASK_COMPANY_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TASK_COMPANY_ID#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.TASK_PARTNER_ID")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TASK_PARTNER_ID#">,<cfelse>NULL,</cfif>
				</cfif>
					#attributes.start_date#,
					#attributes.finish_date#,
					#attributes.process_stage#,
					#attributes.PRIORITY_CAT#,
					#SESSION.EP.USERID#,
					<cfif isdefined("attributes.agreement_no")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.agreement_no#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.location_id) and  len(attributes.department_id)>#listfirst(attributes.department_id,'-')#<cfelse>NULL</cfif>,
                    <cfif len(attributes.department_id) and len(attributes.location_id)>#listlast(attributes.location_id,'-')#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.country_id") and len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>#attributes.special_definition#<cfelse>NULL</cfif>,
                    1
				)
		</cfquery>
		
		<cfif isdefined("attributes.opp_id") and len(attributes.opp_id)><!--- firsattan geliyor ise firsatla baglanacak --->
			<cfquery name="add_opp" datasource="#dsn#">
				UPDATE
					#dsn3_alias#.OPPORTUNITIES
				SET
					PROJECT_ID = #get_last_pro.pro_id#
				WHERE
					OPP_ID = #attributes.opp_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<!---Ek Bilgiler--->
<cfset attributes.info_id = PRO_ID.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -10>
<cfinclude template="/v16/objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfquery name="UPD_PROJECT_NUMBER" datasource="#DSN#">
	UPDATE 
		PRO_PROJECTS 
	SET		
	<cfif isdefined("attributes.project_number") and len(attributes.project_number)>
		PROJECT_NUMBER=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.project_number)#">
	<cfelse>
		PROJECT_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_last_pro.pro_id#">
	</cfif>
	WHERE 
		PROJECT_ID = #get_last_pro.pro_id#
</cfquery>
<cfif not isdefined('is_web_service')><!--- web_Servislerden yada importlardan gelmiyorsa --->
	<cfset attributes.project_id = get_last_pro.pro_id>
	<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='PRO_PROJECTS'
			action_column='PROJECT_ID'
			action_id='#get_last_pro.pro_id#'
			action_page='#request.self#?fuseaction=project.projects&event=det&id=#get_last_pro.pro_id#'
			warning_description = 'Proje No : #attributes.project_number#'>
    <cfset attributes.actionId = get_last_pro.pro_id>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=project.projects&event=det&id=#get_last_pro.pro_id#</cfoutput>';
    </script>
</cfif>