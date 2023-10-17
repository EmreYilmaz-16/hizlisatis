<cf_box scroll="1" collapsable="1" resize="1" popup_box="1">
        <cfdump var="#attributes#">
        <cfset FData=deserializeJSON(attributes.data)>
        <cfdump var="#FData#">
        <button type="button" class="btn btn-outline-success">Fiyat Kaydet</button>
</cf_box>
