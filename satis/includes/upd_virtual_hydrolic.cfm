<cfparam name="attributes.modal_id" default="0">

<cffunction name="getProduct" access="remote" returntype="any" returnFormat="json">
    <cfargument name="PRODUCT_ID">
    <cfargument name="userid">
    <cfargument name="dsn2">
    <cfargument name="dsn1">
    <cfargument name="dsn3">
    <cfargument name="price_catid">
    <cfargument name="comp_id">
    <cfquery name="DelTempTable" datasource="#arguments.dsn1#">
        IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####TempProductList_#arguments.userid#')
        BEGIN
            DROP TABLE ####TempProductList_#arguments.userid#
        END    
    </cfquery>
    
    <cfquery name="get_products" datasource="#arguments.dsn1#">
        SELECT
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE,
            PRODUCT.PRODUCT_NAME,
            PRODUCT.PRODUCT_CODE_2,
            PRODUCT_CAT.PRODUCT_CAT,
            PRODUCT_CAT.PRODUCT_CATID,
            PRODUCT_CAT.HIERARCHY,
            PRODUCT.MANUFACT_CODE,
            PRODUCT.BARCOD,
            ISNULL(GPA.PRICE,0) AS PRICE,
            PRICE_STANDART.MONEY,
            PRODUCT.TAX,
            (SELECT SUM(STOCK_IN-STOCK_OUT) FROM #arguments.dsn2#.STOCKS_ROW WHERE PRODUCT_ID = PRODUCT.PRODUCT_ID AND STORE <> 43) AS AMOUNT,
            PRODUCT_UNIT.ADD_UNIT,
            PRODUCT_UNIT.UNIT_ID,
            PRODUCT_UNIT.MAIN_UNIT,
            PRODUCT_UNIT.MULTIPLIER,
            PRODUCT_BRANDS.BRAND_NAME
        INTO
            ####TempProductList_#arguments.userid# 
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
            AND PRODUCT.PRODUCT_ID='#arguments.PRODUCT_ID#'
    
    </cfquery>
<cfquery name="get_products" datasource="#dsn3#">
    SELECT
        *
    FROM
        ####TempProductList_#session.ep.userid#        
</cfquery>
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
        <cfset is_manuel = 0>
        <cfquery name="getManuel" datasource="#dsn3#">
            SELECT TOP 1
                PROPERTY1
            FROM
                PRODUCT_INFO_PLUS
            WHERE
                PRODUCT_INFO_PLUS.PRODUCT_ID = #PRODUCT_ID#
            ORDER BY
                PROPERTY1 DESC
        </cfquery>
        <cfif getManuel.RecordCount AND getManuel.PROPERTY1 eq 'MANUEL'>
            <cfset is_manuel = 1>
        </cfif>      
        <cfscript>
            Product={
                PRODUCT_ID=PRODUCT_ID,
                STOCK_ID=STOCK_ID,
                PRODUCT_CATID=PRODUCT_CATID,
                TAX=TAX,
                MONEY=MONEY,
                LAST_COST=lastCost,
                IS_MANUEL=is_manuel,
                PRODUCT_NAME=PRODUCT_NAME,
                STOCK_CODE=STOCK_CODE,
                BARCOD=BARCOD,
                BRAND_NAME=BRAND_NAME,
                DISCOUNT_RATE=discountRate,
                MAIN_UNIT=MAIN_UNIT,
                PRICE=PRICE,
                HIERARCHY=HIERARCHY


            };
        </cfscript>

        <!----<a href="javascript://" onclick="addRow(#PRODUCT_ID#,#STOCK_ID#,'#TAX#','#lastCost#','#is_manuel#','#PRODUCT_NAME#','#STOCK_CODE#','#BRAND_NAME#','#discountRate#','','','','','#MAIN_UNIT#',
            '#TLFormat(PRICE,4)#','#MONEY#','#TLFormat(PRICE,4)#','','',0,0,0);">#PRODUCT_NAME#</a>----->
    </cfoutput>
<CFSET ReturnVal.RecordCount=1>
<CFSET ReturnVal.PRODUCT=Product>
<cfelse>
    <CFSET ReturnVal.RecordCount=0>
    <cfscript>
        Product={
            PRODUCT_ID='0',
            STOCK_ID='0',
            PRODUCT_CATID='',
            TAX='0',
            LAST_COST=0,
            IS_MANUEL=0,
            MONEY=MONEY,
            PRODUCT_NAME='',
            STOCK_CODE='',
            BARCOD='',
            BRAND_NAME='',
            DISCOUNT_RATE=0,
            MAIN_UNIT='',
            PRICE=0,
            HIERARCHY=''


        };
    </cfscript>
</cfif>
<CFSET ReturnVal.PRODUCT=Product>
<cfreturn ReturnVal>
</cffunction>


<style>
    .prtMoneyBox{
    text-align:right !important;
    padding:0 !important;
}
</style>
<script>
var hydRowCount = 0;
</script>
<cf_box title="Make Hydrolic" scroll="1" collapsable="1" resize="1" popup_box="1">

<div class="form-group">
    <input type="text" onkeyup="findHydrolic(event,this)"  name="pp_barcode" id="pp_barcode" onkeyup="" placeholder="Barcode">
</div>
<cfquery name="getVP" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#attributes.ID#
</cfquery>

<cfquery name="getTree" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#attributes.ID#
</cfquery>

<cfform name="HydrolicForm">
    <div class="form-group" style="margin-right:10px">
        
        <label>Ürün Adı</label>
        <input type="text" name="hydProductName" id="hydProductName" value="<cfoutput>#getVP.PRODUCT_NAME#</cfoutput>" onchange=""></div>
        <div class="form-group">
            <label>Uretim</label>
            <input type="checkbox" name="IsProduction" checked value="1">
        </div>
    <cfoutput><input type="hidden" name="dsn3" value="#dsn3#"></cfoutput>
    <cfoutput><input type="hidden" name="VPID" value="#attributes.ID#"></cfoutput>
    <cfoutput><input type="hidden" name="ROWID" value="#attributes.row_id#"></cfoutput>
    <cfoutput><input type="hidden" name="QTY_MAIN" value="#attributes.row_id#"></cfoutput>
    <div style="height:40vh;overflow-y: scroll;">
        
        <cf_big_list id="tblBaskHyd">
            <tr>
                <th></th>
                <th>Ürün</th>
                <th>Miktar</th>
                <th>Fiyat</th>
                <th>İndirim</th>
                <th>Doviz</th>
                <th>Doviz T</th>
                <th>Tutar</th>
            </tr>        
        </cf_big_list>
    </div>
    <input type="hidden" name="hydRwc" id="hydRwc" value="">
    
    <div style="display:flex">
        <div class="form-group" style="margin-right:10px">
            <label>Marj</label>
            <input type="text" id="marjHyd" name="marjHyd" onchange="CalculateHydSub()" value="<cfoutput>#tlformat(0)#</cfoutput>" style="text-align:right;padding:0" >
        </div>
        <div class="form-group">
            <label>Toplam</label>
            <input type="text" id="hydSubTotal" name="hydSubTotal" style="text-align:right;padding:0" value="<cfoutput>#tlformat(0)#</cfoutput>">
        </div>
    </div>
    <button type="button" onclick="UpdateVirtualHydrolic('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-primary">Sanal Ürün Güncelle</button>
    <button type="button" class="btn btn-success">Ürün Kaydet</button>
    <button type="button" class="btn btn-danger">Kapat</button>
</cfform>
</cf_box>


<cfoutput query="getTree">
    <cfset PR=getProduct(PRODUCT_ID,session.ep.USERID,'#dsn2#','#dsn1#','#dsn3#',attributes.price_catid,attributes.comp_id)>
   
   <script>
    var Prd={
        PRODUCT:{
            LAST_COST:#PR.PRODUCT.LAST_COST#,
            MONEY:'#PR.PRODUCT.MONEY#',
            IS_MANUEL:#PR.PRODUCT.IS_MANUEL#,
            PRICE:<cfif len(PRICE)>#PRICE#<cfelse>0</cfif>,         
            DISCOUNT_RATE:<cfif len(DISCOUNT)>#DISCOUNT#<cfelse>0</cfif>,
            MONEY:<cfif len(MONEY)>'#MONEY#'<cfelse>'TL'</cfif>,         
            STOCK_ID:#PR.PRODUCT.STOCK_ID#,
            PRODUCT_ID:#PR.PRODUCT.PRODUCT_ID#,
            PRODUCT_NAME:'#PR.PRODUCT.PRODUCT_NAME#',
            PRODUCT_CATID:#PR.PRODUCT.PRODUCT_CATID#,
            STOCK_CODE:'#PR.PRODUCT.STOCK_CODE#',
            MAIN_UNIT:'#PR.PRODUCT.MAIN_UNIT#',
            BRAND_NAME:'#PR.PRODUCT.BRAND_NAME#',
            HIERARCHY:'#PR.PRODUCT.HIERARCHY#',
        },
        RECORDCOUNT:1
    }
    console.log(Prd);
    addHydrolicRow(Prd,#AMOUNT#)
   CalculatehydrolicRow(hydRowCount)
    CalculateHydSub()
    </script>

</cfoutput>

