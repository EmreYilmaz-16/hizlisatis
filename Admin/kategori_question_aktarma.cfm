<cfquery name="getCats" datasource="#dsn3#">
    select * from workcube_metosan_product.PRODUCT_CAT WHERE DETAIL IS NOT NULL AND  DETAIL <>'4077' AND DETAIL <>'4078' AND DETAIL <>''
</cfquery>

<cfoutput query="getCats">
    <cfloop list="#getCats.DETAIL#" item="li">
        #getCats.HIERARCHY# -- #li#
        <br>
    </cfloop>
</cfoutput>