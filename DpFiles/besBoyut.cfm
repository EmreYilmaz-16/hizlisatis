<script>
<cfoutput>
    var period_id=#session.ep.period_id#
</cfoutput>
$(document).ready(function(){
    var e_date=document.getElementById("expense_date").value
    var yil=list_getat(e_date,3,"/")
    var ay=list_getat(e_date,2,"/")
    var gun=list_getat(e_date,1,"/")
    var sst=yil+"-"+ay+"-"+gun;
    var d=new Date(sst)
    var q="select PERIOD_DATE from workcube_metosan.SETUP_PERIOD WHERE PERIOD_ID="+period_id
    var qr=wrk_query(q,"dsn")
    var d2=new Date(qr.PERIOD_DATE[0]);
    if(d<d2){    
        $("#workcube_button").html("")
        $("#workcube_button").html("<span style='color:red'>Butonlar Gizlenmiştir</span>")
        $("#tabMenu").remove()
        
    }
})
</script>