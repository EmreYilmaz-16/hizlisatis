<cf_box title="Hazırlama Personeli Kaldırma">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&ev=search">
        <table>
            <tr>
                <td>
                    SVK No
                </td>
                <td>
                    <div class="form-group">
                        <input type="text" name="svk_no" id="svk_no">
                    </div>
                </td>
                <td>
                    <input type="submit">
                </td>
            </tr>
        </table>
    </cfform>
</cf_box>
<cfif isDefined("attributes.ev")>
    <cfif attributes.ev eq "search">
        <cfquery name="getPrepareData" datasource="#dsn3#">
            SELECT DISTINCT workcube_metosan.getEmployeeWithId(PSRR.PREPARE_PERSONAL)AS PREPARE_EMP ,PSRR.SHIP_RESULT_ID,PSRR.PREPARE_PERSONAL  FROM workcube_metosan_1.PRTOTM_SHIP_RESULT AS PSR 
            LEFT JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS PSRR ON PSR.SHIP_RESULT_ID=PSRR.SHIP_RESULT_ID
            WHERE PSR.DELIVER_PAPER_NO='#attributes.svk_no#'
        </cfquery>
        <cf_big_list>
            <cfoutput query="getPrepareData">
                <tr>
                    <td>
                        #PREPARE_EMP#
                    </td>
                    <td>
                        <button type="button" onclick="window.location.href='#request.self#?fuseaction=#attributes.fuseaction#&ev=del&svk_id=#SHIP_RESULT_ID#&employee_id=#PREPARE_PERSONAL#'" class="btn btn-primary">Sil</button>
                    </td>
                </tr>
            </cfoutput>
            <tr></tr>
        </cf_big_list>
    <cfelseif attributes.ev eq "del">
        <cfquery name="delPrep" datasource="#dsn3#">
            DELETE FROM PRTOTM_SHIP_RESULT_ROW WHERE SHIP_RESULT_ID=#attributes.svk_id# AND PREPARE_PERSONAL=#attributes.employee_id#
        </cfquery>
        <div id="aldiv" class="alert alert-success" >
            Silme Başarılı
        </div>
        <script>
          $(document).ready(function(){
                setTimeout(function (){
                    $("#aldiv").hide(500)
                },1500)
            })
        </script>
    </cfif>
</cfif>