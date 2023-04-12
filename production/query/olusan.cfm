<cfset wrq_Sarf_4=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID,SAME_DEPO","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER")>


<cfscript>
    O={
       STORE_ID=getS12.STORE_ID,
       LOCATION_ID=getS12.LOCATION_ID,
       STOCK_ID=getData.CREATED_SID,
       AMOUNT=1,
       SHELF_NUMBER=getS12.PRODUCT_PLACE_ID,
       SHELF_NUMBER_TXT=getRaf12.shelf_code,
       SAME_DEPO=sameDepo           
   };       
   queryAddRow(wrq_Sarf_4,O);
</cfscript>

<cfif wrq_Sarf_4.recordCount gt 0>
    <cfscript>
        AddSayimFis(wrq_Sarf_4,243,attributes.V_P_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"));
    </cfscript>
</cfif>