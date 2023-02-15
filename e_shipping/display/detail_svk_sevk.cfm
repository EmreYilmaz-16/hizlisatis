<cfquery name="GetSiparisData" datasource="#dsn3#">
SELECT ORR.QUANTITY
    ,ORR.UNIQUE_RELATION_ID
    ,ORR.ORDER_ROW_ID
    ,ORR.ORDER_ID
	,ISNULL(SR.AMOUNT, 0) AS SHIPPED_QUANTITY
	,ISNULL(SIFR.AMOUNT_H, 0) AS READY_QUANTITY
	,S.PRODUCT_NAME
	,S.PRODUCT_CODE
    ,PSR.COMPANY_ID
    ,PSR.DEPARTMENT_ID
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
            <input type="hidden" value="#ORDER_ID#" name="row_order_id" id="row_order_id">
            <input type="hidden" value="#ORDER_ROW_ID#" name="row_order_row_id" id="row_order_row_id">            
            <input type="Checkbox" name="company_order_" id="company_order_" value="#ORDER_ID#;#ORDER_ROW_ID#;#COMPANY_ID#;#DEPARTMENT_ID#">

            <input type="checkbox" value="#UNIQUE_RELATION_ID#" name="quantity_vals">
        </td>
    </tr>
</cfloop>
</cfoutput>
</tbody>
</cf_grid_list>
</cf_box>


<script>
    function control_ship_amounts(form_row_no)
		{
			form_row_no = 1;
			satir_var = 0;
			
			if(eval('document.ship_detail_1.company_order_')!= undefined)
				var checked_item_= eval('document.ship_detail_1.company_order_');
			else if(eval('document.ship_detail_1.cons_order_') != undefined)
				var checked_item_= eval('document.ship_detail_1.cons_order_');
			
			if(checked_item_.length != undefined)
			{
				for(var xx=0; xx < checked_item_.length; xx++)
				{
					if(checked_item_[xx].checked)
					{
						ship_ = eval('document.ship_detail_1.row_order_id[' + xx + '].value');
						ship_row_id_ = eval('document.ship_detail_1.row_order_row_id[' + xx + '].value');
						eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value=filterNum(eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value,4);
						satir_var = 1;
					}
				}
			}
			else if(checked_item_.checked)
			{
				ship_row_id_ = eval('document.ship_detail_1.row_order_row_id.value');
				ship_ = eval('document.ship_detail_1.row_order_id.value');
				eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value=filterNum(eval('document.ship_detail_1.order_add_amount_' + ship_ + '_' + ship_row_id_).value,4);
				satir_var = 1;
			}
			if(satir_var==1)
				{
					
				ship_detail_1.action='index.cfm?fuseaction=objects.popup_add_order_to_ship&is_from_invoice=1&company_id=22781&is_return=0&order_detail=&is_sale_store=0&department_id=&list_type=2&sort_type=1&is_purchase=0&list_type=2';	
				
					if(ship_detail_1.action.includes("list_type")) {
						ship_detail_1.action='index.cfm?fuseaction=objects.popup_add_order_to_ship&is_from_invoice=1&company_id=22781&is_return=0&order_detail=&is_sale_store=0&department_id=&list_type=2&sort_type=1&is_purchase=0';
					}	
					
				ship_detail_1.submit();							
				}
			else
				{
				alert("Lütfen Satır Seçiniz !");
				return false;
				}
		}
</script>