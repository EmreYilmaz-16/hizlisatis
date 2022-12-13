<cfinclude template="/AddOns/Partner/satis/Includes/virtual_offer_parameters.cfm">
<cfquery name="getMoney" datasource="#dsn#">
    SELECT MONEY,RATE1, EFFECTIVE_SALE AS RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
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


    <cfquery name="getProductionOrders" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.VP_ORDER_ID#
    </cfquery>

    <cfquery name="getOffer" datasource="#dsn3#">
        SELECT * FROM  PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
    </cfquery>
    <cfquery name="getOfferMain" datasource="#dsn3#">
        SELECT * FROM  PBS_OFFER WHERE OFFER_ID='#getOffer.OFFER_ID#'
    </cfquery>

<cfform method="post" name="production_form" id="production_form" onsubmit="event.preventDefault()">
    <cfoutput>
        <input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
        <input type="hidden" name="main_product_id" id="main_product_id" value="#getProductionOrders.STOCK_ID#">
        <input type="hidden" name="UNIQUE_RELATION_ID" id="UNIQUE_RELATION_ID" value="#getProductionOrders.UNIQUE_RELATION_ID#">
        <input type="hidden" name="price_cat" id="price_cat" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="company_id" id="company_id" value="#getOfferMain.COMPANY_ID#">
        <input type="hidden" name="company_name" id="company_name" value="#getOfferMain.COMPANY_ID#">
        <cfif getProductionOrders.IS_FROM_VIRTUAL EQ 1>
        <cfquery name="getVirtualProduct"  datasource="#dsn3#">
            SELECT * FROM #dsn3#.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#getProductionOrders.STOCK_ID#
        </cfquery>
        <input type="hidden" name="product_type" id="product_type" value="#getVirtualProduct.product_type#">


            <cfif getVirtualProduct.product_type eq 1>
                <cfinclude template="../includes/basket_tube.cfm">
            <cfelseif getVirtualProduct.product_type eq 2>
                <cfinclude template="../includes/basket_hydrolik.cfm">
            <cfelseif getVirtualProduct.product_type eq 3>
                <cfinclude template="../includes/basket_pump.cfm">
            </cfif>
        <cfelse>
            <cfinclude template="../includes/bakset_normal.cfm">
        </cfif>     
<input type="hidden" name="total_price" id="total_price">
    </cfoutput>
    <button type="button" class="btn btn-warning" onclick="saveVirtual(<cfoutput>#getVirtualProduct.product_type#</cfoutput>)">Kaydet</button>
    <button type="button" class="btn btn-success" onclick="CloseProductionOrders(<cfoutput>#attributes.VP_ORDER_ID#</cfoutput>)">Üretimi Sonlandır</button>
</cfform>
<script src="/AddOns/Partner/production/js/production_order.js"></script>