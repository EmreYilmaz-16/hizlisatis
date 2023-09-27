<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">


<cf_box title="Malzeme İhtiyaçları">
    <div class="form-group">
        <select name="PRODUCT">
            <option value="">Seçiniz</option>
            <cfquery name="getVP" datasource="#dsn3#">
                SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID=#attributes.PROJECT_ID#
            </cfquery>
            <cfoutput>
                <optgroup label="Sanal Ürünler">
                <cfloop query="getVp">
                    <option value="#1#_#VIRTUAL_PRODUCT_ID#">#PRODUCT_NAME#</option>
                </cfloop>
            </optgroup>
            <optgroup label="Gerçek Ürünler">
                <cfquery name="getRp" datasource="#dsn3#">
                    SELECT * FROM STOCKS WHERE PROJECT_ID=#attributes.PROJECT_ID#
                </cfquery>
                <cfloop query="getRp">
                    <option value="#0#_#PRODUCT_ID#">#PRODUCT_NAME#</option>
                </cfloop>
            </optgroup>
            </cfoutput>
        </select>
    </div>
    <div id="productNeed">
        
    </div>
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
        <th>İhtiyaç</th>
        <th>Aşama</th>
    </tr>
</thead>
<tbody>
    <cfoutput query="getProjectNeeds">
        <tr style="<cfif IS_VIRTUAL eq 1>background:##ff00006b<cfelse></cfif>">
            <cfset dvv=-1>
            <cfif IS_VIRTUAL eq 1>                
                <cfquery name="getc" datasource="#dsn3#">
                    SELECT PORCURRENCY FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
                </cfquery>
                <cfset dvv=getc.PORCURRENCY>
            </cfif>
            <td>
                #PRODUCT_NAME#
            </td>
            <td>
                #PRODUCT_CAT#
            </td>
            <td style="text-align:right">#tlformat(BAKIYE)# #MAIN_UNIT#</td>
            <td style="text-align:right">#tlformat(AMOUNT)# #MAIN_UNIT#</td>
            <td><input type="text" value="#TLFORMAT(BAKIYE-AMOUNT)#" name="IHTIYAC_#currentrow#"></td>
            <td>
                <select name="orderrow_currency_#currentrow#" id="orderrow_currency_#currentrow#">
                    <option <cfif dvv eq -1>selected</cfif> value="-1">Açık</option>
                    <option <cfif dvv eq -2>selected</cfif> value="-2">Tedarik</option>
                    <option <cfif dvv eq -5>selected</cfif> value="-5">Üretim</option>
                    <option <cfif dvv eq -6>selected</cfif> value="-6">Sevk</option>                                        
                    <option <cfif dvv eq -10>selected</cfif> value="-10">Kapatıldı</option>
                    <option <cfif dvv eq 1>selected</cfif> value="1">Fiyat Talep</option>
                </select>
                <input type="hidden" name="product_id_#currentrow#" value="#PRODUCT_ID#">
                <input type="hidden" name="is_virtual_#currentrow#" value="#IS_VIRTUAL#">
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
</cf_box>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>