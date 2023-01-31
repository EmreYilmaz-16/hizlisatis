<cfif IS_TYPE eq 1>
    <cfset bak.rc =0>
    <cfif len(company_id)>
        <cfquery name="get_bakiye" datasource="#dsn2#">
            SELECT        
                BAKIYE3, 
                OTHER_MONEY
            FROM      
                COMPANY_REMAINDER_MONEY
            WHERE        
                COMPANY_ID = #company_id#
        </cfquery>
    <cfelseif len(consumer_id)>
        <cfquery name="get_bakiye" datasource="#dsn2#">
            SELECT        
                BAKIYE3, 
                OTHER_MONEY
            FROM      
                CONSUMER_REMAINDER_MONEY
            WHERE        
                CONSUMER_ID = #consumer_id#
        </cfquery>
    </cfif>
    <cfset bak.rc=get_bakiye.recordCount>
    <cfif bak.rc>
      <cfoutput>
        <cfloop query="get_bakiye">
        <font style="color:<cfif bakiye3 lte 0>blue<cfelse>red</cfif>">
            #TlFormat(BAKIYE3,2)# #OTHER_MONEY# 
           </font><cfif bak.rc gt get_bakiye.currentrow><br/></cfif>
        </cfloop>
    </cfoutput>
    </cfif>

</cfif>