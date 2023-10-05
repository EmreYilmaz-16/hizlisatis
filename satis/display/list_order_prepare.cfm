<cfquery name="getD" datasource="#dsn#">
select DEPARTMENT_ID,LOCATION_ID 
from #dsn#.STOCKS_LOCATION 
where WIDTH=#session.EP.USERID# OR HEIGHT=#session.EP.USERID# OR DEPTH=#session.EP.USERID#
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
	select sum (SFR.AMOUNT) AS AMOUNT ,UNIQUE_RELATION_ID  FROM workcube_metosan_2023_1.STOCK_FIS_ROW AS SFR GROUP BY UNIQUE_RELATION_ID

		) AS SF ON SF.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
INNER JOIN  #dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
WHERE 1=1 

AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)

AND SRR.PREPARE_PERSONAL=#session.EP.USERID#
AND ORR.ORDER_ROW_CURRENCY NOT IN(-3,-10)

ORDER BY DELIVER_PAPER_NO
</cfquery>
<cfif session.ep.userid eq 1146>
    <cfdump var="#GETsEVKS#">
</cfif>

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
        <td><button class="btn btn-success" onclick="pencereacgari(#SHIP_RESULT_ID#,#DELIVER_DEPT#,#DELIVER_LOCATION#,1)">AC</button></td>
        <td><button class="btn btn-primary" onclick="pencereacgari(#SHIP_RESULT_ID#,#DELIVER_DEPT#,#DELIVER_LOCATION#,2)">Yazdır</button></td>
    </tr>
</cfoutput>
<cfquery name="GETSEVKS_2" datasource="#DSN3#">
 SELECT IR.QUANTITY,ISNULL(S.AMOUNT,0) AS AMOUNT,I.INTERNAL_NUMBER,I.DEPARTMENT_OUT,I.LOCATION_OUT,I.PROJECT_ID,workcube_metosan.getEmployeeWithId(EP.EMPLOYEE_ID) AS PERSONAL,PREPARE_PERSONAL,I.INTERNAL_ID,D.DEPARTMENT_HED,SL.COMMENT,I.DEPARTMENT_OUT,I.LOCATION_OUT FROM workcube_metosan_1.INTERNALDEMAND AS I
LEFT JOIN workcube_metosan_1.INTERNALDEMAND_ROW AS IR ON IR.I_ID=I.INTERNAL_ID
LEFT JOIN (	SELECT SUM(AMOUNT) AMOUNT,WRK_ROW_RELATION_ID FROM (
			SELECT AMOUNT,WRK_ROW_RELATION_ID FROM workcube_metosan_2023_1.SHIP_ROW AS S
			UNION
			SELECT AMOUNT,WRK_ROW_RELATION_ID FROM workcube_metosan_2022_1.SHIP_ROW AS S ) AS T GROUP BY WRK_ROW_RELATION_ID )
			S ON S.WRK_ROW_RELATION_ID=IR.WRK_ROW_ID
LEFT JOIN workcube_metosan.EMPLOYEE_POSITIONS AS EP ON EP.POSITION_CODE=I.FROM_POSITION_CODE
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=I.DEPARTMENT_OUT
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=I.LOCATION_OUT AND SL.DEPARTMENT_ID=I.DEPARTMENT_OUT

WHERE DEMAND_TYPE=0   AND IR.QUANTITY-ISNULL(S.AMOUNT,0)>0 AND I.PROJECT_ID IS NOT NULL

AND IR.PREPARE_PERSONAL = #session.EP.USERID#
</cfquery>
<tr><TH colspan="7">İç Talepler</TH></tr>
<cfoutput query="GETsEVKS_2">
    <tr>
        <td>#currentrow#</td>
        <td>#INTERNAL_NUMBER#</td>        
        <td>IC TALEP</td>
        <td>#PERSONAL#</td>
        <td>#dateFormat(now(),'dd/mm/yyyy')#</td>        
        <td>#DEPARTMENT_HEAD# #COMMENT#</td>
        <td><button class="btn btn-success" onclick="pencereacgari(#INTERNAL_ID#,#DEPARTMENT_OUT#,#LOCATION_OUT#,1,#IS_SVK#)">AC</button></td>
        <td><button class="btn btn-primary" onclick="pencereacgari(#INTERNAL_ID#,#DEPARTMENT_OUT#,#LOCATION_OUT#,2,#IS_SVK#)">Yazdır</button></td>
    </tr>
</cfoutput>
</cf_grid_list>
</cf_box>
</div>

<script>
function pencereacgari(shid, dep, loc, t, IS_SVK = 0) {
  if (t == 1) {
    if (ss == 0) {
      windowopen(
        "/index.cfm?fuseaction=stock.emptypopup_add_hazirlama&SHIP_ID=" +
          shid +
          "&DELIVER_DEPT=" +
          dep +
          "&DELIVER_LOCATION=" +
          loc+"&IS_SVK"+IS_SVK,
        "list"
      );
    }
  }
  if (t == 2) {
    windowopen(
      "/index.cfm?fuseaction=objects.popup_print_files&print_type=32&action_id=" +
        shid +
        "&action_ids=" +
        dep +
        "-" +
        loc +
        "&action=eshipping.list_partner_shipping"
    );
  }
}

</script>