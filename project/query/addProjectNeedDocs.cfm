<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfif arrayLen(FormData.SEVK)>
    <cfset newQ=queryNew("DEPO,PRODUCT_ID,PRODUCT_NAME,PRODUCT_NEED,PRODUCT_UNIT,PRODUCT_UNIT_ID,STOCK_ID","VARCHAR,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER,INTEGER")>
    <cfscript>
        queryAddRow(newQ,FormData.SEVK);
    </cfscript>
    <cfquery name="newQ2" dbtype="query">
        SELECT * FROM newQ ORDER BY DEPO
    </cfquery>
    <cfoutput>
        <cfloop query="newQ" group="DEPO">
            <cfset attributes.from_position_code=session.ep.POSITION_CODE>
            <cfset attributes.TO_POSITION_CODE=session.ep.POSITION_CODE>
            <cfset attributes.is_demand=0>
            <cfset attributes.subject="İç Talep">
            <cfset attributes.priority=1>
            <cfset attributes.is_active=1>
            <cfset attributes.project_id=FormData.PROJECT_ID>
            <cfset attributes.process_stage=277>
            <cfset attributes.notes="">
            <cfset attributes.BASKET_DISCOUNT_TOTAL=0>
            <cfset attributes.OTHER_MONEY_VALUE =0>
            <cfset attributes.from_position_name=session.ep.POSITION_NAME>
            <cfif len(session.ep.USER_LOCATION) and listlen(session.ep.USER_LOCATION) eq 2>
                <cfset attributes.emp_department_id=listGetAt(session.ep.USER_LOCATION,1,"-")>
                <cfset attributes.emp_department=listGetAt(session.ep.USER_LOCATION,1,"-")>
            </cfif>
            <cfset attributes.department_in_id=45>
            <cfset department_in_txt="45">
            <cfset attributes.location_in_id=1>
            <cfset attributes.department_id=listGetAt(DEPO,1,"-")>
            <cfset txt_departman_=listGetAt(DEPO,1,"-")>
            <cfset attributes.location_id=listGetAt(DEPO,2,"-")>
            <cfset i=0>
            <cfloop>
                <cfset i=i+1>
                <cfset "attributes.product_id#i#"=PRODUCT_ID>
                <cfset "attributes.stock_id#i#"=STOCK_ID>
                <cfset "attributes.amount#i#"=PRODUCT_NEED>
                <cfset "attributes.unit#i#"=PRODUCT_UNIT>
                <cfset "attributes.unit_id#i#"=PRODUCT_UNIT_ID>
                <cfset "attributes.product_name#i#"=PRODUCT_NAME>
                <cfset "attributes.tax#i#"=0>
                <cfset "attributes.row_activity_id#i#"="">
                <cfset "attributes.row_nettotal#i#"=0>
                <cfset "attributes.row_exp_center_id#i#"="">
                <cfset "attributes.row_exp_item_id#i#"="">
                <cfset "attributes.target_date"="">
            </cfloop>
            <cfset attributes.rows_=i>
            <cfinclude template="add_internaldemand.cfm">				
        </cfloop>
    </cfoutput>
</cfif>
<cfif arrayLen(FormData.TEDARIK)>
    <cfset attributes.is_demand=1>
    <cfset attributes.from_position_code=session.ep.POSITION_CODE>
    <cfset attributes.TO_POSITION_CODE=session.ep.POSITION_CODE>
    <cfset attributes.subject="Satınalma Talebi">
    <cfset attributes.priority=1>
    <cfset attributes.is_active=1>
    <cfset attributes.project_id=FormData.PROJECT_ID>
    <cfset attributes.process_stage=345>
    <CFSET attributes.process_cat=164>
    <cfset attributes.notes="">
    <cfset attributes.BASKET_DISCOUNT_TOTAL=0>
    <cfset attributes.OTHER_MONEY_VALUE =0>
    <cfset attributes.from_position_name=session.ep.POSITION_NAME>
    <cfif len(session.ep.USER_LOCATION) and listlen(session.ep.USER_LOCATION) eq 2>
        <cfset attributes.emp_department_id=listGetAt(session.ep.USER_LOCATION,1,"-")>
        <cfset attributes.emp_department=listGetAt(session.ep.USER_LOCATION,1,"-")>     
    </cfif>
    <cfset attributes.rows_=arrayLen(FormData.TEDARIK)>
    <cfset i=1>
    <cfloop array="#FormData.TEDARIK#" item="it">
        <cfset "attributes.product_id#i#"=it.PRODUCT_ID>
        <cfset "attributes.stock_id#i#"=it.STOCK_ID>
        <cfset "attributes.amount#i#"=it.PRODUCT_NEED>
        <cfset "attributes.unit#i#"=it.PRODUCT_UNIT>
        <cfset "attributes.unit_id#i#"=it.PRODUCT_UNIT_ID>
        <cfset "attributes.product_name#i#"=it.PRODUCT_NAME>
        <cfset "attributes.tax#i#"=0>
        <cfset "attributes.row_activity_id#i#"="">
        <cfset "attributes.row_nettotal#i#"=0>
        <cfset "attributes.row_exp_center_id#i#"="">
        <cfset "attributes.row_exp_item_id#i#"="">
        <cfset "attributes.target_date"=""> 
        <cfset i=i+1>
    </cfloop>
    <cfinclude template="add_internaldemand.cfm">
</cfif>

<cfif arrayLen(FormData.URETIM)>
    <cfloop array="#FormData.URETIM#">
        
    </cfloop>
</cfif>