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
            <label class="col col-3 col-xs-12">Şube/ Departman</label>
                <div class="col col-9 col-xs-12">   
                   <div style="display:flex">
                    <select name="branch" id="branch" onchange="getDepartments(this)" class="cls1">
                        <option value=''>Seçiniz</option>
                        <cfloop query="GETBranchs">
                            <option value='#BRANCH_ID#'>#BRANCH_NAME#</option>
                        </cfloop>
                    </select>                
    <select name="department" id="department" class="cls1" onchange="getLocations(this)">
    <option value=''>Seçiniz</option>
    <!----<cfloop query="GETBranchs">
        <cfquery name="getDepartments" datasource="#dsn#">
            SELECT * FROM DEPARTMENT WHERE BRANCH_ID=#GETBranchs.BRANCH_ID#
        </cfquery>
        <optgroup label="#GETBranchs.BRANCH_NAME#">  
        <cfloop query="getDepartments">
                  
                <option <cfif isDefined("attributes.department") and attributes.department eq DEPARTMENT_ID>selected</cfif>   value="#DEPARTMENT_ID#">#DEPARTMENT_HEAD#</option>        
            
        </cfloop>
        </optgroup>
    </cfloop>----->
    </select>
</div>
    </div>
    </div>
    <input type="hidden" name="form_submitted" value="1">
        
    
    
    </td>
    <td>
        <div class="form-group">
        <select name="Location" multiple id="Location">

        </select>
    </div>
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
    <option <cfif attributes.stok_type eq 4>selected</cfif> value="4">Stok Stratejisi Girilmeyenler Gelmesin</option>
    <option <cfif attributes.stok_type eq 5>selected</cfif> value="5">Satışı Olmayanlar Gelmesin</option>
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
<td><input type="checkbox" name="isAll" onclick="if($(this).is(':checked'))$('.cls1').hide();else $('.cls1').show();" value="1"> Tüm Depolar Gelsin</td>
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
        spreadsheetAddRow(theSheet,"Minumum - Maximum Stok Raporu  (#dateFormat(now(),'dd.mm.yyyy')#)",SatirSayaci,hucre);
        spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci,1,20);
        spreadsheetFormatRow(theSheet, myformatBold, SatirSayaci);
        SatirSayaci=SatirSayaci+1;
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
            ,(SELECT TOP 1 PP.SHELF_CODE FROM #DSN3#.PRODUCT_PLACE_ROWS AS PPR 
INNER JOIN #DSN3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
WHERE PPR.STOCK_ID=GSLP.STOCK_ID) AS PROPERTY8
            ,PIP.PROPERTY9
            ,GSLP.STOCK_ID
            ,GSLP.PRODUCT_ID
            <cfif isDefined("attributes.isAll") and attributes.isAll eq 1><cfelse>              
                ,GSLP.DEPARTMENT_ID
                ,GSLP.STORE_LOCATION
            </cfif>
            
            ,SUM(GSLP.TOTAL_STOCK) AS TOTAL_STOCK
        FROM #dsn2#.GET_STOCK_LOCATION_Partner AS GSLP
            LEFT JOIN #dsn1#.PRODUCT AS P ON GSLP.PRODUCT_ID = P.PRODUCT_ID
            LEFT JOIN #dsn3#.PRODUCT_INFO_PLUS AS PIP ON GSLP.PRODUCT_ID = PIP.PRODUCT_ID 
        WHERE 1=1
        <cfif isDefined("attributes.isAll") and attributes.isAll eq 1>

        <cfelse>   
          <cfif isDefined("attributes.branch") and len(attributes.branch)>
                <cfif isDefined("attributes.department") and len(attributes.department)>  AND DEPARTMENT_ID = #attributes.department#
                    <cfif isDefined("attributes.Location") and len(attributes.Location)>  AND STORE_LOCATION IN( #attributes.Location#)
                <cfelse>
                    AND DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM #dsn#.DEPARTMENT WHERE BRANCH_ID =#attributes.BRANCH#)

        </cfif>
            
          </cfif>
          </cfif>
            
            
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
                    AND P.PRODUCT_ID IN(select PRODUCT_ID from #DSN3#.RELATED_PRODUCT where RELATED_PRODUCT_ID=#attributes.stock_id# UNION 
                    select RELATED_PRODUCT_ID AS PRODUCT_ID from #DSN3#.RELATED_PRODUCT where PRODUCT_ID=#attributes.stock_id#
                    )
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
            <cfif isDefined("attributes.isAll") and attributes.isAll eq 1><cfelse>     ,GSLP.DEPARTMENT_ID</cfif>
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
                <cfif  not isDefined("attributes.isexcell") and attributes.isexcell neq 1>
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                </cfif>
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
             <!---STOK STRATEJİ  ---->
        <cfquery name="GETMax_Min" datasource="#dsn3#">
            SELECT ISNULL(SUM(MINIMUM_STOCK),0) as MINIMUM_STOCK,ISNULL(SUM(MAXIMUM_STOCK),0) as MAXIMUM_STOCK FROM STOCK_STRATEGY WHERE STOCK_ID=#getStokcks_1.STOCK_ID#
        </cfquery>
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
        <cfif attributes.stok_type eq 4>
            <cfif GETMax_Min.MAXIMUM_STOCK neq 0 and GETMax_Min.MINIMUM_STOCK neq 0>
                <cfinclude template="min_max_inner.cfm">
            </cfif>
        <cfelseif attributes.stok_type eq 5>
            <cfif getInv.AMOUNT neq 0>
                <cfinclude template="min_max_inner.cfm">
            </cfif>
        <cfelse>
            <cfinclude template="min_max_inner.cfm">
        </cfif>
        </cfloop>
        
    </cfoutput>
    <cfif attributes.isexcell eq 1>
     <cfset file_name = "MinumumMaximumStok_#dateformat(now(),'ddmmyyyy')#.xls">
        <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
        <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
        </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" name="theSheet"
        sheetname="MinumumMaximumStok" overwrite=true>
    
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
                            <cfquery name="infPls" datasource="#dsn3#">
                                SELECT PROPERTY1 FROM workcube_metosan.INFO_PLUS WHERE INFO_OWNER_TYPE=-4 AND OWNER_ID=#session.ep.USERID#
                            </cfquery>
                            
                            <cfif infPls.PROPERTY1 eq "Satın Alma Talebi">
                                <input class="ui-wrk-btn" type="button" value="Satın Alma Talebi Ekle" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol();" style="width:140px;">
                            <cfelseif trim(infPls.PROPERTY1) eq "Satın Alma Siparişi">
                                <input class="ui-wrk-btn" type="button" value="Satın Alma Siparişi Ekle" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol(2);" style="width:140px;">
                            </cfif>
                                
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
        <cfif getStokcks_1.recordCount neq attributes.totalrecords>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
        </cfif>
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
        function kota_kontrol(tipa)
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
                if(tipa==2){
                    aktar_form.action="<cfoutput>#request.self#?fuseaction=purchase.list_order&event=add&type=convert</cfoutput>";
                }else{
                    aktar_form.action="<cfoutput>#request.self#?fuseaction=purchase.list_purchasedemand&event=add&type=convert</cfoutput>";
                }
                  
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
        function  getDepartments(el) {
            var branchId=el.value;
            if(branchId.length>0){
                var departmentResult=wrk_query("SELECT * FROM DEPARTMENT WHERE BRANCH_ID="+branchId,"dsn")
                console.log(departmentResult)
                $("#department").html("")
                var os=document.createElement("option")
                    os.setAttribute("value","")
                    os.innerText="Tüm Departmanlar";
                document.getElementById("department").appendChild(os)
                for (let i=0;i< departmentResult.recordcount;i++){
                    var o=document.createElement("option");
                    o.setAttribute("value",departmentResult.DEPARTMENT_ID[i])
                    o.innerText=departmentResult.DEPARTMENT_HEAD[i]
                document.getElementById("department").appendChild(o)
                }
                
            }  
        }
        function getLocations(el){
            var LocationResult=wrk_query("SELECT * FROM STOCKS_LOCATION WHERE DEPARTMENT_ID="+el.value,"dsn")
            $("#Location").html("")
               /* var os=document.createElement("option")
                    os.setAttribute("value","")
                    os.innerText="Tüm Departmanlar";
                document.getElementById("department").appendChild(os)*/
                for (let i=0;i< LocationResult.recordcount;i++){
                    var o=document.createElement("option");
                    o.setAttribute("value",LocationResult.LOCATION_ID[i])
                    o.innerText=LocationResult.COMMENT[i]
                document.getElementById("Location").appendChild(o)
                }
        }
    </script>       
    </cf_box>