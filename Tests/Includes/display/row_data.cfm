
<cf_box title="#attributes.p_name#" scroll="1" collapsable="1" resize="1" popup_box="1">
   <cfoutput>
    <cfform id="rowExra_#attributes.rowid#">
    <div class="form-group" style="display:none">
        <label>Vergi</label>
        <input type="text" name="row_extra_tax" id="row_extra_tax_tax" value="#attributes.tax#">
       
    </div>
    <div class="form-group">
        <label>İndirim</label>
        <input type="text" name="row_extra_disc" id="row_extra_disc" value="#attributes.disc#">
       
    </div>
</cfform>
    <button class="btn btn-success" type="button" onclick="saveRowExtra(#attributes.rowid#)">Kaydet</button>    
</cfoutput>
</cf_box>

