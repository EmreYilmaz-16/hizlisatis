<!--- 
Enhanced Security Include for Product Design System
Session validation, CSRF protection, and access control
--->

<cfscript>
// Security Configuration
securityConfig = {
    sessionTimeout: 30, // minutes
    maxLoginAttempts: 5,
    lockoutDuration: 15, // minutes
    requiredPermissions: ["PRODUCT_DESIGN_ACCESS"],
    csrfTokenName: "csrf_token",
    secureHeaders: true
};

// Initialize security logging
if (!structKeyExists(application, "securityLog")) {
    application.securityLog = [];
}
</cfscript>

<!--- Function: Validate User Session --->
<cffunction name="validateUserSession" returntype="boolean" access="public">
    <cfargument name="requiredPermissions" type="array" default="#securityConfig.requiredPermissions#">
    
    <cftry>
        <!--- Check if user is logged in --->
        <cfif !structKeyExists(session, "ep") OR !structKeyExists(session.ep, "userid") OR !len(session.ep.userid)>
            <cfreturn false>
        </cfif>
        
        <!--- Check session timeout --->
        <cfif structKeyExists(session, "lastActivity")>
            <cfset minutesSinceActivity = dateDiff("n", session.lastActivity, now())>
            <cfif minutesSinceActivity GT securityConfig.sessionTimeout>
                <cfset structClear(session)>
                <cfreturn false>
            </cfif>
        </cfif>
        
        <!--- Update last activity --->
        <cfset session.lastActivity = now()>
        
        <!--- Check user permissions --->
        <cfloop array="#arguments.requiredPermissions#" index="permission">
            <cfif !checkUserPermission(permission)>
                <cfset logSecurityEvent("ACCESS_DENIED", "User #session.pp.userid# attempted to access without #permission# permission")>
                <cfreturn false>
            </cfif>
        </cfloop>
        
        <!--- Generate new CSRF token if needed --->
        <cfif !structKeyExists(session, "csrfToken") OR !structKeyExists(session, "csrfTokenExpiry") OR 
              dateCompare(now(), session.csrfTokenExpiry) GTE 0>
            <cfset generateCSRFToken()>
        </cfif>
        
        <cfreturn true>
        
        <cfcatch type="any">
            <cfset logSecurityEvent("SESSION_VALIDATION_ERROR", "Error validating session: #cfcatch.message#")>
            <cfreturn false>
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Check User Permission --->
<cffunction name="checkUserPermission" returntype="boolean" access="private">
    <cfargument name="permission" type="string" required="true">
    
    <cftry>
        <!--- Query user permissions --->
        <cfquery name="getUserPermissions" datasource="#dsn#">
            SELECT COUNT(*) as permission_count
            FROM EMPLOYEE_POSITION_ROW_PRT EPR
            INNER JOIN EMPLOYEE_POSITION_ROW_USERTYPE_PRT EPRUT ON EPR.EMPLOYEE_POSITION_ROW_ID = EPRUT.EMPLOYEE_POSITION_ROW_ID
            INNER JOIN FUSEACTION FU ON EPRUT.FUSEACTION_ID = FU.FUSEACTION_ID
            WHERE EPR.EMPLOYEE_ID = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_INTEGER">
            AND FU.FUSEACTION = <cfqueryparam value="#arguments.permission#" cfsqltype="CF_SQL_VARCHAR">
            AND EPR.IS_ACTIVE = 1
        </cfquery>
        
        <cfreturn getUserPermissions.permission_count GT 0>
        
        <cfcatch type="any">
            <cfset logSecurityEvent("PERMISSION_CHECK_ERROR", "Error checking permission #arguments.permission# for user #session.pp.userid#: #cfcatch.message#")>
            <cfreturn false>
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Generate CSRF Token --->
<cffunction name="generateCSRFToken" returntype="string" access="public">
    <cftry>
        <cfset csrfToken = hash(createUUID() & now() & session.sessionid & cgi.remote_addr, "SHA-256")>
        <cfset session.csrfToken = csrfToken>
        <cfset session.csrfTokenExpiry = dateAdd("n", 30, now())>
        <cfreturn csrfToken>
        
        <cfcatch type="any">
            <cfset logSecurityEvent("CSRF_TOKEN_ERROR", "Error generating CSRF token: #cfcatch.message#")>
            <cfreturn "">
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Validate CSRF Token --->
<cffunction name="validateCSRFToken" returntype="boolean" access="public">
    <cfargument name="token" type="string" required="true">
    
    <cftry>
        <!--- Check if session has CSRF token --->
        <cfif !structKeyExists(session, "csrfToken") OR !structKeyExists(session, "csrfTokenExpiry")>
            <cfreturn false>
        </cfif>
        
        <!--- Check token expiry --->
        <cfif dateCompare(now(), session.csrfTokenExpiry) GT 0>
            <cfset structDelete(session, "csrfToken")>
            <cfset structDelete(session, "csrfTokenExpiry")>
            <cfreturn false>
        </cfif>
        
        <!--- Validate token --->
        <cfreturn session.csrfToken EQ arguments.token>
        
        <cfcatch type="any">
            <cfset logSecurityEvent("CSRF_VALIDATION_ERROR", "Error validating CSRF token: #cfcatch.message#")>
            <cfreturn false>
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Rate Limiting --->
<cffunction name="checkRateLimit" returntype="boolean" access="public">
    <cfargument name="identifier" type="string" default="#session.sessionid#">
    <cfargument name="maxAttempts" type="numeric" default="50">
    <cfargument name="timeWindow" type="numeric" default="5"> <!--- minutes --->
    
    <cftry>
        <cfset rateLimitKey = "rateLimit_" & arguments.identifier>
        
        <!--- Initialize application scope for rate limiting if not exists --->
        <cfif !structKeyExists(application, "rateLimits")>
            <cfset application.rateLimits = {}>
        </cfif>
        
        <cfset currentTime = now()>
        
        <!--- Clean up old entries --->
        <cfloop collection="#application.rateLimits#" item="key">
            <cfif structKeyExists(application.rateLimits[key], "lastReset") AND 
                  dateDiff("n", application.rateLimits[key].lastReset, currentTime) GT arguments.timeWindow>
                <cfset structDelete(application.rateLimits, key)>
            </cfif>
        </cfloop>
        
        <!--- Initialize rate limit for this identifier --->
        <cfif !structKeyExists(application.rateLimits, rateLimitKey)>
            <cfset application.rateLimits[rateLimitKey] = {
                attempts: 1,
                lastReset: currentTime
            }>
            <cfreturn true>
        </cfif>
        
        <cfset rateLimitData = application.rateLimits[rateLimitKey]>
        
        <!--- Reset if time window has passed --->
        <cfif dateDiff("n", rateLimitData.lastReset, currentTime) GT arguments.timeWindow>
            <cfset rateLimitData.attempts = 1>
            <cfset rateLimitData.lastReset = currentTime>
            <cfreturn true>
        </cfif>
        
        <!--- Check if rate limit exceeded --->
        <cfif rateLimitData.attempts GTE arguments.maxAttempts>
            <cfset logSecurityEvent("RATE_LIMIT_EXCEEDED", "Rate limit exceeded for identifier: #arguments.identifier#")>
            <cfreturn false>
        </cfif>
        
        <!--- Increment attempts --->
        <cfset rateLimitData.attempts++>
        <cfreturn true>
        
        <cfcatch type="any">
            <cfset logSecurityEvent("RATE_LIMIT_ERROR", "Error checking rate limit: #cfcatch.message#")>
            <cfreturn true> <!--- Allow request on error to prevent DoS --->
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Log Security Events --->
<cffunction name="logSecurityEvent" returntype="void" access="public">
    <cfargument name="eventType" type="string" required="true">
    <cfargument name="eventDetails" type="string" required="true">
    
    <cftry>
        <cfset securityEvent = {
            timestamp: now(),
            eventType: arguments.eventType,
            eventDetails: arguments.eventDetails,
            ipAddress: cgi.remote_addr,
            userAgent: cgi.http_user_agent,
            userId: structKeyExists(session, "pp") ? session.pp.userid : "ANONYMOUS",
            sessionId: session.sessionid,
            referer: cgi.http_referer
        }>
        
        <!--- Add to application log --->
        <cfif arrayLen(application.securityLog) GT 1000>
            <cfset arrayDeleteAt(application.securityLog, 1)> <!--- Keep only last 1000 entries --->
        </cfif>
        <cfset arrayAppend(application.securityLog, securityEvent)>
        
        <!--- Write to file log --->
        <cflog file="security" 
               text="[#arguments.eventType#] #arguments.eventDetails# - IP: #cgi.remote_addr# - User: #securityEvent.userId#"
               type="warning">
               
        <!--- Store in database for critical events --->
        <cfif listFind("ACCESS_DENIED,RATE_LIMIT_EXCEEDED,SQL_INJECTION_ATTEMPT,XSS_ATTEMPT", arguments.eventType)>
            <cfquery datasource="#dsn#">
                INSERT INTO SECURITY_EVENTS (
                    EVENT_TYPE, EVENT_DETAILS, IP_ADDRESS, USER_ID, SESSION_ID, 
                    USER_AGENT, REFERER, EVENT_DATE
                ) VALUES (
                    <cfqueryparam value="#arguments.eventType#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.eventDetails#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#cgi.remote_addr#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#securityEvent.userId#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#session.sessionid#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#cgi.http_user_agent#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#cgi.http_referer#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">
                )
            </cfquery>
        </cfif>
        
        <cfcatch type="any">
            <!--- Silent fail to prevent infinite loops --->
            <cflog file="security_logging_errors" 
                   text="Error logging security event: #cfcatch.message#"
                   type="error">
        </cfcatch>
    </cftry>
</cffunction>

<!--- Function: Set Security Headers --->
<cffunction name="setSecurityHeaders" returntype="void" access="public">
    <cfif securityConfig.secureHeaders>
        <cfheader name="X-Frame-Options" value="DENY">
        <cfheader name="X-Content-Type-Options" value="nosniff">
        <cfheader name="X-XSS-Protection" value="1; mode=block">
        <cfheader name="Referrer-Policy" value="strict-origin-when-cross-origin">
        <!--- 
        Secure CSP without unsafe-eval - all eval() usage has been eliminated
        Added connect-src for AJAX requests and report-uri for CSP violations
        --->
        <cfheader name="Content-Security-Policy" value="default-src 'self'; script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src 'self' data: https:; font-src 'self' https://cdnjs.cloudflare.com; connect-src 'self' https:; report-uri /AddOns/Partner/project/cfc/security_csp_report.cfm;">
        <cfheader name="Cache-Control" value="no-store, no-cache, must-revalidate, private">
        <cfheader name="Pragma" value="no-cache">
    </cfif>
</cffunction>

<!--- Function: Validate Request Method --->
<cffunction name="validateRequestMethod" returntype="boolean" access="public">
    <cfargument name="allowedMethods" type="string" default="GET,POST">
    
    <cfset requestMethod = uCase(cgi.request_method)>
    <cfreturn listFind(arguments.allowedMethods, requestMethod) GT 0>
</cffunction>

<!--- Function: IP Whitelist Check (if configured) --->
<cffunction name="checkIPWhitelist" returntype="boolean" access="public">
    <cfargument name="whitelist" type="string" default="">
    
    <cfif !len(arguments.whitelist)>
        <cfreturn true>
    </cfif>
    
    <cfset clientIP = cgi.remote_addr>
    <cfreturn listFind(arguments.whitelist, clientIP) GT 0>
</cffunction>

<!--- Main Security Check --->
<cfif NOT validateUserSession()>
    <cfset logSecurityEvent("UNAUTHORIZED_ACCESS", "Unauthorized access attempt to product design")>
    <cfheader statuscode="401" statustext="Unauthorized">
    <cfoutput>
        <script>
            alert('Oturum süreniz dolmuş veya yetkisiz erişim. Lütfen tekrar giriş yapın.');
            //window.location.href = '/admin/index.cfm';
        </script>
    </cfoutput>
    
</cfif>

<!--- Rate Limiting Check --->
<cfif NOT checkRateLimit(session.sessionid, 100, 5)>
    <cfheader statuscode="429" statustext="Too Many Requests">
    <cfoutput>
        <script>
            alert('Çok fazla istek gönderiyorsunuz. Lütfen 5 dakika bekleyiniz.');
        </script>
    </cfoutput>
    <cfabort>
</cfif>

<!--- Set Security Headers --->
<cfset setSecurityHeaders()>

<!--- Validate Request Method for specific operations --->
<cfif structKeyExists(url, "method") AND NOT validateRequestMethod("POST")>
    <cfset logSecurityEvent("INVALID_REQUEST_METHOD", "Invalid request method #cgi.request_method# for method #url.method#")>
    <cfheader statuscode="405" statustext="Method Not Allowed">
    <cfabort>
</cfif>

<!--- CSRF Token for forms --->
<cfset currentCSRFToken = structKeyExists(session, "csrfToken") ? session.csrfToken : generateCSRFToken()>

<!--- Make CSRF token available to JavaScript --->
<cfoutput>
<script>
    window.CSRF_TOKEN = '#currentCSRFToken#';
    window.SESSION_TIMEOUT = #securityConfig.sessionTimeout#;
    window.USER_ID = '#session.ep.userid#';
</script>
</cfoutput>