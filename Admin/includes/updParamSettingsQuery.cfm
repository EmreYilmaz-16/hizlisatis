<cfif attributes.is_del eq 1>
    <cfquery name="up" datasource="#dsn3#">
        DELETE FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS WHERE ID=#attributes.ID#
    </cfquery>
     <script>
        window.location.href='/index.cfm?fuseaction=settings.emptypopup_product_cat_param_settings&ev=list';
    </script>
    <cfabort>
</cfif>

<cfquery name="up" datasource="#dsn3#">
    DELETE FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS WHERE ID=#attributes.ID#
</cfquery>

<cfdump var="#attributes#">

<cfquery name="getA" datasource="#DSN#">
    select * from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_CAT_PRODUCT_PARAM_SETTINGS' AND COLUMN_NAME <> 'ID'
</cfquery>
<cfset ix=1>
<cfset iy=1>
<cfquery name="INS" datasource="#DSN3#">
    INSERT INTO PRODUCT_CAT_PRODUCT_PARAM_SETTINGS (
        <cfoutput query="getA">
            #COLUMN_NAME#
            <cfif ix lt getA.recordCount>
                ,
            </cfif>
            <cfset ix=ix+1>
        </cfoutput>
    )
    VALUES (
        <cfoutput query="getA">
            <cfif isDefined("attributes.#COLUMN_NAME#") and len(evaluate("attributes.#COLUMN_NAME#"))>
                <cfif DATA_TYPE EQ "nvarchar">
                '#evaluate("attributes.#COLUMN_NAME#")#'
                    <CFELSE>
                #evaluate("attributes.#COLUMN_NAME#")#
            </cfif>
        <cfelse>
            NULL
            </cfif>
            <cfif iy lt getA.recordCount>
                ,
            </cfif>
            <cfset iy=iy+1>
        </cfoutput>
    )
    

</cfquery>

<script>
    window.location.href='/index.cfm?fuseaction=settings.emptypopup_product_cat_param_settings&ev=list';
</script>