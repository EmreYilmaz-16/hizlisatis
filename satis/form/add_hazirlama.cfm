<cf_box title="Ürün Hazırla">
    <cfform name="sf"></cfform>
<cfquery name="getS" datasource="#dsn3#">
SELECT  AMOUNT,DELIVER_DEPT,DELIVER_LOCATION,PRODUCT_NAME,PRODUCT_PLACE_ID,QUANTITY,SHELF_CODE,SHIP_RESULT_ROW_ID,STOCK_ID,DETAIL_INFO_EXTRA,BRAND_NAME,DESCRIPTION FROM (
SELECT ORR.QUANTITY,SF.AMOUNT,S.PRODUCT_NAME,PP.SHELF_CODE,ORR.DELIVER_DEPT,ORR.DELIVER_LOCATION,S.STOCK_ID,SRR.SHIP_RESULT_ROW_ID,PP.PRODUCT_PLACE_ID,ORR.DETAIL_INFO_EXTRA,B.BRAND_NAME,ORR.DESCRIPTION FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
LEFT JOIN #dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
LEFT JOIN (
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dsn2#.STOCK_FIS AS SF 
LEFT JOIN #dsn2#.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #DSN1#.PRODUCT_BRANDS as B ON B.BRAND_ID=S.BRAND_ID
WHERE SRR.SHIP_RESULT_ID=#attributes.SHIP_ID# AND ORR.DELIVER_DEPT=#attributes.DELIVER_DEPT# AND DELIVER_LOCATION=#attributes.DELIVER_LOCATION#) AS TSL

</cfquery>

<div style="height:60vh">
    <cfform action="#request.self#?fuseaction=#attributes.fuseaction#">
        <cfoutput>
            <input type="hidden" name="SHIP_ID" value="#attributes.SHIP_ID#">
            <input type="hidden" name="DELIVER_DEPT" value="#attributes.DELIVER_DEPT#">
            <input type="hidden" name="DELIVER_LOCATION" value="#attributes.DELIVER_LOCATION#">
        </cfoutput>
<cf_big_list id="basket">
    <thead>
        <tr>
            <th>Raf</th>
            <th>Ürün</th>
            <th>Marka</th>
            <th>Miktar</th>
            <th>Depo</th>
            <th>Ölçü</th>
            <th>Açıklama</th>
            <th></th>

        </tr>
    </thead>
    <tbody>
    <cfoutput query="getS">
       
        <tr>
            <td><input type="hidden" name="STOCK_ID#currentrow#" value="#STOCK_ID#">
                <input type="hidden" name="SHIP_RESULT_ROW_ID#currentrow#" value="#SHIP_RESULT_ROW_ID#">
                <input type="hidden" name="shelfcode#currentrow#" value="#SHELF_CODE#">
                <input type="hidden" name="PRODUCT_PLACE_ID#currentrow#" value="#PRODUCT_PLACE_ID#">
                #SHELF_CODE#</td>
            <td>#PRODUCT_NAME#</td>
            <td>#BRAND_NAME#</td>
            <td style="width:15%"><div class="form-group"><input type="text" name="quantity#currentrow#" value="#tlformat(QUANTITY,2)#" style="padding-right: 0;text-align: right"></div></td>
            <td>
                <cfquery name="getSrQ" datasource="#dsn2#">
                    select sum(STOCK_IN-STOCK_OUT) AS BAKIYE from #dsn2#.STOCKS_ROW where 1=1
                     and STOCK_ID=#STOCK_ID# 
                AND STORE=#attributes.DELIVER_DEPT# AND STORE_LOCATION=#attributes.DELIVER_LOCATION#
                </cfquery>
                #getSrQ.BAKIYE#
            </td>
            <td>#DETAIL_INFO_EXTRA#</td>
            <td>#DESCRIPTION#</td>
            <td style="width:%10"><button style="width:100%" type="button" <cfif AMOUNT GTE QUANTITY>class="btn btn-success" disabled <cfelse> class="btn btn-danger"</cfif> id="chkbtn#currentrow#" onclick="checkT(#currentrow#)">
                <cfif AMOUNT GTE QUANTITY>&##10003<cfelse>X</cfif>
            </button>
                <input type="checkbox" value="#currentrow#" name="roww" id="is_add#currentrow#"style="display:none"></td>
        </tr>
    </cfoutput>
</tbody>
</cf_big_list>
</div>
<input type="submit">
<input type="hidden" name="is_submit" value="1">
</cfform>
<cfif isDefined("attributes.is_submit") >
    
    <cfdump var="#attributes#">
    
    <cfquery name="getParamsPBS" datasource="#dsn3#">
        SELECT * FROM VIRTUAL_OFFER_SETTINGS
    </cfquery>
    
    <cfinclude template="../includes/ptypes.cfm">
    <cfquery name="getSVKNumberPrt" datasource="#dsn3#">
        select DELIVER_PAPER_NO from #dsn3#.PRTOTM_SHIP_RESULT where SHIP_RESULT_ID=#attributes.SHIP_ID#
    </cfquery>
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
        <cfset attributes.active_period=session.ep.period_id>
        <cfquery name="SS" datasource="#DSN3#">
            UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER=STOCK_FIS_NUMBER+1 WHERE STOCK_FIS_NUMBER IS NOT NULL
            select STOCK_FIS_NO,STOCK_FIS_NUMBER from GENERAL_PAPERS
        </cfquery>
        <cfinclude template="/v16/stock/query/check_our_period.cfm"> 
        <cfinclude template="/v16/stock/query/get_process_cat.cfm">        
        <cfset attributes.fis_type = get_process_type.PROCESS_TYPE>
        <cfset attributes.LOCATION_IN=getParamsPBS.SEVK_LOCATION_ID>
        <cfset attributes.LOCATION_OUT=attributes.DELIVER_LOCATION>
        <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
        <cfset attributes.fis_date=now()>
        <cfset attributes.fis_date_h=0>
        <cfset attributes.fis_date_m=0>
        <cfset attributes.process_cat = form.process_cat>
        <cfset attributes.department_out=attributes.DELIVER_DEPT>
        <cfset attributes.department_in =getParamsPBS.SEVK_DEPARTMENT_ID>
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
        <cfdump var="#attributes#">
        <cfloop list="#attributes.ROWW#" item="li" index="ix">
            <cfset STOCK_ID=evaluate("attributes.STOCK_ID#li#")>
            <cfset AMOUNT=filternum(evaluate("attributes.QUANTITY#li#"))>
            <cfset SHELF_NUMBER=evaluate("attributes.PRODUCT_PLACE_ID#li#")>
            <cfset SHELF_NUMBER_TXT=evaluate("attributes.SHELFCODE#li#")>
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
<script>
    //window.location.href="/index.cfm?fuseaction=sales.list_pbs_order_prepare";
    window.opener.location.reload();
    this.close();
</script>
</cfif>
<script>
 function checkT(rowid) {
    var b=document.getElementById("chkbtn"+rowid)
    
var i=document.getElementById("is_add"+rowid)
$(i).click();
    if($(i).is(":checked")){
    b.removeAttribute("class")
    b.setAttribute("class","btn btn-success")
    b.innerHTML="&#10003"
   
}else{
      b.removeAttribute("class")
    b.setAttribute("class","btn btn-danger")
    b.innerText="X"
    
}
    
 }
</script>
</cf_box>