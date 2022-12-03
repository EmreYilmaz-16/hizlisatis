<cfinclude template="/AddOns/Partner/satis/Includes/virtual_offer_parameters.cfm">

	<cfquery name="getProductionOrders" datasource="#dsn3#">
		SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.VP_ORDER_ID#
	</cfquery>

	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT * FROM  PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#getProductionOrders.UNIQUE_RELATION_ID#'
	</cfquery>

<cfform method="post">
	<cfoutput>
		<input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
		<cfif getProductionOrders.IS_FROM_VIRTUAL EQ 1>
		<cfquery name="getVirtualProduct"  datasource="#dsn3#">
			SELECT * FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#getProductionOrders.STOCK_ID#
		</cfquery>
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

	</cfoutput>
</cfform>
<script>
	function openProductPopup(question_id,from_row=0){
		openBoxDraggable("http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=METOSAN%20SATICI%20F%C4%B0YAT%20L%C4%B0STES%C4%B0%20A&PRICE_CATID=19&company_id=22143&company_name=pbs&question_id="+question_id)
	}

	function setRow(product_id,stock_id,product_name,question_id,barcode,main_unit,price,quantity){
		console.log(arguments);
		$("#PRODUCT_NAME_"+question_id).val(product_name);
		$("#STOCK_ID_"+question_id).val(stock_id);
		$("#PRODUCT_ID_"+question_id).val(product_id);
		$("#PRICE_"+question_id).val(price);
		$("#BARKODE_"+question_id).val(barcode);
		$("#AMOUNT_"+question_id).val(quantity);
		$("#MAIN_UNIT_"+question_id).text(main_unit)

	}


	function hesapla(type){

	}
</script>