<cfcomponent>
    <cfset dsn=application.systemparam.dsn>
    <cffunction name="saveAlternative"  httpMethod="POST" access="remote" returntype="any" returnFormat="json">
      <cfquery name="getMaxQuestionNo" datasource="#dsn#">
        SELECT MAX(QUESTION_NO) AS MQN FROM SETUP_ALTERNATIVE_QUESTIONS
      </cfquery>
      <CFSET MAXQNO=getMaxQuestionNo.MQN+1>
      <cftry>
      
      <cfquery name="ins1" datasource="#dsn#" result="res">
        INSERT INTO [workcube_metosan].[SETUP_ALTERNATIVE_QUESTIONS]
           ([QUESTION_NO]
           ,[QUESTION_NAME]
           ,[QUESTION_DETAIL]
           ,[RECORD_EMP]
           ,[RECORD_DATE]
           ,[RECORD_IP]                              
           )
     VALUES
           (#MAXQNO#
           ,'#arguments.QUESTION_NAME#'
           ,'#arguments.QUESTION_NAME#'           
           ,1
           ,GETDATE()
           ,'#CGI.REMOTE_ADDR#'
           )
       </cfquery>
       <cfquery name="ins" datasource="#arguments.dsn3#">
            INSERT INTO VIRTUAL_PRODUCT_TREE_QUESTIONS ( QUESTION_ID,QUESTION,IS_REQUIRED,QUESTION_PRODUCT_TYPE)
            VALUES('#res.IDENTITYCOL#','#arguments.QUESTION_NAME#',0,99)
        </cfquery>
        <cfcatch>
            <cfset returndata.status=0>
            <cfset returndata.mesaj='hata oluştu'>
            <cfreturn replace(serializeJSON(returndata),'//','')>
        </cfcatch>
    </cftry>  
    <cfset returndata.status=1>
            <cfset returndata.mesaj='Başarılı'>
            <cfreturn replace(serializeJSON(returndata),'//','')>
    </cffunction>
</cfcomponent>