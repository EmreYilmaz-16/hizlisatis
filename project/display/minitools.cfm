<cfif attributes.tool_type eq "alternativeQuestion">
   <cf_box title="Alternatif Sorusu">
   <cfquery name="getAlternativeQuestions" datasource="#dsn#">
        SELECT QUESTION_NAME,QUESTION_ID FROM SETUP_ALTERNATIVE_QUESTIONS
    </cfquery>
    <select class="form-control" name="aquestion" id="aquestion" onchange="setAQuestions(<cfoutput>#attributes.idb#</cfoutput>,this.value,'<cfoutput>#attributes.modal_id#</cfoutput>',this.options[this.selectedIndex].text)">
        <option value="">Alternatif Sorusu</option>
        <cfoutput query="getAlternativeQuestions">
            <option value="#QUESTION_ID#">#QUESTION_NAME#</option>
        </cfoutput>
    </select>
<button type="button" style="float:right;margin-top:5px" class="btn btn-danger" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')">İptal</button>
</cf_box>
<cfelseif attributes.tool_type eq 'showMessage'>
    <cfparam name="attributes.AlertType" default="primary">
    <cfparam name="attributes.Message" default="Kayıt Ediliyor ...">
    <span style="border-radius: 10px;background-color:white;padding: 5px 10px 15px 10px;" id="scrollList">
        <div class="alert alert-<cfoutput>#attributes.AlertType#</cfoutput>">
            <cfoutput>#attributes.Message#</cfoutput>
        </div>
    </span>
<cfelseif attributes.tool_type eq ''>
<cfelse> 
    Sistem Yönetici
</cfif>