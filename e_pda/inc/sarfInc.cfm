<cfquery name="getP" datasource="#dsn3#">
    SELECT *
    FROM (
        SELECT PO.P_ORDER_ID
            ,PO.P_ORDER_NO
            ,WS.STATION_NAME
            ,S.PRODUCT_NAME
            ,S.PRODUCT_CODE
            ,S.STOCK_ID
            ,PO.SPECT_VAR_NAME
            ,PO.START_DATE
            ,PO.FINISH_DATE
            ,PO.PROD_ORDER_STAGE
            ,PO.LOT_NO
            ,IS_STAGE
            ,POR.ORDER_ROW_ID
            ,ORR.DELIVER_DATE
            ,PO.STATION_ID
            ,PP.PROJECT_HEAD
            ,PP.PROJECT_NUMBER
            ,PO.PROJECT_ID
            ,O.ORDER_NUMBER
            ,ISNULL(TKSS.AMOUNT, 0) AMOUNT
            ,PO.QUANTITY
            ,C.NICKNAME
        FROM #DSN3#.PRODUCTION_ORDERS AS PO
        LEFT JOIN #DSN3#.WORKSTATIONS AS WS ON WS.STATION_ID = PO.STATION_ID
        LEFT JOIN #DSN#.PRO_PROJECTS AS PP ON PP.PROJECT_ID=PO.PROJECT_ID
        LEFT JOIN #DSN3#.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
        LEFT JOIN #DSN3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = POR.ORDER_ROW_ID
        LEFT JOIN #DSN3#.ORDERS AS O ON O.ORDER_ID = ORR.ORDER_ID
        LEFT JOIN #DSN#.COMPANY AS C ON C.COMPANY_ID = O.COMPANY_ID
        LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = PO.STOCK_ID
        LEFT JOIN (
            SELECT PORS.P_ORDER_ID
                ,SUM(PORRA.AMOUNT) AS AMOUNT
            FROM #DSN3#.PRODUCTION_ORDER_RESULTS AS PORS
            LEFT JOIN #DSN3#.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID = PORS.PR_ORDER_ID
            WHERE 1 = 1
                AND PORRA.TYPE = 1
            GROUP BY PORS.P_ORDER_ID
            ) AS TKSS ON TKSS.P_ORDER_ID = PO.P_ORDER_ID
        ) AS T
     WHERE P_ORDER_ID=#attributes.P_ORDER_ID#
    </cfquery>
    
    
    
    
    <!--- Üretim emrinde sarf ve fire oluşturma... --->
    
    <cfset attributes.stock_id=getP.STOCK_ID>
    <cf_box title="Üretim Emri - #getP.P_ORDER_NO#">
        <cfoutput>
            <cf_ajax_list>
            <tr>
                <th>Müşteri</th>
                <td>#getP.NICKNAME#</td>
                <th>Sipariş</th>
                <td>#getP.ORDER_NUMBER#</td>       
                <th>Proje</th>
                <td>#getP.PROJECT_NUMBER# - #getP.PROJECT_HEAD#</td>
            </tr>
            <tr>
                <th>Ürün Kodu</th>
                <td>#getP.PRODUCT_CODE#</td>
                <th>Ürün</th>
                <td>#getP.PRODUCT_NAME#</td>
                <th>Üretilen Miktarı</th>
                <td>#getP.AMOUNT#</td>
                <th>Üretilecek Miktar</th>
                <td>#getP.QUANTITY#</td>
            </tr>
        </cf_ajax_list>
        </cfoutput>
        <div class="form-group">
            <input style="font-size:24pt !important" type="text" name="Barcode" placeholder="Barkod" onkeyup="TestQ(this,event)">
        </div>  
    
    <form name="add_production_order" id="add_production_order" action="index.cfm?fuseaction=production.emptypopup_upd_prtotm_real_po" method="post" >
        <input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.P_ORDER_ID#</cfoutput>" >
        <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >                
        <cfinclude template="../../GeneralUsage/Production/SarfBasket.cfm">       
    </form>
    </cf_box>
    <script>
        function UretimTamamla(poid,stationid){
            windowopen("/index.cfm?fuseaction=production.emptypopup_add_prod_order_result&JUSPORESULT=1&p_order_id="+poid+"&pws_id="+stationid)
        }
        document.getElementByBarcode=function (Barcode){
            var arr=document.all
            for(let i=0;i<arr.length;i++){
                var El =arr[i].getAttribute("data-barcode")
                if(El != null){
                    if(El===Barcode){
                        return arr[i]
                    }
                }
            } 
        }
        function TestQ(el,ev,v){
            if(ev.keyCode==13){
                var b=el.value;
                var elem=document.getElementByBarcode(b);
                console.log(elem)
                var rowNum=elem.getAttribute("data-rownum");
                var RemAmount=prompt("Çıkış Miktarı",v);
                var QUANTITY=parseFloat(RemAmount)
                if(isNaN(QUANTITY) ==true){
                    alert("Miktar Numerik Olmalı");
                    TestQ(el,ev,v);
                }else{
                    var AmountExit=$("#amount_exit"+rowNum).val();
                    if(parseFloat(filterNum(AmountExit))==QUANTITY){
                        sil_exit(rowNum);
                        var vv=parseInt($("#record_num_exit").val())
                        $("#record_num_exit").val(vv);
                    }else{
                        var px=parseFloat(filterNum(AmountExit))-QUANTITY
                        $("#amount_exit"+rowNum).val(px);
                    }
                    $("#add_production_order").submit()
                }
            }
        }
    </script>