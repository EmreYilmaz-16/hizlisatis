

<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
<input type="text" name="Barcode" placeholder="Barkod" onkeyup="showQ(this,event)">

<cfelse>
    <cfform>
        <input type="text" name="P_ORDER_NO" placeholder="İş Emri No">
        <input type="hidden" name="is_submit" value="1">
    </cfform>
</cfif>

<script>
    function showQ(el,ev,v=1) {
        if(ev.KetCode==13){
            var Barcode=el.value;
            var ih=wrk_query("SELECT * FROM GET_SIMPLE_STOCK WHERE BARCODE='"+el.value+"'","dsn3");
            console.log(ih);
            if(ih.recordCount >0 ){

                var e=prompt("Miktar",v)
                var QUANTITY=parseFloat(e)
                if(isNaN(QUANTITY) ==true){
                    alert("Miktar Numerik Olmalı");
                    showQ(el,ev,v);
                }else{
                    var O={
                        STOCK_ID:ih.STOCK_ID[0],
                        PRODUCT_ID:ih.PRODUCT_ID[0],
                        QUANTITY:QUANTITY
                    }
                }
                
            }
        }
    }
</script>