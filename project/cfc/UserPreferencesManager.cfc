<!--- 
User Preferences Manager for Product Design System
Handles personalized settings and configurations
--->

<cfcomponent displayname="UserPreferencesManager" hint="Manages user preferences and personalization settings">
    
    <cfscript>
        variables.dsn = application.zeroApp.dsnZero;
        variables.defaultPreferences = {
            theme: "light",
            language: "tr",
            pageSize: 25,
            dateFormat: "dd/mm/yyyy",
            timeFormat: "HH:mm",
            currency: "TRY",
            decimals: 2,
            autoSave: true,
            notifications: true,
            soundEnabled: true,
            compactView: false,
            showTutorials: true,
            defaultView: "tree",
            sortOrder: "name_asc",
            filterPanelOpen: true,
            gridColumns: ["name", "category", "price", "status", "date"],
            dashboardWidgets: ["recent_products", "statistics", "notifications"],
            shortcuts: {}
        };
    </cfscript>
    
    <!--- Get user preferences --->
    <cffunction name="getUserPreferences" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="userId" required="false" type="string" default="#session.pp.userid#">
        <cfargument name="category" required="false" type="string" default="">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Validate user can access these preferences --->
            <cfif arguments.userId NEQ session.pp.userid AND NOT checkAdminPermission()>
                <cfthrow message="Bu kullanıcının tercihlerine erişim yetkiniz yok" type="Security">
            </cfif>
            
            <!--- Get user preferences from database --->
            <cfquery name="getUserPrefs" datasource="#variables.dsn#">
                SELECT 
                    PREFERENCE_KEY,
                    PREFERENCE_VALUE,
                    CATEGORY,
                    UPDATE_DATE
                FROM USER_PREFERENCES
                WHERE USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                <cfif len(trim(arguments.category))>
                    AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
                AND IS_ACTIVE = 1
            </cfquery>
            
            <!--- Build preferences structure --->
            <cfset userPreferences = duplicate(variables.defaultPreferences)>
            
            <cfloop query="getUserPrefs">
                <cftry>
                    <!--- Parse JSON values --->
                    <cfif left(getUserPrefs.PREFERENCE_VALUE, 1) EQ "{" OR left(getUserPrefs.PREFERENCE_VALUE, 1) EQ "[">
                        <cfset userPreferences[getUserPrefs.PREFERENCE_KEY] = deserializeJSON(getUserPrefs.PREFERENCE_VALUE)>
                    <cfelse>
                        <cfset userPreferences[getUserPrefs.PREFERENCE_KEY] = getUserPrefs.PREFERENCE_VALUE>
                    </cfif>
                    <cfcatch type="any">
                        <!--- If JSON parsing fails, use raw value --->
                        <cfset userPreferences[getUserPrefs.PREFERENCE_KEY] = getUserPrefs.PREFERENCE_VALUE>
                    </cfcatch>
                </cftry>
            </cfloop>
            
            <!--- Log preference access --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset auditLogger.logUserAction(
                action = "PREFERENCES_ACCESS",
                details = "Retrieved preferences for user #arguments.userId#" & (len(arguments.category) ? " category: #arguments.category#" : ""),
                severity = "INFO"
            )>
            
            <cfreturn serializeJSON({
                success: true,
                preferences: userPreferences,
                lastUpdate: getUserPrefs.recordCount GT 0 ? getUserPrefs.UPDATE_DATE[1] : now()
            })>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("PREFERENCES_ACCESS_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "UserPreferencesManager.cfc")>
                <cfreturn serializeJSON({
                    success: false,
                    message: "Tercihler yüklenirken hata oluştu: " & cfcatch.message,
                    preferences: variables.defaultPreferences
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Save user preferences --->
    <cffunction name="saveUserPreferences" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="userId" required="false" type="string" default="#session.pp.userid#">
        <cfargument name="preferences" required="true" type="struct">
        <cfargument name="category" required="false" type="string" default="general">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Validate user can modify these preferences --->
            <cfif arguments.userId NEQ session.pp.userid AND NOT checkAdminPermission()>
                <cfthrow message="Bu kullanıcının tercihlerini değiştirme yetkiniz yok" type="Security">
            </cfif>
            
            <!--- Initialize audit logger --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset savedCount = 0>
            <cfset oldPreferences = {}>
            
            <!--- Get current preferences for audit --->
            <cfquery name="getCurrentPrefs" datasource="#variables.dsn#">
                SELECT PREFERENCE_KEY, PREFERENCE_VALUE
                FROM USER_PREFERENCES
                WHERE USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">
            </cfquery>
            
            <cfloop query="getCurrentPrefs">
                <cfset oldPreferences[getCurrentPrefs.PREFERENCE_KEY] = getCurrentPrefs.PREFERENCE_VALUE>
            </cfloop>
            
            <!--- Save each preference --->
            <cftransaction>
                <cfloop collection="#arguments.preferences#" item="prefKey">
                    <cfset prefValue = arguments.preferences[prefKey]>
                    
                    <!--- Validate preference key --->
                    <cfset keyValidation = securityValidator.validateInput(prefKey, "alphanumeric_extended", true)>
                    <cfif NOT keyValidation.isValid>
                        <cfcontinue>
                    </cfif>
                    
                    <!--- Convert complex values to JSON --->
                    <cfif isStruct(prefValue) OR isArray(prefValue)>
                        <cfset prefValueStr = serializeJSON(prefValue)>
                    <cfelse>
                        <cfset prefValueStr = toString(prefValue)>
                    </cfif>
                    
                    <!--- Validate preference value --->
                    <cfset valueValidation = securityValidator.validateInput(prefValueStr, "general", true, 4000)>
                    <cfif NOT valueValidation.isValid>
                        <cfcontinue>
                    </cfif>
                    
                    <!--- Update or insert preference --->
                    <cfquery datasource="#variables.dsn#">
                        IF EXISTS (SELECT 1 FROM USER_PREFERENCES 
                                  WHERE USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                                  AND PREFERENCE_KEY = <cfqueryparam value="#prefKey#" cfsqltype="CF_SQL_VARCHAR">
                                  AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">)
                        BEGIN
                            UPDATE USER_PREFERENCES 
                            SET 
                                PREFERENCE_VALUE = <cfqueryparam value="#prefValueStr#" cfsqltype="CF_SQL_VARCHAR">,
                                UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                                UPDATE_EMP = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_VARCHAR">
                            WHERE USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                            AND PREFERENCE_KEY = <cfqueryparam value="#prefKey#" cfsqltype="CF_SQL_VARCHAR">
                            AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">
                        END
                        ELSE
                        BEGIN
                            INSERT INTO USER_PREFERENCES (
                                USER_ID, PREFERENCE_KEY, PREFERENCE_VALUE, CATEGORY,
                                RECORD_DATE, RECORD_EMP, UPDATE_DATE, UPDATE_EMP, IS_ACTIVE
                            ) VALUES (
                                <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">,
                                <cfqueryparam value="#prefKey#" cfsqltype="CF_SQL_VARCHAR">,
                                <cfqueryparam value="#prefValueStr#" cfsqltype="CF_SQL_VARCHAR">,
                                <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">,
                                <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                                <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_VARCHAR">,
                                <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                                <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_VARCHAR">,
                                1
                            )
                        END
                    </cfquery>
                    
                    <cfset savedCount++>
                </cfloop>
            </cftransaction>
            
            <!--- Log preference changes --->
            <cfset auditLogger.logUserAction(
                action = "PREFERENCES_SAVE",
                details = "Saved #savedCount# preferences in category: #arguments.category#",
                oldValues = oldPreferences,
                newValues = arguments.preferences,
                severity = "INFO"
            )>
            
            <!--- Update user session with new preferences if it's current user --->
            <cfif arguments.userId EQ session.pp.userid>
                <cfset session.userPreferences = arguments.preferences>
            </cfif>
            
            <cfreturn serializeJSON({
                success: true,
                message: "#savedCount# tercih kaydedildi",
                savedCount: savedCount
            })>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("PREFERENCES_SAVE_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "UserPreferencesManager.cfc")>
                <cfreturn serializeJSON({
                    success: false,
                    message: "Tercihler kaydedilirken hata oluştu: " & cfcatch.message
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Reset preferences to default --->
    <cffunction name="resetPreferences" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="userId" required="false" type="string" default="#session.pp.userid#">
        <cfargument name="category" required="false" type="string" default="">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Validate user can reset these preferences --->
            <cfif arguments.userId NEQ session.pp.userid AND NOT checkAdminPermission()>
                <cfthrow message="Bu kullanıcının tercihlerini sıfırlama yetkiniz yok" type="Security">
            </cfif>
            
            <!--- Reset preferences --->
            <cfquery datasource="#variables.dsn#">
                UPDATE USER_PREFERENCES 
                SET 
                    IS_ACTIVE = 0,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                    UPDATE_EMP = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_VARCHAR">
                WHERE USER_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="CF_SQL_VARCHAR">
                <cfif len(trim(arguments.category))>
                    AND CATEGORY = <cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
            </cfquery>
            
            <!--- Log preference reset --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset auditLogger.logUserAction(
                action = "PREFERENCES_RESET",
                details = "Reset preferences for user #arguments.userId#" & (len(arguments.category) ? " category: #arguments.category#" : " (all categories)"),
                severity = "WARNING"
            )>
            
            <!--- Clear session preferences if it's current user --->
            <cfif arguments.userId EQ session.pp.userid>
                <cfset structDelete(session, "userPreferences")>
            </cfif>
            
            <cfreturn serializeJSON({
                success: true,
                message: "Tercihler başarıyla sıfırlandı",
                defaultPreferences: variables.defaultPreferences
            })>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("PREFERENCES_RESET_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "UserPreferencesManager.cfc")>
                <cfreturn serializeJSON({
                    success: false,
                    message: "Tercihler sıfırlanırken hata oluştu: " & cfcatch.message
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Import/Export preferences --->
    <cffunction name="exportPreferences" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="userId" required="false" type="string" default="#session.pp.userid#">
        <cfargument name="format" required="false" type="string" default="json">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Get user preferences --->
            <cfset preferencesResult = getUserPreferences(arguments.userId, "", arguments.csrf_token)>
            <cfset preferencesData = deserializeJSON(preferencesResult)>
            
            <cfif NOT preferencesData.success>
                <cfreturn preferencesResult>
            </cfif>
            
            <!--- Create export data --->
            <cfset exportData = {
                exportInfo: {
                    userId: arguments.userId,
                    exportDate: now(),
                    version: "1.0",
                    format: arguments.format
                },
                preferences: preferencesData.preferences
            }>
            
            <!--- Generate filename and path --->
            <cfset exportDir = expandPath("/exports/preferences/")>
            <cfif not directoryExists(exportDir)>
                <cfdirectory action="create" directory="#exportDir#">
            </cfif>
            
            <cfset timestamp = dateFormat(now(), "yyyymmdd") & "_" & timeFormat(now(), "HHmmss")>
            <cfset fileName = "preferences_#arguments.userId#_#timestamp#.json">
            <cfset filePath = exportDir & fileName>
            
            <!--- Write export file --->
            <cffile action="write" 
                    file="#filePath#" 
                    output="#serializeJSON(exportData)#" 
                    charset="utf-8">
            
            <!--- Log export --->
            <cfset auditLogger = createObject("component", "AuditLogger")>
            <cfset auditLogger.logUserAction(
                action = "PREFERENCES_EXPORT",
                details = "Exported preferences for user #arguments.userId#",
                newValues = {fileName: fileName, format: arguments.format},
                severity = "INFO"
            )>
            
            <cfreturn serializeJSON({
                success: true,
                fileName: fileName,
                downloadUrl: "/downloads/preferences/" & fileName,
                message: "Tercihler başarıyla export edildi"
            })>
            
            <cfcatch type="any">
                <cfset auditLogger.logError("PREFERENCES_EXPORT_ERROR", cfcatch.message, cfcatch.detail, cfcatch.stackTrace, "UserPreferencesManager.cfc")>
                <cfreturn serializeJSON({
                    success: false,
                    message: "Tercihler export edilirken hata oluştu: " & cfcatch.message
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Get theme and UI preferences for quick access --->
    <cffunction name="getUIPreferences" access="remote" httpMethod="POST" returntype="any" returnformat="json">
        <cfargument name="csrf_token" required="true">
        
        <cftry>
            <!--- Security validations --->
            <cfset securityValidator = createObject("component", "SecurityValidator")>
            
            <cfif NOT securityValidator.validateSession()>
                <cfthrow message="Oturum geçersiz" type="Security">
            </cfif>
            
            <cfif NOT securityValidator.validateCSRFToken(arguments.csrf_token)>
                <cfthrow message="CSRF token geçersiz" type="Security">
            </cfif>
            
            <!--- Get UI-specific preferences --->
            <cfquery name="getUIPrefs" datasource="#variables.dsn#">
                SELECT PREFERENCE_KEY, PREFERENCE_VALUE
                FROM USER_PREFERENCES
                WHERE USER_ID = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_VARCHAR">
                AND PREFERENCE_KEY IN ('theme', 'language', 'compactView', 'defaultView', 'gridColumns', 'filterPanelOpen')
                AND IS_ACTIVE = 1
            </cfquery>
            
            <cfset uiPreferences = {
                theme: "light",
                language: "tr",
                compactView: false,
                defaultView: "tree",
                gridColumns: ["name", "category", "price", "status", "date"],
                filterPanelOpen: true
            }>
            
            <cfloop query="getUIPrefs">
                <cftry>
                    <cfif left(getUIPrefs.PREFERENCE_VALUE, 1) EQ "{" OR left(getUIPrefs.PREFERENCE_VALUE, 1) EQ "[">
                        <cfset uiPreferences[getUIPrefs.PREFERENCE_KEY] = deserializeJSON(getUIPrefs.PREFERENCE_VALUE)>
                    <cfelse>
                        <cfset uiPreferences[getUIPrefs.PREFERENCE_KEY] = getUIPrefs.PREFERENCE_VALUE>
                    </cfif>
                    <cfcatch type="any">
                        <!--- Keep default value on error --->
                    </cfcatch>
                </cftry>
            </cfloop>
            
            <cfreturn serializeJSON({
                success: true,
                uiPreferences: uiPreferences
            })>
            
            <cfcatch type="any">
                <cfreturn serializeJSON({
                    success: false,
                    message: "UI tercihleri yüklenirken hata oluştu",
                    uiPreferences: {
                        theme: "light",
                        language: "tr",
                        compactView: false,
                        defaultView: "tree",
                        gridColumns: ["name", "category", "price", "status", "date"],
                        filterPanelOpen: true
                    }
                })>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Helper function to check admin permission --->
    <cffunction name="checkAdminPermission" access="private" returntype="boolean">
        <cfquery name="checkAdmin" datasource="#variables.dsn#">
            SELECT COUNT(*) as admin_count
            FROM EMPLOYEE_POSITION_ROW_PRT EPR
            INNER JOIN EMPLOYEE_POSITION_ROW_USERTYPE_PRT EPRUT ON EPR.EMPLOYEE_POSITION_ROW_ID = EPRUT.EMPLOYEE_POSITION_ROW_ID
            INNER JOIN FUSEACTION FU ON EPRUT.FUSEACTION_ID = FU.FUSEACTION_ID
            WHERE EPR.EMPLOYEE_ID = <cfqueryparam value="#session.pp.userid#" cfsqltype="CF_SQL_INTEGER">
            AND FU.FUSEACTION = 'USER_PREFERENCES_ADMIN'
            AND EPR.IS_ACTIVE = 1
        </cfquery>
        
        <cfreturn checkAdmin.admin_count GT 0>
    </cffunction>
    
</cfcomponent>