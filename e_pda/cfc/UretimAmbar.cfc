﻿<cfcomponent>
    <cffunction name="saveBelge"  httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfset e=structKeyArray(arguments)>
        <cfdump var="#e#">
        <cfset FormData=deserializeJSON(e[1])>
        <cfdump var="#FormData#">
<cfset attributes=FormData>
        <cfset dsn3=FormData.dsn3>
        <cfset dsn2=FormData.dsn2>
            <cfset attributes.LOCATION_IN=1>
            <cfset attributes.LOCATION_OUT=FormData.LOCATION_ID>
            <cfset attributes.department_out=FormData.STORE_ID>
            <cfset attributes.department_in =45>
            <cfset form.process_cat=84>
            <cfset attributes.process_cat = form.process_cat>
           <cfset PROJECT_HEAD="">
           <cfset PROJECT_HEAD_IN="">
           <cfset PROJECT_ID="">
           <cfset PROJECT_ID_IN="">
           <cfset attributes.QUANTITY=FormData.QUANTITY>
           <cfset attributes.uniq_relation_id_="">
           <cfset amount_other="">
           <cfset unit_other="">
           <cfset lot_no="">
         <cfdump var="#attributes#">
        <cfset attributes.ROWW=" ,">
        <cfdump var="#listLen(attributes.ROWW)#">
        <cfinclude template="StokFisQuery.cfm">
        
    
    </cffunction>
</cfcomponent>