<cfquery name="GETKARMAC" datasource="#dsn1#">
    SELECT * FROM KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID=#evaluate('attributes.product_id#i#')#
</cfquery>
<cfloop query="GETKARMAC">
    <cfquery name="INSKARMAC" datasource="#dsn3#">
        
        EXEC ADD_PBSOFFER_ROW_KARMA_PRODUCTS '#evaluate('attributes.row_unique_relation_id#i#')#-#timeFormat(now(),"hhmmnnl")#','#evaluate('attributes.row_unique_relation_id#i#')#',#GETKARMAC.PRODUCT_ID#,#GETKARMAC.PRODUCT_AMOUNT#
    </cfquery>
</cfloop>