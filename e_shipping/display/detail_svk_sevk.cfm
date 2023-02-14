<cfquery name="GetSiparisData" datasource="#dsn3#">
SELECT ORR.QUANTITY
    ,ORR.UNIQUE_RELATION_ID
	,ISNULL(SR.AMOUNT, 0) AS SHIPPED_QUANTITY
	,ISNULL(SIFR.AMOUNT_H, 0) AS READY_QUANTITY
	,S.PRODUCT_NAME
	,S.PRODUCT_CODE
FROM workcube_metosan_1.PRTOTM_SHIP_RESULT AS PSR
LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS PSRR ON PSRR.SHIP_RESULT_ID = PSR.SHIP_RESULT_ID
LEFT JOIN workcube_metosan_1.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = PSRR.ORDER_ROW_ID
LEFT JOIN workcube_metosan_1.ORDERS_SHIP AS OS ON OS.ORDER_ID = ORR.ORDER_ID
LEFT JOIN (
	SELECT SUM(AMOUNT) AS AMOUNT
		,UNIQUE_RELATION_ID
		,SHIP_ID
	FROM workcube_metosan_2023_1.SHIP_ROW
	GROUP BY UNIQUE_RELATION_ID
		,SHIP_ID
	) AS SR ON SR.UNIQUE_RELATION_ID = orr.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID = ORR.STOCK_ID
LEFT JOIN (
	SELECT SUM(AMOUNT) AS AMOUNT_H
		,UNIQUE_RELATION_ID
	FROM workcube_metosan_2023_1.STOCK_FIS_ROW
	GROUP BY UNIQUE_RELATION_ID
	) AS SIFR ON SIFR.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE PSR.SHIP_RESULT_ID = #attributes.iid#

</cfquery>
<cf_box title="Sevk Durumları">
<cf_grid_list>
    <thead>
        <tr>
            <th></th>
            <th>Ürün Kodu</th>
            <th>Ürün Adı</th>
            <th>Sipariş Miktarı</th>
            <th>Sevk Edilen Miktar</th>
            <th>Hazırlanan Miktar</th>
            <th>Sevk Edilecek Miktar</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
    <cfoutput>
<cfloop query="GetSiparisData">
    <tr>
        <td>
            #currentrow#
        </td>
        <td>
            #PRODUCT_CODE#
        </td>
        <td>
            #PRODUCT_NAME#
        </td>
        <td>
            #QUANTITY#
        </td>
        <td>
            #SHIPPED_QUANTITY#
        </td>
        <td>#READY_QUANTITY#</td>
        <td>
            <input type="text" name="required_quantity_#UNIQUE_RELATION_ID#" value="#READY_QUANTITY-SHIPPED_QUANTITY#">
        </td>
        <td>
            <input type="checkbox" value="#UNIQUE_RELATION_ID#" name="quantity_vals">
        </td>
    </tr>
</cfloop>
</cfoutput>
</tbody>
</cf_grid_list>
</cf_box>