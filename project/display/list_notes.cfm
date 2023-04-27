<cf_box title="Notlar">
    <button class="btn btn-success" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_form_add_note&action=PROJECT_ID&action_id=<cfoutput>##attributes.action_id#</cfoutput>&is_special=0&action_type=0&action_id_2=&period_id=&is_open_det=1&is_delete=1')" type="button">Yeni Not Ekle</button>
<cfquery name="getNotes" datasource="#dsn#">
    select NOTE_HEAD,NOTE_BODY,IS_WARNING,workcube_metosan.getEmployeeWithId(RECORD_EMP) RECORD_EMP,RECORD_DATE from workcube_metosan.NOTES WHERE ACTION_SECTION='PROJECT_ID' AND ACTION_ID=#attributes.action_id#
</cfquery>

<div class="row">
    <cfoutput query="getNotes">
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="ui-cards">            
            <div class="ui-cards-text">
                <h1>#NOTE_HEAD#</h1>
                <p style="text-align:justify">#NOTE_BODY#</p>
                <code><span class="icn-md icon-save"></span> #dateFormat(RECORD_DATE,'dd/mm/yyyy')# - #RECORD_EMP#</code>
            </div>
        </div>
    </div>
</cfoutput>
</div>
</cf_box>