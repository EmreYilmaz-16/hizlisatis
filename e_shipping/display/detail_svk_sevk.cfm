<cfquery name="GetSiparisData" datasource="#dsn3#">
SELECT ORR.QUANTITY
    ,ORR.UNIQUE_RELATION_ID
    ,ORR.ORDER_ROW_ID
    ,ORR.ORDER_ID
	,ISNULL(SR.AMOUNT, 0) AS SHIPPED_QUANTITY
	,ISNULL(SIFR.AMOUNT_H, 0) AS READY_QUANTITY
	,S.PRODUCT_NAME
	,S.PRODUCT_CODE
    ,PSR.COMPANY_ID
    ,PSR.DEPARTMENT_ID
FROM workcube_metosan_1.PRTOTM_SHIP_RESULT AS PSR
LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS PSRR ON PSRR.SHIP_RESULT_ID = PSR.SHIP_RESULT_ID
LEFT JOIN workcube_metosan_1.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = PSRR.ORDER_ROW_ID
LEFT JOIN workcube_metosan_1.ORDERS_SHIP AS OS ON OS.ORDER_ID = ORR.ORDER_ID
LEFT JOIN (
	SELECT SUM(AMOUNT) AS AMOUNT
		,UNIQUE_RELATION_ID
		,SHIP_ID
	FROM workcube_metosan_2023_1.SHIP_ROW
	GROUP BY UNIQUE_RELATION_ID
		,SHIP_ID
	) AS SR ON SR.UNIQUE_RELATION_ID = orr.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID = ORR.STOCK_ID
LEFT JOIN (
	SELECT SUM(AMOUNT) AS AMOUNT_H
		,UNIQUE_RELATION_ID
	FROM workcube_metosan_2023_1.STOCK_FIS_ROW
	GROUP BY UNIQUE_RELATION_ID
	) AS SIFR ON SIFR.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE PSR.SHIP_RESULT_ID = #attributes.iid#

</cfquery>
<cf_box title="Sevk Durumları">
<cfform method="post" id="frm1" action="">
    <cf_grid_list>
    <thead>
        <tr>
            <th></th>
            <th>Ürün Kodu</th>
            <th>Ürün Adı</th>
            <th>Sipariş Miktarı</th>
            <th>Sevk Edilen Miktar</th>
            <th>Hazırlanan Miktar</th>
            <th>Sevk Edilecek Miktar</th>
            <th><input type="checkbox" onclick="checkAll()"></th>
        </tr>
    </thead>
    <tbody>
    <cfoutput>
        <input type="hidden" value="#GetSiparisData.ORDER_ID#" name="order_id" id="row_order_id">
<cfloop query="GetSiparisData">
    <tr class="rows">
        <td>
            #currentrow#
        </td>
        <td>
            #PRODUCT_CODE#
        </td>
        <td>
            #PRODUCT_NAME#
        </td>
        <td class="order_quantity" id="order_quantity_#currentrow#">
            #QUANTITY#
        </td>
        <td class="shipped_quantity" id="shipped_quantity_#currentrow#">
            #SHIPPED_QUANTITY#
        </td>
        <td class="ready_quantity" id="ready_quantity_#currentrow#">#READY_QUANTITY#</td>
        <td>
            <input type="text" readonly id="txt_#currentrow#" name="quantity" disabled value="#READY_QUANTITY-SHIPPED_QUANTITY#">
            <input type="hidden" name="relation_id_#currentrow#" value="#UNIQUE_RELATION_ID#">
        </td>
        <td>            
            <input type="checkbox" class="cssxbx" onclick="checkKontrol(this,#currentrow#)" value="#ORDER_ROW_ID#" name="order_row_id" id="row_order_row_id">            
                        
        </td>
    </tr>
</cfloop>
</cfoutput>
</tbody>
</cf_grid_list>
<button class="btn btn-success" type="button" onclick="sbm(1)">Fatura Kes</button>
<button class="btn btn-warning" type="button" onclick="sbm(2)">İrsaliye Kes</button>
</cfform>
</cf_box>


<script>
    function checkKontrol(el,id){
        if($(el).is(":checked")){
            document.getElementById("txt_"+id).removeAttribute("disabled")
        }else{
            document.getElementById("txt_"+id).setAttribute("disabled","disabled")
        }
    }
    function sbm(tip) {
       var kntRes=parcaliKontrol(<cfoutput>#attributes.iid#</cfoutput>);
       
        var frm=document.getElementById("frm1")
        if(tip==1){
            frm.action="index.cfm?fuseaction=invoice.form_add_bill&is_from_pbs=1"
        }
        else if(tip==2){
            frm.action="index.cfm?fuseaction=stock.form_add_sale&is_from_pbs=1"
        }
        if(kntRes){
        frm.submit();}
    }



    function parcaliKontrol(iid){
        var hata=false;
        var rows=document.getElementsByClassName("rows")
            for(let i=0;i<rows.length;i++){
            var row=rows[i];
            var OrderQuantity=trim($(row).find(".order_quantity").text())   
                OrderQuantity=parseFloat(OrderQuantity)
            var SevkQuantity=$(row).find("input[name='quantity']").val()
                SevkQuantity=parseFloat(SevkQuantity)
            var cbx=$(row).find("input[type='checkbox']").is(":checked")
                console.log(cbx)
        
            if(cbx){
                if(OrderQuantity!=SevkQuantity){
                    hata=true
                }
            }else{
                hata=true
            }
                
        }
        
        var q=wrk_query("SELECT ISNULL(IS_PARCALI,0) as IS_PARCALI  FROM PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID="+iid,"dsn3")
        console.log(q)
        if(parseInt(q.IS_PARCALI[0])==0){
            hata=false
        };
        
        if(hata){
            alert("Ürünlerin Tamamını Sevk Etmediniz")
            return false
        }else{
            return true
        }
    }

    function checkAll(){
        var cbx=$(".cssxbx")
        for(let i=0;i<cbx.length;i++){cbx[i].click()}
    }
</script>