<h1>Karma Ürün Eklemedeyim</h1>
<h3><cfoutput>#evaluate('attributes.product_id#i#')#
</cfoutput></h3>
<cfquery name="GETKARMAC" datasource="#dsn3#">
    SELECT * FROM #dsn1#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID=#evaluate('attributes.product_id#i#')#
</cfquery>
<cfloop query="GETKARMAC">
    <cfquery name="INSKARMAC" datasource="#dsn3#">
        <cfset tms="#timeFormat(now(),"hhmmnnl")#">
        <cfset lms="#evaluate('attributes.row_unique_relation_id#i#')#-#tms#">
        EXEC ADD_PBSOFFER_ROW_KARMA_PRODUCTS '#lms#','#evaluate('attributes.row_unique_relation_id#i#')#',#GETKARMAC.PRODUCT_ID#,#GETKARMAC.PRODUCT_AMOUNT#
    </cfquery>
    <cfquery name="GETSKARMA" datasource="#dsn3#">
        SELECT * FROM STOCKS WHERE PRODUCT_ID=#GETKARMAC.PRODUCT_ID#
    </cfquery>
    <cfset PRODUCT_ID_KARMA=GETKARMAC.PRODUCT_ID>
    <cfset STOCK_ID_KARMA=GETSKARMA.STOCK_ID>
    <cfset AMOUNT_KARMA=GETKARMAC.PRODUCT_AMOUNT*evaluate('attributes.amount#i#')>

<cfinclude template="save_virtual_production_orders_karma.cfm">

</cfloop>

