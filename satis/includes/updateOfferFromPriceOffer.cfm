
<cfset FORM.ACTIVE_COMPANY=session.ep.company_id>
<cfset ATTRIBUTES.ACTIVE_COMPANY=session.ep.company_id>
<cfset dsn3="#DSN3#">
<cfquery name="getOfferId" datasource="#dsn3#">
    SELECT OFFER_ID FROM PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='#datam.uniqRelationId#'
</cfquery>
<cfquery name="getRows" datasource="#dsn3#">
     SELECT * FROM PBS_OFFER_ROW  WHERE OFFER_ID=#getOfferId.OFFER_ID#
</cfquery>
<cfquery name="getOffer" datasource="#dsn3#">
    SELECT *,#dsn#.getEmployeeWithId(SALES_EMP_ID) as PLASIYER FROM PBS_OFFER  AS O
    LEFT JOIN #DSN#.COMPANY AS C ON C.COMPANY_ID=O.COMPANY_ID
    WHERE OFFER_ID=#getOfferId.OFFER_ID#
</cfquery>
<cfset attributes.offer_id=getOfferId.OFFER_ID>
<cfset attributes.offer_date=createODBCDate(getOffer.OFFER_DATE)>
<cfset attributes.DELIVERDATE=createODBCDate(getOffer.DELIVERDATE)>
<cfset attributes.ship_date=createODBCDate(getOffer.SHIP_DATE)>
<cfset attributes.finishdate=createODBCDate(getOffer.OFFER_DATE)>
<cfset attributes.member_name=getOffer.NICKNAME>
<cfset attributes.OFFER_DESCRIPTION=getOffer.OFFER_DESCRIPTION>
<cfset attributes.company_id=getOffer.COMPANY_ID>
<cfset attributes.partner_id=getOffer.PARTNER_ID>
<cfset attributes.member_id=getOffer.PARTNER_ID>
<cfset attributes.price_catid=getOffer.PRICE_CAT_ID>
<cfset attributes.sales_emp_id=getOffer.SALES_EMP_ID>
<cfset attributes.sales_emp=getOffer.PLASIYER>
<cfset attributes.process_stage=getOffer.OFFER_STAGE>
<cfset attributes.paymethod_id=getOffer.PAYMETHOD>
<cfset attributes.PAYMETHOD=getOffer.PAYMETHOD>
<cfset attributes.ship_method_id=getOffer.SHIP_METHOD>
<cfset attributes.ship_method=getOffer.SHIP_METHOD>
<cfset attributes.pay_method=getOffer.PAYMETHOD>
<cfset attributes.card_paymethod_id="">
<cfset attributes.ship_address=getOffer.SHIP_ADDRESS>
<cfset attributes.ship_address_id=getOffer.SHIP_ADDRESS_ID>
<cfset attributes.city_id=getOffer.CITY_ID>
<cfset attributes.county_id=getOffer.COUNTY_ID>
<cfset attributes.commission_rate="">
<cfset attributes.project_head="">
<cfset attributes.sales_add_option="">
<cfset attributes.offer_head=getOffer.OFFER_HEAD>
<cfset attributes.offer_detail="#getOffer.OFFER_DETAIL#">
<!----- Para Birilmleri ----->
<cfquery name="getOfferMoney" datasource="#dsn3#">
    SELECT MONEY_TYPE,RATE1,RATE2,IS_SELECTED FROM #DSN3#.PBS_OFFER_MONEY WHERE ACTION_ID=#getOfferId.OFFER_ID#
</cfquery>

<CFSET i=1>
<cfset MoneyArr=arrayNew(1)>
<cfloop query="#getOfferMoney#" >
    <cfset "attributes._hidden_rd_money_#i#"=MONEY_TYPE>
    <cfset "attributes._txt_rate1_#i#"=RATE1>
    <cfset "attributes._txt_rate2_#i#"=RATE2>

    <cfset "attributes.hidden_rd_money_#i#"=MONEY_TYPE>
    <cfset "attributes.txt_rate1_#i#"=RATE1>
    <cfset "attributes.txt_rate2_#i#"=RATE2>
    <cfset O=structNew()>
    <cfset O.MONEY=MONEY_TYPE>
    <cfset O.RATE1=RATE1>
    <cfset O.RATE2=RATE2>
    <cfset O.IS_SELECTED=IS_SELECTED>
    <cfscript>
        arrayAppend(MoneyArr,O);
    </cfscript>
    <cfset i=i+1>
</cfloop>
<cfset attributes.KUR_SAY=getOfferMoney.recordCount>

<cfset i=1>
<cfset SUBNETTOTAL=0>
<CFSET SUBNETTOTAL_2=0>
ghgj
<!-------Satırlar------>
<cfloop query="getRows">

    <cfquery name="getUnit" datasource="#dsn3#">
        select PRODUCT_UNIT_ID,MAIN_UNIT from #dsn3#.PRODUCT_UNIT where PRODUCT_ID=#PRODUCT_ID#
    </cfquery>

    <cfset "attributes.product_id#i#"=PRODUCT_ID>
    <cfset "attributes.stock_id#i#"=STOCK_ID>
    <cfset "attributes.amount#i#"=QUANTITY>
    <cfset "attributes.is_virtual#i#"=IS_VIRTUAL>
    <cfset "attributes.is_production_pbs#i#"=0>
    <cfset "attributes.unit#i#"=getUnit.MAIN_UNIT>
    <cfset "attributes.unit_id#i#"=getUnit.PRODUCT_UNIT_ID>
    <cfset "attributes.tax#i#"=TAX>
    <cfset "attributes.product_name#i#"=PRODUCT_NAME>    
    <cfset "attributes.indirim1#i#"=DISCOUNT_1>
    <cfset "attributes.deliver_date#i#"=createODBCDateTime(DELIVER_DATE)>

<cfif UNIQUE_RELATION_ID EQ datam.uniqRelationId>
     <cfset "attributes.price#i#"=attributes.price_offer_from_offering>
     <cfset "attributes.other_money_#i#"=attributes.priceMoney_offer_from_offering>
     <cfset "attributes.PBS_OFFER_ROW_CURRENCY#i#"=-6>
<cfelse>
    <cfset "attributes.price#i#"=PRICE>
    <cfset "attributes.other_money_#i#"=OTHER_MONEY>
    <cfset "attributes.PBS_OFFER_ROW_CURRENCY#i#"=PBS_OFFER_ROW_CURRENCY>
</cfif>
<cfscript>
    pos = ArrayFilter(MoneyArr, function(item) {
	return item.MONEY == '#getRows.OTHER_MONEY#';
});
</cfscript>
<cfset RR2=pos[1].RATE2> 
<CFSET PRO =evaluate("attributes.price#i#")/RR2 >
<cfset "attributes.price_other#i#"=PRO>
<cfdump var="#pos[1]#">
<cfset "attributes.other_money_value_#i#"=(PRO*QUANTITY)-((PRO*QUANTITY)*DISCOUNT_1)/100>
<cfset "attributes.description#i#"=OFFER_ROW_DESCRIPTION>
<cfset "attributes.row_unique_relation_id#i#"=UNIQUE_RELATION_ID>
<cfset "attributes.wrk_row_id#i#"=WRK_ROW_ID>
<cfset "attributes.detail_info_extra#i#"='#DETAIL_INFO_EXTRA#'>
<cfset "attributes.product_name_other#i#"='#PRODUCT_NAME2#'>
<cfset "attributes.deliver_date#i#"='#createODBCdatetime(DELIVER_DATE)#'>
<cfset "attributes.SHELF_CODE#i#"=SHELF_CODE>
<cfquery name="getS" datasource="#dsn3#">
    select STORE_ID,LOCATION_ID,PRODUCT_PLACE_ID from PRODUCT_PLACE where SHELF_CODE='#SHELF_CODE#'
    </cfquery>
    <CFSET RAF='#getS.STORE_ID#_#getS.LOCATION_ID#'>
    <cfset "attributes.deliver_dept#i#"='#getS.STORE_ID#-#getS.LOCATION_ID#'>
    <cfset "attributes.converted_sid#i#"=CONVERTED_STOCK_ID>
    <CFSET PRCS=(((evaluate("attributes.price#i#")*(100-DISCOUNT_1))/100)*QUANTITY)>
    <cfset SUBNETTOTAL_2=SUBNETTOTAL_2+PRCS>
    <CFSET PRCS=PRCS+(PRCS*evaluate("attributes.tax#i#"))/100>
    <cfset SUBNETTOTAL=SUBNETTOTAL+PRCS>

    <cfdump var="#SUBNETTOTAL#"><BR>
<CFSET i=i+1>
</cfloop>
<cfscript>
    pos = ArrayFilter(MoneyArr, function(item) {
	return item.IS_SELECTED == 1;
});
</cfscript>
<cfset attributes.PRICE=SUBNETTOTAL>
<cfset attributes.basket_money=pos[1].MONEY>
<cfset attributes.basket_rate1=pos[1].RATE1>
<cfset attributes.basket_rate2=pos[1].RATE2>
merhaba dünya
merhaba dünya
<cfset attributes.basket_net_total=SUBNETTOTAL_2>
<cfset attributes.basket_tax_total=SUBNETTOTAL-SUBNETTOTAL_2>
<cfset attributes.ref_member_type ="">
<cfset attributes.consumer_id="">
<cfset attributes.reserved=1>
<cfset attributes.rows_=getRows.recordCount>
<cfdump var="#attributes#">
<cfinclude template="/AddOns/partner/satis/includes/upd_offer_tv.cfm">
<script>
    alert("Fiyat kayıt Edildi")
    this.close();
</script>
merhaba dünya