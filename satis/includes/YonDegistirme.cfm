<cfset main_product_id=datam.OlusacakUrun.PRODUCT_ID>
<cfset main_stock_id=datam.OlusacakUrun.STOCK_ID>
<cfquery name="getMaster" datasource="#datam.dataSources.dsn3#">
   SELECT S.*,PIP.PROPERTY1,PU.MAIN_UNIT,PB.BRAND_NAME  FROM workcube_metosan_1.STOCKS AS S
   LEFT JOIN workcube_metosan_1.PRODUCT_INFO_PLUS AS PIP ON PIP.PRODUCT_ID=S.PRODUCT_ID 
   LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND PU.IS_MAIN=1
   LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON S.BRAND_ID=PB.BRAND_ID
   WHERE S.STOCK_ID=main_stock_id>                
</cfquery>
 <cfquery name="get_purchase_price_info" datasource="#datam.dataSources.dsn1#">
   SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
</cfquery>
<cfquery name="get_sales_price_info" datasource="#datam.dataSources.dsn1#">
   SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
</cfquery>
<cfset attributes.STOCK_CODE=getMaster.PRODUCT_CODE>
<cfset UrunAdi=datam.OlusacakUrun.PRODUCT_NAME>
<cfset birim=getMaster.MAIN_UNIT>
<CFSET BRAND_NAME="#getMaster.BRAND_NAME#">
<cfif getMaster.PROPERTY1 EQ 'MANUEL'>
   <cfset IS_MANUEL=1>
</cfif>
<cfquery name="getLastCost" datasource="#dsn2#">
   SELECT TOP 1
       IR.PRICE-(IR.DISCOUNTTOTAL/2) AS PRICE
   FROM
       INVOICE I
       LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
   WHERE
       ISNULL(I.PURCHASE_SALES,0) = 0 AND
       IR.PRODUCT_ID = #main_product_id#
       AND I.PROCESS_CAT<>35
   ORDER BY
       I.INVOICE_DATE DESC
</cfquery>
<cfif getLastCost.RecordCount AND Len(getLastCost.PRICE)>
   <cfset COST = getLastCost.PRICE>
</cfif>

<cfquery name="getDiscount" datasource="#dsn3#">
   SELECT TOP 1
       PCE.DISCOUNT_RATE
   FROM
       PRODUCT P,
       PRICE_CAT_EXCEPTIONS PCE
       LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
   WHERE
       (
           PCE.PRODUCT_ID = P.PRODUCT_ID OR
           PCE.PRODUCT_ID IS NULL
       ) AND
       (
           PCE.BRAND_ID = P.BRAND_ID OR
           PCE.BRAND_ID IS NULL
       ) AND
       (
           PCE.PRODUCT_CATID = P.PRODUCT_CATID OR
           PCE.PRODUCT_CATID IS NULL
       ) AND
       (
           PCE.COMPANY_ID = #datam.offer_data.comp_id# OR
           PCE.COMPANY_ID IS NULL
       ) AND
       P.PRODUCT_ID = #main_product_id# AND
       ISNULL(PC.IS_SALES,0) = 1 AND
       PCE.ACT_TYPE NOT IN (2,4) AND 
       PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#datam.offer_data.price_catid#">
   ORDER BY
       PCE.COMPANY_ID DESC,
       PCE.PRODUCT_CATID DESC
</cfquery>
<cfif getDiscount.RecordCount AND Len(getDiscount.DISCOUNT_RATE)>
   <cfset DISCOUNT_RATE = getDiscount.DISCOUNT_RATE>
</cfif>
<cfquery name="getShelf" datasource="#datam.dataSources.dsn3#">
   SELECT SHELF_CODE FROM workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR
   LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
   WHERE STOCK_ID =#main_stock_id#
</cfquery>