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

<cfform method="post" name="production_form" id="production_form">
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
	<button type="button" class="btn btn-warning" onclick="saveVirtual()">Kaydet</button>
	<button type="button" class="btn btn-success" onclick="CloseProductionOrders()">Üretimi Sonlandır</button>
</cfform>
<script>
	function openProductPopup(question_id,from_row=0){
		  var cp_id=document.getElementById("company_id").value;
          var cp_name=document.getElementById("company_id").value;

          var p_cat=document.getElementById("PRICE_CATID").value;
          var p_cat_id=document.getElementById("PRICE_CATID").value;
        openBoxDraggable("http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat="+p_cat+"&PRICE_CATID="+p_cat_id+"&company_id="+cp_id+"&company_name="+cp_name+"&question_id="+question_id)
	}

	function setRow(product_id,stock_id,product_name,question_id,barcode,main_unit,price,quantity,discount,money){
		console.log(arguments);
		$("#PRODUCT_NAME_"+question_id).val(product_name);
		$("#STOCK_ID_"+question_id).val(stock_id);
		$("#PRODUCT_ID_"+question_id).val(product_id);
		$("#PRICE_"+question_id).val(price);
		$("#BARKODE_"+question_id).val(barcode);
		$("#AMOUNT_"+question_id).val(quantity);
		$("#MAIN_UNIT_"+question_id).text(main_unit)
		$("#DISCOUNT_"+question_id).val(discount)
        $("#MONEY_"+question_id).val(discount)
		Hesapla(1)
	}


function Hesapla(type){
    var TotalPrice=0;
   if(type==1){
    var questions=generalParamsSatis.Questions.filter(p=>p.QUESTION_PRODUCT_TYPE==1)
    questions.forEach(function(el,ix){
    console.log(el.QUESTION_ID)
    console.log("PRICE_"+el.QUESTION_ID)
    var price=document.getElementById("PRICE_"+el.QUESTION_ID).value
    var quantity=document.getElementById("AMOUNT_"+el.QUESTION_ID).value
    var discount=document.getElementById("DISCOUNT_"+el.QUESTION_ID).value
    if(price.length ==0) price=0;
    if(quantity.length ==0) quantity=0;
    if(discount.length ==0) discount=0;
	quantity=filterNum(quantity);
    price=parseFloat(price)
    quantity=parseFloat(quantity)
    discount=parseFloat(discount)
    console.log("Price="+price+" Quantity="+quantity+" Discount="+discount)
    TotalPrice+=DegerLeriHesapla(price,quantity,discount)  
    console.log(DegerLeriHesapla(price,quantity,discount))


})}

document.getElementById("total_price").value=TotalPrice;
}
function DegerLeriHesapla(p,d,q){
    var indirim_tutari=0;
    indirim_tutari=(p*q)/100
    var indirimli_fiyat=p-indirim_tutari
    var tutar=indirimli_fiyat*d
   //return p+" ** "+q+" ** "+d+" ** "+indirim_tutari+" ** "+indirimli_fiyat+" ** "+tutar;
    return tutar;
}

function GetBasketData(){
var questions =generalParamsSatis.Questions.filter(p=>p.QUESTION_PRODUCT_TYPE==1)
var row_data=new Array();
questions.forEach(function(value,key){
    console.log(value)
    var question_id=value.QUESTION_ID
    var product_id=$("#PRODUCT_ID_"+question_id).val()
    var stock_id=$("#STOCK_ID_"+question_id).val()
    var amount=$("#AMOUNT_"+question_id).val()
    var price=$("#PRICE_"+question_id).val()
    var discount=$("#DISCOUNT_"+question_id).val()
    if(product_id.length>0){
        amount=parseFloat(filterNum(commaSplit(amount)))
        price=parseFloat(filterNum(commaSplit(price)))   
        discount=parseFloat(filterNum(commaSplit(discount)))   
        var obj={
            QUESTION_ID:question_id,
            ROW_DATA:{
                PRODUCT_ID:product_id,
                STOCK_ID:stock_id,
                AMOUNT:amount,
                PRICE:price,
                DISCOUNT:discount
            }
        }
        row_data.push(obj)
    }
})
var tprice=document.getElementById("total_price").value;
var main_product_id=$("#main_product_id").val();
var UNIQUE_RELATION_ID=$("#UNIQUE_RELATION_ID").val();
var product_type=$("#product_type").val();
var offer_row_id=$("#offer_row_id").val();
tprice=parseFloat(filterNum(commaSplit(tprice)))
var form_data={
	TotalPrice:tprice,
	row_data:row_data,
	main_product_id:main_product_id,
	UNIQUE_RELATION_ID:UNIQUE_RELATION_ID,
	product_type:product_type,
	offer_row_id:offer_row_id
}
return form_data;
}


function saveVirtual(){
	var BasketData = GetBasketData();
	 var mapForm = document.createElement("form");
        mapForm.target = "Map";
        mapForm.method = "POST"; // or "post" if appropriate
        mapForm.action = "/index.cfm?fuseaction=sales.emptypopup_update_virtual_product";

        var mapInput = document.createElement("input");
        mapInput.type = "hidden";
        mapInput.name = "data";
        mapInput.value = JSON.stringify(BasketData);
        console.log(BasketData);
        mapForm.appendChild(mapInput);

        document.body.appendChild(mapForm);

        map = window.open("/index.cfm?fuseaction=sales.emptypopup_update_virtual_product", "Map", "status=0,title=0,height=600,width=800,scrollbars=1");

        if (map) {
            mapForm.submit();
        } else {
            alert('You must allow popups for this map to work.');
        }
}
</script>