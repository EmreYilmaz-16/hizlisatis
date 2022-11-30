<cfquery name="GetDepoStock" datasource="#dsn2#">
SELECT [PRODUCT_STOCK]
      ,[PRODUCT_ID]
      ,[STOCK_ID]
      ,[STOCK_CODE]
      ,[PROPERTY]
      ,[STOCK_STATUS]
      ,[BARCOD]
      ,[STORE]
      ,[STORE_LOCATION]
  FROM [catalystTest].[catalystTest_2019_1].[GET_STOCK_LOCATION_TOTAL] where PRODUCT_STOCK>0 and STORE_LOCATION=0
</cfquery>



<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.5.6/css/buttons.dataTables.min.css">
<cfset kayitsayisi=GetDepoStock.recordcount>
<cf_big_list id="Tablo1">
<thead>
<tr>
<th>
Üretici Kodu
</th>
<th>Ürün Adı</th>
<th>
Miktar
</th>
<th></th>
</tr>
</thead>
<tbody>
<cfloop from="1" to="#kayitsayisi#" index="i" step="1">
<cfquery name="GetManufactCode" datasource="#dsn1#">
select TOP(1) MANUFACT_CODE,PRODUCT_NAME FROM catalystTest_product.PRODUCT WHERE PRODUCT_ID=#GetDepoStock.PRODUCT_ID[i]#
</cfquery>
<tr>
<td>
<cfoutput>
#GetManufactCode.MANUFACT_CODE#
</cfoutput>
</td>
<td>
<cfoutput>#GetManufactCode.PRODUCT_NAME#</cfoutput></td>
<td>
<cfoutput>
#GetDepoStock.PRODUCT_STOCK[i]#
</cfoutput>
</td>
<td>
<cfoutput>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#GetDepoStock.STOCK_ID[i]#&product_id=#GetDepoStock.PRODUCT_ID[i]#','page');"><img src="/images/cuberelation.gif" title="Lokasyonlara Göre Stoklar" border="0"></a>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping_Emre&id=#GetDepoStock.PRODUCT_ID[i]#','page');"title="Alınan Siparisler"><img src="/images/ship.gif" title="Alınan Siparişler" border="0"></a>
</cfoutput>
</td>
</tr>
</cfloop>
<tbody>
</cf_big_list>


<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.5.6/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.flash.min.js"></script>
<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.html5.min.js"></script>
<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.5.6/js/buttons.print.min.js"></script>
<script>
$(document).ready( function () {
    $('#Tablo1').DataTable({
        dom: 'Bfrtip',
		   lengthMenu: [
            [ 10, 25, 50, -1 ],
            [ '10 rows', '25 rows', '50 rows', 'Show all' ]
        ],
        buttons: [
        'excel', 'pdf', 'print','pageLength'
        ]
    } );
} );
</script>