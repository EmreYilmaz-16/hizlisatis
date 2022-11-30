<cfquery name="del_stock" datasource="#dsn3#">
	DELETE FROM 
    	PRODUCT_PLACE_ROWS
	WHERE        
    	PRODUCT_PLACE_ID = #attributes.product_place_id# AND 
        STOCK_ID = #attributes.stock_id#
</cfquery>
<script type="text/javascript">
	alert('Sat�r Silme ��lemi Tamamlanm��t�r !');
	wrk_opener_reload();
	window.close();
</script>
