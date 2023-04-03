<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=5">
    <div class="form-group">
        <input type="text" name="svk_no" id="svk_no" value="SVK-14446">
        <input type="hidden" name="is_submit">
    </div>
</cfform>

<cfif isDefined("attributes.is_submit")>
    <cfquery name="getKontrol" datasource="#dsn2#">
      
SELECT 
SF.FIS_NUMBER,
SF.FIS_ID
SF.DEPARTMENT_OUT,
SF.LOCATION_OUT,
SF.FIS_DATE,
SL.COMMENT,
D.DEPARTMENT_HEAD,
workcube_metosan.getEmployeeWithId(SF.RECORD_EMP) AS RECORD_EMP,
SF.RECORD_EMP AS RECORD_EMP_ID 
FROM STOCK_FIS  AS SF
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS  SL ON SL.LOCATION_ID=SF.LOCATION_OUT AND SL.DEPARTMENT_ID=SF.DEPARTMENT_OUT
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SF.DEPARTMENT_OUT
 WHERE SF.REF_NO='#attributes.svk_no#'        
    </cfquery>
    <cf_big_list>
        <thead>
            <th>Hazırlama No</th>
            <th>Hazırlama Tarihi</th>
            <th>Hazırlayan Pers</th>
            <th>Hazırlayan Depo</th>
        </thead>
        <tbody>
        <cfoutput query="getKontrol">
            <tr>
                <td><a href="javascript://" onclick="GetRowData(#FIS_ID#)">#FIS_NUMBER#</a></td>                
                <td>#dateFormat(FIS_DATE,"dd/mm/yyyy")#</td>
                <td>#RECORD_EMP#</td>
                <td>#DEPARTMENT_HEAD# #COMMENT#</td>

            </tr>
        </cfoutput>
    </tbody>
    </cf_big_list>
</cfif>

<script>
    function GetRowData(iid){
        AjaxPageLoad(
    "index.cfm?fuseaction=objects.devextreme_test&page=6&fis_id=" +iid,      
    "resultArea",
    1,
    "Yükleniyor"
  );
    }
</script>

<div id="resultArea" name="resultArea">

</div>

