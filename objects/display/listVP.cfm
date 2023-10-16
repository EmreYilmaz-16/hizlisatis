<cf_box title="Merhaba" scroll="1" collapsable="1" resize="1" popup_box="1">
    <cfquery name="getCats" datasource="#dsn#">
        SELECT SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT,SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID,PRNUMBER,SHORT_CODE  FROM #dsn#.SETUP_MAIN_PROCESS_CAT 
    INNER JOIN #dsn#.PROJECT_NUMBERS_BY_CAT ON PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID=SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID
    </cfquery>
    <cfquery name="GET_PRIORITY" datasource="#dsn#">
        SELECT
        PRIORITY_ID,PRIORITY
        FROM
            SETUP_PRIORITY
            
        ORDER BY
            PRIORITY_ID
    </cfquery>
<table style="width:100%">
    <input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
    <input type="hidden" name="idb" id="idb" value="<cfoutput>#attributes.idb#</cfoutput>">
    <tr>
        <td>
            <input type="text" class="form-control" id="txtKeyword" name="txtKeyword" placeholder="Ara">
        </td>
        <td>
            <input type="text" class="form-control" id="txtKeywordProject" name="txtKeywordProject"  placeholder="Proje No">
        </td>
        <td>
            <select class="form-control" name="PCAT" id="PCAT" >
                <option value="">Proje Kategorisi</option>
                <cfoutput>
                    <cfloop query="getCats">
                        <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                    </cfloop>
                </cfoutput>
            </select>
        </td>
        <td>
            <button class="form-control btn btn-success" type="button" onclick="SearchWpT()">Ara</button>      
        </td>
    </tr>
</table>

<div id="resultArea">

</div>

</cf_box>