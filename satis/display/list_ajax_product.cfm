<style>
    .big_list tbody tr td {
     padding: 0; 
    /* height: 20px; */
    border: 1px solid #d6d6d6;
    color: #000;
}
.ui-info-text a { font-family: 'Roboto'; font-size: 11px; color: #04ad6e; font-weight: bold; }
</style>
<cfparam name="attributes.start_row" default="1">
<cfparam name="attributes.getCompId" default="">
<cfparam name="attributes.hiearchy" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.end_row" default="10">
<cfparam name="attributes.max_row" default="10">
<cfparam name="attributes.price_catid" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfif isDefined("attributes.sayfa")>
<cfif attributes.sayfa neq 0>
<cfset attributes.start_row=attributes.sayfa * attributes.max_row+1>
<cfset attributes.end_row=attributes.start_row+attributes.max_row-1>
</cfif>
</cfif>
<cfif session.ep.userid eq 1146>
    
</cfif>

<cfset P_RETURN=getProducts(
    '#attributes.keyword#',
    session.ep.userid,
    dsn2,dsn1,dsn3,
    attributes.price_catid,
    attributes.company_id,
    attributes.start_row,
    attributes.end_row,
    attributes.getCompId,
    attributes.hiearchy,
    attributes.brand_id
    )>

<cf_big_list>
    <thead>
        <tr>
            <th></th>
            <th>Stok Kodu</th>
            <th>Özel Kod</th>
            <th>Ürün</th>
            <th>Ürün Kategorisi</th>
            <th>Üretici Kodu</th>
            <th>Birim</th>
            <th>Marka</th>
            <th>Depo</th>
            <th>S.Stok</th>
            <th>İlişkili Ürünler</th>
            <th></th>
            <th></th>
            <th></th>
            <th></th>
        </tr>
    </thead>
<cfoutput>
    <cfif P_RETURN.recordcount gt 0>
    <cfloop array="#P_RETURN.PRODUCTS#" item="it" index="ix">
        <tr>
            <td>#it.ROWNUM#</td>
            <td>#it.STOCK_CODE#</td>
            <td>#it.PRODUCT_CODE_2#</td>
            <td>
                <!---<cfif isDefined("attributes.actType") and len(attributes.actType)>
                    <cfif attributes.actType eq 1 or attributes.actType eq 2>
                        <a onclick="setRow(#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.PRODUCT_NAME#',#attributes.question_id#,'#it.BARCOD#','#it.MAIN_UNIT#',#it.PRICE#,1,#it.DISCOUNT_RATE#)">#it.PRODUCT_NAME#</a>
                    </cfif>    
                    <cfif attributes.actType eq 3>
                        <a onclick="addCol(#it.STOCK_ID#)">#it.PRODUCT_NAME#</a>
                    </cfif>
                </cfelse>
                    <a onclick="AddRow(#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.STOCK_CODE#','#it.BRAND_NAME#',0,#attributes.miktar#,#it.PRICE#,'#it.PRODUCT_NAME#',#it.TAX#,#it.DISCOUNT_RATE#,0,'','#it.MONEY#',#it.PRICE#,-6,#it.IS_MANUEL#,#it.LAST_COST#,'#it.MAIN_UNIT#')">#it.PRODUCT_NAME#</a>
                </cfif>----->
                <cfif isDefined("attributes.actType") and len(attributes.actType)>
                    <cfif attributes.actType eq 1 or attributes.actType eq 2>
                        <a onclick="setRow(#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.PRODUCT_NAME#',#attributes.question_id#,'#it.BARCOD#','#it.MAIN_UNIT#',#it.PRICE#,1,#it.DISCOUNT_RATE#)">#it.PRODUCT_NAME#</a>
                    </cfif>
                    <cfif attributes.actType eq 3>
                        <a onclick="addCol(#it.PRODUCT_ID#)">#it.PRODUCT_NAME#</a>
                    </cfif>
                <cfelse>
                    <a onclick="AddRow(#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.STOCK_CODE#','#it.BRAND_NAME#',0,#attributes.miktar#,#it.PRICE#,'#it.PRODUCT_NAME#',#it.TAX#,#it.DISCOUNT_RATE#,0,'','#it.MONEY#',#it.PRICE#,-6,#it.IS_MANUEL#,#it.LAST_COST#,'#it.MAIN_UNIT#')">#it.PRODUCT_NAME#</a></li>
                </cfif>
 
            </td>

            <td>#it.PRODUCT_CAT#</td>
            <td>#it.MANUFACT_CODE#</td>
            <td>#it.MAIN_UNIT#</td>
            <td>#it.BRAND_NAME#</td>
            <td>#tlformat(it.STOCK_COUNT)#</td>
            <td>#tlformat(it.SATILABILIR)#</td>
            <cfset PSBV=getRelatedProductspbs(it.PRODUCT_ID,attributes.price_catid)>

            <td><ul style="list-style:none;padding:0;">
                <cfloop array="#PSBV#" item="it2" index="iy">
                <li style="border-bottom: solid 1px ##858b9359;padding-bottom:3px">
                    <cfif isDefined("attributes.actType") and len(attributes.actType)>
                        <cfif attributes.actType eq 1 or attributes.actType eq 2>
                            <a onclick="setRow(#it2.PRODUCT_ID#,#it2.STOCK_ID#,'#it2.PRODUCT_NAME#',#attributes.question_id#,'#it2.BARCOD#','#it2.MAIN_UNIT#',#it2.PRICE#,1,#it2.DISCOUNT_RATE#)">#it2.PRODUCT_NAME#</a>
                        </cfif>
                        <cfif attributes.actType eq 3>
                            <a onclick="addCol(#it2.PRODUCT_ID#)">#it2.PRODUCT_NAME#</a>
                        </cfif>
                    <cfelse>
                        <a onclick="AddRow(#it2.PRODUCT_ID#,#it2.STOCK_ID#,'#it2.STOCK_CODE#','#it2.BRAND_NAME#',0,#attributes.miktar#,#it2.PRICE#,'#it2.PRODUCT_NAME#',#it2.TAX#,#it2.DISCOUNT_RATE#,0,'','#it2.MONEY#',#it2.PRICE#,-6,#it2.IS_MANUEL#,#it2.LAST_COST#,'#it2.MAIN_UNIT#')">#it2.PRODUCT_NAME#</a></li>
                    </cfif>
        
            </cfloop>
        </ul>
        </td>
        <td><a href="javascript://" onclick="openPriceList(0,#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.TAX#','#it.LAST_COST#','#it.IS_MANUEL#','#it.PRODUCT_NAME#','#it.STOCK_CODE#','#it.BRAND_NAME#','#it.DISCOUNT_RATE#','','','','','#it.MAIN_UNIT#','#TLFormat(it.PRICE,4)#','#it.MONEY#',0,'','',0,0,0);">
            <i class="fa fa-money" title="Ürün Fiyat Bilgisi"></i>
        </a></td>
        <td>
            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#it.product_id#&sid=#it.stock_id#')">
                <i class="icon-detail" title="Ürün Detay Bilgisi"></i>
            </a>
        </td>
        <td>
            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_stocks&pid=#it.product_id#&sid=#it.stock_id#');">
                <i class="fa fa-cubes" title="Stoklar"></i>
            </a>
        </td>
        <td>
            <a href="javascript://" onclick="openPriceListPartner(#it.PRODUCT_ID#,#it.STOCK_ID#,'#it.MAIN_UNIT#',#attributes.company_id#)">
                <i class="fa fa-map-marker" title="FiyatDetay"></i>
                <!----objects.popup_product_price_history_js
                    &sepet_process_type=-1&product_id=16536&stock_id=16536&pid=16536&product_name=&unit=LT&row_id=0&company_id=493&TL=1&USD=18.6602&EUR=19.8706&JPY=0.138377&CHF=20.1598&GBP=23.1367---->
            </a>
        </td>
        </tr>
    </cfloop>

<tfoot>
    <tr>
        <td colspan="13">
            #attributes.start_row# -#attributes.end_row# / #P_RETURN.PRODUCTS[1].QUERY_COUNT# 
            <button class="btn btn-primary" type="button" onclick="beforePage(#attributes.sayfa-1#)" <cfif attributes.sayfa eq 0>disabled</cfif>>&lt;</button>
            <button class="btn btn-primary" type="button" <cfif P_RETURN.PRODUCTS[1].QUERY_COUNT lte attributes.end_row>disabled</cfif>  onclick="nextPage(#attributes.sayfa+1#)">&gt;</button>
        </td>
    </tr>
</tfoot>
</cfif>
</cfoutput>
</cf_big_list>

<!---
AddRow(
    product_id,
    stock_id,
    stock_code,
    brand_name,
    is_virtual,
    quantity,
    price,
    product_name,
    tax,
    discount_rate,
    poduct_type = 0,
    shelf_code = '',
    other_money = 'TL',
    price_other,
    currency = "-6",
    is_manuel = 0,
    cost = 0)

    PRODUCT_ID=PRODUCT_ID,
    STOCK_ID=STOCK_ID,
    PRODUCT_CATID=PRODUCT_CATID,
    PRODUCT_CAT=PRODUCT_CAT,
    PRODUCT_CODE_2=PRODUCT_CODE_2,
    MANUFACT_CODE=MANUFACT_CODE,
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
    MONEY=MONEY,
    ROWNUM=ROWNUM,
    QUERY_COUNT=QUERY_COUNT
--->

<cffunction name="getProducts" >
    <cfargument name="keyword">
    <cfargument name="userid">
    <cfargument name="dsn2">
    <cfargument name="dsn1">
    <cfargument name="dsn3">
    <cfargument name="price_catid">
    <cfargument name="comp_id">
    <cfargument name="startrow" default="1">
    <cfargument name="maxrows" default="10">
    <cfargument name="get_company" default="">
    <cfargument name="product_hierarchy" default="">
    <cfargument name="brand_id" default="">

    <cfquery name="DelTempTable" datasource="#arguments.dsn1#">
        IF EXISTS(SELECT * FROM sys.tables where name = 'TempProductList_#arguments.userid#')
        BEGIN
            DROP TABLE #dsn#.TempProductList_#arguments.userid#
        END    
    </cfquery>
    <cfset argkv=arguments.keyword>
   <!--- <cfset arguments.keyword = Replace(arguments.keyword,' ',';','all')>----><!--- % idi ; yaptik --->
             <cfsavecontent  variable="control5">
                <cfdump  var="#argkv#">   
                <br>
                <cfdump  var="#arguments.keyword#">         
                <br>
                <cfdump  var="#listLast(arguments.keyword,";")#">                
               </cfsavecontent>
               <cffile action="write" file = "c:\PBS\listajaxproduct.html" output="#control5#"></cffile>
    <cfquery name="get_productsss" datasource="#arguments.dsn1#" result="getproducts_result">
        SELECT
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE,
            PRODUCT.PRODUCT_NAME,
            PRODUCT.IS_PRODUCTION,
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
            (
                
                select sum(STOCK_IN-STOCK_OUT) AS KOMPLE from #DSN2#.STOCKS_ROW where STOCK_ID=STOCKS.STOCK_ID AND 
(STORE=44 OR (STORE=45 AND STORE_LOCATION=2))
                ) AS AMOUNT,
                #DSN2#.GET_SATILABILIR_STOCK(STOCKS.STOCK_ID) AS SATILABILIR,
            PRODUCT_UNIT.ADD_UNIT,
            PRODUCT_UNIT.UNIT_ID,
            PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_UNIT.MULTIPLIER,
            PRODUCT_BRANDS.BRAND_NAME
        INTO
            #dsn#.TempProductList_#arguments.userid# 
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
                    AND P.PRICE_CATID = #arguments.price_catid#
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
            <cfif Len(arguments.keyword)>
                AND
                (
                    <cfloop list="#arguments.keyword#" index="kw" delimiters=";">
                        (
                        <cfif Len(kw) lt 2>
                            PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                            STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                           PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT_BRANDS.BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT_CAT.PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#kw#%"> COLLATE Turkish_CI_AS
                        <cfelse>
                            PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                            STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                             PRODUCT.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT_BRANDS.BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS OR
                            PRODUCT_CAT.PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#kw#%"> COLLATE Turkish_CI_AS
                        </cfif>
                        )
                        <cfif ListLast(arguments.keyword,';') neq kw>AND</cfif>
                    </cfloop>
                )
            </cfif>
            <cfif Len(arguments.get_company)>
                AND PRODUCT.COMPANY_ID = #attributes.get_company#
            </cfif>
            <cfif Len(arguments.product_hierarchy)>
                AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.product_hierarchy#%">
            </cfif>
            <cfif Len(arguments.brand_id)>
                AND PRODUCT_BRANDS.BRAND_ID	= #attributes.brand_id#
            </cfif>
    
    </cfquery>

         <cfsavecontent  variable="control5">
                <cfdump  var="#getproducts_result#">                
               </cfsavecontent>
               <cffile action="write" file = "c:\PBS\listajaxproduct2.html" output="#control5#"></cffile>
<cfquery name="get_products" datasource="#arguments.dsn1#">
  WITH CTE1 AS   (  SELECT
        *
    FROM
        #dsn#.TempProductList_#session.ep.userid#     
        ),CTE2 AS 
		(
		SELECT
				CTE1.*,
				ROW_NUMBER() OVER (ORDER BY AMOUNT DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
			FROM
				CTE1
		)
		SELECT
			CTE2.*
		FROM
			CTE2
		WHERE
			RowNum BETWEEN #arguments.startrow# and #arguments.maxrows#   
</cfquery>

<cfset returnArr=arrayNew(1)>
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
                SELECT PRODUCT_CAT,PRODUCT_CATID,HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(#PC_DETAIL#)
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
                PRODUCT_CAT=PRODUCT_CAT,
                PRODUCT_CODE_2=PRODUCT_CODE_2,
                MANUFACT_CODE=MANUFACT_CODE,
                TAX=TAX,
                BARCOD=BARCOD,
                IS_PRODUCTION=IS_PRODUCTION,
                STOCK_COUNT=AMOUNT,
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
                MONEY=MONEY,
                ROWNUM=ROWNUM,
                SATILABILIR=SATILABILIR,
                QUERY_COUNT=QUERY_COUNT
               


            };
            arrayAppend(returnArr,Product);
        </cfscript>
        
        <!----<a href="javascript://" onclick="addRow(#PRODUCT_ID#,#STOCK_ID#,'#TAX#','#lastCost#','#is_manuel#','#PRODUCT_NAME#','#STOCK_CODE#','#BRAND_NAME#','#discountRate#','','','','','#MAIN_UNIT#',
            '#TLFormat(PRICE,4)#','#MONEY#','#TLFormat(PRICE,4)#','','',0,0,0);">#PRODUCT_NAME#</a>----->
    </cfoutput>
<CFSET ReturnVal.RecordCount=1>
<CFSET ReturnVal.PRODUCTS=returnArr>
<cfelse>
    <CFSET ReturnVal.RecordCount=0>
    
</cfif>
<cfreturn ReturnVal>
</cffunction>


<cffunction name="getRelatedProductspbs">
    <cfargument name="PRODUCT_ID">
    <cfargument name="price_catid">
    <cfquery name="getRelatedProduct" datasource="#dsn1#">
        SELECT DISTINCT              
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE,
            PRODUCT.PRODUCT_NAME,
            PRODUCT.PRODUCT_CODE_2,
            PRODUCT.IS_PRODUCTION,
            PRODUCT_CAT.PRODUCT_CAT,
            PRODUCT_CAT.HIERARCHY,
            PRODUCT_CAT.DETAIL AS PC_DETAIL,
            PRODUCT_CAT.PRODUCT_CATID,
            PRODUCT.MANUFACT_CODE,
            ISNULL(GPA.PRICE,0) AS PRICE,
            PRICE_STANDART.MONEY,
            PRODUCT.TAX,
            (SELECT SUM(STOCK_IN-STOCK_OUT) FROM #dsn2#.STOCKS_ROW WHERE PRODUCT_ID = PRODUCT.PRODUCT_ID) AS AMOUNT,
            PRODUCT_UNIT.ADD_UNIT,
            PRODUCT_UNIT.UNIT_ID,
            PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_UNIT.MULTIPLIER,
            PRODUCT_BRANDS.BRAND_NAME
        FROM
            #dsn3_alias#.RELATED_PRODUCT
            LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID =
            (
                CASE
                    WHEN
                        RELATED_PRODUCT.PRODUCT_ID = #arguments.PRODUCT_ID#
                    THEN
                        RELATED_PRODUCT.RELATED_PRODUCT_ID
                    ELSE
                        RELATED_PRODUCT.PRODUCT_ID
                END
            )
            LEFT JOIN STOCKS ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN PRODUCT_OUR_COMPANY ON PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN #dsn3_alias#.PRODUCT_UNIT ON PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
            LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
            LEFT JOIN #dsn3_alias#.PRODUCT_BRANDS ON PRODUCT_BRANDS.BRAND_ID	= PRODUCT.BRAND_ID
            LEFT JOIN #dsn3_alias#.PRODUCT_CAT ON PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID
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
                    #dsn3_alias#.PRICE P,
                    #dsn3_alias#.PRODUCT PR
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
            AND (
                RELATED_PRODUCT.PRODUCT_ID = #arguments.PRODUCT_ID# OR
                RELATED_PRODUCT.RELATED_PRODUCT_ID = #arguments.PRODUCT_ID#
            )
    </cfquery>
    <cfset returnArr=arrayNew(1)>
    
    <cfloop query="getRelatedProduct">
        <cfset lastCost2 = 0>
        <cfquery name="getLastCost" datasource="#dsn2#">
            SELECT TOP 1
                IR.PRICE-(IR.DISCOUNTTOTAL/2) AS PRICE
            FROM
                INVOICE I
                LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
            WHERE
                ISNULL(I.PURCHASE_SALES,0) = 0 AND
                IR.PRODUCT_ID = #getRelatedProduct.PRODUCT_ID#
                AND I.PROCESS_CAT<>35
            ORDER BY
                I.INVOICE_DATE DESC
        </cfquery>
        <cfif getLastCost.RecordCount AND Len(getLastCost.PRICE)>
            <cfset lastCost2 = getLastCost.PRICE>
        </cfif>
        <cfset discountRate2 = 0>
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
                P.PRODUCT_ID = #getRelatedProduct.PRODUCT_ID# AND
                ISNULL(PC.IS_SALES,0) = 1 AND
                PCE.ACT_TYPE NOT IN (2,4) AND 
                PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
            ORDER BY
                PCE.PRODUCT_ID DESC,
                PCE.PRODUCT_CATID DESC,
                PCE.BRAND_ID DESC
        </cfquery>
        <cfif getDiscount.RecordCount AND Len(getDiscount.DISCOUNT_RATE)>
            <cfset discountRate2 = getDiscount.DISCOUNT_RATE>
        </cfif>
        <cfset is_manuel2 = 0>
        <cfquery name="getManuel" datasource="#dsn3#">
            SELECT TOP 1
                PROPERTY1
            FROM
                PRODUCT_INFO_PLUS
            WHERE
                PRODUCT_INFO_PLUS.PRODUCT_ID = #getRelatedProduct.PRODUCT_ID#
            ORDER BY
                PROPERTY1 DESC
        </cfquery>
        <cfif getManuel.RecordCount AND getManuel.PROPERTY1 eq 'MANUEL'>
            <cfset is_manuel2 = 1>
        </cfif>
        <cfset REL_CATID="" >
        <cfset REL_CATNAME="" >
        <cfset REL_HIERARCHY="" >
        <cfif len(PC_DETAIL)>
            <cfquery name="getRelProductCat" datasource="#dsn1#">
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
                PRODUCT_CAT=PRODUCT_CAT,
                PRODUCT_CODE_2=PRODUCT_CODE_2,
                MANUFACT_CODE=MANUFACT_CODE,
                IS_PRODUCTION=IS_PRODUCTION,
                TAX=TAX,
                LAST_COST=lastCost2,
                IS_MANUEL=is_manuel2,
                PRODUCT_NAME=PRODUCT_NAME,
                STOCK_CODE=STOCK_CODE,
                BRAND_NAME=BRAND_NAME,
                DISCOUNT_RATE=discountRate2,
                MAIN_UNIT=MAIN_UNIT,
                PRICE=PRICE,
                HIERARCHY=HIERARCHY,
                REL_CATID=REL_CATID,
                REL_CATNAME=REL_CATNAME,
                REL_HIERARCHY=REL_HIERARCHY,
                MONEY=MONEY,
                ROWNUM=1,
                QUERY_COUNT=getRelatedProduct.recordcount


            };
            arrayAppend(returnArr,Product);
        </cfscript>
    </cfloop>
    <CFSET ReturnVal.RecordCount=1>
<CFSET ReturnVal.REL_PRODUCTS=returnArr>
<cfreturn ReturnVal.REL_PRODUCTS>
</cffunction>