<cfcomponent>
   <cfset dsn=application.systemparam.dsn>
   <cffunction name="savePumpa" access="remote" returntype="string" returnformat="JSON" httpMethod="POST">    
      <cfdump var="#arguments#" >
      <CFSET datam=deserializeJSON(arguments.FORM_DATA)>
      <cfdump var="#datam#">
      <cfoutput>
         #catParser(datam.HIERARCHY)#
      </cfoutput>
      
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
                LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID     
                INNER JOIN STOCKS AS SS ON SS.PRODUCT_ID=S.PRODUCT_ID       
                LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID              
                WHERE S.PRODUCT_CATID=#arguments.PRODUCT_CATID# AND PRODUCT_DETAIL2='MASTER'
            </cfquery>
      <cfquery name="get_purchase_price_info" datasource="#datam.dataSources.dsn1#">
         SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
     </cfquery>
     <cfquery name="get_sales_price_info" datasource="#datam.dataSources.dsn1#">
         SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
     </cfquery>
     <cfset barcode=getBarcode()>
     <cfset UrunAdi=arguments.hydProductName>
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
     <cfif isDefined("arguments.dsn")>
     <cfelse>
         <cfset arguments.dsn=dsn>
     </cfif>
     <cfset DSN=datam.dataSources.dsn>
     <cfset DSN3=datam.dataSources.dsn3>
     <cfset DSN1=datam.dataSources.dsn1>
     <cfset database_type="MSSQL">
     <cfinclude template="/AddOns/Partner/satis/Includes/add_import_product.cfm">



         </cfif>



      </cfif>


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
</cfcomponent>