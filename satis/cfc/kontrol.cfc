<cfcomponent>
   <cffunction name="emirver" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
    <cfsavecontent  variable="control5">
        <cfdump  var="#CGI#">                
        <cfdump  var="#arguments#">
 
       </cfsavecontent>
       <cffile action="write" file = "c:\PBS\kontrolemirver.html" output="#control5#"></cffile>
   <cfquery name="EMIR" datasource="workcube_metosan_1">
            INSERT INTO FATURA_EMIR_PBS(SVK_ID,EMIR_DATE,IS_FATURA,EMIR_EMP) VALUES (#arguments.SVK_ID#,GETDATE(),0,#arguments.employee_id#)
        </cfquery>
   </cffunction>
</cfcomponent>