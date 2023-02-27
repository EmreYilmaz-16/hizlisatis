<cfquery name="getCats" datasource="#dsn#">
    SELECT * FROM workcube_metosan.SETUP_MAIN_PROCESS_CAT
</cfquery>
<cf_box title="Yeni Proje" scroll="1" collapsable="1" resize="1" popup_box="1">
    <table>
        <tr>
            <td>
                <div class="form-group">
                    <select name="projectCat" required>
                        <option value="">Ürün Tipi</option>
                        <cfoutput query="getCats">
                            <option value="#MAIN_PROCESS_CAT_ID#">#MAIN_PROCESS_CAT#</option>
                        </cfoutput>
                    </select>
                </div>
            </td>
            <td>
                <div class="form-group">
                <cf_workcube_process is_upd='0'  is_detail='0'>
                </div>
            </td>
        </tr>
    </table>
</cf_box>