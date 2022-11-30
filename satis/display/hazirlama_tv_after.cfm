<cfoutput>
<input type="hidden" name="department_id" value="#attributes.department_id#">
<input type="hidden" name="lcoation_id" value="#attributes.location_id#">
<script>
    deparmanData={
        department_id:#attributes.department_id#,
        location_id:#attributes.location_id#,
    };

</script>

</cfoutput>
<audio id="myAudio">
    <source src="/AddOns/Partner/satis/content/ding.mp3" type="audio/mpeg">    
    <source src="/AddOns/Partner/satis/content/ding.ogg" type="audio/ogg">    
    
</audio>

<cfinclude template="../includes/virtual_offer_parameters.cfm">
<cf_box title="Hazırlamalar">
    
       <cf_grid_list id="grdTbl">

       </cf_grid_list> 
</cf_box>

<script src="/AddOns/Partner/satis/js/hazirlama.js"></script>

