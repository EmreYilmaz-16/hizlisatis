/**
 * Security Utilities for Product Design System
 * Comprehensive security validation, sanitization, and protection mechanisms
 */

component accessors="true" {
    
    // Security Configuration
    variables.securityConfig = {
        maxInputLength: 1000,
        allowedCharacters: "^[a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s\-_.,()]+$",
        sqlInjectionPatterns: [
            "(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE)?|INSERT|MERGE|SELECT|UNION|UPDATE)\b)",
            "(\b(SCRIPT|JAVASCRIPT|VBSCRIPT|ONLOAD|ONERROR)\b)",
            "('|(--)|;|(\|)|(\/\*)|\*\/)",
            "((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))",
            "(\bexec\b|\bEXEC\b)",
            "(\bdrop\b|\bDROP\b)"
        ],
        xssPatterns: [
            "<script[^>]*>.*?</script>",
            "javascript:",
            "on\w+\s*=",
            "<iframe[^>]*>.*?</iframe>",
            "<object[^>]*>.*?</object>",
            "<embed[^>]*>.*?</embed>",
            "<applet[^>]*>.*?</applet>"
        ],
        csrfTokenExpiration: 30, // minutes
        maxFailedAttempts: 5,
        lockoutDuration: 15 // minutes
    };
    
    // User session tracking for security
    variables.userSessions = {};
    
    /**
     * Initialize security component
     */
    public function init() {
        setupCSRFProtection();
        initializeSecurityLogging();
        return this;
    }
    
    /**
     * Validate and sanitize all inputs
     * @param inputValue The value to validate
     * @param inputType Type of input (text, number, email, etc.)
     * @param required Whether the input is required
     * @return struct with isValid flag and sanitizedValue
     */
    remote struct function validateInput(
        required string inputValue,
        required string inputType,
        boolean required = false
    ) {
        var result = {
            isValid: true,
            sanitizedValue: arguments.inputValue,
            errors: []
        };
        
        try {
            // Check if required field is empty
            if (arguments.required && (len(trim(arguments.inputValue)) == 0)) {
                result.isValid = false;
                arrayAppend(result.errors, "Bu alan zorunludur");
                return result;
            }
            
            // Check maximum length
            if (len(arguments.inputValue) > variables.securityConfig.maxInputLength) {
                result.isValid = false;
                arrayAppend(result.errors, "Girdi çok uzun (maksimum #variables.securityConfig.maxInputLength# karakter)");
                return result;
            }
            
            // SQL Injection check
            if (!isSQLSafe(arguments.inputValue)) {
                result.isValid = false;
                arrayAppend(result.errors, "Güvenlik nedeniyle bu girdi kabul edilemiyor");
                logSecurityViolation("SQL Injection attempt", arguments.inputValue);
                return result;
            }
            
            // XSS check
            if (!isXSSSafe(arguments.inputValue)) {
                result.isValid = false;
                arrayAppend(result.errors, "Güvenlik nedeniyle bu girdi kabul edilemiyor");
                logSecurityViolation("XSS attempt", arguments.inputValue);
                return result;
            }
            
            // Type-specific validation
            switch (arguments.inputType) {
                case "number":
                    result = validateNumber(arguments.inputValue, result);
                    break;
                case "email":
                    result = validateEmail(arguments.inputValue, result);
                    break;
                case "projectId":
                    result = validateProjectId(arguments.inputValue, result);
                    break;
                case "productName":
                    result = validateProductName(arguments.inputValue, result);
                    break;
                case "alphanumeric":
                    result = validateAlphanumeric(arguments.inputValue, result);
                    break;
                default:
                    result = validateText(arguments.inputValue, result);
            }
            
            // Sanitize the input
            if (result.isValid) {
                result.sanitizedValue = sanitizeInput(arguments.inputValue, arguments.inputType);
            }
            
        } catch (any e) {
            result.isValid = false;
            arrayAppend(result.errors, "Doğrulama sırasında hata oluştu");
            logError("Input validation error", e);
        }
        
        return result;
    }
    
    /**
     * Check for SQL injection patterns
     */
    private boolean function isSQLSafe(required string input) {
        var cleanInput = uCase(arguments.input);
        
        for (var pattern in variables.securityConfig.sqlInjectionPatterns) {
            if (reFindNoCase(pattern, cleanInput)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Check for XSS patterns
     */
    private boolean function isXSSSafe(required string input) {
        var cleanInput = lCase(arguments.input);
        
        for (var pattern in variables.securityConfig.xssPatterns) {
            if (reFindNoCase(pattern, cleanInput)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Validate numeric input
     */
    private struct function validateNumber(required string input, required struct result) {
        if (len(trim(arguments.input)) > 0 && !isNumeric(arguments.input)) {
            arguments.result.isValid = false;
            arrayAppend(arguments.result.errors, "Geçerli bir sayı giriniz");
        }
        return arguments.result;
    }
    
    /**
     * Validate email input
     */
    private struct function validateEmail(required string input, required struct result) {
        var emailPattern = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})$";
        if (len(trim(arguments.input)) > 0 && !reFind(emailPattern, arguments.input)) {
            arguments.result.isValid = false;
            arrayAppend(arguments.result.errors, "Geçerli bir email adresi giriniz");
        }
        return arguments.result;
    }
    
    /**
     * Validate project ID
     */
    private struct function validateProjectId(required string input, required struct result) {
        if (len(trim(arguments.input)) > 0) {
            if (!isNumeric(arguments.input) || val(arguments.input) <= 0) {
                arguments.result.isValid = false;
                arrayAppend(arguments.result.errors, "Geçerli bir proje ID giriniz");
            }
        }
        return arguments.result;
    }
    
    /**
     * Validate product name
     */
    private struct function validateProductName(required string input, required struct result) {
        var namePattern = "^[a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s\-_.()]{2,100}$";
        if (len(trim(arguments.input)) > 0 && !reFind(namePattern, arguments.input)) {
            arguments.result.isValid = false;
            arrayAppend(arguments.result.errors, "Ürün adı 2-100 karakter arasında olmalı ve sadece harf, rakam, boşluk ve temel noktalama işaretleri içermelidir");
        }
        return arguments.result;
    }
    
    /**
     * Validate alphanumeric input
     */
    private struct function validateAlphanumeric(required string input, required struct result) {
        var alphaPattern = "^[a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s]+$";
        if (len(trim(arguments.input)) > 0 && !reFind(alphaPattern, arguments.input)) {
            arguments.result.isValid = false;
            arrayAppend(arguments.result.errors, "Sadece harf, rakam ve boşluk karakterleri kullanabilirsiniz");
        }
        return arguments.result;
    }
    
    /**
     * Validate text input
     */
    private struct function validateText(required string input, required struct result) {
        // Allow most characters but check for obvious malicious patterns
        return arguments.result;
    }
    
    /**
     * Sanitize input based on type
     */
    private string function sanitizeInput(required string input, required string type) {
        var sanitized = trim(arguments.input);
        
        switch (arguments.type) {
            case "number":
                sanitized = reReplace(sanitized, "[^0-9.-]", "", "all");
                break;
            case "alphanumeric":
                sanitized = reReplace(sanitized, "[^a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s]", "", "all");
                break;
            case "productName":
                sanitized = reReplace(sanitized, "[^a-zA-Z0-9ÇçĞğÜüŞşİıÖö\s\-_.]", "", "all");
                break;
            default:
                // HTML encode for safety
                sanitized = htmlEditFormat(sanitized);
        }
        
        return sanitized;
    }
    
    /**
     * Create secure database query with parameter binding
     */
    public struct function createSecureQuery(
        required string sql,
        struct parameters = {}
    ) {
        var result = {
            isValid: true,
            query: "",
            params: {},
            errors: []
        };
        
        try {
            // Validate SQL statement structure
            if (!isValidSQLStructure(arguments.sql)) {
                result.isValid = false;
                arrayAppend(result.errors, "Geçersiz SQL yapısı");
                return result;
            }
            
            // Validate all parameters
            for (var paramName in arguments.parameters) {
                var paramValue = arguments.parameters[paramName];
                var validation = validateInput(paramValue, "text", false);
                
                if (!validation.isValid) {
                    result.isValid = false;
                    result.errors.addAll(validation.errors);
                } else {
                    result.params[paramName] = {
                        value: validation.sanitizedValue,
                        cfsqltype: determineSQLType(paramValue)
                    };
                }
            }
            
            if (result.isValid) {
                result.query = arguments.sql;
            }
            
        } catch (any e) {
            result.isValid = false;
            arrayAppend(result.errors, "Query oluşturma hatası");
            logError("Secure query creation error", e);
        }
        
        return result;
    }
    
    /**
     * Validate SQL structure
     */
    private boolean function isValidSQLStructure(required string sql) {
        var cleanSQL = uCase(trim(arguments.sql));
        
        // Check for basic SQL structure
        if (!reFindNoCase("^(SELECT|INSERT|UPDATE|DELETE)", cleanSQL)) {
            return false;
        }
        
        // Check for dangerous SQL operations
        var dangerousPatterns = [
            "DROP\s+TABLE",
            "DELETE\s+FROM.*WHERE\s+1\s*=\s*1",
            "TRUNCATE\s+TABLE",
            "ALTER\s+TABLE",
            "CREATE\s+TABLE"
        ];
        
        for (var pattern in dangerousPatterns) {
            if (reFindNoCase(pattern, cleanSQL)) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Determine appropriate SQL type for parameter
     */
    private string function determineSQLType(required any value) {
        if (isNumeric(arguments.value)) {
            if (find(".", arguments.value)) {
                return "CF_SQL_DECIMAL";
            } else {
                return "CF_SQL_INTEGER";
            }
        } else if (isDate(arguments.value)) {
            return "CF_SQL_TIMESTAMP";
        } else {
            return "CF_SQL_VARCHAR";
        }
    }
    
    /**
     * CSRF Token Management
     */
    remote string function generateCSRFToken() {
        var token = hash(createUUID() & now() & session.sessionid, "SHA-256");
        session.csrfToken = token;
        session.csrfTokenExpiry = dateAdd("n", variables.securityConfig.csrfTokenExpiration, now());
        return token;
    }
    
    /**
     * Validate CSRF Token
     */
    remote boolean function validateCSRFToken(required string token) {
        if (!structKeyExists(session, "csrfToken") || 
            !structKeyExists(session, "csrfTokenExpiry")) {
            return false;
        }
        
        if (dateCompare(now(), session.csrfTokenExpiry) > 0) {
            structDelete(session, "csrfToken");
            structDelete(session, "csrfTokenExpiry");
            return false;
        }
        
        return (session.csrfToken == arguments.token);
    }
    
    /**
     * Setup CSRF protection
     */
    private void function setupCSRFProtection() {
        if (!structKeyExists(session, "csrfToken")) {
            generateCSRFToken();
        }
    }
    
    /**
     * Rate limiting for security
     */
    remote boolean function checkRateLimit(required string identifier) {
        var currentTime = now();
        var sessionKey = "rateLimit_" & arguments.identifier;
        
        if (!structKeyExists(variables.userSessions, sessionKey)) {
            variables.userSessions[sessionKey] = {
                attempts: 1,
                lastAttempt: currentTime,
                lockedUntil: ""
            };
            return true;
        }
        
        var userSession = variables.userSessions[sessionKey];
        
        // Check if user is currently locked out
        if (len(userSession.lockedUntil) && dateCompare(currentTime, userSession.lockedUntil) < 0) {
            return false;
        }
        
        // Reset if enough time has passed
        if (dateDiff("n", userSession.lastAttempt, currentTime) > 1) {
            userSession.attempts = 1;
            userSession.lastAttempt = currentTime;
            userSession.lockedUntil = "";
            return true;
        }
        
        // Increment attempts
        userSession.attempts++;
        userSession.lastAttempt = currentTime;
        
        // Lock user if too many attempts
        if (userSession.attempts > variables.securityConfig.maxFailedAttempts) {
            userSession.lockedUntil = dateAdd("n", variables.securityConfig.lockoutDuration, currentTime);
            logSecurityViolation("Rate limit exceeded", arguments.identifier);
            return false;
        }
        
        return true;
    }
    
    /**
     * Session security validation
     */
    remote boolean function validateSession() {
        if (!structKeyExists(session, "isLoggedIn") || !session.isLoggedIn) {
            return false;
        }
        
        if (!structKeyExists(session, "lastActivity")) {
            return false;
        }
        
        // Check session timeout (30 minutes)
        if (dateDiff("n", session.lastActivity, now()) > 30) {
            structClear(session);
            return false;
        }
        
        // Update last activity
        session.lastActivity = now();
        return true;
    }
    
    /**
     * Log security violations
     */
    private void function logSecurityViolation(required string type, string details = "") {
        var logEntry = {
            timestamp: now(),
            type: arguments.type,
            details: arguments.details,
            ipAddress: cgi.remote_addr,
            userAgent: cgi.http_user_agent,
            sessionId: session.sessionid
        };
        
        // Write to security log
        writeLog(
            file: "security",
            text: "Security Violation: #arguments.type# - IP: #cgi.remote_addr# - Details: #arguments.details#",
            type: "warning"
        );
    }
    
    /**
     * Log general errors
     */
    private void function logError(required string message, any exception = "") {
        var logDetails = arguments.message;
        if (isStruct(arguments.exception)) {
            logDetails &= " - Error: " & arguments.exception.message;
        }
        
        writeLog(
            file: "application",
            text: logDetails,
            type: "error"
        );
    }
    
    /**
     * Initialize security logging
     */
    private void function initializeSecurityLogging() {
        // Create security log file if it doesn't exist
        var logPath = expandPath("/logs/security.log");
        if (!fileExists(logPath)) {
            fileWrite(logPath, "Security log initialized on #now()##chr(13)##chr(10)#");
        }
    }
    
    /**
     * Sanitize file upload
     */
    public struct function validateFileUpload(required string filePath, required string allowedExtensions) {
        var result = {
            isValid: true,
            errors: [],
            sanitizedFileName: ""
        };
        
        try {
            var fileName = getFileFromPath(arguments.filePath);
            var fileExtension = lCase(listLast(fileName, "."));
            
            // Check file extension
            if (!listFindNoCase(arguments.allowedExtensions, fileExtension)) {
                result.isValid = false;
                arrayAppend(result.errors, "Dosya türü izin verilmiyor");
                return result;
            }
            
            // Sanitize file name
            var sanitizedName = reReplace(fileName, "[^a-zA-Z0-9._-]", "_", "all");
            result.sanitizedFileName = sanitizedName;
            
            // Check file size (max 10MB)
            if (fileExists(arguments.filePath)) {
                var fileInfo = getFileInfo(arguments.filePath);
                if (fileInfo.size > 10485760) { // 10MB in bytes
                    result.isValid = false;
                    arrayAppend(result.errors, "Dosya boyutu çok büyük (maksimum 10MB)");
                }
            }
            
        } catch (any e) {
            result.isValid = false;
            arrayAppend(result.errors, "Dosya doğrulama hatası");
            logError("File validation error", e);
        }
        
        return result;
    }
}