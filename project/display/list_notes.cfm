﻿<cfparam name="attributes.act" default="list_p">
<cfif attributes.act eq "list_p" >
<cf_box title="Notlar">
    <button style="float:right" class="btn btn-success" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_form_add_note&action=PROJECT_ID&action_id=<cfoutput>#attributes.action_id#</cfoutput>&is_special=0&action_type=0&action_id_2=&period_id=&is_open_det=1&is_delete=1')" type="button">Yeni Not Ekle</button>
<cfquery name="getNotes" datasource="#dsn#">
    select NOTE_HEAD,NOTE_ID,NOTE_BODY,IS_WARNING,workcube_metosan.getEmployeeWithId(RECORD_EMP) RECORD_EMP,RECORD_DATE from workcube_metosan.NOTES WHERE ACTION_SECTION='PROJECT_ID' AND ACTION_ID=#attributes.action_id#
</cfquery>
<div style="clear:both"></div>
<div class="row">
    <cfoutput query="getNotes">
    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
        <div class="ui-cards">            
            <div class="ui-cards-text">
                <h1>#NOTE_HEAD# <a href="javascript://" style="float: right;padding: 10px;border-radius: 50%;color: white;background: ##E08283;" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#&is_delete=1&style=1&design_id=1&is_special=0&action_type=0&is_delete=1&action_section=PROJECT_ID&action_id=#attributes.action_id#&is_open_det=1')" class="tableyazi" style="float: right;"><i class="fa fa-pencil" title="Güncelle "></i></a></h1>
                <p style="text-align:justify">#NOTE_BODY#</p>
                <code><span class="icn-md icon-save"></span> #dateFormat(RECORD_DATE,'dd/mm/yyyy')# #timeFormat(RECORD_DATE,"HH:mm")# - #RECORD_EMP#</code>
                
            </div>
        </div>
    </div>
</cfoutput>
</div>
</cf_box>
</cfif>
<cfif attributes.act eq "list_my">
    <cf_box title="Notlar">       
    <cfquery name="getNotes" datasource="#dsn#">
        select NOTE_HEAD,NOTE_ID,NOTE_BODY,IS_WARNING,ACTION_SECTION,ACTION_ID,workcube_metosan.getEmployeeWithId(N.RECORD_EMP) RECORD_EMP,N.RECORD_DATE,PP.PROJECT_HEAD,PP.PROJECT_NUMBER 
        from workcube_metosan.NOTES AS N
        LEFT JOIN workcube_metosan.PRO_PROJECTS AS PP ON PP.PROJECT_ID=N.ACTION_ID
         WHERE ACTION_SECTION='PROJECT_ID' AND N.RECORD_EMP=#session.ep.userid#
    </cfquery>
    <div style="clear:both"></div>
    <div class="row">
        <cfoutput query="getNotes">
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
            <div class="ui-cards">            
                <div class="ui-cards-text">
                    <h1>(#PROJECT_NUMBER#) - #NOTE_HEAD# <a href="javascript://" style="float: right;padding: 10px;border-radius: 50%;color: white;background: ##E08283;" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_form_upd_note&note_id=#NOTE_ID#&is_delete=1&style=1&design_id=1&is_special=0&action_type=0&is_delete=1&action_section=#ACTION_SECTION#&action_id=#ACTION_ID#&is_open_det=1')" class="tableyazi" style="float: right;"><i class="fa fa-pencil" title="Güncelle "></i></a></h1>
                    <p style="text-align:justify">#NOTE_BODY#</p>
                    <code><span class="icn-md icon-save"></span> #dateFormat(RECORD_DATE,'dd/mm/yyyy')# #timeFormat(RECORD_DATE,"HH:mm")# - #RECORD_EMP#</code>
                    
                </div>
            </div>
        </div>
    </cfoutput>
    </div>
    <div id="leftMenuPss" style="width:10%;height:90vh;position: absolute;right: 0;top: 0;display:none">
        <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
        <cf_grid_list>
            <tr>
            <td>
                <a class="list-group-item" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_welcome</cfoutput>'">
                Proje Ana Sayfa
            </a>
        </td>
        </tr>
        </cf_grid_list>
    </cf_box>
    </div>
    </cf_box>
</cfif>
<script>
        
    $(document).on("mousemove",function(ev){

if(ev.clientX >=window.innerWidth-100){
$(leftMenuPss).show(500);
}else if(ev.clientX <=window.innerWidth-300){
$(leftMenuPss).hide(500);
}
})

</script>