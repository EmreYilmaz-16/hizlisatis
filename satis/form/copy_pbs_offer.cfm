<cfform method="post" action="#request.self#?fuseaction=sales.list_pbs_offer&event=add&act=copy" name="frm_search" id="frm_search">
    <input type="hidden" name="from_offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
    <div class="form-group" id="item_company">
        <label class="col col-12 col-xs-12">Cari Hesap</label>
        <div class="col col-12 col-xs-12">
            <div class="input-group">
                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                <input type="hidden" name="price_catid" id="price_catid" value="">						
                <input type="hidden" name="company_id" id="company_id" value="">
                <input type="hidden" name="employee_id" id="employee_id" value="">
                <input type="text" name="company" id="company" value="" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','consumer_id,company_id,employee_id','','3','250');" autocomplete="off">
                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&field_name=frm_search.company&field_emp_id=frm_search.employee_id&field_consumer=frm_search.consumer_id&field_member_name=frm_search.company&field_comp_name=frm_search.company&field_comp_id=frm_search.company_id&select_list=2,3,1,9&keyword='+encodeURIComponent(document.frm_search.company.value));"></span>
            </div>
        </div>        
    </div>
    <input type="hidden" name="is_submit" value="1">
    <button class="btn btn-success" type="button" onclick="SentForm()">Kopyala</button>
</cfform>


<cfif isDefined("attributes.is_submit")>
    <cfdump var="#attributes#">
    <cfquery name="getOfferRow" datasource="#dsn3#">
        DECLARE @COMPANY_ID INT = #attributes.company_id#
        DECLARE @PRICE_CAT_ID INT = #attributes.price_catid#

        SELECT POR.PRICE_OTHER
            ,POR.QUANTITY
            ,POR.OTHER_MONEY_VALUE
            ,POR.OTHER_MONEY
            ,ISNULL(POR.DISCOUNT_1,0) AS DISCOUNT_1
            ,S.STOCK_ID
            ,S.PRODUCT_CODE
            ,S.PRODUCT_NAME
            ,S.PRODUCT_ID
            ,PB.BRAND_NAME
            ,PO.IS_VIRTUAL
            ,S.TAX
            ,PO.SHELF_CODE
            ,ISNULL(PC.DETAIL,0) AS PRODUCT_TYPE
            ,ISNULL(GPA.PRICE,0) AS PSS
            ,ISNULL((
                SELECT TOP 1 PCE.DISCOUNT_RATE
                FROM #DSN3#.PRODUCT P
                    ,#DSN3#.PRICE_CAT_EXCEPTIONS PCE
                LEFT JOIN #DSN3#.PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
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
                ),0) AS dsc
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
        FROM #DSN3#.PBS_OFFER_ROW AS POR
        LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
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
                
            FROM #DSN3#.PRICE P
                ,#DSN3#.PRODUCT PR
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
        WHERE OFFER_ID = #attributes.OFFER_ID#
    </cfquery>
    <cfdump var="#getOfferRow#">
    <cfoutput query="getOfferRow">
        <script>
            AddRowA(
  #PRODUCT_ID#,
  #STOCK_ID#,
  '#PRODUCT_CODE#',
  '#BRAND_NAME#',
  #IS_VIRTUAL#,
  #QUANTITY#,
  #PSS#,
  '#PRODUCT_NAME#',
  #TAX#,
  <cfif len(dsc)>#DSC#<cfelse>0</cfif>,
  #PRODUCT_TYPE#,
  '#SHELF_CODE#',
  '#OTHER_MONEY#',
  price_other,
  currency = "-6",
  is_manuel = 0,
  cost = 0,
  product_unit = "Adet",
  product_name_other = "",
  detail_info_extra = "",
  fc = 0,
  rowNum = "",
  deliver_date = "",
  is_production = 0,
  row_uniq_id = ""
)
        </script>
    </cfoutput>
</cfif>
<script src="/AddOns/Partner/satis/js/coppyOffer.js"></script>