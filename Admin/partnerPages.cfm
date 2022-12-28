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
<cf_box title="Sayfa Listesi">
    <div class="form-group">
        <input type="text" id="Search" name="Search" placeholder="Search">
    </div>1
<cf_grid_list id="tblPages">
    <thead>
        <tr>
            <th>
                Sayfa
            </th>
            <th>
                Fuseaction
            </th>
            <th>
                Dosya Yolu
            </th>
            <th>
                Modül
            </th>
            <th>
                Family
            </th>
            <th></th>
        </tr>
    </thead>
    <tbody>
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
            <td>
                <a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=#FULL_FUSEACTION#&woid=#WRK_OBJECTS_ID#" target="_blank">Güncelle</a>
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>

<script>
    $(document).ready(function(){
  $("#Search").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#tblPages tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
</script>