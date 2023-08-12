<cfquery name="del_cat_images" datasource="#dsn1#">
    DELETE FROM PRODUCTCAT_IMAGES WHERE  PRODUCTCAT_IMAGEID=#attributes.image_id#
</cfquery>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>