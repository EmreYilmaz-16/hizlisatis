<script>
$(document).ready(function(){
    var pid=getParameterByName('pid');
    var btn=document.createElement("button")
    var qq="SELECT ISNULL(IS_DEMONTAGE,0) IS_DEMONTAGE FROM PRODUCT WHERE PRODUCT_ID ="+pid
   var res=wrk_query(qq,"dsn1")
    //console.log(res)
    var i=document.createElement("i")
    i.setAttribute("class","icn-md icon-cogs")
    var ims=0;
    if(res.IS_DEMONTAGE == 1){
        btn.setAttribute("class","btn btn-success col col-8 col-md-8 col-sm-8 col-xs-12")

    }else{
        btn.setAttribute("class","btn btn-danger col col-8 col-md-8 col-sm-8 col-xs-12")
        ims=1
    }
    btn.appendChild(i)
    btn.setAttribute("onclick","pencereac(1,"+pid+","+ims+")")
    var div=document.createElement("div")
    div.setAttribute("class","form-group")
    var lbl=document.createElement("label")
    lbl.innerText="Demonte Edilebilir"
    lbl.setAttribute("class","col col-4 col-md-4 col-sm-4 col-xs-12")
    div.appendChild(lbl)
    div.appendChild(btn)
    var ch_count=$("#unique_sayfa_1").find(".ui-form-list").children().length
    var ls=$("#unique_sayfa_1").find(".ui-form-list").children()[ch_count-1]
    ls.appendChild(div)
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
function pencereac(tip,idd,demo){
   if(tip==1){
     windowopen("/index.cfm?fuseaction=objects.emptypopup_update_product_demontage&product_id="+idd+"&IS_DEMONTAGE="+demo)
   }
}
</script>