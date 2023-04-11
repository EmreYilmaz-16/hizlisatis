<cfquery name="getData" datasource="#dsn3#">
    SELECT *
FROM workcube_metosan_1.VIRTUAL_PRODUCTION_ORDERS AS VPO
LEFT JOIN workcube_metosan_1.PBS_OFFER_ROW AS POR ON POR.UNIQUE_RELATION_ID = VPO.UNIQUE_RELATION_ID
LEFT JOIN workcube_metosan_1.VirmanProduct AS VP ON VP.VIRMAN_ID = POR.CONVERTED_STOCK_ID
WHERE VPO.V_P_ORDER_ID = #attributes.VP_ORDER_ID#
</cfquery>

<cfset fr_data=deserializeJSON(replace(getData.JSON_DATA,"//",""))>
<cfoutput>
    <script>
       var BozulacakArr=#Replace(SerializeJSON(fr_data.BozulacakUrunler),'//','')#
       var CikanArr=#Replace(SerializeJSON(fr_data.CikanUrunler),'//','')#
       var GirenArr=#Replace(SerializeJSON(fr_data.GirenUrunler),'//','')#
       var OlusacakUrun=#Replace(SerializeJSON(fr_data.OlusacakUrun),'//','')# 
    

    </script>
</cfoutput>
<cfquery name="getRaf12" datasource="#dsn3#">
    SELECT PP.SHELF_CODE  FROM PRODUCT_PLACE_ROWS AS PPR
     LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
     WHERE STOCK_ID= #OlusacakUrun.STOCK_ID#
 </cfquery>
<cfquery name="getS12" datasource="#dsn3#">
    select STORE_ID,LOCATION_ID,PRODUCT_PLACE_ID from PRODUCT_PLACE where SHELF_CODE='#getRaf.shelf_code#'
</cfquery>
<cfset MainSL="#getS12.STORE_ID#-#getS12.LOCATION_ID#">
<!------

    Sarf    Fişi    (Bozulacak)         241
    Sarf    Fişi    (Çıkan)             242
    Sayım   Fişi    (Giren)             243
    Ambar   Fişi                        87
-------->

<cfset wrq_Ambar=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR")>
<cfset wrq_Sarf=queryNew("STORE_ID,LOCATION_ID,STOCK_ID,SHELF_NUMBER,SHELF_NUMBER_TXT,AMOUNT,ROW_UNIQ_ID","INTEGER,INTEGER,INTEGER,INTEGER,VARCHAR,DECIMAL,VARCHAR")>
<cfloop array="#BozulacakArr#" item="it">
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
    <cfscript>
        O={
           STORE_ID=getS.STORE_ID,
           LOCATION_ID=getS.LOCATION_ID,
           STOCK_ID=it.STOCK_ID,
           AMOUNT=filternum(it.QUANTITY),
           SHELF_NUMBER=getS.PRODUCT_PLACE_ID,
           SHELF_NUMBER_TXT=getRaf.shelf_code           
       };       
  </cfscript>
    <cfif MainSL neq SubSL> <!---- Ambar Fişi Kontrolü----->
    <cfscript>
        queryAddRow(wrq_Ambar,O);
    </cfscript>
    
    </cfif>
    <cfscript>
        queryAddRow(wrq_Sarf,O);
    </cfscript>
</cfloop>

<cfif wrq_Ambar.recordCount gt 0>
    <cfscript>
        AddStockFis(wrq_Ambar,87,attributes.VP_ORDER_ID,listGetAt(MainSL,1,"-"),listGetAt(MainSL,2,"-"));
    </cfscript>
</cfif>








<cffunction name="AddStockFis">
    <cfargument name="ResQuery">
    <cfargument name="FisType">
    <cfargument name="RefNo">
    <cfargument name="Din">
    <cfargument name="Lin">
    <cfloop query="ResQuery" group="LOCATION_ID">               
        <cfset ix=1>      
        <cfset attributes.active_period=session.ep.period_id> 
        <cfset attributes.REF_NO="UE_ID-#arguments.RefNo#">
        <cf_papers paper_type="stock_fis">
        <cfif isdefined("paper_full") and isdefined("paper_number")>
            <cfset system_paper_no = paper_full>
        <cfelse>
            <cfset system_paper_no = "">
        </cfif>
        <cfquery name="SS" datasource="#DSN3#">
            UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER=STOCK_FIS_NUMBER+1 WHERE STOCK_FIS_NUMBER IS NOT NULL
            select STOCK_FIS_NO,STOCK_FIS_NUMBER from GENERAL_PAPERS
        </cfquery>
        <cfinclude template="/v16/stock/query/check_our_period.cfm"> 
        <cfinclude template="/v16/stock/query/get_process_cat.cfm">
        <cfset attributes.fis_type = get_process_type.PROCESS_TYPE>
        <cfset attributes.LOCATION_IN=Lin>
        <cfset attributes.LOCATION_OUT=LOCATION_ID>
        <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
        <cfset attributes.fis_date=now()>
        <cfset attributes.fis_date_h=0>
        <cfset attributes.fis_date_m=0>
        <cfset attributes.process_cat = form.process_cat>
        <cfset attributes.department_out=STORE_ID>
        <cfset attributes.department_in =Din>
        <cfset attributes.PROD_ORDER = ''>  
        <cfset attributes.PROD_ORDER_NUMBER = ''>  
        <cfset attributes.PROJECT_HEAD = ''> 
        <cfset attributes.PROJECT_HEAD_IN = ''>  
        <cfset attributes.PROJECT_ID = ''>  
        <cfset attributes.PROJECT_ID_IN = ''> 
        <cfset attributes.member_type='' >
        <cfset attributes.member_name='' >
        <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
        <cfset ATTRIBUTES.FIS_DATE_H  ="00">
        <cfset ATTRIBUTES.FIS_DATE_M  ="0">
        <cfset attributes.rows_=0>
        <cfloop >
            <cfquery name="getSinfo" datasource="#dsn3#">                            
                select PRODUCT_UNIT.MAIN_UNIT,STOCKS.PRODUCT_UNIT_ID,STOCKS.TAX,STOCKS.PRODUCT_ID,STOCKS.IS_INVENTORY from #dsn3#.STOCKS 
                left join #dsn3#.PRODUCT_UNIT on PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID and IS_MAIN=1                            
                where STOCK_ID=#STOCK_ID#
            </cfquery>
            <cfset attributes.rows_=attributes.rows_+1>
            <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
            <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
            <cfset 'attributes.stock_id#ix#' = STOCK_ID>
            <cfset 'attributes.amount#ix#' = AMOUNT>
            <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
            <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
            <cfset 'attributes.tax#ix#' = getSinfo.TAX>
            <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
            <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
            <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
            <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>            
            <cfset ix=ix+1>                        
        </cfloop>
        <cfinclude template="/v16/stock/query/add_ship_fis_1_PBS.cfm">    
        <cfinclude template="/v16/stock/query/add_ship_fis_2_PBS.cfm">
        <cfif isdefined("attributes.rows_")>            
            <cfinclude template="/v16/stock/query/add_ship_fis_3.cfm">
            <cfinclude template="/v16/stock/query/add_ship_fis_4.cfm">                    
        <cfelse>
            <cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
                INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
            </cfquery>
        </cfif>                                            
    </cfloop> 



</cffunction>
