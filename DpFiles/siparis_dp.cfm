<script>
$(document).on('ready',function(){
var fatid=getParameterByName('order_id');
var elem=document.getElementsByClassName("detailHeadButton")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#e303fc' title='Takip'onclick='pencereac(4,"+fatid+")'><i class='icon-bell'></i></a></li>")
$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#0489c7' title='Sevkiyat Talebi Oluştur' onclick='pencereac(1,"+fatid+")'><i class='icon-exchange'></i></a></li>")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#04c76c' title='Şube Sevkiyat Talebi Oluştur'onclick='pencereac(2,"+fatid+")'><i class='icon-industry'></i></a></li>")
//$(elem[0].children).append("<li class='dropdown' id='transformation'><a style='color:#fcba03' title='Yazdır'onclick='pencereac(3,"+fatid+")'><i class='icon-print'></i></a></li>")
})

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


