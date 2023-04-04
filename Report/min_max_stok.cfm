<cf_box>
    <!---Depo Stoğu Buradan ---->
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.price_cat" default="-1">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#"> 
    <cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.department_id" default="26">
    <cfparam name="attributes.department_txt" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_code" default="">
    <cfparam name="attributes.PRODUCT_CATID" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.report_type" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword2" default="">
    <cfparam name="attributes.keyword3" default="">
    <cfparam name="attributes.keyword4" default="">
    <cfparam name="attributes.keyword5" default="">
    <cfparam name="attributes.keyword6" default="">
    <cfparam name="attributes.keyword7" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.stok_type" default="">
    <cfparam name="attributes.isexcell" default="0">
    
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfform name="form_upd_product" method="post" enctype="multipart/form-data" >
    <cfoutput>
    
    <table style="width:100%">
    <tr>
    <td>
        <div class="form-group" id="item-product_code">
            <label class="col col-3 col-xs-12">Filtre</label>
                <div class="col col-9 col-xs-12">        
                    <input name="keyword" id="keyword" type="text" value="#attributes.keyword#" >
                </div>
        </div>
    </td>
    <td>
        <div class="form-group" id="item-brand_id">
            <label class="col col-3 col-xs-12">Marka</label>
            <div class="col col-9 col-xs-12">       
            <cf_wrkproductbrand compenent_name="getProductBrand" brand_id="#attributes.brand_id#">
            </div>
        </div>
    </td>
    <td>
        
    <div class="form-group" id="item-product_cat">
                                    <label class="col col-3 col-xs-12"> Kategori  *</label>
                                    <div class="col col-9 col-xs-12">
                                        <div class="input-group">
                                            
                                            <input type="hidden" name="old_product_catid" id="old_product_catid" value="">
                                            <input type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
                                            <input name="product_cat" type="text" value="#attributes.product_cat#" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');" id="product_cat" class=""><div id="product_cat_div_2" name="product_cat_div_2" class="completeListbox cf_popup" autocomplete="on" style="display: none;"></div>
                                            <span class="input-group-addon icon-ellipsis btnPoniter" title=" Ürün Kategorisi Ekle  !" onclick="windowopen('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form_upd_product.product_catid&field_name=form_upd_product.product_cat','list');"></span>
                                        </div>
                                    </div>
                                </div>
    </td> 
    <td>
    <div class="form-group" id="item-is_gift_card">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"> Excell </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="isexcell" id="isexcell" value="1" onclick="kontrol_day();"></div>
    </div>
    
    </td>
    <td>
    <cfquery name="GETBranchs" datasource="#dsn#">
        SELECT * FROM BRANCH where COMPANY_ID=#session.ep.COMPANY_ID#
    </cfquery>
    
        <div class="form-group" id="item-product_code">
            <label class="col col-3 col-xs-12">Departman</label>
                <div class="col col-9 col-xs-12">   
    <select name="department" id="department" >
    <option value=''>Seçiniz</option>
    <cfloop query="GETBranchs">
        <cfquery name="getDepartments" datasource="#dsn#">
            SELECT * FROM DEPARTMENT WHERE BRANCH_ID=#GETBranchs.BRANCH_ID#
        </cfquery>
        <optgroup label="#GETBranchs.BRANCH_NAME#">  
        <cfloop query="getDepartments">
                  
                <option <cfif isDefined("attributes.department") and attributes.department eq DEPARTMENT_ID>selected</cfif>   value="#DEPARTMENT_ID#">#DEPARTMENT_HEAD#</option>        
            
        </cfloop>
        </optgroup>
    </cfloop>
    </select>
    </div>
    </div>
    <input type="hidden" name="form_submitted" value="1">
        
    
    
    </td>
    
    </tr>
    <tr>
    <td>
    
        <div class="form-group" id="item-product_code">
            <label class="col col-3 col-xs-12">Stok</label>
                <div class="col col-9 col-xs-12">   
    <select name="stok_type" id="stok_type" >
    <option value=''>Seçiniz</option>
    <option <cfif attributes.stok_type eq 1>selected</cfif> value="1">Pozitif Stoklar</option>
    <option <cfif attributes.stok_type eq 2>selected</cfif> value="2">Negatif Stoklar</option>
    <option <cfif attributes.stok_type eq 3>selected</cfif> value="3">"0" Stoklar</option>
    
    </select>
    </div>
    </div>
    </td>
    <td>
        <input type="file" name="file_11" id="file_11">
        <input type="hidden"  name="FileName" id="FileName">
    </td>
    <td>
        <div class="form-group">
            <label>B.Tarihi</label>
        <input type="date" name="start_date">
    </div>
    </td>
    <td>
        <div class="form-group">
            <label>Bit.Tarihi</label>
        <input type="date" name="finish_date">
    </div>
    </td>
    <td><input type="submit"></td>
    </tr>
    </table>
    </cfoutput>
    </cfform>
    <cfif isDefined("attributes.form_submitted") and attributes.form_submitted eq 1>
    <cfif attributes.isexcell eq 1>
    <cfscript>
     theSheet = SpreadsheetNew("CariEkstre");
     SatirSayaci=1;
        myFormatRed=StructNew();
        myFormatRed.color="red";
        myFormatRed.bold="true";
    
        myFormatGreen=StructNew();
        myFormatGreen.color="green";
        myFormatGreen.bold="true";
    
        myformatBold=structNew();
        myformatBold.bold="true";
    
        myFormatBlue=StructNew();
        myFormatBlue.color="blue";
        myFormatBlue.bold="true";
    
        myformatSon=structNew();
        myformatSon.bold="true";
        myformatSon.bottomborder="medium";
    
        myFormatFatura=structNew();
        myFormatFatura.color="dark_teal";
        myFormatFatura.bold="true";
        hucre=1;
           SpreadsheetAddRow(theSheet,"Sıra,Ürün Kodu,Özel Kod,Ürün Adı,Raf,Depo(i),Depo,Mevcut,V.Sipariş,Ü.Gelecek,T.Artan,A.Sipariş,Ü.Gidecek,T.Azalan,Satılabilir,Satış,Sarf,Min,Max,İhtiyaç",SatirSayaci,hucre);
        hucre=20;
        spreadsheetFormatRow(theSheet, myformatBold, SatirSayaci);
        
    </cfscript>
    </cfif>
    <cfif len(attributes.product_cat)>
    <cfquery name="GETcATS" datasource="#DSN1#">
        DECLARE @HIEAR NVARCHAR(150)
    SELECT @HIEAR=HIERARCHY FROM workcube_metosan_product.PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.PRODUCT_CATID#
    SELECT *
    FROM workcube_metosan_product.PRODUCT_CAT
    WHERE PRODUCT_CATID = #attributes.PRODUCT_CATID#
    UNION
    SELECT * FROM workcube_metosan_product.PRODUCT_CAT WHERE HIERARCHY LIKE N'%'+@HIEAR+'.%'
    </cfquery>
    
    <CFSET CATLIST=valueList(GETcATS.PRODUCT_CATID)>
    </cfif>
    <cfif isDefined("attributes.FileName") and len(attributes.FileName)>
        <cffile action = "upload"
    fileField = "file_11"
    destination = "#expandPath("./ExDosyalar")#" 
    nameConflict = "Overwrite" result="resul"> 
    
    <cfspreadsheet  action="read" src = "#expandPath("./ExDosyalar/#attributes.fileName#")#" query = "res">
    
    <cfquery name = "get_invoice_no" dbtype = "query">
        SELECT DISTINCT
            col_1 as ORRS,
            col_2 AS PRODUCT_CODE, 
            col_3 AS QUANTITY                   
        FROM
            res     
    </cfquery>
    <cfquery name="DelTempTable" datasource="#dsn3#">
        IF EXISTS(SELECT * FROM sys.tables where name = 'TempReportPBS_#session.ep.USERID#')
        BEGIN
            DROP TABLE #dsn3#.TempReportPBS_#session.ep.USERID#
        END    
    </cfquery>
    <cfquery name="cr" datasource="#dsn3#">
        CREATE TABLE #dsn3#.TempReportPBS_#session.ep.USERID#(PRODUCT_CODE NVARCHAR(max)) 
    </cfquery>
    <CFLOOP query="get_invoice_no">
    <cfquery name="iinssertt" datasource="#dsn3#">
        INSERT INTO #dsn3#.TempReportPBS_#session.ep.USERID#(PRODUCT_CODE) VALUES('#PRODUCT_CODE#')
    </cfquery>
    </CFLOOP>
    </cfif>
    <cfquery name="getStokcks_1" datasource="#dsn2#">
        WITH CTE1 AS (
            SELECT P.PRODUCT_NAME
            ,P.PRODUCT_CODE
            ,P.PRODUCT_CODE_2
            ,PIP.PROPERTY8
            ,PIP.PROPERTY9
            ,GSLP.PRODUCT_ID
            ,GSLP.STOCK_ID
            ,GSLP.DEPARTMENT_ID
            ,SUM(GSLP.TOTAL_STOCK) AS TOTAL_STOCK
        FROM #dsn2#.GET_STOCK_LOCATION_Partner AS GSLP
            ,#dsn1#.PRODUCT AS P
            ,#dsn3#.PRODUCT_INFO_PLUS AS PIP
        WHERE 1=1
          <cfif isDefined("attributes.department") and len(attributes.department)>  AND DEPARTMENT_ID = #attributes.department#</cfif>
            AND GSLP.PRODUCT_ID = P.PRODUCT_ID
            AND GSLP.PRODUCT_ID = PIP.PRODUCT_ID    
           <cfif len(attributes.product_cat)> AND P.PRODUCT_CATID IN(#CATLIST#)</cfif>
            <cfif isdefined("attributes.FileName") and len(attributes.FileName)>
                AND P.PRODUCT_CODE IN (select TRIM(PRODUCT_CODE) from #dsn3#.TempReportPBS_#session.ep.USERID#)
               
                <cfelse>
            
            <cfif len(attributes.keyword)>
            AND
                (
                    P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                    P.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
                    P.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%'
                )
            </cfif>
            <cfif len(attributes.stock_id)>
                    P.PRODUCT_ID=#attributes.product_id#
                </cfif>
        </cfif>
            <cfif len(attributes.keyword2)>
            AND ( P.SHORT_CODE_ID IN
                (
                    SELECT        
                        MODEL_ID
                    FROM            
                        #dsn1_alias#.PRODUCT_BRANDS_MODEL
                    WHERE
                        MODEL_NAME like '#attributes.keyword2#'
                ) or P.MANUFACT_CODE LIKE '#attributes.keyword2#')
            </cfif>
            <cfif isDefined("attributes.brand_name") and len(attributes.brand_name)>
               AND P.BRAND_ID=#attributes.brand_id#
            </cfif>
              <cfif len(attributes.keyword5)>
                    AND (SELECT TOP (1) PROPERTY6 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID = P.PRODUCT_ID) = '#attributes.keyword5#'
                </cfif>
                <cfif len(attributes.keyword4)>
                    AND (SELECT TOP (1) PROPERTY5 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID = P.PRODUCT_ID) = '#attributes.keyword4#'
                </cfif>
                <cfif len(attributes.keyword3)>
                    AND (SELECT TOP (1) PROPERTY3 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID = P.PRODUCT_ID) = '#attributes.keyword3#'
                </cfif>
                <cfif len(attributes.keyword6)>
                    AND (SELECT TOP (1) PROPERTY8 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID = P.PRODUCT_ID) = '#attributes.keyword6#'
                </cfif>
                <cfif len(attributes.keyword7)>
                    AND (SELECT TOP (1) PROPERTY9 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID = P.PRODUCT_ID) = '#attributes.keyword7#'
                </cfif>   
                <cfif len(attributes.stok_type)>
                <cfif attributes.stok_type eq 1>AND TOTAL_STOCK >0</cfif>
                <cfif attributes.stok_type eq 2>AND TOTAL_STOCK<0</cfif>
                <cfif attributes.stok_type eq 3>AND TOTAL_STOCK=0</cfif>
                </cfif>
                
        GROUP BY
        P.PRODUCT_NAME
            ,P.PRODUCT_CODE
            ,P.PRODUCT_CODE_2
            ,PIP.PROPERTY8
            ,PIP.PROPERTY9
            ,GSLP.PRODUCT_ID
            ,GSLP.STOCK_ID
            ,GSLP.DEPARTMENT_ID
         <!-----    <cfif isDefined("attributes.is_minumum")>
            HAVING
                SUM(REAL_STOCK-(RESERVED_PROD_STOCK+RESERVE_SALE_ORDER_STOCK+NOSALE_STOCK)) <=ISNULL((
                SELECT MINIMUM_STOCK
                FROM #dsn3#.STOCK_STRATEGY
                WHERE STOCK_ID = TBL.STOCK_ID
                ), 0)   </cfif> ----->
            ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (ORDER BY PRODUCT_NAME DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        </cfquery>
        
        <cfset attributes.totalrecords=getStokcks_1.QUERY_COUNT>
        
        <cf_grid_list>
            <thead>
            <tr>
                <th></th>
                <th>Ürün Kodu</th>
                <th>Özel Kod</th>
                <th>Ürün Adı</th>
                <th>Raf</th>
                <th>Depo(i)</th>
                <th>Depo</th>
                <th>Mevcut</th>
                <th>V.Sipariş</th>
                <th>Ü.Gelecek </th>
                <th>T.Artan</th>
                <th>A.Sipariş</th>
                <th>Ü.Gidecek</th>
                <th>T.Azalan</th>
                <th>Satılabilir</th>    
                <th>Satış</th>
                <th>Sarf</th>
                        
                <th>Min</th>
                <th>Max</th>
                <th>İhtiyaç</th>
                <th><input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','_conversion_product_',<cfoutput>#getStokcks_1.recordcount#</cfoutput>);"></th>
            </tr>
        </thead>
        <tbody>
        
         <cfquery name="GET_MONEY" datasource="#DSN2#">
         SELECT * FROM SETUP_MONEY
    </cfquery>
    
    <cfif getStokcks_1.recordcount>
        <cfset stock_id_list = Valuelist(getStokcks_1.stock_id)>
        <cfquery name="GET_PRICE" datasource="#DSN3#">
             SELECT
                P.MONEY,
                 P.PRICE,
                 S.STOCK_ID
              FROM
                <cfif attributes.price_cat eq -1>
                    PRICE_STANDART P,
                <cfelse>
                    PRICE P,
                </cfif>
                  STOCKS S
               WHERE
                S.PRODUCT_ID = P.PRODUCT_ID AND
                 S.STOCK_ID IN (#stock_id_list#) AND
                <cfif attributes.price_cat eq -1>
                    P.PRICESTANDART_STATUS = 1 AND
                    P.PURCHASESALES = 0
                <cfelse>
                    ISNULL(P.STOCK_ID,0)=0 AND
                    ISNULL(P.SPECT_VAR_ID,0)=0 AND
                    P.STARTDATE <= #now()# AND
                    (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                    P.PRICE_CATID = #attributes.price_cat#
                </cfif>
         </cfquery>
          <cfif GET_PRICE.RECORDCOUNT>
            <cfoutput query="GET_PRICE">
                 <cfset 'product_price_#GET_PRICE.STOCK_ID#' = GET_PRICE.PRICE>
                <cfset 'product_money_#GET_PRICE.STOCK_ID#' = GET_PRICE.MONEY>
            </cfoutput>
        </cfif>
        </cfif>
    <cfoutput>
        <cfloop query="getStokcks_1">
        <!---REZERVER SİPARİŞLER ---->
        <cfquery name="getReserved_1" datasource="#dsn3#">
            SELECT ISNULL(SUM(STOCK_AZALT),0) AS STOCK_AZALT,ISNULL(SUM(STOCK_ARTIR),0) AS STOCK_ARTIR FROM (            SELECT
                        SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                        0 AS STOCK_ARTIR,			
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                        ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                     FROM
                        #dsn3#.STOCKS S,
                        #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                        #dsn3#.ORDERS ORDS,		
                        #dsn3#.PRODUCT_UNIT PU
                     WHERE
                        ORR.STOCK_ID = S.STOCK_ID AND 
                        ORDS.RESERVED = 1 AND
                        ORDS.ORDER_STATUS = 1 AND
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (
                            (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                            OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                        )AND
                        S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                        and orr.STOCK_ID=#getStokcks_1.STOCK_ID#
                     GROUP BY
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD,
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ORDS.DELIVER_DEPT_ID,
                        ORDS.LOCATION_ID,
                        ORR.DEPARTMENT_ID,
                        ORR.LOCATION_ID
                    UNION
                    SELECT
                        0 AS STOCK_AZALT,
                        SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                        ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                     FROM
                        #dsn3#.STOCKS S,
                        #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                        #dsn3#.ORDERS ORDS,
                        #dsn#.STOCKS_LOCATION SL,	
                        #dsn3#.PRODUCT_UNIT PU
                     WHERE
                        ORR.STOCK_ID = S.STOCK_ID AND 
                        ORDS.RESERVED = 1 AND
                        ORDS.ORDER_STATUS = 1 AND
                        ORR.ORDER_ID = ORDS.ORDER_ID AND		
                        ORDS.PURCHASE_SALES=0 AND
                        ORDS.ORDER_ZONE=0 AND
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID=SL.LOCATION_ID AND
                        ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                        SL.NO_SALE = 0 AND
                        S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                        AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
                     GROUP BY
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD,
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ORDS.DELIVER_DEPT_ID,
                        ORDS.LOCATION_ID,
                        ORR.DEPARTMENT_ID,
                        ORR.LOCATION_ID
                    UNION 
                    SELECT
                        SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                        0 AS STOCK_ARTIR,
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                        ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                     FROM
                        #dsn3#.STOCKS S,
                        #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                        #dsn3#.ORDERS ORDS,
                        #dsn3#.SPECTS_ROW SR,		
                        #dsn3#.PRODUCT_UNIT PU
                     WHERE
                        SR.STOCK_ID = S.STOCK_ID AND 
                        ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                        SR.IS_SEVK=1 AND
                        ORDS.RESERVED = 1 AND
                        ORDS.ORDER_STATUS = 1 AND
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (
                            (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                            OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                        )AND
                        S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                        AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
                     GROUP BY
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ORDS.DELIVER_DEPT_ID,
                        ORDS.LOCATION_ID,
                        ORR.DEPARTMENT_ID,
                        ORR.LOCATION_ID
                    UNION 	
                    SELECT
                        0 AS STOCK_AZALT,
                        SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD,
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                        ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                     FROM
                       #dsn3#. STOCKS S,
                      #dsn3#. GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                        #dsn3#.ORDERS ORDS,
                       #dsn3#. SPECTS_ROW SR,
                        #dsn#.STOCKS_LOCATION SL,
                        #dsn3#.PRODUCT_UNIT PU
                     WHERE
                        SR.STOCK_ID = S.STOCK_ID AND 
                        ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                        SR.IS_SEVK=1 AND
                        ORDS.RESERVED = 1 AND
                        ORDS.ORDER_STATUS = 1 AND
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        ORDS.PURCHASE_SALES=0 AND
                        ORDS.ORDER_ZONE=0 AND
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID=SL.LOCATION_ID AND
                        ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                        SL.NO_SALE = 0  AND		
                        S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                        AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
                     GROUP BY
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID,
                        ORDS.DELIVER_DEPT_ID,
                        ORDS.LOCATION_ID,
                        ORR.DEPARTMENT_ID,
                        ORR.LOCATION_ID
        
        
            ) AS TBL
        
           <cfif isDefined("attributes.department") and len(attributes.department)> WHERE TBL.DEPARTMENT_ID=#attributes.department#</cfif>
        
        </cfquery>
        <!---ÜRETİM EMRİ RESERVE---->
        <cfquery name="getReserved_2" datasource="#dsn3#">
            SELECT  ISNULL(SUM(STOCK_AZALT),0) AS STOCK_AZALT,
                    ISNULL(SUM(STOCK_ARTIR),0) AS STOCK_ARTIR  
            FROM    GET_PRODUCTION_RESERVED_LOCATION 
            WHERE   PRODUCT_ID=#getStokcks_1.PRODUCT_ID# 
                  <cfif isDefined("attributes.department") and len(attributes.department)> AND DEPARTMENT_ID=#attributes.department#</cfif>
        </cfquery>
        <!---STOK STRATEJİ  ---->
        <cfquery name="GETMax_Min" datasource="#dsn3#">
            SELECT ISNULL(SUM(MINIMUM_STOCK),0) as MINIMUM_STOCK,ISNULL(SUM(MAXIMUM_STOCK),0) as MAXIMUM_STOCK FROM STOCK_STRATEGY WHERE STOCK_ID=#getStokcks_1.STOCK_ID#
        </cfquery>
        <cfset tartan=TOTAL_STOCK+getReserved_2.STOCK_ARTIR+getReserved_1.STOCK_ARTIR>
        <cfset tazlan=getReserved_2.STOCK_AZALT+getReserved_1.STOCK_AZALT>
            <cfquery name="getInv" datasource="#dsn2#">
            SELECT ISNULL(SUM(IR.AMOUNT),0) AS AMOUNT FROM INVOICE AS I 
            INNER JOIN INVOICE_ROW AS IR ON I.INVOICE_ID=IR.INVOICE_ID
            WHERE 
            I.PURCHASE_SALES=1
            AND I.INVOICE_CAT NOT IN(67,69)
            AND I.IS_IPTAL=0
            <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
            AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
            AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
            </cfif> 
            AND IR.STOCK_ID=#getStokcks_1.STOCK_ID#
            <cfif isDefined("attributes.department") and len(attributes.department)>AND   I.DEPARTMENT_ID=#attributes.department# </cfif>
        </cfquery>
        <cfquery name="getSf" datasource="#dsn2#"> 
            SELECT ISNULL(SUM(SFR.AMOUNT),0) AS AMOUNT FROM STOCK_FIS  AS SF 
            INNER JOIN STOCK_FIS_ROW AS SFR ON SF.FIS_ID=SFR.FIS_ID
            WHERE SF.FIS_TYPE=111
            <cfif isDefined("attributes.department") and len(attributes.department)>   AND SF.DEPARTMENT_OUT=#attributes.department#</cfif>
            <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
            AND SF.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
            AND SF.FIS_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
            </cfif>
            AND SFR.STOCK_ID=#getStokcks_1.STOCK_ID#
        </cfquery>
        <tr>
            <td>#getStokcks_1.RowNum#</td>
            <td><a onclick="windowopen('index.cfm?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#','medium');">#getStokcks_1.PRODUCT_CODE#</a></td>
            <td><a href="javascript://" onclick="windowopen('/index.cfm?fuseaction=#attributes.fuseaction#&report_id=#attributes.report_id#&event=det&form_submitted=1&stock_id=#PRODUCT_ID#')">#getStokcks_1.PRODUCT_CODE_2#</a></td>
            <td>#getStokcks_1.PRODUCT_NAME#</td>
            <td>#getStokcks_1.PROPERTY8#</td>
            <td>#getStokcks_1.PROPERTY9#</td>
            <cfquery name="getDname" datasource="#dsn#">
            select TOP 1 * from DEPARTMENT where DEPARTMENT_ID=#DEPARTMENT_ID#
            </cfquery>
            <td>#getDname.DEPARTMENT_HEAD#</td>
    
    
            <td> <cfif getStokcks_1.TOTAL_STOCK lt GETMax_Min.MAXIMUM_STOCK><span style="font-weight:bold;color:red">#AmountFormat(getStokcks_1.TOTAL_STOCK)#</span><cfelseif getStokcks_1.TOTAL_STOCK gt GETMax_Min.MAXIMUM_STOCK> <span style="font-weight:bold;color:blue">#AmountFormat(getStokcks_1.TOTAL_STOCK)#</span></cfif> </td>
            <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_orders&taken=0&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_1.STOCK_ARTIR)#</a></td>
            <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_2.STOCK_ARTIR)#</a></td>    
            <td>#AmountFormat(tartan)#</td>
            <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_orders&taken=1&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_1.STOCK_AZALT)#</a></td>
            <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_2.STOCK_AZALT)#</a></td>    
            <td>#AmountFormat(tazlan)#</td>
            <td><cfset satilabilir=tartan-tazlan> #AmountFormat(tartan-tazlan)#</td>
                    <td>#AmountFormat(getInv.AMOUNT)#</td>
            <td>#AmountFormat(getSf.AMOUNT)#</td>
            <td>#AmountFormat(GETMax_Min.MINIMUM_STOCK)#</td>        
            <td>#AmountFormat(GETMax_Min.MAXIMUM_STOCK)#</td>
            <td><input style="width:50px;text-align:right" type="text" value="<cfset ihtiyac=satilabilir-GETMax_Min.MINIMUM_STOCK><cfif ihtiyac lt 0><cfset ihtiyac= ihtiyac*-1>#ihtiyac#<cfelse><cfset ihtiyac=0>0</cfif>" id="row_total_need_#getStokcks_1.stock_id#" name="row_total_need_#getStokcks_1.stock_id#"></td>
            <td><input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#"></td>
                    <cfif isdefined('product_price_#STOCK_ID#')>
                                    <cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
                                <cfelse>
                                    <cfset row_price = 0 >
                                </cfif>
                                <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                                <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(ihtiyac*row_price)#" onKeyup="return(FormatCurrency(this,event));">
                               <select name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" style="width:45px;display:none;">
                                    <cfloop query="get_money">
                                                    <option value="#money#,#RATE2#"<cfif isdefined('product_money_#getStokcks_1.STOCK_ID#') and Evaluate('product_money_#getStokcks_1.STOCK_ID#') is money>selected</cfif>>#money#</option>
                                    </cfloop>
                                </select>
        </tr>
        <cfif attributes.isexcell eq 1>
        <cfscript>
        
        SatirSayaci=SatirSayaci+1;
        hucre=1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.RowNum#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_CODE#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_CODE_2#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_NAME#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.PROPERTY8#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.PROPERTY9#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getDname.DEPARTMENT_HEAD#", SatirSayaci, hucre);
        hucre=hucre+1;   
            spreadsheetSetCellValue(theSheet, "#getStokcks_1.TOTAL_STOCK#", SatirSayaci, hucre);
            if(getStokcks_1.TOTAL_STOCK lt GETMax_Min.MINIMUM_STOCK){
                SpreadsheetFormatCell(theSheet,myFormatRed,SatirSayaci,hucre); 
            } else if(getStokcks_1.TOTAL_STOCK gt GETMax_Min.MAXIMUM_STOCK){
                SpreadsheetFormatCell(theSheet,myFormatBlue,SatirSayaci,hucre); 
            }else{}
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getReserved_1.STOCK_AZALT#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getReserved_2.STOCK_AZALT#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#tartan#", SatirSayaci, hucre);
        hucre=hucre+1;
               spreadsheetSetCellValue(theSheet, "#getReserved_1.STOCK_ARTIR#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getReserved_2.STOCK_ARTIR#", SatirSayaci, hucre);
        hucre=hucre+1;
                spreadsheetSetCellValue(theSheet, "#tazlan#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#satilabilir#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#getInv.AMOUNT#", SatirSayaci, hucre);
        hucre=hucre+1;
                spreadsheetSetCellValue(theSheet, "#getSf.AMOUNT#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#GETMax_Min.MINIMUM_STOCK#", SatirSayaci, hucre);
        hucre=hucre+1;
            spreadsheetSetCellValue(theSheet, "#GETMax_Min.MAXIMUM_STOCK#", SatirSayaci, hucre);
        hucre=hucre+1;
            
            spreadsheetSetCellValue(theSheet, "#ihtiyac#", SatirSayaci, hucre);
                                                      
        </cfscript>
        </cfif>
        </cfloop>
        
    </cfoutput>
    <cfif attributes.isexcell eq 1>
     <cfset file_name = "Uretim_Planlama_#dateformat(now(),'ddmmyyyy')#.xls">
        <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
        <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
        </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" name="theSheet"
        sheetname="Uretim_Planlama" overwrite=true>
    
       <script type="text/javascript">
        <cfoutput>
        get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
        </cfoutput>
        </script>
    
    </cfif>
    </tbody>
                <tfoot>
                    <tr>
                        <td colspan="19" style="text-align:right">
                                <input class="ui-wrk-btn" type="button" value="Satın Alma Talebi Ekle" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol();" style="width:140px;">
                        </td>
                    </tr>
                </tfoot> 
        </cf_grid_list>
    <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
        <cfset adres="#attributes.fuseaction#&report_id=#attributes.report_id#&form_submitted=1&event=det">
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
           </cfif>
        <cfif len(attributes.keyword2)>
            <cfset adres = "#adres#&keyword2=#attributes.keyword2#">
           </cfif>
        <cfif len(attributes.keyword3)>
            <cfset adres = "#adres#&keyword3=#attributes.keyword3#">
           </cfif>
        <cfif len(attributes.keyword4)>
            <cfset adres = "#adres#&keyword4=#attributes.keyword4#">
           </cfif>
        <cfif len(attributes.keyword5)>
            <cfset adres = "#adres#&keyword5=#attributes.keyword5#">
           </cfif>
        <cfif len(attributes.keyword6)>
            <cfset adres = "#adres#&keyword6=#attributes.keyword6#">
        </cfif>   
        <cfif len(attributes.keyword7)>
            <cfset adres = "#adres#&keyword7=#attributes.keyword7#">
           </cfif>
           <cfif len(attributes.start_date)>
            <cfset adres = "#adres#&start_date=#attributes.start_date#">
           </cfif>
        <cfif len(attributes.finish_date)>
            <cfset adres = "#adres#&finish_date=#attributes.finish_date#">
           </cfif>
        <cfif isdefined('attributes.report_type') and len(attributes.report_type)>
               <cfset adres = "#adres#&report_type=#attributes.report_type#">
        </cfif>
        <cfif Len(attributes.product_code)>
            <cfset adres = "#adres#&product_code=#attributes.product_code#">
        </cfif>
        <!-- sil -->
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
            <!-- sil -->
    </cfif>
    </cfif>
    <form name="aktar_form" method="post">
        <input type="hidden" name="list_price" id="list_price" value="0">
        <input type="hidden" name="price_cat" id="price_cat" value="">
        <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
        <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
        <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
        <input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
        <input type="hidden" name="convert_price" id="convert_price" value="">
        <input type="hidden" name="convert_price_other" id="convert_price_other" value="">
        <input type="hidden" name="convert_money" id="convert_money" value="">
    </form>
    <script type="text/javascript">
        document.getElementById('keyword').focus();
        function kota_kontrol()
        {
             var convert_list ="";
             var convert_list_amount ="";
             var convert_list_price ="";
             var convert_list_price_other="";
             var convert_list_money ="";
             //
               console.log("Merhaba")
             <cfif isdefined("attributes.form_submitted")>
                 <cfoutput query="getStokcks_1">
                 console.log(document.all.conversion_product_#stock_id#)
                     if(document.all.conversion_product_#stock_id#.checked && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
                     {
                        convert_list += "#stock_id#,";
                        convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value,3)+',';
                        convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,3)+',';
                        convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,8)+',';
                        convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
                     }
                 </cfoutput>
            </cfif>
            console.log(convert_list)
            document.getElementById('convert_stocks_id').value=convert_list;
            document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
            document.getElementById('convert_price').value=convert_list_price;
            document.getElementById('convert_price_other').value=convert_list_price_other;
            document.getElementById('convert_money').value=convert_list_money;
            if(convert_list)//Ürün Seçili ise
            {
                windowopen('','wide','cc_paym');
                  aktar_form.action="<cfoutput>#request.self#?fuseaction=purchase.list_purchasedemand&event=add&type=convert</cfoutput>";
                 aktar_form.target='cc_paym';
                aktar_form.submit();
             }
             else
                 alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
        }
        function wrk_select_all2(all_conv_product,_conversion_product_,number)
        {
            for(var cl_ind=1; cl_ind <= number; cl_ind++)
            {
                if(document.getElementById(all_conv_product).checked == true)
                {
                    if(document.getElementById('_conversion_product_'+cl_ind).checked == false)
                        document.getElementById('_conversion_product_'+cl_ind).checked = true;
                }
                else
                {
                    if(document.getElementById('_conversion_product_'+cl_ind).checked == true)
                        document.getElementById('_conversion_product_'+cl_ind).checked = false;
                }
            }
        }
        $('#file_11').change(function(e){
            var fileName = e. target. files[0]. name;
            $("#FileName").val(fileName)
        });
    </script>       
    </cf_box>