<cfexecute name = "D:\PBS\gite.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>

<cfdump var="#local#">