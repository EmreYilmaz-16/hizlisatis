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

<cfset attributes.price_catid=FormData.PRICE_CATID>
<cfset attributes.comp_id=FormData.COMPANY_ID>
<CFSET product_info=getProduct(OlusanUrun.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
<script>
    window.opener.RemSelected();
<cfoutput>window.opener.function AddRow(#product_info.PRODUCT_ID#,#product_info.STOCK_ID#,#product_info.PRODUCT_CODE#,'#product_info.BRAND_NAME#',0,1,#product_info.PRICE#,'#product_info.PRODUCT_NAME#',#product_info.TAX#,#product_info.DISCOUNT#,1,'',"TL",#product_info.PRICE#,-1,0,0,"Adet","","",0,"","",0,"","","",0,1,0)</cfoutput>
    
    this.close();
</script>

<cffunction name="getProduct">
    <cfargument name="keyword">
    <cfargument name="userid">
    <cfargument name="dsn2">
    <cfargument name="dsn1">
    <cfargument name="dsn3">
    <cfargument name="price_catid">
    <cfargument name="comp_id">
    <cfquery name="DelTempTable" datasource="#arguments.dsn1#">
        IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####TempProductList_#arguments.userid#')
        BEGIN
            DROP TABLE ####TempProductList_#arguments.userid#
        END    
    </cfquery>
    <cfset arguments.keyword = Replace(arguments.keyword,' ',';','all')><!--- % idi ; yaptik --->
    <cfquery name="get_products" datasource="#arguments.dsn1#">
        SELECT
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE,
            PRODUCT.PRODUCT_NAME,
            PRODUCT.PRODUCT_CODE_2,
            PRODUCT_CAT.PRODUCT_CAT,
            PRODUCT_CAT.PRODUCT_CATID,
            PRODUCT_CAT.HIERARCHY,
            PRODUCT.BARCOD,
            PRODUCT_CAT.DETAIL AS PC_DETAIL,
            PRODUCT.MANUFACT_CODE,
            ISNULL(GPA.PRICE,0) AS PRICE,
            PRICE_STANDART.MONEY,
            PRODUCT.TAX,
            (SELECT SUM(STOCK_IN-STOCK_OUT) FROM #arguments.dsn2#.STOCKS_ROW WHERE PRODUCT_ID = PRODUCT.PRODUCT_ID AND STORE <> 43) AS AMOUNT,
            PRODUCT_UNIT.ADD_UNIT,
            PRODUCT_UNIT.UNIT_ID,
            PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_UNIT.MULTIPLIER,
            PRODUCT_BRANDS.BRAND_NAME
        INTO
            ####TempProductList_#arguments.userid# 
        FROM
            PRODUCT
            LEFT JOIN STOCKS ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN PRODUCT_OUR_COMPANY ON PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN #arguments.dsn3#.PRODUCT_UNIT ON PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
            LEFT JOIN #arguments.dsn3#.PRODUCT_BRANDS ON PRODUCT_BRANDS.BRAND_ID	= PRODUCT.BRAND_ID
            LEFT JOIN #arguments.dsn3#.PRODUCT_CAT ON PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
            LEFT JOIN
            (
                SELECT
                    P.UNIT,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.PRODUCT_ID,
                    P.MONEY,
                    P.PRICE_CATID,
                    P.CATALOG_ID,
                    P.PRICE_DISCOUNT
                FROM
                    #arguments.dsn3#.PRICE P,
                    #arguments.dsn3#.PRODUCT PR
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID
                    AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
                    AND
                    (
                        P.STARTDATE <= #Now()#
                        AND
                        (
                            P.FINISHDATE >= #Now()# OR
                            P.FINISHDATE IS NULL
                        )
                    )
                    AND ISNULL(P.SPECT_VAR_ID, 0) = 0 
            ) AS GPA ON GPA.PRODUCT_ID = PRODUCT.PRODUCT_ID AND GPA.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID
        WHERE
            PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = 1
            AND PRODUCT.PRODUCT_STATUS = 1
            AND STOCKS.STOCK_STATUS = 1
            AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1
            AND PRODUCT.IS_SALES=1
            AND PRICE_STANDART.PRICESTANDART_STATUS = 1
            AND PRICE_STANDART.PURCHASESALES = 1
            AND PRODUCT.PRODUCT_ID=#arguments.keyword#
    
    </cfquery>
<cfquery name="get_products" datasource="#dsn3#">
    SELECT
        *
    FROM
        ####TempProductList_#session.ep.userid#        
</cfquery>
<cfif get_products.RecordCount>
    <cfoutput query="get_products">
        <cfset lastCost = 0>
        <cfquery name="getLastCost" datasource="#dsn2#">
            SELECT TOP 1
                IR.PRICE-(IR.DISCOUNTTOTAL/2) AS PRICE
            FROM
                INVOICE I
                LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
            WHERE
                ISNULL(I.PURCHASE_SALES,0) = 0 AND
                IR.PRODUCT_ID = #PRODUCT_ID#
                AND I.PROCESS_CAT<>35
            ORDER BY
                I.INVOICE_DATE DESC
        </cfquery>
        <cfif getLastCost.RecordCount AND Len(getLastCost.PRICE)>
            <cfset lastCost = getLastCost.PRICE>
        </cfif>
        <cfset discountRate = 0>
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
                    PCE.COMPANY_ID = #arguments.comp_id# OR
                    PCE.COMPANY_ID IS NULL
                ) AND
                P.PRODUCT_ID = #PRODUCT_ID# AND
                ISNULL(PC.IS_SALES,0) = 1 AND
                PCE.ACT_TYPE NOT IN (2,4) AND 
                PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
            ORDER BY
                PCE.COMPANY_ID DESC,
                PCE.PRODUCT_CATID DESC
        </cfquery>
        <cfif getDiscount.RecordCount AND Len(getDiscount.DISCOUNT_RATE)>
            <cfset discountRate = getDiscount.DISCOUNT_RATE>
        </cfif>
        <cfquery name="getParams" datasource="#dsn3#">
            SELECT MANUEL_CONTROL_AREA FROM VIRTUAL_OFFER_SETTINGS
        </cfquery>
        <cfset is_manuel = 0>
        <cfquery name="getManuel" datasource="#dsn3#">
            SELECT TOP 1
                #getParams.MANUEL_CONTROL_AREA#
            FROM
                PRODUCT_INFO_PLUS
            WHERE
                PRODUCT_INFO_PLUS.PRODUCT_ID = #PRODUCT_ID#
            ORDER BY
            #getParams.MANUEL_CONTROL_AREA# DESC
        </cfquery>
        <cfif getManuel.RecordCount AND evaluate("getManuel.#getParams.MANUEL_CONTROL_AREA#") eq 'MANUEL'>
            <cfset is_manuel = 1>
        </cfif> 
        <cfset REL_CATID="" >
        <cfset REL_CATNAME="" >
        <cfset REL_HIERARCHY="" >
        <cfif len(PC_DETAIL)>
            <cfquery name="getRelProductCat" datasource="#arguments.dsn1#">
                SELECT PRODUCT_CAT,PRODUCT_CATID,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#PC_DETAIL#
            </cfquery>
             <cfset REL_CATID="#getRelProductCat.PRODUCT_CATID#" >
             <cfset REL_CATNAME="#getRelProductCat.PRODUCT_CAT#" >
             <cfset REL_HIERARCHY="#getRelProductCat.HIERARCHY#" >
        </cfif>    
        <cfscript>
            Product={
                PRODUCT_ID=PRODUCT_ID,
                STOCK_ID=STOCK_ID,
                PRODUCT_CATID=PRODUCT_CATID,
                TAX=TAX,
                LAST_COST=lastCost,
                IS_MANUEL=is_manuel,
                PRODUCT_NAME=PRODUCT_NAME,
                STOCK_CODE=STOCK_CODE,
                BRAND_NAME=BRAND_NAME,
                DISCOUNT_RATE=discountRate,
                MAIN_UNIT=MAIN_UNIT,
                PRICE=PRICE,
                HIERARCHY=HIERARCHY,
                REL_CATID=REL_CATID,
                REL_CATNAME=REL_CATNAME,
                REL_HIERARCHY=REL_HIERARCHY,
                MONEY=MONEY


            };
        </cfscript>
        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">                
            <cfdump  var="#arguments#">
            <cfdump  var="#Product#">
            <cfdump var="#get_products#">
           </cfsavecontent>
           <cffile action="write" file = "c:\PBS\hizlisatiscfc_getproduct.html" output="#control5#"></cffile>
        <!----<a href="javascript://" onclick="addRow(#PRODUCT_ID#,#STOCK_ID#,'#TAX#','#lastCost#','#is_manuel#','#PRODUCT_NAME#','#STOCK_CODE#','#BRAND_NAME#','#discountRate#','','','','','#MAIN_UNIT#',
            '#TLFormat(PRICE,4)#','#MONEY#','#TLFormat(PRICE,4)#','','',0,0,0);">#PRODUCT_NAME#</a>----->
    </cfoutput>
<CFSET ReturnVal.RecordCount=1>
<CFSET ReturnVal.PRODUCT=Product>
<cfelse>
    <CFSET ReturnVal.RecordCount=0>
    
</cfif>
<cfreturn Product>
</cffunction>



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
