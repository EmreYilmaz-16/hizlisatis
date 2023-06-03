<!-----
    TODO: Buralara Dikkat Edelim
    *Sayfaları Yap
    index.cfm?fuseaction=objects.ajax_notes&&style=1&design_id=1&is_special=0&action_type=0&is_delete=1&action_section=PROJECT_ID&action_id=2558&is_open_det=1&period_id=
    ------>
    <!----  FIXME: ------>
    
<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfquery name="getProject" datasource="#dsn#">
    select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
</cfquery>
<cf_box title="Proje Detay">
<div style="height:90vh">
    <div >
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
    <div class="list-group list-group-horizontal-lg">
       <!----
        <a class="list-group-item list-group-item-action"</a>---->
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=product.emptypopup_design_product_pbs&project_id=#attributes.project_id#</cfoutput>'">   <img src="/images/e-pd/pdesign.png"> Ürün Dizayn</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_group_employees&project_id=#attributes.project_id#</cfoutput>'"><img src="/images/e-pd/wrkls.png"> Çalışma Gurupları</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_works&project_id=#attributes.project_id#</cfoutput>'"> <img src="/images/e-pd/wrks.png">İşler</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_related_projects_pbs&project_id=#attributes.project_id#</cfoutput>'"><img src="/images/e-pd/pr.png"> İlişkili Projeler</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_documents&project_id=#attributes.project_id#</cfoutput>'"> <img src="/images/e-pd/fld.png"> Belgeler</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"> <img src="/images/e-pd/oppr.png"> Üretim Emirleri</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&action_id=<cfoutput>#attributes.project_id#</cfoutput>'"> <img src="/images/e-pd/nt.png"> Notlar</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"><img src="/images/e-pd/pord.png"> Malzeme İhtiyaçları</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"><img src="/images/e-pd/ordrr.png"> Teklife Dönüştür</a>
        <a class="list-group-item list-group-item-action" style="display: inline-grid;align-content: center;text-align: center;justify-items: center;"><img src="/images/e-pd/rel.png"> İlişkili İşlemler</a>
   
    </div>
<!----
    <div style="display:flex;flex-direction: row;flex-wrap: wrap;align-content: stretch;justify-content: flex-start;align-items: flex-end;">
        <div class="prSt btn btn-outline-success" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=product.emptypopup_design_product_pbs&project_id=#attributes.project_id#</cfoutput>'">Ürün Dizayn</div>
        <div class="prSt btn btn-outline-warning" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_group_employees&project_id=#attributes.project_id#</cfoutput>'">Çalışma Gurupları</div>
        <div class="prSt btn btn-outline-danger"  onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_works&project_id=#attributes.project_id#</cfoutput>'">İşler</div>
        <div class="prSt btn btn-outline-primary" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_related_projects_pbs&project_id=#attributes.project_id#</cfoutput>'">İlişkili Projeler</div>
        <div class="prSt btn btn-outline-dark" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_project_documents&project_id=#attributes.project_id#</cfoutput>'"> Belgeler</div>
        <div class="prSt btn btn-outline-info">Üretim Emirleri</div>
        <div class="prSt btn btn-outline-success" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&action_id=<cfoutput>#attributes.project_id#</cfoutput>'">Notlar</div>
        <div class="prSt btn btn-outline-warning">Malzeme İhtiyaçları</div>
        <div class="prSt btn btn-outline-danger">Teklife Dönüştür</div>
        <div class="prSt btn btn-outline-primary">İlişkili İşlemler</div>
        </div>----->
        <div id="leftMenuPss" style="width:10%;height:90vh;position: absolute;right: 0;top: 0;display:none">
            <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
                <div style="height:90vh">
            <cf_grid_list>
                <tr>
                <td>
                    <a class="" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_welcome</cfoutput>'">
                    Proje Ana Sayfa
                </a>
            </td>
            </tr>
            </cf_grid_list>
        </div>
        </cf_box>
        </div>
    </div>
    </cf_box>
    
    <script>
        
            $(document).on("mousemove",function(ev){
   
    if(ev.clientX >=window.innerWidth-100){
        $(leftMenuPss).show(500);
    }else if(ev.clientX <=window.innerWidth-300){
        $(leftMenuPss).hide(500);
    }
})
$(document).ready(function () {
  var d = document.getElementById("wrk_main_layout");
  d.removeAttribute("class");
  d.setAttribute("class", "container-fluid");
});

    </script>