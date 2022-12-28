<cfquery name="getPages" datasource="#dsn3#">
    SELECT * FROM (
SELECT WO.WRK_OBJECTS_ID,WO.HEAD,WO.FULL_FUSEACTION,WO.FILE_PATH,WM.MODULE,WF.FAMILY,WS.SOLUTION FROM workcube_metosan.WRK_OBJECTS AS WO
	LEFT JOIN workcube_metosan.WRK_MODULE AS WM ON WM.MODULE_NO=WO.MODULE_NO
	LEFT JOIN workcube_metosan.WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID=WM.FAMILY_ID
	LEFT JOIN workcube_metosan.WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID=WF.WRK_SOLUTION_ID
WHERE WS.WRK_SOLUTION_ID=18
UNION ALL
SELECT WO.WRK_OBJECTS_ID,WO.HEAD,WO.FULL_FUSEACTION,WO.FILE_PATH,WM.MODULE,WF.FAMILY,WS.SOLUTION FROM workcube_metosan.WRK_OBJECTS AS WO
	LEFT JOIN workcube_metosan.WRK_MODULE AS WM ON WM.MODULE_NO=WO.MODULE_NO
	LEFT JOIN workcube_metosan.WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID=WM.FAMILY_ID
	LEFT JOIN workcube_metosan.WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID=WF.WRK_SOLUTION_ID
WHERE WS.WRK_SOLUTION_ID=15 AND WO.FILE_PATH LIKE '/AddOns/Partner%'

) AS T ORDER BY FAMILY,MODULE,WRK_OBJECTS_ID
</cfquery>

<table id="tblPages">
    <cfoutput query="getPages">
        <tr>
            <td>
                #HEAD#
            </td>
            <td>
                #FULL_FUSEACTION#
            </td>
            <td>
                #FILE_PATH#
            </td>
            <td>
                #MODULE#
            </td>
            <td>
                #FAMILY#
            </td>
        </tr>
    </cfoutput>
</table>