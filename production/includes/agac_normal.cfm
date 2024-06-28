<cfoutput>
    <cfloop query="getsTree">
    <tr>
        <th></th>
        <td>#PRODUCT_NAME#</td>
        <td>#AMOUNT#</td>
        <td>#MAIN_UNIT#</td>
    </tr>
    </cfloop>
    </cfoutput>