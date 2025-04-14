﻿<cfif session.ep.userid eq 1146>
    <style>
        body { font-family: Arial, sans-serif; font-size: 12px; }
        table { width: 100%; border-collapse: collapse; }
        .header-table td { padding: 5px; vertical-align: top; }
        .info-table td { border: 1px solid #000; padding: 5px; }
        .info-table .label { font-weight: bold; background-color: #f5f5f5; width: 100px; }
        .section-title { font-weight: bold; text-align: center; font-size: 18px; padding: 10px; }
        .product-table th { background-color: #90ee90; padding: 6px; border: 1px solid #000; }
        .product-table td { padding: 5px; border: 1px solid #000; }
        .note-box { border: 1px solid #000; padding: 10px; margin-top: 10px; }
        .signature-box { padding: 10px; text-align: left; }
        .footer-contact { text-align: right; font-size: 11px; padding-right: 10px; }
    </style>
    <style>
        .product-table th {
            background-color: #90ee90;
            text-align: center;
            font-weight: bold;
            border: 1px solid #000;
            padding: 6px;
        }
    
        .product-table td {
            border: 1px solid #000;
            padding: 6px;
        }
    
        .toggle-icon {
            font-weight: bold;
            display: inline-block;
            width: 16px;
            text-align: center;
        }
    </style>
     <table class="header-table">
        <tr>
            <td width="50%">
                <img src="http://erp.metosan.com.tr/documents/settings/3B355075-DEF5-E025-AE27746DDF7BCBF8.png" border="0" style="max-width: 250px;height: 88px;width: 270px;">
            </td>
            <td align="right" style="font-size: 20px; font-weight: bold;">
                SATIŞ TEKLİF FORMU
            </td>
        </tr>
    </table>

    <!-- Firma ve Teklif Bilgileri -->
    <table class="info-table" style="margin-top: 10px;">
        <tr>
            <td class="label">Firma</td>
            <td>Test2</td>
            <td class="label">Tarih</td>
            <td>10.04.2025 05:01:57</td>
        </tr>
        <tr>
            <td class="label">Tel/Faks</td>
            <td></td>
            <td class="label">Ref. No</td>
            <td>PBSTV-136629</td>
        </tr>
        <tr>
            <td class="label">E-Posta</td>
            <td>busraturk@mifasistem.com</td>
            <td class="label">İlgili</td>
            <td></td>
        </tr>
        <tr>
            <td class="label">Konu</td>
            <td colspan="3">Teklifimiz</td>
        </tr>
    </table>

    <!-- Açıklama -->
    <div class="note-box">
        Firmamızdan talep etmiş olduğunuz ürünler ile ilgili teklifimiz aşağıda dikkatinize sunulmuştur.
        Teklifimizin olumlu karşılanacağını ümit eder, çalışmalarınızda başarılar dileriz.<br><br>
        Saygılarımızla,<br><br>
        SERHAT ENVER KARAŞ<br>
        PBS ERP DESTEK UZMANI
    </div>

    
    <!-- Ürün Tablosu -->


    <cftry>
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
WHERE VP_ID=7542
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
        <th colspan="">
            <span style="padding-left: 0px;">Fiyat</span>
        </th>
        <th colspan="">
            <span style="padding-left: 0px;">İndirim</span>
        </th>
        <th colspan="">
            <span style="padding-left: 0px;">İndirimli Fiyat</span>
        </th>
        <th colspan="">
            <span style="padding-left: 0px;">Para Birimi</span>
        </th>
        
    </tr>
    
    <cfoutput query="qProductTree">
        <CFSET SN=SN+1>
        <cfset randomInt = RandRange(1000, 9999)>
        <tr class="tree-row" data-parent="" data-level="#SVY#">
            <td>#SN#</td>
            <td><span class="toggle-icon" data-toggle="#randomInt#">▶</span></td>
            <td><span style="padding-left: 0px;">#PRODUCT_NAME#</span></td>
            <td><span >#BRAND_NAME#</span></td>
            <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
            <td><span style="padding-left: 0px;">#BIRIM#</span></td>
            <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
            <td><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
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
                    ,(SELECT '' AS PRICE,'' AS DISCOUNT,'' AS OTHER_MONEY FOR JSON PATH) AS PRICEJSON
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
                <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                <td><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
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
        <tr data-parent="#randomInt2#" data-level="#SVY#" class="tree-row">
                    <cfset randomInt3 = RandRange(1000, 9999)>
            <td>#SN#</td>
                    <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                    <td><span >#PRODUCT_NAME#</span></td>
                    <td><span >#BRAND_NAME#</span></td>
                    <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                    <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                    <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
            
            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
            <td><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
            
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
                    <tr data-parent="#randomInt3#" data-level="#SVY#" class="tree-row">
                    <cfset randomInt4 = RandRange(1000, 9999)>
                        <td>#SN#</td>
                        <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                        <td><span >#PRODUCT_NAME#</span></td>
                        <td><span >#BRAND_NAME#</span></td>
                        <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                        <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                        <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                        <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                        
                        <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                        <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                        <td><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
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
                        <tr data-parent="#randomInt4#" data-level="#SVY#" class="tree-row">
                            
                            <td>#SN#</td>
                            <td><span class="toggle-icon" style="padding-left:#SVY*15#px" data-toggle="#RELATED_ID#">▶</span></td>
                            <td><span >#PRODUCT_NAME#</span></td>
                            <td><span >#BRAND_NAME#</span></td>
                            <td><span style="padding-left: 0px;">#tlformat(AMOUNT)#</span></td>
                            <td><span style="padding-left: 0px;">#BIRIM#</span></td>
                            <CFSET INDIRIMSIZ_FIYAT=deserializeJSON(PRICEJSON)[1].PRICE+(deserializeJSON(PRICEJSON)[1].DISCOUNT/100*deserializeJSON(PRICEJSON)[1].PRICE)>
                        <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(INDIRIMSIZ_FIYAT))#</span></td>
                            
                            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].DISCOUNT)#</span></td>
                            <td><span style="padding-left: 0px;">#tlformat(deserializeJSON(PRICEJSON)[1].PRICE)#</span></td>
                            <td><span style="padding-left: 0px;">#deserializeJSON(PRICEJSON)[1].OTHER_MONEY#</span></td>
                        </tr>
                    </cfloop>
                </cfloop>
            </cfloop>
        </cfloop>
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

    <!-------------------
<cfoutput>

        <table>
        <cfloop query="qProductTree">
            <tr>
                <td><span class="toggle-icon" data-toggle="#RELATED_ID#">▶</span></td>
                <td><span >#PRODUCT_NAME#</span></td>
            </tr>
                <!-- Alt seviye sorgu -->
                <cfif IS_VIRTUAL EQ 1>
                    <cfquery name="qProductTree1" datasource="#dsn3#">
                        SELECT 
                            CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                            CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                            IS_VIRTUAL,
                            2 AS SVY
                        FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                        LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                        WHERE VP_ID = #RELATED_ID#
                    </cfquery>
                <cfelse>
                    <cfquery name="qProductTree1" datasource="#dsn3#">
                        SELECT 
                            S.PRODUCT_NAME,
                            RELATED_ID,
                            0 AS IS_VIRTUAL,
                            2 AS SVY
                        FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                        WHERE VPT.STOCK_ID = #RELATED_ID#
                    </cfquery>
                </cfif>
        
                
                <cfloop query="qProductTree1">
                    <tr>
                       <td> <span style="padding:#SVY*30#px" class="toggle-icon" data-toggle="#RELATED_ID#">▶</span></td>
                        <td><span >#PRODUCT_NAME#</span></td>
                    </tr>
                        <!-- 3. Seviye -->
                        <cfif IS_VIRTUAL EQ 1>
                            <cfquery name="qProductTree2" datasource="#dsn3#">
                                SELECT 
                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                                    IS_VIRTUAL,
                                    3 AS SVY
                                FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                                WHERE VP_ID = #RELATED_ID#
                            </cfquery>
                        <cfelse>
                            <cfquery name="qProductTree2" datasource="#dsn3#">
                                SELECT 
                                    S.PRODUCT_NAME,
                                    RELATED_ID,
                                    0 AS IS_VIRTUAL,
                                    3 AS SVY
                                FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                WHERE VPT.STOCK_ID = #RELATED_ID#
                            </cfquery>
                        </cfif>
        
                        
                        <cfloop query="qProductTree2">
                            <tr>
                                <td><span class="toggle-icon" style="padding:#SVY*30#px" data-toggle="#RELATED_ID#">▶</span></td>
                                <td><span >#PRODUCT_NAME#</span></td>
                            </tr>
                                <!-- 4. Seviye -->
                                <cfif qProductTree2.IS_VIRTUAL eq 1>
                                    <cfquery name="qProductTree3" datasource="#dsn3#">
                                        SELECT 
                                            CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                                            CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                                            IS_VIRTUAL,
                                            4 AS SVY
                                        FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                        LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                                        WHERE VP_ID = #qProductTree2.RELATED_ID#
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="qProductTree3" datasource="#dsn3#">
                                        SELECT 
                                            S.PRODUCT_NAME,
                                            RELATED_ID,
                                            0 AS IS_VIRTUAL,
                                            4 AS SVY
                                        FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                                        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                        WHERE VPT.STOCK_ID = #qProductTree2.RELATED_ID#
                                    </cfquery>
                                </cfif>
                                
                                <cfloop query="qProductTree3">
                                    <tr>
                                       <td> <span class="toggle-icon" style="padding:#SVY*30#px"  data-toggle="#RELATED_ID#">▶</span></td>
                                        <td><span >#PRODUCT_NAME#</span></td>
                                    </tr>
                                        <!-- 5. Seviye -->
                                        <cfif qProductTree3.IS_VIRTUAL eq 1>
                                            <cfquery name="qProductTree4" datasource="#dsn3#">
                                                SELECT 
                                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.PRODUCT_NAME ELSE S.PRODUCT_NAME END AS PRODUCT_NAME,
                                                    CASE WHEN IS_VIRTUAL = 1 THEN VP.VIRTUAL_PRODUCT_ID ELSE S.STOCK_ID END AS RELATED_ID,
                                                    IS_VIRTUAL,
                                                    5 AS SVY
                                                FROM workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT VPT
                                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                                LEFT JOIN workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP ON VP.VIRTUAL_PRODUCT_ID = VPT.PRODUCT_ID
                                                WHERE VP_ID = #qProductTree3.RELATED_ID#
                                            </cfquery>
                                        <cfelse>
                                            <cfquery name="qProductTree4" datasource="#dsn3#">
                                                SELECT 
                                                    S.PRODUCT_NAME,
                                                    RELATED_ID,
                                                    0 AS IS_VIRTUAL,
                                                    5 AS SVY
                                                FROM workcube_metosan_1.PRODUCT_TREE AS VPT
                                                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.PRODUCT_ID = VPT.PRODUCT_ID
                                                WHERE VPT.STOCK_ID = #qProductTree3.RELATED_ID#
                                            </cfquery>
                                        </cfif>
                                        
                                        <cfloop query="qProductTree4">
                                            <tr>
                                             <td><span class="toggle-icon" style="padding:#SVY*30#px"  data-toggle="#RELATED_ID#">▶</span></td> 
                                                <td><span >#PRODUCT_NAME#</span></td>
                                                                                                
                                            </tr>
                                        </cfloop>
                                    
                                    </cfloop>
                                    
                                    
                            
                        </cfloop>
                        
        
                    
                </cfloop>
                
        
            
        </cfloop>
        </table>
        </cfoutput>
             
------->
<cfabort>


    <cfquery name="qProductTree" datasource="#dsn3#">
       /* WITH ProductTreeCTE AS (
            SELECT 
                PT.STOCK_ID,
                PT.RELATED_ID,
                PT.PRICE_PBS,
                PT.DISCOUNT_PBS,
                PT.OTHER_MONEY_PBS,
                PT.AMOUNT,
                1 AS LEVEL
            FROM PRODUCT_TREE PT
            WHERE PT.STOCK_ID = 48335
        
            UNION ALL
        
            SELECT 
                PT.STOCK_ID,
                PT.RELATED_ID,
                PT.PRICE_PBS,
                PT.DISCOUNT_PBS,
                PT.OTHER_MONEY_PBS,
                PT.AMOUNT,
                CTE.LEVEL + 1
            FROM PRODUCT_TREE PT
            INNER JOIN ProductTreeCTE CTE ON PT.STOCK_ID = CTE.RELATED_ID
            WHERE CTE.LEVEL < 5
        )
        
        SELECT 
            T.STOCK_ID AS ParentID,
            T.RELATED_ID AS ID,
            S.PRODUCT_NAME,
            T.PRICE_PBS AS PRICE,
            T.OTHER_MONEY_PBS AS MONEY,
            T.DISCOUNT_PBS AS DISCOUNT,
            PB.BRAND_NAME,
            PU.MAIN_UNIT,
            T.LEVEL,
            T.AMOUNT
        FROM T T
        INNER JOIN STOCKS S ON S.STOCK_ID = T.RELATED_ID
        LEFT JOIN PRODUCT_BRANDS PB ON PB.BRAND_ID = S.BRAND_ID
        LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND PU.IS_MAIN = 1
        ORDER BY T.LEVEL, S.PRODUCT_NAME*/

        EXEC workcube_metosan_1.GET_VIRTUAL_PRODUCT_TREE_PBS111 7542,0

        </cfquery>
<cfscript>
    treeData = [];

    for (row in qProductTree) {
        arrayAppend(treeData, {
            id: row.ID,
            parentId: row.ParentID,
            name: row.PRODUCT_NAME,
            price: row.PRICE,
            money: row.MONEY,
            brand: row.BRAND_NAME,
            unit: row.MAIN_UNIT,
            discount: row.DISCOUNT,
            level: row.LEVEL,
            amount: row.AMOUNT
        });
    }
    
    // Ağaç şeklinde renderlayan fonksiyon
    function renderTree(data, parentId, depth = 0) {
        var html = "";
        serialNumber = 1; // sıra numarası için başlangıç
        for (item in data) {
            if (item.parentId == parentId) {
                var hasChildren = arrayLen(arrayFilter(data, function(el){ return el.parentId == item.id; }));
                html &= "<tr class='tree-row' data-id='#item.id#' data-parent='#parentId#' data-level='#depth#'>";
                    html &= "<td>#serialNumber++#</td>"; // sıra numarası için önceden `serialNumber = 1` tanımlanmalı
                    html &= "<td style='padding-left:#depth * 20#px'>";
                    if (hasChildren > 0) {
                        html &= "<span class='toggle-icon' data-toggle='#item.id#' style='cursor:pointer;'>▶</span> ";
                    } else {
                        html &= "<span style='visibility:hidden'>▶</span> ";
                    }
                    html &= "📦 " & item.name & "</td>";
                    html &= "<td>" & item.brand & "</td>";
                    html &= "<td>#tlformat(item.amount)#</td>"; // miktar sabit ya da dinamik
                    html &= "<td>" & tlformat(item.price) & "</td>";
                    html &= "<td>" & tlformat(item.price) & "</td>"; // toplam örnek olarak aynı
                    html &= "<td>" & item.money & "</td>";
                    html &= "<td>" & dateFormat(now(), "dd.mm.yyyy") & "</td>"; // teslim tarihi örnek
                    html &= "</tr>";
    
                html &= renderTree(data, item.id, depth + 1);
            }
        }
    
        return html;
    }
    
    treeHtml = renderTree(treeData, 7542);
</cfscript>

<style>
    table.treeview-table {
        width: 100%;
        border-collapse: collapse;
    }

    table.treeview-table th, table.treeview-table td {
        border: 1px solid #ccc;
        padding: 8px;
    }

    .tree-indent {
        padding-left: 20px;
    }
</style>
<table class="product-table" style="margin-top: 10px; font-size: 12px;">
    <thead>
        <tr>
            <th>SN</th>
            <th>Malzeme Adı</th>
            <th>Marka</th>
            <th>Miktar</th>
            <th>Net Birim Fiyat</th>
            <th>Net Toplam Tutar</th>
            <th>Para Birimi</th>
            <th>Teslim Tarihi</th>
        </tr>
    </thead>
    <tbody id="tree-table-body">
        <cfoutput>#treeHtml#</cfoutput>
    </tbody>
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
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>

<cfabort>
</cfif>
<cftry>
    <style>
        @media print
        {
            .etiketForm{
                display:none;
            }
        }
    </style>
    <!--- Teklif Formu --->
    <cfif isdefined("attributes.action_id")>
        <cfset attributes.offer_id = attributes.action_id>
    <cfelse>
        <cfif isdefined("attributes.id")>
            <cfset attributes.offer_id = attributes.id>
        <cfelse>
            <cfset attributes.offer_id = listdeleteduplicates(attributes.iid)>
        </cfif>
    </cfif>

    <cfif not isdefined("form.isSubmit")>
        <cfset form.isSubmit = 1>
        <cfset form.offer_type = 0>
    </cfif>
    <cfquery name="Our_Company" datasource="#dsn#">
        SELECT 
            ASSET_FILE_NAME3,
            ASSET_FILE_NAME3_SERVER_ID,
            COMPANY_NAME,
            TEL_CODE,
            TEL,TEL2,
            TEL3,
            TEL4,
            FAX,
            TAX_OFFICE,
            TAX_NO,
            ADDRESS,
            WEB,
            EMAIL
        FROM 
            OUR_COMPANY 
        WHERE 
        <cfif isDefined("SESSION.EP.COMPANY_ID")>
            COMP_ID = #SESSION.EP.COMPANY_ID#
        <cfelseif isDefined("SESSION.PP.COMPANY")>	
            COMP_ID = #SESSION.PP.COMPANY#
        </cfif>
    </cfquery>
    <cfquery name="CHECK" datasource="#DSN#">
        SELECT 
            ASSET_FILE_NAME2,
            ASSET_FILE_NAME2_SERVER_ID,
            COMPANY_NAME
        FROM 
            OUR_COMPANY 
        WHERE 
            <cfif isdefined("attributes.our_company_id")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
            <cfelse>
                <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                    COMP_ID = #session.ep.company_id#
                <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                    COMP_ID = #session.pp.company_id#
                <cfelseif isDefined("session.ww.our_company_id")>
                    COMP_ID = #session.ww.our_company_id#
                <cfelseif isDefined("session.cp.our_company_id")>
                    COMP_ID = #session.cp.our_company_id#
                </cfif> 
            </cfif> 
    </cfquery>
    <cfif isDefined('attributes.OFFER_ID')>
        <cfquery name="Get_Offer" datasource="#DSN#">
        SELECT
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_EMAIL,	
				PP.PROJECT_HEAD,
				PP.PROJECT_NUMBER,
                PP.PROJECT_ID,
                O.*
            FROM 
                #DSN3#.PBS_OFFER O , 
                workcube_metosan.EMPLOYEES E,
				workcube_metosan.PRO_PROJECTS AS PP 
            WHERE 
                O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
                E.EMPLOYEE_ID = O.RECORD_MEMBER AND
				PP.PROJECT_ID=O.PROJECT_ID
           
        </cfquery>
    </cfif>

    <cfquery name="Get_Offer_Rows" datasource="#dsn3#">
        SELECT
            ORR.*,
            P.BARCOD,
            ORR.PRODUCT_NAME2 AS AAAPNMANE,
            CASE WHEN ORR.IS_VIRTUAL=1 THEN ORR.PRODUCT_NAME COLLATE SQL_Latin1_General_CP1_CI_AS ELSE P.PRODUCT_NAME END AS PRODUCT_NAME,
            CASE WHEN ORR.IS_VIRTUAL=1 THEN '' ELSE P.MANUFACT_CODE END AS MANUFACT_CODE,
            CASE WHEN ORR.IS_VIRTUAL=1 THEN '' ELSE P.PRODUCT_CODE END AS PRODUCT_CODE,
            CASE WHEN ORR.IS_VIRTUAL=1 THEN 'Metosan' ELSE PB.BRAND_NAME END AS BRAND_NAME,            
            PC.PRODUCT_CAT
        FROM
            PBS_OFFER_ROW ORR
             LEFT JOIN PRODUCT P ON P.PRODUCT_ID = ORR.PRODUCT_ID
            LEFT JOIN #dsn1#.PRODUCT_BRANDS PB ON PB.BRAND_ID = P.BRAND_ID
            LEFT JOIN #dsn1#.PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
        WHERE
            ORR.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
        ORDER BY
            ORR.OFFER_ROW_ID
    </cfquery>
    <cfif Get_Offer_Rows.IS_VIRTUAL EQ 1>
        <cfquery name="Get_Offer_Rows2" datasource="#dsn3#">
        EXEC workcube_metosan_1.GET_VIRTUAL_PRODUCT_TREE_PBS111 #Get_Offer_Rows.PRODUCT_ID#,0
        </cfquery>
    <cfelse>
        <cfquery name="Get_Offer_Rows2" datasource="#dsn3#">
         SELECT T.AMOUNT
	,T.PRICE_PBS as PRICE
	,T.OTHER_MONEY_PBS AS MONEY
	,T.DISCOUNT_PBS AS DISCOUNT
	,S.STOCK_ID
	,S.PRODUCT_CODE
	,S.PRODUCT_NAME
    ,S.PRODUCT_ID    
	,PB.BRAND_NAME
	,PU.MAIN_UNIT
FROM (
	SELECT *
	FROM #DSN3#.PRODUCT_TREE
	WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID# ---- 1.SEVİYE
	
	UNION ALL
	
	SELECT *
	FROM #DSN3#.PRODUCT_TREE
	WHERE STOCK_ID IN (
			SELECT RELATED_ID
			FROM #DSN3#.PRODUCT_TREE
			WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
			) ----2.SEVİYE
	
	UNION ALL
	
	SELECT *
	FROM #DSN3#.PRODUCT_TREE
	WHERE STOCK_ID IN (
			SELECT RELATED_ID
			FROM #DSN3#.PRODUCT_TREE
			WHERE STOCK_ID IN (
					SELECT RELATED_ID
					FROM #DSN3#.PRODUCT_TREE
					WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
					)
			) ----3.SEVİYE
	
	UNION ALL
	
	SELECT *
	FROM #DSN3#.PRODUCT_TREE
	WHERE STOCK_ID IN (
			SELECT RELATED_ID
			FROM #DSN3#.PRODUCT_TREE
			WHERE STOCK_ID IN (
					SELECT RELATED_ID
					FROM #DSN3#.PRODUCT_TREE
					WHERE STOCK_ID IN (
							SELECT RELATED_ID
							FROM #DSN3#.PRODUCT_TREE
							WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
							)
					)
			) ----4.SEVİYE
	
	UNION ALL
	
	SELECT *
	FROM #DSN3#.PRODUCT_TREE
	WHERE STOCK_ID IN (
			SELECT RELATED_ID
			FROM #DSN3#.PRODUCT_TREE
			WHERE STOCK_ID IN (
					SELECT RELATED_ID
					FROM #DSN3#.PRODUCT_TREE
					WHERE STOCK_ID IN (
							SELECT RELATED_ID
							FROM #DSN3#.PRODUCT_TREE
							WHERE STOCK_ID IN (
									SELECT RELATED_ID
									FROM #DSN3#.PRODUCT_TREE
									WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
									)
							)
					)
			) ----5.SEVİYE
	) AS T
INNER JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = T.RELATED_ID
LEFT JOIN #DSN3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = S.BRAND_ID
LEFT JOIN #DSN3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
	AND PU.IS_MAIN = 1
WHERE RELATED_ID NOT IN (
		SELECT STOCK_ID
		FROM #DSN3#.PRODUCT_TREE
		WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID# ---- 1.SEVİYE
		
		UNION ALL
		
		SELECT STOCK_ID
		FROM #DSN3#.PRODUCT_TREE
		WHERE STOCK_ID IN (
				SELECT RELATED_ID
				FROM #DSN3#.PRODUCT_TREE
				WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
				) ----2.SEVİYE
		
		UNION ALL
		
		SELECT STOCK_ID
		FROM #DSN3#.PRODUCT_TREE
		WHERE STOCK_ID IN (
				SELECT RELATED_ID
				FROM #DSN3#.PRODUCT_TREE
				WHERE STOCK_ID IN (
						SELECT RELATED_ID
						FROM #DSN3#.PRODUCT_TREE
						WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
						)
				) ----3.SEVİYE
		
		UNION ALL
		
		SELECT STOCK_ID
		FROM #DSN3#.PRODUCT_TREE
		WHERE STOCK_ID IN (
				SELECT RELATED_ID
				FROM #DSN3#.PRODUCT_TREE
				WHERE STOCK_ID IN (
						SELECT RELATED_ID
						FROM #DSN3#.PRODUCT_TREE
						WHERE STOCK_ID IN (
								SELECT RELATED_ID
								FROM #DSN3#.PRODUCT_TREE
								WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
								)
						)
				) ----4.SEVİYE
		
		UNION ALL
		
		SELECT STOCK_ID
		FROM #DSN3#.PRODUCT_TREE
		WHERE STOCK_ID IN (
				SELECT RELATED_ID
				FROM #DSN3#.PRODUCT_TREE
				WHERE STOCK_ID IN (
						SELECT RELATED_ID
						FROM #DSN3#.PRODUCT_TREE
						WHERE STOCK_ID IN (
								SELECT RELATED_ID
								FROM #DSN3#.PRODUCT_TREE
								WHERE STOCK_ID IN (
										SELECT RELATED_ID
										FROM #DSN3#.PRODUCT_TREE
										WHERE STOCK_ID = #Get_Offer_Rows.STOCK_ID#
										)
								)
						)
				) ----5.SEVİYE
		)
        </cfquery>
  
    </cfif>
    <cfquery name="Get_Offer_Plus" datasource="#dsn3#">
        SELECT
            PROPERTY1 AS EPOSTA,
            PROPERTY2 AS ILGILI,
            PROPERTY3 AS NOTLAR,
            PROPERTY4 AS TESLIM,
            PROPERTY5 AS ODEME,
            PROPERTY6 AS OPSIYON,
            PROPERTY7 AS ACIKLAMA
            
        FROM
            PBS_OFFER_INFO_PLUS
        WHERE
            PBS_OFFER_INFO_PLUS.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    </cfquery>
    <cfif len(Get_Offer.Deliver_Place)>
        <cfquery name="Get_Store" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Deliver_Place#">
        </cfquery>
    </cfif>

    <cfif len(Get_Offer.Paymethod)>
        <cfset attributes.paymethod_id = Get_Offer.Paymethod>
        <cfquery name="Get_Paymethod" datasource="#dsn#">
            SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Paymethod_id#">
        </cfquery>
    </cfif>

    <!--- Uye bilgileri --->
    <cfset Member_Code = "">
    <cfset Member_Name = "">
    <cfset Member_Mail = "">
    <cfset Member_TaxOffice = "">
    <cfset Member_TaxNo = "">
    <cfset Member_TelCode = "">
    <cfset Member_Tel = "">
    <cfset Member_Fax = "">
    <cfset Member_Address = "">
    <cfset Member_Semt = "">
    <cfset Member_County = "">
    <cfset Member_City = "">
    <cfset Member_Country = "">
    <cfif isdefined("Get_Offer.Company_Id") and Len(Get_Offer.Company_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                COMPANY_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                FULLNAME MEMBER_NAME,
                COMPANY_EMAIL MEMBER_EMAIL,
                TAXOFFICE MEMBER_TAXOFFICE,
                TAXNO MEMBER_TAXNO,
                COMPANY_TELCODE MEMBER_TELCODE,
                COMPANY_TEL1 MEMBER_TEL,
                COMPANY_FAX MEMBER_FAX,
                COMPANY_ADDRESS MEMBER_ADDRESS,
                SEMT MEMBER_SEMT,
                COUNTY MEMBER_COUNTY,
                CITY MEMBER_CITY,
                COUNTRY MEMBER_COUNTRY
            FROM
                COMPANY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Company_Id#">
        </cfquery>
    <cfelseif isdefined("Get_Offer.Consumer_Id") and Len(Get_Offer.Consumer_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                CONSUMER_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
                CONSUMER_EMAIL MEMBER_EMAIL,
                TAX_OFFICE MEMBER_TAXOFFICE,
                TAX_NO MEMBER_TAXNO,
                CONSUMER_WORKTELCODE MEMBER_TELCODE,
                CONSUMER_WORKTEL MEMBER_TEL,
                CONSUMER_FAXCODE + '' + CONSUMER_FAX MEMBER_FAX,
                WORKADDRESS MEMBER_ADDRESS,
                WORKSEMT MEMBER_SEMT,
                WORK_COUNTY_ID MEMBER_COUNTY,
                WORK_CITY_ID MEMBER_CITY,
                WORK_COUNTRY_ID MEMBER_COUNTRY
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Consumer_Id#">
        </cfquery>
    </cfif>
    <cfquery name="getProject" datasource="#dsn#">
        SELECT PROJECT_NUMBER,PROJECT_HEAD,SMC.MAIN_PROCESS_CAT,PP.PROJECT_EMP_ID FROM workcube_metosan.PRO_PROJECTS AS PP
INNER JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
WHERE PP. PROJECT_ID=#Get_Offer.PROJECT_ID#
    </cfquery>
    <cfif isdefined("Get_Member_Info") and Get_Member_Info.RecordCount>
        <cfset Member_Code = Get_Member_Info.Member_Code>
        <cfset Member_Name = Get_Member_Info.Member_Name>
        <cfset Member_Mail = Get_Member_Info.Member_Email>
        <cfset Member_TaxOffice = Get_Member_Info.Member_TaxOffice>
        <cfset Member_TaxNo = Get_Member_Info.Member_TaxNo>
        <cfset Member_TelCode = Get_Member_Info.Member_TelCode>
        <cfset Member_Tel = Get_Member_Info.Member_Tel>
        <cfset Member_Fax = Get_Member_Info.Member_Fax>
        <cfset Member_Address = Get_Member_Info.Member_Address>
        <cfset Member_Semt = Get_Member_Info.Member_Semt>
        
        <cfif Len(Get_Member_Info.Member_County)>
            <cfquery name="Get_County_Name" datasource="#dsn#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
            </cfquery>
            <cfset Member_County = Get_County_Name.County_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_City)>
            <cfquery name="Get_City_Name" datasource="#dsn#">
                SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
            </cfquery>
            <cfset Member_City = Get_City_Name.City_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_Country)>
            <cfquery name="Get_Country_Name" datasource="#dsn#">
                SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
            </cfquery>
            <cfset Member_Country = Get_Country_Name.Country_Name>
        </cfif>
    </cfif>
    <cfif Len(Get_Offer.Partner_id)>
        <cfquery name="Get_Partner" datasource="#dsn#">
            SELECT COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Partner_id#">
        </cfquery>
        <cfset Partner_Name = Get_Partner.Partner_Name>
    <cfelse>
        <cfset Partner_Name = ''>
    </cfif>
    <cfif Len(Get_Offer.Ship_Method)>
        <cfquery name="Get_Ship_Method" datasource="#dsn#">
            SELECT
                SHIP_METHOD_ID,
                SHIP_METHOD
            FROM
                SHIP_METHOD
            WHERE 
                SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Ship_Method#">
        </cfquery>
    </cfif>
    <cfquery name="Get_Upper_Position" datasource="#dsn#">
        SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfif len (Get_Upper_Position.Upper_Position_Code)>
        <cfquery name="Get_Chief1_Name" datasource="#dsn#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Upper_Position.Upper_Position_Code#">
        </cfquery>
    </cfif>

    <cfif len(Get_Offer.Sales_Emp_Id)>
        <cfquery name="Get_Offer_Sales_Member" datasource="#dsn#">
            SELECT
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME,
                EP.POSITION_NAME,
                E.EMPLOYEE_EMAIL, 
                E.MOBILTEL,
                E.MOBILCODE
            FROM
                EMPLOYEES E
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getProject.PROJECT_EMP_ID#">
        </cfquery>
    </cfif>

    <cfquery name="Get_Money" datasource="#dsn3#">
        SELECT * FROM PBS_OFFER_MONEY WHERE ACTION_ID = #attributes.offer_id#
    </cfquery>
    <cfloop query="Get_Money">
        <cfset "Offer_Money_#Get_Money.Money_Type#" = Get_Money.Rate2>
    </cfloop>

    <cfquery name="Get_Money_Choose" dbtype="query">
        SELECT * FROM Get_Money WHERE IS_SELECTED = 1
    </cfquery>
    <cfset Offer_Money = Get_Money_Choose.Money_Type>


    <cfset Row_Start = 1>
    <cfset Row_End = 30>
    <cfset yazilan_satir=1>
    <cfif Get_Offer_Rows.RecordCount>
        <cfset Page_Count = Ceiling((Get_Offer_Rows.RecordCount)/Row_End)>
    <cfelse>
        <cfset Page_Count = 1>
    </cfif>
    <cfscript>
        sepet_total = 0;
        sepet_toplam_indirim = 0;
        sepet_total_tax = 0;
        sepet_net_total = 0;
        sepet_net_total_2 = 0;
    </cfscript>
    <cfif isdefined("attributes.method")>
        
        <form method="post" name="siparis_etiket">
            <table class="etiketForm">
                <tr>
                    <th class="formbold" style="text-align:left;">Ürün Özel Kodu</th>
                </tr>
                <tr>
                    <td>
                        <select name="offer_type">
                            <option value="0" <cfif isDefined("form.offer_type") and form.offer_type eq 0>selected</cfif>>Açık Teklif</option>
                            <option value="1" <cfif isDefined("form.offer_type") and form.offer_type eq 1>selected</cfif>>Kapalı Teklif</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align:right;">
                        <input type="hidden" name="isSubmit" value="1">
                        <input type="submit" value='Teklif Şablonu Oluştur'>
                        <button type="button" onclick="FiyatGosterGizle()">Fiyat Göster/Gizle</button>
                        <script>
                            function FiyatGosterGizle(params) {
                                var elems= document.getElementsByClassName("FiyatAlan");
                                for (var i = 0; i < elems.length; i++) {
                                    if (elems[i].style.display == "none") {
                                        elems[i].style.display = "table-cell";
                                    } else {
                                        elems[i].style.display = "none";
                                    }
                                }
                            }
                        </script>
                    </td>
                </tr>
            </table>
        </form>
    </cfif>
    <cfif isDefined("form.isSubmit")>
        <cfloop from="1" to="#Page_Count#" index="j">
            <table>
                <tr>
                    <td>
                        <table style="width:100%">
                            <tr>
                                <td colspan="2" >
                                    <table style="width:100%;" align="center" border="1">
                                        <tr>
                                            <td colspan="2" style="text-align:center"><cfif isDefined("attributes.method")><img src="<cfif isdefined("attributes.method")>http://erp.metosan.com.tr/documents/settings/3B355075-DEF5-E025-AE27746DDF7BCBF8.png<cfelse>http://erp.metosan.com.tr/documents/thumbnails/middle/A1A06B48-C977-8625-AA41F2A8941A0F13.PNG</cfif>" border="0" style="max-width: 250px;height: 88px;width: 270px;"></cfif></td>
                                            <td colspan="4" style="text-align:center;vertical-align:middle;max-width: 300px;width: 300px;"><h2 style="margin-top: 15px;">PROJE TEKLİF FORMU</h2></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width:100%; " align="center" border="1">
                                        <tr>
                                            <td><b>Firma</b></td>
                                            <td><b>:</b></td>
                                            <td colspan="4"><cfoutput>#Member_Name#</cfoutput></td>
        
                                            <td><b>Tarih</b></td>
                                            <td><b>:</b></td>
                                            <td><cfoutput>#dateTimeFormat(Get_Offer.Offer_Date, 'dd.mm.yyyy hh:nn:ss')#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td><b>Tel/Faks</b></td>
                                            <td><b>:</b></td>
                                            <td><cfif isDefined("Member_Tel")><cfoutput>#Member_Tel#</cfoutput></cfif></td>
        
                                            <td><b>E-Posta</b></td>
                                            <td><b>:</b></td>
                                            <td><cfoutput>#Get_Offer_Plus.EPOSTA#</cfoutput></td>
                                            
                                            <td><b>Ref. No</b></td>
                                            <td>:</td>
                                            <td><cfoutput>#Get_Offer.PROJECT_HEAD#<BR>#Get_Offer.PROJECT_NUMBER#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td><b>İlgili</b></td>
                                            <td><b>:</b></td>
                                            <td colspan="7"><cfoutput>#Get_Offer_Plus.ILGILI#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td><b>Konu</b></td>
                                            <td><b>:</b></td>
                                            <td colspan="7"><cfoutput>#getProject.MAIN_PROCESS_CAT# - #getProject.PROJECT_HEAD# - #getProject.PROJECT_NUMBER#</cfoutput></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <table style="width:99.4%;" align="center" border="1">
                                    <tr>
                                        <td colspan="3">
                                            <p style="margin-left:20px">
                                                Firmamızdan talep etmiş olduğunuz <cfoutput>#getProject.MAIN_PROCESS_CAT#</cfoutput> ile ilgili teklifimiz aşağıda dikkatinize sunulmuştur. Teklifimizin olumlu karşılanacağını ümit eder, çalışmalarınızda başarılar dileriz.<br>
                                                Saygılarımızla,
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:center" colspan="2">
                                            <cfif len(Get_Offer.Sales_Emp_Id)>
                                                <cfoutput>#Get_Offer_Sales_Member.Fullname#</cfoutput> <br>
                                                <cfoutput>#Get_Offer_Sales_Member.POSITION_NAME#</cfoutput>
                                            </cfif>
                                        </td>
                                        <td style="text-align:center">
                                            <cfoutput>#Get_Offer_Sales_Member.Employee_Email#</cfoutput><br>
                                            <cfoutput>+90 (#Get_Offer_Sales_Member.MobilCode#) #Get_Offer_Sales_Member.MobilTel#</cfoutput><br>
                                            www.metosan.com.tr
                                        </td>
                                    </tr>
                                </table>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="1" style="width: 98.8%;" align="center">
                            <tr>
                                <!---<td><b><cf_get_lang dictionary_id='58585.KOD'></b></td>--->
                                <td style="background-color: #79ff79;"><b>SN</b></td>
                                <td style="background-color: #79ff79; width:45%;"><b>Malzeme Adı</b></td>
                                <td style="background-color: #79ff79;"><b>Marka</b></td>
                                <td style="background-color: #79ff79;" colspan="2"><b>Miktar</b></td>  
                                <td class="FiyatAlan" style="background-color: #79ff79;"><b>Fiyat</b></td>
                                
                                <td class="FiyatAlan" style="background-color: #79ff79;"><b>Tutar</b></td>
                                <td class="FiyatAlan" style="background-color: #79ff79;"><b></b></td>
                            </tr>
                            
                            <cfoutput query="Get_Offer_Rows2" startrow="#Row_Start#" maxrows="#Row_End#">
                                <cfif not IsDefined('ilk_urun_id')><cfset ilk_urun_id=Get_Offer_Rows.PRODUCT_ID></cfif>
                               
                               
                                <tr style="line-height:10px; important!"><!---style="line-height:10px; important!" --->
                                    <td>#CurrentRow#</td>
                                    <td>                                                                                
                                         #left(PRODUCT_NAME, 60)#                                                                                   
                                    </td>
                                    <td>#left(Brand_Name,60)#</td>
                                    <td style="text-align:right;">#AMOUNT#</td>
                                    <td>#MAIN_UNIT#</td>  
                                    <td class="FiyatAlan">#tlformat(PRICE)#</td>                                                          
                                    <td class="FiyatAlan"><cfif LEN(PRICE)>#tlformat(PRICE*AMOUNT)#<CFELSE>#tlformat(0)#</cfif></td>
                                    <td class="FiyatAlan">#MONEY#</td>  
                                </tr>
                              
                            </cfoutput>
                            
            <cfif Page_Count neq j>
                </table>
                <div style="page-break-after: always"></div>
            <cfelse>
                    <cfoutput query="Get_Money">
                                    <cfif isDefined("total_#Money_Type#")>
                                        <tr>
                                            <td colspan="5"></td>
                                            <td colspan="2">
                                                <b>Toplam  Tutar</b>
                                            </td>
                                            <td>
                                                <b></b>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                                <tr>
                                <td colspan="2">
                                        <b>Bugünkü Kura Göre Genel Toplam TL Tutar</b>
                                    </td>
                                    <td>
                                        <cfoutput>
                                            <b>
                                                <cfoutput>
                                                    #Get_Offer.NETTOTAL-Get_Offer.TAX# 
                                                </cfoutput>
                                            </b> 
                                        </cfoutput>
                                    </td>
                                    <td>
                                        TL
                                    </td>
                                    <td>+KDV</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" style="width: 98.8%;" align="center">
                                <tr>
                                    <td style="color:red">
                                        <b>*** Yukarıdaki fiyatlar net olup, K.D.V. dahil değildir.</b>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                       
                        
                        <td>
                            <table border="1" style="width: 98.8%;" align="center">
                                <tr>
                                    <td><b>Notlar</b></td>
                                    <td><b>:</b></td>
                                    <td colspan="3"><cfoutput>#Get_Offer_Plus.NOTLAR#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>Teslim Yeri</b></td>
                                    <td>:</td>
                                    <td colspan="3"><cfoutput>#Get_Offer_Plus.TESLIM#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>Ödeme Şekli</b></td>
                                    <td>:</td>
                                    <td colspan="3">
                                        <cfif isDefined("Get_Paymethod")>
                                            <cfoutput>#Get_Offer_Plus.ODEME#</cfoutput>
                                        </cfif>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Opsiyon</b></td>
                                    <td>:</td>
                                    <td colspan="3"><cfoutput>#Get_Offer_Plus.OPSIYON#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>Açıklama</b></td>
                                    <td>:</td>
                                    <td colspan="3"><cfoutput>#Get_Offer_Plus.ACIKLAMA#</cfoutput></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table border="0" style="width: 98.8%;" align="center">
                            <tr>
                                <td colspan="5" style="" align="center">
                                        <h3>**** SİPARİŞLERİNİZ İÇİN YAZILI ONAY VERİNİZ ****</h3>
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </cfif>
            <cfset Row_Start = Row_End + Row_Start>
        </cfloop>
        <!--- 
        <table>
            <tr class="fixed">
                <td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
            </tr>
        </table>
        --->
        
    </cfif>
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>
