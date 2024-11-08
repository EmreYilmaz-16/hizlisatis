
<cfset attributes.PRODUCT_ID=listGetAt(attributes.pidow,2,"_")>
<cfset attributes.IS_VIRTUAL=listGetAt(attributes.pidow,1,"_")>
<cfset attributes.PROJECT_ID=listGetAt(attributes.pidow,3,"_")>
<cfquery name="GETKO" datasource="#DSN3#">
    SELECT * FROM PBS_OFFER AS PO 
    LEFT JOIN PBS_OFFER_ROW AS POR ON POR.OFFER_ID=PO.OFFER_ID 
    WHERE PROJECT_ID=#attributes.PROJECT_ID# AND POR.STOCK_ID=#attributes.PRODUCT_ID#
</cfquery>

    <cfquery name="getProjectNeeds" datasource="#dsn3#">
     <CFIF attributes.IS_VIRTUAL EQ 1>   EXEC GET_VIRTUAL_PRODUCT_NEED_PBS #attributes.PRODUCT_ID# <CFELSE>
       WITH  UA AS (
SELECT PT.STOCK_ID, PT.RELATED_ID, PT.AMOUNT, PT.AMOUNT * 1 AS BOM_AMOUNT,1 AS SV
  FROM workcube_metosan_1.PRODUCT_TREE PT(NOLOCK)
 WHERE PT.STOCK_ID in (#attributes.PRODUCT_ID#)
 
 UNION ALL
   
SELECT PT.STOCK_ID, PT.RELATED_ID, PT.AMOUNT, PT.AMOUNT * UA.BOM_AMOUNT,UA.SV+1 AS SV
  FROM workcube_metosan_1.PRODUCT_TREE PT(NOLOCK), UA
  where UA.RELATED_ID = PT.STOCK_ID
)
select UA.AMOUNT AS AMOUNT_1,UA.BOM_AMOUNT AS AMOUNT,S.PRODUCT_NAME,S.PRODUCT_CODE,CONVERT(DECIMAL(18,2),ISNULL(RAF.BAKIYE,0)) AS BAKIYE,0 AS IS_VIRTUAL,S.STOCK_ID,S.PRODUCT_ID,PU.MAIN_UNIT,PC.PRODUCT_CAT,PU.PRODUCT_UNIT_ID,RAF.DEF_DEPO,UA.BOM_AMOUNT,RAF.SHELF_CODE
,UA.SV
    
 FROM UA
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=UA.RELATED_ID
LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND PU.IS_MAIN=1
LEFT JOIN workcube_metosan_product.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=S.PRODUCT_CATID
OUTER APPLY
(
    SELECT TOP 1 SHELF_CODE,(SELECT SUM(CONVERT(DECIMAL(18,2),STOCK_IN)-CONVERT(DECIMAL(18,2),STOCK_OUT)) FROM workcube_metosan_2024_1.STOCKS_ROW WHERE 1=1 
    --AND STORE=PP.STORE_ID AND STORE_LOCATION=PP.LOCATION_ID 
    AND STOCK_ID=S.STOCK_ID) AS BAKIYE,
    CONVERT(varchar,PP.STORE_ID)+'-'+CONVERT(varchar,PP.LOCATION_ID) AS DEF_DEPO
     FROM workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR 
    LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
    WHERE PPR.STOCK_ID=S.STOCK_ID
) AS RAF 
    </CFIF>
    </cfquery>

<cfdump var="#getProjectNeeds#">


    <cf_grid_list>
        <thead>
        <tr>
            <th>
                Ürün
            </th>
            <th>Ürün Kategorisi</th>
            <th>Bakiye</th>
            <th>B.Miktar</th>
            <th>
               T. Miktar 
            </th>
            <th>İhtiyaç</th>
            <th>Bekleyen</th>
            <th>Sevk Bekleyen</th>
            <th>Tedarik Bekleyen</th>
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
                <td id="bky_#currentrow#" style="text-align:right">#tlformat(BAKIYE)# #MAIN_UNIT#</td>
                <td style="text-align:right">
                    <cfif attributes.IS_VIRTUAL eq 1><cfelse>
                    #tlformat(GETKO.QUANTITY*AMOUNT_1)# #MAIN_UNIT#</cfif></td>
                <td id="TMK_#currentrow#" style="text-align:right">#tlformat(GETKO.QUANTITY*AMOUNT)# #MAIN_UNIT#</td>
                <cfset OSFFF=0>
                <cfset OSFFFST=0>
                <cfset OSFFFIC=0>
                <cfif attributes.IS_VIRTUAL EQ 0>
                <cfquery name="ihes" datasource="#dsn3#">
                    SELECT * FROM (
SELECT IR.STOCK_ID,IR.QUANTITY,I.DEMAND_TYPE AS ISLEM,I.INTERNAL_NUMBER AS PP_NUMBER FROM workcube_metosan_1.INTERNALDEMAND_ROW AS IR
	LEFT JOIN workcube_metosan_1.INTERNALDEMAND AS I ON I.INTERNAL_ID=IR.I_ID		
	WHERE 1=1 AND I.PROJECT_ID=#attributes.PROJECT_ID# AND I.REF_NO='#attributes.PRODUCT_ID#'
UNION	
SELECT STOCK_ID,QUANTITY,2 AS ISLEM,P_ORDER_NO AS PP_NUMBER FROM workcube_metosan_1.PRODUCTION_ORDERS WHERE PROJECT_ID=#attributes.PROJECT_ID#
) AS T  WHERE STOCK_ID =#STOCK_ID#
                </cfquery>
                
                <cfloop query="ihes">
                    <cfset OSFFF=OSFFF+QUANTITY>
                    <CFIF ISLEM EQ 0>
                        <CFSET OSFFFIC=OSFFFIC+QUANTITY>
                    <cfelse>   
                        <CFSET OSFFFST=OSFFFST+QUANTITY>
                    </CFIF>
                </cfloop>
                
                <cfelse>
                    <cfset ihes.QUANTITY=0>
                    <cfset ihes.ISLEM=-1>
                </cfif>
                <CFIF LEN(ihes.QUANTITY)>
                    <CFSET IHSQ=ihes.QUANTITY>
                <CFELSE>
                    <CFSET IHSQ=0>
                </CFIF>
                <CFIF LEN(ihes.ISLEM)>
                    <CFSET ISLEMCIM=ihes.ISLEM>
                <CFELSE>
                    <CFSET ISLEMCIM=-1>
                </CFIF>
                
                <cfset IHTIYAC=(BAKIYE-AMOUNT)+OSFFF>                
                <td><input onchange="ihtiyacKontrol(this,#currentrow#)"  type="text" value="<cfif IHTIYAC lt 0>#IHTIYAC*-1#<cfelse><cfif IHTIYAC gt 0>0<cfelse>#IHTIYAC#</cfif></cfif>" name="IHTIYAC_#currentrow#" id="IHTIYAC_#currentrow#"></td>
                
                    <td style="text-align:right"><span id="tms_#currentrow#" onclick="">#tlformat(OSFFF)#</span></td>
                    <td style="text-align:right"><span onclick="">#tlformat(OSFFFIC)#</span></td>
                    <td style="text-align:right"><span onclick="">#tlformat(OSFFFST)#</span></td>
                <td>
                    <select name="orderrow_currency_#currentrow#"  id="orderrow_currency_#currentrow#">
                        <option <cfif ISLEMCIM eq -1>selected</cfif> value="-1">Açık</option>
                        <option <cfif ISLEMCIM eq 1>selected</cfif> value="-2">Tedarik</option>
                        
                        <option <cfif ISLEMCIM eq 0>selected</cfif> value="-6">Sevk</option>                                        
                        
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
        <button id="buton1" type="button" class="btn btn-success" onclick="saveIhtiyac()">Kaydet</button>
    </cfif>
    
