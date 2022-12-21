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
                LAST_COST=lastCost,
                IS_MANUEL=is_manuel,
                PRODUCT_NAME=PRODUCT_NAME,
                STOCK_CODE=STOCK_CODE,
                BARCOD=BARCOD,
                BRAND_NAME=BRAND_NAME,
                DISCOUNT_RATE=discountRate,
                MAIN_UNIT=MAIN_UNIT,
                PRICE=PRICE


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
            PRODUCT_NAME='',
            STOCK_CODE='',
            BARCOD='',
            BRAND_NAME='',
            DISCOUNT_RATE=0,
            MAIN_UNIT='',
            PRICE=0


        };
    </cfscript>
</cfif>
<CFSET ReturnVal.PRODUCT=Product>
<cfreturn ReturnVal>
</cffunction>

<cfparam name="attributes.price_catid" default="0">
<cfparam name="attributes.comp_id" default="0">
<cf_box title="Make Tube" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfform name="TubeForm">

    <cfquery name="getVirtual" datasource="#dsn3#">
        select * from VIRTUAL_PRODUCTS_PRT WHERE  VIRTUAL_PRODUCT_ID=#attributes.id#
    </cfquery>
    <cfquery name="getVirtualTree" datasource="#dsn3#">
        SELECT VPT.*,S.PRODUCT_NAME,S.BARCOD FROM #dsn3#.VIRTUAL_PRODUCT_TREE_PRT VPT LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=VPT.STOCK_ID 
        WHERE  VP_ID=#attributes.id#
ORDER BY VP_ID  
    </cfquery>

    <!----------
1	SOL REKOR
2	HORTUM
3	SAĞ REKOR
4	EK İŞLEM
5	KABUK
6	IŞÇİLİK

 <cfargument name="PRODUCT_ID">
    <cfargument name="userid">
    <cfargument name="dsn2">
    <cfargument name="dsn1">
    <cfargument name="dsn3">
    <cfargument name="price_catid">
    <cfargument name="comp_id">
---------->
 
    
    <cfoutput><div class="form-group"><h3> Ürün : <input type="text" name="product_name" value="#getVirtual.PRODUCT_NAME#"></h3></div></cfoutput>

    <cfoutput>
    <div class="form-group">
        <label>Uretim</label>
        <input type="checkbox" name="IsProduction" checked value="1">
    </div>
    <div class="form-group">
        <label>Hortum Grubu</label>
        <input type="text" name="PRODUCT_CAT" id="PRODUCT_CAT" readonly value="">
        <input type="hidden" name="PRODUCT_CATID" id="PRODUCT_CATID" value="">
        <input type="hidden" name="HIEARCHY" id="HIEARCHY" value="">
    </div>
        
    <input type="hidden" name="vp_id" value="#attributes.id#">
    <input type="hidden" name="row_id" value="#attributes.row_id#">
  <!----
    Taslak 

         <tr>
            <th>Sağ Rekor</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td></td>
            <td><div class="form-group"></div></td>
            <td><div class="form-group"></div></td>
        </tr>    
    ------>
    <cfquery name="get1" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=1</cfquery>
    <CFSET PRODUCT=getProduct(get1.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
    <cfquery name="get2" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=2</cfquery>
    <CFSET PRODUCT2=getProduct(get2.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
    <cfquery name="get3" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=3</cfquery>
    <CFSET PRODUCT3=getProduct(get3.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
    <cfquery name="get5" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=5</cfquery> 
    <CFSET PRODUCT5=getProduct(get5.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
    <cfquery name="get4" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=4</cfquery>
    <CFSET PRODUCT4=getProduct(get4.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>
    <cfquery name="get6" dbtype="query">SELECT * FROM getVirtualTree WHERE QUESTION_ID=6</cfquery>
    <CFSET PRODUCT6=getProduct(get6.PRODUCT_ID,session.ep.userid,dsn2,dsn1,dsn3,attributes.price_catid,attributes.comp_id)>

    <table class="table">
        <tr>
            <th>Sol Rekor</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td>    
                <div class="form-group">
                    <input data-type="LRekor" type="text" name="LRekor" id="LRekor" value="#PRODUCT.PRODUCT.PRODUCT_NAME#" onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">                                        
                    <input type="hidden" name="LRekor_PId" id="LRekor_PId" value="#PRODUCT.PRODUCT.PRODUCT_ID#">
                    <input type="hidden" name="LRekor_SId" id="LRekor_SId" value="#PRODUCT.PRODUCT.STOCK_ID#">           
                    <input type="hidden" name="LRekor_Prc" id="LRekor_Prc" value="<cfif len(get1.PRICE)>#get1.PRICE#<cfelse>0</cfif>">                    
                    <input type="hidden" name="LRekor_MNY" id="LRekor_MNY" value="<cfif len(get1.MONEY)>#get1.MONEY#<cfelse>TL</cfif>">
                    <input type="hidden" name="LRekor_TTL" id="LRekor_TTL" value="">
                    <label style="width: 100%;font-size:6pt;color:red" id="LRekor_lbs">#PRODUCT.PRODUCT.PRODUCT_NAME#</label>
           
           </div></td>
            <td><div class="form-group"><input type="text" name="LRekor_Qty" id="LRekor_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get1.recordCount eq 0 and len(get1.AMOUNT) eq 0), 1, get1.AMOUNT))#" onchange="this.value=commaSplit(this.value);CalculateTube()">               </div></td>
            <td><div class="form-group"><input type="text" name="LRekor_DSC" id="LRekor_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()" value="<cfif len(get1.DISCOUNT)>#tlformat(get1.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr>
        <tr>
            <th>Hortum</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td><div class="form-group">            
                <input data-type="Tube" type="text" name="Tube" id="Tube" value="#PRODUCT2.PRODUCT.PRODUCT_NAME#"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">               
                <input type="hidden" name="Tube_PId" id="Tube_PId" value="#PRODUCT2.PRODUCT.PRODUCT_ID#">
                <input type="hidden" name="Tube_SId" id="Tube_SId" value="#PRODUCT2.PRODUCT.STOCK_ID#">                
                <input type="hidden" name="Tube_Prc" id="Tube_Prc" value="<cfif len(get2.PRICE)>#get2.PRICE#<cfelse>0</cfif>">                
                <input type="hidden" name="Tube_MNY" id="Tube_MNY" value="<cfif len(get2.MONEY)>#get2.MONEY#<cfelse>TL</cfif>">
                <input type="hidden" name="Tube_TTL" id="Tube_TTL" value="">
                <label style="width: 100%;font-size:6pt;color:red" id="Tube_lbs">#PRODUCT2.PRODUCT.PRODUCT_NAME#</label>
            </div></td>
            <td><div class="form-group"> <input type="text" name="Tube_Qty" id="Tube_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get2.recordCount eq 0 and len(get2.AMOUNT) eq 0), 1, get2.AMOUNT))#" onchange="this.value=commaSplit(this.value);CalculateTube()"></div></td>
            <td><div class="form-group"><input type="text" name="Tube_DSC" id="Tube_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()"  value="<cfif len(get2.DISCOUNT)>#tlformat(get2.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr>   
        <tr>
            <th>Sağ Rekor</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td>
                <div class="form-group">                    
                    <input  data-type="RRekor" type="text" name="RRekor" id="RRekor" value="#PRODUCT3.PRODUCT.PRODUCT_NAME#"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">                   
                    <input type="hidden" name="RRekor_PId" id="RRekor_PId" value="#PRODUCT3.PRODUCT.PRODUCT_ID#">
                    <input type="hidden" name="RRekor_SId" id="RRekor_SId" value="#PRODUCT3.PRODUCT.STOCK_ID#">                    
                    <input type="hidden" name="RRekor_Prc" id="RRekor_Prc" value="<cfif len(get3.PRICE)>#get3.PRICE#<cfelse>0</cfif>">                    
                    <input type="hidden" name="RRekor_MNY" id="RRekor_MNY" value="<cfif len(get3.MONEY)>#get3.MONEY#<cfelse>TL</cfif>">
                    <input type="hidden" name="RRekor_TTL" id="RRekor_TTL" value="">                
                    <label style="width: 100%;font-size:6pt;color:red" id="RRekor_lbs">#PRODUCT3.PRODUCT.PRODUCT_NAME#</label>
                </div>
            </td>
            <td><div class="form-group"> <input type="text" name="RRekor_Qty" id="RRekor_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get3.recordCount eq 0 and len(get3.AMOUNT) eq 0), 1, get3.AMOUNT))#" onchange="this.value=commaSplit(this.value);CalculateTube()"></div></td>
            <td><div class="form-group"><input type="text" name="RRekor_DSC" id="RRekor_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()" value="<cfif len(get3.DISCOUNT)>#tlformat(get3.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr> 
        <tr>
            <th>Kabuk</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td><div class="form-group">
                <input  data-type="Kabuk" type="text" name="Kabuk" id="Kabuk" value="#PRODUCT5.PRODUCT.BARCOD#"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">               
                <input type="hidden" name="Kabuk_PId" id="Kabuk_PId" value="#PRODUCT5.PRODUCT.PRODUCT_ID#">
                <input type="hidden" name="Kabuk_SId" id="Kabuk_SId" value="#PRODUCT5.PRODUCT.STOCK_ID#">                
                <input type="hidden" name="Kabuk_Prc" id="Kabuk_Prc" value="<cfif len(get5.PRICE)>#get5.PRICE#<cfelse>0</cfif>">
                <input type="hidden" name="Kabuk_MNY" id="Kabuk_MNY" value="<cfif len(get5.MONEY)>#get5.MONEY#<cfelse>TL</cfif>">
                <input type="hidden" name="Kabuk_TTL" id="Kabuk_TTL" value="">            
                <label style="width: 100%;font-size:6pt;color:red" id="Kabuk_lbs">#PRODUCT5.PRODUCT.PRODUCT_NAME#</label>
            </div></td>
            <td><div class="form-group"> <input type="text" name="Kabukr_Qty" id="Kabuk_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get5.recordCount eq 0 and len(get5.AMOUNT) eq 0), 1, get5.AMOUNT))#"  onchange="this.value=commaSplit(this.value);CalculateTube()"></div></td>
            <td><div class="form-group"><input type="text" name="Kabuk_DSC" id="Kabuk_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()" value="<cfif len(get5.DISCOUNT)>#tlformat(get5.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr>      
        <tr>
            <th>Ek Malzeme</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td><div class="form-group">

            
                <label style="width: 100%;">Ek Malzeme</label>
                <input data-type="AdditionalProduct" type="text" name="AdditionalProduct" id="AdditionalProduct" value="#PRODUCT4.PRODUCT.BARCOD#"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">               
                <input type="hidden" name="AdditionalProduct_PId" id="AdditionalProduct_PId" value="#PRODUCT4.PRODUCT.PRODUCT_ID#">
                <input type="hidden" name="AdditionalProduct_SId" id="AdditionalProduct_SId" value="#PRODUCT4.PRODUCT.STOCK_ID#">                
                <input type="hidden" name="AdditionalProduct_Prc" id="AdditionalProduct_Prc" value="<cfif len(get4.PRICE)>#get4.PRICE#<cfelse>0</cfif>">                
                <input type="hidden" name="AdditionalProduct_MNY" id="AdditionalProduct_MNY" value="<cfif len(get4.MONEY)>#get4.MONEY#<cfelse>TL</cfif>">
                <input type="hidden" name="AdditionalProduct_TTL" id="AdditionalProduct_TTL" value="">
                <label style="width: 100%;font-size:6pt;color:red" id="AdditionalProduct_lbs">#PRODUCT4.PRODUCT.PRODUCT_NAME#</label>
            </div></td>
            <td><div class="form-group"> <input type="text" name="AdditionalProduct_Qty" id="AdditionalProduct_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get4.recordCount eq 0 and len(get4.AMOUNT) eq 0), 1, get4.AMOUNT))#"  onchange="this.value=commaSplit(this.value);CalculateTube()"></div></td>
            <td><div class="form-group"><input type="text" name="AdditionalProduct_DSC" id="AdditionalProduct_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()" value="<cfif len(get4.DISCOUNT)>#tlformat(get4.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr> 
        <tr>
            <th>İşçilik</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td><div class="form-group">   
                <input  data-type="working" type="text" name="working" id="working" value="#PRODUCT6.PRODUCT.BARCOD#"  onkeydown="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)"  placeholder="Keyword" onchange="FindProduct(event,this,#session.ep.userid#,'#dsn2#','#dsn1#','#dsn3#',#attributes.price_catid#,#attributes.comp_id#)">
                
                <input type="hidden" name="working_PId" id="working_PId" value="#PRODUCT6.PRODUCT.PRODUCT_ID#">
                <input type="hidden" name="working_SId" id="working_SId" value="#PRODUCT6.PRODUCT.STOCK_ID#">
               
                <input type="hidden" name="working_Prc" id="working_Prc" value="<cfif len(get6.PRICE)>#get6.PRICE#<cfelse>0</cfif>">
                <input type="hidden" name="working_DSC" id="working_DSC" value="<cfif len(get6.DISCOUNT)>#get6.DISCOUNT#<cfelse>0</cfif>">
                <input type="hidden" name="working_MNY" id="working_MNY" value="<cfif len(get6.MONEY)>#get6.MONEY#<cfelse>TL</cfif>">
                <input type="hidden" name="working_TTL" id="working_TTL" value="">
                <label style="width: 100%;font-size:6pt;color:red" id="working_lbs">#PRODUCT6.PRODUCT.PRODUCT_NAME#</label>
            </div></td>
            <td><div class="form-group"><input type="text" name="working_Qty" id="working_Qty" style="padding-right: 1px;text-align:right" value="#tlformat(IIf((get6.recordCount eq 0 and len(get6.AMOUNT) eq 0), 1, get6.AMOUNT))#"  onchange="this.value=commaSplit(this.value);CalculateTube()"></div></td>
            <td><div class="form-group"><input type="text" name="AdditionalProduct_DSC" id="AdditionalProduct_DSC" onchange="this.value=commaSplit(this.value);CalculateTube()" value="<cfif len(get6.DISCOUNT)>#tlformat(get6.DISCOUNT)#<cfelse>#tlformat(0)#</cfif>"></div></td>
        </tr>                                         
    </table>
  


 <!----
    Taslak 

         <tr>
            <th>Sağ Rekor</th>
            <th>Miktar</th>
            <th >İndirim</th>
        </tr>
        <tr>
            <td></td>
            <td><div class="form-group"></div></td>
            <td><div class="form-group"></div></td>
        </tr>    
    ------>







<div class="form-group">
    <label>Açıklama</label>
    <textarea name="PRODUCT_DESCRIPTION" id="PRODUCT_DESCRIPTION">#getVirtual.PRODUCT_DESCRIPTION#</textarea>
</div>
<hr>

<table>
    <tr>
        <td>
            <div class="form-group" id="f1" title="Maliyet">
                <label>Marj %</label>
                <input data-type="maliyet" type="text" name="marj" id="marj"  style="padding-right: 1px;text-align:right" value="#tlformat(0)#" onkeyup="CalculateTube()">    
            </div>
        </td>
        <td>
            <div class="form-group" id="f1" title="Maliyet">
                <label>Hesaplan Maliyet</label>
                <input data-type="maliyet" type="text" name="maliyet" id="maliyet"  style="padding-right: 1px;text-align:right" value="#tlformat(0)#" readonly>    
            </div>
        </td>
    </tr>
</table>
<br>
<div style="display:flex;justify-content: space-around;align-items: center;align-content: space-between;flex-wrap: nowrap;">
<button type="button" onclick="UpdVirtualTube('#dsn3#','#attributes.modal_id#')" class="btn btn-primary">Update Virtual Tube</button>
<button type="button" class="btn btn-success" onclick="SaveTube('#dsn3#','#attributes.modal_id#',1)">Save  Tube</button>
<button type="button" onclick="closeBoxDraggable('#attributes.modal_id#')" class="btn btn-danger">Kapat</button>
</div>
</cfoutput>
</cfform>
</cf_box>

<script>
    CalculateTube()
</script>

