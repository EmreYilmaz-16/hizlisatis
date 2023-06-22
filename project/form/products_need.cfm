<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">
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
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>