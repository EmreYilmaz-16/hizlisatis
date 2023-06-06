<cfdump var="#attributes#">
<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfquery name="getFr" datasource="#dsn3#">
        SELECT PCPS.*,PC.HIERARCHY,PC.PRODUCT_CAT,PC.DETAIL FROM #DSN#.PRO_PROJECTS AS PP
LEFT JOIN #DSN#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT AS MPTC ON MPTC.MAIN_PROCESS_CATID=SMC.MAIN_PROCESS_CAT_ID
LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=MPTC.PRODUCT_CATID
LEFT JOIN #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS as PCPS ON PCPS.PRODUCT_CATID=PC.PRODUCT_CATID
WHERE PP.PROJECT_ID=#FormData.PROJECT_ID#
</cfquery>


<cfif FormData.PRODUCT_ID neq 0 and len(FormData.PRODUCT_ID)>

<cfelse>
    <!----
<cfscript>
   CreatedProduct= CreateVirtualProduct(
        FormData.PRODUCT_NAME,
        getFr.PRODUCT_CATID,
        0,
        0,
        99,
        1,
        '',
        getFr.PRODUCT_UNIT,
        FormData.PROJECT_ID,
        '0',
        FormData.PRODUCT_STAGE,
        -6
    );
    CreatedProductId=CreatedProduct.IDENTITYCOL
</cfscript>
<cfdump var="#CreatedProduct#">---->
<cfif arrayLen(FormData.PRODUCT_TREE)>
<cfloop array="#FormData.PRODUCT_TREE#" index="ai">
<cfdump var="#ai#">
</cfloop>
</cfif>
</cfif>


<cfdump var="#getFr#">

<cffunction name="CreateVirtualProduct">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRICE">
    <cfargument name="MARJ">
    <cfargument name="PRODUCT_TYPE">
    <cfargument name="IS_PRODUCTION">
    <cfargument name="PRODUCT_DESCRIPTION">
    <cfargument name="PRODUCT_UNIT">
    <cfargument name="PROJECT_ID">
    <cfargument name="PRODUCT_VERSION">
    <cfargument name="PRODUCT_STAGE">
    <cfargument name="PORCURRENCY">

   <cfquery name="ins" datasource="#dsn3#" result="res">
    INSERT INTO VIRTUAL_PRODUCTS_PRT (
        PRODUCT_NAME,
        PRODUCT_CATID,
        PRICE,
        MARJ,
        PRODUCT_TYPE,
        IS_CONVERT_REAL,
        IS_PRODUCTION,
        RECORD_EMP,
        RECORD_DATE,
        PRODUCT_DESCRIPTION,
        PRODUCT_UNIT,
        PROJECT_ID,
        PRODUCT_VERSION,
        PRODUCT_STAGE,
        PORCURRENCY
    )
    VALUES (
        '#arguments.PRODUCT_NAME#',
        #arguments.PRODUCT_CATID#,
        #arguments.PRICE#,
        #arguments.MARJ#,
        #arguments.PRODUCT_TYPE#,
        0,
        #arguments.IS_PRODUCTION#,
        #session.ep.userid#,
        GETDATE(),
        '#arguments.PRODUCT_DESCRIPTION#',
        '#arguments.PRODUCT_UNIT#',
        #arguments.PROJECT_ID#,
        '#arguments.PRODUCT_VERSION#',
        #arguments.PRODUCT_STAGE#,
        #arguments.PORCURRENCY#
    )
   </cfquery>
<cfreturn res>
</cffunction>

<cffunction name="UpdateVirtualProduct">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRICE">
    <cfargument name="MARJ">
    <cfargument name="PRODUCT_TYPE">
    <cfargument name="IS_PRODUCTION">
    <cfargument name="PRODUCT_DESCRIPTION">
    <cfargument name="PRODUCT_UNIT">
    <cfargument name="PROJECT_ID">
    <cfargument name="PRODUCT_VERSION">
    <cfargument name="PRODUCT_STAGE">
    <cfargument name="PORCURRENCY">
    <cfargument name="VIRTUAL_PRODUCT_ID">
<cfquery name="UPD" datasource="#DSN3#">
UPDATE VIRTUAL_PRODUCTS_PRT
SET PRODUCT_NAME = '#arguments.PRODUCT_NAME#'
	,PRODUCT_CATID = #arguments.PRODUCT_CATID#
	,PRICE = #arguments.PRICE#
	,MARJ = #arguments.MARJ#
	,PRODUCT_TYPE = #arguments.PRODUCT_TYPE#
	,IS_CONVERT_REAL = 0 
    ,IS_PRODUCTION = #arguments.IS_PRODUCTION#
	,UPDATE_EMP = #session.ep.userid#
	,UPDATE_DATE = GETDATE()
	,PRODUCT_DESCRIPTION = '#arguments.PRODUCT_DESCRIPTION#'
	,PRODUCT_UNIT = '#arguments.PRODUCT_UNIT#'
	,PROJECT_ID = #arguments.PROJECT_ID#
	,PRODUCT_VERSION = '#arguments.PRODUCT_VERSION#'
	,PRODUCT_STAGE = #arguments.PRODUCT_STAGE#
	,PORCURRENCY = #arguments.PORCURRENCY#
    WHERE VIRTUAL_PRODUCT_ID=#arguments.VIRTUAL_PRODUCT_ID#
    
</cfquery>
    
   

</cffunction>

<cffunction name="InsertTree">
    <cfargument name="VP_ID">
    <cfargument name="PRODUCT_ID">
    <cfargument name="STOCK_ID">
    <cfargument name="AMOUNT">
    <cfargument name="QUESTION_ID">
    <cfargument name="PRICE">
    <cfargument name="DISCOUNT">
    <cfargument name="MONEY">
    <cfargument name="IS_VIRTUAL">

<cfquery name="ins" datasource="#dsn3#" result="res">
    

    INSERT INTO VIRTUAL_PRODUCT_TREE_PRT (    
    VP_ID,
    PRODUCT_ID,
    STOCK_ID,
    AMOUNT,
    QUESTION_ID,
    PRICE,
    DISCOUNT,
    MONEY,
    IS_VIRTUAL
    )
    VALUES(
        #arguments.VP_ID#,
    #arguments.PRODUCT_ID#,
    #arguments.STOCK_ID#,
    #arguments.AMOUNT#,
    #arguments.QUESTION_ID#,
    #arguments.PRICE#,
    #arguments.DISCOUNT#,
    '#arguments.MONEY#',
    #arguments.IS_VIRTUAL#
    )

</cfquery>
<cfreturn res>
</cffunction>