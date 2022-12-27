<cf_box title="Üretim Emirleri">
	<cfquery name="getEmpStation" datasource="#dsn3#">
		SELECT CONVERT(INT,COMMENT) COMMENT,EMP_ID FROM workcube_metosan_1.WORKSTATIONS WHERE COMMENT IS NOT NULL AND EMP_ID LIKE '%#session.ep.userid#%'
	</cfquery>
	<cfif getEmpStation.recordCount and len(COMMENT)>	
		<cfquery name="getProductionOrders" datasource="#dsn3#">			
			SELECT * FROM (
			select *,
			CASE WHEN IS_FROM_VIRTUAL =1 THEN (SELECT PRODUCT_TYPE FROM #DSN3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=VPO.STOCK_ID ) ELSE
			(SELECT DETAIL FROM #DSN1#.PRODUCT_CAT WHERE PRODUCT_CATID=(SELECT PRODUCT_CATID FROM #DSN1#.PRODUCT WHERE PRODUCT_ID=VPO.STOCK_ID)) END AS PRODUCT_TYPE
			from VIRTUAL_PRODUCTION_ORDERS  VPO
			LEFT JOIN VIRTUAL_PRODUCTION_ORDERS_RESULT AS VPOR ON VPOR.P_ORDER_ID=VPO.V_P_ORDER_ID
			) AS T WHERE T.PRODUCT_TYPE=#getEmpStation.COMMENT#
		</cfquery>
	</cfif>	
	<cf_big_list>
		<cfif isDefined("getProductionOrders")>
		<cfoutput query="getProductionOrders">
			<tr>
				<td>
					<a href="/index.cfm?fuseaction=production.emptypopup_update_virtual_production_orders&VP_ORDER_ID=#V_P_ORDER_ID#">#V_P_ORDER_NO#</a>
				</td>
			</tr>
		</cfoutput>
		</cfif>
	</cf_big_list>
</cf_box>