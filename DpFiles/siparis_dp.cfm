<cfquery name="GETEMPPO" datasource="#DSN#">
    SELECT D.BRANCH_ID,EMPLOYEE_ID FROM workcube_metosan.EMPLOYEE_POSITIONS AS EP 
INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=EP.DEPARTMENT_ID
WHERE D.BRANCH_ID=4 AND EMPLOYEE_ID=#session.EP.USERID#
</cfquery>
<cfquery name="mc" datasource="#dsn3#">
    select sum(MONEY_CREDIT) MONEY_CREDIT,sum(USE_CREDIT) USE_CREDIT,
    (SELECT SUM(MONEY_CREDIT-USE_CREDIT) FROM workcube_metosan_1.ORDER_MONEY_CREDITS where COMPANY_ID=(
        SELECT COMPANY_ID FROM workcube_metosan_1.ORDERS WHERE ORDER_ID=#attributes.ORDER_ID#
    )) CREADIT
    
     from workcube_metosan_1.ORDER_MONEY_CREDITS where ORDER_ID=#attributes.ORDER_ID#
    </cfquery>
    <div class="row">
    <div class="col col-3 col-sm-12 col-lg-1">
        
        <table border="1" cellspacing="0" style="background: #2ab4c040">
            <thead>
                <tr>
                    <th onclick="$('.tbd').toggle()" style="background: #2ab4c0;text-decoration: underline;color: white;cursor: pointer;padding:5px;border:none" colspan="3">
                        Puan
                    </th>
                </tr>
            <tr style="display:none" class="tbd">
                <th>
                    Kazanılan Puan
                </th>
                <th>
                    Kullanıan Puan
                </th>
                <th>
                    Müşteri Puan Bakiyesi
                </th>
              
            </tr>
        </thead>
            <tr style="display:none" class="tbd">
                <cfoutput>
                    <td style="text-align:right">#tlformat(mc.MONEY_CREDIT)#</td>
                    <td style="text-align:right">#tlformat(mc.USE_CREDIT)#</td>
                    <td style="text-align:right">#tlformat(mc.CREADIT)#</td>
                </cfoutput>
            </tr>
        </table>
    
    </div>
    </div>

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
<CFIF GETEMPPO.recordCount>
    var btn=document.createElement("button")
    btn.innerText="Rafları Yaz & Güncelle";
    btn.setAttribute("type","button")
    btn.setAttribute("onclick","RaflariYaz()")
    btn.setAttribute("class","ui-wrk-btn ui-wrk-btn-warning")
    document.getElementById("workcube_button").appendChild(btn)
</CFIF>

var btn=document.createElement("button")
    btn.setAttribute("type","button")
    btn.innerText="Güncellemeye İzin Ver"
    btn.setAttribute("onclick","readonlyyy()")
    btn.setAttribute("class","ui-wrk-btn ui-wrk-btn-extra")
    document.getElementById("workcube_button").appendChild(btn)


})

function readonlyyy(){
    var PriceElems=document.getElementsByName("Price")
var AmountElems=document.getElementsByName("Amount")
for(let i=0;i<PriceElems.length;i++){
    PriceElems[i].removeAttribute("readonly")
    AmountElems[i].removeAttribute("readonly")
}
}

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

for(let i=0;i<window.basket.items.length;i++){
    var Item=window.basket.items[i];
    var STOCK_ID=Item.STOCK_ID
    console.log(STOCK_ID)
    var str="SELECT TOP 50 S.PRODUCT_NAME,S.PRODUCT_CODE,PP.PRODUCT_PLACE_ID,PP.SHELF_CODE,SL.COMMENT FROM PRODUCT_PLACE_ROWS AS PPR"
    str+=" INNER JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID INNER JOIN STOCKS AS S ON S.STOCK_ID = PPR.STOCK_ID"
    str+=" INNER JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID = PP.STORE_ID	AND SL.LOCATION_ID = PP.LOCATION_ID INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND D.BRANCH_ID=4 WHERE 1=1 AND PPR.STOCK_ID="+STOCK_ID;
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


