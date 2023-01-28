<style>
th{
color:black !important;
}
</style>
<cfquery name="GetLocationStocks" datasource="#dsn2#">
SELECT *,(select MAX(PROCESS_DATE) from #dsn2#.STOCKS_ROW where STOCK_ID=S.STOCK_ID) DD
FROM #dsn1#.STOCKS AS S,#dsn1#.PRODUCT AS P
WHERE STOCK_ID IN (
		SELECT STOCK_ID
		FROM #dsn2#.STOCKS_ROW
		WHERE STORE_LOCATION = 1
		AND STORE=44
		GROUP BY STOCK_ID
		HAVING sum(STOCK_IN - STOCK_OUT) > 0
		
		)
AND S.PRODUCT_ID=P.PRODUCT_ID
ORDER BY DD
</cfquery>
<cfset kayitsayisi=GetLocationStocks.recordcount>
<cfloop from="1" to="#kayitsayisi#" index="i" step="1">
<cf_big_list>
<cfquery name="GetDepoMiktar" datasource="#dsn2#">
select sum(STOCK_IN-STOCK_OUT) AS MIKTAR FROM #dsn2#.STOCKS_ROW WHERE STOCK_ID=#GetLocationStocks.STOCK_ID[i]# AND STORE_LOCATION = 1 AND STORE=44
</cfquery>
<cfset TOPLAMMIK=0>
<cfquery name="GetSiparisler" datasource="#dsn2#">
SELECT c.FULLNAME
	,ordr.QUANTITY
	,ord.ORDER_DATE
	,ord.ORDER_ID
FROM #dsn3#.ORDER_ROW AS ordr
	,#dsn3#.ORDERS AS ord
	,#dsn#.COMPANY AS c
WHERE STOCK_ID = #GetLocationStocks.STOCK_ID[i]#
	AND ORDER_ROW_CURRENCY = - 6
	AND ord.ORDER_ID = ordr.ORDER_ID
	AND c.COMPANY_ID = ord.COMPANY_ID
	AND ord.PURCHASE_SALES=1
	order by ord.ORDER_DATE asc
</cfquery>
<cfset Sipsayisi=GetSiparisler.recordcount>
<cfif Sipsayisi gt 0> 
<tr>
<th style="width:30%">
<h5>
<cfoutput>
Ürün Üretici Kodu: <b>#GetLocationStocks.MANUFACT_CODE[i]#</b>
</cfoutput>
</h5>
</th>
<th style="width:60%">
<cfoutput>
<h5>Ürün Adı : <b> #GetLocationStocks.PRODUCT_NAME[i]#</b>
</h5>
</cfoutput>
</th>
<th style="width:10%">
<h5>
<cfoutput>
Depodaki Miktar :<b>#GetDepoMiktar.MIKTAR#</b>
</cfoutput>
</h5>
</th>
</tr>

<tr>
<td colspan="3">
<cf_big_list>
<tr>
<td style="width:50%">
Firma Adı
</td>
<td style="width:10%">
Sipariş Tarihi
</td>
<td style="width:10%">
Sipariş Miktarı
</td>

<td style="width:10%">
Sevk Edilen Miktar
</td>
<td style="width:10%">
Kalan Miktar
</td>
<td>
SVK Noları
</td>
</tr>
<cfloop from="1" to="#Sipsayisi#" index="j" step="1">
<cfquery name="OrderToShip" datasource="#dsn3#">
	select * from #dsn3#.ORDERS_SHIP where ORDER_ID=#GetSiparisler.ORDER_ID[j]#
</cfquery>
<cfset abc=0>
<cfif OrderToShip.recordcount gt 0>
<cfset abc=OrderToShip.SHIP_ID>
</cfif>
<cfquery name="as1" datasource="#dsn3#">
	SELECT sum(AMOUNT) AS G
	,PRODUCT_ID
	,NAME_PRODUCT
FROM #dsn2#.SHIP_ROW
WHERE SHIP_ID IN (#abc#)
GROUP BY PRODUCT_ID
	,NAME_PRODUCT
HAVING PRODUCT_ID = #GetLocationStocks.PRODUCT_ID[i]#
</cfquery>
<cfquery name="GetSVKNO" datasource="#dsn3#">
SELECT *
FROM #dsn3#.PRTOTM_SHIP_RESULT AS es
	,#dsn3#.PRTOTM_SHIP_RESULT_ROW AS esrr
	,#dsn3#.ORDER_ROW AS ORR
WHERE es.SHIP_RESULT_ID = esrr.SHIP_RESULT_ID
	AND orr.ORDER_ROW_ID = esrr.ORDER_ROW_ID
	AND esrr.ORDER_ID=#GetSiparisler.ORDER_ID[j]#
	AND ORR.PRODUCT_ID=#GetLocationStocks.PRODUCT_ID[i]#
	AND ORR.ORDER_ROW_CURRENCY <>-3
</cfquery>

<cfset svk_list=valueList(GetSVKNO.DELIVER_PAPER_NO)>

<cfquery name="control_info" datasource="#dsn2#">
				SELECT ISNULL(SUM(SFR.AMOUNT),0) AS CONTROL_AMOUNT
				FROM #dsn2#.STOCK_FIS AS SF
				INNER JOIN #dsn2#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
				WHERE SF.FIS_TYPE = 113
					AND SF.REF_NO IN(<cfloop list="#svk_list#" item="item">
						'#item#',
					</cfloop>'')
					AND SFR.STOCK_ID =#GetLocationStocks.STOCK_ID[i]#
				
</cfquery>

<cfset giden=0>
<cfif control_info.recordcount gt 0>
<cfset giden=control_info.CONTROL_AMOUNT>
</cfif>
<cfset KalanMik=GetSiparisler.QUANTITY[j]-giden>
<cfif KalanMik gt 0>
<tr>
<td>
<cfoutput>
#GetSiparisler.FULLNAME[j]#
</cfoutput>
</td>
<td>
<cfoutput>
<a href="##" onclick="windowopen('index.cfm?fuseaction=sales.popup_add_prtotm_shipping&order_id=#GetSiparisler.ORDER_ID[j]#','page')">
#dateformat(GetSiparisler.ORDER_DATE[j],"dd/mm/yyyy")#</a>
</cfoutput>
</td>
<td>
<cfoutput>
#GetSiparisler.QUANTITY[j]#
</cfoutput>
</td>

<td>

<cfoutput>

#giden# *<span style="color:red"> #control_info.CONTROL_AMOUNT#</span>
</cfoutput>
</td>
<td>
<cfoutput>
#KalanMik#
</cfoutput>

<cfset TOPLAMMIK +=#GetSiparisler.QUANTITY[j]#>
</td>
<td>
<cfoutput query="GetSVKNO">
<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_ezgi_shipping_sevk&iid=#SHIP_RESULT_ID#&is_type=1','page');" title="Alınan Siparisler">#DELIVER_PAPER_NO#</a>
</cfoutput>
</td>
</tr>
</cfif>
</cfloop>
<tr>
<td colspan="2">
Toplam:
</td>
<td>
<cfif #GetDepoMiktar.MIKTAR# lt #TOPLAMMIK#>
<span style="color:red;font-weight:bold">
<i class="fa fa-times-circle-o"></i>
<cfoutput>
#TOPLAMMIK#
</cfoutput>
</span>
<cfelse>
<span style="color:green;font-weight:bold">
<i class="fa fa-check-circle-o"></i>
<cfoutput>
#TOPLAMMIK#
</cfoutput>
</span>
</cfif>
</td>
<td colspan="3">
</td>
</tr>
</cf_big_list>
</td>
</tr>
</cfif>
</cf_big_list>
</cfloop>

