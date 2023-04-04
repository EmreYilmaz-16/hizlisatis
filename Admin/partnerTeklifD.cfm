<cfquery name="getQuery" datasource="#dsn3#">
select DISTINCT PO.OFFER_NUMBER, PO.OFFER_ID,C.NICKNAME,O.ORDER_ID,O.ORDER_NUMBER,SRR.DELIVER_PAPER_NO,SRR.SHIP_RESULT_ID,I.INVOICE_NUMBER,I.INVOICE_ID,S.SHIP_NUMBER,S.SHIP_ID,
PS.P_ORDER_NO,PS.RESULT_NO,PS.V_P_ORDER_NO,PS.P_ORDER_ID,PS.PR_ORDER_ID,
workcube_metosan.getEmployeeWithId(PO.RECORD_MEMBER) as EMPO from workcube_metosan_1.PBS_OFFER AS PO 
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=PO.COMPANY_ID
LEFT JOIN workcube_metosan_1.PBS_OFFER_TO_ORDER AS POTR ON POTR.OFFER_ID=PO.OFFER_ID
LEFT JOIN workcube_metosan_1.ORDERS AS O ON O.ORDER_ID=POTR.ORDER_ID
LEFT JOIN (
SELECT DISTINCT ORDER_ID,PSR.DELIVER_PAPER_NO,PSR.SHIP_RESULT_ID FROM workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS PSRR
LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT AS PSR ON PSR.SHIP_RESULT_ID=PSRR.SHIP_RESULT_ID
) AS SRR ON SRR.ORDER_ID=O.ORDER_ID
LEFT JOIN workcube_metosan_1.ORDERS_INVOICE AS OI ON OI.ORDER_ID=O.ORDER_ID AND OI.PERIOD_ID=2
LEFT JOIN workcube_metosan_2022_1.INVOICE AS I ON I.INVOICE_ID=OI.INVOICE_ID
LEFT JOIN workcube_metosan_1.ORDERS_SHIP AS OS ON OS.ORDER_ID=O.ORDER_ID AND OI.PERIOD_ID=2
LEFT JOIN workcube_metosan_2022_1.SHIP AS S ON S.SHIP_ID=OS.SHIP_ID
LEFT JOIN (
SELECT PORR.RESULT_NO,VPO.V_P_ORDER_NO,PO.P_ORDER_NO,POR.OFFER_ID,PORR.PR_ORDER_ID,PORR.P_ORDER_ID FROM  workcube_metosan_1.PBS_OFFER_ROW AS POR 
	LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS AS VPO ON VPO.UNIQUE_RELATION_ID=POR.UNIQUE_RELATION_ID
	LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS_RESULT AS VPOR ON VPOR.P_ORDER_ID=VPO.V_P_ORDER_ID
	LEFT JOIN workcube_metosan_1.PRODUCTION_ORDER_RESULTS AS PORR ON PORR.PR_ORDER_ID=VPOR.REAL_RESULT_ID
	LEFT JOIN workcube_metosan_1.PRODUCTION_ORDERS AS PO ON PO.P_ORDER_ID=PORR.P_ORDER_ID
) AS PS ON PS.OFFER_ID=PO.OFFER_ID
WHERE PO.RECORD_MEMBER NOT IN (43,40,1123)
AND YEAR(PO.RECORD_DATE)=#attributes.yil# AND Month(PO.RECORD_DATE)=#attributes.ay#  AND day(PO.RECORD_DATE)=#attributes.gun#
ORDER BY SHIP_NUMBER DESC


</cfquery>

<cf_big_list>
    <tr>
        <th></th>
        <th>Müşteri</th>
        <th>Kaydeden</th>
        <th>Sanal Teklif</th>
        <th>Sipariş</th>
        <th>SVK</th>
        <th>Fatura</th>
        <th>İrsaliye</th>
        <th>Üretim Emri</th>
        <th>Üretim Sonucu</th>
    </tr>
<cfoutput query="getQuery">
    <tr>
        <td>#currentrow#</td>
        <td>#NICKNAME#</td>
        <td>#EMPO#</td>
        <td><a href="/index.cfm?fuseaction=sales.list_pbs_offer&event=upd&offer_id=#OFFER_ID#" target="_blank">#OFFER_NUMBER#</a><a onclick="windowopen('/index.cfm?fuseaction=sales.emptypopup_delete_pbs_offer&offer_id=#OFFER_ID#')">Sil</a> </td>
        <td><a href="/index.cfm?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#" target="_blank">#ORDER_ID#</a></td>
        <td><a href="/index.cfm?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#" target="_blank">#DELIVER_PAPER_NO#</a></td>
        <td><a href="/index.cfm?fuseaction=invoice.form_add_bill&event=upd&iid=#INVOICE_ID#" target="_blank">#INVOICE_NUMBER#</a></td>
        <td><a href="/index.cfm?fuseaction=stock.form_add_sale&event=upd&ship_id=#SHIP_ID#" target="_blank">#SHIP_NUMBER#</a></td>
        <td><a href="/index.cfm?fuseaction=prod.order&event=upd&upd=#P_ORDER_ID#" target="_blank">#P_ORDER_NO#</a></td>
        <td><a href="/index.cfm?fuseaction=prod.list_results&event=upd&p_order_id=#P_ORDER_ID#&pr_order_id=#PR_ORDER_ID#" target="_blank">#RESULT_NO#</a></td>
    </tr>
</cfoutput>
</cf_big_list>