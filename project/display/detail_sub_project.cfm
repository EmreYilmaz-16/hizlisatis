<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">
<cfquery name="getProject" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER join #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
</cfquery>
<cfquery name="getProject2" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER join #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#getProject.RELATED_PROJECT_ID#
</cfquery>
<cf_box title="Proje Detay">
   <div style="display:flex">
    <div style="width:50%">
        <table style="width:100%">
            <tr>
                <th colspan="2" style="color:orange;font-size:14pt;text-align:left">
                    Proje : <cfoutput>#getProject.PROJECT_HEAD#</cfoutput>
                </th>
            </tr>
            <tr>
                
                    <th style="text-align:left;width:20%">
                        Şirket
                    </th>
                    <td>
                        <cfoutput>#getProject.NICKNAME#</cfoutput>
                    </td>
                    <td >
                        <div class="form-group">
                        <cf_workcube_process is_upd='0' process_stage='#getProject.PRO_CURRENCY_ID#'  is_detail='0'>
                        </div>
                    </td>
                
            </tr>
            <tr>
                <th style="text-align:left">
                    Proje Yöneticisi
                </th>
                <td>
                    <cfoutput>#getProject.YONETICI#</cfoutput>
                </td>  
                <td>
                    <cfoutput><span style="padding: 5px !important;display: block;border-radius: 4px;" class="color#getProject.COLOR#">#getProject.PRIORITY#</span></cfoutput>
                </td>              
            </tr>
            <tr>
                <th style="text-align:left">
                    Tamamlanma
                </th>
                <td>
                    <div style="width:100%;display:flex;border:solid 1px gray;border-radius:100px;background: white;">
                        <span style="display: block;width: 0%;background: #ffb000;text-align: right;font-weight: bold;color: white;padding-right: 10px;border-radius: 100px 0 0 100px;">0%</span>
                        <span style="display:block;width:100%">&nbsp;</span>
                       </div>
                    </td>
            </tr>
        </table>
    </div>
    <div style="width:50%">
    
    <table style="width:100%">
        <tr>
            <th colspan="2" style="color:orange;font-size:14pt;text-align:left">
                Proje : <cfoutput>#getProject2.PROJECT_HEAD#</cfoutput>
            </th>
        </tr>
        <tr>
            
                <th style="text-align:left;width:20%">
                    Şirket
                </th>
                <td>
                    <cfoutput>#getProject2.NICKNAME#</cfoutput>
                </td>
                <td >
                    <div class="form-group">
                    <cf_workcube_process is_upd='0' process_stage='#getProject2.PRO_CURRENCY_ID#'  is_detail='0'>
                    </div>
                </td>
            
        </tr>
        <tr>
            <th style="text-align:left">
                Proje Yöneticisi
            </th>
            <td>
                <cfoutput>#getProject2.YONETICI#</cfoutput>
            </td>  
            <td>
                <cfoutput><span style="padding: 5px !important;display: block;border-radius: 4px;" class="color#getProject2.COLOR#">#getProject2.PRIORITY#</span></cfoutput>
            </td>              
        </tr>
        <tr>
            <th style="text-align:left">
                Tamamlanma
            </th>
            <td>
                <div style="width:100%;display:flex;border:solid 1px gray;border-radius:100px;background: white;">
                    <span style="display: block;width: 0%;background: #ffb000;text-align: right;font-weight: bold;color: white;padding-right: 10px;border-radius: 100px 0 0 100px;">0%</span>
                    <span style="display:block;width:100%">&nbsp;</span>
                   </div>
                </td>
        </tr>
    </table>
</div>
</div>
    
    <div class="list-group list-group-horizontal-lg">
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#getProject.RELATED_PROJECT_ID#</cfoutput>'">
            <img src="/images/e-pd/up40.png"> 
           Üst Proje
        </a>
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=product.emptypopup_design_sub_product_pbs&project_id=#attributes.project_id#</cfoutput>'">
            <img src="/images/e-pd/pdesign.png"> 
            Ürün Dizayn
        </a>
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_group_employees&project_id=#attributes.project_id#</cfoutput>'">
            <img src="/images/e-pd/wrkls.png">
            Çalışma Gurupları
        </a>
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_works&project_id=#attributes.project_id#</cfoutput>'">
            <img src="/images/e-pd/wrks.png">
            İşler
        </a>        
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_documents&project_id=#attributes.project_id#</cfoutput>'">
            <img src="/images/e-pd/fld.png">
            Belgeler
        </a>        
        <a class="list-group-item list-group-item-action" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&action_id=<cfoutput>#attributes.project_id#</cfoutput>'">
            <img src="/images/e-pd/nt.png">
            Notlar
        </a>
        <a class="list-group-item list-group-item-action" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_product_needs&project_id=#attributes.project_id#</cfoutput>'" >
            <img src="/images/e-pd/pord.png">
            Malzeme İhtiyaçları
        </a>
        </div>
   
    </cf_box>

    <script>
        

$(document).ready(function () {
  var d = document.getElementById("wrk_main_layout");
  d.removeAttribute("class");
  d.setAttribute("class", "container-fluid");
});
 
    </script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>