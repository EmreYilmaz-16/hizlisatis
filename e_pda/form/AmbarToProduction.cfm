

<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
<cfdump var="#attributes#">
<input type="text" name="Barcode" placeholder="Barkod" onkeyup="showQ(this,event)">
<cfquery name="isHv" datasource="#dsn3#">
    SELECT * FROM PRODUCTION_ORDERS WHERE P_ORDER_NO='#attributes.P_ORDER_NO#'
</cfquery>
<CFIF isHv.recordCount>
    <input type="hidden" name="p_order_id" value="<cfoutput>#isHv.P_ORDER_ID#</cfoutput>">
<cfelse>
    <script>
        alert("İş Emri Bulunamadı");
        history.back();
    </script>
</CFIF>
<cfelse>
    <cfform>
        <input type="text" name="P_ORDER_NO" placeholder="İş Emri No">
        
        <input type="hidden" name="is_submit" value="1">
    </cfform>
</cfif>

<script>
    function showQ(el,ev,v=1) {
        if(ev.KeyCode==13){
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