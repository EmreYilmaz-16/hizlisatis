<cfif 1 eq 1>
<cfquery name="add_sub" datasource="#dsn3#" result="MAX_ID">
    	INSERT INTO
			PRODUCT_TREE
			(
				STOCK_ID, <!----İÇİNE EKLENEN----->
                PRODUCT_ID, <!--- EKLENEN ------>
				RELATED_ID,
				AMOUNT,
				UNIT_ID,
				SPECT_MAIN_ID,
				IS_CONFIGURE,
				IS_SEVK,
                LINE_NUMBER,
                OPERATION_TYPE_ID,
                IS_PHANTOM,
                RELATED_PRODUCT_TREE_ID,
                QUESTION_ID,
				PROCESS_STAGE,
				MAIN_STOCK_ID,
				IS_FREE_AMOUNT,
				FIRE_AMOUNT,
				FIRE_RATE,
				DETAIL,
                RECORD_EMP,
             	RECORD_DATE
			)
		VALUES
			(
				#attributes.main_stock_id#,
				<cfif  isdefined('attributes.product_id') and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.add_stock_id)>#attributes.add_stock_id#<cfelse>NULL</cfif>,
				#attributes.AMOUNT#,
				<cfif len(attributes.UNIT_ID)>#attributes.UNIT_ID#<cfelse>NULL</cfif>,
				<cfif  isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>#attributes.spect_main_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_configure") and len(attributes.is_configure)>0<cfelse>1</cfif>,
				<cfif isdefined("attributes.is_sevk") and len(attributes.is_sevk) and attributes.is_sevk eq 1>1<cfelse>0</cfif>,
                <cfif isdefined('attributes.line_number') and len(attributes.line_number)>#attributes.line_number#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.operation_type_id') and len(attributes.operation_type_id) and not len(attributes.product_name)>#attributes.operation_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_phantom') and attributes.is_phantom eq 1>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID) >#attributes.PRODUCT_TREE_ID#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.alternative_questions') and len(attributes.alternative_questions) >#attributes.alternative_questions#<cfelse>NULL</cfif>,
				299,
				<cfif isdefined("attributes.operation_main_stock_id") and len(attributes.operation_main_stock_id) and isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID)>#attributes.operation_main_stock_id#<cfelse>NULL</cfif>,
               	NULL,
				<cfif isdefined('attributes.fire_amount') and len(attributes.fire_amount)>#attributes.fire_amount#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.fire_rate') and len(attributes.fire_rate)>#attributes.fire_rate#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
			   	#session.ep.userid#,
                #now()#            
			)
	</cfquery>

	<cfquery name="GET_MAX_TREE" datasource="#dsn3#">
		select max(PRODUCT_TREE_ID) as PRODUCT_TREE_ID from PRODUCT_TREE
	</cfquery>
</cfif>
<!-----
<cfif Insert_Type eq 2>
	<cfset Action="AddOperation">
	<cfif len(ACILACAK.ALTERNATIVE_SID)>                    
		<cfset attributes.main_stock_id=evaluate("Alternatif_#ACILACAK.STOCK_ID#")>
	<cfelse>                    
		<cfset attributes.main_stock_id=evaluate("Alternatif_#ACILACAK.STOCK_ID#")>
	</cfif> 
<!---	<cfscript>
		operation_type_id_list = listappend(operation_type_id_list,isHaveOp.OPERATION_TYPE_ID,',');
	</cfscript>---->
	<cfquery name="insertOpp" datasource="#dsn3#">
		INSERT INTO PRODUCT_TREE (
			IS_TREE
			,AMOUNT
			,OPERATION_TYPE_ID
			,STOCK_ID
			,IS_CONFIGURE
			,IS_SEVK
			,SPECT_MAIN_ID
			,IS_PHANTOM
			,QUESTION_ID
			,PROCESS_STAGE
			,RECORD_EMP
			,RECORD_DATE
			,IS_FREE_AMOUNT
			,FIRE_AMOUNT
			,FIRE_RATE
			,DETAIL
		)
			SELECT TOP (1) NULL
			,AMOUNT
			,OPERATION_TYPE_ID
			,#attributes.main_stock_id#
			,IS_CONFIGURE
			,IS_SEVK
			,SPECT_MAIN_ID
			,IS_PHANTOM
			,QUESTION_ID
			,61
			,#session.ep.userid#
			,#now() #
			,NULL
			,FIRE_AMOUNT
			,FIRE_RATE
			,DETAIL
			FROM PRODUCT_TREE AS PRODUCT_TREE1
			WHERE PRODUCT_TREE_ID = #isHaveOp.PRODUCT_TREE_ID#                    
	</cfquery>	
</cfif>----->