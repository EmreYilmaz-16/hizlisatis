﻿<cf_box>

<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
<cfdump var="#attributes#">
<div class="form-group">
<input style="font-size:24pt !important" type="text" name="Barcode" placeholder="Barkod" onkeyup="showQ(this,event)">
</div>
<cfquery name="isHv" datasource="#dsn3#">
    SELECT * FROM PRODUCTION_ORDERS WHERE P_ORDER_NO='#attributes.P_ORDER_NO#'
</cfquery>
<CFIF isHv.recordCount>
    <input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#isHv.P_ORDER_ID#</cfoutput>">
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
    function showQ(el,ev,v=1) {
        if(ev.keyCode==13){
            var Barcode=el.value;
            var p_order_id=document.getElementById("p_order_id").value;
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
                        STORE_ID:ih.STORE_ID[0],
                        LOCATION_ID:ih.LOCATION_ID[0]
                    };
                    console.log(O)
                }
                
            }
        }
    }
</script>
</cf_box>