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
            select IR.I_ROW_ID,#DSN#.getEmployeeWithId(PREPARE_PERSONAL) AS PREPARE_EMP,PREPARE_PERSONAL,INTERNAL_ID,INTERNAL_NUMBER from workcube_metosan_1.INTERNALDEMAND  AS ID
            LEFT JOIN workcube_metosan_1.INTERNALDEMAND_ROW AS IR ON ID.INTERNAL_ID=IR.I_ID
            WHERE INTERNAL_NUMBER='#attributes.svk_no#'
            ORDER BY INTERNAL_ID DESC
        </cfquery>
        <cf_big_list>
            <cfoutput query="getPrepareData">
                <tr>
                    <td>
                        #PREPARE_EMP#
                    </td>
                    <td>
                        <button type="button" onclick="window.location.href='#request.self#?fuseaction=#attributes.fuseaction#&ev=del&svk_id=#INTERNAL_ID#&employee_id=#PREPARE_PERSONAL#'" class="btn btn-primary">Sil</button>
                    </td>
                </tr>
            </cfoutput>
            <tr></tr>
        </cf_big_list>
    <cfelseif attributes.ev eq "del">
        <cfquery name="delPrep" datasource="#dsn3#">
            UPDATE  INTERNALDEMAND_ROW SET PREPARE_PERSONAL=NULL WHERE I_ID=#attributes.svk_id# AND PREPARE_PERSONAL=#attributes.employee_id#
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