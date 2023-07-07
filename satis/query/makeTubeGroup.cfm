<cfdump var="#attributes#">

<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<CFSET PRODUCT_CAT_ID=attributes.PRODUCT_CATID>