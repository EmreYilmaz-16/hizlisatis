<cf_box title="Çalışan Hazırlama Departmanları">
    <cfquery name="getData" datasource="#dsn#">
SELECT DP.ID as DP_ID
	,workcube_metosan.getEmployeewithId(DP.EMPLOYEE_ID) AS EMPLOYEE
	,TTL.DEPARTMENT_HEAD
	,TTL.COMMENT
	,DP.DEPARTMENT_ID
	,TTL.LOCATION_ID
	,TTL.BRANCH_ID
	,TTL.BRANCH_FULLNAME
FROM #DSN3#.DEPARTMENT_PERSONALS AS DP
LEFT JOIN (
	SELECT D.DEPARTMENT_HEAD
		,D.DEPARTMENT_ID
		,B.BRANCH_ID
		,B.BRANCH_FULLNAME
		,SL.LOCATION_ID
		,SL.COMMENT
	FROM workcube_metosan.DEPARTMENT AS D
	LEFT JOIN workcube_metosan.BRANCH AS B ON D.BRANCH_ID = B.BRANCH_ID
	LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID = D.DEPARTMENT_ID
	) TTL ON TTL.LOCATION_ID = DP.LOCATION_ID
	AND TTL.DEPARTMENT_ID = DP.DEPARTMENT_ID
WHERE 1 = 1
	
ORDER BY DEPARTMENT_ID
	,LOCATION_ID
    </cfquery>

    <cfoutput query="getData" group="DEPARTMENT_ID">
        <cf_box title="#DEPARTMENT_HEAD#" collapsed="1">
            <cfoutput group="LOCATION_ID">
                <cf_seperator title="#COMMENT#" id="item#DEPARTMENT_ID#_#LOCATION_ID#" style="display:none;">
                   <div id="item#DEPARTMENT_ID#_#LOCATION_ID#">
                    <cf_ajax_list>
                        <tr>
                            <th>Çalışan</th>
                            <th>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=epda.emptypopup_form_add_employee_departments&type=2&branch_id=#BRANCH_ID#&deliver_dept_id=#DEPARTMENT_ID#&deliver_loc_id=#LOCATION_ID#')"><span class="fa fa-plus"></span></a>
                            </th>
                        </tr>
                    <cfoutput>
                        <!-----
                            <cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.deliver_dept_id" default="">
<cfparam name="attributes.deliver_loc_id" default="">
<cfparam name="attributes.deliver_dept_name" default="">----->
                            <tr>
                                <td>#EMPLOYEE#</td>
                                <td style="text-align:center"><a href="javascript://" onclick="if(confirm('Silmek İstediğinize Eminmisiniz')){windowopen('#request.self#?fuseaction=epda.emptypopup_form_add_employee_departments&type=1&dp_id=#DP_ID#&deliver_dept_name=#DEPARTMENT_HEAD# #COMMENT#')}"><span class="fa fa-minus"></span></a></td>
                            </tr>
                        
                    </cfoutput>
                </cf_ajax_list>
            </div>
            </cfoutput>
        </cf_box>
    </cfoutput>
</cf_box>