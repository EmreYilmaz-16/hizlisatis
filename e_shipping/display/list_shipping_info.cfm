<cf_box title="Stok Durumları">
<cfquery name="getShippingData" datasource="#dsn3#">
SELECT S.PRODUCT_CODE,S.PRODUCT_NAME,ORR.QUANTITY,ORR.ORDER_ROW_CURRENCY,workcube_metosan_2023_1.GET_SATILABILIR_STOCK(ORR.STOCK_ID) AS SATILABILIR,
		CASE 
	WHEN ORR.ORDER_ROW_CURRENCY=-2 THEN 'Tedarik' 
	WHEN ORR.ORDER_ROW_CURRENCY=-5 THEN 'Üretim' 
	WHEN ORR.ORDER_ROW_CURRENCY=-6 THEN 'Sevk' 
	WHEN ORR.ORDER_ROW_CURRENCY=-1 THEN 'Açık' 
	WHEN ORR.ORDER_ROW_CURRENCY=-10 THEN 'Kapatıldı (Manuel)'
	WHEN ORR.ORDER_ROW_CURRENCY=-3 THEN 'Kapatıldı'
END AS ASAMA

FROM #DSN3#.PRTOTM_SHIP_RESULT_ROW AS PSRR
 LEFT JOIN #DSN3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=PSRR.ORDER_ROW_ID
 LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID

WHERE SHIP_RESULT_ID=#attributes.iid#

</cfquery>

<cf_grid_list>
    <thead>
        <tr>
            <th>
                Ürün Kodu
            </th>
            <th>
                Ürün 
            </th>
            <th>
                Miktar
            </th>
            <th>
                Aşama
            </th>
            <th>
                Satılabilir Stok
            </th>
        </tr>
    </thead>
    <tbody>
<cfoutput query="getShippingData">
<tr>
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
        #ASAMA#
    </td>
    <td>
        #SATILABILIR#
    </td>
</tr>
</cfoutput>
</tbody>
</cf_grid_list>
</cf_box>