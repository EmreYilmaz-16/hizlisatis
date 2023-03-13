<cf_box title="Çalışan Hazırlama Departmanları">
    <cfquery name="getData" datasource="#dsn#">
        SELECT DP.ID,workcube_metosan.getEmployeewithId(DP.EMPLOYEE_ID) AS EMPLOYEE ,D.DEPARTMENT_HEAD,SL.COMMENT,DP.DEPARTMENT_ID,DP.LOCATION_ID FROM workcube_metosan_1.DEPARTMENT_PERSONALS AS DP
	LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=DP.DEPARTMENT_ID
	LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=DP.LOCATION_ID  AND SL.DEPARTMENT_ID=DP.DEPARTMENT_ID 
WHERE 1=1 AND DP.ID <>19
ORDER BY DEPARTMENT_ID,LOCATION_ID 
    </cfquery>

    <cfoutput query="getData" group="DEPARTMENT_ID">
        <cf_box title="#DEPARTMENT_HEAD#">

        </cf_box>
    </cfoutput>
</cf_box>