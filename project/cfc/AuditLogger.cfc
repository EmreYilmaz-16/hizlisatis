<!--- 
Audit Logger Component for Product Design System
Comprehensive logging and monitoring for user actions and system events
--->

<cfcomponent displayname="AuditLogger" hint="Handles comprehensive audit logging for the product design system">
    
    <cfscript>
        // Initialize component properties
        variables.dsn = application.zeroApp.dsnZero;
        variables.logLevels = {
            INFO: 1,
            WARNING: 2,
            ERROR: 3,
            CRITICAL: 4,
            SECURITY: 5
        };
        
        // Action categories for better organization
        variables.actionCategories = {
            USER_ACTION: "USER_ACTION",
            SYSTEM_EVENT: "SYSTEM_EVENT",
            SECURITY_EVENT: "SECURITY_EVENT",
            DATA_CHANGE: "DATA_CHANGE",
            ERROR_EVENT: "ERROR_EVENT",
            PERFORMANCE: "PERFORMANCE"
        };
    </cfscript>
    
    <!--- Function: Log User Action --->
    <cffunction name="logUserAction" returntype="void" access="public">
        <cfargument name="action" type="string" required="true">
        <cfargument name="details" type="string" required="false" default="">
        <cfargument name="affectedRecords" type="string" required="false" default="">
        <cfargument name="oldValues" type="struct" required="false" default="#structNew()#">
        <cfargument name="newValues" type="struct" required="false" default="#structNew()#">
        <cfargument name="severity" type="string" required="false" default="INFO">
        
        <cfset var logData = {
            category: variables.actionCategories.USER_ACTION,
            action: arguments.action,
            details: arguments.details,
            affectedRecords: arguments.affectedRecords,
            oldValues: serializeJSON(arguments.oldValues),
            newValues: serializeJSON(arguments.newValues),
            severity: arguments.severity,
            userId: structKeyExists(session, "pp") ? session.pp.userid : "SYSTEM",
            userName: structKeyExists(session, "pp") ? session.pp.username : "SYSTEM",
            ipAddress: cgi.remote_addr,
            userAgent: cgi.http_user_agent,
            sessionId: session.sessionid,
            timestamp: now(),
            requestUrl: cgi.script_name & (len(cgi.query_string) ? "?" & cgi.query_string : ""),
            referer: cgi.http_referer
        }>
        
        <cfset writeToDatabase(logData)>
        <cfset writeToFile(logData)>
    </cffunction>
    
    <!--- Function: Log System Event --->
    <cffunction name="logSystemEvent" returntype="void" access="public">
        <cfargument name="event" type="string" required="true">
        <cfargument name="details" type="string" required="false" default="">
        <cfargument name="severity" type="string" required="false" default="INFO">
        <cfargument name="component" type="string" required="false" default="ProductDesign">
        
        <cfset var logData = {
            category: variables.actionCategories.SYSTEM_EVENT,
            action: arguments.event,
            details: arguments.details,
            component: arguments.component,
            severity: arguments.severity,
            userId: "SYSTEM",
            userName: "SYSTEM",
            ipAddress: cgi.remote_addr,
            timestamp: now(),
            memoryUsage: createObject("java", "java.lang.Runtime").getRuntime().totalMemory() - createObject("java", "java.lang.Runtime").getRuntime().freeMemory(),
            requestUrl: cgi.script_name
        }>
        
        <cfset writeToDatabase(logData)>
        <cfset writeToFile(logData)>
    </cffunction>
    
    <!--- Function: Log Performance Metrics --->
    <cffunction name="logPerformance" returntype="void" access="public">
        <cfargument name="operation" type="string" required="true">
        <cfargument name="executionTime" type="numeric" required="true">
        <cfargument name="recordsProcessed" type="numeric" required="false" default="0">
        <cfargument name="queryCount" type="numeric" required="false" default="0">
        <cfargument name="memoryUsage" type="numeric" required="false" default="0">
        
        <cfset var runtime = createObject("java", "java.lang.Runtime").getRuntime()>
        <cfset var currentMemory = runtime.totalMemory() - runtime.freeMemory()>
        
        <cfset var logData = {
            category: variables.actionCategories.PERFORMANCE,
            action: arguments.operation,
            details: "Execution time: #arguments.executionTime#ms, Records: #arguments.recordsProcessed#, Queries: #arguments.queryCount#",
            executionTime: arguments.executionTime,
            recordsProcessed: arguments.recordsProcessed,
            queryCount: arguments.queryCount,
            memoryUsage: arguments.memoryUsage > 0 ? arguments.memoryUsage : currentMemory,
            severity: arguments.executionTime > 5000 ? "WARNING" : "INFO",
            userId: structKeyExists(session, "pp") ? session.pp.userid : "SYSTEM",
            timestamp: now(),
            requestUrl: cgi.script_name
        }>
        
        <cfset writeToDatabase(logData)>
        
        <!--- Alert on slow operations --->
        <cfif arguments.executionTime GT 10000>
            <cfset logSystemEvent("SLOW_OPERATION", "Operation #arguments.operation# took #arguments.executionTime#ms", "WARNING")>
        </cfif>
    </cffunction>
    
    <!--- Function: Log Data Changes --->
    <cffunction name="logDataChange" returntype="void" access="public">
        <cfargument name="tableName" type="string" required="true">
        <cfargument name="recordId" type="string" required="true">
        <cfargument name="operation" type="string" required="true">
        <cfargument name="oldValues" type="struct" required="false" default="#structNew()#">
        <cfargument name="newValues" type="struct" required="false" default="#structNew()#">
        
        <cfset var changedFields = []>
        
        <!--- Identify changed fields --->
        <cfif arguments.operation EQ "UPDATE">
            <cfloop collection="#arguments.newValues#" item="field">
                <cfif structKeyExists(arguments.oldValues, field) AND 
                      arguments.oldValues[field] NEQ arguments.newValues[field]>
                    <cfset arrayAppend(changedFields, field)>
                </cfif>
            </cfloop>
        </cfif>
        
        <cfset var logData = {
            category: variables.actionCategories.DATA_CHANGE,
            action: arguments.operation,
            details: "Table: #arguments.tableName#, Record: #arguments.recordId#" & 
                    (arrayLen(changedFields) > 0 ? ", Changed fields: #arrayToList(changedFields)#" : ""),
            tableName: arguments.tableName,
            recordId: arguments.recordId,
            changedFields: arrayToList(changedFields),
            oldValues: serializeJSON(arguments.oldValues),
            newValues: serializeJSON(arguments.newValues),
            severity: "INFO",
            userId: structKeyExists(session, "pp") ? session.pp.userid : "SYSTEM",
            userName: structKeyExists(session, "pp") ? session.pp.username : "SYSTEM",
            timestamp: now()
        }>
        
        <cfset writeToDatabase(logData)>
    </cffunction>
    
    <!--- Function: Log Error Event --->
    <cffunction name="logError" returntype="void" access="public">
        <cfargument name="errorType" type="string" required="true">
        <cfargument name="errorMessage" type="string" required="true">
        <cfargument name="errorDetail" type="string" required="false" default="">
        <cfargument name="stackTrace" type="string" required="false" default="">
        <cfargument name="component" type="string" required="false" default="">
        <cfargument name="line" type="string" required="false" default="">
        
        <cfset var logData = {
            category: variables.actionCategories.ERROR_EVENT,
            action: "ERROR_" & arguments.errorType,
            details: arguments.errorMessage,
            errorDetail: arguments.errorDetail,
            stackTrace: arguments.stackTrace,
            component: arguments.component,
            line: arguments.line,
            severity: "ERROR",
            userId: structKeyExists(session, "pp") ? session.pp.userid : "SYSTEM",
            timestamp: now(),
            requestUrl: cgi.script_name,
            requestMethod: cgi.request_method,
            formData: structKeyExists(form, "fieldnames") ? serializeJSON(form) : "",
            urlData: serializeJSON(url)
        }>
        
        <cfset writeToDatabase(logData)>
        <cfset writeToFile(logData)>
        
        <!--- Send alert for critical errors --->
        <cfif listFind("DATABASE,SECURITY,SYSTEM", arguments.errorType)>
            <cfset sendAlert(logData)>
        </cfif>
    </cffunction>
    
    <!--- Function: Write to Database --->
    <cffunction name="writeToDatabase" returntype="void" access="private">
        <cfargument name="logData" type="struct" required="true">
        
        <cftry>
            <cfquery datasource="#variables.dsn#">
                INSERT INTO AUDIT_LOGS (
                    LOG_ID, CATEGORY, ACTION, DETAILS, SEVERITY, USER_ID, USER_NAME,
                    IP_ADDRESS, USER_AGENT, SESSION_ID, REQUEST_URL, REFERER,
                    TABLE_NAME, RECORD_ID, OLD_VALUES, NEW_VALUES, CHANGED_FIELDS,
                    ERROR_DETAIL, STACK_TRACE, COMPONENT, ERROR_LINE,
                    EXECUTION_TIME, RECORDS_PROCESSED, QUERY_COUNT, MEMORY_USAGE,
                    LOG_DATE, CREATED_DATE
                ) VALUES (
                    <cfqueryparam value="#createUUID()#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.logData.category#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.logData.action#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#left(arguments.logData.details, 4000)#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.logData.severity#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.logData.userId#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'userName') ? arguments.logData.userName : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'ipAddress') ? arguments.logData.ipAddress : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'userAgent') ? left(arguments.logData.userAgent, 500) : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'sessionId') ? arguments.logData.sessionId : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'requestUrl') ? arguments.logData.requestUrl : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'referer') ? arguments.logData.referer : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'tableName') ? arguments.logData.tableName : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'recordId') ? arguments.logData.recordId : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'oldValues') ? arguments.logData.oldValues : ''#" cfsqltype="CF_SQL_LONGVARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'newValues') ? arguments.logData.newValues : ''#" cfsqltype="CF_SQL_LONGVARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'changedFields') ? arguments.logData.changedFields : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'errorDetail') ? left(arguments.logData.errorDetail, 4000) : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'stackTrace') ? arguments.logData.stackTrace : ''#" cfsqltype="CF_SQL_LONGVARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'component') ? arguments.logData.component : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'line') ? arguments.logData.line : ''#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'executionTime') ? arguments.logData.executionTime : 0#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'recordsProcessed') ? arguments.logData.recordsProcessed : 0#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'queryCount') ? arguments.logData.queryCount : 0#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#structKeyExists(arguments.logData, 'memoryUsage') ? arguments.logData.memoryUsage : 0#" cfsqltype="CF_SQL_BIGINT">,
                    <cfqueryparam value="#arguments.logData.timestamp#" cfsqltype="CF_SQL_TIMESTAMP">,
                    <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
                )
            </cfquery>
            
            <cfcatch type="any">
                <!--- Fallback to file logging if database fails --->
                <cfset writeToFile(arguments.logData, "DATABASE_ERROR: " & cfcatch.message)>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Function: Write to File --->
    <cffunction name="writeToFile" returntype="void" access="private">
        <cfargument name="logData" type="struct" required="true">
        <cfargument name="prefix" type="string" required="false" default="">
        
        <cftry>
            <cfset var logFileName = "audit_" & dateFormat(now(), "yyyy-mm-dd") & ".log">
            <cfset var logDirectory = expandPath("/logs/audit/")>
            
            <!--- Create directory if it doesn't exist --->
            <cfif not directoryExists(logDirectory)>
                <cfdirectory action="create" directory="#logDirectory#">
            </cfif>
            
            <cfset var logEntry = "[#dateFormat(arguments.logData.timestamp, 'yyyy-mm-dd')# #timeFormat(arguments.logData.timestamp, 'HH:mm:ss')#] " &
                                 "#arguments.prefix##arguments.logData.severity# - #arguments.logData.category# - " &
                                 "#arguments.logData.action# - User: #arguments.logData.userId# - " &
                                 "IP: #structKeyExists(arguments.logData, 'ipAddress') ? arguments.logData.ipAddress : 'N/A'# - " &
                                 "Details: #arguments.logData.details#" & chr(13) & chr(10)>
            
            <cffile action="append" 
                    file="#logDirectory##logFileName#" 
                    output="#logEntry#" 
                    addnewline="no">
                    
            <cfcatch type="any">
                <!--- Silent fail for file logging to prevent cascading errors --->
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Function: Send Alert --->
    <cffunction name="sendAlert" returntype="void" access="private">
        <cfargument name="logData" type="struct" required="true">
        
        <cftry>
            <!--- Add to application alerts queue --->
            <cfif not structKeyExists(application, "alertQueue")>
                <cfset application.alertQueue = []>
            </cfif>
            
            <cfset var alertData = {
                timestamp: arguments.logData.timestamp,
                severity: arguments.logData.severity,
                category: arguments.logData.category,
                action: arguments.logData.action,
                details: arguments.logData.details,
                userId: arguments.logData.userId,
                ipAddress: structKeyExists(arguments.logData, 'ipAddress') ? arguments.logData.ipAddress : '',
                component: structKeyExists(arguments.logData, 'component') ? arguments.logData.component : ''
            }>
            
            <cfset arrayAppend(application.alertQueue, alertData)>
            
            <!--- Keep queue size manageable --->
            <cfif arrayLen(application.alertQueue) GT 100>
                <cfset arrayDeleteAt(application.alertQueue, 1)>
            </cfif>
            
            <cfcatch type="any">
                <!--- Silent fail --->
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Function: Get Audit History --->
    <cffunction name="getAuditHistory" returntype="query" access="public">
        <cfargument name="userId" type="string" required="false" default="">
        <cfargument name="category" type="string" required="false" default="">
        <cfargument name="startDate" type="date" required="false">
        <cfargument name="endDate" type="date" required="false">
        <cfargument name="limit" type="numeric" required="false" default="100">
        
        <cftry>
            <cfquery name="getHistory" datasource="#variables.dsn#">
                SELECT TOP #arguments.limit#
                    LOG_ID, CATEGORY, ACTION, DETAILS, SEVERITY, USER_ID, USER_NAME,
                    IP_ADDRESS, TABLE_NAME, RECORD_ID, LOG_DATE, CREATED_DATE
                FROM AUDIT_LOGS
                WHERE 1=1
                <cfif len(arguments.userId)>
                    AND USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
                <cfif len(arguments.category)>
                    AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
                <cfif structKeyExists(arguments, "startDate")>
                    AND LOG_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_TIMESTAMP">
                </cfif>
                <cfif structKeyExists(arguments, "endDate")>
                    AND LOG_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_TIMESTAMP">
                </cfif>
                ORDER BY LOG_DATE DESC
            </cfquery>
            
            <cfreturn getHistory>
            
            <cfcatch type="any">
                <cfset logError("QUERY_ERROR", "Error retrieving audit history", cfcatch.message)>
                <cfreturn queryNew("LOG_ID,CATEGORY,ACTION,DETAILS,SEVERITY,USER_ID,LOG_DATE")>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Function: Cleanup Old Logs --->
    <cffunction name="cleanupOldLogs" returntype="void" access="public">
        <cfargument name="daysToKeep" type="numeric" required="false" default="90">
        
        <cftry>
            <cfset var cutoffDate = dateAdd("d", -arguments.daysToKeep, now())>
            
            <cfquery datasource="#variables.dsn#">
                DELETE FROM AUDIT_LOGS
                WHERE LOG_DATE < <cfqueryparam value="#cutoffDate#" cfsqltype="CF_SQL_TIMESTAMP">
                AND SEVERITY NOT IN ('CRITICAL', 'SECURITY')
            </cfquery>
            
            <cfset logSystemEvent("LOG_CLEANUP", "Cleaned up audit logs older than #arguments.daysToKeep# days")>
            
            <cfcatch type="any">
                <cfset logError("LOG_CLEANUP_ERROR", "Error cleaning up old logs", cfcatch.message)>
            </cfcatch>
        </cftry>
    </cffunction>
    
</cfcomponent>