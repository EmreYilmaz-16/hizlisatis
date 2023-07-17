<cfif isDefined("attributes.is_from_pbs")>
<cfif session.ep.userid eq 1146>
    
</cfif>
<script>
$(document).on('ready',function(){
  <cfoutput>
    <cfloop list="#attributes.ORDER_ROW_ID#" item="it">
        var ix=basket.items.find(p=>P.WRK_ROW_RELATION_ID="#evaluate("attributes.RELATION_ID_#it#")#")
        if(ix !=-1){
            basket.items[ix].AMOUNT=#evaluate("attributes.quantity_#it#")#
        }
    </cfloop>
  </cfoutput>
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