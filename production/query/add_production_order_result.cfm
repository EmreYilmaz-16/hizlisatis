<cfinclude template="add_virtual_production_order_result.cfm">
<cfinclude template="/AddOns/Partner/production/Includes/close_porders.cfm">

<cfset attributes.process_cat=111>
<cfset attributes.process_stage=26>
<cfset attributes.employee_id_=session.ep.userid>
<cfset attributes.station_id_=pws_id>
<cfset attributes.upd_id=PARTNER_P_ORDER_ID>
<cfinclude template="/AddOns/Partner/production/Includes/add_prod_order_result.cfm">

<cfset attributes.pr_order_id =ADD_PRODUCTION_ORDER.MAX_ID>
<cfinclude template="/AddOns/Partner/production/Includes/add_ezgi_prod_order_result_stock.cfm">