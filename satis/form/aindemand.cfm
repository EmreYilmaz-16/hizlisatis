<cfloop list="#attributes.ROWW#" item="li" index="ix">
    <cfset STOCK_ID=evaluate("attributes.STOCK_ID#li#")>
    <cfset AMOUNT=filternum(evaluate("attributes.QUANTITY#li#"))>
    <cfset SHELF_NUMBER=evaluate("attributes.PRODUCT_PLACE_ID#li#")>
    <cfset SHELF_NUMBER_TXT=evaluate("attributes.SHELFCODE#li#")>
    <cfset WRK_ROW_ID=evaluate("attributes.WRK_ROW_ID#li#")>
    <cfset attributes.rows_=0>
    <cfquery name="getSinfo" datasource="#dsn3#">                            
        select PRODUCT_UNIT.MAIN_UNIT,STOCKS.PRODUCT_UNIT_ID,STOCKS.TAX,STOCKS.PRODUCT_ID,STOCKS.IS_INVENTORY from #dsn3#.STOCKS 
        left join #dsn3#.PRODUCT_UNIT on PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID and IS_MAIN=1                            
        where STOCK_ID=#STOCK_ID#
    </cfquery>
    
      <cfset attributes.rows_=attributes.rows_+1>
      <cfquery name="isShelfed" datasource="#dsn3#">
        SELECT * FROM #DSN3#.PRODUCT_PLACE WHERE SHELF_CODE='#SHELF_NUMBER_TXT#' AND STORE_ID=#attributes.DELIVER_DEPT# AND LOCATION_ID=#attributes.DELIVER_LOCATION#
      </cfquery>
      <cfif isShelfed.recordCount>
        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
        <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>
        
      <cfelse>
        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = ''> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = ''>
        <cfset 'attributes.shelf_number#ix#' = ''>
        
    </cfif>
    <cfquery name="GETSP" datasource="#DSN3#">
        select * from SPECT_MAIN where STOCK_ID=#STOCK_ID#  and SPECT_MAIN_ID= (SELECT MAX(SPECT_MAIN_ID) FROM SPECT_MAIN WHERE STOCK_ID=#STOCK_ID#)
    </cfquery>
      <cfset 'attributes.stock_id#ix#' = STOCK_ID>
      <cfset 'attributes.spect_id#ix#' = GETSP.SPECT_MAIN_ID>
      <cfset 'attributes.amount#ix#' = AMOUNT>
      <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
      <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
      <cfset 'attributes.tax#ix#' = getSinfo.TAX>
      <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
      <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
      <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">      
      <cfset 'attributes.wrk_row_relation_id#ix#'=WRK_ROW_ID>
      <cfset ix=ix+1>   
</cfloop>