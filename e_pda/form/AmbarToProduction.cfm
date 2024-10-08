﻿<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cf_box>
    <div style="height:90vh">
<cfif isDefined("attributes.tip") and attributes.tip eq 1453>
    <cfinclude template="../inc/sarfInc.cfm">
    <cfabort>
</cfif>
<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>

<div class="form-group">
<input style="font-size:24pt !important" type="text" name="Barcode" placeholder="Barkod" onkeyup="showQ(this,event)">
</div>
<cfquery name="isHv" datasource="#dsn3#">
    SELECT * FROM PRODUCTION_ORDERS WHERE P_ORDER_NO='#attributes.P_ORDER_NO#'
</cfquery>
<CFIF isHv.recordCount>
    <input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#isHv.P_ORDER_ID#</cfoutput>">
    <input type="hidden" name="p_order_no" id="p_order_no" value="<cfoutput>#isHv.P_ORDER_NO#</cfoutput>">
    <input type="hidden" name="user_id" id="user_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
    <input type="hidden" name="dsn3" id="dsn3" value="<cfoutput>#dsn3#</cfoutput>">
    <input type="hidden" name="dsn2" id="dsn2" value="<cfoutput>#dsn2#</cfoutput>">
    <div style="display: flex;flex-direction: column;position: absolute;width: 100%;bottom: 0;text-align: center;align-content: center;justify-content: space-evenly;">

    <button class="btn btn-lg btn-outline-success" type="button" onclick="windowopen('/index.cfm?fuseaction=<cfoutput>#attributes.fuseaction#&tip=1453&p_order_no=#isHv.P_ORDER_NO#&p_order_id=#isHv.P_ORDER_ID#</cfoutput>')">Liste</button>
    </div>
<cfelse>
    <script>
        alert("İş Emri Bulunamadı");
        history.back();
    </script>
</CFIF>
<cfelse>
    <cfform>
        <div class="form-group">
        <input style="font-size:24pt !important" type="text" name="P_ORDER_NO" placeholder="İş Emri No">        
        <input type="hidden" name="is_submit" value="1">
    </div>
    </cfform>
</cfif>

<script>
$(document).ready(function(){
    document.getElementById("wrk_main_layout").setAttribute("class","container-fluid");
})
$("#add_production_order").on("submit",function (ev){
    ev.preventDefault()
});
    function showQ(el,ev,v=1) {
        if(ev.keyCode==13){
            var Barcode=el.value;
            var p_order_id=document.getElementById("p_order_id").value;
            var p_order_no=document.getElementById("p_order_no").value;
            var user_id=document.getElementById("user_id").value;
            var dsn3=document.getElementById("dsn3").value;
            var dsn2=document.getElementById("dsn2").value;
            var ih=wrk_query("SELECT * FROM GET_SIMPLE_STOCK WHERE BARCODE='"+el.value+"'","dsn3");
            console.log(ih);
            if(ih.recordcount >0 ){

                var e=prompt("Miktar",v)
                var QUANTITY=parseFloat(e)
                if(isNaN(QUANTITY) ==true){
                    alert("Miktar Numerik Olmalı");
                    showQ(el,ev,v);
                }else{
                    var O={
                        STOCK_ID:ih.STOCK_ID[0],
                        PRODUCT_ID:ih.PRODUCT_ID[0],
                        QUANTITY:QUANTITY,
                        P_ORDER_ID:p_order_id,
                        P_ORDER_NO:p_order_no,
                        STORE_ID:ih.STORE_ID[0],
                        LOCATION_ID:ih.LOCATION_ID[0],
                        SHELF_CODE:ih.SHELF_CODE[0],
                        DSN3:dsn3,
                        DSN2:dsn2,
                        USER_ID:user_id
                    };
                    console.log(O)
                }
                var str=JSON.stringify(O);
               // windowopen("/index.cfm?fuseaction=epda.emptypopup_save_production_orders_sevk&data="+str,"page");
               $.ajax({
                url:"/AddOns/Partner/e_pda/cfc/UretimAmbar.cfc?method=saveBelge",
                data:str,
                success:function(retDat){
                    console.log(retDat);
                    alert("Başarılı")
                    $(document.getElementsByName("Barcode")[0]).val("").focus()
                }
               })
            }
        }
    }
</script>
</div>
</cf_box>