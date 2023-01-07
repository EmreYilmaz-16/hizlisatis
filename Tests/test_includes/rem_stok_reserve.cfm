
<cfif len(attributes.wrk_row_id)>
  <cfquery name="getRow" datasource="#dsn3#" RESULT="GETROW_DEL_RESULT">
        DELETE  FROM ORDER_ROW_RESERVED WHERE ORDER_WRK_ROW_ID='#attributes.wrk_row_id#'
    </cfquery>
    <cfif listFind("-9,-10,-3", attributes.OCURRENCY)>
    <cfquery name="updOrd" datasource="#dsn3#">
        UPDATE ORDER_ROW SET ORDER_ROW_CURRENCY=-10 WHERE WRK_ROW_ID='#attributes.wrk_row_id#'
    </cfquery>
    </cfif>
    <cfdump  var="#GETROW_DEL_RESULT#">
    <script>return true</script>
<cfelse>
</cfif>

