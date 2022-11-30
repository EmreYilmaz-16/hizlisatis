
<cfcomponent>
    <cffunction name="getProduct" access="remote" returntype="any" returnFormat="json">
        <cfargument name="keyword">
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
            ----pbppss
        </cfquery>
        <cfset arguments.keyword = Replace(arguments.keyword,' ',';','all')><!--- % idi ; yaptik --->
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
                AND PRODUCT.BARCOD='#arguments.keyword#'
        
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
        
    </cfif>
    <cfreturn Replace(SerializeJSON(ReturnVal),'//','')>
    </cffunction>

    <cffunction name="saveVirtualTube" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="0">
        <cftry>
        <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
            INSERT INTO VIRTUAL_PRODUCTS_PRT(PRODUCT_NAME,PRODUCT_CATID,PRICE,IS_CONVERT_REAL,MARJ,PRODUCT_TYPE,IS_PRODUCTION) VALUES('#arguments.product_name#',0,#Filternum(arguments.maliyet)#,0,#Filternum(arguments.marj)#,1,#arguments.IsProduction#)
        </cfquery>
        <cfif isDefined("arguments.LRekor_PId") and len(arguments.LRekor_PId)>
        <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.LRekor_PId#,#arguments.LRekor_SId#,#Filternum(arguments.LRekor_Qty)#,1)
        </cfquery>
        </cfif>
        <cfif isDefined("arguments.Tube_PId") and len(arguments.Tube_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.Tube_PId#,#arguments.Tube_SId#,#Filternum(arguments.Tube_Qty)#,2)
        </cfquery>
        </cfif>
        <cfif isDefined("arguments.RRekor_PId") and len(arguments.RRekor_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.RRekor_PId#,#arguments.RRekor_SId#,#Filternum(arguments.RRekor_Qty)#,3)
        </cfquery>  
        </cfif>
        <cfif isDefined("arguments.AdditionalProduct_PId") and len(arguments.AdditionalProduct_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.AdditionalProduct_PId#,#arguments.AdditionalProduct_SId#,#Filternum(arguments.AdditionalProduct_Qty)#,4)
        </cfquery> 
        </cfif>
        <cfif isDefined("arguments.Kabuk_PId") and len(arguments.Kabuk_PId)>
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
               INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.Kabuk_PId#,#arguments.Kabuk_SId#,#Filternum(arguments.Kabukr_Qty)#,5)
           </cfquery> 
        </cfif> 
        <cfif isDefined("arguments.working_PId") and len(arguments.working_PId)>
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
               INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#Res.IDENTITYCOL#,#arguments.working_PId#,#arguments.working_SId#,#Filternum(arguments.working_Qty)#,6)
           </cfquery> 
        </cfif>            
        <cfcatch>
            <cfsavecontent  variable="control5">
                <cfdump  var="#CGI#">                
                <cfdump  var="#arguments#">
                <cfdump  var="#cfcatch#">
               </cfsavecontent>
               <cffile action="write" file = "c:\cfcatch2223.html" output="#control5#"></cffile>
            </cfcatch>
        </cftry>
        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">
            
            <cfdump  var="#arguments#">
            
           </cfsavecontent>
           <cffile action="write" file = "c:\cfcatch22234.html" output="#control5#"></cffile>
           <CFSET RETURN_VAL.PID=Res.IDENTITYCOL>
           <CFSET RETURN_VAL.IS_VIRTUAL=1>
           <CFSET RETURN_VAL.PRICE=arguments.maliyet>
           <CFSET RETURN_VAL.QTY=1>
           <CFSET RETURN_VAL.NAME=arguments.product_name>
           <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>
    </cffunction>
    
    <cffunction name="UpdVirtualTube" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="0">
        
        <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
            UPDATE VIRTUAL_PRODUCTS_PRT 
            SET 
                PRODUCT_NAME='#arguments.PRODUCT_NAME#',
                PRICE=#Filternum(arguments.maliyet)#,
                MARJ=#Filternum(arguments.marj)#,
                PRODUCT_TYPE=1,
                IS_PRODUCTION=1 
            WHERE VIRTUAL_PRODUCT_ID=#arguments.vp_id#
        </cfquery>

        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">            
            <cfdump  var="#arguments#">  
            <cfdump  var="#Res#">            
           </cfsavecontent>
           <cffile action="write" file = "c:\updateVirtualTube.html" output="#control5#"></cffile>
       <cfquery name="delTree" datasource="#arguments.dsn3#">
            DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.vp_id#

       </cfquery>
        <cftry>
 
        <cfif isDefined("arguments.LRekor_PId") and len(arguments.LRekor_PId)>
        <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.LRekor_PId#,#arguments.LRekor_SId#,#Filternum(arguments.LRekor_Qty)#,1)
        </cfquery>
        </cfif>
        <cfif isDefined("arguments.Tube_PId") and len(arguments.Tube_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.Tube_PId#,#arguments.Tube_SId#,#Filternum(arguments.Tube_Qty)#,2)
        </cfquery>
        </cfif>
        <cfif isDefined("arguments.RRekor_PId") and len(arguments.RRekor_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.RRekor_PId#,#arguments.RRekor_SId#,#Filternum(arguments.RRekor_Qty)#,3)
        </cfquery>  
        </cfif>
        <cfif isDefined("arguments.AdditionalProduct_PId") and len(arguments.AdditionalProduct_PId)>
         <cfquery name="InsertTree" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.AdditionalProduct_PId#,#arguments.AdditionalProduct_SId#,#Filternum(arguments.AdditionalProduct_Qty)#,4)
        </cfquery> 
        </cfif>
        <cfif isDefined("arguments.Kabuk_PId") and len(arguments.Kabuk_PId)>
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
               INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.Kabuk_PId#,#arguments.Kabuk_SId#,#Filternum(arguments.Kabukr_Qty)#,5)
           </cfquery> 
        </cfif> 
        <cfif isDefined("arguments.working_PId") and len(arguments.working_PId)>
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
               INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID) VALUES(#arguments.vp_id#,#arguments.working_PId#,#arguments.working_SId#,#Filternum(arguments.working_Qty)#,6)
           </cfquery> 
        </cfif>            
        <cfcatch>
            <cfsavecontent  variable="control5">
                <cfdump  var="#CGI#">                
                <cfdump  var="#arguments#">
                <cfdump  var="#cfcatch#">
               </cfsavecontent>
               <cffile action="write" file = "c:\cfcatch2223.html" output="#control5#"></cffile>
            </cfcatch>
        </cftry>
        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">
            
            <cfdump  var="#arguments#">
            
           </cfsavecontent>
           <cffile action="write" file = "c:\cfcatch22234.html" output="#control5#"></cffile>
           <CFSET RETURN_VAL.PID=arguments.vp_id>
           <CFSET RETURN_VAL.IS_VIRTUAL=1>
           <CFSET RETURN_VAL.PRICE=arguments.maliyet>
           <CFSET RETURN_VAL.QTY=1>
           <CFSET RETURN_VAL.ROW_ID=arguments.row_id>
           <CFSET RETURN_VAL.NAME=arguments.product_name>
           <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>
    </cffunction>


    <cffunction name="filterNum" returntype="string" output="false" hint="filternum">
        <!--- 
        by Ozden Ozturk 20070316
        notes :
            float veya integer alanların temizliği için kullanılır, js filterNum fonksiyonuyla aynı işlevi gorur
        parameters :
            1) str:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
        usage : 
            filternum('124587,787',4)
            veya
            filternum(attributes.money,4)
         --->
        <cfargument name="str" required="yes">
        <cfargument name="no_of_decimal" required="no" default="2">	
        <cfscript>
        
        if((isdefined("moneyformat_style") and moneyformat_style eq 0) or (not isdefined("moneyformat_style")) or not isdefined("session.ep"))
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;,';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(newStr,',','.','all');
            newStr = replace(newStr,',',' ','all');
        }
        else
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(str,',','','all');
        }
        </cfscript>
        <cfreturn wrk_round(newStr,no_of_decimal)>
    </cffunction>
    <cffunction name="wrk_round" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>
</cfcomponent>
