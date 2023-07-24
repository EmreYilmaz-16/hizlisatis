<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">
<cf_box title="Çalışma Grubu" add_href="openBoxDraggable('index.cfm?fuseaction=project.popup_add_workgroup&project_id=#attributes.project_id#')">
<cfquery name="getWorkGroupEmployees" datasource="#dsn#">
    SELECT EMP_INFO.*,ROLE_HEAD FROM #dsn#.WORKGROUP_EMP_PAR  AS WEP
    LEFT JOIN (
    select E.EMPLOYEE_ID, ISNULL(PHOTO,CASE WHEN ED.SEX=1 THEN 'male.jpg' else 'female.jpg' end) AS PHOTO,CASE WHEN PHOTO IS NULL THEN '/images/' else '/documents/hr/' end as phath ,EMPLOYEE_NAME,EMPLOYEE_SURNAME,ED.SEX from #dsn#.EMPLOYEES AS E
    LEFT JOIN #dsn#.EMPLOYEES_DETAIL AS ED ON ED.EMPLOYEE_ID=E.EMPLOYEE_ID
    ) AS EMP_INFO ON EMP_INFO.EMPLOYEE_ID=WEP.EMPLOYEE_ID
    WHERE WORKGROUP_ID=(SELECT WORKGROUP_ID FROM #dsn#.WORK_GROUP WHERE PROJECT_ID=#attributes.PROJECT_ID#)
    </cfquery>
    <cfquery name="getProject" datasource="#dsn#">
        select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
    INNER join #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
    INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
    INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
    </cfquery>
    <div class="row" style="display:flex;justify-content: space-evenly;align-items: stretch;">
        <cfoutput query="getWorkGroupEmployees">
    <div class="col-2" style="padding:20px;background:white;border:solid 1px black;border-radius:3%">
    <div style="width:100%">
        <img style="width:100%" src="#getWorkGroupEmployees.phath##getWorkGroupEmployees.PHOTO#">
    </div>
    <div style="background:white">
    <code>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</code>
    <br>
    <small>
        #ROLE_HEAD#
    </small>
    </div>
    </div>
    </cfoutput>
    </div>
    </cf_box>


    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>