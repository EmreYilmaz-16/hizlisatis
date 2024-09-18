<div class="row">
    <div class="col col-1">
        <cf_box>
			<div style="display: flex;flex-direction: column">
        <button type="button" onclick="windowopen('/index.cfm?fuseaction=objects.popup_print_files&action_id=<cfoutput>#attributes.P_ORDER_ID#</cfoutput>&print_type=281&action=prod.order')" class="ui-wrk-btn ui-wrk-btn-extra"><i class="icon-print"></i> &nbsp; Yazdır</button>
		<button type="button" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_mini_tools&tool_type=UE-TR&P_ORDER_ID=<cfoutput>#attributes.P_ORDER_ID#</cfoutput>&print_type=281&action=prod.order')" class="ui-wrk-btn ui-wrk-btn-extra"><i class="icn-md fa fa-exchange"></i> &nbsp; Karşılaştır</button>
	</div>
    </cf_box>
    </div>
    <div class="col col-11">
<cfquery name="getP" datasource="#dsn3#">
SELECT *
FROM (
	SELECT PO.P_ORDER_ID
		,PO.P_ORDER_NO
		,WS.STATION_NAME
		,S.PRODUCT_NAME
        ,S.PRODUCT_CODE
		,S.STOCK_ID
		,PO.SPECT_VAR_NAME
		,PO.START_DATE
		,PO.FINISH_DATE
		,PO.PROD_ORDER_STAGE
		,PO.LOT_NO
		,IS_STAGE
		,POR.ORDER_ROW_ID
		,ORR.DELIVER_DATE
		,PO.STATION_ID
		,PP.PROJECT_HEAD
		,PP.PROJECT_NUMBER
		,PO.PROJECT_ID
		,O.ORDER_NUMBER
		,ISNULL(TKSS.AMOUNT, 0) AMOUNT
		,PO.QUANTITY
		,C.NICKNAME
	FROM #DSN3#.PRODUCTION_ORDERS AS PO
	LEFT JOIN #DSN3#.WORKSTATIONS AS WS ON WS.STATION_ID = PO.STATION_ID
	LEFT JOIN #DSN#.PRO_PROJECTS AS PP ON PP.PROJECT_ID=PO.PROJECT_ID
	LEFT JOIN #DSN3#.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
	LEFT JOIN #DSN3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = POR.ORDER_ROW_ID
	LEFT JOIN #DSN3#.ORDERS AS O ON O.ORDER_ID = ORR.ORDER_ID
	LEFT JOIN #DSN#.COMPANY AS C ON C.COMPANY_ID = O.COMPANY_ID
	LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = PO.STOCK_ID
	LEFT JOIN (
		SELECT PORS.P_ORDER_ID
			,SUM(PORRA.AMOUNT) AS AMOUNT
		FROM #DSN3#.PRODUCTION_ORDER_RESULTS AS PORS
		LEFT JOIN #DSN3#.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID = PORS.PR_ORDER_ID
		WHERE 1 = 1
			AND PORRA.TYPE = 1
		GROUP BY PORS.P_ORDER_ID
		) AS TKSS ON TKSS.P_ORDER_ID = PO.P_ORDER_ID
	) AS T
 WHERE P_ORDER_ID=#attributes.P_ORDER_ID#
</cfquery>


<script>
    row_count_exit=0;
</script>

<!--- Üretim emrinde sarf ve fire oluşturma... --->
<cfsetting showdebugoutput="no">
<cfquery name="get_product_sarf" datasource="#DSN3#">
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
        POS.SPECT_VAR_ID,
		POS.AMOUNT,
		POS.PRODUCT_UNIT_ID,
		POS.SPECT_MAIN_ROW_ID,
        POS.LINE_NUMBER,
        POS.LOT_NO,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
        S.PROJECT_ID,
		PU.MAIN_UNIT,
		(SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME,
		ISNULL(POS.IS_PHANTOM,0) IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE,
        WRK_ROW_ID
	FROM 
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.P_ORDER_ID#"> AND
		TYPE = 2
	ORDER BY
		<cfif isdefined('is_line_number') and is_line_number eq 1>
        	POS.LINE_NUMBER
        <cfelse>
            POS.RECORD_DATE DESC
        </cfif>
</cfquery>
<cfset attributes.stock_id=getP.STOCK_ID>
<cf_box title="Üretim Emri - #getP.P_ORDER_NO#">
<cfoutput>
    <cf_ajax_list>
    <tr>
        <th>Müşteri</th>
        <td>#getP.NICKNAME#</td>
        <th>Sipariş</th>
        <td>#getP.ORDER_NUMBER#</td>       
        <th>Proje</th>
        <td>#getP.PROJECT_NUMBER# - #getP.PROJECT_HEAD#</td>
    </tr>
    <tr>
        <th>Ürün Kodu</th>
        <td>#getP.PRODUCT_CODE#</td>
        <th>Ürün</th>
        <td>#getP.PRODUCT_NAME#</td>
        <th>Üretilen Miktarı</th>
        <td>#getP.AMOUNT#</td>
        <th>Üretilecek Miktar</th>
        <td>#getP.QUANTITY#</td>
    </tr>
</cf_ajax_list>
</cfoutput>
<cf_seperator title="Ürün Ağacı" id="Agac" is_closed="0">
	<div id="Agac">
		<cfquery name="getPT" datasource="#dsn3#">
			SELECT S.PRODUCT_CODE,S.PRODUCT_NAME,PT.AMOUNT FROM PRODUCT_TREE AS PT INNER JOIN STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID
		</cfquery>
		<cf_grid_list>
			<tr>
				<th>
					Ürün K
				</th>
				<th>
					Ürün
				</th>
				<th>
					Miktar
				</th>
			</tr>
			<cfoutput query="getPT">
				<tr>
					<td>#PRODUCT_CODE#</td>
					<td>#PRODUCT_NAME#</td>
					<td>#tlformat(AMOUNT)#</td>
				</tr>
			</cfoutput>
		</cf_grid_list>
	</div>

<form name="add_production_order" id="add_production_order" action="index.cfm?fuseaction=production.emptypopup_upd_prtotm_real_po" method="post" >

    <input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.P_ORDER_ID#</cfoutput>" >
    <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >
	<cfinclude template="../../GeneralUsage/Production/SarfBasket.cfm">
	<cfif getP.AMOUNT eq getP.QUANTITY>

<span style="color:red">Üretim Tamamlanmıştır</span><cfelse><input type="button" class=" ui-wrk-btn ui-wrk-btn-primary" onclick="$('#add_production_order').submit()" value="Sarf Kaydet">  <input type="button" class=" ui-wrk-btn ui-wrk-btn-warning" onclick="UretimTamamla(<cfoutput>#attributes.p_order_id#,#getP.STATION_ID#</cfoutput>)" value="Üretimi Sonlandır"></cfif>
</form>
</cf_box>
<script>
    function UretimTamamla(poid,stationid){
        windowopen("/index.cfm?fuseaction=production.emptypopup_add_prod_order_result&JUSPORESULT=1&p_order_id="+poid+"&pws_id="+stationid)
    }
</script>
</div>
</div>