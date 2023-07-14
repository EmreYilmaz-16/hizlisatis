<cfparam   name="attributes.VIRTUAL_PRODUCT_ID" default="">
<!---- Eğer Ürün Gelmezse Durdurdum------>
<cfif len(attributes.VIRTUAL_PRODUCT_ID)><cfelse><cfabort></cfif>
<cfinclude template="../includes/getTreeQuery.cfm">
<!--------- Sanallar Ayıklanıyor----->
<cfquery name="getvirtuals" dbtype="query">
    SELECT * FROM getVirtualTree WHERE IS_VIRTUAL=1
</cfquery>
<!--------- Ana Ürün Bilgileri----->
<cfquery name="productInfo" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#attributes.VIRTUAL_PRODUCT_ID#
</cfquery>
<cfscript>
     AcilanUrunler=queryNew("VP_ID,STOCK_ID,PRODUCT_ID,SEVIYE","INTEGER,INTEGER,INTEGER,INTEGER");    
</cfscript>
<!----- Ana Ürün Kayıt Ediliyor----->    
<CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,20,productInfo.PROJECT_ID)>	
<CFSET "A.PRODUCT_ID_#attributes.VIRTUAL_PRODUCT_ID#"=K_URUN.PRODUCT_ID>
<CFSET "A.STOCK_ID_#attributes.VIRTUAL_PRODUCT_ID#"=K_URUN.STOCK_ID>
<CFSET "A.SPECT_MAIN_LIST_#attributes.VIRTUAL_PRODUCT_ID#"="">
<cfscript>
    OX={
        VP_ID=#attributes.VIRTUAL_PRODUCT_ID#,
        STOCK_ID=K_URUN.STOCK_ID,
        PRODUCT_ID=K_URUN.PRODUCT_ID,
        SEVIYE=-1
    }
    queryAddRow(AcilanUrunler,OX);
</cfscript>
<cfquery name="upd" datasource="#dsn3#">
    UPDATE VIRTUAL_PRODUCTS_PRT SET  IS_CONVERT_REAL=1,REAL_PRODUCT_ID=#K_URUN.PRODUCT_ID# WHERE VIRTUAL_PRODUCT_ID=#attributes.VIRTUAL_PRODUCT_ID#
</cfquery>
<!----- Sanal Ürünler Kayıt Ediliyor----->    
<cfset SRaRR=[{
    VP_ID=attributes.VIRTUAL_PRODUCT_ID,
    STOCK_ID=K_URUN.STOCK_ID
}]>
<cfoutput query="getvirtuals">    
    <cfquery name="productInfo" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
    </cfquery>
    <CFSET K_URUN=SAVE_URUN(productInfo.PRODUCT_CATID,productInfo.PRODUCT_NAME,10,10,20,productInfo.PROJECT_ID)>	
    <CFSET "A.PRODUCT_ID_#PRODUCT_ID#"=K_URUN.PRODUCT_ID>
    <CFSET "A.STOCK_ID_#PRODUCT_ID#"=K_URUN.STOCK_ID>
    <CFSET "A.SPECT_MAIN_LIST_#PRODUCT_ID#"="">
    <cfquery name="upd" datasource="#dsn3#">
        UPDATE VIRTUAL_PRODUCTS_PRT SET  IS_CONVERT_REAL=1,REAL_PRODUCT_ID=#K_URUN.PRODUCT_ID# WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
    </cfquery>
    <cfscript>
        OX={
            VP_ID=PRODUCT_ID,
            STOCK_ID=K_URUN.STOCK_ID,
            PRODUCT_ID=K_URUN.PRODUCT_ID,
            SEVIYE=SEVIYE
        }
        queryAddRow(AcilanUrunler,OX);
    </cfscript>
    <cfscript>
        O={
            VP_ID=PRODUCT_ID,
            STOCK_ID=K_URUN.STOCK_ID}
        arrayAppend(SRaRR,O);
    </cfscript>
</cfoutput>


<cfquery name="AcilanUrunler" dbtype="query">
    SELECT * FROM AcilanUrunler ORDER BY SEVIYE DESC
</cfquery>

<cfloop query="AcilanUrunler">
    <cfquery name="getPList" dbtype="query">
        SELECT * FROM getVirtualTree WHERE VP_ID=#AcilanUrunler.VP_ID#
    </cfquery> 
    <cfset MAIN_PID=PRODUCT_ID>
    <cfset MAIN_SID=STOCK_ID>
    <CFSET spec_main_id_list="">
    <cfloop query="getPList">        
        <cfquery name="getStokInfo" datasource="#dsn3#">
            SELECT * FROM #DSN3#.STOCKS WHERE PRODUCT_ID=<cfif isDefined("A.PRODUCT_ID_#PRODUCT_ID#")>#evaluate("A.PRODUCT_ID_#PRODUCT_ID#")#<cfelse>#PRODUCT_ID#</cfif>
        </cfquery>
        <cfscript>AgacaEkle(MAIN_SID,MAIN_PID,getStokInfo.STOCK_ID,getStokInfo.PRODUCT_ID,getPList.AMOUNT,"",getPList.QUESTION_ID)</cfscript>
        <CFSET spec_main_id_list="#spec_main_id_list#,#getStokInfo.STOCK_ID#">
    </cfloop>
    <cfscript>
        AddSpects(MAIN_SID,spec_main_id_list);
    </cfscript>
</cfloop>
<cfquery name="getParamSet" datasource="#dsn3#">
    select PRODUCT_CAT_PRODUCT_PARAM_SETTINGS.DEFAULT_STATION_ID,PRODUCT_CAT,PRODUCT_CAT.PRODUCT_CATID 
    from #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS 
    LEFT JOIN #DSN3#.PRODUCT_CAT ON PRODUCT_CAT_PRODUCT_PARAM_SETTINGS.PRODUCT_CATID=PRODUCT_CAT.PRODUCT_CATID
    
</cfquery>
<cfloop query="AcilanUrunler">
    <cfquery name="getParamSet" datasource="#dsn3#">
        select PRODUCT_CAT_PRODUCT_PARAM_SETTINGS.DEFAULT_STATION_ID,PRODUCT_CAT,PRODUCT_CAT.PRODUCT_CATID 
        from #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS 
        LEFT JOIN #DSN3#.PRODUCT_CAT ON PRODUCT_CAT_PRODUCT_PARAM_SETTINGS.PRODUCT_CATID=PRODUCT_CAT.PRODUCT_CATID
        WHERE PRODUCT_CAT.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#STOCK_ID#)
    </cfquery>
    <cfquery name="ins2" datasource="#dsn3#">
     INSERT INTO #DSN3#.WORKSTATIONS_PRODUCTS(
        WS_ID,
        STOCK_ID,
        CAPACITY,
        PRODUCTION_TIME,
        PRODUCTION_TIME_TYPE,
        SETUP_TIME,
        MIN_PRODUCT_AMOUNT,
        PRODUCTION_TYPE,
        MAIN_STOCK_ID,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE)
    VALUES (
        #getParamSet.DEFAULT_STATION_ID#,
        #STOCK_ID#,
        60,
        1,
        1,
        0,
        1,
        0,
        #STOCK_ID#,
        #session.ep.userid#, 
        '#CGI.REMOTE_ADDR#', 
        #now()#)
                            
    </cfquery>
</cfloop>

<cfoutput>[#replace(serializeJSON(A),"//","")#]</cfoutput>
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

<cffunction name="SAVE_URUN" >
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PURCHASE_PRICE">
    <cfargument name="SALE_PRICE">
    <cfargument name="TAX">
    <cfargument name="project_id">
    <cfargument name="shownName" default="">
    
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
    <cfinclude template="../../satis/Includes/add_import_product.cfm">
    <cfscript>
        main_stock_id = GET_MAX_STCK.MAX_STCK;
        main_product_id =GET_PID.PRODUCT_ID;
        spec_name="#urun_adi#";                          
    </cfscript> 
    <cfquery name="ins" datasource="#dsn3#">
        EXEC ADD_PIP_PBS 'PROPERTY3','#arguments.shownName#','#main_product_id#' 
    </cfquery>
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
