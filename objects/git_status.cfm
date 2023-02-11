<cfexecute name = "C:\PBS\git_status.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>



<cf_box title="Git Status">
<cfoutput>
#local.out#
</cfoutput>

</cf_box>