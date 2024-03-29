﻿<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.location_id" default="">

<cfparam name="attributes.department_id2" default="">
<cfparam name="attributes.location_name2" default="">
<cfparam name="attributes.location_id2" default="">

<cfparam name="attributes.department_id3" default="">
<cfparam name="attributes.location_name3" default="">
<cfparam name="attributes.location_id3" default="">

<cfparam name="attributes.department_id4" default="">
<cfparam name="attributes.location_name4" default="">
<cfparam name="attributes.location_id4" default="">


<cfparam name="attributes.record_emp_id " default="">
<cfparam name="attributes.record_cons_id " default="">
<cfparam name="attributes.record_part_id " default="">
<cfparam name="attributes.record_name " default="">

<div class="row myhomeBox" style="position: relative; height: 477px;">	 		
    <div class="col col-3 col-md-6 col-sm-12 homeSortArea ui-sortable" id="homeColumnLeft" style="position: absolute; left: 0px; top: 5px;">
<cf_box title="Depo Tanımlama">
<cfquery name="getD" datasource="#dsn3#">
    SELECT *,#dsn#.getEmployeeWithId(EPLOYEE_ID) AS EMP FROM workcube_metosan.PRTOTM_PDA_DEPARTMENT_DEFAULTS
</cfquery>
<cfquery name="GETDETTA" datasource="#DSN#">
    SELECT CONVERT(VARCHAR,SL.DEPARTMENT_ID)+'_'+CONVERT(VARCHAR,SL.LOCATION_ID) AS D_ID,SL.COMMENT,D.DEPARTMENT_HEAD,D.DEPARTMENT_ID,SL.LOCATION_ID FROM workcube_metosan.STOCKS_LOCATION AS SL
LEFT JOIN DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID

</cfquery>
<cfloop query="GETDETTA">
    <CFSET "DEPO.DEP_#D_ID#"="#DEPARTMENT_HEAD# #COMMENT#">
</cfloop>

<cf_grid_list>
    <thead>
    <tr>
        <th rowspan="2">Çalışan</th>
        <th colspan="2">
            Mal Kabulden - Rafa
        </th>
        <th colspan="2">
            Raftan - Sevke
        </th>
    </tr>
    <tr>
        <th>
            Malkabul
        </th>
        <th>
            Raf
        </th>
    
        <th>
            Raf
        </th>
        <th>
            Sevk
        </th>
    </tr>
</thead>
<tbody>
    <cfoutput>
        <cfloop query="getD">
            
            <CFSET D_1=listGetAt(DEFAULT_MK_TO_RF_DEP,1)>
            <CFSET D_2=listGetAt(DEFAULT_MK_TO_RF_DEP,2)>
            <CFSET L_1=listGetAt(DEFAULT_MK_TO_RF_LOC,1)>
            <CFSET L_2=listGetAt(DEFAULT_MK_TO_RF_LOC,2)>
            <cfset dl_1="#D_1#_#L_1#">
            <cfset dl_2="#D_2#_#L_2#">
            <cfset dx1=evaluate("DEPO.DEP_#dl_1#")>
            <cfset dx2=evaluate("DEPO.DEP_#dl_2#")>
                
                <CFSET D_3=listGetAt(DEFAULT_RF_TO_SV_DEP,1)>
                <CFSET D_4=listGetAt(DEFAULT_RF_TO_SV_DEP,2)>
                <CFSET L_3=listGetAt(DEFAULT_RF_TO_SV_LOC,1)>
                <CFSET L_4=listGetAt(DEFAULT_RF_TO_SV_LOC,2)>
                <cfset dl_1="#D_3#_#L_3#">
                <cfset dl_2="#D_4#_#L_4#">
                <cfset dx3=evaluate("DEPO.DEP_#dl_1#")>
                <cfset dx4=evaluate("DEPO.DEP_#dl_2#")>
                <cfset adres="">
<cfset adres="#adres#&department_id=#D_1#">
<cfset adres="#adres#&location_name=#dx1#">
<cfset adres="#adres#&location_id=#L_1#">

<cfset adres="#adres#&department_id2=#D_2#">
<cfset adres="#adres#&location_name2=#dx2#">
<cfset adres="#adres#&location_id2=#L_2#">                

<cfset adres="#adres#&department_id3=#D_3#">
<cfset adres="#adres#&location_name3=#dx3#">
<cfset adres="#adres#&location_id3=#L_3#">                

<cfset adres="#adres#&department_id4=#D_4#">
<cfset adres="#adres#&location_name4=#dx4#">
<cfset adres="#adres#&location_id4=#L_4#">                

<cfset adres="#adres#&record_emp_id=#EPLOYEE_ID#">
<cfset adres="#adres#&record_name=#EMP#">                


            <tr>
                <td>
<a href="#request.self#?fuseaction=#attributes.fuseaction##adres#">#EMP#</a>                    
                </td>
                <td>
                    #dx1#
                </td>
                <td>
                    #dx2#
                </td>
                
                <td>
                    #dx3#
                </td>
                <td>
                    #dx4#
                </td>
            </tr>
        </cfloop>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>
</div>
<div class="col col-6 col-md-6 col-sm-12 homeSortArea ui-sortable" id="homeColumnCenter" style="position: absolute; left: 477.5px; top: 5px;">		
<cf_box>
    <cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<table>
    <tr>
        <td colspan="2">
            <div class="form-group" id="item-record_emp_id">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">Çalışan</label>	
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="input-group">
                    <cfoutput> 
                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="#attributes.record_emp_id#">
                        <input type="hidden" name="record_cons_id" id="record_cons_id" value="#attributes.record_cons_id#">
                        <input type="hidden" name="record_part_id" id="record_part_id" value="#attributes.record_part_id#">
                        <input name="record_name" id="record_name" type="text" placeholder="Çalışan" onfocus="AutoComplete_Create('record_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,PARTNER_ID,EMPLOYEE_ID,MEMBER_NAME','record_cons_id,record_part_id,record_emp_id,record_name','','3','250');" value="#attributes.record_name#" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_emp_id=order_form.record_emp_id&field_name=order_form.record_name&field_consumer=order_form.record_cons_id&field_partner=order_form.record_part_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3');"></span>
                    </cfoutput>
                    </div>
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            Mal Kabulden - Rafa
        </td>
    </tr>
    <tr>
        <td>
            <div class="form-group" id="item-sales_departments1">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                    returninputvalue="location_name,department_id,location_id"
                    returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                    fieldname="location_name"
                    fieldid="location_id"
                    branch_fldId=""
                    department_fldid="department_id"
                    department_id="#attributes.department_id#"
                    location_name="#attributes.location_name#"
                    location_id="#attributes.location_id#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    width="120">
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-sales_departments2">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                    returninputvalue="location_name2,department_id2,location_id2"
                    returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                    fieldname="location_name2"
                    fieldid="location_id2"
                    branch_fldId=""
                    department_fldid="department_id2"
                    department_id="#attributes.department_id2#"
                    location_name="#attributes.location_name2#"
                    location_id="#attributes.location_id2#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    width="120">
                </div>
            </div>
        </td>
    </tr>

    <tr>
        <td colspan="2">
            Raftan - Sevke
        </td>
    </tr>
    <tr>
        <td>
            <div class="form-group" id="item-sales_departments3">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                    returninputvalue="location_name3,department_id3,location_id3"
                    returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                    fieldname="location_name3"
                    fieldid="location_id3"
                    branch_fldId=""
                    department_fldid="department_id3"
                    department_id="#attributes.department_id3#"
                    location_name="#attributes.location_name3#"
                    location_id="#attributes.location_id3#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    width="120">
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-sales_departments4">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                    returninputvalue="location_name4,department_id4,location_id4"
                    returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                    fieldname="location_name4"
                    fieldid="location_id4"
                    branch_fldId=""
                    department_fldid="department_id4"
                    department_id="#attributes.department_id4#"
                    location_name="#attributes.location_name4#"
                    location_id="#attributes.location_id4#"
                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                    width="120">
                </div>
            </div>
        </td>
    </tr>
</table>
<input type="hidden" name="is_submit">
<input type="submit">

</cfform>
<cfif isDefined("attributes.is_submit")>
    <cfdump var="#attributes#">
    <cfquery name="del" datasource="#dsn#">
        DELETE FROM PRTOTM_PDA_DEPARTMENT_DEFAULTS WHERE EPLOYEE_ID=#attributes.record_emp_id#
    </cfquery>
    <cfquery name="ins" datasource="#dsn#" result="res">
        INSERT  INTO PRTOTM_PDA_DEPARTMENT_DEFAULTS( DEFAULT_MK_TO_RF_DEP,
            DEFAULT_MK_TO_RF_LOC,
            DEFAULT_RF_TO_SV_DEP,
            DEFAULT_RF_TO_SV_LOC,
            EPLOYEE_ID) VALUES (N'#attributes.department_id#,#attributes.department_id2#','#attributes.location_id#,#attributes.location_id2#',
            '#attributes.department_id3#,#attributes.department_id4#','#attributes.location_id3#,#attributes.location_id4#',#attributes.record_emp_id#)
    </cfquery>
    <cfdump var="#res#">
</cfif>

</cf_box>

</div>
</div>
