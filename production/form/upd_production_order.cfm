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

<cfform method="post" name="production_form" id="production_form">
	<cfoutput>
		<input type="hidden" name="offer_row_id" value="#getOffer.OFFER_ROW_ID#"> 
		<input type="hidden" name="main_product_id" id="main_product_id" value="#getProductionOrders.STOCK_ID#">
		<input type="hidden" name="UNIQUE_RELATION_ID" id="UNIQUE_RELATION_ID" value="#getProductionOrders.UNIQUE_RELATION_ID#">
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
	<button type="button" class="btn btn-warning" onclick="SaveVirtual()">Kaydet</button>
	<button type="button" class="btn btn-success" onclick="CloseProductionOrders()">Üretimi Sonlandır</button>
</cfform>
<script>
	function openProductPopup(question_id,from_row=0){
		openBoxDraggable("http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=METOSAN%20SATICI%20F%C4%B0YAT%20L%C4%B0STES%C4%B0%20A&PRICE_CATID=19&company_id=22143&company_name=pbs&question_id="+question_id)
	}

	function setRow(product_id,stock_id,product_name,question_id,barcode,main_unit,price,quantity,discount){
		console.log(arguments);
		$("#PRODUCT_NAME_"+question_id).val(product_name);
		$("#STOCK_ID_"+question_id).val(stock_id);
		$("#PRODUCT_ID_"+question_id).val(product_id);
		$("#PRICE_"+question_id).val(price);
		$("#BARKODE_"+question_id).val(barcode);
		$("#AMOUNT_"+question_id).val(quantity);
		$("#MAIN_UNIT_"+question_id).text(main_unit)
		$("#DISCOUNT_"+question_id).val(discount)
		Hesapla(1)
	}


function Hesapla(type){
    var TotalPrice=0;
   if(type==1){
    var questions=generalParamsSatis.Questions.filter(p=>p.QUESTION_PRODUCT_TYPE==0)
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

function SaveVirtual(){
var questions =generalParamsSatis.Questions.filter(p=>p.QUESTION_PRODUCT_TYPE==0)
var form_data=new Array();
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
        form_data.push(obj)
    }
})
console.log(form_data);
}
</script>