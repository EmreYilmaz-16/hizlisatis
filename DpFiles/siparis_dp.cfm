<cfquery name="GETEMPPO" datasource="#DSN#">
    SELECT D.BRANCH_ID,EMPLOYEE_ID FROM workcube_metosan.EMPLOYEE_POSITIONS AS EP 
INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=EP.DEPARTMENT_ID
WHERE D.BRANCH_ID=4 AND EMPLOYEE_ID=#session.EP.USERID#
</cfquery>

<script>
$(document).on('ready',function(){
var fatid=getParameterByName('order_id');
var elem=document.getElementsByClassName("detailHeadButton")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#e303fc' title='Takip'onclick='pencereac(4,"+fatid+")'><i class='icon-bell'></i></a></li>")
$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#0489c7' title='Sevkiyat Talebi Oluştur' onclick='pencereac(1,"+fatid+")'><i class='icon-exchange'></i></a></li>")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#04c76c' title='Şube Sevkiyat Talebi Oluştur'onclick='pencereac(2,"+fatid+")'><i class='icon-industry'></i></a></li>")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#fcba03' title='Yazdır'onclick='pencereac(3,"+fatid+")'><i class='icon-print'></i></a></li>")
// var q="SELECT DISTINCT ORDER_ID FROM PRTOTM_SHIP_RESULT_ROW WHERE ORDER_ID="+fatid
// var res=wrk_query(q,"dsn3")
// console.log(res)
// if(res.recordcount >0){
//     $("#workcube_button").remove()
//     $(".detailHeadButton").remove()
//     var drs=$(".detailHeadButton .dropdown a")
//     drs.each(function(i,e){
//         var att=$(e).attr("Title")
//         if(att=="Kaydet"){
//             $(e).remove()
//         }
//     })
// }
<CFIF 1=1>
    var btn=document.createElement("button")
    btn.innerText="Rafları Yaz & Güncelle";
    btn.setAttribute("type","button")
    btn.setAttribute("onclick","RaflariYaz()")
    btn.setAttribute("class","ui-wrk-btn ui-wrk-btn-warning")
    document.getElementById("workcube_button").appendChild(btn)
</CFIF>

})
function getSaleEmp(){
    var elements=$("#tblBasket").find("tr[basketitem]")
for(let i=0;i<elements.length;i++){   
    var detail_info_extra=$(elements[i]).find("#detail_info_extra")
    var relationId=$(elements[i]).find("#wrk_row_relation_id").val()
    var s="SELECT workcube_metosan.getEmployeeWithId(SALES_EMP_ID) as SATIS_CALISAN FROM PBS_OFFER WHERE OFFER_ID=(SELECT OFFER_ID FROM PBS_OFFER_ROW WHERE UNIQUE_RELATION_ID='"+relationId+"')"
    var res=wrk_query(s,"dsn3")
    var satis_calisani=res.SATIS_CALISAN[0]        
    detail_info_extra.val(satis_calisani)
    detail_info_extra.attr("style","color:red !important")
}
}
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}
function pencereac(tip,idd){
    if(tip==1){
    windowopen('index.cfm?fuseaction=eshipping.emptypopup_add_prtotm_shipping&order_id='+idd,'wide');}else if(tip==2){
        windowopen('index.cfm?fuseaction=sales.popup_list_order_internal_rate&order_id='+idd,'wide');
    }else if(tip==3){
         windowopen('index.cfm?fuseaction=objects.popup_print_files_old&action=sales.list_order&action_id='+idd+'&print_type=73','wide');
    }else if(tip==4){
        windowopen('index.cfm?fuseaction=objects.popup_rekactions_prt&action=ORDER&action_id='+idd,'wide');
    }
}
function RaflariYaz(){
console.log(window.basket)
var Department=document.getElementById("department_id").value;
var Location=document.getElementById("location_id").value;
for(let i=0;i<window.basket.items.length;i++){
    var Item=window.basket.items[i];
    var STOCK_ID=Item.STOCK_ID
    console.log(STOCK_ID)
    var str="SELECT TOP 50 S.PRODUCT_NAME,S.PRODUCT_CODE,PP.PRODUCT_PLACE_ID,PP.SHELF_CODE,SL.COMMENT FROM PRODUCT_PLACE_ROWS AS PPR"
    str+=" INNER JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID INNER JOIN STOCKS AS S ON S.STOCK_ID = PPR.STOCK_ID"
    str+=" INNER JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID = PP.STORE_ID	AND SL.LOCATION_ID = PP.LOCATION_ID WHERE 1=1 AND PPR.STOCK_ID="+STOCK_ID+" AND SL.DEPARTMENT_ID = "+Department+" AND SL.LOCATION_ID = "+Location;
    var queryResult=wrk_query(str,"dsn3")
    console.log(queryResult)
    if(queryResult.recordcount>0){
        window.basket.items[i].SHELF_NUMBER_TXT=queryResult.SHELF_CODE[0];
        window.basket.items[i].SHELF_NUMBER=queryResult.PRODUCT_PLACE_ID[0];
        var clk=document.getElementsByName("detail_info_extra");
        for (let index = 0; index < clk.length; index++) {
            clk[i].click()
        }
    }
}
sessionControl() && validateControl() && kontrol() 

}
///objects.popup_rekactions_prt
</script>


