<cfset wrq_Sarf=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID,SAME_DEPO","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER")>


<cfscript>
    O={
       STORE_ID=getS12.STORE_ID,
       LOCATION_ID=getS12.LOCATION_ID,
       STOCK_ID=getData.CREATED_SID,
       AMOUNT=fr_data.OlusacakUrun.QUANTITY,
       SHELF_NUMBER=getS12.PRODUCT_PLACE_ID,
       SHELF_NUMBER_TXT=getRaf12.shelf_code,
       SAME_DEPO=sameDepo           
   };       
   queryAddRow(wrq_Sarf,O);
</cfscript>

<cfif wrq_Sarf.recordCount gt 0>
    <cfscript>
        AddSayimFis(wrq_Sarf,243,attributes.V_P_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"));
    </cfscript>
</cfif>