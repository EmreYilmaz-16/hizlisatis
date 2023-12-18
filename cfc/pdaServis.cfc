<cfcomponent>
    <cffunction name="GET_ONAY" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="DELIVER_PAPER_NO">
        <cfargument name="dsn3">
        <cfquery name="GETONAY_ROWS" datasource="#arguments.dsn3#">
            EXEC workcube_metosan_1.GET_ONAY '#arguments.DELIVER_PAPER_NO#'
        </cfquery>
        <CFSET RETURNARR=arrayNew(1)>
        
        <cfoutput query="GETONAY_ROWS">
            <cfscript>
                OnayItem={
                    ORR_MIK=ORR_MIK,
                    SF_MIK=SF_MIK,
                	FIS_ID=FIS_ID,
                    STOCK_ID=STOCK_ID,
                    ONY_MIK=ONY_MIK,
                    UNIQUE_RELATION_ID=UNIQUE_RELATION_ID,
                    DETAIL_INFO_EXTRA=DETAIL_INFO_EXTRA,
                    SHIP_METHOD=SHIP_METHOD,
                    PRODUCT_CODE=PRODUCT_CODE,                        
                    PRODUCT_NAME=PRODUCT_NAME,
                    MAIN_UNIT=MAIN_UNIT,
                    BRAND_NAME=BRAND_NAME
                };
                arrayAppend(RETURNARR,OnayItem)
            </cfscript>
        </cfoutput>
        <cfreturn replace(serializeJSON(RETURNARR),'//','')>
    </cffunction>
    <cffunction name="OnaylaCanim" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="FIS_ID">
        <cfargument name="PERIOD_ID">
        <cfargument name="EMPLOYEE_ID">
        <cfargument name="UNIQUE_RELATION_ID">
        <cfargument name="AMOUNT">
        <cfargument name="DSN3">
        <cfquery name="INS" datasource="#arguments.DSN3#" result="resa">
                INSERT INTO STOCK_FIS_ONAY(RECORD_EMP,RECORD_DATE,UNIQUE_RELATION_ID,AMOUNT,FIS_PERIOD_ID,FIS_ID) VALUES (
                    #arguments.EMPLOYEE_ID#,GETDATE(),'#arguments.UNIQUE_RELATION_ID#',#arguments.AMOUNT#,#arguments.PERIOD_ID#,#arguments.FIS_ID#
                )
        </cfquery>
        <cfreturn replace(serializeJSON(resa),'//','')>
        <!----
            CREATE TABLE workcube_metosan_1.STOCK_FIS_ONAY(ID INT PRIMARY KEY IDENTITY(1,1),RECORD_EMP INT ,RECORD_DATE DATETIME,UNIQUE_RELATION_ID NVARCHAR(150),AMOUNT FLOAT,FIS_PERIOD_ID INT,FIS_ID INT)
        ---->
        </cffunction>
</cfcomponent>