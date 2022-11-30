<cfexecute name = "C:\PBS\gite.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>




<cfoutput>
 <cfset st=findNoCase("it_is_runing", local.out)>
<cfset git =findNoCase("pull",st)>
<cfset stlen =len(st)>
<cfset stgit=stlen-git >
<h3>Git Durumu</h3>
<h2>#mid(st,git,stgit-15)#</h2>
</cfoutput>


