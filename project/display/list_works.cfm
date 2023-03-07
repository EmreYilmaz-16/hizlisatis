<cfquery name="getWorks" datasource="#dsn#">
SELECT WORK_ID
	,WORK_STATUS
	,RELATED_WORK_ID
	,WORK_HEAD
	,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
	,TARGET_START
	,TARGET_FINISH
	,TERMINATE_DATE
	,workcube_metosan.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
    ,PTR.STAGE
FROM workcube_metosan.PRO_WORKS as PWH
LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
WHERE PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>
<cfquery name="getProject" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
</cfquery>
<cf_box title="İşler">
    <cf_grid_list>
        <thead>
            <tr>
                <th>
                    # 
                </th>
                <th>
                    Görev
                </th>
                <th>
                    Görevli
                </th>
                <th>
                    Süreç
                </th>
                <th>
                    Termin Tarihi
                </th>
                <th>
                    Hedef Başlangıç
                </th>
                <th>
                    Hedef Bitiş
                </th>
                <th>Atayan</th>
                <th>
                  <cfoutput>  <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=project.works&event=add&id=#attributes.project_id#&work_fuse=project.emptypopup_ajax_project_works')" title="Ekle "><i class="fa fa-plus"></i></a></cfoutput>
                </th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="getWorks">
                <tr>
                    <td>#WORK_ID#</td>
                    <td>#WORK_HEAD#</td>
                    <td>#PROJECT_EMP#</td>
                    <td>#STAGE#</td>
                    <td>#dateFormat(TERMINATE_DATE,"dd/mm/yyyy")#</td>
                    <td>#dateFormat(TARGET_START,"dd/mm/yyyy")#</td>
                    <td>#dateFormat(TARGET_FINISH,"dd/mm/yyyy")#</td>
                    <td>#RECORD_AUTHOR#</td>
                    <td><span onclick="openBoxDraggable('#request.self#?fuseaction=project.emptypopup_work_detail_pbs&work_id=#WORK_ID#')" class="icn-md icon-search"></span></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>
<div id="leftMenuPss" style="width:10%;height:90vh;position: absolute;right: 0;top: 0;display:none">
    <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
        <div style="height:90vh">
    <cf_grid_list>
        <tr>
            <td>
                <cfif len(getProject.RELATED_PROJECT_ID)>
                <a class="list-group-item" onclick="<cfoutput>window.location.href='#request.self#?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=#getProject.PROJECT_ID#'</cfoutput>">
                       Proje Detay 
                </a>        
            <cfelse>
                <a class="list-group-item" onclick="<cfoutput>window.location.href='#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#getProject.PROJECT_ID#'</cfoutput>">
                    Proje Detay 
             </a>
            </cfif>
            </td>
        </tr>
        <tr>
        <td>
            <a class="list-group-item" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_welcome</cfoutput>'">
            Proje Ana Sayfa
        </a>
    </td>
    </tr>
    
    </cf_grid_list>
</div>
</cf_box>
</div>


<script>

    $(document).on("mousemove",function(ev){

if(ev.clientX >=window.innerWidth-20){
$(leftMenuPss).show(500);
}else if(ev.clientX <=window.innerWidth-300){
$(leftMenuPss).hide(500);
}
})

</script>