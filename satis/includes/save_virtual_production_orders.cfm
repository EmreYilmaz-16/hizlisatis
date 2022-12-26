<cfquery name="ishvprodorders" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE UNIQUE_RELATION_ID='#evaluate("attributes.row_unique_relation_id#i#")#'
</cfquery>

<cfif not ishvprodorders.recordcount and evaluate("attributes.PBS_OFFER_ROW_CURRENCY#i#") eq -5>
	<cfquery name="get_p_order_number" datasource="#dsn3#">
		EXEC GET_PAPER_NUMBER 2
	</cfquery>
	<cfset paper_p_order_no=get_p_order_number.PAPER_NO>
	<cfquery name="insertvirtualporder" datasource="#dsn3#">
		INSERT INTO [#dsn3#].[VIRTUAL_PRODUCTION_ORDERS]
			(
				[STOCK_ID],
				[IS_FROM_VIRTUAL],
				[P_ORDER_STATUS],
				[OFFER_ROW_ID],
				[QUANTITY],
				[UNIQUE_RELATION_ID],
				[V_P_ORDER_NO]
			)
		VALUES
			(
				#evaluate("attributes.product_id#i#")#,
				#evaluate('attributes.is_virtual#i#')#,
				0,
				#GET_MAX_OFFER_ROW.OFFER_ROW_ID#,
				#evaluate('attributes.amount#i#')#,
				'#evaluate('attributes.row_unique_relation_id#i#')#',
				'#paper_p_order_no#'
			)
	</cfquery>
</cfif>	