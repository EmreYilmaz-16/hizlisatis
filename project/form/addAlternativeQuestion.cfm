<cf_box title="Alternatif Sorusu Ekle">
    <input type="text" name="questionName" id="questionName">
    <button type="button" onclick="saveAlternative(<cfoutput>'#dsn3#','#attributes.modal_id#'</cfoutput>)" class="btn btn-sm btn-success">Kaydet</button>
    <button type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-sm btn-danger">Kapat</button>
</cf_box>

