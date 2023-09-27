﻿
<cfset attributes.PRODUCT_ID=listGetAt(attributes.pidow,2,"_")>
<cfset attributes.IS_VIRTUAL=listGetAt(attributes.pidow,1,"_")>

    <cfquery name="getProjectNeeds" datasource="#dsn3#">
     <CFIF attributes.IS_VIRTUAL EQ 1>   EXEC GET_VIRTUAL_PRODUCT_NEED_PBS #attributes.PRODUCT_ID# <CFELSE>
        EXEC GET_REAL_PRODUCT_NEED_PBS #attributes.PRODUCT_ID#
    </CFIF>
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
    <tbody id="rowws">
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
                <td><input type="text" value="<CFIF BAKIYE-AMOUNT LT 0>#-1*(BAKIYE - AMOUNT)#<CFELSE>0</CFIF> " name="IHTIYAC_#currentrow#"></td>
                <td>
                    <select name="orderrow_currency_#currentrow#" id="orderrow_currency_#currentrow#">
                        <option <cfif dvv eq -1>selected</cfif> value="-1">Açık</option>
                        <option <cfif dvv eq -2>selected</cfif> value="-2">Tedarik</option>
                        <option <cfif dvv eq -5>selected</cfif> value="-5">Üretim</option>
                        <option <cfif dvv eq -6>selected</cfif> value="-6">Sevk</option>                                        
                        <option <cfif dvv eq -10>selected</cfif> value="-10">Kapatıldı</option>
                        <option <cfif dvv eq 1>selected</cfif> value="1">Fiyat Talep</option>
                    </select>
                    <input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#PRODUCT_ID#">
                    <input type="hidden" name="is_virtual_#currentrow#" id="is_virtual_#currentrow#" value="#IS_VIRTUAL#">
                </td>
            </tr>
        </cfoutput>
    </tbody>
    </cf_grid_list>

    


