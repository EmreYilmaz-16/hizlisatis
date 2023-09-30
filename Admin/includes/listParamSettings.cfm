<cf_box title="Kategori Parametreleri">
<cfquery name="getList" datasource="#dsn3#" result="RES">
    select PCS.*,PC.PRODUCT_CAT,PC.HIERARCHY from #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS AS PCS
INNER JOIN workcube_metosan_product.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=PCS.PRODUCT_CATID
</cfquery>
<cfset YenListe=ListSort(RES.COLUMNLIST,'text',"asc")>

<cf_big_list>
    <thead>
    <tr>
        <cfloop list="#YenListe#" item="li">
            <cfscript>
                pos = ArrayFilter(ColumnData, function(item) {
                return item.column_name == '#li#';
            })[1];
            </cfscript>
            <cfoutput>
                <th>
                    #pos.descr#
                  
                </th>
            </cfoutput>
        </cfloop>
        <th>
            <cfoutput><a href="#request.self#?fuseaction=#attributes.fuseaction#&ev=add">+</a></cfoutput>
        </th>
    </tr>
</thead>
<tbody>
    <cfoutput query="getList">
        <tr>
            <cfloop list="#YenListe#" item="li">
               
                    <td>
                        #evaluate("#li#")#
                    </td>
               
            </cfloop>   
            <td>
                <a href="#request.self#?fuseaction=#attributes.fuseaction#&ev=upd&id=#ID#">Güncelle</a>
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_big_list>
</cf_box>