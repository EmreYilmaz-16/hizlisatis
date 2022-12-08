<cfquery name="getPo" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=#attributes.VP_ORDER_ID#
</cfquery>
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
		,S.PRODUCT_ID
		,VPT.AMOUNT
		,VPQ.QUESTION
		,PU.MAIN_UNIT
		,VP_ID
		,VPQ.QUESTION_ID
		,S.BARCOD
		,VPT.PRICE
		,VPT.DISCOUNT
	FROM #dsn3#.VIRTUAL_PRODUCT_TREE_PRT AS VPT
	LEFT JOIN #dsn3#.STOCKS AS S ON VPT.STOCK_ID = S.STOCK_ID
	LEFT JOIN #dsn3#.VIRTUAL_PRODUCT_TREE_QUESTIONS AS VPQ ON VPQ.QUESTION_ID = VPT.QUESTION_ID
	LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
		AND PRODUCT_UNIT_STATUS = 1
	WHERE VP_ID = #getPo.STOCK_ID#
	ORDER BY VP_ID
</cfquery>

<cf_box title="Üretim Emri #getPo.V_P_ORDER_NO#">
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
				<th>Barkod</th>
				<th>Miktar</th>
				<th>Birim</th>
			</tr>
			<cfset QUESTION_ID=1>
			<CFLOOP query="getsTree">
				<tr>
					<th style="text-align:left;">
						#QUESTION#
					</th>					
					
						<td>
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="PRODUCT_NAME_#QUESTION_ID#" id="PRODUCT_NAME_#QUESTION_ID#"  value='PRODUCT_NAME'>
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick='openProductPopup(#QUESTION_ID#)'></span>
									</div>
								</div>
							<input type="hidden" name="STOCK_ID_#QUESTION_ID#" id="STOCK_ID_#QUESTION_ID#"  value="#STOCK_ID#">
							<input type="hidden" name="PRODUCT_ID_#QUESTION_ID#" id="PRODUCT_ID_#QUESTION_ID#" value="#PRODUCT_ID#">	
							<input type="hidden" name="PRICE_#QUESTION_ID#" id="PRICE_#QUESTION_ID#" value="#PRICE#">	
							<input type="hidden" name="DISCOUNT_#QUESTION_ID#" id="DISCOUNT_#QUESTION_ID#" value="#DISCOUNT#">	
						</td>
						<td>
							<div class="form-group">
								<input type="text"  name="BARKODE_#QUESTION_ID#" id="BARKODE_#QUESTION_ID#" value="#BARCOD#">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="AMOUNT_#QUESTION_ID#" onchange="this.value=commaSplit(this.value)" id="AMOUNT_#QUESTION_ID#"  value="#tlformat(AMOUNT)#">
							</div>
						</td>
						<td>
							<span id="MAIN_UNIT_#QUESTION_ID#">#MAIN_UNIT#</span>
						</td>
					
					
				</tr>
			<cfset QUESTION_ID=QUESTION_ID+1>
			</CFLOOP>
		</cf_grid_list>
	</cf_box>