<cfscript>
// CSP Violation Report Handler
// This file handles Content Security Policy violation reports

// Set content type for CSP reports
cfheader(name="Content-Type", value="application/json");

try {
    // Get the raw POST data (CSP reports are sent as JSON)
    rawData = toString(getHttpRequestData().content);
    
    if (len(trim(rawData))) {
        // Parse the CSP violation report
        reportData = deserializeJSON(rawData);
        
        // Extract violation details
        if (structKeyExists(reportData, "csp-report")) {
            violation = reportData["csp-report"];
            
            // Log the violation
            logEntry = {
                "timestamp": dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "HH:mm:ss"),
                "document_uri": structKeyExists(violation, "document-uri") ? violation["document-uri"] : "",
                "violated_directive": structKeyExists(violation, "violated-directive") ? violation["violated-directive"] : "",
                "blocked_uri": structKeyExists(violation, "blocked-uri") ? violation["blocked-uri"] : "",
                "source_file": structKeyExists(violation, "source-file") ? violation["source-file"] : "",
                "line_number": structKeyExists(violation, "line-number") ? violation["line-number"] : "",
                "original_policy": structKeyExists(violation, "original-policy") ? violation["original-policy"] : "",
                "user_agent": cgi.http_user_agent,
                "ip_address": cgi.remote_addr
            };
            
            // Write to application log
            if (!structKeyExists(application, "cspViolations")) {
                application.cspViolations = [];
            }
            
            arrayAppend(application.cspViolations, logEntry);
            
            // Keep only last 100 violations to prevent memory issues
            if (arrayLen(application.cspViolations) > 100) {
                arrayDeleteAt(application.cspViolations, 1);
            }
            
            // Log to system log as well
            writeLog(
                text="CSP Violation: " & violation["violated-directive"] & " - " & violation["blocked-uri"],
                type="Warning",
                file="security"
            );
            
            // For development/debugging, you might also want to log to console
            // writeOutput("CSP Violation logged: " & violation["violated-directive"]);
        }
    }
    
    // Return success status
    cfheader(statuscode="200", statustext="OK");
    writeOutput('{"status": "received"}');
    
} catch (any e) {
    // Log error but don't expose details
    writeLog(
        text="CSP report handler error: " & e.message,
        type="Error", 
        file="security"
    );
    
    cfheader(statuscode="400", statustext="Bad Request");
    writeOutput('{"status": "error"}');
}
</cfscript>