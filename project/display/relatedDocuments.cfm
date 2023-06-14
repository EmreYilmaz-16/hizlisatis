<cfinclude template="../includes/getTreeQuery.cfm">
<!--------- Sanallar Ayıklanıyor----->
<cfquery name="getvirtuals" dbtype="query">
    SELECT * FROM getVirtualTree WHERE IS_VIRTUAL=1
</cfquery>
<!--------- Ana Ürün Bilgileri----->
<cfquery name="productInfo" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=1190
</cfquery>
<cfscript>
    var AcilanUrunler=queryNew("VP_ID,STOCK_ID,SEVIYE","INTEGER,INTEGER,INTEGER");
</cfscript>
<!----- Ana Ürün Kayıt Ediliyor----->    
<CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,18)>	
<CFSET "A.PRODUCT_ID_1190"=K_URUN.PRODUCT_ID>
<CFSET "A.STOCK_ID_1190"=K_URUN.STOCK_ID>
<CFSET "A.SPECT_MAIN_LIST_1190"="">
<!----- Sanal Ürünler Kayıt Ediliyor----->    
<cfoutput query="getvirtuals">    
    <cfquery name="productInfo" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
    </cfquery>
    <CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,18)>	
    <CFSET "A.PRODUCT_ID_#PRODUCT_ID#"=K_URUN.PRODUCT_ID>
    <CFSET "A.STOCK_ID_#PRODUCT_ID#"=K_URUN.STOCK_ID>
    <CFSET "A.SPECT_MAIN_LIST_#PRODUCT_ID#"="">
    <cfscript>
        O={
            VP_ID=PRODUCT_ID,
            STOCK_ID=K_URUN.STOCK_ID}
        arrayAppend(SRaRR,O);
    </cfscript>
</cfoutput>
<cfloop query="getvirtuals">
    <cfquery name="getPList" dbtype="query">
        SELECT * FROM getVirtualTree WHERE VP_ID=#VP_ID#
    </cfquery> 
    <cfloop query="getPList">
        <cfoutput>
            #getPList.PRODUCT_ID#
        </cfoutput>
    </cfloop>
</cfloop>
<cfabort>



 
    
    <CFLOOP query="getVirtualTree">
        <CFIF isDefined("A.PRODUCT_ID_#VP_ID#")>
            <CFIF isDefined("A.PRODUCT_ID_#PRODUCT_ID#")>
                ÜRÜNÜ EKLE =<cfoutput>#evaluate("A.PRODUCT_ID_#PRODUCT_ID#")# => #evaluate("A.PRODUCT_ID_#VP_ID#")#</cfoutput> <BR>
                <cfquery name="insertTree" datasource="#dsn#">
                    INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#evaluate("A.PRODUCT_ID_#PRODUCT_ID#")# ,#evaluate("A.PRODUCT_ID_#VP_ID#")#)
                </cfquery>
                <cfscript>
                    AgacaEkle(evaluate("A.STOCK_ID_#VP_ID#"),evaluate("A.PRODUCT_ID_#VP_ID#"),evaluate("A.STOCK_ID_#PRODUCT_ID#"),evaluate("A.PRODUCT_ID_#PRODUCT_ID#"),AMOUNT,"",QUESTION_ID)
                </cfscript>
            <CFELSE>
                ÜRÜNÜ EKLE =<cfoutput>#PRODUCT_ID# => #evaluate("A.PRODUCT_ID_#VP_ID#")#</cfoutput> <BR>
                <cfquery name="insertTree" datasource="#dsn#">
                    INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#PRODUCT_ID# ,#evaluate("A.PRODUCT_ID_#VP_ID#")#)				
                </cfquery>
                <cfquery name="getStokInfo" datasource="#dsn3#">
                    SELECT * FROM workcube_metosan_1.STOCKS WHERE PRODUCT_ID=#PRODUCT_ID#
                </cfquery>
                <cfscript>
                    AgacaEkle(evaluate("A.STOCK_ID_#VP_ID#"),evaluate("A.PRODUCT_ID_#VP_ID#"),getStokInfo.STOCK_ID,PRODUCT_ID,AMOUNT,"",QUESTION_ID)
                </cfscript>
            </CFIF>
            <CFSET "A.SPECT_MAIN_LIST_#VP_ID#" ="#evaluate('A.SPECT_MAIN_LIST_#VP_ID#')#,#evaluate("A.STOCK_ID_#VP_ID#")#">
        </CFIF>
    </CFLOOP>
    <cfdump var="#A#">
    <cfquery name="SEL" datasource="#DSN#">
        SELECT * FROM geciciUrun
    </cfquery>
    <cfquery name="SEAL" datasource="#DSN#">
        SELECT * FROM geciciUrunAGACI
    </cfquery>
    <cfloop array="#SRaRR#" item="ii">
    <cfscript>
        AddSpects(ii.STOCK_ID,evaluate("A.SPECT_MAIN_LIST_#ii.VP_ID#"))
    </cfscript>
    </cfloop>
    <cfscript>
        function get_spect_row(spect_id)
        {										
            SQLStr = "
                    SELECT
                        AMOUNT,
                        ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID,
                        STOCK_ID
                    FROM 
                        SPECT_MAIN_ROW SM
                    WHERE
                        SPECT_MAIN_ID = #spect_id#
                        AND IS_PHANTOM = 1
                ";
            query1 = cfquery(SQLString : SQLStr, Datasource : new_dsn3);
            stock_id_ary='';
            for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
            {
                stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'█');
                stock_id_ary=listappend(stock_id_ary,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
                stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
            }
            return stock_id_ary;
        }
        function writeProductTree(spect_main_id,old_amount)
        {
            var i = 1;
            var sub_products = get_spect_row(spect_main_id);
            for (i=1; i lte listlen(sub_products,'█'); i = i+1)
            {
                _next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
                _next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
                _next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
                phantom_spec_main_id_list = listdeleteduplicates(listappend(phantom_spec_main_id_list,_next_spect_id_,','));
                phantom_stock_id_list = listdeleteduplicates(listappend(phantom_stock_id_list,_next_stock_id_,','));
                'multipler_#_next_spect_id_#' = _next_amount_;
                if(_next_spect_id_ gt 0)
                {
                    'multipler_#_next_spect_id_#' = _next_amount_*old_amount;
                    writeProductTree(_next_spect_id_,_next_amount_*old_amount);
                }
             }
        }
    </cfscript>
    
    <cfdump var="#SEL#">
    <cfdump var="#SEAL#">
    <cfabort>x"1
    <cfscript>
        getTree_1453(1190,1)
    </cfscript>
    <cffunction name="getTree_1453">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="MAIN_PRODUCT_ID" default="0">
        <cfargument name="MAIN_STOCK_ID" default="0">	
        <cfargument name="seviye" default="0">
        <cfargument name="AMOUNT">
        <cfargument name="QUESTION_ID">
    
        <cfoutput>
            Ürünü Kaydet : #arguments.PRODUCT_ID#<br>
            <cfquery name="ins" datasource="#dsn#" result="RES">
                INSERT INTO geciciUrun (PRODUCT_NAME) VALUES ('#arguments.PRODUCT_ID#')
            </cfquery>
            <cfset KAYDEDILEN_URUN=RES.IDENTITYCOL>
                AĞAC KAYDINDAN MI GELİYOR : #arguments.MAIN_PRODUCT_ID# 
                <CFIF arguments.MAIN_PRODUCT_ID NEQ 0>
                    Evet
                    #arguments.MAIN_PRODUCT_ID# URUNUN AGACINA #KAYDEDILEN_URUN#'ü Ekle
                <cfelse>
                    HAYIR
                </CFIF><br>
            Ağacına Bak : [
                <br><cfquery name="isHvTree" datasource="#dsn3#">
                    SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.PRODUCT_ID#
                </cfquery>
                <cfif isHvTree.recordCount>
                    Ağacı Var : #arguments.PRODUCT_ID# <br>
                        <cfloop query="isHvTree">
                            
                            Sanal mı :#isHvTree.PRODUCT_ID# <cfif isHvTree.IS_VIRTUAL eq 1>Evet
                                <cfscript>
                                    getTree_1453(isHvTree.PRODUCT_ID,1,KAYDEDILEN_URUN);
                                </cfscript>
    
                            <cfelse>
                            Sanal Değil--#KAYDEDILEN_URUN# Kaydedilen Ürüne #isHvTree.PRODUCT_ID# Ürününü Ekle -- MAIN_PRODUCT_ID:#MAIN_PRODUCT_ID#
    
                            </cfif><br>
                        </cfloop>
                    <cfelse>
                        Ağacı Yok : #arguments.PRODUCT_ID#
                </cfif>
            ]
        </cfoutput>
        
        
    </cffunction>
    <cffunction name="getTree">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="MAIN_PRODUCT_ID" default="0">
        <cfargument name="MAIN_STOCK_ID" default="0">	
        <cfargument name="seviye" default="0">
        <cfargument name="AMOUNT">
        <cfargument name="QUESTION_ID">
        <cfquery name="productInfo" datasource="#dsn3#">
            SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#arguments.PRODUCT_ID#
        </cfquery>
        
        <cfquery name="ins" datasource="#dsn#" result="RES">
            INSERT INTO geciciUrun (PRODUCT_NAME) VALUES ('#productInfo.PRODUCT_NAME#')
        </cfquery>
        <CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,18)>	
        <CFSET 	MAIN_PID=K_URUN.PRODUCT_ID>
        <CFSET 	MAIN_SID=K_URUN.STOCK_ID>
        <cfquery name="isHvTree" datasource="#dsn3#">
            SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.PRODUCT_ID#
        </cfquery>
        
        <cfif arguments.MAIN_PRODUCT_ID neq 0>
            Ürün Ağacına Ekle MAIN_PRODUCT_ID ----- <cfoutput>#isHvTree.PRODUCT_ID#,#arguments.MAIN_PRODUCT_ID#</cfoutput><br>
            <!----<cfquery name="insertTree" datasource="#dsn#">
                INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#MAIN_PID#,#arguments.MAIN_PRODUCT_ID#)
            </cfquery>----->
            <cfscript>
                AgacaEkle(arguments.MAIN_STOCK_ID,arguments.MAIN_PRODUCT_ID,MAIN_SID,MAIN_PID,ARGUMENTS.AMOUNT,"",ARGUMENTS.QUESTION_ID);
            </cfscript>
        </cfif>
        <cfif isHvTree.recordCount>
            <cfloop query="isHvTree">
                <cfoutput>
                    #isHvTree.PRODUCT_ID# ----- #isHvTree.IS_VIRTUAL#----#arguments.seviye#----#MAIN_PID#----#arguments.MAIN_PRODUCT_ID#<BR>
                </cfoutput>
                <CFIF isHvTree.IS_VIRTUAL eq 1>
                    <cfscript>getTree(isHvTree.PRODUCT_ID,1,MAIN_PID,MAIN_SID,0,isHvTree.amount,isHvTree.QUESTION_ID)</cfscript>
                <cfelse>
                    Ürün Ağacına Ekle ----- <cfoutput>#isHvTree.PRODUCT_ID#,#MAIN_PID#</cfoutput><br>
                    <!---<cfquery name="insertTree" datasource="#dsn#">
                        INSERT INTO geciciUrunAGACI(PRODUCT_ID,STOCK_ID) VALUES(#isHvTree.PRODUCT_ID#,#MAIN_PID#)
                    </cfquery>----->
                    
                    <cfif len(isHvTree.STOCK_ID)>
                    <cfscript>
                        AgacaEkle(MAIN_SID,MAIN_PID,isHvTree.STOCK_ID,isHvTree.PRODUCT_ID,isHvTree.amount,"",isHvTree.QUESTION_ID)
                    </cfscript>
                    <cfelse>
                        <cfquery name="gets" datasource="#dsn3#">
                            SELECT * FROM STOCKS WHERE PRODUCT_ID=#isHvTree.PRODUCT_ID#
                        </cfquery>
                <cfscript>
                    AgacaEkle(MAIN_SID,MAIN_PID,gets.STOCK_ID,isHvTree.PRODUCT_ID,isHvTree.amount,"",isHvTree.QUESTION_ID)
                </cfscript>	
                </cfif>
                    
                </CFIF>
    
            </cfloop>
    
        </cfif>
        
    </cffunction>
    
    <cffunction name="SAVE_URUN" >
        <cfargument name="PRODUCT_CATID">
        <cfargument name="PRODUCT_NAME">
        <cfargument name="PURCHASE_PRICE">
        <cfargument name="SALE_PRICE">
        <cfargument name="TAX">
        
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
                ,S.IS_ZERO_STOCK
                ,PB.BRAND_ID
                ,S.IS_LIMITED_STOCK
                ,S.IS_PURCHASE
                ,S.IS_INTERNET
                ,S.IS_EXTRANET                                        
                ,S.TAX
              --  ,S.PRODUCT_STAGE
                ,PU.IS_MAIN
                ,PU.MAIN_UNIT
                ,PU.MAIN_UNIT_ID
              --  ,SS.STOCK_ID
                ,PC.HIERARCHY
            FROM workcube_metosan_1.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS S 
            LEFT JOIN workcube_metosan_1.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID   
            LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=379
            LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON MAIN_UNIT_ID=S.UNIT_ID              
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
        <cfinclude template="/AddOns/Partner/satis/Includes/add_import_product.cfm">
        <cfscript>
            main_stock_id = GET_MAX_STCK.MAX_STCK;
            main_product_id =GET_PID.PRODUCT_ID;
            spec_name="#urun_adi#";                          
        </cfscript> 
        <cfset RETURN_VAL.STOCK_ID=GET_MAX_STCK.MAX_STCK>
        <cfset RETURN_VAL.PRODUCT_ID=GET_PID.PRODUCT_ID>
        <CFRETURN RETURN_VAL>
    </cffunction>
    
    <cfabort>
    
    <cffunction name="AgacaEkle" >
       <cfargument name="MainStockId">
       <cfargument name="MainProductId">
       <cfargument name="StockId">
       <cfargument name="ProductId">
       <cfargument name="Amount">
       <cfargument name="UnitId">
       <cfargument name="QuestionId">
    
        
        <cfscript>
            main_stock_id = GET_MAX_STCK.MAX_STCK;
            main_product_id =GET_PID.PRODUCT_ID;
            spec_name="#urun_adi#";                          
        </cfscript>  
        <cfset product_tree_id_list = ''>
        <cfset spec_main_id_list =''>
        
            <cfquery name="getStock_Info" datasource="#dsn3#" >
                SELECT TOP 1 PRODUCT_ID,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID=#arguments.StockId#
            </cfquery>
            
            <cfset attributes.main_stock_id=arguments.MainStockId>
            <cfset attributes.PRODUCT_ID=getStock_Info.PRODUCT_ID>
            <cfset attributes.add_stock_id=arguments.StockId>
            <cfset attributes.AMOUNT = arguments.Amount>
            <cfset attributes.UNIT_ID = getStock_Info.PRODUCT_UNIT_ID>
            <cfset attributes.alternative_questions = arguments.QuestionId>
            <cfinclude template="/AddOns/Partner/satis/Includes/PARTNERTREEPORT.cfm">        
            <cfreturn getStock_Info.STOCK_ID>
        
    
    
    </cffunction>
    <cffunction name="AddSpects">
    <cfargument name="STOCK_ID">
    <cfargument name="SPEC_MAIN_ID_LIST">
        
        
        <cfset attributes.stock_id=arguments.STOCK_ID>
        <cfset attributes.main_stock_id=arguments.STOCK_ID>
        <cfset attributes.old_main_spec_id =0>
        <cfset attributes.process_stage=299>
       <cfset spec_main_id_list=arguments.SPEC_MAIN_ID_LIST>
    
        <cfset dsn2_alias=dsn2>
        <cfset dsn3_alias=dsn3>
        <cfset dsn1_alias=dsn1>
        <cfset dsn_alias=dsn>
        <cfset X_IS_PHANTOM_TREE =0>
        <cfset pp_lte=0>
        <cfif  pp_lte eq 0>		
           
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
    
    <cfquery name="SEL" datasource="#DSN#">
        SELECT * FROM geciciUrun
    </cfquery>
    <cfquery name="SEAL" datasource="#DSN#">
        SELECT * FROM geciciUrunAGACI
    </cfquery>
    <cfdump var="#SEL#">
    <cfdump var="#SEAL#">
    <cfquery name="tr1" datasource="#dsn#">
        TRUNCATE TABLE workcube_metosan.geciciUrun
    
    </cfquery>
    <cfquery name="tr2" datasource="#dsn#">
        TRUNCATE TABLE  workcube_metosan.geciciUrunAGACI
    </cfquery>
    <cfabort>
    <cf_box title="İlişkili Belgeler">
    <cfquery name="getDocuments" datasource="#dsn3#">
        SELECT OFFER_ID AS ACTION_ID
        ,OFFER_NUMBER AS ACTION_NUMBER
        ,OFFER_HEAD ACTION_HEAD
        ,OFFER_DATE AS ACTION_DATE
        ,PRICE AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Teklifi'
            ELSE 'Alış Teklifi'
            END AS TIP
        ,'Teklif' AS MAIN_TIP
    FROM workcube_metosan_1.PBS_OFFER
    WHERE PROJECT_ID = 2906
    
    UNION
    
    SELECT ORDER_ID AS ACTION_ID
        ,ORDER_NUMBER AS ACTION_NUMBER
        ,ORDER_HEAD ACTION_HEAD
        ,ORDER_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Siparişi'
            ELSE 'Alış Siparişi'
            END AS TIP
        ,'Sipariş' AS MAIN_TIP
    FROM workcube_metosan_1.ORDERS
    WHERE PROJECT_ID = 2906
    
    UNION
    
    SELECT INVOICE_ID AS ACTION_ID
        ,INVOICE_NUMBER AS ACTION_NUMBER
        ,'Fatura' ACTION_HEAD
        ,INVOICE_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış Faturası'
            ELSE 'Alış Faturası'
            END AS TIP
        ,'Fatura' AS MAIN_TIP
    FROM workcube_metosan_2023_1.INVOICE
    WHERE PROJECT_ID = 2906
    
    UNION
    
    SELECT SHIP_ID AS ACTION_ID
        ,SHIP_NUMBER AS ACTION_NUMBER
        ,'İrsaliye' ACTION_HEAD
        ,SHIP_DATE AS ACTION_DATE
        ,NETTOTAL AS ACTION_VALUE
        ,CASE 
            WHEN PURCHASE_SALES = 1
                THEN 'Satış İrsaliyesi'
            ELSE 'Alış İrsaliyesi'
            END AS TIP
        ,'İrsaliye' AS MAIN_TIP
    FROM workcube_metosan_2023_1.SHIP
    WHERE PROJECT_ID = 2906
    
    UNION
    
    SELECT ACTION_ID
        ,PAPER_NO AS ACTION_NUMBER
        ,ACTION_TYPE AS ACTION_HEAD
        ,ACTION_DATE
        ,ACTION_VALUE 
        ,CASE 
            WHEN (
                    ACTION_FROM_COMPANY_ID IS NOT NULL
                    OR ACTION_FROM_EMPLOYEE_ID IS NOT NULL
                    )
                THEN 'Banka Giren'
            ELSE 'Banka Çıkan'
            END AS TIP
        ,'Banka' AS MAIN_TIP
    FROM workcube_metosan_2023_1.BANK_ACTIONS
    WHERE PROJECT_ID = 2906
    
    UNION
    
    SELECT ACTION_ID
        ,PAPER_NO AS ACTION_NUMBER
        ,ACTION_TYPE AS ACTION_HEAD
        ,ACTION_DATE
        ,ACTION_VALUE 
        ,CASE 
            WHEN (
                    CASH_ACTION_FROM_CASH_ID IS NOT NULL
                    OR CASH_ACTION_FROM_COMPANY_ID IS NOT NULL
                    )
                OR (
                    CASH_ACTION_FROM_CONSUMER_ID IS NOT NULL
                    OR CASH_ACTION_FROM_EMPLOYEE_ID IS NOT NULL
                    )
                THEN 'Kasa Giren'
            ELSE 'Kasa Çıkan'
            END AS TIP
        ,'Kasa' AS MAIN_TIP
    FROM workcube_metosan_2023_1.CASH_ACTIONS
    WHERE PROJECT_ID = 2906
    </cfquery>
    
    <div>    
        <cf_big_list>
    <cfoutput query="getDocuments">        
        <tr>
            <td>#MAIN_TIP#</td>
            <td>#TIP#</td>        
            <td>#ACTION_NUMBER#</td>
            <td>#ACTION_HEAD#</td>
            <td>#ACTION_DATE#</td>
            <td>#ACTION_VALUE#</td>    
        </tr>
    
    
    </cfoutput>
    </cf_big_list>
    </div>
    </cf_box>