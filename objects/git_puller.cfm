<cfexecute name = "C:\PBS\gite.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>

<cfdump var="#local#">


<cfoutput>
 <cfscript>
 	findNoCase("it_is_runing", local.out)
 </cfscript>
</cfoutput>


