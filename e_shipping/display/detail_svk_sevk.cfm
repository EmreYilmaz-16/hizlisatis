<cfquery name="GetSiparisData" datasource="#dsn3#">
SELECT ORR.QUANTITY
	,SR.AMOUNT AS SHIPPED_QUANTITY
	,S.PRODUCT_NAME
	,S.PRODUCT_CODE
    ,ORR.UNIQUE_RELATION_ID
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
WHERE PSR.SHIP_RESULT_ID = 6413

</cfquery>
<cf_grid_list>
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
        <td>
            <input type="text" name="required_quantity_#UNIQUE_RELATION_ID#">
        </td>
        <td>
            <input type="checkbox" value="#UNIQUE_RELATION_ID#" name="quantity_vals">
        </td>
    </tr>
</cfloop>
</cfoutput>
</cf_grid_list>