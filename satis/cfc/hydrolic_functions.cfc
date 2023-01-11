<cfcomponent>
    <cfscript>
        if(isdefined("session.pda") and isDefined("session.pda.userid"))
        {
            session_base.money = session.pda.money;
            session_base.money2 = session.pda.money2;
            session_base.userid = session.pda.userid;
            session_base.company_id = session.pda.our_company_id;
            session_base.our_company_id = session.pda.our_company_id;
            session_base.period_id = session.pda.period_id;
        }
        else if(isdefined("session.ep") and isDefined("session.ep.userid"))
        {
            session_base.money = session.ep.money;
            session_base.money2 = session.ep.money2;
            session_base.userid = session.ep.userid;
            session_base.company_id = session.ep.company_id;
            session_base.period_id = session.ep.period_id;
        }
    </cfscript>

    <cffunction name="saveVirtualHydrolic" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="1">        
            <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
                INSERT INTO VIRTUAL_PRODUCTS_PRT(PRODUCT_NAME,PRODUCT_CATID,PRICE,IS_CONVERT_REAL,MARJ,PRODUCT_TYPE,IS_PRODUCTION) VALUES('#arguments.hydProductName#',0,#Filternum(arguments.hydSubTotal)#,0,#Filternum(arguments.marjHyd)#,2,#arguments.IsProduction#)
            </cfquery>
            <cfloop from="1" to="#arguments.hydRwc#" index="i">
                <cfquery name="InsertTree" datasource="#arguments.dsn3#">
                    INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID,PRICE,DISCOUNT,MONEY) 
                    VALUES(
                    #Res.IDENTITYCOL#,
                    #evaluate("arguments.product_id_#i#")#,
                    #evaluate("arguments.stock_id_#i#")#,
                    #Filternum(evaluate("arguments.quantity_#i#"))#,
                    0,
                    #Filternum(evaluate("arguments.price_#i#"))#,
                    #Filternum(evaluate("arguments.discount_#i#"))#,
                    '#evaluate("arguments.money_#i#")#'
                    )
                </cfquery>
            </cfloop>                
            <cfsavecontent  variable="control5">
                <cfdump  var="#CGI#">        
                <cfdump  var="#arguments#">
                
               </cfsavecontent>
               <cffile action="write" file = "c:\PBS\hizlisatiscfc_saveVirtualHydrolic.html" output="#control5#"></cffile>
               <CFSET RETURN_VAL.PID=Res.IDENTITYCOL>
               <CFSET RETURN_VAL.IS_VIRTUAL=1>
               <CFSET RETURN_VAL.PRICE=Filternum(arguments.hydSubTotal)>
               <CFSET RETURN_VAL.QTY=1>
               <CFSET RETURN_VAL.NAME=arguments.hydProductName>
               <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>
        
            
        </cffunction>
        <cffunction name="updateVirtualHydrolic" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="1">        
        <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
            UPDATE VIRTUAL_PRODUCTS_PRT 
            SET 
                PRODUCT_NAME='#arguments.hydProductName#',
                PRICE=#Filternum(arguments.hydSubTotal)#,
                MARJ=#Filternum(arguments.marjHyd)#,
                PRODUCT_TYPE=2,
                IS_PRODUCTION=1 
            WHERE VIRTUAL_PRODUCT_ID=#arguments.VPID#
        </cfquery>   
        <cfquery name="delTree" datasource="#arguments.dsn3#">
            DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.VPID#
        </cfquery>
        
        <cfloop from="1" to="#arguments.hydRwc#" index="i">
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
                INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID,PRICE,DISCOUNT,MONEY) 
                VALUES(
                #arguments.VPID#,
                #evaluate("arguments.product_id_#i#")#,
                #evaluate("arguments.stock_id_#i#")#,
                #Filternum(evaluate("arguments.quantity_#i#"))#,
                0,
                #Filternum(evaluate("arguments.price_#i#"))#,
                #Filternum(evaluate("arguments.discount_#i#"))#,
                '#evaluate("arguments.money_#i#")#'
                )
            </cfquery>
        </cfloop>
        <CFSET RETURN_VAL.PID=arguments.VPID>
        <CFSET RETURN_VAL.IS_VIRTUAL=1>
        <CFSET RETURN_VAL.PRICE=arguments.hydSubTotal>
        <CFSET RETURN_VAL.QTY=1>
        <CFSET RETURN_VAL.ROW_ID=arguments.ROWID>
        <CFSET RETURN_VAL.NAME=arguments.hydProductName>
        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">        
            <cfdump  var="#arguments#">
            
           </cfsavecontent>
           <cffile action="write" file = "c:\PBS\hizlisatiscfc_UpdateVirtualHydrolick.html" output="#control5#"></cffile>
        <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>   
        </cffunction>
        
<cffunction name="SaveRealHydrolic" access="remote" returntype="any" returnFormat="json">
    <cfset arguments.PRODUCT_CATID=4083>
    <cfquery name="getMaster" datasource="#arguments.dsn1#">
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
    <cfquery name="getMasterShelf" datasource="#arguments.dsn3#">
        SELECT SHELF_CODE,PRODUCT_PLACE.PRODUCT_PLACE_ID FROM PRODUCT_PLACE_ROWS 
        LEFT JOIN PRODUCT_PLACE ON PRODUCT_PLACE.PRODUCT_PLACE_ID=PRODUCT_PLACE_ROWS.PRODUCT_PLACE_ID
        WHERE STOCK_ID=#getMaster.STOCK_ID#
    </cfquery>
      <cfquery name="get_purchase_price_info" datasource="#dsn1#">
        SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
    </cfquery>
    <cfquery name="get_sales_price_info" datasource="#dsn1#">
        SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
    </cfquery>
    <cfset barcode=getBarcode()>
    <cfset UrunAdi=arguments.hydProductName>
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
            alis_fiyat_kdvsiz = get_purchase_price_info.PRICE;
            satis_fiyat_kdvli = filternum(arguments.maliyet)+((filternum(arguments.maliyet)*18)/100);
            alis_fiyat_kdvli = get_purchase_price_info.PRICE_KDV;
            sales_money = get_sales_price_info.MONEY;
            cesit_adi='';
            purchase_money = get_purchase_price_info.MONEY;
        </cfscript>
    </CFOUTPUT>
    <cfset attributes.HIERARCHY =getMaster.HIERARCHY>
    <cfset DSN=arguments.dsn>
    <cfset DSN3=arguments.dsn3>
    <cfset DSN1=arguments.dsn1>
    <cfset database_type="MSSQL">
    <cfinclude template="/AddOns/Partner/satis/Includes/add_import_product.cfm">
    <cfset sidArr=arrayNew(1)>
    <cfloop from="1" to="#arguments.hydRwc#" index="i">
        <cfscript>
            o={
                PID=evaluate("arguments.product_id_#i#"),
                SID=evaluate("arguments.stock_id_#i#"),
                QTY=evalueate("arguments.quantity_#i#"),
                QUE=""
            };
            arrayAppend(sidArr,o);
        </cfscript>
    </cfloop>
    <cfscript>
        main_stock_id = GET_MAX_STCK.MAX_STCK;
        main_product_id =GET_PID.PRODUCT_ID;
        spec_name="#urun_adi#";                          
    </cfscript>  
    <cfset product_tree_id_list = ''>
    <cfset spec_main_id_list =''>
    <cfloop array="#sidArr#" item="pr">
        <cfquery name="getStock_Info" datasource="#arguments.dsn3#" >
            SELECT TOP 1 PRODUCT_ID,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID=#pr.SID#
        </cfquery>
        <cfset attributes.main_stock_id=main_stock_id>
        <cfset attributes.PRODUCT_ID=getStock_Info.PRODUCT_ID>
        <cfset attributes.add_stock_id=pr.SID>
        <cfset attributes.AMOUNT = filterNum(pr.QTY)>
        <cfset attributes.UNIT_ID = getStock_Info.PRODUCT_UNIT_ID>
        <cfset attributes.alternative_questions = pr.QUE>
        <cfinclude template="/AddOns/Partner/satis/Includes/PARTNERTREEPORT.cfm">
        <cfset SPEC_MAIN_ID_LIST= listAppend(SPEC_MAIN_ID_LIST, getStock_Info.STOCK_ID)> 
    </cfloop>
    <cfquery name="insertOpp" datasource="#dsn3#">
        INSERT INTO PRODUCT_TREE (
            IS_TREE
            ,AMOUNT
            ,OPERATION_TYPE_ID
            ,STOCK_ID
            ,IS_CONFIGURE
            ,IS_SEVK
            ,SPECT_MAIN_ID
            ,IS_PHANTOM
            ,QUESTION_ID
            ,PROCESS_STAGE
            ,RECORD_EMP
            ,RECORD_DATE
            ,IS_FREE_AMOUNT
            ,FIRE_AMOUNT
            ,FIRE_RATE
            ,DETAIL
        )
            SELECT  NULL
            ,AMOUNT
            ,OPERATION_TYPE_ID
            ,#attributes.main_stock_id#
            ,IS_CONFIGURE
            ,IS_SEVK
            ,SPECT_MAIN_ID
            ,IS_PHANTOM
            ,QUESTION_ID
            ,61
            ,#session.ep.userid#
            ,#now() #
            ,NULL
            ,FIRE_AMOUNT
            ,FIRE_RATE
            ,DETAIL
            FROM PRODUCT_TREE AS PRODUCT_TREE1
            WHERE STOCK_ID = #getMaster.STOCK_ID#                    
    </cfquery>	
    
    <cfset attributes.stock_id=main_stock_id>
    <cfset attributes.main_stock_id=main_stock_id>
    <cfset attributes.old_main_spec_id =0>
    <cfset attributes.process_stage=299>
    <cfif isDefined("arguments.dsn2")>
    <cfelse>
        <cfset arguments.dsn2="#arguments.dsn#_2021_1">
    </cfif>
    <cfset dsn2_alias=arguments.dsn2>
    <cfset dsn3_alias=arguments.dsn3>
    <cfset dsn1_alias=arguments.dsn1>
    <cfset dsn_alias=arguments.dsn>
    <cfset X_IS_PHANTOM_TREE =0>
    <cfset pp_lte=0>
    <cfif  pp_lte eq 0>
        <cfinclude template="/v16/production_plan/query/get_product_list.cfm">
        <cfset pp_lte=1>
    </cfif>
    <cfinclude template="/AddOns/Partner/satis/Includes/add_spect_main_ver.cfm">
    <cfif len(spec_main_id_list)>
        <cfset spec_main_id_list=ListToArray(spec_main_id_list)>
    <cfset spec_main_id_list=ArrayToList(spec_main_id_list)>
        <cfquery name="get_spec_main" datasource="#dsn3#">
            UPDATE 
                SPECT_MAIN_ROW
            SET
                RELATED_MAIN_SPECT_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =SPECT_MAIN_ROW.STOCK_ID AND SM.IS_TREE = 1  ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
            WHERE
                SPECT_MAIN_ID IN (#spec_main_id_list#)
        </cfquery>
    </cfif>
    <cfquery name="InsertShelfStock" datasource="#dsn3#">
        INSERT INTO PRODUCT_PLACE_ROWS (PRODUCT_ID,STOCK_ID,PRODUCT_PLACE_ID,AMOUNT) VALUES (#main_product_id#,#main_stock_id#,#getMasterShelf.PRODUCT_PLACE_ID#,1)
    </cfquery>
    
    <CFSET RETURN_VAL.PRODUCT_ID=GET_PID.PRODUCT_ID>
    <CFSET RETURN_VAL.STOCK_ID=main_stock_id>
    <CFSET RETURN_VAL.STOCK_CODE=attributes.PRODUCT_CODE>
    <CFSET RETURN_VAL.BRAND_NAME=''>
    <CFSET RETURN_VAL.IS_VIRTUAL=0>
    <CFSET RETURN_VAL.QUANTITY=1>
    <CFSET RETURN_VAL.PRICE=Filternum(arguments.maliyet)>
    <CFSET RETURN_VAL.PRODUCT_NAME=arguments.product_name>
    <CFSET RETURN_VAL.TAX=getMaster.TAX>
    <CFSET RETURN_VAL.DISCOUNT_RATE=0>
    <CFSET RETURN_VAL.PRODUCT_TYPE=2>
    <CFSET RETURN_VAL.SHELF_CODE='#getMasterShelf.SHELF_CODE#'>
    <CFSET RETURN_VAL.OTHER_MONEY=get_sales_price_info.MONEY>
    <CFSET RETURN_VAL.PRICE_OTHER=Filternum(arguments.maliyet)>
    <CFSET RETURN_VAL.OFFER_ROW_CURRENCY=-5>
    <CFSET RETURN_VAL.IS_MANUEL=0>
    <CFSET RETURN_VAL.COST=Filternum(arguments.maliyet)>
    <CFSET RETURN_VAL.MAIN_UNIT=birim>
    <CFSET RETURN_VAL.PRODUCT_NAME_OTHER=''>
    <CFSET RETURN_VAL.DETAIL_INFO_EXTRA=''>
    <CFSET RETURN_VAL.FC=0>
    <CFSET RETURN_VAL.ROW_NUM=''>
    <CFSET RETURN_VAL.DELIVERDATE=dateFormat(NOW(),"yyyy-mm-dd")>
    <CFSET RETURN_VAL.IS_PRODUCTION=1>
    <CFSET RETURN_VAL.ROW_UNIQ_ID=''>
    <cfif isDefined("arguments.row_id")>
    <CFSET RETURN_VAL.ROW_ID=arguments.row_id>
    <cfelse>
        <CFSET RETURN_VAL.ROW_ID="">
    </cfif>
    
    
    <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>

    <cfreturn Replace(SerializeJSON(arguments),'//','')>   
</cffunction>
</cfcomponent>