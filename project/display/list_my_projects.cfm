<cfquery name="getProjects" datasource="#dsn#">
select WEP.ROLE_HEAD,PP.PROJECT_NUMBER,PROJECT_HEAD,PP.PROJECT_ID,PP.MAIN_PROCESS_CAT,PP.TARGET_START,TARGET_FINISH,pp.STAGE,YONETICI,PRIORITY,COLOR,NICKNAME from #dsn#.WORKGROUP_EMP_PAR AS WEP
LEFT JOIN (
SELECT ptp.STAGE,SMP.MAIN_PROCESS_CAT, PROJECT_ID,RELATED_PROJECT_ID, PP.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS AS PP
LEFT JOIN #dsn#.SETUP_MAIN_PROCESS_CAT AS SMP ON SMP.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTP ON PTP.PROCESS_ROW_ID=PP.PRO_CURRENCY_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PP.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PP.COMPANY_ID 
) as PP on PP.PROJECT_ID=WEP.PROJECT_ID
where EMPLOYEE_ID=#session.ep.userid# and WEP.PROJECT_ID is not null
UNION 
SELECT '' AS ROLE_HEAD,PRO_PROJECTS.PROJECT_NUMBER,PRO_PROJECTS.PROJECT_HEAD,
PROJECT_ID,SMP.MAIN_PROCESS_CAT,TARGET_START,TARGET_FINISH,STAGE,
#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS YONETICI,SETUP_PRIORITY.PRIORITY,
SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER JOIN #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
LEFT JOIN #dsn#.SETUP_MAIN_PROCESS_CAT AS SMP ON SMP.MAIN_PROCESS_CAT_ID=PRO_PROJECTS.PROCESS_CAT
LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTP ON PTP.PROCESS_ROW_ID=PRO_PROJECTS.PRO_CURRENCY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_EMP_ID =#session.ep.userid# 
</cfquery>
<cf_box title="Projelerim">
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
        <th>Rolüm</th>
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
            <td>
                #ROLE_HEAD#
            </td>
            <td><a onclick="window.location.href='#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#PROJECT_ID#'"><span class="icn-md icon-pencil-square-o"></span></a></td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>