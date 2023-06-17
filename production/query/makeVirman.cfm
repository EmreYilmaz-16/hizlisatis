<cfquery name="getData" datasource="#dsn3#">
    SELECT *,CASE WHEN VP.CREATED_SID=0 THEN POR.STOCK_ID ELSE VP.CREATED_SID END AS CREATED_SID
FROM #DSN3#.VIRTUAL_PRODUCTION_ORDERS AS VPO
LEFT JOIN #DSN3#.PBS_OFFER_ROW AS POR ON POR.UNIQUE_RELATION_ID = VPO.UNIQUE_RELATION_ID
LEFT JOIN #DSN3#.VirmanProduct AS VP ON VP.VIRMAN_ID = POR.CONVERTED_STOCK_ID
WHERE VPO.V_P_ORDER_ID = #attributes.V_P_ORDER_ID#
</cfquery>

<cfset fr_data=deserializeJSON(replace(getData.JSON_DATA,"//",""))>
<cfdump var="#fr_data#">


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
     WHERE STOCK_ID= <cfif getData.CREATED_SID neq 0>#getData.CREATED_SID# <cfelse>#fr_data.OlusacakUrun.STOCK_ID#</cfif>
 </cfquery>
 <cfdump var="#getRaf12#">
<cfquery name="getS12" datasource="#dsn3#">
    select STORE_ID,LOCATION_ID,PRODUCT_PLACE_ID from PRODUCT_PLACE where SHELF_CODE='#getRaf12.shelf_code#'
</cfquery>
<cfset MainSL="#getS12.STORE_ID#-#getS12.LOCATION_ID#">
<!------

    Sarf    Fişi    (Bozulacak)         241
    Sarf    Fişi    (Çıkan)             242
    Sayım   Fişi    (Giren)             243

    Ambar   Fişi                        87
-------->

<cfinclude template="bozulacak.cfm">
<cfinclude template="cikan.cfm">
<cfinclude template="giren.cfm">
<cfinclude template="olusan.cfm">

<cfquery name="AddVirtualResult" datasource="#dsn3#">
	INSERT INTO VIRTUAL_PRODUCTION_ORDERS_RESULT (
		P_ORDER_ID,RECORD_DATE,RECORD_EMP,RESULT_AMOUNT
		)
	VALUES(
		#attributes.V_P_ORDER_ID#,#NOW()#,#session.ep.userid#,#getData.QUANTITY#
		)

</cfquery>

<cffunction name="AddSayimFis">
    <cfargument name="ResQuery">
    <cfargument name="FisType">
    <cfargument name="RefNo">
    <cfargument name="DepartmentIn">
    <cfargument name="LocationIn">
    <cfargument name="IOOPT">
<cfloop query="ResQuery" group="LOCATION_ID">
    <cfset ix=1>
    <cfset attributes.active_period=session.ep.period_id> 
    <cfset attributes.REF_NO="UEID-#arguments.RefNo#">
    <CFSET form.process_cat=arguments.FisType>
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
    <cfset attributes.LOCATION_IN=LOCATION_ID>
    <cfset attributes.department_in =STORE_ID>
    <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
    <cfset attributes.fis_date=now()>
    <cfset attributes.fis_date_h=0>
    <cfset attributes.fis_date_m=0>
    <cfset attributes.process_cat = form.process_cat>

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
        <cfdump var="#getSinfo#">
        <cfset attributes.rows_=attributes.rows_+1>

        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
        <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>      
        <cfset 'attributes.stock_id#ix#' = STOCK_ID>
        <cfset 'attributes.amount#ix#' = AMOUNT>
        <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
        <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
        <cfset 'attributes.tax#ix#' = getSinfo.TAX>
        <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
        <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
        <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
              
        <cfset ix=ix+1>                        
    </cfloop>
    <cfinclude template="/v16/stock/query/add_ship_fis_1_PBS.cfm">    
    <cfinclude template="/v16/stock/query/add_ship_fis_2_PBS.cfm">
    <cfif isdefined("attributes.rows_")>            
        <cfinclude template="/v16/stock/query/add_ship_fis_3_PBS.cfm">
        <cfinclude template="/v16/stock/query/add_ship_fis_4.cfm">                    
    <cfelse>
        <cfquery name="ADD_STOCK_FIS_ROW" datasource="#dsn2#">
            INSERT INTO STOCK_FIS_ROW (FIS_NUMBER,FIS_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FIS_NO#">,#GET_ID.MAX_ID#)
        </cfquery>
    </cfif>                                            
</cfloop> 



</cffunction>










<cffunction name="AddStockFis">
    <cfargument name="ResQuery">
    <cfargument name="FisType">
    <cfargument name="RefNo">
    <cfargument name="Din">
    <cfargument name="Lin">
    <cfargument name="ioopt">
    <cfargument name="DOut" default="">
    <cfargument name="LOut" default="">
    <cfdump var="#arguments#">
    <cfdump var="#arguments.ResQuery#">
    <cfloop query="ResQuery" group="LOCATION_ID">               
        <cfset ix=1>      
        <cfset attributes.active_period=session.ep.period_id> 
        <cfset attributes.REF_NO="UEID-#arguments.RefNo#">
        <CFSET form.process_cat=arguments.FisType>
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
<cfif arguments.ioopt eq 1>
    <cfif len(arguments.DOut)>
        
    </cfif>
    <cfset attributes.LOCATION_IN=Lin>
    <cfset attributes.LOCATION_OUT=Lin>
    <cfset attributes.department_out=Din>
    <cfset attributes.department_in =Din>
<cfelse>

        <cfset attributes.LOCATION_IN=Lin>
        <cfset attributes.LOCATION_OUT=LOCATION_ID>
        <cfset attributes.department_out=STORE_ID>
        <cfset attributes.department_in =Din>
    </cfif>
        <cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
        <cfset attributes.fis_date=now()>
        <cfset attributes.fis_date_h=0>
        <cfset attributes.fis_date_m=0>
        <cfset attributes.process_cat = form.process_cat>

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
<cfif arguments.ioopt eq 1>
    <cfif SAME_DEPO eq 1>
    <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
    <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
    <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>    
    <cfelse>
        <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = ""> 
        <cfset 'attributes.SHELF_NUMBER_#ix#' = "">
        <cfset 'attributes.shelf_number#ix#' = "">     
</cfif>
<cfelse>
    <cfset 'attributes.SHELF_NUMBER_TXT_#ix#' = SHELF_NUMBER_TXT> 
    <cfset 'attributes.SHELF_NUMBER_#ix#' = SHELF_NUMBER>
    <cfset 'attributes.shelf_number#ix#' = SHELF_NUMBER>     
              
        </cfif>

            <cfset 'attributes.stock_id#ix#' = STOCK_ID>
            <cfset 'attributes.amount#ix#' = AMOUNT>
            <cfset 'attributes.unit#ix#' = getSinfo.MAIN_UNIT>
            <cfset 'attributes.unit_id#ix#' = getSinfo.PRODUCT_UNIT_ID>
            <cfset 'attributes.tax#ix#' = getSinfo.TAX>
            <cfset 'attributes.product_id#ix#' = getSinfo.PRODUCT_ID>
            <cfset 'attributes.is_inventory#ix#' = getSinfo.IS_INVENTORY>
            <cfset 'attributes.WRK_ROW_ID#ix#' = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
                  
            <cfset ix=ix+1>                        
        </cfloop>
        <cfdump var="#attributes#">
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
