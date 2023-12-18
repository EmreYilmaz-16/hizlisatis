<cfparam name="attributes.keyword" default="">
<cf_box title="E-Shipping">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <cfoutput>
        <table>
            <tr>
                <td>
                    <div class="form-group">
                        <input type="text" name="Keyword" id="Keyword" value="#attributes.Keyword#">
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <select name="report_type_id" id="report_type_id" style="width:120px;height:20px">
                            <option value="">Tümü</option>
							<option value="1">Açık Sevkler</option>
                            <option value="2">Kapalı Sevkler</option>
                            <option value="3" selected="">Hazır Sevkler</option>
                            <option value="4">Kısmi Hazır Sevkler</option>
					    </select>
                    </div>
                </td>
            </tr>
        </table>
    </cfoutput>

    </cfform>
</cf_box>