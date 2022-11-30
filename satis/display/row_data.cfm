<cfquery name="getMoney" datasource="#dsn#">
    SELECT MONEY,RATE1, EFFECTIVE_SALE AS RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
</cfquery>

<cf_box title="#attributes.p_name#" scroll="1" collapsable="1" resize="1" popup_box="1">
   <cfoutput>
    <cfform id="rowExra_#attributes.rowid#">
        <div class="form-group" >
            <label>Döviz Fiyatı</label>
            <input type="text" name="row_extra_price_other" id="row_extra_price_other" value="#attributes.price_other#">
           
        </div>
        <div class="form-group" >
            <label>Döviz</label>
            <select name="row_extra_other_money" id="row_extra_other_money">
                <cfloop query="getMoney">
                    <option <cfif attributes.other_money eq MONEY>selected</cfif> value="#MONEY#">#MONEY#</option>
                </cfloop>
            </select>
        </div>
    <div class="form-group" style="display:none">
        <label>Vergi</label>
        <input type="text" name="row_extra_tax" id="row_extra_tax_tax" value="#attributes.tax#">
       
    </div>
    <div class="form-group">
        <label>İndirim</label>
        <input type="text" name="row_extra_disc" id="row_extra_disc" value="#attributes.disc#">
       
    </div>
</cfform>

    <button class="btn btn-success" type="button" onclick="saveRowExtra(#attributes.rowid#,'#attributes.modal_id#')">Kaydet</button>    
    <button class="btn btn-danger" type="button" onclick="closeBoxDraggable(#attributes.modal_id#)">Kapat</button>    
</cfoutput>
</cf_box>

