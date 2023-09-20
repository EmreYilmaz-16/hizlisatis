<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<cfinclude template="../includes/upperMenu.cfm">

<cfif isDefined("attributes.list_my_projects")>
    <cfinclude template="list_my_projects.cfm">
    <cfabort>
</cfif>

<cf_box title="Projeler">
<cfquery name="getProjects" datasource="#dsn#">
SELECT PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER JOIN #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where RELATED_PROJECT_ID IS NULL
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
                <span style="padding: 5px !important;display: block;border-radius: 4px;" class="color#COLOR#">#PRIORITY#</span>

            </td>
            <td><a onclick="window.location.href='#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#PROJECT_ID#'"><span class="icn-md icon-pencil-square-o"></span></a></td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>