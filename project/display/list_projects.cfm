<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<cf_box title="Projeler">
<cfquery name="getProjects" datasource="#dsn#">
SELECT PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) AS YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
INNER JOIN workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where RELATED_PROJECT_ID IS NULL
</cfquery>

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
        <th></th>
    </tr>
</thead>
<tbody>
    <cfoutput query="getProjects">
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
                <span style="padding: 1px !important;width: 100%;display: block;border-radius: 4px;" class="color#COLOR#">#PRIORITY#</span>

            </td>
            <td><a onclick="window.location.href='#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#PROJECT_ID#'"></a></td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>