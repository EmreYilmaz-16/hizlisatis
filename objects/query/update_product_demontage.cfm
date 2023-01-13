<cfquery name="upd" datasource="#dsn1#">
    UPDATE PRODUCT SET IS_DEMONTAGE=#attributes.IS_DEMONTAGE# WHERE PRODUCT_ID=#attributes.product_id#
</cfquery>

<script>
    this.close();
    window.opener.location.reload();
</script>