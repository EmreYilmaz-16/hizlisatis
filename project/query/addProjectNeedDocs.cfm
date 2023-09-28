<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfif arrayLen(FormData.SEVK)>

</cfif>
<cfif arrayLen(FormData.TEDARIK)>
<!---- Satınalma Talebi Kayıt ---->     

<!---select *,TO_POSITION_CODE,SUBJECT,FROM_POSITION_CODE,PROJECT_ID,INTERNALDEMAND_STAGE,INTERNAL_NUMBER,IS_ACTIVE,RECORD_EMP,DEMAND_TYPE,PROCESS_CAT,DEPARTMENT_ID from workcube_metosan_1.INTERNALDEMAND where INTERNAL_ID=9102--->
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
</cfloop>
<!----
    PROCESS_CAT	INTERNALDEMAND_STAGE	DEPARTMENT_ID
        164	            345	                8
----->
<cfinclude template="add_internaldemand.cfm">

</cfif>

<cfif arrayLen(FormData.URETIM)>
    
</cfif>