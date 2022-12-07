<cfdump var="#attributes#">

<cfset FormData = deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfquery name="getOrder" datasource="#dsn3#">
SELECT OFFER_ID FROM PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#FormData.UNIQUE_RELATION_ID#'
</cfquery>

<cfdump var="#getOrder#">


<cfquery name="getOrderMain" datasource="#dsn3#">
	SELECT * FROM PBS_OFFER where OFFER_ID=#getOrder.ORDER_ID#
</cfquery>

<cfquery name="UpdateRow" datasource="#DSN3#">
	UPDATE PBS_OFFER_ROW SET PRICE=#FormData.TotalPrice#,PRICE_OTHER=#FormData.TotalPrice#,OTHER_MONEY='TL' WHERE UNIQUE_RELATION_ID='#FormData.UNIQUE_RELATION_ID#' 
</cfquery>

<cfquery name="getOrderRows" datasource="#dsn3#">
	SELECT * FROM PBS_OFFER_ROW where OFFER_ID=#getOrder.ORDER_ID#
</cfquery>



<!-------------
		SİPARİŞİN ÖRNEĞİNİ OLUŞTURMAK LAZIM 
		HESAPLAMALARINI YAPTIRMAK LAZIM
				---------------------------->

<cfquery name="getofferMoney" datasource="#dsn3#">
select * from PBS_OFFER_MONEY where ACTION_ID=#getOrder.ORDER_ID#
</cfquery>
<cfloop query="getofferMoney">
    <cfset 'attributes._hidden_rd_money_#i#' = MONEY_TYPE>
    <cfset 'attributes._txt_rate1_#i#' = RATE1>
    <cfset 'attributes._txt_rate2_#i#' = RATE2>

    <cfset 'attributes.hidden_rd_money_#i#' = MONEY_TYPE>
    <cfset 'attributes.txt_rate1_#i#' = RATE1>
    <cfset 'attributes.txt_rate2_#i#' = RATE2>
</cfloop

<cfquery name="getofferMoney3" datasource="#dsn3#">
select * from PBS_OFFER_MONEY where ACTION_ID=#getOrder.ORDER_ID# AND IS_SELECTED=1
</cfquery>

<cfset attributes.KUR_SAY = getofferMoney.recordcount>
<cfset attributes.offer_id = getOrder.ORDER_ID>
<cfset attributes.offer_date = getOrderMain.OFFER_DATE>
<cfset attributes.deliverdate = getOrderMain.DELIVERDATE>
<cfset attributes.ship_date = getOrderMain.SHIP_DATE>
<cfset attributes.finishdate = getOrderMain.FINISHDATE>

<cfset attributes.member_name = getOrderMain.COMPANY_ID>
<cfset attributes.company_id = getOrderMain.COMPANY_ID>
<cfset attributes.partner_id = getOrderMain.PARTNER_ID>
<cfset attributes.member_id = getOrderMain.PARTNER_ID>
<cfset attributes.sales_emp_id = getOrderMain.RECORD_EMP>
<cfset attributes.sales_emp = '#session.ep.NAME# #session.ep.SURNAME#'>
<cfset attributes.process_stage = getOrderMain.PROCESS_STAGE>

<cfset attributes.paymethod_id = getOrderMain.PAYMETHOD>
<cfset attributes.PAYMETHOD = getOrderMain.PAYMETHOD>
<cfset attributes.ship_method_id = getOrderMain.SHIP_METHOD>
<cfset attributes.ship_method = getOrderMain.SHIP_METHOD>
<cfset attributes.pay_method = getOrderMain.PAYMETHOD>
<cfset attributes.card_paymethod_id = ''>
<cfset attributes.ship_address = getOrderMain.SHIP_ADDRESS>
<cfset attributes.ship_address_id = getOrderMain.SHIP_ADDRESS_ID>
<cfset attributes.city_id = getOrderMain.CITY_ID>
<cfset attributes.county_id = getOrderMain.COUNTY_ID>
<cfset attributes.commission_rate = ''>
<cfset attributes.project_head = ''>
<cfset attributes.sales_add_option = ''>
<cfset attributes.offer_head = getOrderMain.OFFER_HEAD>
<cfset attributes.offer_detail = ''>
<cfset attributes.offer_detail = '#getOrderMain.OFFER_DETAIL#'>

<cfset attributes.basket_money = getofferMoney3.MONEY_TYPE>
<cfset attributes.basket_rate1 = getofferMoney3.RATE1>
<cfset attributes.basket_rate2 = getofferMoney3.RATE2>
<cfset attributes.ref_member_type = ''>
<cfset attributes.consumer_id = ''>
<cfset attributes.rows_ = getOrderRows.RECORDCOUNT>


<cfset attributes.price = 0>
<cfset attributes.basket_net_total = 0>
<cfset attributes.basket_tax_total = 0>

<cfscript>
netT = 0;
taxT = 0;
discT = 0;
grosT = 0;
kdv_matrah = 0;

cfloop(query='getOrderRows' ){
	tts=PRICE*QUANTITY;
	dsc=DISCOUNT_1;
	ds=(tts*dsc)/100;
	ttr=tts-ds;
	tx=(ttr*TAX)/100;

	netT+=ttr;
	taxT+=tx;
	discT+=ds;
	grosT+=tts;
}

</cfscript>

<cfloop query="getOrderRows">




</cfloop>




<!-----------------------------
	    var rows = document.getElementsByClassName("sepetRow")
    var netT = 0;
    var taxT = 0;
    var discT = 0;
    var grosT = 0;
    var kdv_matrah = 0;
    for (let i = 1; i <= rows.length; i++) {
        var prc = filterNum(document.getElementById("price_" + i).value)
        var qty = filterNum(document.getElementById("amount_" + i).value)
        var dsc = filterNum(document.getElementById("indirim1_" + i).value)
        var tax = filterNum(document.getElementById("Tax_" + i).value)
        //   console.log("%c Fiyat "+ prc,"color:green;font-size:10pt")
        //  console.log("%c Miktar "+qty,"color:red;font-size:10pt")
        // console.log("%c Tax "+tax,"color:orange;font-size:10pt")
        var tts = prc * qty;
        var ds = (tts * dsc) / 100
        var ttr = tts - ds
        //   console.log("%c Tutar "+commaSplit(ttr,2),"color:blue;font-size:10pt")
        var tx = (ttr * tax) / 100
        netT += ttr
        taxT += tx;
        discT += ds
        grosT += tts;



    }
    console.log("%c Genel Toplam " + commaSplit(netT, 2), "color:purple;font-size:10pt")
    console.log("%c Vergi Toplam " + commaSplit(taxT, 2), "color:violet;font-size:10pt")
    console.log("%c İndirim Toplam " + commaSplit(discT, 2), "color:lightgreen;font-size:10pt")
    console.log("%c Gros Total " + commaSplit(grosT, 2), "color:#cad13d;font-size:10pt")
    var d = parseFloat(filterNum($("#txt_disc").val()))
    $("#txt_disc").val(commaSplit(d, 3))
    var udc = (netT * generalParamsSatis.workingParams.MAX_DISCOINT) / 100
    console.log(udc)
    if (d > udc) {
        alert("Genel İndirim İşlem Tutarının %" + generalParamsSatis.workingParams.MAX_DISCOINT + "'ndan büyük Olmaz İndirim 0'lanacaktır")
        $("#txt_disc").val(commaSplit(0, 3))
        d = 0;
    }

    console.log("%c İndirim Toplam " + commaSplit(d, 2), "color:lightgreen;font-size:10pt")
    $("#txt_total").val(commaSplit(grosT, 3))
    discT += d

    $("#txt_disc_total").val(commaSplit(discT, 3))
    netT = grosT - discT
    $("#txt_nokdv_total").val(commaSplit(netT, 3))
    taxT = (netT * 18) / 100
    $("#txt_kdv_total").val(commaSplit(taxT, 3))
    $("#txt_withkdv_total").val(commaSplit(netT + taxT, 3))
    $("#basket_bottom_total").val(commaSplit(netT + taxT, 3))
}--------------->