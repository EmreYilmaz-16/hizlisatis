
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
            <th>Bekleyen</th>
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
                <td id="product_name_#currentrow#">#PRODUCT_NAME#</td>
                <td>
                    #PRODUCT_CAT#
                </td>
                <td style="text-align:right">#tlformat(BAKIYE)# #MAIN_UNIT#</td>
                <td style="text-align:right">#tlformat(AMOUNT)# #MAIN_UNIT#</td>
                <cfif attributes.IS_VIRTUAL EQ 0>
                <cfquery name="ihes" datasource="#dsn3#">
                    SELECT * FROM (
SELECT IR.STOCK_ID,IR.QUANTITY,I.DEMAND_TYPE AS ISLEM,I.INTERNAL_NUMBER AS PP_NUMBER FROM workcube_metosan_1.INTERNALDEMAND_ROW AS IR
	LEFT JOIN workcube_metosan_1.INTERNALDEMAND AS I ON I.INTERNAL_ID=IR.I_ID		
	WHERE 1=1 AND I.PROJECT_ID=#attributes.PROJECT_ID#
UNION	
SELECT STOCK_ID,QUANTITY,2 AS ISLEM,P_ORDER_NO AS PP_NUMBER FROM workcube_metosan_1.PRODUCTION_ORDERS WHERE PROJECT_ID=#attributes.PROJECT_ID#
) AS T  WHERE STOCK_ID =#STOCK_ID#
                </cfquery>
                <cfelse>
                    <cfset ihes.QUANTITY=0>
                    <cfset ihes.ISLEM=0>
                </cfif>                
                <td><input type="text" value="<CFIF BAKIYE-AMOUNT LT 0>#-1*(BAKIYE - AMOUNT)#<CFELSE>0</CFIF> " name="IHTIYAC_#currentrow#" id="IHTIYAC_#currentrow#"></td>
                <td>#ihes.QUANTITY#</td>
                <td>
                    <select name="orderrow_currency_#currentrow#" id="orderrow_currency_#currentrow#">
                        <option <cfif ihes.islem eq -1>selected</cfif> value="-1">Açık</option>
                        <option <cfif ihes.islem eq 1>selected</cfif> value="-2">Tedarik</option>
                        <option <cfif ihes.islem eq 2>selected</cfif> value="-5">Üretim</option>
                        <option <cfif ihes.islem eq 0>selected</cfif> value="-6">Sevk</option>                                        
                        <option <cfif ihes.islem eq -10>selected</cfif> value="-10">Kapatıldı</option>
                        <option <cfif ihes.islem eq 1>selected</cfif> value="1">Fiyat Talep</option>
                    </select>
                    <input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#PRODUCT_ID#">
                    <cfif isDefined("getProjectNeeds.STOCK_ID")>
                    <input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#STOCK_ID#">
                    <cfelse>
                        <input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="##">
                </cfif>
                    <input type="hidden" name="is_virtual_#currentrow#" id="is_virtual_#currentrow#" value="#IS_VIRTUAL#">
                   <cfif isDefined("getProjectNeeds.PRODUCT_UNIT_ID")>
                    <input type="hidden" name="unit_id_#currentrow#" id="unit_id_#currentrow#" value="#PRODUCT_UNIT_ID#">
                    <input type="hidden" name="unit_#currentrow#" id="unit_#currentrow#" value="#MAIN_UNIT#">
                </cfif>
                <cfif isDefined("getProjectNeeds.DEF_DEPO")>
                    <input type="hidden" name="depo_#currentrow#" id="depo_#currentrow#" value="#DEF_DEPO#">
                    
                </cfif>
                </td>
            </tr>
        </cfoutput>
    </tbody>
    </cf_grid_list>
    <cfif attributes.IS_VIRTUAL eq 0>
        <button type="button" class="btn btn-success" onclick="saveIhtiyac()">Kaydet</button>
    </cfif>
    
