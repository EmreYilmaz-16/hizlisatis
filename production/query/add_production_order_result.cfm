<cfdump var="#attributes#">
<cfquery name="getVirtualProductionOrder" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>
<cfif getVirtualProductionOrder.IS_FROM_VIRTUAL eq 1>
    <cfquery name="getOfferData" datasource="#dsn3#">
        SELECT PC.DETAIL FROM workcube_metosan_1.PBS_OFFER_ROW AS POR 
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=POR.STOCK_ID 
LEFT JOIN workcube_metosan_1.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
WHERE  UNIQUE_RELATION_ID=#getVirtualProductionOrder.UNIQUE_RELATION_ID#
    </cfquery>
    <cfset VirmanList="3,5,6,7,8,9">
    <cfif  listFind(VirmanList,getOfferData.DETAIL)>
        <cfinclude template="makeVirman.cfm">
        <cfabort>
    <cfelse>
        <cfinclude template="add_virtual_production_order_result.cfm">
    </cfif> 
    
<cfelse>
    <cfinclude template="realproduction_res.cfm">
</cfif>



<cfset attributes.PRODUCT_AMOUNT_1_0="#getVirtualProductionOrder.QUANTITY#">
<cfinclude template="/AddOns/Partner/production/Includes/close_porders.cfm">

<cfset attributes.process_cat=111>
<cfset attributes.process_stage=26>
<cfset attributes.employee_id_=session.ep.userid>
<cfset attributes.station_id_=pws_id>
<cfset attributes.upd_id=PARTNER_P_ORDER_ID>
<cfinclude template="/AddOns/Partner/production/Includes/add_prod_order_result.cfm">

<cfset attributes.pr_order_id =ADD_PRODUCTION_ORDER.MAX_ID>
<cfinclude template="/AddOns/Partner/production/Includes/add_ezgi_prod_order_result_stock.cfm">


<cfquery name="UP" datasource="#DSN3#">
    UPDATE VIRTUAL_PRODUCTION_ORDERS_RESULT SET REAL_RESULT_ID =  #RESULT_ID_PBS_ID# WHERE P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>

<cfquery name="up1" datasource="#dsn3#">
update  #dsn3#.PBS_OFFER_ROW set PBS_OFFER_ROW_CURRENCY=-6 WHERE UNIQUE_RELATION_ID=(select UNIQUE_RELATION_ID from #dsn3#.VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#)

</cfquery>

<cfquery name="up2" datasource="#dsn3#">
   
    update #dsn3#.ORDER_ROW set ORDER_ROW_CURRENCY=-6 WHERE UNIQUE_RELATION_ID=(select UNIQUE_RELATION_ID from #dsn3#.VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#)
    </cfquery>

<script>
    window.opener.location.reload();
    this.close();
</script>