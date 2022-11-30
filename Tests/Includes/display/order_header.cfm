<div class="form-group">    
    <label>Müşteri</label> 
    <input type="text" onkeyup="getCustomer(event,this)" name="company_name" id="company_name" autocomplete="off">
<input type="hidden" name="company_id" id="company_id">
</div>
<div style="display:flex">
    <div class="form-group">    
        <label>Risk</label> 
        <input type="text"  name="RISK" id="RISK">
    </div>
    <div class="form-group">    
        <label>Bakiye</label> 
        <input type="text"  name="BAKIYE" id="BAKIYE">
    </div>

</div>
<div class="form-group">    
    <label>Ödeme Yöntemi</label> 
    <input type="text"  name="PAYMETHOD" id="PAYMETHOD">
    <input type="hidden" name="PAYMETHOD_ID" id="PAYMETHOD_ID">
    <input type="hidden" name="VADE" id="VADE">
</div>
<div class="form-group">    
    <label>Fiyat Listesi</label> 
    <input type="text"  name="PRICE_CAT" id="PRICE_CAT">
    <input type="hidden"  name="PRICE_CATID" id="PRICE_CATID">
</div>
<div style="scroll-y:scroll;width:100%;display:none;overflow-y: scroll;height: 30vh;" id="cmpDiv">
        
</div>