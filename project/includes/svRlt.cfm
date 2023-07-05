<cfquery name="getMainStockInfo" datasource="#dsn3#">
    SELECT * FROM STOCKS WHERE PRODUCT_ID =#FormData.PRODUCT_ID#
</cfquery>
<!---- Ürün Ağacı Temizlenecek----->
<cfquery name="del" datasource="#dsn3#">
    DELETE FROM PRODUCT_TREE WHERE STOCK_ID=#getMainStockInfo.STOCK_ID#

</cfquery>

<CFSET PROJECT_ID=FormData.PROJECT_ID>


<cfloop array="#FormData.PRODUCT_TREE#" item="item">
    <cfset prc=0>

    <cfif isDefined("item.PRICE")>
        <cfset prc=item.PRICE>
    </cfif>
    <cfset qid="">
    <cfif isDefined("item.QUESTION_ID")>
        <cfset qid=item.QUESTION_ID >
    </cfif>
<cfif item.IS_VIRTUAL eq 1>
    Ürünü Oluştur Ve Urün Ağacına AgacaEkle
    SANAL URUN OLUSTUR    

    <cfset K_URUN=SAVE_URUN(item.PRODUCT_CATID,item.PRODUCT_NAME,prc,prc,18,PROJECT_ID)>          
        bu arada oluşan ürünün ağacı kontrol edilecek        
        <cfloop array="#item.AGAC#" item="item2">
            <cfset qid2="">
            <cfif isDefined("item2.QUESTION_ID")>
                <cfset qid2=item2.QUESTION_ID >
            </cfif>
            <cfset prc2=0>
            <cfif isDefined("item2.PRICE")>
                <cfset prc2=item2.PRICE>
            </cfif>
            <cfif item2.IS_VIRTUAL eq 1>
                <cfset K_URUN2=SAVE_URUN(item2.PRODUCT_CATID,item2.PRODUCT_NAME,prc2,prc2,18,PROJECT_ID)>  
                burada agacında dolas 
                <CFSET "A.SPEC_MAIN_ID_LIST_#K_URUN2.STOCK_ID#"="">
                <cfloop array="#item2.AGAC#" item="item3">
                    <cfset prc3=0>
                    <cfif isDefined("item3.PRICE")>
                        <cfset prc3=item3.PRICE>
                    </cfif>
                    <cfset qid3="">
                    <cfif isDefined("item3.QUESTION_ID")>
                        <cfset qid3=item3.QUESTION_ID >
                    </cfif>
                    <cfif item3.IS_VIRTUAL eq 1>
                        <cfset K_URUN3=SAVE_URUN(item3.PRODUCT_CATID,item3.PRODUCT_NAME,prc3,prc3,18,PROJECT_ID)>  
                        <cfset e=AgacaEkle(K_URUN2.STOCK_ID,K_URUN2.PRODUCT_ID,K_URUN3.STOCK_ID,K_URUN3.PRODUCT_ID,item3.AMOUNT,"",qid3)>
                        <cfset MAIN_SID_3=K_URUN3.STOCK_ID>
                    <cfelse>
                        burda direk ağaca ekle
                        <CFSET EL=getStockInfo(item3.PRODUCT_ID)>
                    <cfset e=AgacaEkle(K_URUN2.STOCK_ID,K_URUN2.PRODUCT_ID,EL.STOCK_ID,EL.PRODUCT_ID,item3.AMOUNT,"",qid3)>
                    <cfset MAIN_SID_3=EL.STOCK_ID>
                    </cfif>
                    <CFSET "A.SPEC_MAIN_ID_LIST_#K_URUN2.STOCK_ID#"="#evaluate("A.SPEC_MAIN_ID_LIST_#K_URUN2.STOCK_ID#")#,#MAIN_SID_3#">
                </cfloop>

                <cfset e=AgacaEkle(K_URUN.STOCK_ID,K_URUN.PRODUCT_ID,K_URUN2.STOCK_ID,K_URUN2.PRODUCT_ID,item2.AMOUNT,"",qid2)>
            
            <cfelse>
    
                <CFSET EL=getStockInfo(item2.PRODUCT_ID)>
                <cfset e=AgacaEkle(K_URUN.STOCK_ID,K_URUN.PRODUCT_ID,EL.STOCK_ID,EL.PRODUCT_ID,item2.AMOUNT,"",qid2)>
            </cfif>
        </cfloop>
        spect kaydet
    <cfset e=AgacaEkle(getMainStockInfo.STOCK_ID,getMainStockInfo.PRODUCT_ID,K_URUN.STOCK_ID,K_URUN.PRODUCT_ID,item.AMOUNT,"",qid)>
    
<cfelse>
    ürünü direk Ağaca ekle
    <CFSET EL=getStockInfo(item.PRODUCT_ID)>
    <cfset e=AgacaEkle(getMainStockInfo.STOCK_ID,getMainStockInfo.PRODUCT_ID,EL.STOCK_ID,EL.PRODUCT_ID,item.AMOUNT,"",qid)>
</cfif>
burada speckt kaydet

</cfloop>


<cffunction name="getStockInfo">
    <cfargument name="PRODUCT_ID">
    <cfquery name="GetS" datasource="#dsn3#">
        SELECT * FROM STOCKS WHERE PRODUCT_ID =#arguments.PRODUCT_ID#
    </cfquery>
    <CFSET ReturnData.PRODUCT_ID=GetS.PRODUCT_ID>
    <CFSET ReturnData.STOCK_ID=GetS.STOCK_ID>
    <CFSET ReturnData.PRODUCT_CATID=GetS.PRODUCT_CATID>
<cfreturn ReturnData>
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

<cffunction name="AgacaEkle" >
    <cfargument name="MainStockId">
    <cfargument name="MainProductId">
    <cfargument name="StockId">
    <cfargument name="ProductId">
    <cfargument name="Amount">
    <cfargument name="UnitId">
    <cfargument name="QuestionId">
 
     
 
     
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