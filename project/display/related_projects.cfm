<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfquery name="getRelatedProjects" datasource="#dsn#">
    select PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME,PRO_PROJECTS.PRO_CURRENCY_ID from workcube_metosan.PRO_PROJECTS
INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where RELATED_PROJECT_ID=#attributes.project_id#
</cfquery>
<cfquery name="getProject" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
</cfquery>
<cf_box title="Proje Detay">
    <div style="width:50%">
        <table style="width:100%">
            <tr>
                <th colspan="2" style="color:orange;font-size:14pt;text-align:left">
                    Proje : <cfoutput>#getProject.PROJECT_HEAD#</cfoutput>
                </th>
            </tr>
        </table>
    </div>
    <cf_grid_list>
        <thead>
        <tr>
            <th>
                Proje  No
            </th>
            <th>
                Proje
            </th>
            <th>
                Proje Yöneticisi
            </th>
            <th>
                İlişkili Şirket
            </th>
            <th>
                Başlangıç
            </th>
            <th>
                Bitiş
            </th>
            <th>
                Öncelik
            </th>
            <th>
                <a href="javascript:\\" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_add_project_fast&upper_project_id=<cfoutput>#attributes.project_id#</cfoutput>')"><span class="icn-md icon-pluss"></span></a>
            </th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="getRelatedProjects">
            <tr>
                <td>
                    #PROJECT_NUMBER#
                </td>
                <td>#PROJECT_HEAD#</td>
                <td>#YONETICI#</td>
                <td>#NICKNAME#</td>
                <td>#dateFormat(TARGET_START,"dd/mm/yyyy")#</td>
                <td>#dateFormat(TARGET_FINISH,"dd/mm/yyyy")#</td>
                <td>
                    <span style="padding: 5px !important;display: block;border-radius: 4px;" class="color#COLOR#">#PRIORITY#</span>
    
                </td>
                <td><a onclick="window.location.href='#request.self#?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=#PROJECT_ID#'"><span class="icn-md icon-pencil-square-o"></span></a></td>
            </tr>
        </cfoutput>
    </tbody>
    </cf_grid_list>

</cf_box>
<script src="/AddOns/Partner/project/content/project_welcome.js"></script>