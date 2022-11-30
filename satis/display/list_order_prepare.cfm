﻿<cfquery name="getD" datasource="#dsn#">
select DEPARTMENT_ID,LOCATION_ID from #dsn#.STOCKS_LOCATION where WIDTH=#session.EP.USERID# OR HEIGHT=#session.EP.USERID# OR DEPTH=#session.EP.USERID#

</cfquery>
<cfset dep_id_list=valueList(getD.DEPARTMENT_ID)>
<cfset loc_id_list=valueList(getD.LOCATION_ID)>



<cfquery name="GETsEVKS" datasource="#dsn3#">
SELECT DISTINCT  O.RECORD_DATE,
SR.DELIVER_PAPER_NO,SR.COMPANY_ID,C.NICKNAME,SR.DELIVERY_DATE,DEPARTMENT_LOCATION,COMMENT,SR.SHIP_RESULT_ID,DELIVER_DEPT,DELIVER_LOCATION 
FROM workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS SRR
LEFT JOIN workcube_metosan_1.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
LEFT JOIN workcube_metosan_1.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
LEFT JOIN (
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM workcube_metosan_2022_1.STOCK_FIS AS SF 
LEFT JOIN workcube_metosan_2022_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
INNER JOIN  #dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
WHERE 1=1 
--AND SRR.SHIP_RESULT_ID=18
--AND ORR.DELIVER_DEPT IN(#dep_id_list#)
--AND ORR.DELIVER_LOCATION IN (#loc_id_list#)
AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)

AND SRR.PREPARE_PERSONAL=#session.EP.USERID#
<!----SELECT DISTINCT PSR.DELIVER_PAPER_NO,SRR.SHIP_RESULT_ID,ORR.DELIVER_DEPT,ORR.DELIVER_LOCATION,C.NICKNAME,PSR.DELIVERY_DATE, DEPARTMENT_LOCATION,COMMENT  FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
INNER JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
INNER JOIN #dsn3#.PRTOTM_SHIP_RESULT AS PSR ON PSR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
INNER JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID=PSR.COMPANY_ID
INNER JOIN  #dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
where ORR.DELIVER_DEPT IN(#dep_id_list#) AND ORR.DELIVER_LOCATION IN (#loc_id_list#)
ORDER BY DELIVER_PAPER_NO--->
</cfquery>

<div style="height:80vh">
    <cf_box title="Hazırlama Listesi">
<cf_grid_list>
<cfoutput query="GETsEVKS">
    <tr>
        <td>#currentrow#</td>
        <td>#DELIVER_PAPER_NO#</td>
        <td>#NICKNAME#</td>
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