<cfset wrq_Ambar_2=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID,SAME_DEPO","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER")>
<cfset wrq_Sarf_2=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID,SAME_DEPO","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER")>
<cfloop array="#fr_data.CikanUrunler#" item="it" index="i">
    <cfquery name="getRaf" datasource="#dsn3#">
       SELECT PP.SHELF_CODE  FROM PRODUCT_PLACE_ROWS AS PPR
        LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
        WHERE STOCK_ID= #it.stock_id#
    </cfquery>
    <cfset "attributes.SHELF_CODE#i#"=getRaf.shelf_code>
    <cfquery name="getS" datasource="#dsn3#">
    select STORE_ID,LOCATION_ID,PRODUCT_PLACE_ID from PRODUCT_PLACE where SHELF_CODE='#getRaf.shelf_code#'
    </cfquery>
    <CFSET RAF='#getS.STORE_ID#_#getS.LOCATION_ID#'>
    <cfset SUBSL='#getS.STORE_ID#-#getS.LOCATION_ID#'>
    <cfif MainSL neq SUBSL>
        <cfset sameDepo=0>
    <cfelse>
        <cfset sameDepo=1>
    </cfif>
    <cfscript>
        O={
           STORE_ID=getS.STORE_ID,
           LOCATION_ID=getS.LOCATION_ID,
           STOCK_ID=it.STOCK_ID,
           AMOUNT=filternum(it.QUANTITY),
           SHELF_NUMBER=getS.PRODUCT_PLACE_ID,
           SHELF_NUMBER_TXT=getRaf.shelf_code,
           SAME_DEPO=sameDepo           
       };       
  </cfscript>
    <cfif MainSL neq SubSL> <!---- Ambar Fişi Kontrolü----->
    <cfscript>
        queryAddRow(wrq_Ambar_2,O);
    </cfscript>
    
    </cfif>
    <cfscript>
        queryAddRow(wrq_Sarf_2,O);
    </cfscript>
</cfloop>

<cfif wrq_Ambar_2.recordCount gt 0>
    <cfscript>
        AddStockFis(wrq_Ambar_2,87,attributes.V_P_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"),0);
    </cfscript>
</cfif>
<cfif wrq_Sarf_2.recordCount gt 0>
    <cfset iopt=0>
    <cfif wrq_Ambar_2.recordCount gt 0>
        <cfset iopt=1>
    </cfif>
    <cfscript>
        AddStockFis(wrq_Sarf_2,242,attributes.V_P_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"),iopt);
    </cfscript>
</cfif>