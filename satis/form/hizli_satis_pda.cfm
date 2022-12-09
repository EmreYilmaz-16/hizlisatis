
<cfparam name="attributes.offer_id" default="">
<cfparam name="attributes.event" default="add">
<cfset TekNo="Yeni Kayıt">
<cfif attributes.event eq "UPD">
    
    <cfquery name="getOffer" datasource="#dsn3#">
    select PO.OFFER_NUMBER,C.COMPANY_ID,C.FULLNAME,CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS NN,CP.PARTNER_ID,PO.OFFER_HEAD,PO.OFFER_DATE,ISNULL(PO.SHIP_METHOD,0) SHIP_METHOD,ISNULL(PO.PAYMETHOD,0) PAYMETHOD,
    PO.RECORD_DATE, PO.UPDATE_DATE,#dsn#.getEmployeeWithId( PO.RECORD_MEMBER) as RECORD_MEMBER,#dsn#.getEmployeeWithId( PO.UPDATE_MEMBER) as UPDATE_MEMBER,PO.OFFER_DETAIL,ISNULL(PO.SA_DISCOUNT,0) SA_DISCOUNT
     from PBS_OFFER AS PO
LEFT JOIN #dsn#.COMPANY AS C ON PO.COMPANY_ID=C.COMPANY_ID
LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID=PO.PARTNER_ID
WHERE OFFER_ID=#attributes.offer_id#
    </cfquery>
    
    <cfset TekNo="#getOffer.OFFER_NUMBER#">
    <cfquery name="getOfferRow" datasource="#dsn3#">
        
<!----select PRODUCT_ID,STOCK_ID,QUANTITY,PRICE,PRICE_OTHER,PRODUCT_NAME,DISCOUNT_1,OTHER_MONEY,OTHER_MONEY_VALUE,TAX,SHELF_CODE,PBS_OFFER_ROW_CURRENCY from #dsn3#.PBS_OFFER_ROW WHERE OFFER_ID=#attributes.offer_id#---->
SELECT S.STOCK_CODE
	,CASE WHEN POR.IS_VIRTUAL = 1 THEN (SELECT PRODUCT_NAME FROM #dsn3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=POR.PRODUCT_ID) COLLATE SQL_Latin1_General_CP1_CI_AS  ELSE S.PRODUCT_NAME END AS PRODUCT_NAME
    ,CASE WHEN POR.IS_VIRTUAL = 1 THEN (SELECT PRODUCT_TYPE FROM #dsn3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=POR.PRODUCT_ID)   ELSE 0 END AS PRODUCT_TYPE
	,POR.PRODUCT_ID
	,POR.STOCK_ID
	,CASE WHEN POR.IS_VIRTUAL = 1 THEN POR.UNIT COLLATE SQL_Latin1_General_CP1_CI_AS ELSE PU.MAIN_UNIT END AS MAIN_UNIT
	,PB.BRAND_NAME
	,POR.QUANTITY
	,POR.PRICE
	,POR.PRICE_OTHER	
	,POR.DISCOUNT_1
	,POR.OTHER_MONEY
	,POR.OTHER_MONEY_VALUE
	,POR.TAX
	,POR.SHELF_CODE
	,POR.PBS_OFFER_ROW_CURRENCY
	,POR.DETAIL_INFO_EXTRA
	,POR.PRODUCT_NAME2
	,PIP.PROPERTY1
	,POR.EXTRA_COST
	,POR.DELIVER_DATE
	,POR.IS_VIRTUAL
	,POR.UNIT
FROM #dsn3#.PBS_OFFER_ROW AS POR
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
LEFT JOIN #dsn3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = CASE WHEN POR.IS_VIRTUAL=1 THEN 491 ELSE S.BRAND_ID END
LEFT JOIN #dsn3#.PRODUCT_INFO_PLUS AS PIP ON PIP.PRODUCT_ID=S.PRODUCT_ID
WHERE OFFER_ID=#attributes.offer_id#
    </cfquery>
    <cfquery name="GETOFFERmONEY" datasource="#dsn3#">
        select * from PBS_OFFER_MONEY where ACTION_ID=#attributes.offer_id#
    </cfquery>
</cfif>

<style>
    body{
background:white;
    }
    .prtMoneyBox{
        text-align:right !important;
        padding:0 !important;
    }
</style>
<cfinclude template="../includes/virtual_offer_parameters.cfm">

<cf_box title="Hızlı Satış PDA #TekNo#" >
    
        <cfparam name="attributes.order_id" default="">
    <cfform method="post" action="#request.self#" name="hizliForm" id="hizliForm" autocomplete="off">
        <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5"  divLang="<img src='/images/e-pd/customer.png' style='width:35px' > ;<img src='/images/e-pd/basket.png' style='width:35px'>;<img src='/images/e-pd/sigma.png' style='width:35px'>;<img src='/images/e-pd/docs.png' style='width:35px'>;<img src='/images/e-pd/star.png' style='width:35px'>" beforeFunction="emptyFunction|TabCntFunction()|TabCntFunction()|emptyFunction|emptyFunction|">
        <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/order_header.cfm">
        </div>
        <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/basket.cfm">
        </div>
        <div id="unique_sayfa_3" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/basket_footer.cfm">
        </div>
        <div id="unique_sayfa_4" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/related_documents.cfm">
        </div>
        <div id="unique_sayfa_5" class="ui-info-text uniqueBox"><cfinclude template="../includes/hizli_erisim.cfm"></div>
    </cfform>
    
</cf_box>


<!----

<script>
 <cfinclude template="../js/hizli_satis_pda.js">
    <cfinclude template="../js/basket.js">*/
</script>

----->

<cfif attributes.event eq "UPD">
    

    <script>    
    <cfoutput>
        $(document).ready(function(){                     
                setCompany(#getOffer.COMPANY_ID#, '#getOffer.FULLNAME#',#getOffer.PARTNER_ID#,'#getOffer.NN#')           
            <cfif getOffer.PAYMETHOD neq 0>var pm=generalParamsSatis.PAY_METHODS.filter(p=>p.PAYMETHOD_ID==#getOffer.PAYMETHOD#);
                setOdemeYontem(pm[0].PAYMETHOD_ID, pm[0].PAYMETHOD, pm[0].DUE_DAY)
            </cfif>
            <cfif getOffer.SHIP_METHOD neq 0>
                var sm=generalParamsSatis.SHIP_METHODS.filter(p=>p.SHIP_METHOD_ID==#getOffer.SHIP_METHOD#)
                setSevkYontem(sm[0].SHIP_METHOD_ID, sm[0].SHIP_METHOD)
            </cfif>
                document.getElementById("offer_head").value="#getOffer.OFFER_HEAD#"
                document.getElementById("offer_date").value=date_format("#getOffer.OFFER_DATE#")
                document.getElementById("txt_disc").value=commaSplit(#getOffer.SA_DISCOUNT#)
                <cfif len(getOffer.RECORD_MEMBER)>
                var e1=document.getElementById("dvv_r");
                $(e1).show();
                document.getElementById("record_member").innerText="#getOffer.RECORD_MEMBER#"
                document.getElementById("record_inf_date").innerText= pbs_DatetimeFormat("#getOffer.RECORD_DATE#")
                </cfif>
                <cfif len(getOffer.UPDATE_MEMBER)>
                var e1=document.getElementById("dvv_ru");
                $(e1).show();
                document.getElementById("update_member").innerText="#getOffer.UPDATE_MEMBER#"
                document.getElementById("update_inf_date").innerText= pbs_DatetimeFormat("#getOffer.UPDATE_DATE#")
                </cfif>
                <cfif listFindNoCase(getOffer.OFFER_DETAIL,"1")>
                    document.getElementById("snl_teklif").setAttribute("checked","true");
                </cfif>
                <cfif listFindNoCase(getOffer.OFFER_DETAIL,"2")>
                    document.getElementById("siparis").setAttribute("checked","true");
                </cfif>
                <cfif listFindNoCase(getOffer.OFFER_DETAIL,"3")>
                    document.getElementById("sevkiyat").setAttribute("checked","true");
                    $("##sales_type_m").show();
                </cfif>
                <cfif listFindNoCase(getOffer.OFFER_DETAIL,"4")>
                    document.getElementById("sales_type_1").setAttribute("checked","true");
                    $("##sales_type_m").show();
                </cfif>
            <cfloop query="getOfferRow">
                AddRow(#PRODUCT_ID#, #STOCK_ID#, #IS_VIRTUAL#, #QUANTITY#, #PRICE#, '#PRODUCT_NAME#', #TAX#, #DISCOUNT_1#, #PRODUCT_TYPE#, '#SHELF_CODE#','#OTHER_MONEY#',#PRICE_OTHER#,#PBS_OFFER_ROW_CURRENCY#) 
            </cfloop>
            RowControlForVirtual() 
            

                
        })
    </cfoutput>

    </script>
</cfif>


<script src="/AddOns/Partner/satis/js/basket.js"></script>
<script src="/AddOns/Partner/satis/js/hizli_satis_pda.js"/>
