
<cfquery name="getLot" datasource="#dsn3#">
    select PRODUCTION_LOT_NO,PRODUCTION_LOT_NUMBER from GENERAL_PAPERS WHERE PRODUCTION_LOT_NUMBER IS NOT NULL
</cfquery>


<cfset REAL_START_DATE=now()>
<cfset REAL_FINISH_DATE=now()>

<cfif 1 eq 1> <!----Öncesine Yıkama Ekle---->


<cfquery name="GETSWS" datasource="#DSN3#">
SELECT * FROM WORKSTATIONS_PRODUCTS WHERE STOCK_ID=#main_stock_id#
</cfquery>

<cfset pws_id=GETSWS.WS_ID>


<CFSET NEW_FINISH_DATE_=dateAdd("n", 30, REAL_START_DATE)>




<cfset attributes.DELIVER_DATE_1="#dateformat(NEW_FINISH_DATE_,'yyyy-mm-dd')#">
<cfset attributes.DETAIL="">
<cfset attributes.ORDER_ID_1="">
<cfset attributes.ORDER_ROW_ID_1="">
<cfset attributes.IS_LINE_NUMBER_1="0">
<cfset attributes.IS_OPERATOR_DISPLAY_1="1">
<cfset attributes.PRODUCTION_ROW_COUNT_1="0">
<cfset attributes.STOCK_RESERVED="1">
<cfset attributes.SHOW_LOT_NO_COUNTER="0">
<cfset attributes.PRODUCT_AMOUNT_1_0="1">
<cfset attributes.IS_STAGE="4">
<cfset attributes.PROJECT_ID_1="">
<cfset attributes.PROCESS_STAGE="25">
<cfset attributes.IS_TIME_CALCULATION_1="0">
<cfset attributes.LOT_NO="#getLot.PRODUCTION_LOT_NO#-#getLot.PRODUCTION_LOT_NUMBER+1#">
<cfset attributes.FINISH_DATE_1="#dateformat(NEW_FINISH_DATE_,'yyyy-mm-dd')#">
<cfset attributes.START_DATE_1="#dateformat(REAL_START_DATE,'yyyy-mm-dd')#">
<cfset attributes.station_id_1_0="#GETSWS.WS_ID#,0,0,0,-1,4,4,4,4">


<cfset attributes.FINISH_H_1="#hour(NEW_FINISH_DATE_)#">
<cfset attributes.FINISH_M_1="#minute(NEW_FINISH_DATE_)#">
<cfset attributes.START_H_1="#hour(REAL_START_DATE)#">
<cfset attributes.START_M_1="#minute(REAL_START_DATE)#">
 <cfset attributes.DELIVER_DATE_1=NEW_FINISH_DATE_>
<cfset attributes.PRODUCT_VALUES_1_0="#main_stock_id#,0,0,0,#smain_pbs#">

<cfinclude  template="add_production_ordel_all_2.cfm">


</cfif>