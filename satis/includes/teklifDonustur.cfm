<cfdump var="#attributes#">
<cfset FormData=deserializeJSON(attributes.data)>
<cfdump var="#FormData#">
<cfset attributes.type_id=FormData.company_id>
<cfset attributes.q_type="CompanyInfo">
<cfinclude template="../includes/getCompInfoQuery.cfm">