<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">

<cfquery name="getWorks" datasource="#dsn#">
SELECT WORK_ID
	,WORK_STATUS
	,RELATED_WORK_ID
	,WORK_HEAD
	,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
	,TARGET_START
	,TARGET_FINISH
	,TERMINATE_DATE
	,#dsn#.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
    ,PTR.STAGE
FROM #dsn#.PRO_WORKS as PWH
LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
WHERE PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>
<cfquery name="getProject" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER join #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
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




<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>