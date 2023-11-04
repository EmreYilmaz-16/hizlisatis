<cfdump var="#attributes#">
<cfif attributes.printType eq "STOK_FIS">
    <cfquery name="getRows" datasource="#dsn2#">
        
	SELECT SR.*,SL.COMMENT,D.DEPARTMENT_HEAD,PP.SHELF_CODE,SL.LOCATION_ID,SL.DEPARTMENT_ID,S.BARCOD,CONVERT(varchar,SL.DEPARTMENT_ID)+'-'+CONVERT(VARCHAR,SL.LOCATION_ID) AS SSLT,S.STOCK_CODE FROM #DSN2#.STOCK_FIS_ROW AS SR 
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=SR.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=PP.STORE_ID
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID=PP.STORE_ID AND SL.LOCATION_ID=PP.LOCATION_ID
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=SR.STOCK_ID
WHERE FIS_ID=#attributes.ACTION_ID# ORDER BY SL.DEPARTMENT_ID,SL.LOCATION_ID 


    </cfquery>
    <cfdump var="#getRows#">
</cfif>

<script>
    $(document).ready(function (params) {
        $("#wrk_bug_add_div").remove();

    })
</script>