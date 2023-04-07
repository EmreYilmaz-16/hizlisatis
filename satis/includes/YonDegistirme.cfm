<cfset main_product_id=datam.OlusacakUrun.PRODUCT_ID>
<cfset main_stock_id=datam.OlusacakUrun.STOCK_ID>
<cfquery name="getMaster" datasource="#datam.dataSources.dsn3#">
   SELECT S.*,PIP.PROPERTY1,PU.MAIN_UNIT,PB.BRAND_NAME  FROM workcube_metosan_1.STOCKS AS S
   LEFT JOIN workcube_metosan_1.PRODUCT_INFO_PLUS AS PIP ON PIP.PRODUCT_ID=S.PRODUCT_ID 
   LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND PU.IS_MAIN=1
   LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON S.BRAND_ID=PB.BRAND_ID
   WHERE S.STOCK_ID=main_stock_id>                
</cfquery>
<cfset attributes.STOCK_CODE=getMaster.PRODUCT_CODE>
<CFSET BRAND_NAME="#getMaster.BRAND_NAME#">
<cfset UrunAdi=datam.OlusacakUrun.PRODUCT_NAME>

<cfquery name="getShelf" datasource="#datam.dataSources.dsn3#">
    SELECT SHELF_CODE FROM workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR
    LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
    WHERE STOCK_ID =#main_stock_id#
</cfquery>




<CFSET RETURN_PRODUCT_ID=main_product_id>
<CFSET RETURN_STOCK_ID=main_stock_id>
<CFSET RETURN_PRODUCT_CODE=getMaster.PRODUCT_CODE>
<CFSET RETURN_BRAND_NAME=getMaster.BRAND_NAME>
<CFSET RETURN_PRODUCT_NAME=getMaster.PRODUCT_NAME>
<CFSET RETURN_TAX=getMaster.TAX>
<CFSET RETURN_UNIT=getMaster.MAIN_UNIT>
<CFSET RETURN_SHELF=getShelf.SHELF_CODE>