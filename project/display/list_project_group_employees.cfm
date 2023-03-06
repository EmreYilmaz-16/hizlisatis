<cf_box title="Çalışma Grubu">
<cfquery name="getWorkGroupEmployees" datasource="#dsn#">
    SELECT EMP_INFO.*,ROLE_HEAD FROM workcube_metosan.WORKGROUP_EMP_PAR  AS WEP
    LEFT JOIN (
    select E.EMPLOYEE_ID, ISNULL(PHOTO,CASE WHEN ED.SEX=1 THEN 'male.jpg' else 'female.jpg' end) AS PHOTO,CASE WHEN PHOTO IS NULL THEN '/images/' else '/documents/hr/' end as phath ,EMPLOYEE_NAME,EMPLOYEE_SURNAME,ED.SEX from workcube_metosan.EMPLOYEES AS E
    LEFT JOIN workcube_metosan.EMPLOYEES_DETAIL AS ED ON ED.EMPLOYEE_ID=E.EMPLOYEE_ID
    ) AS EMP_INFO ON EMP_INFO.EMPLOYEE_ID=WEP.EMPLOYEE_ID
    WHERE WORKGROUP_ID=(SELECT WORKGROUP_ID FROM workcube_metosan.WORK_GROUP WHERE PROJECT_ID=#attributes.PROJECT_ID#)
    </cfquery>
    <cfquery name="getProject" datasource="#dsn#">
        select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
    INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
    INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
    INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
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

    <div id="leftMenuPss" style="width:10%;height:90vh;position: absolute;right: 0;top: 0;display:none">
        <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
        <div style="height:90vh">
            <cf_grid_list>
            <tr>
                <td>
                    <cfif len(getProject.RELATED_PROJECT_ID)>
                    <a class="list-group-item" onclick="<cfoutput>window.location.href='#request.self#?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=#getProject.RELATED_PROJECT_ID#'</cfoutput>">
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
    
    if(ev.clientX >=window.innerWidth-100){
    $(leftMenuPss).show(500);
    }else if(ev.clientX <=window.innerWidth-300){
    $(leftMenuPss).hide(500);
    }
    })
    
    </script>