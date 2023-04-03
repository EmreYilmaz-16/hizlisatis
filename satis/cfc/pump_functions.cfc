﻿
<cfcomponent>
    <cfset dsn=application.systemparam.dsn>
    <cfset dsn1="">
    <cfset dsn2="">
    <cfset dsn3="">
    <!---
        TODO: 
        ---->
    <cffunction name="savePumpa" access="remote" returntype="string" returnformat="JSON" httpMethod="POST">          
       <CFSET datam=deserializeJSON(arguments.FORM_DATA)>            
       <cfquery name="getShelf" datasource="#datam.dataSources.dsn3#">
          SELECT PRODUCT_PLACE_ID,SHELF_CODE  FROM workcube_metosan_1.PRODUCT_PLACE WHERE SHELF_CODE=ltrim('#catParser(datam.HIERARCHY)#')
       </cfquery>
       <cfquery name="ins" datasource="#datam.datasources.dsn3#" result="RESSSS">
          INSERT INTO VirmanProduct (
             JSON_DATA
             ,CREATED_PID
             ,CREATED_SID
             )
          VALUES (
             '#Replace(SerializeJSON(datam),' //','')#'
             ,#0#
             ,#0#
             )      
       </cfquery>
       <CFSET IS_MANUEL=0>
       <CFSET COST=datam.OlusacakUrun.PRICE>
       <CFSET VIRMAN_ID=RESSSS.IDENTITYCOL>
       <CFSET BRAND_NAME="">
       <CFSET DISCOUNT_RATE=0>
       <cfset RETURN_VAL=structNew()>   
      <cfif datam.IsRotate eq 1>
         <cfinclude template="../includes/YonDegistirme.cfm">
      <cfelse>
         <cfif datam.OlusacakUrun.IS_VIRTUAL eq 1>
            <cfinclude template="../includes/sanal_pompa_kayit.cfm">
         <cfelse>
            <cfinclude template="../includes/gercek_pompa_kayit.cfm">
         </cfif>

      </cfif>


       
       <cfdump var="#RESSSS#">
           
       <cfif datam.IsRotate neq 1>
          <cfif datam.OlusacakUrun.IS_VIRTUAL eq 1>
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
                <!----INSERT INTO VirmanProduct (
                   JSON_DATA
                   ,CREATED_PID
                   ,CREATED_SID
                   )
                VALUES (
                   '#Replace(SerializeJSON(datam),' //','')#'
                   ,#main_product_id#
                   ,#main_stock_id#
                   )----->
             </cfquery>
          <cfelse>
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
             </cfquery
          </cfif>
 
       </cfif>
 
    <CFSET RETURN_VAL.PRODUCT_ID=main_product_id>
    <CFSET RETURN_VAL.STOCK_ID=main_stock_id>
    <CFSET RETURN_VAL.STOCK_CODE=attributes.PRODUCT_CODE>
    <CFSET RETURN_VAL.BRAND_NAME='#BRAND_NAME#'>
    <CFSET RETURN_VAL.IS_VIRTUAL=0>
    <CFSET RETURN_VAL.QUANTITY=1>
    <CFSET RETURN_VAL.PRICE=datam.OlusacakUrun.PRICE>
    <CFSET RETURN_VAL.PRODUCT_NAME=urun_adi>
    <CFSET RETURN_VAL.TAX=getMaster.TAX>
    <CFSET RETURN_VAL.DISCOUNT_RATE=DISCOUNT_RATE>
    <CFSET RETURN_VAL.PRODUCT_TYPE=3>
    <CFSET RETURN_VAL.SHELF_CODE='#getShelf.SHELF_CODE#'>
    <CFSET RETURN_VAL.OTHER_MONEY=get_sales_price_info.MONEY>
    <CFSET RETURN_VAL.PRICE_OTHER=datam.OlusacakUrun.PRICE>
    <CFSET RETURN_VAL.OFFER_ROW_CURRENCY=-5>
    <CFSET RETURN_VAL.IS_MANUEL=IS_MANUEL>
    <CFSET RETURN_VAL.COST=COST>
    <CFSET RETURN_VAL.MAIN_UNIT=birim>
    <CFSET RETURN_VAL.PRODUCT_NAME_OTHER=''>
    <CFSET RETURN_VAL.DETAIL_INFO_EXTRA=''>
    <CFSET RETURN_VAL.FC=0>
    <CFSET RETURN_VAL.ROW_NUM=''>
    <CFSET RETURN_VAL.DELIVERDATE=dateFormat(NOW(),"yyyy-mm-dd")>
    <CFSET RETURN_VAL.IS_PRODUCTION=1>
    <CFSET RETURN_VAL.ROW_UNIQ_ID=''>
    <cfset RETURN_VAL.VIRMAN_ID=VIRMAN_ID>
    <cfif isDefined("arguments.row_id")>
    <CFSET RETURN_VAL.ROW_ID=arguments.row_id>
    <cfelse>
    <CFSET RETURN_VAL.ROW_ID="">
    </cfif>
 
 
    <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>
 
 
 
    </cffunction>
 
 
    <cffunction  name="catParser">
    <cfargument  name="product_code">         
    <cfset Nlist=arguments.product_code>
    <cfset a=listLen(Nlist,".")>
    <cfset rest=Nlist>
    <cfset arr=arrayNew(1)>
    <cfloop from="1" to="#a#" index="ix">    
    <cfquery name="getCatimg" datasource="#dsn#_product">
    SELECT * FROM workcube_metosan_1.PRODUCT_CAT_SHELF_CODES WHERE PRODUCT_CATID =(SELECT PRODUCT_CATID FROM PRODUCT_CAT WHERE HIERARCHY='#rest#')
    </cfquery>
    <cfif getCatimg.recordcount>
 
    <cfreturn getCatimg.SHELF_CODE>
    </cfif>    
    <cfset rest=listDeleteAt(rest, a,'.')>
    <cfset a=a-1>
    </cfloop>  
    <cfreturn "Merhaba">
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
 </cfcomponent>