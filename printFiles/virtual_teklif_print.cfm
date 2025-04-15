<cfquery name="qProductTree" datasource="#dsn3#">
        SELECT 
    CASE WHEN IS_VIRTUAL =1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
    CASE WHEN IS_VIRTUAL=1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
    CASE WHEN IS_VIRTUAL=1 THEN VP.PRODUCT_UNIT ELSE PU.MAIN_UNIT END AS BIRIM,
    IS_VIRTUAL,
    VPT.PRICE,
    VPT.DISCOUNT,
    VPT.MONEY,
    PB.BRAND_NAME,
    
    (SELECT TOP 1  CAST(PRICE AS DECIMAL(18,2)) AS PRICE,CAST(DISCOUNT AS DECIMAL(18,2)) AS DISCOUNT,OTHER_MONEY FROM workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE PBS_ROW_ID=VPT.PBS_ROW_ID AND IS_ACTIVE=1 FOR JSON AUTO) AS PRICEJSON,
    AMOUNT,
    1 AS SVY FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
    LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID=VPT.PRODUCT_ID
    LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID=VPT.PRODUCT_ID
    LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB 
        ON PB.BRAND_ID = 
            CASE 
                WHEN IS_VIRTUAL = 1 THEN 491
                ELSE S.BRAND_ID 
            END
    LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
    WHERE VP_ID=#getOfferRow.PRODUCT_ID#
    </cfquery>
    <CFSET EURO_TOPLAM=0>;
    <CFSET TL_TOPLAM=0>;
    <CFSET USD_TOPLAM=0>;
    <CFSET SN=0>
    <table class="table product-table" style="margin-top: 10px;">
        <tr>
            <th colspan="2">
                <span style="padding-left: 0px;">Sıra No</span>
                
            </th>
            <th>
                <span style="padding-left: 0px;">Ürün Adı</span>
            </th>
            <th>
                <span style="padding-left: 0px;">Marka</span>
            </th>
            <th colspan="2">
                <span style="padding-left: 0px;">Miktar</span>
            </th>
            <th class="FiyatAlan"  colspan="">
                <span style="padding-left: 0px;">Fiyat</span>
            </th>
            <th class="FiyatAlan" colspan="">
                <span style="padding-left: 0px;">İndirim</span>
            </th>
            <th  class="FiyatAlan" colspan="">
                <span style="padding-left: 0px;">İndirimli Fiyat</span>
            </th>
            <th class="FiyatAlan" colspan="">
                <span style="padding-left: 0px;">Tutar</span>
            </th>
            <th class="FiyatAlan" colspan="">
                <span style="padding-left: 0px;">Para Birimi</span>
            </th>
            
        </tr>
        
        <cfoutput query="qProductTree">
            <CFSET SN=SN+1>
            <cfset randomInt = RandRange(1000, 9999)>
            <tr class="tree-row" data-parent="" data-level="#SVY-1#">
                <td>#SN#</td>
                <td><span class="toggle-icon" data-toggle="#randomInt#">▶</span></td>
                <td><span style="padding-left: 0px;">#PRODUCT_NAME#</span></td>
                <td><span >#BRAND_NAME#</span></td>
                <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                <cfif len(PRICEJSON) AND isJSON(PRICEJSON)>
                <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                <cfelse>
                <CFSET INDIRIMSIZ_FIYAT=0>
                <CFSET PRICEJSON='[{"PRICE":0,"DISCOUNT":0,"OTHER_MONEY":"TL"}]'>
            </cfif>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE*AMOUNT)#</span></td>
                <td class="FiyatAlan"> <span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                <CFIF deserializeJSON(PRICEJSON)[1].OTHER_MONEY EQ 'USD'>
                    <CFSET USD_TOPLAM=USD_TOPLAM+INDIRIMSIZ_FIYAT*AMOUNT>
                <CFELSEIF deserializeJSON(PRICEJSON)[1].OTHER_MONEY EQ 'TL'>
                    <CFSET TL_TOPLAM=TL_TOPLAM+INDIRIMSIZ_FIYAT*AMOUNT>
                <CFELSE>
                    <CFSET EURO_TOPLAM=EURO_TOPLAM+INDIRIMSIZ_FIYAT*AMOUNT>
                </CFIF>
            </tr>
            <cfif IS_VIRTUAL EQ 1>
                <cfquery name="qProductTree1" datasource="#dsn3#">
                    SELECT 
                        CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                        CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                        CASE WHEN IS_VIRTUAL=1 THEN VP.PRODUCT_UNIT ELSE PU.MAIN_UNIT END AS BIRIM,
                        IS_VIRTUAL,
                        VPT.PRICE,
                        VPT.DISCOUNT,
                        VPT.MONEY,
                        AMOUNT,
                        PB.BRAND_NAME,
                        (SELECT TOP 1  CAST(PRICE AS DECIMAL(18,2)) AS PRICE,CAST(DISCOUNT AS DECIMAL(18,2)) AS DISCOUNT,OTHER_MONEY FROM workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE PBS_ROW_ID=VPT.PBS_ROW_ID AND IS_ACTIVE=1 FOR JSON AUTO) AS PRICEJSON,
                        2 AS SVY
                    FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                    LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                    LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                    LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                    LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB 
        ON PB.BRAND_ID = 
            CASE 
                WHEN IS_VIRTUAL = 1 THEN 491
                ELSE S.BRAND_ID 
            END
            
                    WHERE VP_ID = #RELATED_ID#
                </cfquery>
            <cfelse>
                <cfquery name="qProductTree1" datasource="#dsn3#">
                    SELECT 
                        S.PRODUCT_NAME,
                        RELATED_ID,
                        0 AS IS_VIRTUAL,
                        PRICE_PBS PRICE,
                        DISCOUNT_PBS DISCOUNT,
                        OTHER_MONEY_PBS MONEY,
                        AMOUNT,    
                        PB.BRAND_NAME,
                        PU.MAIN_UNIT AS BIRIM,               
                        2 AS SVY
                        ,(SELECT '0' AS PRICE,'0' AS DISCOUNT,'TL' AS OTHER_MONEY FOR JSON PATH) AS PRICEJSON
                    FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                    LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                    LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                    LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB 
                        ON PB.BRAND_ID = S.BRAND_ID
                            
                    WHERE VPT.STOCK_ID = #RELATED_ID#
                </cfquery>
            </cfif>
            <cfloop query="qProductTree1">
                <CFSET SN=SN+1>
                <tr data-parent="#randomInt#" data-level="#SVY#" class="tree-row">
                    <cfset randomInt2 = RandRange(1000, 9999)>
                    <td>#SN#</td>
                    <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#randomInt2#">▶</span></td>
                    <td><span >#PRODUCT_NAME#</span></td>
                    <td><span >#BRAND_NAME#</span></td>
                    <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                    <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                    
                    <cfif len(PRICEJSON) AND isJSON(PRICEJSON)>
                        <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                        
                        <cfelse>
                            
                        <CFSET INDIRIMSIZ_FIYAT=0>
                        <CFSET PRICEJSON='[{"PRICE":0,"DISCOUNT":0,"OTHER_MONEY":"TL"}]'>
                    </cfif>
                
                    <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                    <td class="FiyatAlan"><span style="padding-left: 0px;"><cftry>#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#<cfcatch><cfdump var="#qProductTree1#"></cfcatch></cftry></span></td>
                    <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                    <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE*AMOUNT)#</span></td>
                    <td class="FiyatAlan"><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                </tr>
                <cfif IS_VIRTUAL EQ 1>
                    <cfquery name="qProductTree2" datasource="#dsn3#">
                        SELECT 
                            CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                            CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                            CASE WHEN IS_VIRTUAL=1 THEN VP.PRODUCT_UNIT ELSE PU.MAIN_UNIT END AS BIRIM,
                            IS_VIRTUAL,
                            VPT.PRICE,
                            VPT.DISCOUNT,
                            VPT.MONEY,
                            AMOUNT,
                            PB.BRAND_NAME,
                            (SELECT TOP 1  CAST(PRICE AS DECIMAL(18,2)) AS PRICE,CAST(DISCOUNT AS DECIMAL(18,2)) AS DISCOUNT,OTHER_MONEY FROM workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE PBS_ROW_ID=VPT.PBS_ROW_ID AND IS_ACTIVE=1 FOR JSON AUTO) AS PRICEJSON,
                            3 AS SVY
                        FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                        LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                        LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                        LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB
                            ON PB.BRAND_ID = 
                                CASE 
                                    WHEN IS_VIRTUAL = 1 THEN 491
                                    ELSE S.BRAND_ID 
                                END
                        WHERE VP_ID = #RELATED_ID#
                    </cfquery>
                <cfelse>
                    <cfquery name="qProductTree2" datasource="#dsn3#">
                        SELECT 
                            S.PRODUCT_NAME,
                            RELATED_ID,
                            0 AS IS_VIRTUAL,
                            PRICE_PBS PRICE,
                        DISCOUNT_PBS DISCOUNT,
                        OTHER_MONEY_PBS MONEY,
                        AMOUNT,
                        PU.MAIN_UNIT AS BIRIM,
                            PB.BRAND_NAME,
                            3 AS SVY
                            ,(SELECT 0 AS PRICE,0 AS DISCOUNT,'' AS OTHER_MONEY FOR JSON PATH) AS PRICEJSON
                        FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                        LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                        LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB 
                            ON PB.BRAND_ID = S.BRAND_ID
                        WHERE VPT.STOCK_ID = #RELATED_ID#
                    </cfquery>
                </cfif>
                <cfloop query="qProductTree2">
                    <CFSET SN=SN+1>
            <tr data-parent="#randomInt2#" data-level="#SVY-1#" class="tree-row">
                        <cfset randomInt3 = RandRange(1000, 9999)>
                <td>#SN#</td>
                        <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                        <td><span >#PRODUCT_NAME#</span></td>
                        <td><span >#BRAND_NAME#</span></td>
                        <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                        <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                        <cfif len(PRICEJSON) AND isJSON(PRICEJSON)>
                            <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                            <cfelse>
                            <CFSET INDIRIMSIZ_FIYAT=0>
                            <CFSET PRICEJSON='[{"PRICE":0,"DISCOUNT":0,"OTHER_MONEY":"TL"}]'>
                        </cfif>
                    <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE*AMOUNT)#</span></td>
                <td class="FiyatAlan"><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                
                    </tr>
                    <cfif IS_VIRTUAL EQ 1>
                        <cfquery name="qProductTree3" datasource="#dsn3#">
                            SELECT 
                                CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                                CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                                CASE WHEN IS_VIRTUAL=1 THEN VP.PRODUCT_UNIT ELSE PU.MAIN_UNIT END AS BIRIM,
                                IS_VIRTUAL,
                                VPT.PRICE,
                                VPT.DISCOUNT,
                                VPT.OTHER_MONEY,
                                PB.BRAND_NAME,
                        AMOUNT,
                        (SELECT TOP 1  CAST(PRICE AS DECIMAL(18,2)) AS PRICE,CAST(DISCOUNT AS DECIMAL(18,2)) AS DISCOUNT,OTHER_MONEY FROM workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE PBS_ROW_ID=VPT.PBS_ROW_ID AND IS_ACTIVE=1 FOR JSON AUTO) AS PRICEJSON,
                                4 AS SVY
                            FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                            LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                            LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                            LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB
                                ON PB.BRAND_ID = 
                                    CASE 
                                        WHEN IS_VIRTUAL = 1 THEN 491
                                        ELSE S.BRAND_ID 
                                    END
                            WHERE VP_ID = #RELATED_ID#
                        </cfquery>
                    <cfelse>
                        <cfquery name="qProductTree3" datasource="#dsn3#">
                            SELECT 
                                S.PRODUCT_NAME,
                                RELATED_ID,
                                0 AS IS_VIRTUAL,
                                PRICE_PBS PRICE,
                        DISCOUNT_PBS DISCOUNT,
                        OTHER_MONEY_PBS MONEY,
                        AMOUNT,
                                4 AS SVY,
                                PB.BRAND_NAME
                                ,PU.MAIN_UNIT AS BIRIM,
                                ,(SELECT 0 AS PRICE,0 AS DISCOUNT,'' AS OTHER_MONEY FOR JSON PATH) AS PRICEJSON
                            FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                            LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                            LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                            WHERE VPT.STOCK_ID = #RELATED_ID#
                        </cfquery>
                    </cfif>
                    <cfloop query="qProductTree3">
                        <CFSET SN=SN+1>
                        <tr data-parent="#randomInt3#" data-level="#SVY-1#" class="tree-row">
                        <cfset randomInt4 = RandRange(1000, 9999)>
                            <td>#SN#</td>
                            <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                            <td><span >#PRODUCT_NAME#</span></td>
                            <td><span >#BRAND_NAME#</span></td>
                            <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                            <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                            <cfif len(PRICEJSON) AND isJSON(PRICEJSON)>
                                <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                                <cfelse>
                                <CFSET INDIRIMSIZ_FIYAT=0>
                                <CFSET PRICEJSON='[{"PRICE":0,"DISCOUNT":0,"OTHER_MONEY":"TL"}]'>
                            </cfif>
                            <tdclass="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                            
                            <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                            <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                            <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE*AMOUNT)#</span></td>
                            <td class="FiyatAlan"><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                        </tr>
                        <cfif IS_VIRTUAL EQ 1>
                            <cfquery name="qProductTree4" datasource="#dsn3#">
                                SELECT 
                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                                    CASE WHEN IS_VIRTUAL=1 THEN VP.PRODUCT_UNIT ELSE PU.MAIN_UNIT END AS BIRIM,
                                    IS_VIRTUAL,
                                    VPT.PRICE,
                                    VPT.DISCOUNT,
                                    VPT.OTHER_MONEY,
                        AMOUNT,
                                    PB.BRAND_NAME,
                        (SELECT TOP 1  CAST(PRICE AS DECIMAL(18,2)) AS PRICE,CAST(DISCOUNT AS DECIMAL(18,2)) AS DISCOUNT,OTHER_MONEY FROM workcube_metosan_1.PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE PBS_ROW_ID=VPT.PBS_ROW_ID AND IS_ACTIVE=1 FOR JSON AUTO) AS PRICEJSON,
                                    5 AS SVY
                                FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                                LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                                LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB
                                    ON PB.BRAND_ID = 
                                        CASE 
                                            WHEN IS_VIRTUAL = 1 THEN 491
                                            ELSE S.BRAND_ID 
                                        END
                                WHERE VP_ID = #RELATED_ID#
                            </cfquery>
                        <cfelse>
                            <cfquery name="qProductTree4" datasource="#dsn3#">
                                SELECT 
                                    S.PRODUCT_NAME,
                                    RELATED_ID,
                                    0 AS IS_VIRTUAL,
                                    PRICE_PBS PRICE,
                        DISCOUNT_PBS DISCOUNT,
                        OTHER_MONEY_PBS MONEY,
                        AMOUNT,
                        PB.BRAND_NAME,
                                    PU.MAIN_UNIT AS BIRIM,
                        
                                    5 AS SVY
                                    ,(SELECT 0 AS PRICE,0 AS DISCOUNT,'' AS OTHER_MONEY FOR JSON PATH) AS PRICEJSON
                                FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
                                LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB 
                                    ON PB.BRAND_ID = S.BRAND_ID
                                WHERE VPT.STOCK_ID = #RELATED_ID#
                            </cfquery>
                        </cfif>
                        <cfloop query="qProductTree4">
                            <CFSET SN=SN+1>
                            <tr data-parent="#randomInt4#" data-level="#SVY-1#" class="tree-row">
                                
                                <td>#SN#</td>
                                <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                                <td><span >#PRODUCT_NAME#</span></td>
                                <td><span >#BRAND_NAME#</span></td>
                                <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                                <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                                <cfif len(PRICEJSON) AND isJSON(PRICEJSON)>
                                    <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                                    <cfelse>
                                    <CFSET INDIRIMSIZ_FIYAT=0>
                                    <CFSET PRICEJSON='[{"PRICE":0,"DISCOUNT":0,"OTHER_MONEY":"TL"}]'>
                                </cfif>
                            <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                                
                                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                                <td class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE*AMOUNT)#</span></td>
                                <td class="FiyatAlan"><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                            </tr>
                        </cfloop>
                    </cfloop>
                </cfloop>
            </cfloop>
        </cfoutput>
        <cfoutput>
            <tr>
                <td colspan="9" style="text-align: right; font-weight: bold;">Toplam</td>            
                <td colspan="2" class="FiyatAlan"><span style="padding-left: 0px;">#tlformat(EURO_TOPLAM)# EUR </span>
                <br>
                <span style="padding-left: 0px;">#tlformat(TL_TOPLAM)# TL</span>
                <br>
                <span style="padding-left: 0px;">#tlformat(USD_TOPLAM)# USD</span>
                </td>
                
            </tr>
        </cfoutput>
    </table>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toggles = document.querySelectorAll('.toggle-icon');
    
            toggles.forEach(toggle => {
                toggle.addEventListener('click', function () {
                    const id = this.getAttribute('data-toggle');
                    const rows = document.querySelectorAll(`.tree-row[data-parent='${id}']`);
                    const isOpen = this.textContent === '▼';
    
                    this.textContent = isOpen ? '▶' : '▼';
    
                    rows.forEach(row => {
                        if (isOpen) {
                            row.style.display = 'none';
                            collapseChildren(row.getAttribute('data-id')); // alt dalları da kapat
                        } else {
                            row.style.display = 'table-row';
                        }
                    });
                });
            });
    
            // Alt seviyeleri kapatma fonksiyonu
            function collapseChildren(parentId) {
                const children = document.querySelectorAll(`.tree-row[data-parent='${parentId}']`);
                children.forEach(child => {
                    child.style.display = 'none';
                    const childId = child.getAttribute('data-id');
                    collapseChildren(childId); // recursive kapatma
                    const icon = document.querySelector(`.toggle-icon[data-toggle='${childId}']`);
                    if (icon) icon.textContent = '▶';
                });
            }
    
            // İlk yüklemede tüm satırları gizle (sadece seviye 0 kalsın)
            document.querySelectorAll('.tree-row').forEach(row => {
                if (row.getAttribute('data-level') != "0") {
                    row.style.display = 'none';
                }
            });
        });
    </script>