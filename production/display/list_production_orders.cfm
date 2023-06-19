<cf_box title="Üretim Emirleri">
	<cfquery name="getEmpStation" datasource="#dsn3#">
		SELECT CONVERT(INT,COMMENT) COMMENT,EMP_ID FROM #DSN3#.WORKSTATIONS WHERE COMMENT IS NOT NULL AND EMP_ID LIKE '%#session.ep.userid#%'
	</cfquery>
		<cfquery name="getEmpStation2" datasource="#dsn3#">
			SELECT STATION_ID,EMP_ID FROM #DSN3#.WORKSTATIONS WHERE 1=1 AND EMP_ID LIKE '%#session.ep.userid#%'
		</cfquery>
	<CFSET TSLIST=valueList(getEmpStation.COMMENT)>
	<CFSET TSLIS2T=valueList(getEmpStation.STATION_ID)>
	<cfif getEmpStation.recordCount and len(getEmpStation.COMMENT)>	
		<cfquery name="getProductionOrders" datasource="#dsn3#">			
		SELECT T.*,C.NICKNAME,T.QUANTITY,POR.PRODUCT_NAME FROM (
				select VPO.*,VPOR.P_ORDER_RESULT_ID,VPOR.REAL_RESULT_ID,
			CASE WHEN IS_FROM_VIRTUAL =1 THEN (SELECT PRODUCT_TYPE FROM #DSN3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=VPO.STOCK_ID ) ELSE
			(SELECT DETAIL FROM #DSN3#.PRODUCT_CAT WHERE PRODUCT_CATID=(SELECT PRODUCT_CATID FROM #DSN3#.PRODUCT WHERE PRODUCT_ID=VPO.STOCK_ID)) END AS PRODUCT_TYPE
			from #DSN3#.VIRTUAL_PRODUCTION_ORDERS  VPO
			LEFT JOIN #DSN3#.VIRTUAL_PRODUCTION_ORDERS_RESULT AS VPOR ON VPOR.P_ORDER_ID=VPO.V_P_ORDER_ID
			) AS T 
			LEFT JOIN #DSN3#.PBS_OFFER_ROW AS POR ON POR.UNIQUE_RELATION_ID =T.UNIQUE_RELATION_ID
LEFT JOIN #DSN3#.PBS_OFFER AS PO ON PO.OFFER_ID=POR.OFFER_ID
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PO.COMPANY_ID
LEFT JOIN #DSN3#.STOCKS AS S ON S.PRODUCT_ID=POR.STOCK_ID
 WHERE T.PRODUCT_TYPE IN(#TSLIST#) and  T.REAL_RESULT_ID IS NULL
		</cfquery>
	<cfquery name="getProductionOrders2" datasource="#DSN3#">
SELECT * FROM (
SELECT PO.P_ORDER_ID,PO.P_ORDER_NO,WS.STATION_NAME,PO.SPECT_VAR_NAME,PO.START_DATE,PO.FINISH_DATE,PO.PROD_ORDER_STAGE,PO.LOT_NO,IS_STAGE,POR.ORDER_ROW_ID,ORR.DELIVER_DATE,PO.STATION_ID,O.ORDER_NUMBER,ISNULL(TKSS.AMOUNT,0) AMOUNT,PO.QUANTITY FROM workcube_metosan_1.PRODUCTION_ORDERS  AS PO
LEFT JOIN workcube_metosan_1.WORKSTATIONS AS WS ON WS.STATION_ID=PO.STATION_ID
LEFT JOIN workcube_metosan_1.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID=PO.P_ORDER_ID
LEFT JOIN workcube_metosan_1.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=POR.ORDER_ROW_ID
LEFT JOIN workcube_metosan_1.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID =O.COMPANY_ID
LEFT JOIN ( SELECT PORS.P_ORDER_ID,SUM(PORRA.AMOUNT) AS AMOUNT FROM workcube_metosan_1.PRODUCTION_ORDER_RESULTS AS PORS 
 LEFT JOIN workcube_metosan_1.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID=PORS.PR_ORDER_ID
 WHERE 1=1 AND PORRA.TYPE=1 GROUP BY PORS.P_ORDER_ID) AS TKSS ON TKSS.P_ORDER_ID=PO.P_ORDER_ID ) AS T
 WHERE T.AMOUNT <>QUANTITY AND T.STATION_ID IN (#TSLIS2T#)

	</cfquery>
	</cfif>	
	<cf_big_list>
		<thead>
			<tr>
				<th>
					Üretim Emri
				</th>
				<th>
					Ürün
				</th>
				<th>
					Müşteri
				</th>
				<th>
					Miktar
				</th>
			</tr>
		</thead>
		<cfif isDefined("getProductionOrders")>
		<cfoutput query="getProductionOrders">
			<tr>
				
				<td>
					<a href="/index.cfm?fuseaction=production.emptypopup_update_virtual_production_orders&VP_ORDER_ID=#V_P_ORDER_ID#">#V_P_ORDER_NO#</a>
				</td>
				<td>#PRODUCT_NAME#</td>
				<td>#NICKNAME#</td>
				<td>#QUANTITY#</td>
			</tr>
		</cfoutput>
		</cfif>
		<cfif isDefined("getProductionOrders2")>
			<cfoutput query="getProductionOrders2">
				<tr>
					
					<td>
						<a href="/index.cfm?fuseaction=production.emptypopup_update_virtual_production_orders&VP_ORDER_ID=#V_P_ORDER_ID#">#V_P_ORDER_NO#</a>
					</td>
					<td>#PRODUCT_NAME#</td>
					<td>#NICKNAME#</td>
					<td>#QUANTITY#</td>
				</tr>
			</cfoutput>
			</cfif>
	</cf_big_list>
</cf_box>


