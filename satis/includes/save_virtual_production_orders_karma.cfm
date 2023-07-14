<cfquery name="ishvprodorders" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE UNIQUE_RELATION_ID='#lms#'
</cfquery>

<cfif not ishvprodorders.recordcount and evaluate("attributes.PBS_OFFER_ROW_CURRENCY#i#") eq -5>
	<cfquery name="get_p_order_number" datasource="#dsn3#">
		EXEC GET_PAPER_NUMBER 2
	</cfquery>
	<cfset paper_p_order_no=get_p_order_number.PAPER_NO>
	<cfquery name="insertvirtualporder" datasource="#dsn3#" result="RESpos2">
		INSERT INTO [#dsn3#].[VIRTUAL_PRODUCTION_ORDERS]
			(
				[STOCK_ID],
				[IS_FROM_VIRTUAL],
				[P_ORDER_STATUS],
				[OFFER_ROW_ID],
				[QUANTITY],
				[UNIQUE_RELATION_ID],
				[V_P_ORDER_NO],
				[REL_V_P_ORDER_ID],
				[KARMA_AMOUNT]
			)
		VALUES
			(
				#PRODUCT_ID_KARMA#,
				0,
				0,
				#GET_MAX_OFFER_ROW.OFFER_ROW_ID#,
				#AMOUNT_KARMA#,
				'#LMS#',
				'#paper_p_order_no#',
				#MAIN_VP_ORDERID#,
				#GETKARMAC.PRODUCT_AMOUNT#
			)
	</cfquery>
	
		<cfquery name="GETtREE" datasource="#DSN3#">
			SELECT * FROM PRODUCT_TREE WHERE STOCK_ID=#STOCK_ID_KARMA#
		</cfquery>
		<cfdump var="#GETtREE#">
		<cfloop query="GETtREE">
			<cfquery name="insertPosStocks" datasource="#dsn3#">
				INSERT INTO VIRTUAL_PRODUCTION_ORDERS_STOCKS
						(V_P_ORDER_ID
						,STOCK_ID
						,AMOUNT
						,PRODUCT_ID
						,PRICE
						,DISCOUNT
						,QUESTION_ID)
					VALUES
						(#RESpos2.IDENTITYCOL#
						,#RELATED_ID#
						,#AMOUNT#
						,#PRODUCT_ID#
						,0
						,0
						,<cfif len(QUESTION_ID)>#QUESTION_ID#<cfelse>NULL</cfif>
						)
			</cfquery>
		</cfloop>
	
	
</cfif>	