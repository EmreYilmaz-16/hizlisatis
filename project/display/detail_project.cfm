
<cfdump var="#attributes#">
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
                    <td rowspan="2">
                        <cf_workcube_process is_upd='0' process_stage='#getProject.PRO_CURRENCY_ID#' process_cat_width='130' is_detail='0'>
                    </td>
                
            </tr>
            <tr>
                <th style="text-align:left">
                    Proje Yöneticisi
                </th>
                <td>
                    <cfoutput>#getProject.YONETICI#</cfoutput>
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
    <div class="prSt prGray">Ürün Dizayn</div>
    <div class="prSt prGray">Çalışma Gurupları</div>
    <div class="prSt prGray">İşler</div>
    <div class="prSt prGray">İlişkili Projeler</div>
    <div class="prSt prGray">Belgeler</div>
    <div class="prSt prGray">Üretim Emirleri</div>
    <div class="prSt prGray">Notlar</div>
    <div class="prSt prGray">Malzeme İhtiyaçları</div>
    <div class="prSt prGray">Teklife Dönüştür</div>
    <div class="prSt prGray">İlişkili İşlemler</div>
</cf_box>