<cfparam name="attributes.department_id_1" default="">
<cfparam name="attributes.location_name_1" default="">
<cfparam name="attributes.location_id_1" default="">
<cfparam name="attributes.department_id_2" default="">
<cfparam name="attributes.location_name_2" default="">
<cfparam name="attributes.location_id_2" default="">
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
<cfdump var="#DEPO#">
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
            <tr>
                <td>
                    #EMP#
                </td>
                <td>
                    #evaluate("DEPO.DEP_#dl_1#")#
                </td>
                <td>
                    #evaluate("DEPO.DEP_#dl_2#")#
                </td>
                <CFSET D_1="">
                <CFSET D_2="">
                <CFSET L_1="">
                <CFSET L_2="">
                <CFSET D_1=listGetAt(DEFAULT_RF_TO_SV_DEP,1)>
                <CFSET D_2=listGetAt(DEFAULT_RF_TO_SV_DEP,2)>
                <CFSET L_1=listGetAt(DEFAULT_RF_TO_SV_LOC,1)>
                <CFSET L_2=listGetAt(DEFAULT_RF_TO_SV_LOC,2)>
                <cfset dl_1="#D_1#_#L_1#">
                <cfset dl_2="#D_2#_#L_2#">
                <td>
                    #evaluate("DEPO.DEP_#dl_1#")#
                </td>
                <td>
                    #evaluate("DEPO.DEP_#dl_2#")#
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
    
<table>
    <tr>
        <td>
            <div class="form-group" id="item-sales_departments">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                        returninputvalue="location_name_1,department_id_1,location_id_1"
                        returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                        fieldname="location_name_1"
                        fieldid="department_id_1"
                        branch_fldId=""
                        department_fldid="department_id_1"
                        department_id="#attributes.department_id_1#"
                        location_name="#attributes.location_name_1#"
                        location_id="#attributes.location_id_1#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        width="120">
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-sales_departments">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_wrkdepartmentlocation 
                        returninputvalue="location_name_2,department_id_2,location_id_2"
                        returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                        fieldname="location_name_2"
                        fieldid="department_id_2"
                        branch_fldId=""
                        department_fldid="department_id_2"
                        department_id="#attributes.department_id_2#"
                        location_name="#attributes.location_name_2#"
                        location_id="#attributes.location_id_2#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        width="120">
                </div>
            </div>
        </td>
    </tr>
</table>

</cf_box>
</div>
</div>