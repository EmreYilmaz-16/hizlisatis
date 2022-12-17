<cfif attributes.event eq "upd">
<cfquery name="getOrders" datasource="#dsn3#">
    SELECT O.ORDER_ID,O.ORDER_HEAD,O.ORDER_NUMBER,RECORD_DATE FROM #dsn3#.PBS_OFFER_TO_ORDER POTO
LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=POTO.ORDER_ID
 where POTO.OFFER_ID=#attributes.offer_id#
</cfquery>

<cf_box title="İlişkili Siparişler">
    <cf_ajax_list>
        <cfoutput query="getOrders">
            <tr>
                <td><a onclick="windowopen('/index.cfm?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#','page')"> #ORDER_NUMBER#</a></td>
                <td>#ORDER_HEAD#</td>
                <td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>
                <td><a onclick=" windowopen('index.cfm?fuseaction=eshipping.emptypopup_add_prtotm_shipping&order_id=#ORDER_ID#','wide')"></a></td>
            </tr>
        </cfoutput>
    </cf_ajax_list>
</cf_box>


<cfif getOrders.recordCount and len(getOrders.ORDER_ID)>
<script>
    $("#btnsave").attr("disabled","true")
</script>
<cfquery name="GETSVK" datasource="#DSN3#">
 SELECT DELIVER_PAPER_NO,RECORD_DATE,SHIP_RESULT_ID  FROM #dsn3#.PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID IN(
 SELECT SHIP_RESULT_ID FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW WHERE ORDER_ROW_ID IN( SELECT ORDER_ROW_ID FROM #dsn3#.ORDER_ROW WHERE ORDER_ID=#getOrders.ORDER_ID#))
 
</cfquery>

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
        <a onclick="windowopen('/index.cfm?fuseaction=production.emptypopup_detail_virtual_production_orders&p_order_id=#V_P_ORDER_ID#')" href="##_#V_P_ORDER_ID#">#V_P_ORDER_NO#</a>
    </td>
</tr>
</cfoutput>
</cf_ajax_list>
</cf_box>
</cfif>