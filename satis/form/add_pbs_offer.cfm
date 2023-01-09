<link rel="stylesheet" href="/AddOns/Partner/satis/style/pbs_offer_pc.css">
<cfparam name="attributes.offer_id" default="">
<cf_catalystheader>
    <cfinclude template="../includes/virtual_offer_parameters.cfm">
  <cf_box>
    <cfform name="product_form">
    <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2,sayfa_3,sayfa_4"  divLang="<img src='/images/e-pd/customer.png' style='width:35px' > ;<img src='/images/e-pd/basket.png' style='width:35px'>;<img src='/images/e-pd/sigma.png' style='width:35px'>;<img src='/images/e-pd/star.png' style='width:35px'>" beforeFunction="emptyFunction|TabCntFunction()|TabCntFunction()|emptyFunction|" >
     
        <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/order_header_normal.cfm">
        </div>
        <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
            <span id="cnamear" style="margin:0;padding:0" class="pageCaption font-green-sharp bold">&nbsp;</span>
            <cfinclude template="../includes/product_list.cfm">
            <cfinclude template="../includes/basket_normal.cfm">
            
        </div>
        <div id="unique_sayfa_3" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/basket_footer_normal.cfm">
        </div>
        <div id="unique_sayfa_4" class="ui-info-text uniqueBox"><cfinclude template="../includes/hizli_erisim_pc.cfm"></div>
    </cfform>
</cf_box>

<cfif isDefined("attributes.act") and attributes.act eq "copy">
   <cfdump var="#attributes#">
    <cfif isDefined("attributes.from_offer_id") and len(attributes.from_offer_id)>
    <cfelse>
        <cfabort>
    </cfif>
    <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
    <cfelse>
        <script>
            alert("Cari Seçmeden Kopyalama Yapamazsınız")
        </script>
        <cfabort>
    </cfif>

    

    <cfquery name="getOfferRow" datasource="#dsn3#">
        DECLARE @COMPANY_ID INT = #attributes.company_id#
        DECLARE @PRICE_CAT_ID INT = #attributes.price_catid#

        SELECT POR.PRICE_OTHER
            ,POR.QUANTITY
            ,POR.OTHER_MONEY_VALUE
            ,POR.OTHER_MONEY
            ,POR.DISCOUNT_1
            ,S.STOCK_ID
            ,S.PRODUCT_CODE
            ,S.PRODUCT_NAME
            ,S.PRODUCT_ID
            ,PB.BRAND_NAME
            ,POR.IS_VIRTUAL
            ,S.TAX
            ,POR.SHELF_CODE
            ,ISNULL(PC.DETAIL,0) AS PRODUCT_TYPE
            ,ISNULL(GPA.PRICE,0) AS PSS
            ,(
                SELECT TOP 1 PCE.DISCOUNT_RATE
                FROM workcube_metosan_1.PRODUCT P
                    ,workcube_metosan_1.PRICE_CAT_EXCEPTIONS PCE
                LEFT JOIN workcube_metosan_1.PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                WHERE (
                        PCE.PRODUCT_ID = P.PRODUCT_ID
                        OR PCE.PRODUCT_ID IS NULL
                        )
                    AND (
                        PCE.BRAND_ID = P.BRAND_ID
                        OR PCE.BRAND_ID IS NULL
                        )
                    AND (
                        PCE.PRODUCT_CATID = P.PRODUCT_CATID
                        OR PCE.PRODUCT_CATID IS NULL
                        )
                    AND (
                        PCE.COMPANY_ID = @COMPANY_ID
                        OR PCE.COMPANY_ID IS NULL
                        )
                    AND P.PRODUCT_ID = s.PRODUCT_ID
                    AND ISNULL(PC.IS_SALES, 0) = 1
                    AND PCE.ACT_TYPE NOT IN (
                        2
                        ,4
                        )
                    AND PC.PRICE_CATID = @PRICE_CAT_ID
                ORDER BY PCE.COMPANY_ID DESC
                    ,PCE.PRODUCT_CATID DESC
                ) AS dsc
            ,(
                SELECT TOP 1 RATE2
                FROM (
                    SELECT MONEY
                        ,RATE2
                        ,VALIDATE_DATE
                    FROM workcube_metosan.MONEY_HISTORY
                    
                    UNION ALL
                    
                    SELECT 'TL' AS MONEY
                        ,1 AS RATE2
                        ,CONVERT(DATE, GETDATE()) AS VALIDATE_DATE
                    ) AS TT
                WHERE VALIDATE_DATE = CONVERT(DATE, GETDATE())
                    AND MONEY = ISNULL(GPA.MONEY, 'TL')
                ) AS R2
            ,GPA.*
        FROM workcube_metosan_1.PBS_OFFER_ROW AS POR
        LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
        LEFT JOIN #DSN1#.PRODUCT_BRANDS as PB ON PB.BRAND_ID=S.BRAND_ID
        LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
        LEFT JOIN (
            SELECT P.UNIT
                ,P.PRICE
                ,P.PRICE_KDV
                ,P.PRODUCT_ID
                ,P.MONEY
                ,P.PRICE_CATID
                ,P.CATALOG_ID
                ,P.PRICE_DISCOUNT
                
            FROM workcube_metosan_1.PRICE P
                ,workcube_metosan_1.PRODUCT PR
            WHERE P.PRODUCT_ID = PR.PRODUCT_ID
                AND P.PRICE_CATID = 19
                AND (
                    P.STARTDATE <= GETDATE()
                    AND (
                        P.FINISHDATE >= GETDATE()
                        OR P.FINISHDATE IS NULL
                        )
                    )
                AND ISNULL(P.SPECT_VAR_ID, 0) = 0
            ) AS GPA ON GPA.PRODUCT_ID = S.PRODUCT_ID
            AND GPA.UNIT = S.PRODUCT_UNIT_ID
        WHERE OFFER_ID = #attributes.from_offer_id#
    </cfquery>
    <cfdump var="#getOfferRow#">
    <cfquery name="getComp" datasource="#dsn3#">
        SELECT C.NICKNAME,C.FULLNAME,C.MANAGER_PARTNER_ID,C.COMPANY_ID,ISNULL(CC.PAYMETHOD_ID,0)AS PAYMETHOD_ID,CC.PRICE_CAT,ISNULL(CC.SHIP_METHOD_ID,0) AS SHIP_METHOD_ID,SPM.PAYMETHOD,SM.SHIP_METHOD,CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS NN FROM workcube_metosan.COMPANY AS C 
LEFT JOIN workcube_metosan.COMPANY_CREDIT AS CC ON CC.COMPANY_ID=C.COMPANY_ID
LEFT JOIN workcube_metosan.SETUP_PAYMETHOD AS SPM ON SPM.PAYMETHOD_ID=CC.PAYMETHOD_ID
LEFT JOIN workcube_metosan.SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID=CC.SHIP_METHOD_ID
LEFT JOIN workcube_metosan.COMPANY_PARTNER AS CP ON CP.PARTNER_ID =C.MANAGER_PARTNER_ID
WHERE C.COMPANY_ID=#attributes.company_id#
    </cfquery>
    <script>
    $(document).ready(function () {          
        <cfoutput>
            setCompany(#getComp.COMPANY_ID#, '#getComp.FULLNAME#',#getComp.MANAGER_PARTNER_ID#,'#getComp.NN#')       
        
        <cfif getComp.PAYMETHOD_ID neq 0>
            var pm=generalParamsSatis.PAY_METHODS.filter(p=>p.PAYMETHOD_ID==#getComp.PAYMETHOD_ID#);
            setOdemeYontem(pm[0].PAYMETHOD_ID, pm[0].PAYMETHOD, pm[0].DUE_DAY)
        </cfif>
        <cfif getComp.SHIP_METHOD_ID neq 0>
            var sm=generalParamsSatis.SHIP_METHODS.filter(p=>p.SHIP_METHOD_ID==#getComp.SHIP_METHOD_ID#)
            setSevkYontem(sm[0].SHIP_METHOD_ID, sm[0].SHIP_METHOD)
        </cfif>
    </cfoutput>
})
    </script>
</cfif>


<script src="/AddOns/Partner/satis/js/basket_pc.js"></script>
<script src="/AddOns/Partner/satis/js/hizli_satis_pc.js"></script>
<script src="/AddOns/Partner/satis/js/tube_functions.js"></script>
<script src="/AddOns/Partner/satis/js/hydrolic_functions.js"></script>
<script src="/AddOns/Partner/satis/js/virtual_product_functions.js"></script>


    <link rel="stylesheet" href="/JS/codemirror-5.65.0/lib/codemirror.css">
    <script src="/JS/codemirror-5.65.0/lib/codemirror.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/edit/matchbrackets.js"></script>
    <script src="/JS/codemirror-5.65.0/mode/sql/sql.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/show-hint.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/sql-hint.js"></script>


