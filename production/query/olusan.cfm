<cfset wrq_Sarf_4=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID,SAME_DEPO","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR,INTEGER")>
<CFSET CS="">
<cfif getData.CREATED_SID neq 0><CFSET CS=getData.CREATED_SID> <cfelse><CFSET CS=fr_data.OlusacakUrun.STOCK_ID></cfif>
<cfscript>
    O={
       STORE_ID=getS12.STORE_ID,
       LOCATION_ID=getS12.LOCATION_ID,
       STOCK_ID=CS,
       AMOUNT=1,
       SHELF_NUMBER=getS12.PRODUCT_PLACE_ID,
       SHELF_NUMBER_TXT=getRaf12.shelf_code,
       SAME_DEPO=sameDepo           
   };       
   queryAddRow(wrq_Sarf_4,O);
</cfscript>
EMRE YILMAZ
<cfdump var="#wrq_Sarf_4#">
<cfif wrq_Sarf_4.recordCount gt 0>
    <cfscript>
        AddSayimFis(wrq_Sarf_4,243,attributes.V_P_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"));
    </cfscript>
</cfif>