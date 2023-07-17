<cfif isDefined("attributes.is_from_pbs")>
<cfif session.ep.userid eq 1146>
    <cfdump var="#attributes#">
    <cfabort>
</cfif>
<script>
$(document).on('ready',function(){
  <cfoutput>
    <cfloop list="#attributes.ORDER_ROW_ID#" item="it">
        var ix=basket.items.find(p=>P.WRK_ROW_RELATION_ID='#evaluate("attributes.RELATION_ID_#it#")#'
        if(ix !=-1){
            basket.items[ix].AMOUNT=#evaluate("attributes.quantity_#it#")#
        }
    </cfloop>
  </cfoutput>
  
    /*<!---- var quantity_list="<cfoutput>#attributes.quantity#</cfoutput>"
     
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
document.getElementsByName("price_other")[0].click()----->*/
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