<cf_box title="Alternatif Sorusu Ekle">
    <div class="form-group">
        <label>Alternatif Sorusu</label>
    <input type="text" class="form-control form-control-sm" name="questionName" id="questionName">
</div>
    <button type="button" onclick="saveAlternative(<cfoutput>'#dsn3#','#attributes.modal_id#'</cfoutput>)" class="btn btn-sm btn-success">Kaydet</button>
    <button type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-sm btn-danger">Kapat</button>
</cf_box>

