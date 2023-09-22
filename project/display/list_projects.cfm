<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">

<cfif isDefined("attributes.list_my_projects")>
    <cfinclude template="list_my_projects.cfm">
    <cfabort>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#" name="search" id="search">
    <table>
        <tr>
            <td>
                <div class="form-group">
                    <label>Filtre</label>
                    <input type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
                </div>
            </td>
            <td>
                <div class="form-group" id="form_ul_process_catid">
                    <label>Kategori </label>
                    <select name="process_catid" id="process_catid">
                        <option value="">Seçiniz </option>
                         
                            <option value="1">Direksiyon Seti</option>
                         
                            <option value="2">Test Makinası</option>
                         
                            <option value="3">Hidrolik Güç Ünitesi</option>
                         
                            <option value="4">Elektrik Panosu</option>
                         
                            <option value="5">Hidrolik Silindir</option>
                         
                            <option value="6">Pnömatik Sistem Panosu</option>
                         
                            <option value="7">Hidrolik Blok</option>
                         
                            <option value="8">Kompleks Proje</option>
                         
                            <option value="9">Traktör Satışı</option>
                         
                            <option value="10">Workcube ERP</option>
                         
                            <option value="1010">Ar-Ge Projeleri</option>
                         
                    </select>
                </div>
            </td>
            <td>
                <div class="form-group" id="form_ul_consumer_id">
                    <label>Üye </label>
                    <div class="input-group input-group-sm mb-3" style="flex-wrap: nowrap">
                        <input type="hidden" name="consumer_id" id="consumer_id">			
                        <input type="hidden" name="company_id" id="company_id">
                        <input   type="text" name="company" id="company" value="" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','','3','250');" autocomplete="off" style=""><div id="company_div_2" name="company_div_2" class="completeListbox" autocomplete="on" style="width: 516px; max-height: 150px; overflow: auto; position: absolute; left: 15px; top: 319.444px; z-index: 159; display: none;"></div>
                        <span class="input-group-text icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=search.company&field_comp_id=search.company_id&field_consumer=search.consumer_id&field_member_name=search.company','list')"></span>
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group" id="form_ul_pro_employee_id">
                    <label>Görevli </label>
                    <div class="input-group input-group-sm mb-3" style="flex-wrap: nowrap">
                        
                        <input  type="text" name="pro_employee" id="pro_employee" value="" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','COMPANY_ID,PARTNER_ID,EMPLOYEE_ID','pro_company_id,pro_partner_id,pro_employee_id','','3','200','get_company()');" passthrough="readonly" autocomplete="off" style=""><div id="pro_employee_div_2" name="pro_employee_div_2" class="completeListbox" autocomplete="on" style="width: 516px; max-height: 150px; overflow: auto; position: absolute; left: 15px; top: 260px; z-index: 159; display: none;"></div>
                        <span class="input-group-text icon-ellipsis btnPointer" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_partner=search.pro_partner_id&field_emp_id=search.pro_employee_id&field_code=search.project_pos_code&field_comp_id=search.pro_company_id&field_name=search.pro_employee&select_list=1,2','list');"></span>
                        <input type="hidden" name="project_pos_code" id="project_pos_code" value="">
                        <input type="hidden" name="pro_employee_id" id="pro_employee_id" value="">
                        <input type="hidden" name="pro_company_id" id="pro_company_id" value="">
                        <input type="hidden" name="pro_partner_id" id="pro_partner_id" value="">
                        
                    </div>
                </div>
            </td>
        </tr>
    </table>
</cfform>
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
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>