<cfquery name="getPages" datasource="#dsn3#">
    SELECT * FROM (
SELECT WO.WRK_OBJECTS_ID,WO.HEAD,WO.FULL_FUSEACTION,WO.FILE_PATH,WM.MODULE,WF.FAMILY,WS.SOLUTION,WO.AUTHOR FROM workcube_metosan.WRK_OBJECTS AS WO
	LEFT JOIN workcube_metosan.WRK_MODULE AS WM ON WM.MODULE_NO=WO.MODULE_NO
	LEFT JOIN workcube_metosan.WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID=WM.FAMILY_ID
	LEFT JOIN workcube_metosan.WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID=WF.WRK_SOLUTION_ID
WHERE WS.WRK_SOLUTION_ID=18
UNION ALL
SELECT WO.WRK_OBJECTS_ID,WO.HEAD,WO.FULL_FUSEACTION,WO.FILE_PATH,WM.MODULE,WF.FAMILY,WS.SOLUTION,WO.AUTHOR FROM workcube_metosan.WRK_OBJECTS AS WO
	LEFT JOIN workcube_metosan.WRK_MODULE AS WM ON WM.MODULE_NO=WO.MODULE_NO
	LEFT JOIN workcube_metosan.WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID=WM.FAMILY_ID
	LEFT JOIN workcube_metosan.WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID=WF.WRK_SOLUTION_ID
WHERE WS.WRK_SOLUTION_ID=15 AND WO.FILE_PATH LIKE '/AddOns/Partner%'

) AS T ORDER BY FAMILY,MODULE,WRK_OBJECTS_ID
</cfquery>
<!----------
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.0/polyfill.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.1.1/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.2/FileSaver.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.0.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.9/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.7.1/jszip.js" integrity="sha512-NOmoi96WK3LK/lQDDRJmrobxa+NMwVzHHAaLfxdy0DRHIBc6GZ44CRlYDmAKzg9j7tvq3z+FGRlJ4g+3QC2qXg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/event.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/supplemental.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/unresolved.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/message.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/number.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/currency.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/date.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.common.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.light.css" />
    <script src="https://cdn3.devexpress.com/jslib/20.2.4/js/dx.all.js"></script>
<cf_box title="DevExtreme Test">
  <div class="demo-container">
    <div id="gridContainer"></div>
    <div class="options">
      <div class="caption">Options</div>
      <div class="option">
        <div id="autoExpand"></div>
      </div>
    </div>
  </div>
</cf_box>
,C.COMPANY_TELCODE,C.COMPANY_TEL1

<script>
  const customers = [
  <cfoutput query="getPages">
  {
  ID: #WRK_OBJECTS_ID#,
  Sayfa: '#HEAD#',
  Fuseaction: '#FULL_FUSEACTION#',
  FilePath: '#FILE_PATH#',
  Module: '#MODULE#',
  Family: '#FAMILY#',
  Author: '#AUTHOR#'
},</cfoutput> ];

</script>
    <script>
      $(() => {
  const dataGrid = $('#gridContainer').dxDataGrid({
    dataSource: customers,
    keyExpr: 'ID',
    allowColumnReordering: true,
    showBorders: true,
    grouping: {
      autoExpandAll: true,
    },
    searchPanel: {
      visible: true,
    },
    paging: {
      pageSize: 10,
    },
    groupPanel: {
      visible: true,
    },
    columns: [
      'Sayfa',
      'Fuseaction',
      'FilePath',
      'Module',
      'Family',
      'Author'
    ],
  }).dxDataGrid('instance');

  $('#autoExpand').dxCheckBox({
    value: true,
    text: 'Expand All Groups',
    onValueChanged(data) {
      dataGrid.option('grouping.autoExpandAll', data.value);
    },
  });
});

    </script>

-------------->




<cf_box title="Sayfa Listesi">
    <div class="form-group">
        <input type="text" id="Search" name="Search" placeholder="Search">
    </div>1
<cf_grid_list id="tblPages">
    <thead>
        <tr>
            <th>##</th>
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
            <th>AUTHOR</th>
            <th></th>
            <th>Satır Sayısı</th>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="getPages">
        <tr>
            <td>#currentrow#</td>
            <td>
                #HEAD#
            </td>
            <td>
               <a href="/index.cfm?fuseaction=#FULL_FUSEACTION#" target="_blank">#FULL_FUSEACTION#</a>
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
          <td>#AUTHOR#</td>
            <td>
                <a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=#FULL_FUSEACTION#&woid=#WRK_OBJECTS_ID#" target="_blank">Güncelle</a>
            </td>
            <td>
              <cfset cp="#ExpandPath(".")#/#FILE_PATH#">
              <cfset cp="#replace(cp,'//','/',"all")#">
              <cfset cp="#replace(cp,'\','/',"all")#">
              
              <cfset linecount=0>
              <cfset cp=0>
              <cftry>
              <cfset myfile = FileRead("#ExpandPath(".")#/#FILE_PATH#")>   
               
              <cfset linecount = ListLen(myfile,chr(10),true)>
              <cfcatch></cfcatch>
              </cftry>
              <cfdump var="#linecount#">
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