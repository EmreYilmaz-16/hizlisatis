<cfquery name="getsTree" datasource="#dsn3#">
select * from workcube_metosan_1.PRODUCT_TREE   AS PT  WHERE STOCK_ID=60180
</cfquery>
<cfdump var="#getPo#">
<cfdump var="#gets#">