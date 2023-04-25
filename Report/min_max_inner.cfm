<cfoutput>
<!---REZERVER SİPARİŞLER ---->
<cfquery name="getReserved_1" datasource="#dsn3#">
    SELECT ISNULL(SUM(STOCK_AZALT),0) AS STOCK_AZALT,ISNULL(SUM(STOCK_ARTIR),0) AS STOCK_ARTIR FROM (            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                0 AS STOCK_ARTIR,			
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                #dsn3#.STOCKS S,
                #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                #dsn3#.ORDERS ORDS,		
                #dsn3#.PRODUCT_UNIT PU
             WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                (
                    (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                    OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                )AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                and orr.STOCK_ID=#getStokcks_1.STOCK_ID#
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
            UNION
            SELECT
                0 AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                #dsn3#.STOCKS S,
                #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                #dsn3#.ORDERS ORDS,
                #dsn#.STOCKS_LOCATION SL,	
                #dsn3#.PRODUCT_UNIT PU
             WHERE
                ORR.STOCK_ID = S.STOCK_ID AND 
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND		
                ORDS.PURCHASE_SALES=0 AND
                ORDS.ORDER_ZONE=0 AND
                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                ORDS.LOCATION_ID=SL.LOCATION_ID AND
                ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                SL.NO_SALE = 0 AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
            UNION 
            SELECT
                SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                0 AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
                #dsn3#.STOCKS S,
                #dsn3#.GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                #dsn3#.ORDERS ORDS,
                #dsn3#.SPECTS_ROW SR,		
                #dsn3#.PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                (
                    (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                    OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                )AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID
            UNION 	
            SELECT
                0 AS STOCK_AZALT,
                SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD,
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
             FROM
               #dsn3#. STOCKS S,
              #dsn3#. GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                #dsn3#.ORDERS ORDS,
               #dsn3#. SPECTS_ROW SR,
                #dsn#.STOCKS_LOCATION SL,
                #dsn3#.PRODUCT_UNIT PU
             WHERE
                SR.STOCK_ID = S.STOCK_ID AND 
                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                SR.IS_SEVK=1 AND
                ORDS.RESERVED = 1 AND
                ORDS.ORDER_STATUS = 1 AND
                ORR.ORDER_ID = ORDS.ORDER_ID AND
                ORDS.PURCHASE_SALES=0 AND
                ORDS.ORDER_ZONE=0 AND
                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                ORDS.LOCATION_ID=SL.LOCATION_ID AND
                ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                SL.NO_SALE = 0  AND		
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                AND ORR.STOCK_ID=#getStokcks_1.STOCK_ID#
             GROUP BY
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PROPERTY,
                S.BARCOD, 
                PU.MAIN_UNIT,
                ORDS.ORDER_ID,
                ORDS.DELIVER_DEPT_ID,
                ORDS.LOCATION_ID,
                ORR.DEPARTMENT_ID,
                ORR.LOCATION_ID


    ) AS TBL

   <cfif isDefined("attributes.department") and len(attributes.department)> WHERE TBL.DEPARTMENT_ID=#attributes.department#</cfif>

</cfquery>
<!---ÜRETİM EMRİ RESERVE---->
<cfquery name="getReserved_2" datasource="#dsn3#">
    SELECT  ISNULL(SUM(STOCK_AZALT),0) AS STOCK_AZALT,
            ISNULL(SUM(STOCK_ARTIR),0) AS STOCK_ARTIR  
    FROM    GET_PRODUCTION_RESERVED_LOCATION 
    WHERE   PRODUCT_ID=#getStokcks_1.PRODUCT_ID# 
          <cfif isDefined("attributes.department") and len(attributes.department)> AND DEPARTMENT_ID=#attributes.department#</cfif>
</cfquery>

<cfset tartan=TOTAL_STOCK+getReserved_2.STOCK_ARTIR+getReserved_1.STOCK_ARTIR>
<cfset tazlan=getReserved_2.STOCK_AZALT+getReserved_1.STOCK_AZALT>
    <cfquery name="getInv" datasource="#dsn2#">
    SELECT ISNULL(SUM(IR.AMOUNT),0) AS AMOUNT FROM INVOICE AS I 
    INNER JOIN INVOICE_ROW AS IR ON I.INVOICE_ID=IR.INVOICE_ID
    WHERE 
    I.PURCHASE_SALES=1
    AND I.INVOICE_CAT NOT IN(67,69)
    AND I.IS_IPTAL=0
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
    </cfif>
    <cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
    AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
    </cfif> 
    AND IR.STOCK_ID=#getStokcks_1.STOCK_ID#
    <cfif isDefined("attributes.department") and len(attributes.department)>AND   I.DEPARTMENT_ID=#attributes.department# </cfif>
</cfquery>
<cfquery name="getSf" datasource="#dsn2#"> 
    SELECT ISNULL(SUM(SFR.AMOUNT),0) AS AMOUNT FROM STOCK_FIS  AS SF 
    INNER JOIN STOCK_FIS_ROW AS SFR ON SF.FIS_ID=SFR.FIS_ID
    WHERE SF.FIS_TYPE=111
    <cfif isDefined("attributes.department") and len(attributes.department)>   AND SF.DEPARTMENT_OUT=#attributes.department#</cfif>
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
    AND SF.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
    </cfif>
    <cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
    AND SF.FIS_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
    </cfif>
    AND SFR.STOCK_ID=#getStokcks_1.STOCK_ID#
</cfquery>

<tr >
    <td>#getStokcks_1.RowNum#</td>
    <td><a onclick="windowopen('index.cfm?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#','medium');">#getStokcks_1.PRODUCT_CODE#</a></td>
    <td><a href="javascript://" onclick="windowopen('/index.cfm?fuseaction=#attributes.fuseaction#&report_id=#attributes.report_id#&event=det&form_submitted=1&stock_id=#PRODUCT_ID#','page')">#getStokcks_1.PRODUCT_CODE_2#</a></td>
    <td>#getStokcks_1.PRODUCT_NAME#</td>
    <td>#getStokcks_1.PROPERTY8#</td>
    <td>#getStokcks_1.PROPERTY9#</td>
    <cfquery name="getDname" datasource="#dsn#">
    select TOP 1 * from DEPARTMENT where DEPARTMENT_ID=#DEPARTMENT_ID#
    </cfquery>
    <td>#getDname.DEPARTMENT_HEAD#</td>


    <td> <cfif getStokcks_1.TOTAL_STOCK lt GETMax_Min.MAXIMUM_STOCK><span style="font-weight:bold;color:red">#AmountFormat(getStokcks_1.TOTAL_STOCK)#</span><cfelseif getStokcks_1.TOTAL_STOCK gt GETMax_Min.MAXIMUM_STOCK> <span style="font-weight:bold;color:blue">#AmountFormat(getStokcks_1.TOTAL_STOCK)#</span></cfif> </td>
    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_orders&taken=0&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_1.STOCK_ARTIR)#</a></td>
    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_2.STOCK_ARTIR)#</a></td>    
    <td>#AmountFormat(tartan)#</td>
    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_orders&taken=1&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_1.STOCK_AZALT)#</a></td>
    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#PRODUCT_ID#','medium');">#AmountFormat(getReserved_2.STOCK_AZALT)#</a></td>    
    <td>#AmountFormat(tazlan)#</td>
    <td><cfset satilabilir=tartan-tazlan> #AmountFormat(tartan-tazlan)#</td>
            <td>#AmountFormat(getInv.AMOUNT)#</td>
    <td>#AmountFormat(getSf.AMOUNT)#</td>
    <td>#AmountFormat(GETMax_Min.MINIMUM_STOCK)#</td>        
    <td>#AmountFormat(GETMax_Min.MAXIMUM_STOCK)#</td>
    <td><input style="width:50px;text-align:right" type="text" value="<cfset ihtiyac=satilabilir-GETMax_Min.MINIMUM_STOCK><cfif ihtiyac lt 0><cfset ihtiyac= ihtiyac*-1>#ihtiyac#<cfelse><cfset ihtiyac=0>0</cfif>" id="row_total_need_#getStokcks_1.stock_id#" name="row_total_need_#getStokcks_1.stock_id#"></td>
    <td><input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#"></td>
            <cfif isdefined('product_price_#STOCK_ID#')>
                            <cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
                        <cfelse>
                            <cfset row_price = 0 >
                        </cfif>
                        <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                        <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(ihtiyac*row_price)#" onKeyup="return(FormatCurrency(this,event));">
                       <select name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" style="width:45px;display:none;">
                            <cfloop query="get_money">
                                            <option value="#money#,#RATE2#"<cfif isdefined('product_money_#getStokcks_1.STOCK_ID#') and Evaluate('product_money_#getStokcks_1.STOCK_ID#') is money>selected</cfif>>#money#</option>
                            </cfloop>
                        </select>
</tr>
<cfif attributes.isexcell eq 1>
<cfscript>

SatirSayaci=SatirSayaci+1;
hucre=1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.RowNum#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_CODE#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_CODE_2#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.PRODUCT_NAME#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.PROPERTY8#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.PROPERTY9#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getDname.DEPARTMENT_HEAD#", SatirSayaci, hucre);
hucre=hucre+1;   
    spreadsheetSetCellValue(theSheet, "#getStokcks_1.TOTAL_STOCK#", SatirSayaci, hucre);
    if(getStokcks_1.TOTAL_STOCK lt GETMax_Min.MINIMUM_STOCK){
        SpreadsheetFormatCell(theSheet,myFormatRed,SatirSayaci,hucre); 
    } else if(getStokcks_1.TOTAL_STOCK gt GETMax_Min.MAXIMUM_STOCK){
        SpreadsheetFormatCell(theSheet,myFormatBlue,SatirSayaci,hucre); 
    }else{}
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getReserved_1.STOCK_AZALT#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getReserved_2.STOCK_AZALT#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#tartan#", SatirSayaci, hucre);
hucre=hucre+1;
       spreadsheetSetCellValue(theSheet, "#getReserved_1.STOCK_ARTIR#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getReserved_2.STOCK_ARTIR#", SatirSayaci, hucre);
hucre=hucre+1;
        spreadsheetSetCellValue(theSheet, "#tazlan#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#satilabilir#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#getInv.AMOUNT#", SatirSayaci, hucre);
hucre=hucre+1;
        spreadsheetSetCellValue(theSheet, "#getSf.AMOUNT#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#GETMax_Min.MINIMUM_STOCK#", SatirSayaci, hucre);
hucre=hucre+1;
    spreadsheetSetCellValue(theSheet, "#GETMax_Min.MAXIMUM_STOCK#", SatirSayaci, hucre);
hucre=hucre+1;
    
    spreadsheetSetCellValue(theSheet, "#ihtiyac#", SatirSayaci, hucre);
                                              
</cfscript>
</cfif>
</cfoutput>