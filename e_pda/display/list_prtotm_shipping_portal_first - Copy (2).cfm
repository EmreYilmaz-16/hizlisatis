<!--- <cfoutput>
	Main DB: #dsn# <br/ > Product DB: #dsn1# <br/ > Period DB: #dsn2# <br/ > Company DB: #dsn3# <br/ >
	</cfoutput> --->
<meta http-equiv="refresh" content="30">
<style>
	table{ font-size: }
</style>
<cfquery name="Sorgu" datasource="#dsn3#">
SELECT ORDERROW.QUANTITY
	,PRODUCT.PRODUCT_CODE
	,PRODUCT.PRODUCT_NAME
	,COMPANY.FULLNAME
	,ORDERS.ORDER_NUMBER
	,ORDERS.ORDER_DATE
	,PRODUCT.MANUFACT_CODE
	,ORDERS.ORDER_HEAD
	,ES.DELIVER_PAPER_NO
	,ORDERS.ORDER_ID	
FROM catalystTest_1.ORDERS AS ORDERS
	,#dsn3#.ORDER_ROW AS ORDERROW
	,catalystTest_product.PRODUCT AS PRODUCT
	,#dsn#.COMPANY AS COMPANY
	,#dsn3#.PRTOTM_SHIP_RESULT as ES
	,#dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESR
WHERE PURCHASE_SALES = 1
	AND ORDERS.ORDER_ID = ORDERROW.ORDER_ID
	AND ORDERROW.ORDER_ROW_CURRENCY = '-6'
	AND ORDERROW.PRODUCT_ID IN (
		SELECT PRODUCT_ID
		FROM #dsn2#.SHIP AS SH
			,#dsn2#.SHIP_ROW AS SR
		WHERE SH.SHIP_ID = SR.SHIP_ID
			AND SH.SHIP_TYPE IN (
				75
				,76
				)
			AND SH.LOCATION_IN = 0
		)
	AND ORDERROW.ORDER_ROW_CURRENCY = '-6'
	AND PRODUCT.PRODUCT_ID=ORDERROW.PRODUCT_ID
	AND COMPANY.COMPANY_ID=ES.COMPANY_ID
	AND COMPANY.COMPANY_ID=ORDERS.COMPANY_ID
	AND ORDERS.ORDER_ID=ORDERROW.ORDER_ID
	AND ESR.ORDER_ID=ORDERS.ORDER_ID 
	AND ES.SHIP_RESULT_ID=ESR.SHIP_RESULT_ID
	AND ESR.ORDER_ID=ORDERROW.ORDER_ID
	AND ESR.ORDER_ROW_ID=ORDERROW.ORDER_ROW_ID
	AND ES.IS_SEVK_EMIR IS NOT NULL
	AND ORDERROW.STOCK_ID IN (SELECT				
				S.STOCK_ID			
			FROM
				#dsn1#.STOCKS S,
				#dsn2#.STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID 

				AND sr.STORE_LOCATION=0				 
			GROUP BY
				S.STOCK_ID
				
				HAVING SUM(SR.STOCK_IN - SR.STOCK_OUT)>0) 
ORDER BY ORDERROW.PRODUCT_ID DESC
	,ORDERS.ORDER_NUMBER DESC

</cfquery>
<!--- <cfquery name="PRTOTMDeneme1" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_ORDERS_ORDERS_REL
	</cfquery>
	<cfquery name="PRTOTMDeneme2" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIP_RESULT
	</cfquery>
	<cfquery name="PRTOTMDeneme3" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIP_RESULT_ROW
	</cfquery>
	<cfquery name="PRTOTMDeneme4" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIPPING_PACKAGE_LIST
	</cfquery>
	<cfdump var="#PRTOTMDeneme1#">
	<cfdump var="#PRTOTMDeneme2#">
	<cfdump var="#PRTOTMDeneme3#">
	<cfdump var="#PRTOTMDeneme4#">
	<cfdump var="#Sorgu#" > --->
<cf_big_list>
	<tr>
	<thead>
		<th>
			Sevk No
		</th>
		<th>
			Üretici Kodu
		</th>
		<th>
			Ürün Adı
		</th>
		<th>
			Sipariş Tarihi
		</th>
		<th>
			Sipariş Miktarı
		</th>
		<th>
			Müşteri Adı
		</th>
	</thead>
	</tr>
	<tbody>
		<cfoutput query="Sorgu">
			<tr>
				<td>
					#Sorgu.DELIVER_PAPER_NO#
				</td>
				<td>
					#Sorgu.MANUFACT_CODE#
				</td>
				<td>
					#Sorgu.PRODUCT_NAME#
				</td>
				<td>
					<cfscript>
                      writeOutput(DateFormat(Sorgu.ORDER_DATE,"dd/mm/yy"));
                    </cfscript>
					<!--- #Sorgu.ORDER_DATE# --->
				</td>
				<td>
					#Sorgu.QUANTITY#
				</td>
				<td>
					#Sorgu.FULLNAME#
				</td>
			</tr>
		</cfoutput>
	</tbody>
</cf_big_list>
