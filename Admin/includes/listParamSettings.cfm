<cf_box title="Kategori Parametreleri">
<cfquery name="getList" datasource="#dsn3#" result="RES">
    select PCS.*,PC.PRODUCT_CAT,PC.HIERARCHY from workcube_metosan_1.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS PCS
INNER JOIN workcube_metosan_product.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=PCS.PRODUCT_CATID
</cfquery>
<cf_big_list>
    <thead>
    <tr>
        <cfloop list="#RES.COLUMNLIST#" item="li">
            <cfscript>
                pos = ArrayFilter(ColumnData, function(item) {
                return item.column_name == '#li#';
            });
            </cfscript>
            <cfoutput>
                <th>
                    #pos#
                </th>
            </cfoutput>
        </cfloop>
    </tr>
</thead>
<tbody>
    <cfoutput query="getList">
        <tr>
            <cfloop list="#RES.COLUMNLIST#" item="li">
               
                    <td>
                        #evaluate("#li#")#
                    </td>
               
            </cfloop>   
            <td>
                <a href="#request.self#?fuseaction=#attributes.fuseaction#&event=upd&id=#ID#">Güncelle</a>
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_big_list>
</cf_box>