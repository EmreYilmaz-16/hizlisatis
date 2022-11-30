<cfquery name="get_detail_info" datasource="#dsn3#">
	SELECT     
    	ESRR.SHIP_RESULT_ID, 
        ESRR.SHIP_RESULT_ROW_ID,
        ESRR.ORDER_ROW_AMOUNT AS QUANTITY,
        ORW.STOCK_ID, 
        ORW.PRODUCT_ID, 
        ORW.SPECT_VAR_ID,
        ORW.ORDER_ID, 
        PU.MAIN_UNIT, 
        S.STOCK_CODE, 
      	S.PRODUCT_NAME
	FROM         
    	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
        ORDER_ROW AS ORW ON ESRR.ORDER_ROW_ID = ORW.ORDER_ROW_ID INNER JOIN
        PRODUCT_UNIT AS PU ON ORW.PRODUCT_ID = PU.PRODUCT_ID INNER JOIN
        STOCKS AS S ON ORW.STOCK_ID = S.STOCK_ID
	WHERE     
    	ESRR.SHIP_RESULT_ID = #attributes.ship_result_id# AND 
        PU.IS_MAIN = 1
</cfquery>
<table id="iliskili_sevk_detay" width="590px">
	<tr>
		<td>
			 <cf_medium_list>
				<thead>
					<tr> 
						<th style="width:25px">S.No</th>
						<th style="width:100px">Stok Kodu</th>
						<th style="width:220px">Ürün</th>
                        <th style="width:70px">Spec</th>
                        <th style="width:70px">Miktar</th>
                        <th style="width:50px">Birim</th>
                        <!---<th style="width:20px"></th>--->
					</tr>
              	</thead>
                <tbody>
                	<cfif get_detail_info.recordcount>
                     	<cfoutput query="get_detail_info">
              				<tr>
                            	<td style="text-align:right">#currentrow#</td>
                                <td>#STOCK_CODE#</td>
                                <td>#PRODUCT_NAME#</td> 
                                <td>#SPECT_VAR_ID#</td>
                                <td style="text-align:right">#AmountFormat(QUANTITY)#</td>
                                <td>#MAIN_UNIT#</td>
                                <!---<td>
                                	<a href="javascript://" onClick="sil(#SHIP_RESULT_ROW_ID#,#ORDER_ID#);"><img src="/images/delete_list.gif" align="absmiddle" border="0"></a>
                                </td>--->     
                         	</tr>
                     	</cfoutput>
                  	</cfif>
              	</tbody>
          	 </cf_medium_list>            
		</td>
	</tr>
</table>
</table>
<script language="javascript">
	function sil(ship_result_row_id,order_id)
	{	
		window.location ='<cfoutput>#request.self#</cfoutput>?fuseaction=sevkiyat.emptypopup_del_PRTOTM_shipping&ship_result_row_id='+ship_result_row_id+'&order_id='+order_id;
	}
</script>