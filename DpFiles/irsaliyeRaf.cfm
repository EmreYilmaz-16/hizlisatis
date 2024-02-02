<cfquery name="GETEMPPO" datasource="#DSN#">
    SELECT TOP 1 D.BRANCH_ID,EMPLOYEE_ID FROM workcube_metosan.EMPLOYEE_POSITIONS AS EP 
INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=EP.DEPARTMENT_ID
WHERE 1=1 AND EMPLOYEE_ID=#session.EP.USERID#
</cfquery>
<script>

$(document).ready(function(){
    <CFIF GETEMPPO.recordCount>
    var btn=document.createElement("button")
    btn.innerText="Rafları Yaz & Güncelle";
    btn.setAttribute("type","button")
    btn.setAttribute("onclick","RaflariYaz()")
    btn.setAttribute("class","ui-wrk-btn ui-wrk-btn-warning")
    document.getElementById("workcube_button").appendChild(btn)
</CFIF>
})

function RaflariYaz(){
console.log(window.basket)
var Department=document.getElementById("department_id").value;
var Location=document.getElementById("location_id").value;
var dps=document.getElementById("old_process_type");
for(let i=0;i<window.basket.items.length;i++){
    var Item=window.basket.items[i];
    var STOCK_ID=Item.STOCK_ID
    console.log(STOCK_ID)
    var str="SELECT TOP 50 S.PRODUCT_NAME,S.PRODUCT_CODE,PP.PRODUCT_PLACE_ID,PP.SHELF_CODE,SL.COMMENT FROM PRODUCT_PLACE_ROWS AS PPR"
    str+=" INNER JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID INNER JOIN STOCKS AS S ON S.STOCK_ID = PPR.STOCK_ID"
    str+=" INNER JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID = PP.STORE_ID	AND SL.LOCATION_ID = PP.LOCATION_ID INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND D.BRANCH_ID=<CFOUTPUT>#GETEMPPO.BRANCH_ID#</CFOUTPUT> WHERE 1=1 AND PPR.STOCK_ID="+STOCK_ID;
    var queryResult=wrk_query(str,"dsn3")
    console.log(queryResult)
    if(queryResult.recordcount>0){
     if(dps=="76"){
        window.basket.items[i].SHELF_NUMBER_TXT=queryResult.SHELF_CODE[0];
        window.basket.items[i].SHELF_NUMBER=queryResult.PRODUCT_PLACE_ID[0];
     }else{
        window.basket.items[i].TO_SHELF_NUMBER_TXT=queryResult.SHELF_CODE[0];
        window.basket.items[i].TO_SHELF_NUMBER=queryResult.PRODUCT_PLACE_ID[0];
    }
        var clk=document.getElementsByName("detail_info_extra");
        for (let index = 0; index < clk.length; index++) {
            clk[index].click()
        }
    }
}
try {
    sessionControl() && validateControl() && kontrol_firma()
} catch (error) {
    try {
        sessionControl() && validateControl() && kontrol()     
    } catch (error) {
        sessionControl() && validateControl() && upd_form_function()
    }
    
}

}

</script>

