<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">





<CFSET PRODUCT_CAT_ID=4079>


<cfset OlusanUrun=SAVE_URUN(PRODUCT_CAT_ID,FormData.PRODUCT_NAME_MAIN,0,FormData.PRICE_TOTAL,20,"")>

<cfloop array="#FormData.PRODUCT_LIST#" item="it">
    <cfquery name="getUnitId" datasource="#dsn3#">
    select PRODUCT_UNIT_ID,MAIN_UNIT from workcube_metosan_1.PRODUCT_UNIT where PRODUCT_ID=#it.PRODUCT_ID# and IS_MAIN=1
        
    </cfquery>
    <cfquery name="getsm" datasource="#dsn3#">
        select SPECT_MAIN_ID from SPECT_MAIN where PRODUCT_ID=#it.PRODUCT_ID# and SPECT_STATUS=1
    </cfquery>
    <cfquery name="ins" datasource="#dsn1#">
        INSERT INTO KARMA_PRODUCTS (
        KARMA_PRODUCT_ID,PRODUCT_ID,MONEY,PURCHASE_PRICE,SALES_PRICE,TOTAL_PRODUCT_PRICE,TAX,TAX_PURCHASE,PRODUCT_UNIT_ID,UNIT,PRODUCT_AMOUNT,STOCK_ID,SPEC_MAIN_ID,LIST_PRICE,OTHER_LIST_PRICE)
        VALUES (#OlusanUrun.PRODUCT_ID#,#it.PRODUCT_ID#,'#it.OTHER_MONEY#',0,#it.PRICE#,#it.ROW_NET_TOTAL#,#it.TAX#,#it.TAX#,#getUnitId.PRODUCT_UNIT_ID#,'#getUnitId.MAIN_UNIT#',#it.AMOUNT#,#it.STOCK_ID#,<cfif getsm.recordCount>#getsm.SPECT_MAIN_ID#<cfelse>NULL</cfif>,0,0)

    </cfquery>
</cfloop>
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
            satis_fiyat_kdvli = arguments.SALE_PRICE+(((arguments.SALE_PRICE)*TAX)/100);
            alis_fiyat_kdvli = arguments.SALE_PRICE+(((arguments.SALE_PRICE)*TAX)/100);
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

<cffunction name="getBarcode">
      
    <cfif  1 eq 1>
        <cfquery name="get_barcode_no" datasource="#dsn1#">
            SELECT PRODUCT_NO AS BARCODE FROM PRODUCT_NO
        </cfquery>
        <cfset barcode_on_taki = '100000000000'>
        <cfset barcode = get_barcode_no.barcode>
        <cfset barcode_len = len(barcode)>
        <cfset barcode = left(barcode_on_taki,12-barcode_len)&barcode> 
    <cfelse>
        <cfquery name="get_barcode_no" datasource="#dsn1#">
            SELECT LEFT(BARCODE, 12) AS BARCODE FROM PRODUCT_NO
        </cfquery>
        <cfset barcode = (get_barcode_no.barcode*1)+1>
        <cfquery name="upd_barcode_no" datasource="#dsn1#">
            UPDATE PRODUCT_NO SET BARCODE = '#barcode#X'
        </cfquery>
    </cfif>

        <cfset barcode_tek = 0>
        <cfset barcode_cift =0>
        <cfif len(barcode) eq 12>
            <cfloop from="1" to="11" step="2" index="i">
                <cfset barcode_kontrol_1 = mid(barcode,i,1)>
                <cfset barcode_kontrol_2 = mid(barcode,i+1,1)>
                <cfset barcode_tek = (barcode_tek*1) + (barcode_kontrol_1*1)>
                <cfset barcode_cift = (barcode_cift*1) + (barcode_kontrol_2*1)>
            </cfloop>
            <cfset barcode_toplam = (barcode_cift*3)+(barcode_tek*1)>
            <cfset barcode_control_char = right(barcode_toplam,1)*1>
            <cfif barcode_control_char gt 0>
            <cfset barcode_control_char = 10-barcode_control_char>
        <cfelse>
            <cfset barcode_control_char = 0>
        </cfif>
        <cfset barcode_no = '#barcode##barcode_control_char#'>
    <cfelse>
        <cfset barcode_no = ''>
    </cfif>
    

</cffunction>
