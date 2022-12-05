<cfquery name="GETp" datasource="#DSN3#">
select S.PRODUCT_NAME,S.PRODUCT_CODE_2,S.PRODUCT_ID,S.STOCK_ID from #dsn1#.SETUP_COMPANY_STOCK_CODE  SCS
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=SCS.STOCK_ID
where SCS.COMPANY_ID=#attributes.cp_id#
</cfquery>

<cf_box title="Müşteri Ürünleri">
    <cf_grid_list>
        <tr>
            <th>#</th>
            <th>Ürün Kodu</th>
            <th>Ürün Adı</th>
        </tr>
        <cfoutput query="GETp">
            <td>
                #currentrow#
            </td>
            <td>
                <a href="javascript://" onclick="setProduct('#PRODUCT_NAME#','#PRODUCT_ID#','#STOCK_ID#')" ><span class="menuTitle">#PRODUCT_CODE_2#</span></a>
            </td>
            <td>
                <a href="javascript://" onclick="setProduct('#PRODUCT_NAME#','#PRODUCT_ID#','#STOCK_ID#')"><span class="menuTitle">#PRODUCT_NAME#</span></a>
            </td>
        </cfoutput>
    </cf_grid_list>
</cf_box>
<cfoutput>
<script>

    function setProduct(name,id1,id2){
        window.opener.#field_id#.value=id2
        window.opener.#field_name#.value=name
        window.opener.#product_id#.value=id1
    }
</script>
</cfoutput>