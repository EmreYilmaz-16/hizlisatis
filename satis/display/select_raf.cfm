<cf_box title="Raf Seç" scroll="1" collapsable="1" resize="1" popup_box="1">


<cfquery name="getShelves" datasource="#dsn3#">
SELECT PP.SHELF_CODE,SL.COMMENT,D.DEPARTMENT_HEAD,PP.LOCATION_ID,PP.STORE_ID FROM #DSN3#.PRODUCT_PLACE_ROWS AS PPR 
	LEFT JOIN #DSN3#.PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID=PP.PRODUCT_PLACE_ID
	LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID
	LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID 
WHERE PPR.STOCK_ID=#attributes.sid_# AND D.BRANCH_ID IN (
    SELECT D.BRANCH_ID FROM workcube_metosan.EMPLOYEE_POSITIONS AS EP INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID =EP.DEPARTMENT_ID
 WHERE EP.POSITION_CODE=#session.ep.POSITION_CODE#
)
</cfquery>
<cf_grid_list>
	<tr>
		<th>Raf</th>
		<th>Lokasyon</th>
		<th>Depo</th>
	</tr>
	<cfoutput query="getShelves">
		<tr>
			<td><a onClick="selectRafP(<cfoutput>#attributes.pid_#,#attributes.sid_#,'#attributes.stock_code#','#attributes.brand#',#attributes.is_virtual#,#attributes.amount#,#attributes.price#,'#attributes.product_name#',#attributes.tax#,#attributes.indirim1#,#attributes.product_type#,'#SHELF_CODE#','#attributes.other_money#',#attributes.price_other#,-6,#attributes.manuel#,#attributes.cost#,'#attributes.unit#','','',1,'#attributes.modal_id#',#attributes.rowNum#</cfoutput>);">#SHELF_CODE#</a></td>
			<td>#COMMENT#</td>
			<td>#DEPARTMENT_HEAD#</td>
		</tr>
	</cfoutput>
	
</cf_grid_list>
<button onclick="closeBoxDraggable(<cfoutput>'#attributes.modal_id#'</cfoutput>)">Kapa
</button>
<cf_box>

<script>
	 function selectRafP(
    product_id,
    stock_id,
    stock_code,
    brand_name,
    is_virtual,
    quantity,
    price,
    product_name,
    tax,
    discount_rate,
    poduct_type = 0,
    shelf_code = '',
    other_money = 'TL',
    price_other,
    currency = "-6",
    is_manuel = 0,
    cost = 0,
    product_unit = 'Adet',
    product_name_other='',
    detail_info_extra='',
    fc=1,
    modal_id,
    rowNum
    ){
        
        console.log(rowNum)

        AddRow(
        product_id,
    stock_id,
    stock_code,
    brand_name,
    is_virtual,
    quantity,
    price,
    product_name,
    tax,
    discount_rate,
    poduct_type,
    shelf_code ,
    other_money ,
    price_other,
    currency,
    is_manuel,
    cost,
    product_unit,
    product_name_other,
    '',
    fc,
    rowNum)
    
    closeBoxDraggable(modal_id);
}

</script>