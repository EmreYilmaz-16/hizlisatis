<cfset module_name="sales">
<cfquery name="Bekleyen_Satis" datasource="#dsn3#">
SELECT ORD.ORDER_NUMBER
	,ORD.ORDER_DATE
	,C.FULLNAME
	,ORD.ORDER_ID
	,SUM(ORR.QUANTITY) AS TOPMIK
FROM catalystTest_1.ORDER_ROW AS ORR
	,catalystTest_1.ORDERS AS ORD
	,catalystTest.COMPANY AS C
WHERE STOCK_ID = #attributes.id#
	AND ORR.ORDER_ID = ORD.ORDER_ID
	AND C.COMPANY_ID = ORD.COMPANY_ID
	AND ORD.PURCHASE_SALES=1
	AND ORDER_ROW_CURRENCY = '-6'
GROUP BY ORD.ORDER_ID,ORD.ORDER_NUMBER,ORD.ORDER_DATE,C.FULLNAME
</cfquery>
<cfset kayitsayisi=Bekleyen_Satis.recordcount>
<cf_popup_box title="Bekleyen Siparişler">
<cf_medium_list>
<tr>
	<td>Sipariş No</td>
	<td>Firma Adı</td>
	<td>Sipariş Miktarı</td>
	<td>İrsaliyeleşmiş Miktar</td>
	<td>Kalan Miktar</td>
	<td>SVK No</td>
	
</tr>
<cfloop from="1" to="#kayitsayisi#" index="i" step="1">
<cfquery name="GetSVKNO" datasource="#dsn3#">
	SELECT *
	FROM catalystTest_1.PRTOTM_SHIP_RESULT_ROW AS ESRR
		,catalystTest_1.PRTOTM_SHIP_RESULT AS ESR
	WHERE ESRR.ORDER_ID = #Bekleyen_Satis.ORDER_ID[i]#
		AND ESRR.ORDER_ID = #Bekleyen_Satis.ORDER_ID[i]#
		and ESRR.ORDER_ROW_ID in(select ORDER_ROW_ID from catalystTest_1.ORDER_ROW where PRODUCT_ID=#attributes.id# and ORDER_ID=#Bekleyen_Satis.ORDER_ID[i]#)
		AND ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
</cfquery>
<cfquery name="getOrdSh" datasource="#dsn3#">
	select * from catalystTest_1.ORDERS_SHIP where ORDER_ID=#Bekleyen_Satis.ORDER_ID[i]#
</cfquery>
<cfset abc=0>
<cfif getOrdSh.recordcount gt 0>
<cfset abc=getOrdSh.SHIP_ID>
</cfif>
<cfquery name="as1" datasource="#dsn3#">
	select sum(AMOUNT) AS G,PRODUCT_ID,NAME_PRODUCT from catalystTest_2019_1.SHIP_ROW where SHIP_ID in (#abc#) GROUP BY PRODUCT_ID,NAME_PRODUCT having PRODUCT_ID=#attributes.id#
</cfquery>
<cfset giden=0>
<cfif as1.recordcount gt 0>
<cfset giden=as1.G>
</cfif>
<cfquery name="as2" datasource="#dsn3#">
	select SUM(QUANTITY) AS M ,PRODUCT_ID,PRODUCT_NAME from catalystTest_1.ORDER_ROW where ORDER_ID in (#Bekleyen_Satis.ORDER_ID[i]#)  GROUP BY PRODUCT_ID,PRODUCT_NAME having PRODUCT_ID=#attributes.id#
</cfquery>
<cfset sip=0>
<cfif as2.recordcount gt 0>
<cfset sip=as2.M>
</cfif>
<tr>
<td>
<cfoutput>
<a href="#request.self#?fuseaction=sales.list_order&amp;event=upd&amp;order_id=#Bekleyen_Satis.ORDER_ID[i]#" class="tableyazi" target="_blank">#Bekleyen_Satis.ORDER_NUMBER[i]#</a>
</cfoutput>
</td>
<td><cfoutput>#Bekleyen_Satis.FULLNAME[i]#</cfoutput></td>
<td><cfoutput>#Bekleyen_Satis.TOPMIK[i]#</cfoutput></td>
<td>
<cfoutput>
#giden#
</cfoutput>
</td>
<td>
<cfoutput>
#(sip-giden)#
</cfoutput>
</td>
<td>
<table>
<cfoutput query="GetSVKNO">
<tr><td>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping&iid=#SHIP_RESULT_ID#','page');" title="Alınan Siparisler">#DELIVER_PAPER_NO#</a>
</td></tr>
</cfoutput>
</table>
</td>

</tr>
</cfloop>
</cf_medium_list>
</cf_popup_box>
