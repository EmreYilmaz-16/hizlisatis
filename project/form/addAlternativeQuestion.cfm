<cf_box title="Alternatif Sorusu Ekle">
    <input type="text" name="questionName" id="questionName">
    <button type="button" onclick="addAltrnativeQ(<cfoutput>'#dsn3#','#attributes.modal_id#'</cfoutput>)" class="btn btn-success">Kaydet</button>
    <button type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-success">Kapat</button>
</cf_box>

