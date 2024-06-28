

<cfquery name="AddVirtualResult" datasource="#dsn3#">
	INSERT INTO VIRTUAL_PRODUCTION_ORDERS_RESULT (
		P_ORDER_ID,RECORD_DATE,RECORD_EMP,RESULT_AMOUNT
		)
	VALUES(
		#attributes.V_P_ORDER_ID#,#NOW()#,#session.ep.userid#,#getVirtualProductionOrder.QUANTITY#
		)

</cfquery>

<cfquery name="getVirtualProductionOrder" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>
<cfquery name="getVirtualProduct" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#getVirtualProductionOrder.STOCK_ID#
</cfquery>
<cfquery name="getVirtualProductTREE" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#getVirtualProductionOrder.STOCK_ID#
</cfquery>
<cfif len(getVirtualProduct.PRODUCT_CATID) and getVirtualProduct.PRODUCT_CATID neq 0><cfset pcatid=getVirtualProduct.PRODUCT_CATID><cfelse><cfset pcatid=4084></cfif>
<cfset sidArr=arrayNew(1)>
<cfloop query="getVirtualProductTREE">
	<cfscript>
		o={
			PID=PRODUCT_ID,
			SID=STOCK_ID,
			QTY=AMOUNT,
			QUESTION=QUESTION_ID
		};
		arrayAppend(sidArr,o);
	</cfscript>	

</cfloop>

 <cfquery name="getMaster" datasource="#dsn1#">
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
	FROM PRODUCT AS S 
	LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID     
	INNER JOIN STOCKS AS SS ON SS.PRODUCT_ID=S.PRODUCT_ID                     
	WHERE PRODUCT_CATID=#pcatid# AND PRODUCT_DETAIL2='MASTER'
	</cfquery>

      <cfquery name="get_purchase_price_info" datasource="#dsn1#">
                SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
            </cfquery>
            <cfquery name="get_sales_price_info" datasource="#dsn1#">
                SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0 AND PRODUCT_ID = #getMaster.PRODUCT_ID#
            </cfquery>

            <cfset barcode=getBarcode()>
            <cfset UrunAdi=getVirtualProduct.PRODUCT_NAME>
            <cfif len(getVirtualProduct.PRODUCT_CATID) and getVirtualProduct.PRODUCT_CATID neq 0><cfset kategori_id=getVirtualProduct.PRODUCT_CATID><cfelse><cfset kategori_id=4084></cfif>
<cfquery name="getCat" datasource="#dsn1#">
SELECT * FROM PRODUCT_CAT WHERE PRODUCT_CATID=#kategori_id#
</cfquery>

<CFSET attributes.hierarchy=getCat.HIERARCHY>
<CFOUTPUT query="getMaster">	
	<cfscript>
		
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
		satis_fiyat_kdvli = (getVirtualProduct.PRICE+(getVirtualProduct.PRICE*TAX)/100);
		alis_fiyat_kdvli = get_purchase_price_info.PRICE_KDV;
		sales_money = get_sales_price_info.MONEY;
		cesit_adi='';
		purchase_money = get_purchase_price_info.MONEY;
	</cfscript>
</CFOUTPUT>

<cfinclude template="/AddOns/Partner/satis/Includes/add_import_product.cfm">
ürünü import etmiş olmam lazım
        <cfscript>
            main_stock_id = GET_MAX_STCK.MAX_STCK;
            main_product_id =GET_PID.PRODUCT_ID;
            spec_name="#urun_adi#";                          
        </cfscript>  
        <cfset product_tree_id_list = ''>
<cfset spec_main_id_list =''>
<cfloop array="#sidArr#" item="pr">
    <cfquery name="getStock_Info" datasource="#dsn3#" >
        SELECT TOP 1 PRODUCT_ID,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID=#pr.SID#
    </cfquery>
<cfset attributes.main_stock_id=main_stock_id>
    <cfset attributes.PRODUCT_ID=getStock_Info.PRODUCT_ID>
    <cfset attributes.add_stock_id=pr.SID>
    <cfset attributes.AMOUNT = filterNum(pr.QTY)>
    <cfset attributes.UNIT_ID = getStock_Info.PRODUCT_UNIT_ID>
    <cfset attributes.alternative_questions = PR.QUESTION>
       <cfinclude template="/AddOns/Partner/satis/Includes/PARTNERTREEPORT.cfm">
        <cfset SPEC_MAIN_ID_LIST= listAppend(SPEC_MAIN_ID_LIST, getStock_Info.STOCK_ID)> 
</cfloop>
buraya kadar geldim sanırım
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

<cfset dsn2_alias=dsn2>
<cfset dsn3_alias=dsn3>
<cfset dsn1_alias=dsn1>
<cfset dsn_alias=dsn>
<cfset X_IS_PHANTOM_TREE =0>
<cfset pp_lte=0>
<cfif  pp_lte eq 0>
    <cfinclude template="/v16/production_plan/query/get_product_list.cfm">
    <cfset pp_lte=1>
</cfif>
<cfinclude template="/AddOns/Partner/satis/Includes/add_spect_main_ver.cfm">
<cfif len(spec_main_id_list)>
    <cfquery name="get_spec_main" datasource="#dsn3#">
    	UPDATE 
        	SPECT_MAIN_ROW
		SET
        	RELATED_MAIN_SPECT_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =SPECT_MAIN_ROW.STOCK_ID AND SM.IS_TREE = 1  ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
		WHERE
        	SPECT_MAIN_ID IN (#spec_main_id_list#)
    </cfquery>
</cfif>

<cfquery name="upd" datasource="#dsn3#">
	UPDATE PBS_OFFER_ROW set PRODUCT_ID=#main_product_id#,STOCK_ID=#main_stock_id#,IS_VIRTUAL=0 WHERE UNIQUE_RELATION_ID='#getVirtualProductionOrder.UNIQUE_RELATION_ID#'
</cfquery>




<cfquery name="ivs" datasource="#dsn3#">

  INSERT INTO 
            WORKSTATIONS_PRODUCTS
            (
            WS_ID, STOCK_ID, CAPACITY, PRODUCTION_TIME, PRODUCTION_TIME_TYPE, SETUP_TIME, MIN_PRODUCT_AMOUNT, PRODUCTION_TYPE, PROCESS, MAIN_STOCK_ID, OPERATION_TYPE_ID, 
             ASSET_ID, RECORD_EMP, RECORD_IP, RECORD_DATE
            )
        SELECT        
            TOP (1) 
            WS_ID, #main_stock_id#,CAPACITY, PRODUCTION_TIME, PRODUCTION_TIME_TYPE, SETUP_TIME, MIN_PRODUCT_AMOUNT, PRODUCTION_TYPE, PROCESS, MAIN_STOCK_ID, OPERATION_TYPE_ID, 
             ASSET_ID, #session.ep.userid#, '#CGI.REMOTE_ADDR#', #now()#
        FROM            
            WORKSTATIONS_PRODUCTS AS WORKSTATIONS_PRODUCTS_1
        WHERE        
            STOCK_ID = #getMaster.STOCK_ID#
    </cfquery>

<cfquery name="getspekmain" datasource="#dsn3#">
SELECT top 1 * FROM SPECT_MAIN WHERE STOCK_ID=#main_stock_id#
</cfquery>
<cfset smain_pbs=getspekmain.SPECT_MAIN_ID>




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







<!-------
	//Sanal Sonuç Tablosunu Oluştur
	//Sanal Sonuç Ekle
	Ürün Oluştur
	Ağacacı Oluştur
	Gerçek İş Emri Oluştur
	Gerçek Üretim Sonucu Oluştur
	Teklifi Güncelle
	Bildirim Gönder
----->



