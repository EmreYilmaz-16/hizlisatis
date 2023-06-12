<cf_box title="Malzeme İhtiyaçları">
<cfquery name="getProjectNeeds" datasource="#dsn3#">
    EXEC GET_PROJECT_NEED_PBS #attributes.PROJECT_ID#
</cfquery>

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
                #PRODUCT_CAT#
            </td>
            <td>
                #tlformat(AMOUNT)#
            </td>
        </tr>
    </cfoutput>
</cf_grid_list>
</cf_box>