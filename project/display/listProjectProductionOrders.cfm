<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">
<cfquery name="getP_Orders" datasource="#dsn3#">
    SELECT PO.P_ORDER_ID,PO.P_ORDER_NO,PO.QUANTITY,WS.STATION_NAME,PO.SPECT_VAR_NAME,PO.START_DATE,PO.FINISH_DATE,PO.PROD_ORDER_STAGE,PO.LOT_NO,IS_STAGE,POR.ORDER_ROW_ID,ORR.DELIVER_DATE,O.ORDER_NUMBER,S.PRODUCT_CODE,S.PRODUCT_NAME,ISNULL(TKSS.AMOUNT,0) as AMOUNT_P,PO.QUANTITY AS AMOUNT_PQ FROM #DSN3#.PRODUCTION_ORDERS  AS PO
LEFT JOIN #DSN3#.WORKSTATIONS AS WS ON WS.STATION_ID=PO.STATION_ID
LEFT JOIN #DSN3#.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID=PO.P_ORDER_ID
LEFT JOIN #DSN3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=POR.ORDER_ROW_ID
LEFT JOIN #DSN3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID=PO.STOCK_ID
LEFT JOIN ( SELECT PORS.P_ORDER_ID,SUM(PORRA.AMOUNT) AS AMOUNT FROM #dsn3#.PRODUCTION_ORDER_RESULTS AS PORS 
 LEFT JOIN #dsn3#.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID=PORS.PR_ORDER_ID
 WHERE 1=1 AND PORRA.TYPE=1 GROUP BY PORS.P_ORDER_ID) AS TKSS ON TKSS.P_ORDER_ID=PO.P_ORDER_ID

WHERE PO.PROJECT_ID =#attributes.PROJECT_ID#
</cfquery>
<cf_box title="Üretim Emirleri">
    <cf_grid_list>
        <thead>
            <tr>
                <th>
                    Emir No
                </th>
                <th>
                    Sipraiş No
                </th>
                <th>
                    Lot no
                </th>
                
               
                <th>
                    Teslim Tarihi           
                </th>
                <th>
                    İstasyon
                </th>
                <th>
                    Stok Kodu
                </th>
                <th>Ürün</th>
                <th>Miktar</th>
                <th>Kalan Miktar</th>
                <th>Başlangıç Tarihi</th>
                <th>Bitiş Tarihi</th>
                <th>Durum</th>
                <th><a onclick="windowopen('/index.cfm?fuseaction=prod.tracking&project_id=<cfoutput>#attributes.project_id#</cfoutput>&project_head=proje&is_submitted=1','page')"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="getP_Orders">
                <tr>
                    <td><a href="##" onclick="windowopen('/index.cfm?fuseaction=project.emptypopup_mini_tools&autoComplete=1&tool_type=showSarf&p_order_id=#P_ORDER_ID#')">#P_ORDER_NO#</a></td>
                    <td>#ORDER_NUMBER#</td>
                    <td>#LOT_NO#</td>
                    
                    
                    <td>#dateformat(DELIVER_DATE,"dd/mm/yyyy")#</td>
                    <td>#STATION_NAME#</td>
                    <td>#PRODUCT_CODE#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#QUANTITY#</td>
                    <td>#AMOUNT_PQ-AMOUNT_P#</td>
                    <td>#dateFormat(START_DATE,"dd/mm/yyyy")#</td>
                    <td>#dateFormat(FINISH_DATE,"dd/mm/yyyy")#</td>                   
                    <td colspan="2" style="text-align:center">
                        <cfif IS_STAGE eq 4>
                            
                                <i class="fa fa-circle" style="color:##0DD8FC;font-size:13px" title="<cf_get_lang dictionary_id ='36583.Başlamadı'>"></i>
                            
                        <cfelseif IS_STAGE eq 0>
                            <i class="fa fa-circle" style="color:##FAAB38;font-size:13px" title="<cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'>"></i>
                        <cfelseif IS_STAGE eq 1>
                            <i class="fa fa-circle" style="color:##A2FA38;font-size:13px"  title="<cf_get_lang dictionary_id ='36890.Başladı'>"></i>
                        <cfelseif IS_STAGE eq 2>
                            <i class="fa fa-circle" style="color:red;font-size:13px" title="<cf_get_lang dictionary_id ='36584.Bitti'>">
                        <cfelseif IS_STAGE eq 3>
                            <i class="fa fa-circle"  style="color:##858484;font-size:13px" title="<cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'>"></i>
                    </cfif>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>

</cf_box>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>