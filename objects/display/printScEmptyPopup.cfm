<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

<cfif attributes.printType eq "STOK_FIS">
    <cfquery name="getRows" datasource="#dsn2#">
        
	SELECT SR.*,SL.COMMENT,D.DEPARTMENT_HEAD,S.PRODUCT_NAME,PP.SHELF_CODE,SL.LOCATION_ID,SL.DEPARTMENT_ID,S.BARCOD,CONVERT(varchar,SL.DEPARTMENT_ID)+'-'+CONVERT(VARCHAR,SL.LOCATION_ID) AS SSLT,S.STOCK_CODE FROM #DSN2#.STOCK_FIS_ROW AS SR 
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=SR.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=PP.STORE_ID
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID=PP.STORE_ID AND SL.LOCATION_ID=PP.LOCATION_ID
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=SR.STOCK_ID
WHERE FIS_ID=#attributes.ACTION_ID# ORDER BY SL.DEPARTMENT_ID,SL.LOCATION_ID 


    </cfquery>
     <table class="table" >
        <tr>
            <td style="height:40px;"><b><cf_get_lang dictionary_id='33929.Ürün Detay'></b></td>
        </tr>
    </table>
    <table class="table" style="width:190mm">
        <tr><td style="width:100px"></td>
            <td>Raf Kodu</td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57518.Inventory Code'></b></td>
            <td   style="width:300px"><b><cf_get_lang dictionary_id='57657.ÜRÜN'></b></td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57636.Adet'></b></td>
        </tr>
        <cfoutput query="getRows" group="SSLT">
            
        <tr><th colspan="5">#DEPARTMENT_HEAD#- #COMMENT#</th></tr>
            
            <cfoutput>
              
               <tr>
               
                <td style="text-align:center"><cf_workcube_barcode type="code128"  value="#getRows.BARCOD#" show="1" width="80" height="35"><br>
                    #BARCOD#
                </td>
                <td>#SHELF_CODE#</td>
                <td>#getRows.Stock_Code#</td>
                <td>#left(getRows.PRODUCT_NAME,53)#</td>
                <td  style="text-align:right;">#getRows.Amount#</td>
                <td>#getRows.Unit#</td>
            </tr>
            </cfoutput>
            
        </cfoutput>
</cfif>
<script>
    document
</script>
<script>
    $(document).ready(function (params) {
        $("#wrk_bug_add_div").remove();
        $("body").attr("style","background:white");

    })
</script>