<cfset arguments.PRODUCT_CATID=4083>
<cfquery name="getMaster" datasource="#datam.dataSources.dsn1#">
SELECT S.PRODUCT_ID
	,S.PRODUCT_CODE
	,S.PRODUCT_CODE_2
	,S.PRODUCT_NAME
	,S.PRODUCT_CATID
	,S.PROD_COMPETITIVE
	,S.MANUFACT_CODE
	,S.MIN_MARGIN
	,S.IS_QUALITY
	,S.MAX_MARGIN
	,S.SHELF_LIFE
	,S.SEGMENT_ID
	,S.BSMV
	,S.OIV
	,S.TAX_PURCHASE
	,S.IS_INVENTORY
	,S.PRODUCT_ID
	,S.IS_PRODUCTION
	,S.IS_SALES
	,S.IS_ZERO_STOCK
	,S.BRAND_ID
	,S.IS_LIMITED_STOCK
	,S.IS_PURCHASE
	,S.IS_INTERNET
	,S.IS_EXTRANET
	,S.TAX
	,S.PRODUCT_STAGE
	,PU.IS_MAIN
	,PU.MAIN_UNIT
	,PU.MAIN_UNIT_ID
	,SS.STOCK_ID
	,PC.HIERARCHY
FROM PRODUCT AS S
LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
INNER JOIN STOCKS AS SS ON SS.PRODUCT_ID = S.PRODUCT_ID
LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID
WHERE S.PRODUCT_CATID = #arguments.PRODUCT_CATID#
	AND PRODUCT_DETAIL2 = 'MASTER'               
</cfquery>
<cfquery name="get_purchase_price_info" datasource="#datam.dataSources.dsn1#">
SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
</cfquery>
<cfquery name="get_sales_price_info" datasource="#datam.dataSources.dsn1#">
SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
</cfquery>
<cfset UrunAdi=datam.OlusacakUrun.PRODUCT_NAME>
<cfquery name="getCat" datasource="#datam.dataSources.dsn#">
    select * from workcube_metosan_1.PRODUCT_CAT WHERE HIERARCHY='#datam.HIERARCHY#'
</cfquery>
             <CFOUTPUT query="getMaster">
                <cfscript>
                   kategori_id=getCat.PRODUCT_CATID;   
                   urun_adi=UrunAdi; 
                   detail=''; 
                   detail_2='';
                   satis_kdv=TAX;
                   ALIS_KDV=TAX_PURCHASE;
                   is_inventory=IS_INVENTORY;
                   is_production=IS_PRODUCTION;
                   is_sales=IS_SALES;
                   is_purchase=IS_PURCHASE;
                   is_internet=IS_INTERNET;
                   is_extranet=IS_EXTRANET;
                   birim = MAIN_UNIT;
                   dimention = "";
                   volume = "";
                   weight = "";
                   surec_id=PRODUCT_STAGE;
                   fiyat_yetkisi = PROD_COMPETITIVE;
                   uretici_urun_kodu="";
                   brand_id=BRAND_ID;
                   short_code = '';
                   short_code_id = '';
                   product_code_2='';
                   is_limited_stock=IS_LIMITED_STOCK;
                   min_margin=MIN_MARGIN;
                   max_margin=MAX_MARGIN;
                   shelf_life=SHELF_LIFE;
                   segment_id=SEGMENT_ID;
                   bsmv=BSMV;
                   oiv=OIV;
                   IS_ZERO_STOCK=IS_ZERO_STOCK;
                   IS_QUALITY=IS_QUALITY;
                   alis_fiyat_kdvsiz = datam.OlusacakUrun.PRICE;
                   satis_fiyat_kdvli = datam.OlusacakUrun.PRICE+((datam.OlusacakUrun.PRICE*18)/100);
                   alis_fiyat_kdvli = get_purchase_price_info.PRICE_KDV;
                   sales_money = get_sales_price_info.MONEY;
                   cesit_adi='';
                   purchase_money = get_purchase_price_info.MONEY;
                </cfscript>
             </CFOUTPUT>
             <cfset attributes.HIERARCHY =datam.HIERARCHY>
             <cfif isDefined("arguments.dsn")><cfelse><cfset arguments.dsn=dsn></cfif>                  
             <cfset DSN=datam.dataSources.dsn>
             <cfset DSN3=datam.dataSources.dsn3>
             <cfset DSN1=datam.dataSources.dsn1>
             <cfset database_type="MSSQL">
             <cfset barcode=getBarcode()>
             <cfinclude template="/AddOns/Partner/satis/Includes/add_import_product.cfm">
             <cfscript>
                main_stock_id = GET_MAX_STCK.MAX_STCK;
                main_product_id =GET_PID.PRODUCT_ID;
             </cfscript>
             <cfquery name="InsertShelfStock" datasource="#dsn3#">
                INSERT INTO PRODUCT_PLACE_ROWS (PRODUCT_ID,STOCK_ID,PRODUCT_PLACE_ID,AMOUNT) VALUES (#main_product_id#,#main_stock_id#,#getShelf.PRODUCT_PLACE_ID#,1)
             </cfquery>
             <cfquery name="ins" datasource="#dsn3#">
                 UPDATE VirmanProduct SET CREATED_PID=#main_product_id#,CREATED_SID=#main_stock_id# WHERE VIRMAN_ID=#VIRMAN_ID#               
             </cfquery>

<CFSET RETURN_PRODUCT_ID=main_product_id>
<CFSET RETURN_STOCK_ID=main_stock_id>
<CFSET RETURN_PRODUCT_CODE=attributes.PRODUCT_CODE>
<CFSET RETURN_BRAND_NAME="METOSAN">
<CFSET RETURN_PRODUCT_NAME=datam.OlusacakUrun.PRODUCT_NAME>
<CFSET RETURN_TAX=getMaster.TAX>
<CFSET RETURN_UNIT=getMaster.MAIN_UNIT>
<CFSET RETURN_SHELF=getShelf.SHELF_CODE>