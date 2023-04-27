<cfquery name="getNotes" datasource="#dsn#">
    select NOTE_HEAD,NOTE_BODY,IS_WARNING,workcube_metosan.getEmployeeWithId(RECORD_EMP) RECORD_EMP,RECORD_DATE from workcube_metosan.NOTES WHERE ACTION_SECTION='PROJECT_ID' AND ACTION_ID=2558
</cfquery>

<div class="row">
    <cfoutput query="getNotes">
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="ui-cards">            
            <div class="ui-cards-text">
                <h1>#NOTE_HEAD#</h1>
                <p>#NOTE_BODY#</p>
                <code>#dateFormat(RECORD_DATE,'dd/mm/yyyy')# - #RECORD_EMP#</code>
            </div>
        </div>
    </div>
</cfoutput>
</div>