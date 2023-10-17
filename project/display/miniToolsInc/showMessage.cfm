<cfparam name="attributes.AlertType" default="primary">
<cfparam name="attributes.Message" default="Kayıt Ediliyor ...">
<span style="border-radius: 10px;background-color:white;padding: 5px 10px 15px 10px;" id="scrollList">
    <div class="alert alert-<cfoutput>#attributes.AlertType#</cfoutput>">
        <cfoutput>#attributes.Message#</cfoutput>
    </div>
</span>