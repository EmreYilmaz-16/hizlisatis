<cf_box title="Malzeme İhtiyaçları">
<cfquery name="getProjectNeeds" datasource="#dsn3#">
    EXEC GET_PROJECT_NEED_PBS #attributes.PROJECT_ID#
</cfquery>

<cf_grid_list>
    <thead>
    <tr>
        <th>
            Ürün
        </th>
        <th>Ürün Kategorisi</th>
        <th>Bakiye</th>
        <th>
            Miktar 
        </th>
    </tr>
</thead>
<tbody>
    <cfoutput query="getProjectNeeds">
        <tr style="<cfif IS_VIRTUAL eq 1>background:##ff00006b<cfelse></cfif>">
            
            <td>
                #PRODUCT_NAME#
            </td>
            <td>
                #PRODUCT_CAT#
            </td>
            <td style="text-align:right">#tlformat(BAKIYE)# #MAIN_UNIT#</td>
            <td style="text-align:right">#tlformat(AMOUNT)# #MAIN_UNIT#</td>
            
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>