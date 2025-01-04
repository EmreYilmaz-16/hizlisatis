<cfquery name="GETORDER" datasource="#DSN3#">
    SELECT ORDER_ID FROM workcube_metosan_1.ORDERS_INVOICE  WHERE INVOICE_ID= #attributes.action_id# AND PERIOD_ID=#session.ep.PERIOD_ID#
</cfquery>

<cfquery name="GETORDER" datasource="#DSN3#">
    SELECT ORDER_ID FROM workcube_metosan_1.ORDERS_INVOICE  WHERE INVOICE_ID= #attributes.action_id# AND PERIOD_ID=#session.ep.PERIOD_ID#
</cfquery>


<cfif GETORDER.recordCount>
    <cfquery name="getUsedPuan" datasource="#dsn3#">
        SELECT USE_CREDIT FROM workcube_metosan_1.ORDER_MONEY_CREDITS WHERE ORDER_ID=#GETORDER.ORDER_ID# AND USE_CREDIT>0
    </cfquery>
    <CFSET RR2=1>
    <cfif getUsedPuan.recordCount>
     
        <cfquery name="getInvoiceMOney" datasource="#dsn2#">
            SELECT MONEY_TYPE,RATE2,RATE1 FROM INVOICE_MONEY WHERE ACTION_ID=#attributes.action_id#
        </cfquery>
        <cfloop query="getInvoiceMOney">
            <CFSET "attributes.txt_rate1_#currentrow#"=getInvoiceMOney.RATE1>
            <CFSET "attributes.txt_rate2_#currentrow#"=getInvoiceMOney.RATE2>
            <CFSET "attributes.hidden_rd_money_#currentrow#"=getInvoiceMOney.MONEY_TYPE>
            <CFIF MONEY_TYPE EQ "USD">
                <CFSET RR2=RATE2>
            </CFIF>
        </cfloop>
        <CFSET attributes.KUR_SAY=getInvoiceMOney.recordCount>
        <cfquery name="GETPAPER" datasource="#DSN3#">
            SELECT EXPENSE_COST_NO,EXPENSE_COST_NUMBER FROM GENERAL_PAPERS WHERE EXPENSE_COST_NO IS NOT NULL
        </cfquery>
        <cfquery name="GETINVOICE" datasource="#DSN2#">
            select COMPANY_ID,PARTNER_ID,INVOICE_ID,SALE_EMP from INVOICE WHERE INVOICE_ID=#attributes.action_id#
        </cfquery>

        <CFSET attributes.WRK_ROW_ID1="PBS#session.ep.userid##dateFormat(now(),"yyyymmdd")##timeFormat(now(),"hhmmnnl")#"><!----TODO: WRK_ROW ID--->
        <CFSET attributes.TOTAL1=getUsedPuan.USE_CREDIT>
        <CFSET attributes.TOTAL_AMOUNT=getUsedPuan.USE_CREDIT>
        <CFSET attributes.SERIAL_NO=GETPAPER.EXPENSE_COST_NUMBER+1><!----TODO: SERIAL NO--->
        <CFSET attributes.SERIAL_NUMBER="#GETPAPER.EXPENSE_COST_NO#"><!----TODO: SERIAL NO--->
        <CFSET attributes.OTHER_TOTAL_AMOUNT=(getUsedPuan.USE_CREDIT/RR2)><!----TODO: KUR--->
        <CFSET attributes.OTHER_NET_TOTAL1=getUsedPuan.USE_CREDIT>
        <CFSET attributes.OTHER_NET_TOTAL_AMOUNT=(getUsedPuan.USE_CREDIT/RR2)><!----TODO: KUR--->
        <CFSET attributes.OTHER_NET_TOTAL_KDVSIZ1=getUsedPuan.USE_CREDIT>
        <CFSET attributes.NET_TOTAL1=getUsedPuan.USE_CREDIT>
        <CFSET attributes.NET_TOTAL_AMOUNT=getUsedPuan.USE_CREDIT>
        <cfset attributes.CH_COMPANY="#GETINVOICE.COMPANY_ID#"> 
        <cfset attributes.CH_COMPANY_ID="#GETINVOICE.COMPANY_ID#">
        <cfset attributes.CH_MEMBER_TYPE="partner">
        <cfset attributes.CH_PARTNER="#GETINVOICE.PARTNER_ID#">
        <cfset attributes.CH_PARTNER_ID="#GETINVOICE.PARTNER_ID#">



        
        <cfset attributes.ACCOUNT_ACC_CODE="">
        <cfset attributes.ACCOUNT_CODE1="760.01.03.0020">
        <cfset attributes.ACTIVE_PERIOD=session.ep.PERIOD_ID>
        <cfset attributes.ACTIVITY_TYPE1="">
        <cfset attributes.ADRES="">
        <cfset attributes.ASSET1="">
        <cfset attributes.ASSET_ID1="">
        <cfset attributes.AUTHORIZED1="">
        <cfset attributes.BANK_BRANCH_NAME="">
        <cfset attributes.BANK_CODE="">
        <cfset attributes.BANK_NAME="">
        <cfset attributes.BASKET_DUE_VALUE=0>
        <cfset attributes.BASKET_DUE_VALUE_DATE_="#dateFormat(now(),"dd/>mm/yyyy")#">
        <cfset attributes.BRANCH_ID="">
        <cfset attributes.BSMV_TOTAL_AMOUNT=0>
        <cfset attributes.BUDGET_PERIOD="">
        <cfset attributes.BUDGET_PLAN_ID="">
        <cfset attributes.CONTROL_FIELD_VALUE=""> 
        <cfset attributes.CREDIT_CARD_INFO=""> 
        <cfset attributes.CREDIT_CONTRACT_ID=""> 
        <cfset attributes.CREDIT_CONTRACT_ROW_ID=""> 
        <cfset attributes.CREDIT_TYPE1=1> 
        <cfset attributes.CREDIT_CONTRACT_ROW_ID=""> 
        <cfset attributes.CT_PROCESS_TYPE_215=120>
        <cfset attributes.CT_PROCESS_TYPE_232=120>
        <cfset attributes.CT_PROCESS_TYPE_95=120>
        <cfset attributes.EXPENSE_CENTER_ID1=7>
        <cfset attributes.EXPENSE_CENTER_NAME1='SATIŞ VE PAZARLAMA'>
        <cfset attributes.EXPENSE_COST_TYPE=120>
        <cfset attributes.EXPENSE_DATE="#dateFormat(now(),"dd/>mm/yyyy")#">
        <cfset attributes.EXPENSE_DATE1="#dateFormat(now(),"dd/>mm/yyyy")#">
        <cfset attributes.EXPENSE_DATE_H=timeformat(now(),"HH")>
        <cfset attributes.EXPENSE_DATE_M=timeformat(now(),"mm")>
        <cfset attributes.EXPENSE_EMPLOYEE="#session.ep.NAME# #session.ep.SURNAME#">
        <cfset attributes.EXPENSE_EMPLOYEE_ID=session.ep.userid>
        <cfset attributes.EXPENSE_EMPLOYEE_POSITION=session.ep.POSITION_CODE>
        <CFSET attributes.EXPENSE_ITEM_ID1=551>
        <CFSET attributes.EXPENSE_ITEM_NAME1="MERKEZ PUAN-PROMOSYON">
        <CFSET attributes.KDV_TOTAL1=0>
        <CFSET attributes.KDV_TOTAL_AMOUNT=0>
        <CFSET attributes.LOCATION_ID="">
        <CFSET attributes.MEMBER_ID1="">

        <CFSET attributes.OIV_TOTAL_AMOUNT=0>
        <CFSET attributes.OPP_HEAD1="">
        <CFSET attributes.OPP_ID1="">

        <CFSET attributes.OTHER_KDV_TOTAL_AMOUNT=0>

        <CFSET attributes.OTHER_OTV_TOTAL_AMOUNT=0>

        <CFSET attributes.OTV_RATE1=0>
        <CFSET attributes.OTV_TOTAL1=0>
        <CFSET attributes.OTV_TOTAL_AMOUNT=0>
        <CFSET attributes.PAPER_CONTROL_=0>
        <CFSET attributes.PAYMETHOD	=2>
        <CFSET attributes.PAYMETHOD_NAME="NAKİT">
        <CFSET attributes.PBS_DESCRIPTION_PBS="">
        <CFSET attributes.PROCESS_CAT=215>
        <cfset attributes.PROCESS_DATE="#dateFormat(now(),"dd/>mm/yyyy")#">
        <cfset attributes.PRODUCT_ID1="">
        <cfset attributes.PRODUCT_NAME1="">
        <cfset attributes.PROJECT1="">
        <cfset attributes.PROJECT_HEAD="">
        <cfset attributes.PROJECT_ID="">
        <cfset attributes.PROJECT_ID1="">
        <cfset attributes.PRO_INFO_ID="">
        <cfset attributes.QUANTITY1=1>

        <CFSET attributes.REASON_CODE1="">
        <CFSET attributes.RECORD_NUM=1>
        <CFSET attributes.ROW_BRANCH1="">
        <CFSET attributes.ROW_BSMV_AMOUNT1=0>
        <CFSET attributes.ROW_BSMV_CURRENCY1=0>
        <CFSET attributes.ROW_BSMV_RATE1=0>
        <CFSET attributes.ROW_DETAIL1="Puan Kullanım">
        <CFSET attributes.ROW_KONTROL1=1>
        <CFSET attributes.ROW_OIV_AMOUNT1=0>
        <CFSET attributes.ROW_OIV_RATE1=0>
        <CFSET attributes.ROW_TEVKIFAT_AMOUNT1=0>
        <CFSET attributes.ROW_TEVKIFAT_RATE1=0>
        <CFSET attributes.MONEY_ID1="TL,1,1">
        <CFSET attributes.SHIP_ADDRESS_ID=-1>

        <CFSET attributes.STOCK_ID1="">
        <CFSET attributes.STOCK_UNIT1="">
        <CFSET attributes.STOCK_UNIT_ID1="">
        <CFSET attributes.STOPAJ=0>
        <CFSET attributes.STOPAJ_RATE_ID="">
        <CFSET attributes.STOPAJ_YUZDE=0>
        <CFSET attributes.SUBSCRIPTION_ID1="">
        <CFSET attributes.SUBSCRIPTION_NAME1="">
        <CFSET attributes.SYSTEM_RELATION="">

        <CFSET attributes.TAX_CODE="">
        <CFSET attributes.TAX_CODE1="">
        <CFSET attributes.TAX_RATE1=0>
        <CFSET attributes.TEMP_DATE="#dateFormat(now(),"dd/>mm/yyyy")#">
        <CFSET attributes.TEVKIFAT_ID="">
        <CFSET attributes.TEVKIFAT_ORAN="">
        <CFSET attributes.TL_VALUE1="USD">
        <CFSET attributes.TL_VALUE2="USD">
        <CFSET attributes.TL_VALUE3="USD">
        <CFSET attributes.TL_VALUE4="USD">
        <CFSET attributes.WORKGROUP_ID1="">
        <CFSET attributes.WORK_HEAD1="">
        <CFSET attributes.WORK_ID1="">

        <CFSET attributes.YUVARLAMA=0>







        <CFSET attributes.WRK_ROW_ID1=""><!----TODO: WRK_ROW ID--->
        <CFSET attributes.TOTAL1=1000><!----TODO: NET TOTAL--->
        <CFSET attributes.TOTAL_AMOUNT=1000><!---TODO: NET TOTAL--->
        <CFSET attributes.SERIAL_NO=18902><!----TODO: SERIAL NO--->
        <CFSET attributes.SERIAL_NUMBER="MF"><!----TODO: SERIAL NO--->
        <CFSET attributes.OTHER_TOTAL_AMOUNT=28.27><!----TODO: KUR--->
        <CFSET attributes.OTHER_NET_TOTAL1=1000><!----TODO: NET TOTAL--->
        <CFSET attributes.OTHER_NET_TOTAL_AMOUNT=28.27><!----TODO: KUR--->
        <CFSET attributes.OTHER_NET_TOTAL_KDVSIZ1=1000><!----TODO: NET TOTAL--->
        <CFSET attributes.NET_TOTAL1=1000><!----TODO: NET TOTAL--->
        <CFSET attributes.NET_TOTAL_AMOUNT=1000><!----TODO: NET TOTAL--->
        <cfset attributes.CH_COMPANY=""> <!---TODO: Company ID --->
        <cfset attributes.CH_COMPANY_ID=""> <!---TODO: Company ID --->
        <cfset attributes.CH_MEMBER_TYPE=""> <!---TODO: Company ID --->
        <cfset attributes.CH_PARTNER=""> <!--- TODO:Müşteri ID --->
        <cfset attributes.CH_PARTNER_ID=""> <!--- TODO:Müşteri ID --->


    <cfinclude template="/V16/objects/query/add_collacted_expense_cost.cfm">

</cfif>



</cfif>

HIDDEN_RD_MONEY_1	TL
HIDDEN_RD_MONEY_2	USD
HIDDEN_RD_MONEY_3	EUR
KUR_SAY	3



/*
struct














TAX_CODE	[empty string]
TAX_CODE1	[empty string]
TAX_RATE1	0
TEMP_DATE	03/01/2025
TEVKIFAT_ID	[empty string]
TEVKIFAT_ORAN	[empty string]
TL_VALUE1	USD
TL_VALUE2	USD
TL_VALUE3	USD
TL_VALUE4	USD
TOTAL1	1000.00000
TOTAL_AMOUNT	1000.00
TXT_RATE1_1	1
TXT_RATE1_2	1
TXT_RATE1_3	1
TXT_RATE2_1	1.0000
TXT_RATE2_2	35.3690
TXT_RATE2_3	36.6010
WORKGROUP_ID1	[empty string]
WORK_HEAD1	[empty string]
WORK_ID1	[empty string]
WRK_ROW_ID1	1146oa312025164826197Sg
YUVARLAMA	0.00
_cf_nodebug	true
formSubmittedController	1
fuseaction	cost.form_add_expense_cost
isAjax	1
moduleForLanguage	objects
xmlhttp	1

*/

ACCOUNT_ACC_CODE	[empty string]
ACCOUNT_CODE1	760.01.03.0020
ACCOUNT_ID	[empty string]
ACTIONID	[empty string]
ACTIVE_PERIOD	5
ACTIVITY_TYPE1	[empty string]
ADRES	ÜÇEVLER MAH.DÜZOVA SOKAK YALÇIN AY İŞ MRK.NO:1/11 NİLÜFER BURSA Türkiye
ASSET1	[empty string]
ASSET_ID1	[empty string]
AUTHORIZED1	[empty string]
BANK_BRANCH_NAME	[empty string]
BANK_CODE	[empty string]
BANK_NAME	[empty string]
BASKET_DUE_VALUE	0
BASKET_DUE_VALUE_DATE_	03/01/2025
BRANCH_ID	[empty string]
BSMV_TOTAL_AMOUNT	0.00
BUDGET_PERIOD	[empty string]
BUDGET_PLAN_ID	[empty string]
CH_COMPANY	PARTNER BİLGİ SİTEMLERİ SANAYİ VE TİCARET LTD.ŞTİ
CH_COMPANY_ID	22781
CH_MEMBER_TYPE	partner
CH_PARTNER	ERHAN KARAŞ
CH_PARTNER_ID	22785
CIRCUIT	objects
COMPANY1	[empty string]
COMPANY_ID1	[empty string]
CONTROLLER	WBO/controller/ExpenseReceiptController.cfm
CONTROLLERFILENAME	WBO/controller/ExpenseReceiptController.cfm
CONTROL_FIELD_VALUE	[empty string]
CREDIT_CARD_INFO	[empty string]
CREDIT_CONTRACT_ID	[empty string]
CREDIT_CONTRACT_ROW_ID	[empty string]
CREDIT_TYPE1	1
CT_PROCESS_MULTI_TYPE_215	[empty string]
CT_PROCESS_MULTI_TYPE_232	[empty string]
CT_PROCESS_MULTI_TYPE_95	[empty string]
CT_PROCESS_TYPE_215	120
CT_PROCESS_TYPE_232	120
CT_PROCESS_TYPE_95	120
CURRENCY_ID	[empty string]
DELAY_INFO	[empty string]
DEPARTMENT_ID	[empty string]
DEPARTMENT_NAME	[empty string]
DETAIL	[empty string]
EMP_ID	[empty string]
EVENT	add
EXPENSE_CENTER_ID1	7
EXPENSE_CENTER_NAME1	SATIŞ VE PAZARLAMA
EXPENSE_COST_TYPE	120
EXPENSE_DATE	03/01/2025
EXPENSE_DATE1	03/01/2025
EXPENSE_DATE_H	16
EXPENSE_DATE_M	48
EXPENSE_EMPLOYEE	EMRE YILMAZ
EXPENSE_EMPLOYEE_ID	1146
EXPENSE_EMPLOYEE_POSITION	147
EXPENSE_EMPLOYEE_TYPE	[empty string]
EXPENSE_ITEM_ID1	551
EXPENSE_ITEM_NAME1	MERKEZ PUAN-PROMOSYON
EXPENSE_PAPER_TYPE	[empty string]
FIELDNAMES	EXPENSE_COST_TYPE,BUDGET_PERIOD,BUDGET_PLAN_ID,CREDIT_CONTRACT_ID,CREDIT_CONTRACT_ROW_ID,IS_FROM_CREDIT,ACTIVE_PERIOD,PROCESS_CAT,CT_PROCESS_TYPE_95,CT_PROCESS_MULTI_TYPE_95,CT_PROCESS_TYPE_215,CT_PROCESS_MULTI_TYPE_215,CT_PROCESS_TYPE_232,CT_PROCESS_MULTI_TYPE_232,CH_MEMBER_TYPE,CH_COMPANY_ID,CH_PARTNER_ID,EMP_ID,CH_COMPANY,CH_PARTNER,EXPENSE_EMPLOYEE_ID,EXPENSE_EMPLOYEE_TYPE,EXPENSE_EMPLOYEE,EXPENSE_EMPLOYEE_POSITION,PROJECT_ID,PROJECT_HEAD,PAPER_CONTROL_,SERIAL_NUMBER,SERIAL_NO,PROCESS_DATE,EXPENSE_DATE,EXPENSE_DATE_H,EXPENSE_DATE_M,EXPENSE_PAPER_TYPE,TAX_CODE,BRANCH_ID,DEPARTMENT_ID,LOCATION_ID,DEPARTMENT_NAME,PAYMETHOD,PAYMETHOD_NAME,SHIP_ADDRESS_ID,ADRES,BASKET_DUE_VALUE,BASKET_DUE_VALUE_DATE_,KASA,BANK_NAME,BANK_BRANCH_NAME,CURRENCY_ID,ACCOUNT_ACC_CODE,BANK_CODE,ACCOUNT_ID,CREDIT_CARD_INFO,INST_NUMBER,DELAY_INFO,DETAIL,SYSTEM_RELATION,PRO_INFO_ID,PBS_DESCRIPTION_PBS,CONTROL_FIELD_VALUE,RECORD_NUM,TEMP_DATE,WRK_ROW_ID1,CREDIT_TYPE1,ROW_KONTROL1,EXPENSE_DATE1,ROW_DETAIL1,EXPENSE_CENTER_ID1,EXPENSE_CENTER_NAME1,EXPENSE_ITEM_ID1,EXPENSE_ITEM_NAME1,ACCOUNT_CODE1,PRODUCT_NAME1,PRODUCT_ID1,STOCK_ID1,STOCK_UNIT_ID1,STOCK_UNIT1,QUANTITY1,TOTAL1,TAX_RATE1,OTV_RATE1,KDV_TOTAL1,OTV_TOTAL1,ROW_BSMV_RATE1,ROW_BSMV_AMOUNT1,ROW_BSMV_CURRENCY1,ROW_OIV_RATE1,ROW_OIV_AMOUNT1,ROW_TEVKIFAT_RATE1,ROW_TEVKIFAT_AMOUNT1,NET_TOTAL1,MONEY_ID1,OTHER_NET_TOTAL1,ACTIVITY_TYPE1,WORKGROUP_ID1,WORK_ID1,WORK_HEAD1,OPP_ID1,OPP_HEAD1,PROJECT_ID1,PROJECT1,SUBSCRIPTION_ID1,SUBSCRIPTION_NAME1,MEMBER_TYPE1,MEMBER_ID1,COMPANY_ID1,AUTHORIZED1,COMPANY1,ASSET_ID1,ASSET1,TAX_CODE1,OTHER_NET_TOTAL_KDVSIZ1,REASON_CODE1,ROW_BRANCH1,KUR_SAY,HIDDEN_RD_MONEY_1,TXT_RATE1_1,TXT_RATE2_1,HIDDEN_RD_MONEY_2,TXT_RATE1_2,RD_MONEY,TXT_RATE2_2,HIDDEN_RD_MONEY_3,TXT_RATE1_3,TXT_RATE2_3,TOTAL_AMOUNT,KDV_TOTAL_AMOUNT,OTV_TOTAL_AMOUNT,BSMV_TOTAL_AMOUNT,OIV_TOTAL_AMOUNT,STOPAJ_RATE_ID,STOPAJ_YUZDE,STOPAJ,YUVARLAMA,NET_TOTAL_AMOUNT,OTHER_TOTAL_AMOUNT,TL_VALUE1,OTHER_KDV_TOTAL_AMOUNT,TL_VALUE2,OTHER_OTV_TOTAL_AMOUNT,TL_VALUE4,OTHER_NET_TOTAL_AMOUNT,TL_VALUE3,TEVKIFAT_ID,TEVKIFAT_ORAN,PAGEHEAD,CONTROLLERFILENAME,CONTROLLER,EVENT,PAGEFUSEACTION,FUSEACTION
HIDDEN_RD_MONEY_1	TL
HIDDEN_RD_MONEY_2	USD
HIDDEN_RD_MONEY_3	EUR
INST_NUMBER	[empty string]
IS_FROM_CREDIT	[empty string]
KASA	[empty string]
KDV_TOTAL1	0.00000
KDV_TOTAL_AMOUNT	0.00
KUR_SAY	3