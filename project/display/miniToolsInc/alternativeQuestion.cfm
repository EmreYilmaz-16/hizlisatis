<cf_box title="Alternatif Sorusu">
    <cfquery name="getAlternativeQuestions" datasource="#dsn#">
         SELECT QUESTION_NAME,QUESTION_ID FROM SETUP_ALTERNATIVE_QUESTIONS
     </cfquery>
     <select class="form-control" name="aquestion" id="aquestion">
         <option value="">Alternatif Sorusu</option>
         <cfoutput query="getAlternativeQuestions">
             <option <cfif isDefined("attributes.question_id") and attributes.question_id eq QUESTION_ID>selected</cfif> value="#QUESTION_ID#">#QUESTION_NAME#</option>
         </cfoutput>
     </select>
     <input type="text" name="displayName" id="displayName" class="form-control form-control" style="margin-top:10px" placeholder="Gözükecek Ad" value="<cfif isdefined('attributes.displayName') and len(attributes.displayName)>
         <cfoutput>#attributes.displayName#</cfoutput>
     </cfif>">
     <button type="button" style="float:right;margin-top:5px" class="btn btn-success" onclick="setAQuestions2(<cfoutput>#attributes.idb#</cfoutput>,'<cfoutput>#attributes.modal_id#</cfoutput>')">Tamam</button>
 <button type="button" style="float:right;margin-top:5px" class="btn btn-danger" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')">İptal</button>
 </cf_box>