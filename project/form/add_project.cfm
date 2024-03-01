<cfquery name="getCats" datasource="#dsn#">
    SELECT SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT,SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID,PRNUMBER,SHORT_CODE  FROM #dsn#.SETUP_MAIN_PROCESS_CAT 
INNER JOIN #dsn#.PROJECT_NUMBERS_BY_CAT ON PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID=SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID
</cfquery>
<cfquery name="GET_PRIORITY" datasource="#dsn#">
    SELECT
    PRIORITY_ID,PRIORITY
    FROM
        SETUP_PRIORITY
        
    ORDER BY
        PRIORITY_ID
</cfquery> 
<script>
    var SCodes=[
<cfoutput query="getCats">
{
    MAIN_PROCESS_CAT_ID:#MAIN_PROCESS_CAT_ID#,
    SHORT_CODE:'#SHORT_CODE#'
},
</cfoutput>
    ]
</script>
<cfparam name="attributes.upper_project_id" default="">


<span style="border-radius: 10px;background-color:white;padding: 5px 10px 15px 10px;" id="scrollList">
   <div style="display:flex;flex-direction: row;flex-wrap: nowrap;justify-content: flex-start;align-items: center;">
    <h3 style="color:orange">Yeni Proje</h3>
    <button style="margin-left:auto" class="btn btn-danger" type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')"><span class="icn-md icon-times"></span></button>
</div>
<cfif isDefined("attributes.upper_project_id") and len(attributes.upper_project_id)>
    <cfquery name="getProject" datasource="#dsn#">
            select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,COMPANY.COMPANY_ID,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from #dsn#.PRO_PROJECTS
INNER join #dsn#.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN #dsn#.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.upper_project_id#
    </cfquery>
    
</cfif> 
<cfform name="add_project_form" id="add_project_form" action="#request.self#?fuseaction=project.emptypopup_save_project">
    <input type="hidden" name="consumer_id" id="consumer_id" value="">
    <input type="hidden" name="company_id" id="company_id" value="<cfif isDefined('getProject')><cfoutput>#getProject.COMPANY_ID#</cfoutput></cfif>">
    <div class="form-group" id="form_ul_about_par_name" style="display: none;">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Yetkili </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
            <input type="hidden" name="partner_id" id="partner_id" value="">
            <input type="text" name="about_par_name" id="about_par_name" value="">
        </div>
    </div>
    <input type="hidden" name="task_partner_id" id="task_partner_id" value="" class="">
    <input type="hidden" name="project_pos_code" id="project_pos_code" value="">
    <input type="hidden" name="task_company_id" id="task_company_id" value="" class="">
    <input type="hidden" name="project_emp_id" id="project_emp_id" value="" class="">
<input type="hidden" name="RELATED_PROJECT_ID" value="<cfoutput>#attributes.upper_project_id#</cfoutput>">


    <table>
        <tr>
            <td>
                <div class="form-group">
                    <select name="projectCat" required onchange="ProjectNameGet(this)" class="form-control form-control-sm">
                        <option value="">Ürün Tipi</option>
                        <cfoutput query="getCats">
                            <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                        </cfoutput>
                    </select>
                </div>
            </td>
            <td>
                <div class="form-group">
                <cf_workcube_process cls="form-control form-control-sm" is_upd='0'  is_detail='0'>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <select name="PRIORITY_CAT" class="form-control form-control-sm">
                        <cfoutput query="GET_PRIORITY">
                            <option value="#PRIORITY_ID#">#PRIORITY#</option>
                        </cfoutput>                        
                    </select>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group" id="item_about_company">                    
                    <label>Şirket </label>                                        
                    <div class="input-group mb-3">
                        <input type="text" name="about_company" readonly onblur="" id="about_company" placeholder="" value="<cfif isDefined('getProject')><cfoutput>#getProject.NICKNAME#</cfoutput></cfif>" onchange="" class="form-control form-control-sm" data-gdpr="">
                        <span class="input-group-text" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&field_comp_id=add_project_form.company_id&is_period_kontrol=0&field_comp_name=add_project_form.about_company&field_partner=add_project_form.partner_id&field_consumer=add_project_form.consumer_id&field_name=add_project_form.about_par_name&par_con=1&select_list=2,3')">
                        <span class="icon-ellipsis"></span>
                        </span>                    
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group" id="item_responsable_name">
                    <label>Proje Yöneticisi *</label>
                    <div class="input-group">
                        <input type="text" name="responsable_name" readonly onblur="" required="yes" id="responsable_name" placeholder="" value="" onchange="" class="form-control form-control-sm" data-gdpr="">
                        <span class="input-group-text" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&field_partner=add_project_form.task_partner_id&field_emp_id=add_project_form.project_emp_id&field_code=add_project_form.project_pos_code&field_comp_id=add_project_form.task_company_id&field_name=add_project_form.responsable_name&select_list=1,2')">
                            <span class="icon-ellipsis"></span>
                        </span>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <label>Başlangıç Tarihi</label>
                    <input type="date" class="form-control form-control-sm" name="start_date" placeholder="Başlangıç Tarihi">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label>Bitiş Tarihi</label>
                    <input type="date" class="form-control form-control-sm" name="finish_date" placeholder="Bitiş Tarihi">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <label>Proje Adı</label>
                    <input type="text" class="form-control form-control-sm" name="project_head" id="project_head">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label>Proje No</label>
                    <input type="text" class="form-control form-control-sm" name="project_number" id="project_number">
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:right">
                <div class="form-group">
                    <label>Açıklama</label>
                    <textarea class="form-control form-control-sm" name="project_detail" id="project_detail"></textarea>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:right">
                <button type="submit" class="btn btn-success">Kaydet</button>
            </td>
        </tr>
    </table>
</cfform>
</span>