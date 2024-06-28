<cfquery name="getPo" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=#attributes.P_ORDER_ID#
</cfquery>
<cfif getPo.IS_FROM_VIRTUAL eq 1>
	<cfquery name="gets" datasource="#dsn3#">
		SELECT VIRTUAL_PRODUCT_ID
			,PRODUCT_NAME
			,PC.PRODUCT_CATID
			,PRICE
			,MARJ
			,PRODUCT_DESCRIPTION
			,PRODUCT_TYPE
			,IS_CONVERT_REAL
			,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.RECORD_EMP) RECORD_EMP
			,VIRTUAL_PRODUCTS_PRT.RECORD_DATE
			,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.UPDATE_EMP) UPDATE_EMP
			,VIRTUAL_PRODUCTS_PRT.UPDATE_DATE
			,PC.PRODUCT_CAT
		FROM #dsn3#.VIRTUAL_PRODUCTS_PRT
		LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = VIRTUAL_PRODUCTS_PRT.PRODUCT_CATID
		WHERE VIRTUAL_PRODUCT_ID = #getPo.STOCK_ID#
	</cfquery>
	<cfquery name="getsTree" datasource="#dsn3#">
		SELECT S.PRODUCT_NAME
			,S.STOCK_CODE
			,S.STOCK_ID
			,VPT.AMOUNT
			,VPQ.QUESTION
			,PU.MAIN_UNIT
			,VP_ID
			,VPQ.QUESTION_ID
		FROM #dsn3#.VIRTUAL_PRODUCT_TREE_PRT AS VPT
		LEFT JOIN #dsn3#.STOCKS AS S ON VPT.STOCK_ID = S.STOCK_ID
		LEFT JOIN #dsn3#.VIRTUAL_PRODUCT_TREE_QUESTIONS AS VPQ ON VPQ.QUESTION_ID = VPT.QUESTION_ID
		LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
			AND PRODUCT_UNIT_STATUS = 1
		WHERE VP_ID = #getPo.STOCK_ID#
		ORDER BY VP_ID
	</cfquery>
	<cfquery name="getQUESTIONS" datasource="#dsn3#">
		SELECT *
		FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
		WHERE QUESTION_PRODUCT_TYPE = #gets.PRODUCT_TYPE#
	</cfquery>
<cfelse>
	<cfquery name="gets" datasource="#dsn3#">
		SELECT S.PRODUCT_ID
			,S.STOCK_ID
			,PRODUCT_NAME
			,PC.PRODUCT_CATID
			,PS.PRICE
			,0 as MARJ
			,PRODUCT_DETAIL AS PRODUCT_DESCRIPTION
			,ISNULL(PC.DETAIL,"0") AS PRODUCT_TYPE
			,1 AS IS_CONVERT_REAL
			,#dsn#.getEmployeeWithId(S.RECORD_EMP) RECORD_EMP
			,S.RECORD_DATE
			,#dsn#.getEmployeeWithId(S.UPDATE_EMP) UPDATE_EMP
			,S.UPDATE_DATE
			,PC.PRODUCT_CAT
			
		FROM #dsn3#.STOCKS AS S
		LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID
		LEFT JOIN #DSN1#.PRICE_STANDART AS PS ON PS.PRODUCT_ID=S.PRODUCT_ID AND PRICESTANDART_STATUS=1  AND PURCHASESALES=1
		WHERE S.PRODUCT_ID = #getPo.STOCK_ID# 
	</cfquery>
	
	<cfquery name="getsTree" datasource="#dsn3#">
		SELECT *,PU.MAIN_UNIT FROM PRODUCT_TREE AS PT 
		LEFT JOIN #dsn3#.STOCKS AS S ON PT.RELATED_ID = S.STOCK_ID
		LEFT JOIN #dsn3#.PRODUCT_UNIT as PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND IS_MAIN=1
		WHERE PT.STOCK_ID =#gets.STOCK_ID#
	</cfquery>
		<cfquery name="getQUESTIONS" datasource="#dsn3#">
			SELECT *
			FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
			WHERE QUESTION_PRODUCT_TYPE = #gets.PRODUCT_TYPE#
		</cfquery>
</cfif>
<cf_box title="Üretim Emri #getPo.V_P_ORDER_NO#" print_href="/index.cfm?fuseaction=objects.popup_print_files&action=production.list_production_orders&action_id=#attributes.P_ORDER_ID#&print_type=1450">
	<cfoutput>
	<table style="width:100%">
		<tr>
			<th style="text-align: left;" colspan="2">Ürün Gurubu</th>
			<td colspan="2" >#gets.PRODUCT_CAT#</td>
		</tr>
		<tr>
			<th style="font-size:14pt">
				Ürün Adı
			</th>
			<td style="font-size:14pt">
				#gets.PRODUCT_NAME# 
			</td>
			<th style="font-size:14pt">
				Sipariş Miktar
			</th>
			<td style="font-size:14pt">
				#getPo.QUANTITY#
			</td>
		</tr>
		<tr>
			<th colspan="4" style="font-size:14pt">Açıklama</th>
		</tr>
		<tr>

			<td colspan="4">
				<div class="alert alert-success">
					#gets.PRODUCT_DESCRIPTION#
				</div>
			</td>
		</tr>
	</table>



	<cf_box title="Ürün Ağacı">
		<cf_grid_list >
			<tr>
				<th></th>
				<th>Ürün</th>
				<th>Miktar</th>
				<th>Birim</th>
			</tr>
			<cfif gets.PRODUCT_TYPE eq 1>
				<cfinclude template="../includes/agac_tube.cfm">
			<cfelseif gets.PRODUCT_TYPE eq 2>
				<cfinclude template="../includes/agac_hyd.cfm">
			<cfelseif gets.PRODUCT_TYPE eq 3>
				<cfset hide_buttons=1>
				<cfinclude template="../includes/virman_sh.cfm">
			<cfelse>
				<cfinclude template="../includes/agac_normal.cfm">
			</cfif>
			
		</cf_grid_list>
	</cf_box>

		<cf_box title="Üretim Sonuçları">
		<cf_grid_list >
			<tr>
				<th></th>
				<th>Ürün</th>
				<th>Miktar</th>
				<th>Birim</th>
			</tr>
			<CFLOOP query="getQUESTIONS">
				<tr>
					<th style="text-align:left;">
						#QUESTION#
					</th>					
					<cfif isDefined("Eleman#QUESTION_ID#.STOCK_ID")>
						<td>#evaluate("Eleman#QUESTION_ID#.PRODUCT_NAME")#</td>
						<td>#evaluate("Eleman#QUESTION_ID#.AMOUNT")#</td>
						<td>#evaluate("Eleman#QUESTION_ID#.MAIN_UNIT")#</td>
					<cfelse>				
					<td></td>
					<td></td>
					<td></td>
					</cfif>
					
				</tr>
			</CFLOOP>
		</cf_grid_list>
	</cf_box>
	</cfoutput>


</cf_box>
