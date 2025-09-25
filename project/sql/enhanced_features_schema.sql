-- SQL Table Structures for Enhanced Features
-- Product Design System - Feature Enhancements
-- Created: December 2024

-- User Preferences Table
CREATE TABLE USER_PREFERENCES (
    PREFERENCE_ID int IDENTITY(1,1) PRIMARY KEY,
    USER_ID varchar(50) NOT NULL,
    PREFERENCE_KEY varchar(100) NOT NULL,
    PREFERENCE_VALUE varchar(4000),
    CATEGORY varchar(50) DEFAULT 'general',
    RECORD_DATE datetime DEFAULT GETDATE(),
    RECORD_EMP varchar(50),
    UPDATE_DATE datetime DEFAULT GETDATE(),
    UPDATE_EMP varchar(50),
    IS_ACTIVE bit DEFAULT 1,
    
    CONSTRAINT UK_USER_PREFERENCES UNIQUE (USER_ID, PREFERENCE_KEY, CATEGORY)
);

-- Create indexes for user preferences
CREATE INDEX IX_USER_PREFERENCES_USER ON USER_PREFERENCES (USER_ID, IS_ACTIVE);
CREATE INDEX IX_USER_PREFERENCES_CATEGORY ON USER_PREFERENCES (CATEGORY, IS_ACTIVE);

-- Bulk Operations Log Table
CREATE TABLE BULK_OPERATIONS_LOG (
    LOG_ID varchar(50) PRIMARY KEY,
    OPERATION_TYPE varchar(50) NOT NULL,
    USER_ID varchar(50) NOT NULL,
    AFFECTED_RECORDS int DEFAULT 0,
    SUCCESS_COUNT int DEFAULT 0,
    FAILED_COUNT int DEFAULT 0,
    OPERATION_DATA text,
    START_TIME datetime DEFAULT GETDATE(),
    END_TIME datetime,
    STATUS varchar(20) DEFAULT 'RUNNING', -- RUNNING, COMPLETED, FAILED
    ERROR_MESSAGE varchar(4000),
    SESSION_ID varchar(100),
    IP_ADDRESS varchar(45),
    
    CONSTRAINT CK_BULK_STATUS CHECK (STATUS IN ('RUNNING', 'COMPLETED', 'FAILED'))
);

-- Create indexes for bulk operations log
CREATE INDEX IX_BULK_OPS_USER_DATE ON BULK_OPERATIONS_LOG (USER_ID, START_TIME DESC);
CREATE INDEX IX_BULK_OPS_STATUS ON BULK_OPERATIONS_LOG (STATUS, START_TIME);

-- Filter Presets Table
CREATE TABLE FILTER_PRESETS (
    PRESET_ID int IDENTITY(1,1) PRIMARY KEY,
    USER_ID varchar(50) NOT NULL,
    PRESET_NAME varchar(100) NOT NULL,
    FILTER_DATA text NOT NULL,
    IS_DEFAULT bit DEFAULT 0,
    IS_PUBLIC bit DEFAULT 0,
    RECORD_DATE datetime DEFAULT GETDATE(),
    RECORD_EMP varchar(50),
    UPDATE_DATE datetime DEFAULT GETDATE(),
    UPDATE_EMP varchar(50),
    IS_ACTIVE bit DEFAULT 1,
    
    CONSTRAINT UK_FILTER_PRESETS UNIQUE (USER_ID, PRESET_NAME)
);

-- Create indexes for filter presets
CREATE INDEX IX_FILTER_PRESETS_USER ON FILTER_PRESETS (USER_ID, IS_ACTIVE);
CREATE INDEX IX_FILTER_PRESETS_PUBLIC ON FILTER_PRESETS (IS_PUBLIC, IS_ACTIVE);

-- Export History Table
CREATE TABLE EXPORT_HISTORY (
    EXPORT_ID varchar(50) PRIMARY KEY,
    USER_ID varchar(50) NOT NULL,
    EXPORT_TYPE varchar(50) NOT NULL,
    FORMAT varchar(20) NOT NULL,
    FILE_NAME varchar(255) NOT NULL,
    FILE_PATH varchar(500),
    FILE_SIZE bigint DEFAULT 0,
    RECORD_COUNT int DEFAULT 0,
    EXPORT_FILTERS text,
    SELECTED_COLUMNS text,
    START_TIME datetime DEFAULT GETDATE(),
    COMPLETION_TIME datetime,
    STATUS varchar(20) DEFAULT 'PROCESSING', -- PROCESSING, COMPLETED, FAILED
    ERROR_MESSAGE varchar(4000),
    DOWNLOAD_COUNT int DEFAULT 0,
    LAST_DOWNLOAD datetime,
    SESSION_ID varchar(100),
    IP_ADDRESS varchar(45),
    
    CONSTRAINT CK_EXPORT_STATUS CHECK (STATUS IN ('PROCESSING', 'COMPLETED', 'FAILED'))
);

-- Create indexes for export history
CREATE INDEX IX_EXPORT_HISTORY_USER ON EXPORT_HISTORY (USER_ID, START_TIME DESC);
CREATE INDEX IX_EXPORT_HISTORY_STATUS ON EXPORT_HISTORY (STATUS, START_TIME);
CREATE INDEX IX_EXPORT_HISTORY_TYPE ON EXPORT_HISTORY (EXPORT_TYPE, FORMAT);

-- Workflow Automation Rules Table
CREATE TABLE WORKFLOW_AUTOMATION_RULES (
    RULE_ID int IDENTITY(1,1) PRIMARY KEY,
    RULE_NAME varchar(100) NOT NULL,
    DESCRIPTION varchar(500),
    TRIGGER_EVENT varchar(100) NOT NULL, -- PRODUCT_CREATED, PRICE_CHANGED, etc.
    CONDITIONS text, -- JSON format conditions
    ACTIONS text NOT NULL, -- JSON format actions
    IS_ACTIVE bit DEFAULT 1,
    CREATED_BY varchar(50) NOT NULL,
    CREATED_DATE datetime DEFAULT GETDATE(),
    UPDATED_BY varchar(50),
    UPDATED_DATE datetime DEFAULT GETDATE(),
    LAST_EXECUTED datetime,
    EXECUTION_COUNT int DEFAULT 0,
    SUCCESS_COUNT int DEFAULT 0,
    FAILURE_COUNT int DEFAULT 0,
    
    CONSTRAINT UK_WORKFLOW_RULE_NAME UNIQUE (RULE_NAME)
);

-- Create indexes for workflow rules
CREATE INDEX IX_WORKFLOW_RULES_TRIGGER ON WORKFLOW_AUTOMATION_RULES (TRIGGER_EVENT, IS_ACTIVE);
CREATE INDEX IX_WORKFLOW_RULES_ACTIVE ON WORKFLOW_AUTOMATION_RULES (IS_ACTIVE, CREATED_DATE);

-- Workflow Execution Log Table
CREATE TABLE WORKFLOW_EXECUTION_LOG (
    EXECUTION_ID varchar(50) PRIMARY KEY,
    RULE_ID int NOT NULL,
    TRIGGER_DATA text,
    EXECUTION_RESULT text,
    STATUS varchar(20) DEFAULT 'SUCCESS', -- SUCCESS, FAILED, SKIPPED
    ERROR_MESSAGE varchar(4000),
    EXECUTION_TIME int DEFAULT 0, -- milliseconds
    EXECUTED_DATE datetime DEFAULT GETDATE(),
    TRIGGERED_BY varchar(50),
    
    CONSTRAINT FK_WORKFLOW_EXECUTION_RULE FOREIGN KEY (RULE_ID) REFERENCES WORKFLOW_AUTOMATION_RULES(RULE_ID),
    CONSTRAINT CK_WORKFLOW_EXECUTION_STATUS CHECK (STATUS IN ('SUCCESS', 'FAILED', 'SKIPPED'))
);

-- Create indexes for workflow execution log
CREATE INDEX IX_WORKFLOW_EXEC_RULE ON WORKFLOW_EXECUTION_LOG (RULE_ID, EXECUTED_DATE DESC);
CREATE INDEX IX_WORKFLOW_EXEC_STATUS ON WORKFLOW_EXECUTION_LOG (STATUS, EXECUTED_DATE DESC);

-- Scheduled Tasks Table
CREATE TABLE SCHEDULED_TASKS (
    TASK_ID int IDENTITY(1,1) PRIMARY KEY,
    TASK_NAME varchar(100) NOT NULL,
    DESCRIPTION varchar(500),
    TASK_TYPE varchar(50) NOT NULL, -- EXPORT, CLEANUP, BACKUP, etc.
    SCHEDULE_PATTERN varchar(100) NOT NULL, -- CRON-like expression
    TASK_DATA text, -- JSON format task parameters
    IS_ACTIVE bit DEFAULT 1,
    NEXT_EXECUTION datetime,
    LAST_EXECUTION datetime,
    EXECUTION_COUNT int DEFAULT 0,
    SUCCESS_COUNT int DEFAULT 0,
    FAILURE_COUNT int DEFAULT 0,
    CREATED_BY varchar(50) NOT NULL,
    CREATED_DATE datetime DEFAULT GETDATE(),
    UPDATED_BY varchar(50),
    UPDATED_DATE datetime DEFAULT GETDATE(),
    
    CONSTRAINT UK_SCHEDULED_TASK_NAME UNIQUE (TASK_NAME)
);

-- Create indexes for scheduled tasks
CREATE INDEX IX_SCHEDULED_TASKS_NEXT ON SCHEDULED_TASKS (NEXT_EXECUTION, IS_ACTIVE);
CREATE INDEX IX_SCHEDULED_TASKS_TYPE ON SCHEDULED_TASKS (TASK_TYPE, IS_ACTIVE);

-- Task Execution History Table
CREATE TABLE TASK_EXECUTION_HISTORY (
    EXECUTION_ID varchar(50) PRIMARY KEY,
    TASK_ID int NOT NULL,
    STATUS varchar(20) DEFAULT 'RUNNING', -- RUNNING, COMPLETED, FAILED
    START_TIME datetime DEFAULT GETDATE(),
    END_TIME datetime,
    EXECUTION_TIME int DEFAULT 0, -- milliseconds
    RESULT_DATA text,
    ERROR_MESSAGE varchar(4000),
    RECORDS_PROCESSED int DEFAULT 0,
    
    CONSTRAINT FK_TASK_EXECUTION_TASK FOREIGN KEY (TASK_ID) REFERENCES SCHEDULED_TASKS(TASK_ID),
    CONSTRAINT CK_TASK_EXECUTION_STATUS CHECK (STATUS IN ('RUNNING', 'COMPLETED', 'FAILED'))
);

-- Create indexes for task execution history
CREATE INDEX IX_TASK_EXEC_TASK ON TASK_EXECUTION_HISTORY (TASK_ID, START_TIME DESC);
CREATE INDEX IX_TASK_EXEC_STATUS ON TASK_EXECUTION_HISTORY (STATUS, START_TIME DESC);

-- Product Change History Table (for tracking all changes)
CREATE TABLE PRODUCT_CHANGE_HISTORY (
    CHANGE_ID varchar(50) PRIMARY KEY,
    PRODUCT_ID int NOT NULL,
    CHANGE_TYPE varchar(50) NOT NULL, -- CREATE, UPDATE, DELETE, BULK_UPDATE
    FIELD_NAME varchar(100),
    OLD_VALUE varchar(4000),
    NEW_VALUE varchar(4000),
    CHANGED_BY varchar(50) NOT NULL,
    CHANGED_DATE datetime DEFAULT GETDATE(),
    SESSION_ID varchar(100),
    IP_ADDRESS varchar(45),
    BULK_OPERATION_ID varchar(50), -- Reference to bulk operation if applicable
    REASON varchar(500),
    
    CONSTRAINT FK_PRODUCT_CHANGE_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES VIRTUAL_PRODUCT_TREE_PRODUCTS_2(PRODUCT_ID)
);

-- Create indexes for product change history
CREATE INDEX IX_PRODUCT_CHANGES_PRODUCT ON PRODUCT_CHANGE_HISTORY (PRODUCT_ID, CHANGED_DATE DESC);
CREATE INDEX IX_PRODUCT_CHANGES_USER ON PRODUCT_CHANGE_HISTORY (CHANGED_BY, CHANGED_DATE DESC);
CREATE INDEX IX_PRODUCT_CHANGES_TYPE ON PRODUCT_CHANGE_HISTORY (CHANGE_TYPE, CHANGED_DATE DESC);
CREATE INDEX IX_PRODUCT_CHANGES_BULK ON PRODUCT_CHANGE_HISTORY (BULK_OPERATION_ID) WHERE BULK_OPERATION_ID IS NOT NULL;

-- Dashboard Widgets Configuration Table
CREATE TABLE DASHBOARD_WIDGETS (
    WIDGET_ID int IDENTITY(1,1) PRIMARY KEY,
    USER_ID varchar(50) NOT NULL,
    WIDGET_TYPE varchar(50) NOT NULL,
    WIDGET_CONFIG text, -- JSON format widget configuration
    POSITION_X int DEFAULT 0,
    POSITION_Y int DEFAULT 0,
    WIDTH int DEFAULT 4,
    HEIGHT int DEFAULT 4,
    IS_VISIBLE bit DEFAULT 1,
    CREATED_DATE datetime DEFAULT GETDATE(),
    UPDATED_DATE datetime DEFAULT GETDATE(),
    
    CONSTRAINT UK_DASHBOARD_WIDGET UNIQUE (USER_ID, WIDGET_TYPE)
);

-- Create indexes for dashboard widgets
CREATE INDEX IX_DASHBOARD_WIDGETS_USER ON DASHBOARD_WIDGETS (USER_ID, IS_VISIBLE);

-- System Settings Table (for global application settings)
CREATE TABLE SYSTEM_SETTINGS (
    SETTING_ID int IDENTITY(1,1) PRIMARY KEY,
    SETTING_KEY varchar(100) NOT NULL,
    SETTING_VALUE varchar(4000),
    SETTING_TYPE varchar(50) DEFAULT 'string', -- string, number, boolean, json
    CATEGORY varchar(50) DEFAULT 'general',
    DESCRIPTION varchar(500),
    IS_EDITABLE bit DEFAULT 1,
    REQUIRES_RESTART bit DEFAULT 0,
    CREATED_DATE datetime DEFAULT GETDATE(),
    UPDATED_DATE datetime DEFAULT GETDATE(),
    UPDATED_BY varchar(50),
    
    CONSTRAINT UK_SYSTEM_SETTING UNIQUE (SETTING_KEY)
);

-- Create indexes for system settings
CREATE INDEX IX_SYSTEM_SETTINGS_CATEGORY ON SYSTEM_SETTINGS (CATEGORY);

-- Insert default system settings
INSERT INTO SYSTEM_SETTINGS (SETTING_KEY, SETTING_VALUE, SETTING_TYPE, CATEGORY, DESCRIPTION, IS_EDITABLE) VALUES
('MAX_EXPORT_RECORDS', '10000', 'number', 'export', 'Maximum number of records allowed in a single export', 1),
('BULK_OPERATION_TIMEOUT', '300', 'number', 'bulk', 'Timeout in seconds for bulk operations', 1),
('AUTO_BACKUP_ENABLED', 'true', 'boolean', 'backup', 'Enable automatic database backups', 1),
('DEFAULT_PAGE_SIZE', '25', 'number', 'ui', 'Default number of items per page', 1),
('SESSION_TIMEOUT_MINUTES', '30', 'number', 'security', 'User session timeout in minutes', 1),
('ENABLE_AUDIT_LOGGING', 'true', 'boolean', 'audit', 'Enable comprehensive audit logging', 0),
('MAX_FILTER_PRESETS_PER_USER', '10', 'number', 'filters', 'Maximum filter presets per user', 1);

-- Create stored procedures for common operations

-- Procedure for cleaning up old export files
CREATE PROCEDURE sp_CleanupOldExports
    @DaysToKeep int = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CutoffDate datetime = DATEADD(day, -@DaysToKeep, GETDATE());
    
    -- Update export records to mark files for deletion
    UPDATE EXPORT_HISTORY 
    SET STATUS = 'EXPIRED'
    WHERE COMPLETION_TIME < @CutoffDate
      AND STATUS = 'COMPLETED';
      
    SELECT @@ROWCOUNT as RecordsUpdated;
END;

-- Procedure for user preference management
CREATE PROCEDURE sp_GetUserPreferences
    @UserId varchar(50),
    @Category varchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        PREFERENCE_KEY,
        PREFERENCE_VALUE,
        CATEGORY,
        UPDATE_DATE
    FROM USER_PREFERENCES
    WHERE USER_ID = @UserId
      AND IS_ACTIVE = 1
      AND (@Category IS NULL OR CATEGORY = @Category);
END;

-- Procedure for bulk operation logging
CREATE PROCEDURE sp_LogBulkOperation
    @LogId varchar(50),
    @OperationType varchar(50),
    @UserId varchar(50),
    @AffectedRecords int,
    @OperationData text,
    @SessionId varchar(100),
    @IpAddress varchar(45)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO BULK_OPERATIONS_LOG (
        LOG_ID, OPERATION_TYPE, USER_ID, AFFECTED_RECORDS,
        OPERATION_DATA, SESSION_ID, IP_ADDRESS, STATUS
    ) VALUES (
        @LogId, @OperationType, @UserId, @AffectedRecords,
        @OperationData, @SessionId, @IpAddress, 'RUNNING'
    );
END;

-- Function for calculating user statistics
CREATE FUNCTION fn_GetUserActivityStats(@UserId varchar(50), @Days int = 30)
RETURNS TABLE
AS
RETURN (
    WITH UserActivity AS (
        SELECT 
            'Export' as ActivityType,
            COUNT(*) as Count,
            MAX(START_TIME) as LastActivity
        FROM EXPORT_HISTORY 
        WHERE USER_ID = @UserId 
          AND START_TIME >= DATEADD(day, -@Days, GETDATE())
        
        UNION ALL
        
        SELECT 
            'BulkOperation' as ActivityType,
            COUNT(*) as Count,
            MAX(START_TIME) as LastActivity
        FROM BULK_OPERATIONS_LOG 
        WHERE USER_ID = @UserId 
          AND START_TIME >= DATEADD(day, -@Days, GETDATE())
        
        UNION ALL
        
        SELECT 
            'PreferenceChange' as ActivityType,
            COUNT(*) as Count,
            MAX(UPDATE_DATE) as LastActivity
        FROM USER_PREFERENCES 
        WHERE USER_ID = @UserId 
          AND UPDATE_DATE >= DATEADD(day, -@Days, GETDATE())
    )
    SELECT * FROM UserActivity WHERE Count > 0
);

-- Create views for reporting
CREATE VIEW vw_UserPreferencesSummary AS
SELECT 
    USER_ID,
    COUNT(*) as TotalPreferences,
    COUNT(DISTINCT CATEGORY) as CategoriesUsed,
    MAX(UPDATE_DATE) as LastUpdated,
    SUM(CASE WHEN CATEGORY = 'ui' THEN 1 ELSE 0 END) as UIPreferences,
    SUM(CASE WHEN CATEGORY = 'behavior' THEN 1 ELSE 0 END) as BehaviorPreferences
FROM USER_PREFERENCES 
WHERE IS_ACTIVE = 1
GROUP BY USER_ID;

CREATE VIEW vw_ExportStatistics AS
SELECT 
    EXPORT_TYPE,
    FORMAT,
    COUNT(*) as TotalExports,
    SUM(RECORD_COUNT) as TotalRecords,
    AVG(DATEDIFF(second, START_TIME, COMPLETION_TIME)) as AvgDurationSeconds,
    MAX(COMPLETION_TIME) as LastExport,
    COUNT(DISTINCT USER_ID) as UniqueUsers
FROM EXPORT_HISTORY 
WHERE STATUS = 'COMPLETED'
GROUP BY EXPORT_TYPE, FORMAT;

-- Comments and documentation
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Stores user preferences and personalization settings',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'USER_PREFERENCES';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Logs all bulk operations performed by users',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'BULK_OPERATIONS_LOG';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Tracks all product changes including bulk updates',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'PRODUCT_CHANGE_HISTORY';

PRINT 'Enhanced Features Database Schema Created Successfully';
PRINT 'Tables Created: USER_PREFERENCES, BULK_OPERATIONS_LOG, FILTER_PRESETS, EXPORT_HISTORY';
PRINT 'Tables Created: WORKFLOW_AUTOMATION_RULES, SCHEDULED_TASKS, PRODUCT_CHANGE_HISTORY';
PRINT 'Additional Features: Stored Procedures, Functions, Views, and Indexes';