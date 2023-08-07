<script>
$(document).on('ready',function(){
var fatid=getParameterByName('order_id');
var elem=document.getElementsByClassName("detailHeadButton")
getSaleEmp();
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#e303fc' title='Takip'onclick='pencereac(4,"+fatid+")'><i class='icon-bell'></i></a></li>")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#0489c7' title='Sevkiyat Talebi Oluştur' onclick='pencereac(1,"+fatid+")'><i class='icon-exchange'></i></a></li>")
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
///objects.popup_rekactions_prt
</script>


