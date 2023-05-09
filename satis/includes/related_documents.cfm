<cfif attributes.event eq "upd">
<cfquery name="getOrders" datasource="#dsn3#">
    SELECT O.ORDER_ID,O.ORDER_HEAD,O.ORDER_NUMBER,RECORD_DATE FROM #dsn3#.PBS_OFFER_TO_ORDER POTO
LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=POTO.ORDER_ID
 where POTO.OFFER_ID=#attributes.offer_id#
</cfquery>
<cfquery name="GEToRDERS2" datasource="#dsn3#">
    SELECT *
FROM ORDERS
WHERE ORDER_ID IN (
		SELECT ORDER_ID
		FROM ORDER_ROW
		WHERE WRK_ROW_RELATION_ID IN (
				SELECT UNIQUE_RELATION_ID 
				FROM PBS_OFFER_ROW
				WHERE OFFER_ID = #attributes.offer_id#
				)
		)
</cfquery>
<cf_box title="İlişkili Siparişler">
   
    <cf_ajax_list>
        <tr><th colspan="5">Satış Siparişleri</th></tr>
        <cfoutput query="getOrders">
            <tr>
                <td><a onclick="windowopen('/index.cfm?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#','page')"> #ORDER_NUMBER#</a></td>
                <td>#ORDER_HEAD#</td>
                <td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>                
                <td><a onclick=" windowopen('index.cfm?fuseaction=eshipping.emptypopup_add_prtotm_shipping&order_id=#ORDER_ID#','wide')">Sevk Talebi</a></td>
                <td><a onclick="windowopen('index.cfm?fuseaction=objects.popup_print_files&action=sales.list_order&action_id=#ORDER_ID#&print_type=73')"><i class="icon-print"></i></a></td>
            </tr>
        </cfoutput>
        <tr>
            <th colspan="5">
                Alış Siparişleri
            </th>
        </tr>
        <cfoutput query="GEToRDERS2">
            <tr>
                <td><a onclick="windowopen('/index.cfm?fuseaction=purchase.list_order&event=upd&order_id=#ORDER_ID#','page')"> #ORDER_NUMBER#</a></td>
                <td>#ORDER_HEAD#</td>
                <td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>                
                <td></td>
                <td><a onclick="windowopen('index.cfm?fuseaction=objects.popup_print_files&action=sales.list_order&action_id=#ORDER_ID#&print_type=73')"><i class="icon-print"></i></a></td>
            </tr>
        </cfoutput>
    </cf_ajax_list>
 
</cf_box>
<cf_box title="İlişkili Fatura ve İrsaliyeler">
    <cfquery name="getPeriods" datasource="#dsn#">
        SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR<>#session.ep.PERIOD_YEAR#
    </cfquery>
    <cfif getOrders.recordCount>
   <cfquery name="getoi" datasource="#dsn3#">        
   SELECT * FROM (SELECT 
ISNULL(ISNULL(I.INVOICE_NUMBER,I1.INVOICE_NUMBER),I2.INVOICE_NUMBER) AS ACTION_NUMBER
,ISNULL(ISNULL(I.INVOICE_ID,I1.INVOICE_ID),I2.INVOICE_ID) AS ACTION_ID
,ISNULL(ISNULL(I.INVOICE_DATE,I1.INVOICE_DATE),I2.INVOICE_DATE) AS ACTION_DATE
,OI.PERIOD_ID
,'FATURA' AS TIP,OI.ORDER_ID FROM workcube_metosan_1.ORDERS_INVOICE AS OI 
LEFT JOIN (SELECT *,3 AS PERIOD_ID FROM  workcube_metosan_2023_1.INVOICE  ) I ON OI.INVOICE_ID=I.INVOICE_ID AND OI.PERIOD_ID=I.PERIOD_ID
LEFT JOIN (SELECT *,2 AS PERIOD_ID FROM  workcube_metosan_2022_1.INVOICE  ) I1 ON OI.INVOICE_ID=I1.INVOICE_ID AND OI.PERIOD_ID=I1.PERIOD_ID
LEFT JOIN (SELECT *,1 AS PERIOD_ID FROM  workcube_metosan_2021_1.INVOICE  ) I2 ON OI.INVOICE_ID=I2.INVOICE_ID AND OI.PERIOD_ID=I2.PERIOD_ID
UNION 
SELECT 
ISNULL(ISNULL(I.SHIP_NUMBER,I1.SHIP_NUMBER),I2.SHIP_NUMBER) AS ACTION_NUMBER
,ISNULL(ISNULL(I.SHIP_ID,I1.SHIP_ID),I2.SHIP_ID) AS ACTION_ID
,ISNULL(ISNULL(I.SHIP_DATE,I1.SHIP_DATE),I2.SHIP_DATE) AS ACTION_DATE
,OI.PERIOD_ID

,'IRSALIYE' AS TIP,OI.ORDER_ID FROM workcube_metosan_1.ORDERS_SHIP AS OI 
LEFT JOIN (SELECT *,3 AS PERIOD_ID FROM  workcube_metosan_2023_1.SHIP  ) I ON OI.SHIP_ID=I.SHIP_ID AND OI.PERIOD_ID=I.PERIOD_ID
LEFT JOIN (SELECT *,2 AS PERIOD_ID FROM  workcube_metosan_2022_1.SHIP  ) I1 ON OI.SHIP_ID=I1.SHIP_ID AND OI.PERIOD_ID=I1.PERIOD_ID
LEFT JOIN (SELECT *,1 AS PERIOD_ID FROM  workcube_metosan_2021_1.SHIP  ) I2 ON OI.SHIP_ID=I2.SHIP_ID AND OI.PERIOD_ID=I2.PERIOD_ID
) AS OI

WHERE OI.ORDER_ID=#getOrders.ORDER_ID#
    </cfquery> 
<cf_ajax_list>
    <thead>
    <tr>
        <th>Belge No</th>
        <th>Belge Tipi</th>
        <th>Belge Tarihi</th>
    </tr>
</thead>
<tbody>
    <cfoutput query="getoi">
        <tr>
            
                <td>#ACTION_NUMBER# (#dateformat(ACTION_DATE,"dd/mm/yyyy")#)</td>
                <td>#TIP#</td>                                                
                <td> (#dateformat(ACTION_DATE,"dd/mm/yyyy")#)</td>       
            

        </tr>
    </cfoutput>
</tbody>
</cf_ajax_list></cfif>
</cf_box>

<cfif getOrders.recordCount and len(getOrders.ORDER_ID)>


<script>
    $("#btnsave").attr("disabled","true");
    $("#btnsave2").attr("disabled","true");
    $("#btnsil").attr("disabled","true");
</script>
<cfquery name="GETSVK" datasource="#DSN3#">
 SELECT DELIVER_PAPER_NO,RECORD_DATE,SHIP_RESULT_ID  FROM #dsn3#.PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID IN(
 SELECT SHIP_RESULT_ID FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW WHERE ORDER_ROW_ID IN( SELECT ORDER_ROW_ID FROM #dsn3#.ORDER_ROW WHERE ORDER_ID=#getOrders.ORDER_ID#))
 
</cfquery>
<cfif GETSVK.recordCount and len(GETSVK.DELIVER_PAPER_NO)>
    <script>
        $("#btnsave").attr("disabled","true");
        $("#btnsave2").attr("disabled","true");
        $("#btnsil").attr("disabled","true");
    </script>
</cfif>

<cf_box title="İlişkili Sevk Belgeleri">
    <cf_ajax_list>
        <cfoutput query="GETSVK">
            <tr>
                <td><a onclick="windowopen('/index.cfm?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','page')"> #DELIVER_PAPER_NO#</a></td>                
                <td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>
            </tr>
        </cfoutput>
    </cf_ajax_list>
</cf_box>
</cfif>



<cf_box title="İlişkili Üretim Emirleri">
    <cfquery name="getProductionOrders" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE UNIQUE_RELATION_ID IN (SELECT UNIQUE_RELATION_ID FROM PBS_OFFER_ROW WHERE OFFER_ID=#attributes.offer_id#)
</cfquery>

<cf_ajax_list>
<cfoutput query="getProductionOrders">
<tr>
    <td>
        <a onclick="windowopen('/index.cfm?fuseaction=production.emptypopup_detail_virtual_production_orders&p_order_id=#V_P_ORDER_ID#')" href="##_#V_P_ORDER_ID#">#V_P_ORDER_NO#- Detay</a>
    </td>
    <td>
        <a onclick="windowopen('/index.cfm?fuseaction=production.emptypopup_update_virtual_production_orders&VP_ORDER_ID=#V_P_ORDER_ID#')" href="##_#V_P_ORDER_ID#">#V_P_ORDER_NO# Aç</a>
    </td>
</tr>
</cfoutput>
</cf_ajax_list>
</cf_box>
</cfif>