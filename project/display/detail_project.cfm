<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
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
    <div style="display:flex;width: 50%;flex-direction: row;flex-wrap: wrap;align-content: stretch;justify-content: flex-start;align-items: flex-end;">
        <div class="prSt prGray">Ürün Dizayn</div>
        <div class="prSt prGray">Çalışma Gurupları</div>
        <div class="prSt prGray">İşler</div>
        <div class="prSt prGray" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_list_related_projects_pbs&project_id=#attributes.project_id#</cfoutput>'">İlişkili Projeler</div>
        <div class="prSt prGray">Belgeler</div>
        <div class="prSt prGray">Üretim Emirleri</div>
        <div class="prSt prGray">Notlar</div>
        <div class="prSt prGray">Malzeme İhtiyaçları</div>
        <div class="prSt prGray">Teklife Dönüştür</div>
        <div class="prSt prGray">İlişkili İşlemler</div>
        </div>
        <div id="leftMenuPss" style="width:10%;height:90vh;background:gray;position: absolute;right: 0;top: 0;display:none">
            <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
            <div class="list-group">
                <a class="list-group-item" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_welcome</cfoutput>'">
                    Proje Ana Sayfa
                </a>
            </div>
        </cf_box>
        </div>
    </cf_box>

    <script>
        
            $(document).on("mousemove",function(ev){
   
    if(ev.clientX >=window.innerWidth-100){
        $(leftMenuPss).show(500);
    }else if(ev.clientX >=window.innerWidth-200){
        $(leftMenuPss).hide(500);
    }
})
        
    </script>