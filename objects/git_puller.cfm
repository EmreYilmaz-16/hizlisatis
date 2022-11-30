<cfexecute name = "C:\PBS\gite.bat"  
timeout = "1000"
variable="local.out"
errorvariable="local.err"> 
</cfexecute>




<cfoutput>
 <cfscript>
 	son_Satir=findNoCase("it_is_runing", local.out);
 	writeDump(son_Satir);
 	writeDump(left(local.out, son_Satir));
 </cfscript>
</cfoutput>


