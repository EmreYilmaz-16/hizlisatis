<cfquery name="getsTree" datasource="#dsn3#">
select AMOUNT,QUESTION_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,PU.MAIN_UNIT from workcube_metosan_1.PRODUCT_TREE   AS PT 
INNER JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID
INNER JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND IS_MAIN=1
  WHERE PT.STOCK_ID=#gets.STOCK_ID#
</cfquery>
<cfdump var="#getPo#">
<cfdump var="#gets#">
<cf_box title="Üretim Emri #getPo.V_P_ORDER_NO#">
<cf_big_list>
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
            Birim
        </th>
    </tr>
</thead>
    <cfoutput query="getsTree">
    <tr>
        <td>
            #PRODUCT_CODE#
        </td>
        <td>
            #PRODUCT_NAME#
        </td>
        <td>
            #AMOUNT#
        </td>
        <td>
            #MAIN_UNIT#
        </td>
    </tr>
</cfoutput>
</cf_big_list>
</cf_box>