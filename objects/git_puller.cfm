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
<cfset listem=mid(st,git+4,stgit-18)>
<cfloop list="#listem#" item="it" delimiters="|">
<code>#it#</code> <br>
</cfloop>

</div>
</cfoutput>

</cf_box>