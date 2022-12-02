<cfquery name="getPo" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=#attributes.VP_ORDER_ID#
</cfquery>

<cfif getPo.IS_FROM_VIRTUAL eq 1>
	<cfquery name="gets" datasource="#dsn3#">
		        SELECT VIRTUAL_PRODUCT_ID,PRODUCT_NAME,PC.PRODUCT_CATID,PRICE,MARJ,PRODUCT_DESCRIPTION,PRODUCT_TYPE,IS_CONVERT_REAL,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.RECORD_EMP) RECORD_EMP,VIRTUAL_PRODUCTS_PRT.RECORD_DATE,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.UPDATE_EMP) UPDATE_EMP,VIRTUAL_PRODUCTS_PRT.UPDATE_DATE,PC.PRODUCT_CAT FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT 
		        LEFT JOIN workcube_metosan_1.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=VIRTUAL_PRODUCTS_PRT.PRODUCT_CATID
		        where VIRTUAL_PRODUCT_ID=#getPo.STOCK_ID#
	</cfquery>
	<cfquery name="getsTree" datasource="#dsn3#">
	            SELECT S.PRODUCT_NAME,S.STOCK_CODE,S.STOCK_ID,VPT.AMOUNT,VPQ.QUESTION,PU.MAIN_UNIT,VP_ID,VPQ.QUESTION_ID,S.BARCOD FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT AS VPT
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
<cfset "Eleman#QUESTION_ID#.BARCOD"=BARCOD>
</cfloop>

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
			<CFLOOP query="getQUESTIONS">
				<tr>
					<th style="text-align:left;">
						#QUESTION#
					</th>					
					<cfif isDefined("Eleman#QUESTION_ID#.STOCK_ID")>
						<td><div class="form-group"><input type="text" name="PRODUCT_NAME#QUESTION_ID#" value='#evaluate("Eleman#QUESTION_ID#.PRODUCT_NAME")#'></div>
							<input type="hidden" name="STOCK_ID_#QUESTION_ID#" value="#evaluate("Eleman#QUESTION_ID#.STOCK_ID")#">
						</td>
						<td><div class="form-group"><input type="text" name="BARKODE#QUESTION_ID#" value="#evaluate("Eleman#QUESTION_ID#.BARCOD")#"></div></td>
						<td><div class="form-group"><input type="text" name="AMOUNT#QUESTION_ID#" value="#evaluate("Eleman#QUESTION_ID#.AMOUNT")#"></div></td>
						<td><span id="MAIN_UNIT_#QUESTION_ID#">#evaluate("Eleman#QUESTION_ID#.MAIN_UNIT")#</span></td>
					<cfelse>				
					<td><div class="form-group"><input type="text" name="PRODUCT_NAME#QUESTION_ID#" value=''></div>
							<input type="hidden" name="STOCK_ID_#QUESTION_ID#" value=""></td>
					<td><div class="form-group"><input type="text" name="AMOUNT#QUESTION_ID#" value=""></div></td>
					<td><span id="MAIN_UNIT_#QUESTION_ID#"></span></td>
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
