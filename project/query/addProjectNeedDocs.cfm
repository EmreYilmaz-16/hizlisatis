<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>
<cfdump var="#FormData#">
<cfabort>

<cfif arrayLen(FormData.SEVK)>
    <cfset newQ=queryNew("DEPO,PRODUCT_ID,PRODUCT_NAME,PRODUCT_NEED,PRODUCT_UNIT,PRODUCT_UNIT_ID,STOCK_ID,FOR_PRODUCT_ID,DESCRIPTION","VARCHAR,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER,INTEGER,INTEGER,VARCHAR")>
    <cfscript>
        queryAddRow(newQ,FormData.SEVK);
    </cfscript>
    <cfdump var="#newQ#">


    <cfquery name="newQ2" dbtype="query">
        SELECT * FROM newQ ORDER BY DEPO
    </cfquery>

    <cfoutput>
        <cfloop query="newQ" group="DEPO">
            <cfset attributes.from_position_name="admin">
            <cfset attributes.from_position_code=1>
            <cfset attributes.TO_POSITION_CODE=session.ep.POSITION_CODE>
            <cfset attributes.is_demand=0>
            <cfset attributes.subject="İç Talep">
            <cfset attributes.priority=1>
            <cfset attributes.is_active=1>
            <cfset attributes.project_id=FormData.PROJECT_ID>
            <cfset attributes.process_stage=352>
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
            <cfset attributes.FROM_PROJE=1>
            <cfset attributes.DELIVER_STATUS=0>
            <cfset attributes.OCC=1>
            <cfset attributes.ref_no=FOR_PRODUCT_ID>
            <!---------------------------
                <cfif isDefined("attributes.FROM_PROJE") and len(attributes.FROM_PROJE)>#attributes.FROM_PROJE#<cfelse>0</cfif>,
						<cfif isDefined("attributes.DELIVER_STATUS") and len(attributes.DELIVER_STATUS)>#attributes.DELIVER_STATUS#<cfelse>0</cfif>,
							<cfif isDefined("attributes.OCC") and len(attributes.OCC)>#attributes.OCC#<cfelse>NULL</cfif>
                ------------->
            <cfset i=0>
            <cfloop>
                <cfset i=i+1>
                <cfset "attributes.product_id#i#"=PRODUCT_ID>
                <cfset "attributes.stock_id#i#"=STOCK_ID>
                <cfset "attributes.amount#i#"=PRODUCT_NEED>
                <cfset "attributes.unit#i#"=PRODUCT_UNIT>
                <cfset "attributes.unit_id#i#"=PRODUCT_UNIT_ID>
                <cfset "attributes.product_name#i#"=PRODUCT_NAME>
                <cfset "attributes.product_name_other#i#"=DESCRIPTION>
                
                <cfset "attributes.tax#i#"=0>
                <cfset "attributes.row_activity_id#i#"="">
                <cfset "attributes.row_nettotal#i#"=0>
                <cfset "attributes.row_exp_center_id#i#"="">
                <cfset "attributes.row_exp_item_id#i#"="">
                <cfset "attributes.target_date"="">
                <cfset "attributes.wrk_row_id#i#"="PBS#session.ep.userid##dateFormat(now(),"yyyymmdd")##timeFormat(now(),"hhmmnnl")#_#i#">
            </cfloop>
            <cfset attributes.rows_=i>
            <cfinclude template="add_internaldemand.cfm">				
        </cfloop>
    </cfoutput>
</cfif>
<cfif arrayLen(FormData.TEDARIK)>
    <cfset attributes.is_demand=0>
    <cfset attributes.from_position_name="admin">
    <cfset attributes.from_position_code=1>
    <cfset attributes.TO_POSITION_CODE=session.ep.POSITION_CODE>
    <cfset attributes.subject="Satınalma Talebi">
    <cfset attributes.priority=1>
    <cfset attributes.is_active=1>
    <cfset attributes.project_id=FormData.PROJECT_ID>
    <cfset attributes.process_stage=353>
    
    <cfset attributes.notes="">
    <cfset attributes.BASKET_DISCOUNT_TOTAL=0>
    <cfset attributes.OTHER_MONEY_VALUE =0>
    <cfset attributes.from_position_name=session.ep.POSITION_NAME>
    <cfset attributes.ref_no=FormData.FOR_PRODUCT_ID>
    <cfif len(session.ep.USER_LOCATION) and listlen(session.ep.USER_LOCATION) eq 2>
        <cfset attributes.emp_department_id=listGetAt(session.ep.USER_LOCATION,1,"-")>
        <cfset attributes.emp_department=listGetAt(session.ep.USER_LOCATION,1,"-")>     
    </cfif>
    <cfset attributes.FROM_PROJE=1>
            <cfset attributes.DELIVER_STATUS=0>
            <cfset attributes.OCC=2>
    <cfset attributes.rows_=arrayLen(FormData.TEDARIK)>
    <cfset i=1>
    <cfloop array="#FormData.TEDARIK#" item="it">
        <cfset "attributes.product_id#i#"=it.PRODUCT_ID>
        <cfset "attributes.stock_id#i#"=it.STOCK_ID>
        <cfset "attributes.amount#i#"=it.PRODUCT_NEED>
        <cfset "attributes.unit#i#"=it.PRODUCT_UNIT>
        <cfset "attributes.unit_id#i#"=it.PRODUCT_UNIT_ID>
        <cfset "attributes.product_name#i#"=it.PRODUCT_NAME>
        <cfset "attributes.product_name_other#i#"=it.DESCRIPTION>
        <cfset "attributes.tax#i#"=0>
        <cfset "attributes.row_activity_id#i#"="">
        <cfset "attributes.row_nettotal#i#"=0>
        <cfset "attributes.row_exp_center_id#i#"="">
        <cfset "attributes.row_exp_item_id#i#"="">
        <cfset "attributes.target_date"=""> 
        <cfset "attributes.wrk_row_id#i#"="PBS#session.ep.userid##dateFormat(now(),"yyyymmdd")##timeFormat(now(),"hhmmnnl")#_#i#">
        <cfset i=i+1>
    </cfloop>
    <cfinclude template="add_internaldemand.cfm">
</cfif>

<cfif arrayLen(FormData.URETIM)>
 
</cfif>

<script>
    window.opener.location.reload();
   this.close();
</script>