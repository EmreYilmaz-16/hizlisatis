<cfif isDefined("attributes.is_from_pbs")>
<script>
$(document).on('ready',function(){
    var quantity_list=getParameterByName('quantity');
    
var strArr=quantity_list.split(",")
var rows=$("#tblBasket").find("input[name='Amount']")
var rowas=$("#tblBasket").find("input[name='price_other']") 
for(let i=0;i<rows.length;i++){
   // console.log(rows[i].value=commaSplit(strArr[i]))
    basket.items[i].AMOUNT=strArr[i]
    //rowas[i].click()
    console.log(basket.items[i].AMOUNT)
    hesapla("AMOUNT",i)
}
document.getElementsByName("price_other")[0].click()
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
</script>
    
</cfif>