<cfquery name="getProjects" datasource="#dsn#">
select WEP.ROLE_HEAD,PP.PROJECT_NUMBER,PROJECT_HEAD,PP.PROJECT_ID,PP.MAIN_PROCESS_CAT,PP.TARGET_START,TARGET_FINISH,pp.STAGE,YONETICI,PRIORITY,COLOR,NICKNAME from workcube_metosan.WORKGROUP_EMP_PAR AS WEP
LEFT JOIN (
SELECT ptp.STAGE,SMP.MAIN_PROCESS_CAT, PROJECT_ID,RELATED_PROJECT_ID, PP.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) AS YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS AS PP
LEFT JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMP ON SMP.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS AS PTP ON PTP.PROCESS_ROW_ID=PP.PRO_CURRENCY_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PP.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PP.COMPANY_ID 
) as PP on PP.PROJECT_ID=WEP.PROJECT_ID
where EMPLOYEE_ID=#session.ep.userid# and WEP.PROJECT_ID is not null

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