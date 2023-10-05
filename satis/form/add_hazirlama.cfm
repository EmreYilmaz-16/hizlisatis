
<cf_box title="Ürün Hazırla">
<cfif attributes.IS_SVK eq 1>
    <cfquery name="GETS" datasource="#DSN3#">
SELECT SS.PRODUCT_NAME
	,SS.PRODUCT_CODE
	,SS.STOCK_ID
	,PP.PRODUCT_PLACE_ID
	,PB.BRAND_NAME
	,PP.SHELF_CODE
	,IR.WRK_ROW_ID
	,IR.I_ROW_ID
	,IR.QUANTITY
	,ISNULL(S.AMOUNT, 0) AS AMOUNT
	,I.INTERNAL_NUMBER
	,I.DEPARTMENT_OUT
	,I.LOCATION_OUT
	,I.PROJECT_ID
	,#DSN#.getEmployeeWithId(EP.EMPLOYEE_ID) AS PERSONAL
	,PREPARE_PERSONAL
	,I.INTERNAL_ID
	,D.DEPARTMENT_HEAD
	,SL.COMMENT
FROM #DSN3#.INTERNALDEMAND AS I
LEFT JOIN #DSN3#.INTERNALDEMAND_ROW AS IR ON IR.I_ID = I.INTERNAL_ID
LEFT JOIN (
	SELECT SUM(AMOUNT) AMOUNT
		,WRK_ROW_RELATION_ID
	FROM (
		SELECT AMOUNT
			,WRK_ROW_RELATION_ID
		FROM #DSN2#.SHIP_ROW AS S
		
		UNION
		
		SELECT AMOUNT
			,WRK_ROW_RELATION_ID
		FROM #DSN#_#YEAR(NOW())-1#_1.SHIP_ROW AS S
		) AS T
	GROUP BY WRK_ROW_RELATION_ID
	) S ON S.WRK_ROW_RELATION_ID = IR.WRK_ROW_ID
LEFT JOIN #DSN#.EMPLOYEE_POSITIONS AS EP ON EP.POSITION_CODE = I.FROM_POSITION_CODE
LEFT JOIN #DSN#.DEPARTMENT AS D ON D.DEPARTMENT_ID = I.DEPARTMENT_OUT
LEFT JOIN #DSN#.STOCKS_LOCATION AS SL ON SL.LOCATION_ID = I.LOCATION_OUT
	AND SL.DEPARTMENT_ID = I.DEPARTMENT_OUT
LEFT JOIN #DSN3#.STOCKS AS SS ON SS.STOCK_ID = IR.STOCK_ID
LEFT JOIN #DSN3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID = SS.STOCK_ID
LEFT JOIN #DSN3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = SS.BRAND_ID
LEFT JOIN #DSN3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
	AND PP.STORE_ID = D.DEPARTMENT_ID
	AND PP.LOCATION_ID = SL.LOCATION_ID
WHERE DEMAND_TYPE = 0
	AND IR.QUANTITY - ISNULL(S.AMOUNT, 0) > 0
	AND I.PROJECT_ID IS NOT NULL
	AND DEPARTMENT_OUT = #attributes.DELIVER_DEPT#
	AND LOCATION_OUT = #attributes.DELIVER_LOCATION#
	AND I.INTERNAL_ID = #attributes.SHIP_ID#
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
            <th>Ürün Kodu</th>
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
                <input type="hidden" name="SHIP_RESULT_ROW_ID#currentrow#" value="#I_ROW_ID#">
                <input type="hidden" name="shelfcode#currentrow#" value="#SHELF_CODE#">
                <input type="hidden" name="PRODUCT_PLACE_ID#currentrow#" value="#PRODUCT_PLACE_ID#">
                <input type="hidden" name="WRK_ROW_ID#currentrow#" value="#WRK_ROW_ID#">
                #SHELF_CODE#</td>
                <td>#PRODUCT_CODE#</td>
            <td>#PRODUCT_NAME#</td>
            <td>#BRAND_NAME#</td>
            <td style="width:15%"><div class="form-group"><input type="text" data-kmp="#KM_P#" <cfif KM_P gte 1> onchange="setKarmaMi(this,#STOCK_ID#)"</cfif> name="quantity#currentrow#" value="#tlformat(QUANTITY-AMOUNT,2)#" style="padding-right: 0;text-align: right"></div></td>
            <td>
                <cfquery name="getSrQ" datasource="#dsn2#">
                    select sum(STOCK_IN-STOCK_OUT) AS BAKIYE from #dsn2#.STOCKS_ROW where 1=1
                     and STOCK_ID=#STOCK_ID# 
                AND STORE=#attributes.DELIVER_DEPT# AND STORE_LOCATION=#attributes.DELIVER_LOCATION#
                </cfquery>
                #getSrQ.BAKIYE#
            </td>
            <td></td>
            <td></td>
            <td style="width:%10">
                <cfif 0 gte 1>
                <cfquery name="getKp" datasource="#dsn3#">
                    SELECT * FROM PBS_OFFER_ROW_KARMA_PRODUCTS WHERE REL_UNIQUE_RELATION_ID ='#UNIQUE_RELATION_ID#'
                </cfquery>
                <cfloop query="getKp"></cfloop>
                <cfelse>
                    <button style="width:100%" type="button" <cfif AMOUNT GTE QUANTITY>class="btn btn-success" disabled <cfelse> class="btn btn-danger"</cfif> id="chkbtn#currentrow#" onclick="checkT(#currentrow#)">
                        <cfif AMOUNT GTE QUANTITY>&##10003<cfelse>X</cfif>
                    </button>
                </cfif>         
                <input type="checkbox"  <cfif AMOUNT GTE QUANTITY>disabled checked</cfif> value="#currentrow#" name="roww" id="is_add#currentrow#"style="display:none"></td>
        </tr>
        <cfif KM_P gte 1>
            <cfquery name="getKp" datasource="#dsn3#">
           select PORK.*,S.PRODUCT_CODE,S.PRODUCT_NAME,PP.SHELF_CODE,PB.BRAND_NAME,S.STOCK_ID,SF.AMOUNT as AMOUNT_2 from #dsn3#.PBS_OFFER_ROW_KARMA_PRODUCTS AS PORK
LEFT JOIN #dsn3#.STOCKS AS S ON S.PRODUCT_ID=PORK.PRODUCT_ID 
LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR. STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP .PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #dsn3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=S.BRAND_ID 
LEFT JOIN (
		SELECT sum(SFR.AMOUNT) AS AMOUNT
			,UNIQUE_RELATION_ID
		FROM #dsn2#.STOCK_FIS_ROW AS SFR
		GROUP BY UNIQUE_RELATION_ID
		) AS SF ON SF.UNIQUE_RELATION_ID = PORK.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE PORK.REL_UNIQUE_RELATION_ID='#UNIQUE_RELATION_ID#' 
            </cfquery>
            <cfloop query="getKp">
                <tr>
                    <td>#SHELF_CODE#</td>
                    <td>#PRODUCT_CODE#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#BRAND_NAME#</td>
                    <td><div class="form-group" style="display:flex">
                        <input type="text" name="quantity#getS.currentrow#_#currentrow#" value="#tlformat(((getS.QUANTITY-getS.AMOUNT)*AMOUNT),2)#" style="padding-right: 0;text-align: disabled right">
                        <input type="text" name="quantity22_#getS.currentrow#_#currentrow#" value="#tlformat(AMOUNT,2)#" style="padding-right: 0;text-align: right;width:25% !important;margin-left:2px !important" disabled readonly>
                    </div>
                        </td>
                    <td>
                        <cfquery name="getSrQR" datasource="#dsn2#">
                            select sum(STOCK_IN-STOCK_OUT) AS BAKIYE from #dsn2#.STOCKS_ROW where 1=1
                             and STOCK_ID=#STOCK_ID# 
                        AND STORE=#attributes.DELIVER_DEPT# AND STORE_LOCATION=#attributes.DELIVER_LOCATION#
                        </cfquery>
                        #getSrQR.BAKIYE#
                    </td>
                    <td>#getS.DETAIL_INFO_EXTRA#</td>
                    <td>#getS.DESCRIPTION#</td>
                    <td>
                        <button style="width:100%" type="button" <cfif AMOUNT_2 GTE AMOUNT>class="btn btn-success" disabled <cfelse> class="btn btn-danger"</cfif> id="chkbtn#getS.currentrow#_#currentrow#" onclick="checkTKarma(#getS.currentrow#,#currentrow#)">
                            <cfif AMOUNT_2 GTE AMOUNT>&##10003<cfelse>X</cfif>
                        </button>
                        <input type="checkbox"  <cfif AMOUNT_2 GTE AMOUNT>disabled checked</cfif> value="#getS.currentrow#-#currentrow#" name="roww" id="is_add#getS.currentrow#_#currentrow#" disabled style="display:none">
                    </td>
                </tr>
            </cfloop>
            <tfoot>
                <tr>
                    <td colspan="9">
                        <button type="button" onclick="CheckKarmaKoli(#gets.currentRow#,#QUANTITY-AMOUNT#)">Karma Koli Kontrol</button>
                    </td>
                </tr>
            </tfoot>
        </cfif>
    </cfoutput>
</tbody>
</cf_big_list>
</div>
</cfform>
<cfelse>
  
    <cfform name="sf"></cfform>

<cfquery name="getS" datasource="#dsn3#">
SELECT ISNULL(AMOUNT, 0) AMOUNT
	,DELIVER_DEPT
	,DELIVER_LOCATION
	,PRODUCT_NAME
	,PRODUCT_PLACE_ID
	,QUANTITY
	,SHELF_CODE
	,SHIP_RESULT_ROW_ID
	,STOCK_ID
	,DETAIL_INFO_EXTRA
	,BRAND_NAME
	,PRODUCT_CODE
	,DESCRIPTION
	,UNIQUE_RELATION_ID
    ,KM_P
FROM (
	SELECT ORR.QUANTITY
		,ORR.UNIQUE_RELATION_ID
		,SF.AMOUNT
		,S.PRODUCT_NAME
		,S.PRODUCT_CODE
		,PP.SHELF_CODE
		,ORR.DELIVER_DEPT
		,ORR.DELIVER_LOCATION
		,S.STOCK_ID
		,SRR.SHIP_RESULT_ROW_ID
		,PP.PRODUCT_PLACE_ID
		,ORR.DETAIL_INFO_EXTRA
		,B.BRAND_NAME
		,ORR.DESCRIPTION
        ,(SELECT COUNT(*) FROM PBS_OFFER_ROW_KARMA_PRODUCTS WHERE REL_UNIQUE_RELATION_ID=ORR.UNIQUE_RELATION_ID ) AS KM_P
	FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
	LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = SRR.ORDER_ROW_ID
	LEFT JOIN #dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID
	LEFT JOIN (
		SELECT sum(SFR.AMOUNT) AS AMOUNT
			,UNIQUE_RELATION_ID
		FROM #dsn2#.STOCK_FIS_ROW AS SFR
		GROUP BY UNIQUE_RELATION_ID
		) AS SF ON SF.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID = ORR.STOCK_ID
	LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID = S.STOCK_ID
	LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
	LEFT JOIN #DSN1#.PRODUCT_BRANDS AS B ON B.BRAND_ID = S.BRAND_ID
	WHERE SRR.SHIP_RESULT_ID = #attributes.SHIP_ID#
		AND ORR.DELIVER_DEPT = #attributes.DELIVER_DEPT#
		AND DELIVER_LOCATION = #attributes.DELIVER_LOCATION#
	) AS TSL

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
            <th>Ürün Kodu</th>
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
                <input type="hidden" name="uniq_relation_id_#currentrow#" value="#UNIQUE_RELATION_ID#">
                #SHELF_CODE#</td>
                <td>#PRODUCT_CODE#</td>
            <td>#PRODUCT_NAME#</td>
            <td>#BRAND_NAME#</td>
            <td style="width:15%"><div class="form-group"><input type="text" data-kmp="#KM_P#" <cfif KM_P gte 1> onchange="setKarmaMi(this,#STOCK_ID#)"</cfif> name="quantity#currentrow#" value="#tlformat(QUANTITY-AMOUNT,2)#" style="padding-right: 0;text-align: right"></div></td>
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
            <td style="width:%10">
                <cfif 0 gte 1>
                <cfquery name="getKp" datasource="#dsn3#">
                    SELECT * FROM PBS_OFFER_ROW_KARMA_PRODUCTS WHERE REL_UNIQUE_RELATION_ID ='#UNIQUE_RELATION_ID#'
                </cfquery>
                <cfloop query="getKp"></cfloop>
                <cfelse>
                    <button style="width:100%" type="button" <cfif AMOUNT GTE QUANTITY>class="btn btn-success" disabled <cfelse> class="btn btn-danger"</cfif> id="chkbtn#currentrow#" onclick="checkT(#currentrow#)">
                        <cfif AMOUNT GTE QUANTITY>&##10003<cfelse>X</cfif>
                    </button>
                </cfif>         
                <input type="checkbox"  <cfif AMOUNT GTE QUANTITY>disabled checked</cfif> value="#currentrow#" name="roww" id="is_add#currentrow#"style="display:none"></td>
        </tr>
        <cfif KM_P gte 1>
            <cfquery name="getKp" datasource="#dsn3#">
           select PORK.*,S.PRODUCT_CODE,S.PRODUCT_NAME,PP.SHELF_CODE,PB.BRAND_NAME,S.STOCK_ID,SF.AMOUNT as AMOUNT_2 from #dsn3#.PBS_OFFER_ROW_KARMA_PRODUCTS AS PORK
LEFT JOIN #dsn3#.STOCKS AS S ON S.PRODUCT_ID=PORK.PRODUCT_ID 
LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR. STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP .PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #dsn3#.PRODUCT_BRANDS AS PB ON PB.BRAND_ID=S.BRAND_ID 
LEFT JOIN (
		SELECT sum(SFR.AMOUNT) AS AMOUNT
			,UNIQUE_RELATION_ID
		FROM #dsn2#.STOCK_FIS_ROW AS SFR
		GROUP BY UNIQUE_RELATION_ID
		) AS SF ON SF.UNIQUE_RELATION_ID = PORK.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE PORK.REL_UNIQUE_RELATION_ID='#UNIQUE_RELATION_ID#' 
            </cfquery>
            <cfloop query="getKp">
                <tr>
                    <td>#SHELF_CODE#</td>
                    <td>#PRODUCT_CODE#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#BRAND_NAME#</td>
                    <td><div class="form-group" style="display:flex">
                        <input type="text" name="quantity#getS.currentrow#_#currentrow#" value="#tlformat(((getS.QUANTITY-getS.AMOUNT)*AMOUNT),2)#" style="padding-right: 0;text-align: disabled right">
                        <input type="text" name="quantity22_#getS.currentrow#_#currentrow#" value="#tlformat(AMOUNT,2)#" style="padding-right: 0;text-align: right;width:25% !important;margin-left:2px !important" disabled readonly>
                    </div>
                        </td>
                    <td>
                        <cfquery name="getSrQR" datasource="#dsn2#">
                            select sum(STOCK_IN-STOCK_OUT) AS BAKIYE from #dsn2#.STOCKS_ROW where 1=1
                             and STOCK_ID=#STOCK_ID# 
                        AND STORE=#attributes.DELIVER_DEPT# AND STORE_LOCATION=#attributes.DELIVER_LOCATION#
                        </cfquery>
                        #getSrQR.BAKIYE#
                    </td>
                    <td>#getS.DETAIL_INFO_EXTRA#</td>
                    <td>#getS.DESCRIPTION#</td>
                    <td>
                        <button style="width:100%" type="button" <cfif AMOUNT_2 GTE AMOUNT>class="btn btn-success" disabled <cfelse> class="btn btn-danger"</cfif> id="chkbtn#getS.currentrow#_#currentrow#" onclick="checkTKarma(#getS.currentrow#,#currentrow#)">
                            <cfif AMOUNT_2 GTE AMOUNT>&##10003<cfelse>X</cfif>
                        </button>
                        <input type="checkbox"  <cfif AMOUNT_2 GTE AMOUNT>disabled checked</cfif> value="#getS.currentrow#-#currentrow#" name="roww" id="is_add#getS.currentrow#_#currentrow#" disabled style="display:none">
                    </td>
                </tr>
            </cfloop>
            <tfoot>
                <tr>
                    <td colspan="9">
                        <button type="button" onclick="CheckKarmaKoli(#gets.currentRow#,#QUANTITY-AMOUNT#)">Karma Koli Kontrol</button>
                    </td>
                </tr>
            </tfoot>
        </cfif>
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
        <cfif session.ep.userid eq 1146>
            <cfdump var="#attributes#">
            </cfif>
        <cfloop list="#attributes.ROWW#" item="li" index="ix">
            <cfset STOCK_ID=evaluate("attributes.STOCK_ID#li#")>
            <cfset AMOUNT=filternum(evaluate("attributes.QUANTITY#li#"))>
            <cfset SHELF_NUMBER=evaluate("attributes.PRODUCT_PLACE_ID#li#")>
            <cfset SHELF_NUMBER_TXT=evaluate("attributes.SHELFCODE#li#")>
            <cfset ROW_UNIQ_RELATION=evaluate("attributes.uniq_relation_id_#li#")>
            <cfquery name="getSinfo" datasource="#dsn3#">                            
                select PRODUCT_UNIT.MAIN_UNIT,STOCKS.PRODUCT_UNIT_ID,STOCKS.TAX,STOCKS.PRODUCT_ID,STOCKS.IS_INVENTORY from #dsn3#.STOCKS 
                left join #dsn3#.PRODUCT_UNIT on PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID and IS_MAIN=1                            
                where STOCK_ID=#STOCK_ID#
            </cfquery>
            
              <cfset attributes.rows_=attributes.rows_+1>
              <cfquery name="isShelfed" datasource="#dsn3#">
                SELECT * FROM #DSN3#.PRODUCT_PLACE WHERE SHELF_CODE='#SHELF_NUMBER_TXT#' AND STORE_ID=#attributes.department_out# AND LOCATION_ID=#attributes.LOCATION_OUT#
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
              <cfset 'attributes.stock_id#ix#' = STOCK_ID>
              <cfset 'attributes.amount#ix#' = AMOUNT>
              <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
              <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
              <cfset 'attributes.tax#ix#' = getSinfo.TAX>
              <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
              <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
              <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
              <cfset 'attributes.row_unique_relation_id#ix#'=ROW_UNIQ_RELATION>
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
<script>
    //window.location.href="/index.cfm?fuseaction=sales.list_pbs_order_prepare";
    window.opener.location.reload();
    this.close();
</script>
</cfif>

</cfif> 
</cf_box>

<script>
    <cfinclude template="../js/addHazirlama.js">
    </script>