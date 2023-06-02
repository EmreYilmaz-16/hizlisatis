<cfif attributes.tool_type eq "alternativeQuestion">
    <cfquery name="getAlternativeQuestions" datasource="#dsn#">
        SELECT QUESTION_NAME,QUESTION_ID FROM SETUP_ALTERNATIVE_QUESTIONS
    </cfquery>
    <select name="aquestion" id="aquestion">
        <option value="">Alternatif Sorusu</option>
        <cfoutput query="getAlternativeQuestions">
            <option value="#QUESTION_ID#">#QUESTION_NAME#</option>
        </cfoutput>
    </select>
<cfelseif attributes.tool_type eq ''>
<cfelse>
    Sistem Yönetici
</cfif>