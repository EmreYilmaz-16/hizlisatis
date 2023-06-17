<cf_box title="Demonte Edilebilir Ürünler" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfquery name="getP" datasource="#dsn3#">
select DISTINCT PT.STOCK_ID,S.PRODUCT_NAME,S.PRODUCT_CODE,PT.AMOUNT,P.PRODUCT_ID,P.IS_DEMONTAGE ,
ISNULL((
			SELECT SUM(STOCK_IN - STOCK_OUT)
			FROM  #DSN2#.STOCKS_ROW
			WHERE STOCK_ID = S.STOCK_ID
				AND STORE = 45
			), 0) AS BAKIYE
from #DSN3#.PRODUCT_TREE  AS PT
LEFT JOIN #DSN3#.STOCKS AS S ON PT.STOCK_ID=S.STOCK_ID
LEFT JOIN workcube_metosan_product.PRODUCT AS P ON P.PRODUCT_ID=S.PRODUCT_ID
where RELATED_ID=#attributes.stock_id# AND IS_DEMONTAGE=1
</cfquery>

<cf_grid_list>
    <thead>
        <tr>
            <th>
                Ürün  K.
            </th>
            <th>
                Ürün
            </th>
            <th>
                Depo
            </th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="getP">
            <tr>
                <td>
                    #PRODUCT_CODE#
                </td>
                <td>
                    <a onclick="addCol(#STOCK_ID#,#attributes.miktar#,-1,0)">#PRODUCT_NAME#</a>
                </td>
                <td>
                     #tlformat(BAKIYE)#
                </td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>
</cf_box>