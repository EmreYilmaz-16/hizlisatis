<cfcomponent>
   <cffunction name="emirver" access="remote">
        <cfquery name="EMIR" datasource="workcube_metosan_1">
            INSERT INTO FATURA_EMIR_PBS(SVK_ID,EMIR_DATE,IS_FATURA,EMIR_EMP) VALUES (#arguments.SVK_ID#,GETDATE(),0,#arguments.employee_id#)
        </cfquery>
   </cffunction>
</cfcomponent>