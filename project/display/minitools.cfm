<cfif attributes.tool_type eq "alternativeQuestion">
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
<cfelseif attributes.tool_type eq 'showMessage'>
    <cfparam name="attributes.AlertType" default="primary">
    <cfparam name="attributes.Message" default="Kayıt Ediliyor ...">
    <span style="border-radius: 10px;background-color:white;padding: 5px 10px 15px 10px;" id="scrollList">
        <div class="alert alert-<cfoutput>#attributes.AlertType#</cfoutput>">
            <cfoutput>#attributes.Message#</cfoutput>
        </div>
    </span>
<cfelseif attributes.tool_type eq 'ListVP'>
    
    <cfquery name="getVP" datasource="#dsn3#">
        SELECT 
VP.PRODUCT_NAME,VP.VIRTUAL_PRODUCT_ID,PP.PROJECT_HEAD,PP.PROJECT_NUMBER,SMC.MAIN_PROCESS_CAT,ISNULL(PTR.STAGE,'Aşamasız') as STAGE,C.NICKNAME,
SMC.MAIN_PROCESS_CAT_ID
FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP
INNER JOIN workcube_metosan.PRO_PROJECTS AS PP ON PP.PROJECT_ID=VP.PROJECT_ID
INNER JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID =PP.COMPANY_ID
WHERE 1=1 <CFIF LEN(attributes.KeyWord_1)>
    AND PRODUCT_NAME LIKE '%#attributes.KeyWord_1#%'
</CFIF>
<CFIF LEN(attributes.KeyWord_2)>
    AND ( PROJECT_NUMBER LIKE '%#attributes.KeyWord_2#%' OR PROJECT_HEAD LIKE '%#attributes.KeyWord_2#%')
</CFIF>
<CFIF LEN(attributes.projectCatId)>
    AND  SMC.MAIN_PROCESS_CAT_ID=#attributes.projectCatId# 
</CFIF>
    </cfquery>
<cfoutput>
    <table class="table table-sm table-stripped">
        <tbody>
            <cfloop query="getVP">                
                <tr>
                    <td><a href="##" onclick='ngetTree(#VIRTUAL_PRODUCT_ID#,1,"#dsn3#","",#attributes.type#,"","","#attributes.idb#")'>#PRODUCT_NAME#</a></td>
                    <td>#PROJECT_HEAD#</td>
                    <td>#STAGE#</td>
                </tr>                
            </cfloop>
        </tbody>
    </table>
</cfoutput>
<cfelse> 
    Sistem Yönetici
</cfif>