<cfexecute name = "C:\PBS\gite.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>



<cf_box title="Gİt">
<cfoutput>
 <cfset st=left(local.out,findNoCase("it_is_runing", local.out))>
<cfset git =findNoCase("pull",st)>
<cfset stlen =len(st)>
<cfset stgit=stlen-git >
<div class="alert alert-success">
<code>Git Durumu</code>
<code>#mid(st,git,stgit-15)#</code>
</div>
</cfoutput>

</cf_box>