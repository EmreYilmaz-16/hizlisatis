<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.deliver_dept_id" default="">
<cfparam name="attributes.deliver_loc_id" default="">
<cfparam name="attributes.deliver_dept_name" default="">

<cfif attributes.type eq 1>
    <cfquery name="del" datasource="#dsn3#">
        DELETE FROM DEPARTMENT_PERSONALS WHERE ID=#attributes.dp_id#
    </cfquery>

<script>
    window.opener.location.reload();
    this.close();
</script>
<cfabort>
</cfif>
<cfif attributes.type eq 2>
<cf_box title="Depoya Personel Ekleme">
    <cfform action="#request.self#?fuseaction=#attributes.fuseaction#&type=3" name="order_form"> 
        <div class="form-group" id="item-order_employee_id">						
            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">Çalışan </label>			
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="input-group">
                    <input type="hidden" name="order_employee_id" id="order_employee_id" value="">
                    <input name="order_employee" type="text" id="order_employee" placeholder="Çalışan " onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" value="" autocomplete="off"><div id="order_employee_div_2" name="order_employee_div_2" class="completeListbox" autocomplete="on" style="width: 453px; max-height: 150px; overflow: auto; position: absolute; left: 20px; top: 529px; z-index: 159; display: none;"></div>
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=order_form.order_employee_id&field_name=order_form.order_employee&is_form_submitted=1&select_list=1');"></span>
                </div>
            </div>
        </div>
        <div class="form-group require" id="item-deliver_dept_name">
            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58763.Depo'></label>
            <div class="col col-8 col-sm-12">
                <cf_wrkdepartmentlocation 
                    returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                    fieldName="deliver_dept_name"
                    fieldid="deliver_loc_id"
                    department_fldId="deliver_dept_id"
                    branch_fldId="branch_id"
                    branch_id="#attributes.branch_id#"
                    department_id="#attributes.deliver_dept_id#"
                    location_id="#attributes.deliver_loc_id#"
                    location_name="#attributes.deliver_dept_name#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    xml_all_depo = "1"
                    width="140">
            </div>                
        </div>
        <input type="hidden" name="is_submit">
        <input type="submit">
    </cfform>
</cf_box>
</cfif>
<cfif isDefined("attributes.is_submit") and attributes.type eq 3>
    <cfquery name="ins" datasource="#dsn3#">
        INSERT INTO DEPARTMENT_PERSONALS (EMPLOYEE_ID,DEPARTMENT_ID,LOCATION_ID) VALUES(#attributes.order_employee_id#,#attributes.deliver_dept_id#,#attributes.deliver_loc_id#)
    </cfquery>
    <script>
        alert("Kayıt Başarılı");
        window.opener.location.reload();
        this.close();
    </script>
</cfif>