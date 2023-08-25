<cfdump var="#attributes#">

<cfset FORM.ACTIVE_COMPANY=session.ep.company_id>
<cfset ATTRIBUTES.ACTIVE_COMPANY=session.ep.company_id>
<cfdump var="#attributes#">
<cfquery name="getOfferC" datasource="#dsn3#">
select count(*) AS RC from PBS_OFFER
</cfquery>

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">
<cfif session.ep.userid eq 1146>

</cfif>
<cfloop array="#FormData.OrderMoney#" item="it" index="i">
    <cfset "attributes._hidden_rd_money_#i#"=it.MONEY>


    <cfset "attributes.hidden_rd_money_#i#"=it.MONEY>
    <cfset "attributes._txt_rate1_#i#"=it.RATE1>
    <cfset "attributes._txt_rate2_#i#"=it.RATE2>
    <cfset "attributes.txt_rate1_#i#"=it.RATE1>
    <cfset "attributes.txt_rate2_#i#"=it.RATE2>
</cfloop>



<cfset BasketRows=FormData.OrderRows>
<cfset attributes.KUR_SAY=arrayLen(FormData.OrderMoney)>
<cfset attributes.offer_id=FormData.OrderHeader.ORDER_ID>
<cfset attributes.offer_date=now()>
<cfset attributes.deliverdate=now()>
<cfset attributes.ship_date=now()>
<cfset attributes.finishdate=now()>
<cfset attributes.member_name=FormData.OrderHeader.MEMBER_NAME>
<cfif isDefined("FormData.OrderHeader.OFFER_DESCRIPTION")>
<cfset attributes.OFFER_DESCRIPTION=FormData.OrderHeader.OFFER_DESCRIPTION>
<cfelse>
    <cfset attributes.OFFER_DESCRIPTION="">
</cfif>
<cfset attributes.company_id=FormData.OrderHeader.COMPANY_ID>
<cfset attributes.partner_id=FormData.OrderHeader.COMPANY_PARTNER_ID>
<cfset FactPBS=FormData.OrderHeader.FACT>
<cfset attributes.company_id=FormData.OrderHeader.COMPANY_ID>
<cfset attributes.member_id=FormData.OrderHeader.COMPANY_PARTNER_ID>
<cfset attributes.price_catid=FormData.OrderHeader.PRICE_CATID>
<cfif  1 EQ 0 AND isDefined("FormData.OrderHeader.PLASIYER_ID")>
    <cfset attributes.sales_emp_id=FormData.OrderHeader.PLASIYER_ID>
    <cfset attributes.sales_emp=FormData.OrderHeader.PLASIYER>
<cfelse>
    <cfset attributes.sales_emp_id=session.ep.userid>
    <cfset attributes.sales_emp="#session.ep.NAME# #session.ep.SURNAME#">
</cfif>
PROJECT_NAME 
<cfif isDefined("FormData.OrderHeader.PROJECT_NAME")>
    <cfset attributes.project_head=FormData.OrderHeader.PROJECT_NAME>
<cfelse>
    <cfset attributes.project_head="">
</cfif>
<cfif isDefined("FormData.OrderHeader.PROJECT_ID")>
    <cfset attributes.project_id=FormData.OrderHeader.PROJECT_ID>
<cfelse>
    <cfset attributes.project_id="">
</cfif>

<cfset attributes.process_stage=FormData.OrderHeader.PROCESS_STAGE>
<cfset attributes.price=FormData.OrderFooter.SUBNETTOTAL>
<cfset attributes.paymethod_id=FormData.OrderHeader.PAYMETHOD_ID>
<cfset attributes.PAYMETHOD=FormData.OrderHeader.PAYMETHOD>
<cfset attributes.ship_method_id=FormData.OrderHeader.SHIP_METHOD_ID>
<cfset attributes.ship_method=FormData.OrderHeader.SHIP_METHOD>
<cfset attributes.pay_method=FormData.OrderHeader.PAYMETHOD>
<cfset attributes.card_paymethod_id="">
<cfset attributes.ship_address=FormData.OrderHeader.SHIP_ADDRESS>
<cfset attributes.ship_address_id=FormData.OrderHeader.SHIP_ADDRESS_ID>
<cfset attributes.city_id=FormData.OrderHeader.CITY_ID>
<cfset attributes.county_id=FormData.OrderHeader.COUNTY_ID>
<cfset attributes.commission_rate="">

<cfset attributes.sales_add_option="">
<cfset attributes.offer_head=FormData.OrderHeader.OFFER_HEAD>
<cfset attributes.offer_detail="">
<cfset attributes.offer_detail="#FormData.OrderHeader.ISLEM_TIPI_PBS#">
<cfset attributes.basket_money=FormData.OrderFooter.BASKET_MONEY>
<cfset attributes.basket_rate1=FormData.OrderFooter.BASKET_RATE_1>
<cfset attributes.basket_rate2=FormData.OrderFooter.BASKET_RATE_2>
<cfset attributes.basket_net_total=FormData.OrderFooter.TOTAL_WITH_KDV>
<cfset attributes.basket_tax_total=FormData.OrderFooter.TAX_TOTAL>
<cfset attributes.ref_member_type ="">
<cfset attributes.consumer_id="">
<cfset attributes.reserved=1>
<cfset attributes.rows_=arrayLen(BasketRows)>
<cfif getOfferC.RC eq 0><cfset Num=1><cfelse>
    <cfset num=getOfferC.RC>
    <cfset Num=Num+1></cfif>
<cfset paper_fulbs="PBSTV-#Num#">
<cfif len(FormData.OrderHeader.ORDER_ID)>
<cfelse>    
    <cfquery name="get_offer_number" datasource="#dsn3#">
        EXEC GET_PAPER_NUMBER 1
    </cfquery>
    <cfset paper_fulbs=get_offer_number.PAPER_NO>
</cfif>
<cfset attributes.offer_status=1>
<cfset fs=attributes.fuseaction>
<cfset attributes.genel_indirim=FormData.OrderFooter.AFTER_DISCOUNT>
<cfset form.genel_indirim=FormData.OrderFooter.AFTER_DISCOUNT>
<cfdump var="#FormData#">

<cfset wrq=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR")>

<cfloop array="#BasketRows#" item="it" index="i">
    
    <!----<cfif it.is_virtual eq 1 or it.---->

    <cfquery name="getUnit" datasource="#dsn3#">
        select PRODUCT_UNIT_ID,MAIN_UNIT from #dsn3#.PRODUCT_UNIT where PRODUCT_ID=#it.product_id#
    </cfquery>
 
    <cfset "attributes.product_id#i#"=it.product_id>
    <cfif len(it.stock_id)><cfset "attributes.stock_id#i#"=it.stock_id><cfelse><cfset "attributes.stock_id#i#"=0></cfif>
    
    <cfset "attributes.amount#i#"=filternum(it.amount)>
    <cfset "attributes.is_virtual#i#"=it.is_virtual>
    <cfif isDefined("it.is_production")>
    <cfset "attributes.is_production_pbs#i#"=it.is_production>
<cfelse>
    <cfset "attributes.is_production_pbs#i#"=0>
</cfif>
    <cfset "attributes.unit#i#"=getUnit.MAIN_UNIT>
    <cfset "attributes.unit_id#i#"=getUnit.PRODUCT_UNIT_ID>
    <cfset "attributes.price#i#"=filternum(it.price)>
    <cfset "attributes.tax#i#"=filternum(it.Tax)>
    <cfif isDefined("it.is_karma")>
        <cfset "attributes.is_karma#i#"=it.is_karma>
        <cfquery name="del" datasource="#dsn3#">
            DELETE FROM PBS_OFFER_ROW_KARMA_PRODUCTS WHERE REL_UNIQUE_RELATION_ID=''
        </cfquery>
    <cfelse>
        <cfset "attributes.is_karma#i#"=0>
    </cfif>
    
    <cfset "attributes.product_name#i#"=it.product_name>
    <cfset "attributes.indirim1#i#"=filternum(it.indirim1)>
    <cfset "attributes.other_money_#i#"=it.other_money>
    <cfset "attributes.other_money_value_#i#"=(filternum(it.price_other)*filternum(it.amount))-((filternum(it.price_other)*filternum(it.amount))*filternum(it.indirim1))/100>
    <cfset "attributes.price_other#i#"=filternum(it.price_other)>
    <cfif isDefined("it.description")>
    <cfset "attributes.description#i#"=it.description>
    <cfelse>    
        <cfset "attributes.description#i#"="">
    </cfif>
    <cfif isDefined("it.row_uniq_id") and len(it.row_uniq_id)>
        <cfset "attributes.row_unique_relation_id#i#"=it.row_uniq_id>
        <cfset "attributes.wrk_row_id#i#"=it.row_uniq_id>
        <cfset "attributes.wrk_row_id#i#"=it.row_uniq_id>
    <cfelse>
        <cfset "attributes.row_unique_relation_id#i#"="PBS#session.ep.userid##dateFormat(now(),"yyyymmdd")##timeFormat(now(),"hhmmnnl")#">
        <cfset "attributes.wrk_row_id#i#"="PBS#session.ep.userid##dateFormat(now(),"yyyymmdd")##timeFormat(now(),"hhmmnnl")#">
    </cfif>
    <cfif isDefined("it.is_karma")>
        <cfset "attributes.is_karma#i#"=it.is_karma>
        <cfquery name="del" datasource="#dsn3#">
            DELETE FROM PBS_OFFER_ROW_KARMA_PRODUCTS WHERE REL_UNIQUE_RELATION_ID='#evaluate("attributes.row_unique_relation_id#i#")#'
        </cfquery>
    <cfelse>
        <cfset "attributes.is_karma#i#"=0>
    </cfif>
   
    <cfset "attributes.RELATED_ACTION_TABLE#i#"="PBS_OFFER_ROW">
    <cfset "attributes.PBS_OFFER_ROW_CURRENCY#i#"=it.orderrow_currency>
    <cfset "attributes.order_currency#i#"=it.orderrow_currency>
<cfif not isDefined("it.detail_info_extra")>
    <cfset "attributes.detail_info_extra#i#"=''>
<cfelse>
    <cfset "attributes.detail_info_extra#i#"='#it.detail_info_extra#'>
</cfif>
<cfif not isDefined("it.product_name_other")>
    <cfset "attributes.product_name_other#i#"=''>
<cfelse>
    <cfset "attributes.product_name_other#i#"='#it.product_name_other#'>
</cfif>
<cfif  isDefined("it.deliver_date_bask") and len(it.deliver_date_bask)>
    
    <cfset "attributes.deliver_date#i#"='#createODBCdatetime(it.deliver_date_bask)#'>
<cfelse>
    <cfset "attributes.deliver_date#i#"=''>
</cfif>
    <cfset "attributes.SHELF_CODE#i#"=it.shelf_code>
    <cfquery name="getS" datasource="#dsn3#">
    select STORE_ID,LOCATION_ID,PRODUCT_PLACE_ID from PRODUCT_PLACE where SHELF_CODE='#it.shelf_code#'
    </cfquery>
    <CFSET RAF='#getS.STORE_ID#_#getS.LOCATION_ID#'>
    <cfset "attributes.deliver_dept#i#"='#getS.STORE_ID#-#getS.LOCATION_ID#'>
    <cfif isDefined("it.converted_sid")>
    <cfset "attributes.converted_sid#i#"=it.converted_sid>
    <cfelse>
        <cfset "attributes.converted_sid#i#"=0>
</cfif>
    <!----<cfset "attributes.deliver_loc_id#i#"=getS.LOCATION_ID>
    <cfif isdefined("attributes.raflar.sl_#RAF#")>
        <cfset "attributes.raflar.sl_#RAF#"="#evaluate("attributes.raflar.sl_#RAF#")#,#it.stock_id#_#filternum(it.amount)#">
    <cfelse>
        <cfset "attributes.raflar.sl_#RAF#"="#it.stock_id#_#filternum(it.amount)#">
    </cfif>----->
   <cfscript>
         O={
            STORE_ID=getS.STORE_ID,
            LOCATION_ID=getS.LOCATION_ID,
            STOCK_ID=it.stock_id,
            AMOUNT=filternum(it.amount),
            SHELF_NUMBER=getS.PRODUCT_PLACE_ID,
            SHELF_NUMBER_TXT=it.shelf_code,
            ROW_UNIQ_ID=evaluate("attributes.row_unique_relation_id#i#")
        };
        queryAddRow(wrq,O);
   </cfscript>
</cfloop>
<cfdump var="#attributes#">
<cfif session.ep.USERID eq 1146>

</cfif>
<cfquery name="get_ProcessTypeEshipping" datasource="#dsn#">
	SELECT
    	TOP (1)
		PT.PROCESS_ID,
		PT.PROCESS_NAME,
		PT.IS_STAGE_BACK,
		PT.MAIN_FILE,
		PT.IS_MAIN_FILE,
		PT.MAIN_ACTION_FILE,
		PT.IS_MAIN_ACTION_FILE
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_OUR_COMPANY PTOC
	WHERE
      	PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTOC.PROCESS_ID AND
		CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%sales.popup_add_ezgi_shipping%' 
	ORDER BY
		PTOC.OUR_COMPANY_ID,
		PT.PROCESS_ID
</cfquery>
<cfif not get_ProcessTypeEshipping.recordcount>
	<script type="text/javascript">
		alert("E-Shipping Süreci Tanımlayınız!");
		history.back();	
	</script>
<cfelse>
	<cfset process_stage_eshipping = get_ProcessTypeEshipping.PROCESS_ID>
</cfif>
<cfset attributes.process_stage_eshipping=process_stage_eshipping>
 Açmayı Unutma !!!!!!!!!!!!
<cfif len(FormData.OrderHeader.ORDER_ID)>
    upd_offer_tv
    <cfinclude template="../includes/upd_offer_tv.cfm">
<CFELSE>
    add_offer
    <cfinclude template="../includes/add_offer.cfm">
</cfif>

<cfset attributes.RELATED_ACTION_TABLE="PBS_OFFER">
<cfif len(attributes.offer_id)>
    <cfset offfr_id=attributes.offer_id>
<cfelse>
    <cfset attributes.offer_id=get_max_offer.max_id>
    <cfset offfr_id=attributes.offer_id>
</cfif>
pos 1 <br>
<cfquery name="getOfferToOrder" datasource="#dsn3#">
    SELECT * FROM PBS_OFFER_TO_ORDER WHERE OFFER_ID=#attributes.OFFER_ID#
</cfquery>
pos 2 <br>
<CFSET ORDER_ID=getOfferToOrder.ORDER_ID>
<cfif listfind(FormData.OrderHeader.ISLEM_TIPI_PBS,"2")>
    siparişi burda kaydet
   <cfif getOfferToOrder.recordCount>
    pos 3 <br>
   <cfelse>
    pos 4 <br>
    <cfif FormData.WORKING_PARAMS.CURRENCY_FROM eq 0>
        <cfquery name="getMoneyext" datasource="#dsn3#">
            SELECT 
         (SELECT RATE1 FROM #dsn#.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
         SELECT MAX(MONEY_HISTORY_ID) FROM #dsn#.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
         (SELECT EFFECTIVE_SALE RATE2 FROM #dsn#.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
         SELECT MAX(MONEY_HISTORY_ID) FROM #dsn#.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE2,
         SM.MONEY
         FROM #dsn#.SETUP_MONEY AS SM WHERE SM.PERIOD_ID=#session.ep.period_id#
         </cfquery>
         <cfset ibnm=1>
<cfloop query="getMoneyext">
    <cfset "attributes._txt_rate1_#ibnm#"=RATE1>
    <cfset "attributes._txt_rate2_#ibnm#"=RATE2>
    <cfset "attributes.txt_rate1_#ibnm#"=RATE1>
    <cfset "attributes.txt_rate2_#ibnm#"=RATE2>
    <cfset ibnm=ibnm+1>
</cfloop>

    </cfif>
        <cfset attributes.order_date=now()>
        <cfset attributes.order_employee_id=session.ep.userid>
        <cfset attributes.order_employee="#session.ep.NAME# #session.ep.SURNAME#">
        <cfset attributes.order_head=attributes.offer_head>
        <cfset attributes.deliver_dept_id=FormData.WORKING_PARAMS.SEVK_DEPARTMENT_ID>
        <cfset attributes.deliver_dept_name="departmanadi">
        <cfset attributes.deliver_loc_id=FormData.WORKING_PARAMS.SEVK_LOCATION_ID>
        <cfinclude template="../includes/add_order.cfm">
    
        <cfquery name="add_rel_partner" datasource="#dsn3#">
            INSERT INTO  PBS_OFFER_TO_ORDER(OFFER_ID ,ORDER_ID) VALUES(#attributes.offer_id#,#GET_MAX_ORDER.MAX_ID#)
        </cfquery>
        <CFSET ORDER_ID=GET_MAX_ORDER.MAX_ID>
        <cfscript>
            rezerveEklePartner(dsn3,1,ORDER_ID);
        </cfscript>
        <!--- Aşaması Tedarik Olanların Depolarının Malkabule Çekilmesi---->
<cfquery name="getOrderRow" datasource="#dsn3#">
    UPDATE  ORDER_ROW 
    SET 
        DELIVER_DEPT=#FormData.WORKING_PARAMS.ENTRY_DEPARTMENT_ID#,
        DELIVER_LOCATION=#FormData.WORKING_PARAMS.ENTRY_LOCATION_ID# 
    WHERE ORDER_ID=#GET_MAX_ORDER.MAX_ID# AND ORDER_ROW_CURRENCY=-2
</cfquery>


    </cfif>
</cfif>
<cfdump var="#FormData#">

<cfset PRODUCT_ARR_6=arrayNew(1)>
<cfset PRODUCT_ARR_5=arrayNew(1)>
<cfset PRODUCT_ARR_2=arrayNew(1)>

<cfloop array="#BasketRows#" item="it">
    <cfif it.orderrow_currency eq "-5">
        <cfscript>
            arrayAppend(PRODUCT_ARR_5,it);
        </cfscript>
    </cfif>
    <cfif it.orderrow_currency eq "-6">
        <cfscript>
            arrayAppend(PRODUCT_ARR_6,it);
        </cfscript>
    </cfif>
    <cfif it.orderrow_currency eq "-2">
        <cfscript>
            arrayAppend(PRODUCT_ARR_2,it);
        </cfscript>
    </cfif>
</cfloop>


<cfif listfind(FormData.OrderHeader.ISLEM_TIPI_PBS,"3") or getOfferToOrder.recordCount>
    <cfquery name="GETSR" datasource="#DSN3#">
        SELECT * FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW WHERE ORDER_ID=#ORDER_ID#
    </cfquery>        
    <cfif GETSR.recordCount>
        <cfset SH_RES_ID_PRT=GETSR.SHIP_RESULT_ID>
    <cfelse>            
        <cfinclude template="../includes/add_e_shipping_1.cfm">
        <cfset SH_RES_ID_PRT=MAX_ID.IDENTITYCOL>
    </cfif>
    <cfquery name="getSVKNumberPrt" datasource="#dsn3#">
        select DELIVER_PAPER_NO from #dsn3#.PRTOTM_SHIP_RESULT where SHIP_RESULT_ID=#SH_RES_ID_PRT#
    </cfquery>
    <cfif listfind(FormData.OrderHeader.ISLEM_TIPI_PBS,"4")>            
        <cfset structClear(attributes)>         
        <cfquery name="wrq" dbtype="query">
            select * from wrq order by LOCATION_ID
        </cfquery>                                                       
        <cfquery name="UPD_SEVKIYAT_KONTROL" datasource="#dsn3#">
            INSERT INTO 
            PRTOTM_SHIPPING_PACKAGE_LIST
                (
                SHIPPING_ID, 
                STOCK_ID, 
                AMOUNT, 
                CONTROL_AMOUNT, 
                CONTROL_STATUS, 
                TYPE, 
                RECORD_EMP, 
                RECORD_DATE
                )
            SELECT        
                E.SHIP_RESULT_ID, 
                ORR.STOCK_ID, 
                ORR.QUANTITY, 
                ORR.QUANTITY AS A, 
                2 AS B, 
                1 AS C, 
                #session.ep.userid#,
                #now()#
            FROM            
            PRTOTM_SHIP_RESULT_ROW AS E INNER JOIN
                ORDER_ROW AS ORR ON E.ORDER_ROW_ID = ORR.ORDER_ROW_ID
            WHERE        
                E.SHIP_RESULT_ID = #SH_RES_ID_PRT#
        </cfquery>
        <cfinclude template="../includes/ptypes.cfm">
        <cfset form.process_cat = attributes.process_cat_id>            
        <cfloop query="wrq" group="LOCATION_ID">               
            <cfset ix=1>
            <cfset structClear(attributes)>
            <cfset attributes.fuseaction=fs>
            <cfset attributes.active_period=session.ep.period_id> 
            <cfif isDefined("get_GEN_PAP.FISNO")>
                <cfset attributes.REF_NO = get_GEN_PAP.FISNO>
            <cfelse>
                <cfset attributes.REF_NO = getSVKNumberPrt.DELIVER_PAPER_NO>
            </cfif>
            <cf_papers paper_type="stock_fis">
            <cfif isdefined("paper_full") and isdefined("paper_number")>
                <cfset system_paper_no = paper_full>
            <cfelse>
                <cfset system_paper_no = "">
            </cfif>
            <cfquery name="SS" datasource="#DSN3#">
                UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER=STOCK_FIS_NUMBER+1 WHERE STOCK_FIS_NUMBER IS NOT NULL
                select STOCK_FIS_NO,STOCK_FIS_NUMBER from GENERAL_PAPERS
            </cfquery>
            <cfinclude template="/v16/stock/query/check_our_period.cfm"> 
            <cfinclude template="/v16/stock/query/get_process_cat.cfm">
            <cfset attributes.fis_type = get_process_type.PROCESS_TYPE>
            <cfset attributes.LOCATION_IN=FormData.WORKING_PARAMS.SEVK_LOCATION_ID>
            <cfset attributes.LOCATION_OUT=LOCATION_ID>
            <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
            <cfset attributes.fis_date=now()>
            <cfset attributes.fis_date_h=0>
            <cfset attributes.fis_date_m=0>
            <cfset attributes.process_cat = form.process_cat>
            <cfset attributes.department_out=STORE_ID>
            <cfset attributes.department_in =FormData.WORKING_PARAMS.SEVK_DEPARTMENT_ID>
            <cfset attributes.PROD_ORDER = ''>  
            <cfset attributes.PROD_ORDER_NUMBER = ''>  
            <cfset attributes.PROJECT_HEAD = ''> 
            <cfset attributes.PROJECT_HEAD_IN = ''>  
            <cfset attributes.PROJECT_ID = ''>  
            <cfset attributes.PROJECT_ID_IN = ''> 
            <cfset attributes.member_type='' >
            <cfset attributes.member_name='' >
            <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
            <cfset ATTRIBUTES.FIS_DATE_H  ="00">
            <cfset ATTRIBUTES.FIS_DATE_M  ="0">
            <cfset attributes.rows_=0>
            <cfloop >
                <cfquery name="getSinfo" datasource="#dsn3#">                            
                    select PRODUCT_UNIT.MAIN_UNIT,STOCKS.PRODUCT_UNIT_ID,STOCKS.TAX,STOCKS.PRODUCT_ID,STOCKS.IS_INVENTORY from #dsn3#.STOCKS 
                    left join #dsn3#.PRODUCT_UNIT on PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID and IS_MAIN=1                            
                    where STOCK_ID=#STOCK_ID#
                </cfquery>
                <cfset attributes.rows_=attributes.rows_+1>
                <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
                <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
                <cfset 'attributes.stock_id#ix#' = STOCK_ID>
                <cfset 'attributes.amount#ix#' = AMOUNT>
                <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
                <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
                <cfset 'attributes.tax#ix#' = getSinfo.TAX>
                <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
                <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
                <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
                <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>
                <cfset 'attributes.row_unique_relation_id#ix#' = ROW_UNIQ_ID>
                <cfset ix=ix+1>                        
            </cfloop>
            <cfinclude template="/v16/stock/query/add_ship_fis_1_PBS.cfm">    
            <cfinclude template="/v16/stock/query/add_ship_fis_2_PBS.cfm">
            <cfif isdefined("attributes.rows_")>            
                <cfinclude template="/v16/stock/query/add_ship_fis_3.cfm">
                <cfinclude template="/v16/stock/query/add_ship_fis_4.cfm">                    
            <cfelse>
                <cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
                    INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
                </cfquery>
            </cfif>                                            
        </cfloop>                
    </cfif>
</cfif>
	<cffunction name="get_stock_amount">
		<cfargument name="stock_id">
		<cfquery name="get_pro_stock" datasource="#DSN2#">
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
			FROM
				#dsn_alias#.DEPARTMENT D,
				#dsn3_alias#.PRODUCT P,
				#dsn3_alias#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				P.PRODUCT_ID = S.PRODUCT_ID AND
				S.STOCK_ID = SR.STOCK_ID AND
				D.DEPARTMENT_ID = SR.STORE AND
				D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_in#"> AND
				S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
			GROUP BY
				P.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				D.DEPARTMENT_ID, 
				D.DEPARTMENT_HEAD
		</cfquery>
		<cfreturn get_pro_stock.product_stock>
	</cffunction>


<script>
<cfif FactPBS eq 'sales.list_pbs_offer'>
    window.opener.location.href="/index.cfm?fuseaction=sales.list_pbs_offer&event=upd&offer_id=<cfoutput>#offfr_id#</cfoutput>"
<cfelse>
    window.opener.location.href="/index.cfm?fuseaction=sales.emptypopup_form_add_upd_fast_sale_partner&event=upd&offer_id=<cfoutput>#offfr_id#</cfoutput>"
    </cfif>
    
    <cfif session.ep.userid neq 1146>
    this.close();
</cfif>
</script>
<!----------
    PRICE=ROW_PRICE
PRICE_OTHER=PRICE_OTHER
OTHER_MONEY_VALUE=(PRICE_OTHER*AMOUNT)-((PRICE_OTHER*AMOUNT)*DISCOUNT)/100---------->


<cffunction name="rezerveEklePartner">
   <cfargument name="process_db">
   <cfargument name="is_purchase_sales">
   <cfargument name="reserve_order_id">
   <cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#" result="Res">
        DECLARE @RetryCounter INT
        SET @RetryCounter = 1
        RETRY:
        BEGIN TRY
            INSERT INTO
                #arguments.process_db#.ORDER_ROW_RESERVED
            (
                STOCK_ID,
                PRODUCT_ID,
                SPECT_VAR_ID,
                ORDER_ID,
                <cfif arguments.is_purchase_sales eq 1>
                    RESERVE_STOCK_OUT,
                <cfelse>
                    RESERVE_STOCK_IN,
                </cfif>
                SHELF_NUMBER,
                ORDER_WRK_ROW_ID,
                DEPARTMENT_ID,
                LOCATION_ID		
            )
            SELECT
                ORDER_ROW.STOCK_ID,
                ORDER_ROW.PRODUCT_ID,
                ORDER_ROW.SPECT_VAR_ID,
                ORDER_ROW.ORDER_ID,
                ORDER_ROW.QUANTITY,
                ORDER_ROW.SHELF_NUMBER,
                ORDER_ROW.WRK_ROW_ID,
                ISNULL(ORDER_ROW.DELIVER_DEPT,ORDERS.DELIVER_DEPT_ID),
                ISNULL(ORDER_ROW.DELIVER_LOCATION,ORDERS.LOCATION_ID)
            FROM 
                #arguments.process_db#.ORDER_ROW ORDER_ROW,
                #arguments.process_db#.ORDERS ORDERS
            WHERE
                ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID
                AND ORDERS.ORDER_ID= #arguments.reserve_order_id#
        END TRY
        BEGIN CATCH
            DECLARE @DoRetry bit; 
            DECLARE @ErrorMessage varchar(500)
            SET @doRetry = 0;
            SET @ErrorMessage = ERROR_MESSAGE()
            IF ERROR_NUMBER() = 1205 
            BEGIN
                SET @doRetry = 1; 
            END
            IF @DoRetry = 1
            BEGIN
                SET @RetryCounter = @RetryCounter + 1
                IF (@RetryCounter > 3)
                BEGIN
                    RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
                END
                ELSE
                BEGIN
                    WAITFOR DELAY '00:00:00.05' 
                    GOTO RETRY	
                END
            END
            ELSE
            BEGIN
                RAISERROR(@ErrorMessage, 18, 1)
            END
        END CATCH
    </cfquery>
    <cfdump var="#Res#">
</cffunction>