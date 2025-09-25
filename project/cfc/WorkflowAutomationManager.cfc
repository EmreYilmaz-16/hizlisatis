<cfcomponent displayname="WorkflowAutomationManager" hint="Manages workflow automation features for the product design system">
    
    <cffunction name="init" access="public" returntype="WorkflowAutomationManager" hint="Initialize the workflow automation manager">
        <cfset variables.dsn = "workcube_metosan_1">
        <cfset variables.dsn1 = "workcube_1">
        <cfset variables.companyId = session.pp.company_id>
        <cfset variables.userId = session.pp.userid>
        <cfreturn this>
    </cffunction>
    
    <!--- Workflow Rule Management --->
    <cffunction name="createWorkflowRule" access="remote" returnformat="json" hint="Create a new workflow automation rule">
        <cfargument name="ruleName" type="string" required="true">
        <cfargument name="triggerType" type="string" required="true">
        <cfargument name="triggerConditions" type="string" required="true">
        <cfargument name="actionType" type="string" required="true">
        <cfargument name="actionParameters" type="string" required="true">
        <cfargument name="isActive" type="boolean" default="true">
        <cfargument name="priority" type="numeric" default="1">
        
        <cftry>
            <!--- Validate inputs --->
            <cfif len(trim(arguments.ruleName)) eq 0>
                <cfthrow message="Rule name cannot be empty">
            </cfif>
            
            <!--- Validate trigger type --->
            <cfset var validTriggerTypes = "stage_change,cost_threshold,time_based,product_added,product_removed,status_change">
            <cfif not listFindNoCase(validTriggerTypes, arguments.triggerType)>
                <cfthrow message="Invalid trigger type">
            </cfif>
            
            <!--- Validate action type --->
            <cfset var validActionTypes = "send_notification,update_stage,assign_user,create_task,generate_report,send_email">
            <cfif not listFindNoCase(validActionTypes, arguments.actionType)>
                <cfthrow message="Invalid action type">
            </cfif>
            
            <!--- Insert new workflow rule --->
            <cfquery name="insertRule" datasource="#variables.dsn#" result="insertResult">
                INSERT INTO WORKFLOW_AUTOMATION_RULES (
                    RULE_NAME,
                    TRIGGER_TYPE,
                    TRIGGER_CONDITIONS,
                    ACTION_TYPE,
                    ACTION_PARAMETERS,
                    IS_ACTIVE,
                    PRIORITY,
                    CREATED_BY,
                    CREATED_DATE,
                    COMPANY_ID
                ) VALUES (
                    <cfqueryparam value="#arguments.ruleName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.triggerType#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.triggerConditions#" cfsqltype="cf_sql_longvarchar">,
                    <cfqueryparam value="#arguments.actionType#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.actionParameters#" cfsqltype="cf_sql_longvarchar">,
                    <cfqueryparam value="#arguments.isActive#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#arguments.priority#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#variables.userId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
            
            <!--- Log activity --->
            <cfset logWorkflowActivity("rule_created", "New workflow rule created: #arguments.ruleName#", insertResult.generatedkey)>
            
            <cfset var result = {
                "success": true,
                "message": "Workflow rule created successfully",
                "ruleId": insertResult.generatedkey
            }>
            
        <cfcatch type="any">
            <cfset var result = {
                "success": false,
                "message": "Error creating workflow rule: " & cfcatch.message,
                "error": cfcatch.detail
            }>
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <cffunction name="getWorkflowRules" access="remote" returnformat="json" hint="Get all workflow rules for the company">
        <cfargument name="filterActive" type="boolean" default="false">
        
        <cftry>
            <cfquery name="getRules" datasource="#variables.dsn#">
                SELECT 
                    WAR.RULE_ID,
                    WAR.RULE_NAME,
                    WAR.TRIGGER_TYPE,
                    WAR.TRIGGER_CONDITIONS,
                    WAR.ACTION_TYPE,
                    WAR.ACTION_PARAMETERS,
                    WAR.IS_ACTIVE,
                    WAR.PRIORITY,
                    WAR.CREATED_DATE,
                    WAR.LAST_EXECUTED,
                    WAR.EXECUTION_COUNT,
                    WAR.SUCCESS_COUNT,
                    WAR.FAILURE_COUNT,
                    P.PARTNER_NAME AS CREATED_BY_NAME
                FROM WORKFLOW_AUTOMATION_RULES WAR
                LEFT JOIN #variables.dsn1#.PARTNER P ON P.PARTNER_ID = WAR.CREATED_BY
                WHERE WAR.COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                <cfif arguments.filterActive>
                    AND WAR.IS_ACTIVE = 1
                </cfif>
                ORDER BY WAR.PRIORITY ASC, WAR.RULE_NAME ASC
            </cfquery>
            
            <cfset var rules = []>
            <cfloop query="getRules">
                <cfset var rule = {
                    "ruleId": RULE_ID,
                    "ruleName": RULE_NAME,
                    "triggerType": TRIGGER_TYPE,
                    "triggerConditions": TRIGGER_CONDITIONS,
                    "actionType": ACTION_TYPE,
                    "actionParameters": ACTION_PARAMETERS,
                    "isActive": IS_ACTIVE,
                    "priority": PRIORITY,
                    "createdDate": dateFormat(CREATED_DATE, "yyyy-mm-dd") & " " & timeFormat(CREATED_DATE, "HH:mm:ss"),
                    "lastExecuted": isNull(LAST_EXECUTED) ? "" : dateFormat(LAST_EXECUTED, "yyyy-mm-dd") & " " & timeFormat(LAST_EXECUTED, "HH:mm:ss"),
                    "executionCount": EXECUTION_COUNT,
                    "successCount": SUCCESS_COUNT,
                    "failureCount": FAILURE_COUNT,
                    "createdByName": CREATED_BY_NAME
                }>
                <cfset arrayAppend(rules, rule)>
            </cfloop>
            
            <cfset var result = {
                "success": true,
                "rules": rules,
                "totalCount": arrayLen(rules)
            }>
            
        <cfcatch type="any">
            <cfset var result = {
                "success": false,
                "message": "Error retrieving workflow rules: " & cfcatch.message,
                "error": cfcatch.detail
            }>
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <cffunction name="updateWorkflowRule" access="remote" returnformat="json" hint="Update an existing workflow rule">
        <cfargument name="ruleId" type="numeric" required="true">
        <cfargument name="ruleName" type="string" required="true">
        <cfargument name="triggerType" type="string" required="true">
        <cfargument name="triggerConditions" type="string" required="true">
        <cfargument name="actionType" type="string" required="true">
        <cfargument name="actionParameters" type="string" required="true">
        <cfargument name="isActive" type="boolean" required="true">
        <cfargument name="priority" type="numeric" required="true">
        
        <cftry>
            <!--- Verify rule exists and belongs to company --->
            <cfquery name="checkRule" datasource="#variables.dsn#">
                SELECT RULE_ID FROM WORKFLOW_AUTOMATION_RULES
                WHERE RULE_ID = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
                AND COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <cfif checkRule.recordCount eq 0>
                <cfthrow message="Workflow rule not found or access denied">
            </cfif>
            
            <!--- Update rule --->
            <cfquery name="updateRule" datasource="#variables.dsn#">
                UPDATE WORKFLOW_AUTOMATION_RULES SET
                    RULE_NAME = <cfqueryparam value="#arguments.ruleName#" cfsqltype="cf_sql_varchar">,
                    TRIGGER_TYPE = <cfqueryparam value="#arguments.triggerType#" cfsqltype="cf_sql_varchar">,
                    TRIGGER_CONDITIONS = <cfqueryparam value="#arguments.triggerConditions#" cfsqltype="cf_sql_longvarchar">,
                    ACTION_TYPE = <cfqueryparam value="#arguments.actionType#" cfsqltype="cf_sql_varchar">,
                    ACTION_PARAMETERS = <cfqueryparam value="#arguments.actionParameters#" cfsqltype="cf_sql_longvarchar">,
                    IS_ACTIVE = <cfqueryparam value="#arguments.isActive#" cfsqltype="cf_sql_bit">,
                    PRIORITY = <cfqueryparam value="#arguments.priority#" cfsqltype="cf_sql_integer">,
                    UPDATED_BY = <cfqueryparam value="#variables.userId#" cfsqltype="cf_sql_integer">,
                    UPDATED_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
                WHERE RULE_ID = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
                AND COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <!--- Log activity --->
            <cfset logWorkflowActivity("rule_updated", "Workflow rule updated: #arguments.ruleName#", arguments.ruleId)>
            
            <cfset var result = {
                "success": true,
                "message": "Workflow rule updated successfully"
            }>
            
        <cfcatch type="any">
            <cfset var result = {
                "success": false,
                "message": "Error updating workflow rule: " & cfcatch.message,
                "error": cfcatch.detail
            }>
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <cffunction name="deleteWorkflowRule" access="remote" returnformat="json" hint="Delete a workflow rule">
        <cfargument name="ruleId" type="numeric" required="true">
        
        <cftry>
            <!--- Verify rule exists and belongs to company --->
            <cfquery name="checkRule" datasource="#variables.dsn#">
                SELECT RULE_NAME FROM WORKFLOW_AUTOMATION_RULES
                WHERE RULE_ID = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
                AND COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <cfif checkRule.recordCount eq 0>
                <cfthrow message="Workflow rule not found or access denied">
            </cfif>
            
            <!--- Delete rule --->
            <cfquery name="deleteRule" datasource="#variables.dsn#">
                DELETE FROM WORKFLOW_AUTOMATION_RULES
                WHERE RULE_ID = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
                AND COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <!--- Log activity --->
            <cfset logWorkflowActivity("rule_deleted", "Workflow rule deleted: #checkRule.RULE_NAME#", arguments.ruleId)>
            
            <cfset var result = {
                "success": true,
                "message": "Workflow rule deleted successfully"
            }>
            
        <cfcatch type="any">
            <cfset var result = {
                "success": false,
                "message": "Error deleting workflow rule: " & cfcatch.message,
                "error": cfcatch.detail
            }>
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Workflow Execution --->
    <cffunction name="executeWorkflowRules" access="public" returntype="void" hint="Execute workflow rules based on trigger">
        <cfargument name="triggerType" type="string" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        <cfargument name="projectId" type="numeric" default="0">
        <cfargument name="productId" type="numeric" default="0">
        
        <cftry>
            <!--- Get active rules for trigger type --->
            <cfquery name="getActiveRules" datasource="#variables.dsn#">
                SELECT * FROM WORKFLOW_AUTOMATION_RULES
                WHERE TRIGGER_TYPE = <cfqueryparam value="#arguments.triggerType#" cfsqltype="cf_sql_varchar">
                AND IS_ACTIVE = 1
                AND COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                ORDER BY PRIORITY ASC
            </cfquery>
            
            <!--- Execute each matching rule --->
            <cfloop query="getActiveRules">
                <cfset var ruleId = RULE_ID>
                <cfset var triggerConditions = TRIGGER_CONDITIONS>
                <cfset var actionType = ACTION_TYPE>
                <cfset var actionParameters = ACTION_PARAMETERS>
                
                <!--- Check if trigger conditions are met --->
                <cfif evaluateTriggerConditions(triggerConditions, arguments.triggerData)>
                    <!--- Execute the action --->
                    <cfset var actionResult = executeWorkflowAction(actionType, actionParameters, arguments.triggerData, arguments.projectId, arguments.productId)>
                    
                    <!--- Update rule execution statistics --->
                    <cfset updateRuleStats(ruleId, actionResult.success)>
                    
                    <!--- Log execution --->
                    <cfset logWorkflowExecution(ruleId, arguments.triggerType, actionResult.success, actionResult.message)>
                </cfif>
            </cfloop>
            
        <cfcatch type="any">
            <!--- Log error but don't throw to prevent disrupting main flow --->
            <cfset logWorkflowActivity("execution_error", "Workflow execution error: " & cfcatch.message, 0)>
        </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Private Methods --->
    <cffunction name="evaluateTriggerConditions" access="private" returntype="boolean" hint="Evaluate if trigger conditions are met">
        <cfargument name="conditions" type="string" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        
        <cftry>
            <!--- Parse JSON conditions --->
            <cfset var conditionsObj = deserializeJSON(arguments.conditions)>
            
            <!--- Simple condition evaluation logic --->
            <cfif structKeyExists(conditionsObj, "field") and structKeyExists(conditionsObj, "operator") and structKeyExists(conditionsObj, "value")>
                <cfset var fieldValue = structKeyExists(arguments.triggerData, conditionsObj.field) ? arguments.triggerData[conditionsObj.field] : "">
                <cfset var expectedValue = conditionsObj.value>
                <cfset var operator = conditionsObj.operator>
                
                <cfswitch expression="#operator#">
                    <cfcase value="equals">
                        <cfreturn fieldValue eq expectedValue>
                    </cfcase>
                    <cfcase value="not_equals">
                        <cfreturn fieldValue neq expectedValue>
                    </cfcase>
                    <cfcase value="greater_than">
                        <cfreturn val(fieldValue) gt val(expectedValue)>
                    </cfcase>
                    <cfcase value="less_than">
                        <cfreturn val(fieldValue) lt val(expectedValue)>
                    </cfcase>
                    <cfcase value="contains">
                        <cfreturn findNoCase(expectedValue, fieldValue) gt 0>
                    </cfcase>
                    <cfdefaultcase>
                        <cfreturn false>
                    </cfdefaultcase>
                </cfswitch>
            </cfif>
            
            <cfreturn true> <!--- Default to true if no conditions specified --->
            
        <cfcatch type="any">
            <cfreturn false>
        </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="executeWorkflowAction" access="private" returntype="struct" hint="Execute a workflow action">
        <cfargument name="actionType" type="string" required="true">
        <cfargument name="actionParameters" type="string" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        <cfargument name="productId" type="numeric" required="true">
        
        <cftry>
            <cfset var parameters = deserializeJSON(arguments.actionParameters)>
            <cfset var result = {success: false, message: "Unknown action type"}>
            
            <cfswitch expression="#arguments.actionType#">
                <cfcase value="send_notification">
                    <cfset result = sendNotification(parameters, arguments.triggerData, arguments.projectId)>
                </cfcase>
                <cfcase value="update_stage">
                    <cfset result = updateProductStage(parameters, arguments.projectId, arguments.productId)>
                </cfcase>
                <cfcase value="assign_user">
                    <cfset result = assignUserToProject(parameters, arguments.projectId)>
                </cfcase>
                <cfcase value="create_task">
                    <cfset result = createAutomatedTask(parameters, arguments.triggerData, arguments.projectId)>
                </cfcase>
                <cfcase value="generate_report">
                    <cfset result = generateAutomatedReport(parameters, arguments.projectId)>
                </cfcase>
                <cfcase value="send_email">
                    <cfset result = sendAutomatedEmail(parameters, arguments.triggerData, arguments.projectId)>
                </cfcase>
            </cfswitch>
            
            <cfreturn result>
            
        <cfcatch type="any">
            <cfreturn {success: false, message: "Action execution failed: " & cfcatch.message}>
        </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="sendNotification" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        
        <!--- Implement notification sending logic --->
        <cfreturn {success: true, message: "Notification sent"}>
    </cffunction>
    
    <cffunction name="updateProductStage" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        <cfargument name="productId" type="numeric" required="true">
        
        <!--- Implement stage update logic --->
        <cfreturn {success: true, message: "Stage updated"}>
    </cffunction>
    
    <cffunction name="assignUserToProject" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        
        <!--- Implement user assignment logic --->
        <cfreturn {success: true, message: "User assigned"}>
    </cffunction>
    
    <cffunction name="createAutomatedTask" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        
        <!--- Implement task creation logic --->
        <cfreturn {success: true, message: "Task created"}>
    </cffunction>
    
    <cffunction name="generateAutomatedReport" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        
        <!--- Implement report generation logic --->
        <cfreturn {success: true, message: "Report generated"}>
    </cffunction>
    
    <cffunction name="sendAutomatedEmail" access="private" returntype="struct">
        <cfargument name="parameters" type="struct" required="true">
        <cfargument name="triggerData" type="struct" required="true">
        <cfargument name="projectId" type="numeric" required="true">
        
        <!--- Implement email sending logic --->
        <cfreturn {success: true, message: "Email sent"}>
    </cffunction>
    
    <cffunction name="updateRuleStats" access="private" returntype="void">
        <cfargument name="ruleId" type="numeric" required="true">
        <cfargument name="success" type="boolean" required="true">
        
        <cfquery name="updateStats" datasource="#variables.dsn#">
            UPDATE WORKFLOW_AUTOMATION_RULES SET
                EXECUTION_COUNT = EXECUTION_COUNT + 1,
                <cfif arguments.success>
                SUCCESS_COUNT = SUCCESS_COUNT + 1,
                </cfif>
                <cfif not arguments.success>
                FAILURE_COUNT = FAILURE_COUNT + 1,
                </cfif>
                LAST_EXECUTED = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
            WHERE RULE_ID = <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>
    
    <cffunction name="logWorkflowActivity" access="private" returntype="void">
        <cfargument name="activityType" type="string" required="true">
        <cfargument name="description" type="string" required="true">
        <cfargument name="ruleId" type="numeric" required="true">
        
        <cftry>
            <cfquery name="logActivity" datasource="#variables.dsn#">
                INSERT INTO WORKFLOW_ACTIVITY_LOG (
                    RULE_ID,
                    ACTIVITY_TYPE,
                    DESCRIPTION,
                    CREATED_BY,
                    CREATED_DATE,
                    COMPANY_ID
                ) VALUES (
                    <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.activityType#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#variables.userId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
        <cfcatch>
            <!--- Silently handle logging errors --->
        </cfcatch>
        </cftry>
    </cffunction>
    
    <cffunction name="logWorkflowExecution" access="private" returntype="void">
        <cfargument name="ruleId" type="numeric" required="true">
        <cfargument name="triggerType" type="string" required="true">
        <cfargument name="success" type="boolean" required="true">
        <cfargument name="message" type="string" required="true">
        
        <cftry>
            <cfquery name="logExecution" datasource="#variables.dsn#">
                INSERT INTO WORKFLOW_EXECUTION_LOG (
                    RULE_ID,
                    TRIGGER_TYPE,
                    EXECUTION_RESULT,
                    RESULT_MESSAGE,
                    EXECUTED_DATE,
                    EXECUTED_BY,
                    COMPANY_ID
                ) VALUES (
                    <cfqueryparam value="#arguments.ruleId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.triggerType#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.success#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#arguments.message#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                    <cfqueryparam value="#variables.userId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
        <cfcatch>
            <!--- Silently handle logging errors --->
        </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Workflow Statistics and Monitoring --->
    <cffunction name="getWorkflowStats" access="remote" returnformat="json" hint="Get workflow automation statistics">
        <cfargument name="dateFrom" type="string" default="">
        <cfargument name="dateTo" type="string" default="">
        
        <cftry>
            <!--- Set default date range if not provided --->
            <cfif len(arguments.dateFrom) eq 0>
                <cfset arguments.dateFrom = dateFormat(dateAdd("d", -30, now()), "yyyy-mm-dd")>
            </cfif>
            <cfif len(arguments.dateTo) eq 0>
                <cfset arguments.dateTo = dateFormat(now(), "yyyy-mm-dd")>
            </cfif>
            
            <!--- Get rule execution statistics --->
            <cfquery name="getStats" datasource="#variables.dsn#">
                SELECT 
                    COUNT(*) as TOTAL_RULES,
                    SUM(CASE WHEN IS_ACTIVE = 1 THEN 1 ELSE 0 END) as ACTIVE_RULES,
                    SUM(EXECUTION_COUNT) as TOTAL_EXECUTIONS,
                    SUM(SUCCESS_COUNT) as TOTAL_SUCCESS,
                    SUM(FAILURE_COUNT) as TOTAL_FAILURES
                FROM WORKFLOW_AUTOMATION_RULES
                WHERE COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
            </cfquery>
            
            <!--- Get recent execution statistics --->
            <cfquery name="getRecentStats" datasource="#variables.dsn#">
                SELECT 
                    COUNT(*) as RECENT_EXECUTIONS,
                    SUM(CASE WHEN EXECUTION_RESULT = 1 THEN 1 ELSE 0 END) as RECENT_SUCCESS,
                    SUM(CASE WHEN EXECUTION_RESULT = 0 THEN 1 ELSE 0 END) as RECENT_FAILURES
                FROM WORKFLOW_EXECUTION_LOG
                WHERE COMPANY_ID = <cfqueryparam value="#variables.companyId#" cfsqltype="cf_sql_integer">
                AND EXECUTED_DATE >= <cfqueryparam value="#arguments.dateFrom#" cfsqltype="cf_sql_date">
                AND EXECUTED_DATE <= <cfqueryparam value="#arguments.dateTo# 23:59:59" cfsqltype="cf_sql_timestamp">
            </cfquery>
            
            <!--- Calculate success rate --->
            <cfset var totalExecutions = val(getStats.TOTAL_EXECUTIONS)>
            <cfset var successRate = totalExecutions gt 0 ? round((val(getStats.TOTAL_SUCCESS) / totalExecutions) * 100) : 0>
            
            <cfset var recentExecutions = val(getRecentStats.RECENT_EXECUTIONS)>
            <cfset var recentSuccessRate = recentExecutions gt 0 ? round((val(getRecentStats.RECENT_SUCCESS) / recentExecutions) * 100) : 0>
            
            <cfset var result = {
                "success": true,
                "stats": {
                    "totalRules": getStats.TOTAL_RULES,
                    "activeRules": getStats.ACTIVE_RULES,
                    "totalExecutions": getStats.TOTAL_EXECUTIONS,
                    "totalSuccess": getStats.TOTAL_SUCCESS,
                    "totalFailures": getStats.TOTAL_FAILURES,
                    "successRate": successRate,
                    "recentExecutions": getRecentStats.RECENT_EXECUTIONS,
                    "recentSuccess": getRecentStats.RECENT_SUCCESS,
                    "recentFailures": getRecentStats.RECENT_FAILURES,
                    "recentSuccessRate": recentSuccessRate,
                    "dateFrom": arguments.dateFrom,
                    "dateTo": arguments.dateTo
                }
            }>
            
        <cfcatch type="any">
            <cfset var result = {
                "success": false,
                "message": "Error retrieving workflow statistics: " & cfcatch.message,
                "error": cfcatch.detail
            }>
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
</cfcomponent>