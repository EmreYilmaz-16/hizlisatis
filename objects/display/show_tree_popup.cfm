<cfquery name="gets" datasource="#dsn3#">
    SELECT * FROM STOCKS  WHERE STOCK_ID=#attributes.stock_id#
</cfquery>

<cf_box title="Ürün Ağacı: #gets.PRODUCT_NAME#" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfquery name="showq" datasource="#dsn3#">
    SELECT S.BARCOD,S.PRODUCT_NAME,S.PRODUCT_CODE,PT.QUESTION_ID,PT.AMOUNT,SQ.QUESTION_NAME,PU.MAIN_UNIT,PT.UNIT_ID FROM #DSN3#.PRODUCT_TREE AS PT
LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID
LEFT JOIN workcube_metosan.SETUP_ALTERNATIVE_QUESTIONS AS SQ ON SQ.QUESTION_ID=PT.QUESTION_ID
LEFT JOIN #DSN3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID
WHERE PT.STOCK_ID =#attributes.stock_id#
</cfquery>

<cf_ajax_list>
    <thead>
        <tr>
            <th>Ürün Kodu</th>
            <th>Ürün</th>
            <th>Miktar</th>
            <th>S</th>
        </tr>
        <tbody>
            <cfoutput query="showq">
            <tr>
                <td>#PRODUCT_CODE#</td>
                <td>#PRODUCT_NAME#</td>
                <td>#tlformat(AMOUNT)# #MAIN_UNIT#</td>
                <td>#QUESTION_NAME#</td>
            </tr>
        </cfoutput>
        </tbody>
    </thead>
</cf_ajax_list>
</cf_box>