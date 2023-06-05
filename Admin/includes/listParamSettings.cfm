<cfquery name="getList" datasource="#dsn3#" result="RES">
    select PCS.*,PC.PRODUCT_CAT,PC.HIERARCHY from workcube_metosan_1.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS PCS
INNER JOIN workcube_metosan_product.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=PCS.PRODUCT_CATID
</cfquery>

<cfdump var="#RES#">
<cfdump var="#getList#">