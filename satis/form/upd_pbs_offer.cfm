

<script>
    function CalisanKontrolPbs(){
        <cfquery name="isactpbsp" datasource="#dsn#">
            SELECT * FROM WRK_SESSION WHERE ACTION_PAGE_Q_STRING LIKE '%#CGI.QUERY_STRING#%' AND USERID <> #session.ep.userid#
        </cfquery>
        
        <cfset CalisanPersoneller="">
        var CalisanPersoneller=[<cfloop query="isactpbsp"><CFSET ACS=""><cfset ACS="#left(NAME,1)#.#left(SURNAME,1)#">'<cfoutput>#ACS#</cfoutput>'<cfset CalisanPersoneller="#CalisanPersoneller# , #ACS# "></cfloop>]
        <cfif isactpbsp.recordCount>
            //HataGoster('Bu sayfada Çalışan var <cfoutput>#CalisanPersoneller#</cfoutput>','danger',1500)
            $("#btnsave2").hide();
            $("#btnsave").hide();
            $("#btnsil").hide()
            console.log(CalisanPersoneller)
            var span=document.createElement("div")

span.setAttribute("style","color:red;font-weight:bold")
span.innerText="Bu Sayfada Çalışan Var !"
$("#btnsave2").parent()[0].appendChild(span)
$("#btnsave").parent()[0].appendChild(span)
for(let i=0;i<CalisanPersoneller.length;i++){
    var d=document.createElement("div")
d.innerText=CalisanPersoneller[i];
d.setAttribute("style","border-radius:50% !important ;max-width:25%;padding:5px")
d.setAttribute("class","btn btn-danger")

$("#btnsave2").parent().append(d)  
$("#btnsave").parent().append(d)  
}
return false
        </cfif>
        return true;
    }
</script>

<link rel="stylesheet" href="/AddOns/Partner/satis/style/pbs_offer_pc.css">
<cfparam name="attributes.offer_id" default="">
<cfparam name="attributes.defaultOpen" default="sayfa_1">
<cfif attributes.event eq "UPD">
    
    <cfquery name="getOffer" datasource="#dsn3#">
SELECT PO.OFFER_NUMBER
	,PO.OFFER_DESCRIPTION
	,C.COMPANY_ID
	,C.FULLNAME
	,CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS NN
	,CP.PARTNER_ID
	,PO.OFFER_HEAD
	,PO.OFFER_DATE
    ,ISNULL(PO.PROJECT_ID,0) PROJECT_ID
	,ISNULL(PO.SHIP_METHOD, 0) SHIP_METHOD
	,ISNULL(PO.PAYMETHOD, 0) PAYMETHOD
	,PO.RECORD_DATE
	,PO.UPDATE_DATE
	,#dsn#.getEmployeeWithId(PO.RECORD_MEMBER) AS RECORD_MEMBER
	,#dsn#.getEmployeeWithId(PO.UPDATE_MEMBER) AS UPDATE_MEMBER
	,PO.OFFER_DETAIL
	,ISNULL(PO.SA_DISCOUNT, 0) SA_DISCOUNT
FROM PBS_OFFER AS PO
LEFT JOIN #dsn#.COMPANY AS C ON PO.COMPANY_ID = C.COMPANY_ID
LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = PO.PARTNER_ID
WHERE OFFER_ID = #attributes.offer_id#
    </cfquery>
    
    <cfset TekNo="#getOffer.OFFER_NUMBER#">
    <cfquery name="getProject" datasource="#DSN#">
        select PROJECT_NUMBER+'-'+PROJECT_HEAD as PROJECT_HEAD,PROJECT_ID from workcube_metosan.PRO_PROJECTS where PROJECT_ID=#getOffer.PROJECT_ID#
    </cfquery>
    <cfquery name="getOfferRow" datasource="#dsn3#">
        

        SELECT S.STOCK_CODE
	,CASE WHEN POR.IS_VIRTUAL = 1 THEN (SELECT PRODUCT_NAME FROM #dsn3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=POR.PRODUCT_ID) COLLATE SQL_Latin1_General_CP1_CI_AS  ELSE S.PRODUCT_NAME END AS PRODUCT_NAME
    ,CASE WHEN POR.IS_VIRTUAL = 1 THEN (SELECT PRODUCT_TYPE FROM #dsn3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=POR.PRODUCT_ID)   ELSE 0 END AS PRODUCT_TYPE
	,POR.PRODUCT_ID
	,POR.STOCK_ID
	,CASE WHEN POR.IS_VIRTUAL = 1 THEN POR.UNIT COLLATE SQL_Latin1_General_CP1_CI_AS ELSE PU.MAIN_UNIT END AS MAIN_UNIT
	,CASE WHEN POR.IS_VIRTUAL =1 THEN 0 ELSE ISNULL(S.IS_KARMA,0) END AS IS_KARMA
    ,CASE WHEN POR.IS_VIRTUAL =1 THEN 0 ELSE ISNULL(S.IS_KARMA_SEVK,0) END AS IS_KARMA_SEVK
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
    ,POR.DESCRIPTION
    ,POR.UNIQUE_RELATION_ID
    ,ISNULL(POR.CONVERTED_STOCK_ID,0) CONVERTED_STOCK_ID
    ,D.DEPARTMENT_HEAD+' '+SL.COMMENT AS DELLOC
    ,CASE WHEN POR.IS_VIRTUAL =1 THEN 1 ELSE S.IS_PRODUCTION END AS IS_PRODUCTION
FROM #dsn3#.PBS_OFFER_ROW AS POR
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN=1
LEFT JOIN #dsn3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = CASE WHEN POR.IS_VIRTUAL=1 THEN 491 ELSE S.BRAND_ID END
LEFT JOIN (SELECT TOP 1 * FROM  #dsn3#.PRODUCT_INFO_PLUS) AS PIP ON PIP.PRODUCT_ID=S.PRODUCT_ID
LEFT JOIN #dsn#.DEPARTMENT AS D ON D.DEPARTMENT_ID=POR.DELIVER_DEPT
LEFT JOIN #dsn#.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=POR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=POR.DELIVER_DEPT

WHERE POR.OFFER_ID=#attributes.offer_id#
ORDER BY POR.OFFER_ROW_ID
    </cfquery>
    
    <cfquery name="GETOFFERmONEY" datasource="#dsn3#">
        select * from PBS_OFFER_MONEY where ACTION_ID=#attributes.offer_id#
    </cfquery>
</cfif>
<cfset pageHead ="SANAL TEKLİFLER - #getOffer.OFFER_NUMBER#">


        <cfparam name="attributes.offer_id" default="">
        <cf_catalystheader>
            <cfinclude template="../includes/virtual_offer_parameters.cfm">
          <cf_box>
            <cfform name="product_form">
            <cf_tab defaultOpen="#attributes.defaultOpen#" divId="sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5"  divLang="<img src='/images/e-pd/customer.png' style='width:35px' > ;<img src='/images/e-pd/basket.png' style='width:35px'>;<img src='/images/e-pd/sigma.png' style='width:35px'>;<img src='/images/e-pd/docs.png' style='width:35px'>;<img src='/images/e-pd/star.png' style='width:35px'>" beforeFunction="emptyFunction|TabCntFunction()|TabCntFunction()|emptyFunction|emptyFunction|">
             
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
                 <div id="unique_sayfa_4" class="ui-info-text uniqueBox">
                    <cfinclude template="../includes/related_documents.cfm">
                </div>
                <div id="unique_sayfa_5" class="ui-info-text uniqueBox"><cfinclude template="../includes/hizli_erisim_pc.cfm"></div>
            </cfform>
        </cf_box>
        
        <cfif attributes.event eq "UPD">
    

            <script>    
            <cfoutput>
                $(document).ready(function(){                     
                        setCompany(#getOffer.COMPANY_ID#, '#getOffer.FULLNAME#',#getOffer.PARTNER_ID#,'#getOffer.NN#',0)      
                        setProjects('#getProject.PROJECT_ID#','#getProject.PROJECT_HEAD#')     
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
                        document.getElementById("offer_desc").value='#EncodeForJavaScript(getOffer.OFFER_DESCRIPTION)#'
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
                        
                        console.log("Burada 2")
                    <cfloop query="getOfferRow">
                        <CFSET EMANUEL=0>
                        <cfset lastCost = 0>
                        <cfset Pname="">
                        
          <CFIF getOfferRow.IS_VIRTUAL neq 1>
                        
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
                        
                            <CFIF getOfferRow.PROPERTY1 EQ "MANUEL">
                                <CFSET EMANUEL=1>
                            </CFIF>
        </cfif>
                        <cfif session.ep.userid neq 1146>
                        AddRow(
                            #PRODUCT_ID#,
                            #STOCK_ID#,
    '#STOCK_CODE#',
    '#getOfferRow.BRAND_NAME#',
    #getOfferRow.IS_VIRTUAL#,
    #getOfferRow.QUANTITY#,
    #getOfferRow.PRICE#,
    '#EncodeForJavaScript(getOfferRow.PRODUCT_NAME)#',
    #getOfferRow.TAX#,
    #getOfferRow.DISCOUNT_1#,
    #getOfferRow.PRODUCT_TYPE#,
    '#getOfferRow.SHELF_CODE#',
    '#getOfferRow.OTHER_MONEY#',
    #getOfferRow.PRICE_OTHER#,
    #getOfferRow.PBS_OFFER_ROW_CURRENCY#,
    #EMANUEL#,
    #lastCost#,
    '#getOfferRow.MAIN_UNIT#',
    '#getOfferRow.PRODUCT_NAME2#',
    '#getOfferRow.DETAIL_INFO_EXTRA#',
    1,
0,
'#dateFormat(getOfferRow.DELIVER_DATE,"yyyy-mm-dd")#',
#getOfferRow.IS_PRODUCTION#,
'#getOfferRow.UNIQUE_RELATION_ID#',
'#DESCRIPTION#',
'#DELLOC#',
#CONVERTED_STOCK_ID#,
#IS_KARMA#,
#IS_KARMA_SEVK#
)
<cfelse>
                            AddRow_pbso(
                            #PRODUCT_ID#,
                            #STOCK_ID#,
    '#STOCK_CODE#',
    '#getOfferRow.BRAND_NAME#',
    #getOfferRow.IS_VIRTUAL#,
    #getOfferRow.QUANTITY#,
    #getOfferRow.PRICE#,
    '#getOfferRow.PRODUCT_NAME#',
    #getOfferRow.TAX#,
    #getOfferRow.DISCOUNT_1#,
    #getOfferRow.PRODUCT_TYPE#,
    '#getOfferRow.SHELF_CODE#',
    '#getOfferRow.OTHER_MONEY#',
    #getOfferRow.PRICE_OTHER#,
    #getOfferRow.PBS_OFFER_ROW_CURRENCY#,
    #EMANUEL#,
    #lastCost#,
    '#getOfferRow.MAIN_UNIT#',
    '#getOfferRow.PRODUCT_NAME2#',
    '#getOfferRow.DETAIL_INFO_EXTRA#',
    1,
0,
'#dateFormat(getOfferRow.DELIVER_DATE,"yyyy-mm-dd")#',
#getOfferRow.IS_PRODUCTION#,
'#getOfferRow.UNIQUE_RELATION_ID#',
'#DESCRIPTION#',
'#DELLOC#',
#CONVERTED_STOCK_ID#,
#IS_KARMA#,
#IS_KARMA_SEVK#
)
</cfif>                 
                       
                      //  AddRow(#PRODUCT_ID#, #STOCK_ID#, 0, #QUANTITY#, #PRICE#, '#PRODUCT_NAME#', #TAX#, #DISCOUNT_1#, 0, '#SHELF_CODE#','#OTHER_MONEY#',#PRICE_OTHER#,#PBS_OFFER_ROW_CURRENCY#,'#DESCRIPTION#') 
                    </cfloop>
                    RowControlForVirtual();
                    setDoom();
                    
                })
            </cfoutput>
            </script>
        </cfif>

        <script src="/AddOns/Partner/satis/js/basket_pc.js"></script>
        <script src="/AddOns/Partner/satis/js/hizli_satis_pc.js"></script>
      <script src="/AddOns/Partner/satis/js/tube_functions.js"></script>
        <script src="/AddOns/Partner/satis/js/hydrolic_functions.js"></script>
        <script src="/AddOns/Partner/satis/js/virtual_product_functions.js"></script>