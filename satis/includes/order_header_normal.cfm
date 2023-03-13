
<cfoutput><input type="hidden" name="order_id" id="order_id" value="#attributes.offer_id#"></cfoutput>
<table style="width:100%">
    <tr>
        <td style="width:45%">
<table style="width:100%">
    <tr>
        <td>
            <div class="form-group" id="item-offer_head">
                <label>Başlık </label>            
                    <input name="offer_head" id="offer_head" type="text" value="Teklifimiz" maxlength="200">                
            </div>
        </td>
        <td>
            <div class="form-group" id="item-offer_date">
                <label ><cf_get_lang dictionary_id='46831.Teklif Tarihi'></label>                
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='38656.Teklif Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="offer_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" maxlength="10" onblur="change_money_info('form_basket','offer_date');">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_date" call_function="change_money_info"></span>
                    </div>                
            </div>
    </td>
    </tr>
    <tr>
        <td>
            <div class="form-group">    
                <label>Müşteri</label> 
                <input type="text" onkeyup="getCustomer(event,this)" name="company_name" id="company_name" autocomplete="off" >
                <input type="hidden" name="company_id" id="company_id">
                <button id="btncari" onclick="openCariExtre()" type="button" class="btn btn-primary">Cari Extre</button>
            </div>
        </td>
        <td>
            <div class="form-group">    
                <label>Yetkili</label> 
                <input type="text" name="company_partner_name" id="company_partner_name" autocomplete="off">
                <input type="hidden" name="company_partner_id" id="company_partner_id">
            </div>
        </td>
    </tr>
        <tr>
    
    </tr>
    <tr>
        <td>
            <div class="form-group">    
                <label>Ödeme Yöntemi</label> 
                <input type="text"  name="PAYMETHOD" id="PAYMETHOD" onkeyup="getOdemeYontem(this)">
                <input type="hidden" name="PAYMETHOD_ID" id="PAYMETHOD_ID">
                <input type="hidden" name="VADE" id="VADE">
            </div>
        </td>
        <td>
            <div class="form-group">    
                <label>Fiyat Listesi</label> 
                <input type="text"  name="PRICE_CAT" id="PRICE_CAT">
                <input type="hidden"  name="PRICE_CATID" id="PRICE_CATID">
            </div>
        </td>
    </tr>
    <tr>
        <td>
            <div class="form-group" id="item-process_stage">
                <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                
                    <cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
                
            </div>
        </td>
        <td>
            <div class="form-group">    
                <label>Sevk Yöntemi</label> 
                <input type="text"  name="SHIP_METHOD" id="SHIP_METHOD" onkeyup="getSevkYontem(this)">
                <input type="hidden" name="SHIP_METHOD_ID"  id="SHIP_METHOD_ID">                
            </div>
        </td>
    </tr>
<tr>
    <td >
        <div class="form-group">
            <label>Sevk Adresi</label>
        <div class="input-group">
            <input type="hidden" name="city_id" id="city_id" value="">
            <input type="hidden" name="county_id" id="county_id" value="">
            <input type="hidden" name="ship_address_id" id="ship_address_id" value="">
            <input type="text" name="ship_address" id="ship_address" onChange="kontrol(this,200)">
            <span class="input-group-addon btnPointer icon-ellipsis" onClick="add_adress();"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">    
            <label>Temsilci</label> 
            <input type="text"  name="plasiyer" id="plasiyer">
            <input type="hidden" name="plasiyer_id"  id="plasiyer_id">                
        </div>
    </td>
</tr>
<tr>
    <td>
        <div class="form-group">
            <select name="is_parcali">
                <option value="0">Kısmi Sevk</option>
                <option value="1">Tamamı Sevk</option>
            </select>
        </div>
    </td>
</tr>
<tr>
    <td colspan="2">
        <div class="form-group">    
            <label>Açıklama</label> 
            <textarea name="offer_desc" id="offer_desc"></textarea>              
        </div>
    </td>
</tr>
</table>
</td>
<td style="width:55%">
<div style="scroll-y:scroll;width:100%;display:none;overflow-y: scroll;height: 30vh;" id="cmpDiv">
        
</div>
</td>
</tr>
</table>

