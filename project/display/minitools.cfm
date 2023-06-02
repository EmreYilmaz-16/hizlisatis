<cfif attributes.tool_type eq "alternativeQuestion">
   <cf_box title="Alternatif Sorusu">
   <cfquery name="getAlternativeQuestions" datasource="#dsn#">
        SELECT QUESTION_NAME,QUESTION_ID FROM SETUP_ALTERNATIVE_QUESTIONS
    </cfquery>
    <select name="aquestion" id="aquestion" onchange="setAQuestions(<cfoutput>#attributes.idb#</cfoutput>,this.value,'<cfoutput>#attributes.modal_id#</cfoutput>')">
        <option value="">Alternatif Sorusu</option>
        <cfoutput query="getAlternativeQuestions">
            <option value="#QUESTION_ID#">#QUESTION_NAME#</option>
        </cfoutput>
    </select>
<button type="button" class="btn btn-danger" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')">İptal</button>
</cf_box>
<cfelseif attributes.tool_type eq ''>
<cfelse>
    Sistem Yönetici
</cfif>