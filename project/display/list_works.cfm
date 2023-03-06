<cfquery name="getWorks" datasource="#dsn#">
SELECT WORK_ID
	,WORK_STATUS
	,RELATED_WORK_ID
	,WORK_HEAD
	,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
	,TARGET_START
	,TARGET_FINISH
	,TERMINATE_DATE
	,workcube_metosan.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
FROM workcube_metosan.PRO_WORKS
WHERE PROJECT_ID = #attributes.PROJECT_ID#
</cfquery>

<cf_box title="İşler">
    <cf_grid_list>
        <thead>
            <tr>
                <th>
                    # 
                </th>
                <th>
                    Görev
                </th>
                <th>
                    Görevli
                </th>
                <th>
                    Termin Tarihi
                </th>
                <th>
                    Hedef Başlangıç
                </th>
                <th>
                    Hedef Bitiş
                </th>
                <th>Atayan</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="getWorks">
                <tr>
                    <td>#WORK_ID#</td>
                    <td>#WORK_HEAD#</td>
                    <td>#PROJECT_EMP#</td>
                    <td>#dateFormat(TERMINATE_DATE,"dd/mm/yyyy")#</td>
                    <td>#dateFormat(TARGET_START,"dd/mm/yyyy")#</td>
                    <td>#dateFormat(TARGET_FINISH,"dd/mm/yyyy")#</td>
                    <td>#RECORD_AUTHOR#</td>
                    <td><span class="icn-md icon-search"></span></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>