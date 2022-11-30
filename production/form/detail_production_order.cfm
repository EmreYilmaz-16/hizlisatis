<cfquery name="getPo" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=#attributes.P_ORDER_ID#
</cfquery>

<cfif getPo.IS_FROM_VIRTUAL eq 1>
	<cfquery name="gets" datasource="#dsn3#">
		        SELECT VIRTUAL_PRODUCT_ID,PRODUCT_NAME,PRODUCT_CATID,PRICE,MARJ,PRODUCT_DESCRIPTION,PRODUCT_TYPE,IS_CONVERT_REAL,#dsn#.getEmployeeWithId(RECORD_EMP) RECORD_EMP,RECORD_DATE,#dsn#.getEmployeeWithId(UPDATE_EMP) UPDATE_EMP,UPDATE_DATE FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT where VIRTUAL_PRODUCT_ID=#getPo.STOCK_ID#
	</cfquery>
	<cfquery name="getsTree" datasource="#dsn3#">
	            SELECT S.PRODUCT_NAME,S.STOCK_CODE,S.STOCK_ID,VPT.AMOUNT,VPQ.QUESTION,PU.MAIN_UNIT,VP_ID,VPQ.QUESTION_ID FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS VPT
LEFT JOIN workcube_metosan_1.STOCKS AS S ON VPT.STOCK_ID=S.STOCK_ID
LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCT_TREE_QUESTIONS AS VPQ ON VPQ.QUESTION_ID=VPT.QUESTION_ID
LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND PRODUCT_UNIT_STATUS=1
            WHERE  VP_ID=#getPo.STOCK_ID#
    ORDER BY VP_ID  
	</cfquery>
		<cfquery name="getQUESTIONS" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCT_TREE_QUESTIONS WHERE QUESTION_PRODUCT_TYPE=0
	</cfquery>
<cfelse>

	<cfquery name="getsTree" datasource="#dsn3#"></cfquery>
</cfif>
<cfloop query="getsTree">
<cfset "Eleman#QUESTION_ID#.STOCK_ID"=STOCK_ID>
<cfset "Eleman#QUESTION_ID#.PRODUCT_NAME"=PRODUCT_NAME>
<cfset "Eleman#QUESTION_ID#.AMOUNT"=AMOUNT>
<cfset "Eleman#QUESTION_ID#.MAIN_UNIT"=MAIN_UNIT>
</cfloop>

<cf_box title="Üretim Emri #getPo.V_P_ORDER_NO#">
	<cfoutput>
	<table style="width:100%">
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
			<th>
				
				Açıklama
			</th>
			<td colspan="3">
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
