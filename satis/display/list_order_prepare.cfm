<cfquery name="getD" datasource="#dsn#">
select DEPARTMENT_ID,LOCATION_ID from #dsn#.STOCKS_LOCATION where WIDTH=#session.EP.USERID# OR HEIGHT=#session.EP.USERID# OR DEPTH=#session.EP.USERID#

</cfquery>
<cfset dep_id_list=valueList(getD.DEPARTMENT_ID)>
<cfset loc_id_list=valueList(getD.LOCATION_ID)>



<cfquery name="GETsEVKS" datasource="#dsn3#">
SELECT DISTINCT  O.RECORD_DATE,
SR.DELIVER_PAPER_NO,SR.COMPANY_ID,C.NICKNAME,SR.DELIVERY_DATE,DEPARTMENT_LOCATION,COMMENT,SR.SHIP_RESULT_ID,DELIVER_DEPT,DELIVER_LOCATION ,
#DSN#.getEmployeeWithId(SR.RECORD_EMP) AS KAYDEDEN
FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN #dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
LEFT JOIN (
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dsn2#.STOCK_FIS AS SF 
LEFT JOIN #dsn2#.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
INNER JOIN  #dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
WHERE 1=1 
--AND SRR.SHIP_RESULT_ID=18
--AND ORR.DELIVER_DEPT IN(#dep_id_list#)
--AND ORR.DELIVER_LOCATION IN (#loc_id_list#)
AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)

AND SRR.PREPARE_PERSONAL=#session.EP.USERID#

</cfquery>

<div style="height:80vh">
    <cf_box title="Hazırlama Listesi">
<cf_grid_list>
<cfoutput query="GETsEVKS">
    <tr>
        <td>#currentrow#</td>
        <td>#DELIVER_PAPER_NO#</td>        
        <td>#NICKNAME#</td>
        <td>#KAYDEDEN#</td>
        <td>#dateFormat(DELIVERY_DATE,'dd/mm/yyyy')#</td>        
        <td>#DEPARTMENT_LOCATION# #COMMENT#</td>
        <td><button class="btn btn-success" onclick="pencereacgari(#SHIP_RESULT_ID#,#DELIVER_DEPT#,#DELIVER_LOCATION#)">AC</button></td>
    </tr>
</cfoutput>
</cf_grid_list>
</cf_box>
</div>

<script>
    function pencereacgari(shid,dep,loc){
        windowopen('/index.cfm?fuseaction=stock.emptypopup_add_hazirlama&SHIP_ID='+shid+'&DELIVER_DEPT='+dep+'&DELIVER_LOCATION='+loc,'list');
    }
</script>