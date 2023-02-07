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
	<cfif isDefined("attributes.stock_id_1")>
	and	P.PRODUCT_ID=#attributes.stock_id_1#
	</cfif>
	ORDER BY DD
	</cfquery>
	
	<cfset kayitsayisi=GetLocationStocks.recordcount>
	
	<cfloop from="1" to="#kayitsayisi#" index="i" step="1">
		<cfquery name="GetDepoMiktar" datasource="#dsn2#">
			select sum(STOCK_IN-STOCK_OUT) AS MIKTAR FROM #dsn2#.STOCKS_ROW WHERE STOCK_ID=#GetLocationStocks.STOCK_ID[i]# AND STORE_LOCATION = 1 AND STORE=44
		</cfquery>
		<cfquery name="getOrderAmount" datasource="#dsn3#">
			SELECT SUM(ordr.QUANTITY) AS QUANTITY
			FROM workcube_metosan_1.ORDER_ROW AS ordr
				,workcube_metosan_1.ORDERS AS ord
			WHERE 1 = 1
				 AND STOCK_ID = #GetLocationStocks.STOCK_ID[i]#
				AND ORDER_ROW_CURRENCY = - 6
				AND ord.ORDER_ID = ordr.ORDER_ID
				AND ord.PURCHASE_SALES = 1
		
			
		</cfquery>
		<cfquery name="getOrderList" datasource="#dsn3#">
				
		SELECT c.FULLNAME
			,SUM(ordr.QUANTITY) AS QUANTITY
			,ord.ORDER_DATE
			,ord.ORDER_ID
			,ord.ORDER_NUMBER
		FROM #dsn3#.ORDER_ROW AS ordr
			,#dsn3#.ORDERS AS ord
			,#dsn#.COMPANY AS c
		WHERE STOCK_ID = #GetLocationStocks.STOCK_ID[i]#
			AND ORDER_ROW_CURRENCY = -6
			AND ord.ORDER_ID = ordr.ORDER_ID
			AND c.COMPANY_ID = ord.COMPANY_ID
			AND ord.PURCHASE_SALES=1
			GROUP BY C.FULLNAME,ord.ORDER_DATE,ord.ORDER_ID,ord.ORDER_NUMBER
			order by ord.ORDER_DATE asc
					
		</cfquery>
		<cfset SiparisMiktari=0>
		<cfif getOrderAmount.recordCount>
			<cfset SiparisMiktari=getOrderAmount.QUANTITY>
		</cfif>
	<cf_box title="#GetLocationStocks.PRODUCT_NAME[i]# #GetLocationStocks.STOCK_ID[i]# " resize="0" collapsable="0">
		
		<table>
			<tr><td>
			<cf_grid_list>
				<thead>
					<tr>
						<th colspan="4">Ürün Durumu</th>
					</tr>
				</thead>
				<tbody>
				<tr>
					<td style="font-weight:bold">
						Depo Miktarı
					</td>
					<td style="text-align:right">
						<cfoutput>#TLFORMAT(GetDepoMiktar.MIKTAR)#</cfoutput>
					</td>
					<td style="font-weight:bold">
						T.Sipariş Miktarı
					</td>
					<td style="text-align:right">
						<cfoutput>#TLFORMAT(SiparisMiktari)#</cfoutput>
					</td>
				</tr>
			</tbody>
			</cf_grid_list>
		</td>
		<td>
			<cfif getOrderList.recordCount >
			<cf_grid_list>
				<thead>
				<tr>
					<th>
						Müşteri
					</th>
					<th>Sipariş No</th>
					<th>Sipariş T</th>
					<th>
						Sipariş Miktarı
					</th>
					<th>
						Hazırlanan Miktar
					</th>
					<th>İlişkili Sevk Belgeleri</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="getOrderList">
					<cfquery name="OrderToShip" datasource="#dsn3#">
						select * from #dsn3#.ORDERS_SHIP where ORDER_ID=#getOrderList.ORDER_ID#
					</cfquery>
					<cfset abc=0>
					<cfif OrderToShip.recordcount gt 0>
						<cfset abc=valueList(OrderToShip.SHIP_ID)>
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
							AND esrr.ORDER_ID=#getOrderList.ORDER_ID#
							AND ORR.PRODUCT_ID=#GetLocationStocks.PRODUCT_ID[i]#
							AND ( ORR.ORDER_ROW_CURRENCY <>-3 OR ORR.ORDER_ROW_CURRENCY <>-10)
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
											AND SF.DEPARTMENT_OUT=44 AND SF.LOCATION_OUT=1
										
						</cfquery>
						
						<cfset giden=0>
						<cfif control_info.recordcount gt 0>
						<cfset giden=control_info.CONTROL_AMOUNT>
						</cfif>
					<tr>
						<td>
							<cfoutput>#getOrderList.FULLNAME#</cfoutput>
						</td>
						<td><cfoutput>#getOrderList.ORDER_NUMBER#</cfoutput></td>
						<td><cfoutput>#dateformat(getOrderList.ORDER_DATE,"dd/mm/yyyy")#</cfoutput></td>
						<td style="text-align:right">
							<cfoutput>#tlformat(getOrderList.QUANTITY)#</cfoutput>
						</td>
						<td>
							<cfoutput>#tlformat(giden)#</cfoutput>
						</td>
						<td>
							<ul style="margin:0">
							<cfloop query="GetSVKNO">
							<li><cfoutput>#GetSVKNO.DELIVER_PAPER_NO#</cfoutput></li>	
							</cfloop>
						</ul>
						</td>
					</tr>
				</cfloop>
			</tbody>
			</cf_grid_list>
		</cfif>
		</td>
	</tr>
		</table>
		
		
	</cf_box>
	
	
	
	<!----<cf_big_list>
		<tr>
			<th>
				<cfoutput>#GetLocationStocks.PRODUCT_NAME[i]#</cfoutput>
			</th>
		
			
			<th>
				<cfoutput>Depo Miktarı : #TLFORMAT(GetDepoMiktar.MIKTAR)#</cfoutput>
			</th>
		</tr>
		<tr>
			<td colspan="2">
			
					<cf_big_list>
						<cfloop from="1" to="#GetSiparisler.recordCount#" index="j">
							<tr>
								<td>
									<cfoutput>
										#GetSiparisler.FULLNAME[j]#
									</cfoutput>
								</td>
								<td></td>
								<td><cfoutput>
									#GetSiparisler.QUANTITY[j]#
								</cfoutput></td>
							</tr>
						</cfloop>
					</cf_big_list>
			</td>
		</tr>
	</cf_big_list>
		
	<div style="height:10px;background:black"></div>----->
	
	</cfloop>
	
	
	
	
	<!---
	<cfset kayitsayisi=GetLocationStocks.recordcount>
	<cfloop from="1" to="#kayitsayisi#" index="i" step="1">
	<cf_big_list>
	
	<cfset TOPLAMMIK=0>
	
	
	<cfset Sipsayisi=GetSiparisler.recordcount>
	
	<cfif Sipsayisi gt 0> 
		
	<tr>
	<th style="width:30%">
	<h5>
	<cfoutput>
	Ürün Üretici Kodu: <b>#GetLocationStocks.MANUFACT_CODE[i]#</b> Sipariş Sayısı #Sipsayisi#
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
	<cfset abc=valueList(OrderToShip.SHIP_ID)>
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
		AND ( ORR.ORDER_ROW_CURRENCY <>-3 OR ORR.ORDER_ROW_CURRENCY <>-10)
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
						AND SF.DEPARTMENT_OUT=44 AND SF.LOCATION_OUT=1
					
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
	<a href="##" onclick="windowopen('index.cfm?fuseaction=eshipping.emptypopup_add_prtotm_shipping&order_id=#GetSiparisler.ORDER_ID[j]#','page')">
	#dateformat(GetSiparisler.ORDER_DATE[j],"dd/mm/yyyy")#</a>
	#GetSiparisler.ORDER_DATE[j]#
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
	<a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#&is_type=1','page');" title="Alınan Siparisler">#DELIVER_PAPER_NO#</a>
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
	
	----->