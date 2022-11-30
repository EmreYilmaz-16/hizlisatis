<cfset module_name="sales">

<br><cfdump var="#dsn#">
<br><cfdump var="#dsn1#">
<br><cfdump var="#dsn2#">
<cfquery name="get_shippng_plan" datasource="#dsn3#">
SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				ST.PRODUCT_ID, 
				ST.STOCK_ID, 
				ST.STOCK_CODE, 
				ST.PROPERTY,
				ST.STOCK_STATUS, 
				ST.BARCOD,
				SR.STORE,
				SR.STORE_LOCATION,
				PR.PRODUCT_NAME,
				PR.MANUFACT_CODE,
				PR.PRODUCT_ID
			FROM
				catalystTest_product.STOCKS AS ST,
				catalystTest_2019_1.STOCKS_ROW AS SR,
				catalystTest_product.PRODUCT AS PR
			WHERE
				ST.STOCK_ID = SR.STOCK_ID AND
				ST.PRODUCT_ID=PR.PRODUCT_ID	
			GROUP BY
				ST.PRODUCT_ID,
				ST.STOCK_ID,
				ST.STOCK_CODE,
				ST.PROPERTY,
				ST.STOCK_STATUS, 
				ST.BARCOD,
				SR.STORE,
				SR.STORE_LOCATION,
				PR.PRODUCT_NAME,
				PR.MANUFACT_CODE,
				PR.PRODUCT_ID
			HAVING SR.STORE_LOCATION=0 AND SUM(SR.STOCK_IN - SR.STOCK_OUT)>0
</cfquery>

<cf_popup_box title="Mal Kabul Depo Stok Bilgileri">
<cf_big_list>
<thead>
<tr>
	<td>
	Üretici Kodu
	</td>

	<td>
	Ürün Adı
	</td>
	<td>
	Barkod
	</td>
	<td>
	Mal Kabul Depo Miktarı
	</td>
</tr>
</thead>

<tbody>
<cfoutput query="get_shippng_plan">
<tr>
<td>
#MANUFACT_CODE#
</td>

<td>
#PRODUCT_NAME#
</td>
<td>
#BARCOD#
</td>
<td>
#PRODUCT_STOCK#
</td>
<td>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#STOCK_ID#&product_id=#PRODUCT_ID#','page');" class="tableyazi" title="Sevk Fişine Git">Lokasyona Göre Stoklar</a>
</td>
</tr>
</cfoutput>
</tbody>

</cf_big_list>
</cf_popup_box>