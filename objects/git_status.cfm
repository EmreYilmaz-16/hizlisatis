<cfexecute name = "C:\PBS\git_status.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>



<cf_box title="Git Status">
    <cfset str="#local.out#">

    <cfoutput>
        <cfset sx=findNocase("git",str)>
        <cfset lx=len(mid(str,sx,len(str)))>
        #mid(str,sx,lx-59)#
    </cfoutput>



</cf_box>