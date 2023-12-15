<script>
$(document).ready(function(){
    var btn=document.createElement("button")
    btn.innerText="Rafları Yaz";
    btn.setAttribute("type","button")
    btn.setAttribute("onclick","RaflariYaz()")
    btn.setAttribute("class","ui-wrk-btn ui-wrk-btn-warning")
    document.getElementById("workcube_button").appendChild(btn)
})

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
sessionControl() && validateControl() && kontrol_firma()}
</script>