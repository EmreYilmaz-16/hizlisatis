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
<cfquery name="getPo" datasource="#dsn3#">
	SELECT *,VPO.QUANTITY-ISNULL(RR.RESULT_AMOUNT,0) AS BAKIYE FROM workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS 
AS VPO 
LEFT JOIN (
SELECT SUM(RESULT_AMOUNT) RESULT_AMOUNT,P_ORDER_ID FROM workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS_RESULT  GROUP BY P_ORDER_ID
) AS RR ON RR.P_ORDER_ID=VPO.V_P_ORDER_ID
 WHERE VPO.V_P_ORDER_ID=#attributes.VP_ORDER_ID#
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
        	SELECT *,VPO.QUANTITY-ISNULL(RR.RESULT_AMOUNT,0) AS BAKIYE FROM workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS 
AS VPO 
LEFT JOIN (
SELECT SUM(RESULT_AMOUNT) RESULT_AMOUNT,P_ORDER_ID FROM workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS_RESULT  GROUP BY P_ORDER_ID
) AS RR ON RR.P_ORDER_ID=VPO.V_P_ORDER_ID
 WHERE VPO.V_P_ORDER_ID=#attributes.VP_ORDER_ID#
    </cfquery>
<cfif not isDefined("attributes.isFromKarma")>
    <cfquery name="getOffer" datasource="#dsn3#">
        select POR.*,DETAIL from PBS_OFFER_ROW  AS POR 
        LEFT JOIN STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
        LEFT JOIN #dsn1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID 
        WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
    </cfquery>
    <cfquery name="getOfferMain" datasource="#dsn3#">
        SELECT * FROM  PBS_OFFER WHERE OFFER_ID='#getOffer.OFFER_ID#'
    </cfquery>
    <cfelse>
         
    <cfquery name="getProductionOrders" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#getProductionOrders.REL_V_P_ORDER_ID#
    </cfquery>
        <cfquery name="getOffer" datasource="#dsn3#">
            select POR.*,DETAIL from PBS_OFFER_ROW  AS POR 
            LEFT JOIN STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID
            LEFT JOIN #dsn1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID 
            WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
        </cfquery>
        <cfquery name="getOfferMain" datasource="#dsn3#">
            SELECT * FROM  PBS_OFFER WHERE OFFER_ID='#getOffer.OFFER_ID#'
        </cfquery>
</cfif>
<cfform method="post" name="production_form" id="production_form" onsubmit="event.preventDefault()">
    <cfoutput>
        <input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
        <input type="hidden" name="main_product_id" id="main_product_id" value="#getProductionOrders.STOCK_ID#">
        <input type="hidden" name="UNIQUE_RELATION_ID" id="UNIQUE_RELATION_ID" value="#getProductionOrders.UNIQUE_RELATION_ID#">
        <input type="hidden" name="price_cat" id="price_cat" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="#getOfferMain.PRICE_CAT_ID#">
        <input type="hidden" name="company_id" id="company_id" value="#getOfferMain.COMPANY_ID#">
        <input type="hidden" name="company_name" id="company_name" value="#getOfferMain.COMPANY_ID#">
        <input type="hidden" name="vpoorderid" id="vpoorderid" value="#attributes.VP_ORDER_ID#">
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
            
            <cfinclude template="../includes/basket_normal.cfm">
        </cfif>     
<input type="hidden" name="total_price" id="total_price">
    </cfoutput>
    <cf_box title="Üretim Sonuçları">
		<cf_grid_list >
			<tr>
				<th>#</th>
				<th>Sanal Üretim Sonucu</th>
				<th>Gerçek Üretim Sonucu</th>
				<th>Miktar</th>
                <th>Kaydeden</th>
                <th>Kayıt Tarihi</th>
			</tr>
	<cfquery name="GETrES" datasource="#DSN3#">
         SELECT POR.RESULT_NO,POR.RESULT_NUMBER,POR.RECORD_DATE,#dsn#.getEmployeeWithId(POR.RECORD_EMP) RECORD_EMP,VPOR.P_ORDER_RESULT_ID,VPOR.RESULT_AMOUNT FROM  #DSN3#.VIRTUAL_PRODUCTION_ORDERS_RESULT  AS VPOR 
LEFT JOIN #DSN3#.PRODUCTION_ORDER_RESULTS AS POR ON VPOR.REAL_RESULT_ID=POR.PR_ORDER_ID

 WHERE VPOR.P_ORDER_ID=#attributes.VP_ORDER_ID#
    </cfquery>
    <cfoutput>
    <cfloop query="GETrES">
        <tr>
            <td>
                #CurrentRow#
            </td>
            <td>
                VPUS-#P_ORDER_RESULT_ID#
            </td>
            <td>
                #RESULT_NO#
            </td>
            <td>
                #RESULT_AMOUNT#
            </td>
            <td>
                #RECORD_EMP#
            </td>
            <td>
                #dateFormat(RECORD_DATE,"dd/mm/yyyy")#
            </td>
        </tr>
    </cfloop>
</cfoutput>
		</cf_grid_list>
	</cf_box>

    
    <cfif GETrES.recordCount eq 0>
    <button type="button" class="btn btn-warning" onclick="saveVirtual(<cfoutput>#getVirtualProduct.product_type#,#getProductionOrders.IS_FROM_VIRTUAL#</cfoutput>)">Kaydet</button>
    <button type="button" class="btn btn-success" onclick="CloseProductionOrders(<cfoutput>#attributes.VP_ORDER_ID#</cfoutput>)">Üretimi Sonlandır</button>
    <button type="button" class="btn btn-danger" onclick="DeleteProductionOrders(<cfoutput>#attributes.VP_ORDER_ID#</cfoutput>)">Sil</button>
</cfif>
</cfform>

    <script src="/AddOns/Partner/production/js/production_order.js"></script>
