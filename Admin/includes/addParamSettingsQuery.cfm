﻿<cfdump var="#attributes#">

<cfquery name="getA" datasource="#DSN#">
    select * from INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRODUCT_CAT_PRODUCT_PARAM_SETTINGS' AND COLUMN_NAME <> 'ID'
</cfquery>
<cfset ix=1>
<cfset iy=1>

    INSERT INTO PRODUCT_CAT_PRODUCT_PARAM_SETTINGS (
        <CFLOOP query="getA">
            #COLUMN_NAME#
            <cfif ix lt getA.recordCount>
                ,
            </cfif>
            <cfset ix=ix+1>
        </CFLOOP>
    )
    VALUES (
        <CFLOOP query="getA">
            <cfif isDefined("attributes.COLUMN_NAME") and len(evaluate("attributes.#COLUMN_NAME#"))>
                <cfif DATA_TYPE EQ "nvarchar">
                '#evaluate("attributes.#COLUMN_NAME#")#'
                    <CFELSE>
                #evaluate("attributes.#COLUMN_NAME#")#
            </cfif>
            </cfif>
            <cfif iy lt getA.recordCount>
                ,
            </cfif>
            <cfset iy=iy+1>
        </CFLOOP>
    )
    
