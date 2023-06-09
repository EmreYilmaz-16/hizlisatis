<cfquery name="getProjectNeeds" datasource="#dsn3#">
    EXEC GET_PROJECT_NEEDS #attributes.PROJECT_ID#
</cfquery>
<cfdump var="#getProjectNeeds#">
<cf_grid_list>
    <tr>
        <th>
            
        </th>
    </tr>
    <cfoutput query="getProjectNeeds">
        <tr style="<cfif IS_VIRTUAL eq 1>background:##ff00006b<cfelse></cfif>">
            <td>
                #PRODUCT_NAME#
            </td>
            <td>
                #tlformat(COMPUTED_COLUMN_1)#
            </td>
        </tr>
    </cfoutput>
</cf_grid_list>