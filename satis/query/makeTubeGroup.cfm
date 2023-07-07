<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">


<CFSET PRODUCT_CAT_ID=4079>
<cfset OlusanUrun=SAVE_URUN(PRODUCT_CAT_ID,FormData.PRODUCT_NAME_MAIN,0,FormData.PRICE_TOTAL,18,"")>
<cffunction name="SAVE_URUN" >
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PURCHASE_PRICE">
    <cfargument name="SALE_PRICE">
    <cfargument name="TAX">
    <cfargument name="project_id">
    
    <cfquery name="getMaster" datasource="#dsn3#">
        SELECT 
            S.PRODUCT_CATID
            ,NULL PROD_COMPETITIVE
            ,NULL MANUFACT_CODE
            ,NULL MIN_MARGIN 
            ,S.IS_QUALITY
            ,NULL MAX_MARGIN
            ,NULL SHELF_LIFE
            ,NULL SEGMENT_ID
            ,0 BSMV
            ,0 OIV                     
            ,S.TAX_PURCHASE
            ,S.IS_INVENTORY            
            ,S.IS_PRODUCTION 
            ,S.IS_SALES
            ,S.IS_KARMA
            ,S.IS_KARMA_SEVK
            ,S.IS_ZERO_STOCK
            ,PB.BRAND_ID
            ,S.IS_LIMITED_STOCK
            ,S.IS_PURCHASE
            ,S.IS_INTERNET
            ,S.IS_EXTRANET                                        
            ,S.TAX
            ,PU.IS_MAIN
            ,PU.MAIN_UNIT
            ,PU.MAIN_UNIT_ID
            ,PC.HIERARCHY
        FROM #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS S 
        LEFT JOIN #DSN3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID   
        LEFT JOIN #DSN3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=379
        LEFT JOIN #DSN3#.PRODUCT_UNIT AS PU ON MAIN_UNIT_ID=S.UNIT_ID              
        WHERE S.PRODUCT_CATID=#arguments.PRODUCT_CATID#

    </cfquery>

    <cfset barcode=getBarcode()>
    <cfset UrunAdi=arguments.PRODUCT_NAME>
    <CFOUTPUT query="getMaster">
        <cfscript>
            kategori_id=arguments.PRODUCT_CATID;   
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
            is_karma=IS_KARMA;
            is_karma_sevk=IS_KARMA_SEVK
            birim = MAIN_UNIT;
            dimention = "";
            volume = "";
            weight = "";
            surec_id=1;
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
            attributes.project_id=arguments.project_id;
            bsmv=BSMV;
            oiv=OIV;
            IS_ZERO_STOCK=IS_ZERO_STOCK;
            IS_QUALITY=IS_QUALITY;
            alis_fiyat_kdvsiz = arguments.SALE_PRICE;
            satis_fiyat_kdvli = arguments.SALE_PRICE+(((arguments.SALE_PRICE)*18)/100);
            alis_fiyat_kdvli = arguments.SALE_PRICE+(((arguments.SALE_PRICE)*18)/100);
            sales_money = "TL";
            cesit_adi='';
            purchase_money = "TL";
        </cfscript>
    </CFOUTPUT>
    <cfset attributes.HIERARCHY =getMaster.HIERARCHY>
    <cfif isDefined("arguments.dsn")>
    <cfelse>
        <cfset arguments.dsn=dsn>
    </cfif>
    <cfset database_type="MSSQL">
    <cfinclude template="../Includes/add_import_product.cfm">
    <cfscript>
        main_stock_id = GET_MAX_STCK.MAX_STCK;
        main_product_id =GET_PID.PRODUCT_ID;
        spec_name="#urun_adi#";                          
    </cfscript> 
    <cfset RETURN_VAL.STOCK_ID=GET_MAX_STCK.MAX_STCK>
    <cfset RETURN_VAL.PRODUCT_ID=GET_PID.PRODUCT_ID>
    <CFRETURN RETURN_VAL>
</cffunction>
