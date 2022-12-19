<cf_box title="Make Tube" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfdump var="#attributes#">

<cfquery name="getShelves" datasource="#dsn3#">
SELECT PP.SHELF_CODE,SL.COMMENT,D.DEPARTMENT_HEAD,PP.LOCATION_ID,PP.STORE_ID FROM workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR 
	LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID=PP.PRODUCT_PLACE_ID
	LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID
	LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID
WHERE PPR.STOCK_ID=#attributes.sid_#
</cfquery>
<cf_grid_list>
	<tr>
		<th>Raf</th>
		<th>Lokasyon</th>
		<th>Depo</th>
	</tr>
	<cfoutput query="getShelves">
		<tr>
			<td>#SHELF_CODE#</td>
			<td>#COMMENT#</td>
			<td>#DEPARTMENT_HEAD#</td>
		</tr>
	</cfoutput>
	
</cf_grid_list>
<button onclick="closeBoxDraggable(<cfoutput>'#attributes.modal_id#'</cfoutput>)">Kapa
</button>
<cf_box>