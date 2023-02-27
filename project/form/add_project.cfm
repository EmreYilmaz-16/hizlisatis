<cfquery name="getCats" datasource="#dsn#">
    SELECT * FROM workcube_metosan.SETUP_MAIN_PROCESS_CAT
</cfquery>
<cf_box title="Yeni Proje" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfform name="add_project_form">
    <input type="hidden" name="consumer_id" id="consumer_id" value="">
    <input type="hidden" name="company_id" id="company_id" value="">
    <div class="form-group" id="form_ul_about_par_name" style="display: none;">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Yetkili </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
            <input type="hidden" name="partner_id" id="partner_id" value="">
            <input type="text" name="about_par_name" id="about_par_name" value="">
        </div>
    </div>
    <input type="hidden" name="task_partner_id" id="task_partner_id" value="" class="">
    <input type="hidden" name="project_pos_code" id="project_pos_code" value="" 
    <table>
        <tr>
            <td>
                <div class="form-group">
                    <select name="projectCat" required>
                        <option value="">Ürün Tipi</option>
                        <cfoutput query="getCats">
                            <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                        </cfoutput>
                    </select>
                </div>
            </td>
            <td>
                <div class="form-group">
                <cf_workcube_process is_upd='0'  is_detail='0'>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group" id="item_about_company">                    
                    <label>Şirket </label>                                        
                    <div class="input-group">
                        <input type="text" name="about_company" onblur="" id="about_company" placeholder="" value="" onchange="" class="" data-gdpr="">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&field_comp_id=add_project_form.company_id&is_period_kontrol=0&field_comp_name=add_project_form.about_company&field_partner=add_project_form.partner_id&field_consumer=add_project_form.consumer_id&field_name=add_project_form.about_par_name&par_con=1&select_list=2,3')"></span>                    
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group" id="item_responsable_name">
                    <label>Yönetici *</label>
                    <div class="input-group">
                        <input type="text" name="responsable_name" onblur="" required="yes" id="responsable_name" placeholder="" value="" onchange="" class="" data-gdpr="">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&field_partner=add_project_form.task_partner_id&field_emp_id=add_project_form.project_emp_id&field_code=add_project_form.project_pos_code&field_comp_id=add_project_form.task_company_id&field_name=add_project_form.responsable_name&select_list=1,2')"></span>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <label>Başlangıç Tarihi</label>
                    <input type="date" name="start_data" placeholder="Başlangıç Tarihi">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label>Bitiş Tarihi</label>
                    <input type="date" name="finish_data" placeholder="Bitiş Tarihi">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form-group">
                    <label>Proje Adı</label>
                    <input type="text" name="project_head" id="project_head">
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label>Proje No</label>
                    <input type="text" name="project_number" id="project_number">
                </div>
            </td>
        </tr>
    </table>
</cfform>
</cf_box>