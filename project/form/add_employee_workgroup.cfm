<cfinclude template="../includes/upperMenu.cfm">
<cfquery name="getWorkGroupEmployees" datasource="#dsn#">
SELECT EMP_INFO.*,ROLE_HEAD FROM #dsn#.WORKGROUP_EMP_PAR  AS WEP
LEFT JOIN (
select E.EMPLOYEE_ID, ISNULL(PHOTO,CASE WHEN ED.SEX=1 THEN 'male.jpg' else 'female.jpg' end) AS PHOTO,CASE WHEN PHOTO IS NULL THEN '/images/' else '/documents/hr/' end as phath ,EMPLOYEE_NAME,EMPLOYEE_SURNAME,ED.SEX from #dsn#.EMPLOYEES AS E
LEFT JOIN #dsn#.EMPLOYEES_DETAIL AS ED ON ED.EMPLOYEE_ID=E.EMPLOYEE_ID
) AS EMP_INFO ON EMP_INFO.EMPLOYEE_ID=WEP.EMPLOYEE_ID
WHERE WORKGROUP_ID=(SELECT WORKGROUP_ID FROM #dsn#.WORK_GROUP WHERE PROJECT_ID=#attributes.PROJECT_ID#)
</cfquery>
<div class="row">
    <cfoutput query="">
<div class="col-2">
<div style="width:100%">
    <img src="#getWorkGroupEmployees.phath##getWorkGroupEmployees.PHOTO#">
</div>
<div style="background:white">
<code>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</code>
<br>
<small>
    #ROLE_HEAD#
</small>
</div>
</div>
</cfoutput>
</div>