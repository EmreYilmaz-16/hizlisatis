<cfset attributes.ACTIVE_PERIOD =session.ep.period_id>
<cfquery name="SS" datasource="#DSN3#">
    UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER=STOCK_FIS_NUMBER+1 WHERE STOCK_FIS_NUMBER IS NOT NULL
    select STOCK_FIS_NO,STOCK_FIS_NUMBER from GENERAL_PAPERS
</cfquery>
<cfinclude template="/v16/stock/query/check_our_period.cfm"> 
<cfinclude template="/v16/stock/query/get_process_cat.cfm">  


<cfset attributes.fis_type = get_process_type.PROCESS_TYPE>

<cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
<cfset attributes.fis_date=now()>
<cfset attributes.fis_date_h=0>
<cfset attributes.fis_date_m=0>

<cfset attributes.PROD_ORDER = ''>  
<cfset attributes.PROD_ORDER_NUMBER = ''>  
<cfset attributes.PROJECT_HEAD = PROJECT_HEAD> 
<cfset attributes.PROJECT_HEAD_IN = PROJECT_HEAD_IN>  
<cfset attributes.PROJECT_ID = PROJECT_ID>  
<cfset attributes.PROJECT_ID_IN = PROJECT_ID_IN> 
<cfset attributes.member_type='' >
<cfset attributes.member_name='' >
<cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
<cfset ATTRIBUTES.FIS_DATE_H  ="00">
<cfset ATTRIBUTES.FIS_DATE_M  ="0">
<cfset attributes.rows_=0>
<cfdump var="#attributes#">

<cfloop list="#attributes.ROWW#" item="li" index="ix">
    <cfset STOCK_ID=evaluate("attributes.STOCK_ID#li#")>
    <cfset AMOUNT=evaluate("attributes.QUANTITY#li#")>
    <cfif isDefined(trim("attributes.PRODUCT_PLACE_ID#li#")) and len(evaluate("attributes.PRODUCT_PLACE_ID#li#"))><cfset SHELF_NUMBER=evaluate("attributes.PRODUCT_PLACE_ID#li#")><cfelse><cfset SHELF_NUMBER=""></cfif>
  <cfif isDefined(trim("attributes.SHELFCODE#li#")) and len(evaluate("attributes.SHELFCODE#li#"))><cfset SHELF_NUMBER_TXT=evaluate("attributes.SHELFCODE#li#")><cfelse><cfset SHELF_NUMBER_TXT="YOK_ARTIK_ARKADAS"></cfif>
    <cfif not isDefined(trim("attributes.uniq_relation_id_#li#"))>
      <cfset "attributes.uniq_relation_id_#li#"="">
    </cfif>
    <cfset ROW_UNIQ_RELATION=evaluate("attributes.uniq_relation_id_#li#")>
    <cfquery name="getSinfo" datasource="#dsn3#">                            
        select PRODUCT_UNIT.MAIN_UNIT,STOCKS.PRODUCT_UNIT_ID,STOCKS.TAX,STOCKS.PRODUCT_ID,STOCKS.IS_INVENTORY from #dsn3#.STOCKS 
        left join #dsn3#.PRODUCT_UNIT on PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID and IS_MAIN=1                            
        where STOCK_ID=#STOCK_ID#
    </cfquery>
    <cfset attributes.rows_=attributes.rows_+1>
    <cfif len(attributes.department_out)>
      
      <cfquery name="isShelfed" datasource="#dsn3#">
        SELECT * FROM #DSN3#.PRODUCT_PLACE WHERE SHELF_CODE='#SHELF_NUMBER_TXT#' AND STORE_ID=#attributes.department_out# AND LOCATION_ID=#attributes.LOCATION_OUT#
      </cfquery>
      <cfelse>
      
      </cfif>
      
      <cfif isDefined("isShelfed") and isShelfed.recordCount>
        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
        <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>
        
      <cfelse>
        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = ''> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = ''>
        <cfset 'attributes.shelf_number#ix#' = ''>
        
    </cfif>
      <cfset 'attributes.stock_id#ix#' = STOCK_ID>
      <cfset 'attributes.amount#ix#' = AMOUNT>
      <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
      <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
      <cfset 'attributes.tax#ix#' = getSinfo.TAX>
      <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
      <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
      <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
      <cfset 'attributes.row_unique_relation_id#ix#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
      <cfset "attributes.amount_other#ix#"=amount_other>
      <cfset "attributes.unit_other#ix#"=unit_other>
      <cfset "attributes.lot_no#ix#"=lot_no>
      <cfset ix=ix+1>   
</cfloop>
<cfinclude template="/v16/stock/query/add_ship_fis_1_PBS.cfm">    
<cfinclude template="/v16/stock/query/add_ship_fis_2_PBS.cfm">
<cfif isdefined("attributes.rows_")>            
    <cfinclude template="/v16/stock/query/add_ship_fis_3.cfm">
    <cfinclude template="/v16/stock/query/add_ship_fis_4_PBS.cfm">                    
<cfelse>
    <cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
        INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
    </cfquery>
</cfif>   