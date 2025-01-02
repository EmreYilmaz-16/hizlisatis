<cfquery name="gets" datasource="#dsn#">
    SELECT top 10 * FROM workcube_test.workcube_test_product.PRODUCT
</cfquery>

<cfdump var="#gets#">