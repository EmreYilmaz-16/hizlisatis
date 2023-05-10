<cfinclude template="/AddOns/Partner/satis/Includes/virtual_offer_parameters.cfm">
<cfquery name="getMoney" datasource="#dsn#">
  SELECT 
(SELECT RATE1 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
(SELECT RATE2 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE2,
SM.MONEY
FROM workcube_metosan.SETUP_MONEY AS SM WHERE SM.PERIOD_ID=#session.ep.period_id#
</cfquery>
<script>
    var moneyArr=[
        <cfoutput query="getMoney">
            {
                MONEY:"#MONEY#",
                RATE1:"#RATE1#",
                RATE2:"#RATE2#",
            },
        </cfoutput>
    ]
</script>
<cfoutput query="getMoney">
    <input type="hidden" id="hidden_rd_money_#CurrentRow#" name="hidden_rd_money_#CurrentRow#" value="#MONEY#">
    <input type="hidden" id="txt_rate1_#CurrentRow#" name="txt_rate1_#CurrentRow#" value="#RATE1#">
    <input type="hidden" id="txt_rate2_#CurrentRow#" name="txt_rate2_#CurrentRow#" value="#RATE2#">
</cfoutput>
    <cfquery name="getOffer" datasource="#dsn3#">
        select POR.*,DETAIL from PBS_OFFER_ROW  AS POR 
        LEFT JOIN STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
        LEFT JOIN #dsn1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID 
        WHERE UNIQUE_RELATION_ID='#getPor.UNIQUE_RELATION_ID#'
    </cfquery>
    <cfquery name="getOfferMain" datasource="#dsn3#">
        SELECT * FROM  PBS_OFFER WHERE OFFER_ID='#getOffer.OFFER_ID#'
    </cfquery>
<cfform method="post" name="production_form" id="production_form" onsubmit="event.preventDefault()">
    <cfoutput>
        <input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
        <input type="hidden" name="main_product_id" id="main_product_id" value="#getOffer.STOCK_ID#">
        <input type="hidden" name="UNIQUE_RELATION_ID" id="UNIQUE_RELATION_ID" value="#getOffer.UNIQUE_RELATION_ID#">
        <input type="hidden" name="price_cat" id="price_cat" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="company_id" id="company_id" value="#getOfferMain.COMPANY_ID#">
        <input type="hidden" name="company_name" id="company_name" value="#getOfferMain.COMPANY_ID#">        
            <cfif getPor.KKD eq 1>
                <cfinclude template="/AddOns/partner/Production/includes/basket_tube.cfm">
            <cfelseif getPor.KKD eq 2>
                <cfinclude template="/AddOns/partner/Production/includes/basket_hydrolik.cfm">
            <cfelseif getPor.KKD eq 3>
                <cfinclude template="/AddOns/partner/Production/includes/basket_pump.cfm">
            </cfif>
     
<input type="hidden" name="total_price" id="total_price">
    </cfoutput>    
</cfform>
<script src="/AddOns/Partner/production/js/production_order.js"></script>
