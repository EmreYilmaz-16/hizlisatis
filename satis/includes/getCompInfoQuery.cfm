<cftry>
    <cfset InfoArray = ArrayNew(1)>
    <cfif isDefined("attributes.type_id") and Len(attributes.type_id) and isDefined("attributes.q_type") and attributes.q_type eq "CompanyInfo">
        <cfscript>
            CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
            get_open_order_ships = CreateCompenent.getCompenentFunction(company_id:attributes.type_id);
        </cfscript>
        <cfquery name = "GetCompInfo" datasource="#dsn#">
            SELECT
                SC.CITY_NAME,
                SCO.COUNTY_NAME,
                C.TAXNO,
                CASE
                    WHEN
                        C.COMPANY_TEL1 IS NOT NULL
                    THEN
                        CONCAT(CASE WHEN C.COMPANY_TELCODE IS NOT NULL THEN CONCAT('(',C.COMPANY_TELCODE,') ') ELSE '' END,C.COMPANY_TEL1)
                    ELSE
                        ''
                END AS PHONE,
                SCV.CUSTOMER_VALUE,
                SP.PAYMETHOD_ID,
                SP.PAYMETHOD,
		        SP.PAYMENT_VEHICLE,
                SP.DUE_DAY,
                C.FULLNAME,
                ISNULL(SUM(CRT.BORC-CRT.ALACAK),0) AS BAKIYE,
                (CR.BAKIYE+#get_open_order_ships.SHIP_TOTAL#+#get_open_order_ships.ORDER_TOTAL#+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.CEK_KARSILIKSIZ+CR.SENET_KARSILIKSIZ) AS RISK,
                CONCAT(EP.EMPLOYEE_NAME,' ',EP.EMPLOYEE_SURNAME) AS PLASIYER,
                CONCAT(CP.COMPANY_PARTNER_NAME,' ',CP.COMPANY_PARTNER_SURNAME) AS MANAGER,
                EP.EMPLOYEE_ID AS PLASIYER_ID,
                SM.SHIP_METHOD,
		        SM.SHIP_METHOD_ID,
                C.MANAGER_PARTNER_ID
            FROM
                COMPANY C
                LEFT JOIN SETUP_CITY SC ON C.CITY = SC.CITY_ID
                LEFT JOIN SETUP_COUNTY SCO ON C.COUNTY = SCO.COUNTY_ID
                LEFT JOIN SETUP_CUSTOMER_VALUE SCV ON C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID
                LEFT JOIN COMPANY_CREDIT CC ON C.COMPANY_ID = CC.COMPANY_ID
                LEFT JOIN SETUP_PAYMETHOD SP ON CC.REVMETHOD_ID = SP.PAYMETHOD_ID
                LEFT JOIN #dsn2_alias#.CARI_ROWS_TOPLAM CRT ON ISNULL(CRT.FROM_CMP_ID,CRT.TO_CMP_ID) = C.COMPANY_ID
                LEFT JOIN #dsn2_alias#.COMPANY_RISK CR ON CR.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = ISNULL(C.POS_CODE,#session.ep.position_code#)
                LEFT JOIN SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID=CC.SHIP_METHOD_ID
                LEFT JOIN COMPANY_PARTNER AS CP ON CP.PARTNER_ID=C.MANAGER_PARTNER_ID
            WHERE
                C.COMPANY_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.type_id#">
            GROUP BY
                SC.CITY_NAME,
                SCO.COUNTY_NAME,
                C.TAXNO,
                C.COMPANY_TELCODE,
                C.COMPANY_TEL1,
                SCV.CUSTOMER_VALUE,
                SP.PAYMETHOD_ID,
                SP.PAYMETHOD,
                SP.DUE_DAY,
		        SP.PAYMENT_VEHICLE,
                CR.BAKIYE,
                CR.CEK_ODENMEDI,
                CR.SENET_ODENMEDI,
                CR.CEK_KARSILIKSIZ,
                CR.SENET_KARSILIKSIZ,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_SURNAME,
                SM.SHIP_METHOD_ID,
	            SM.SHIP_METHOD,
                EP.EMPLOYEE_ID,
                CP.COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
                C.MANAGER_PARTNER_ID,
                C.FULLNAME
        </cfquery>
        <cfquery name="getPriceLists" datasource="#dsn3#">
            SELECT
                PCE.IS_DEFAULT,
                PC.PRICE_CATID,
                PC.PRICE_CAT
            FROM
                PRICE_CAT_EXCEPTIONS PCE
                LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
            WHERE 
                PCE.COMPANY_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.type_id#">
                AND PCE.ACT_TYPE IN (2,4)
                AND ISNULL(PCE.PURCHASE_SALES,1) = 1
                AND ISNULL(PC.PRICE_CAT_STATUS,0) = 1
            ORDER BY
                PC.PRICE_CAT
        </cfquery>
         <cfquery name="GETnOTES" datasource="#DSN#">
            SELECT COUNT(*) AS NOTE_COUNT FROM #dsn#.NOTES where ACTION_SECTION='COMPANY_ID' AND ACTION_ID=#attributes.type_id#
        </cfquery>
        <cfset CompInfoStruct = StructNew()>
        <cfset CompInfoStruct.CITY = GetCompInfo.CITY_NAME>
        <cfset CompInfoStruct.COUNTY = GetCompInfo.COUNTY_NAME>
        <cfset CompInfoStruct.TAXNO = GetCompInfo.TAXNO>
        <cfset CompInfoStruct.PHONE = GetCompInfo.PHONE>
        <cfset CompInfoStruct.CUSTOMER_VALUE = GetCompInfo.CUSTOMER_VALUE>
        <cfset CompInfoStruct.PAYMETHOD_ID = GetCompInfo.PAYMETHOD_ID>
        <cfset CompInfoStruct.PAYMETHOD = GetCompInfo.PAYMETHOD>
        <cfset CompInfoStruct.PAYMENT_VEHICLE = GetCompInfo.PAYMENT_VEHICLE>
        <cfset CompInfoStruct.SHIP_METHOD = GetCompInfo.SHIP_METHOD>
        <cfset CompInfoStruct.SHIP_METHOD_ID = GetCompInfo.SHIP_METHOD_ID>
        <cfset CompInfoStruct.VADE = GetCompInfo.DUE_DAY>
        <cfset CompInfoStruct.MANAGER = GetCompInfo.MANAGER>
        <cfset CompInfoStruct.MANAGER_PARTNER_ID = GetCompInfo.MANAGER_PARTNER_ID>
        <cfset CompInfoStruct.FULLNAME = GetCompInfo.FULLNAME>
        <cfset CompInfoStruct.NOTE_COUNT = GETnOTES.NOTE_COUNT>
        <cfset VADE2 = 0>
        <cfset attributes.company_id = attributes.type_id>
        <cfinclude template="../includes/kapali_islemler.cfm">
        <cfset CompInfoStruct.VADE2 = VADE2>
        <cfset VADE_TOPLAMI = 0>
        <cfinclude template="../includes/acik_islemler.cfm">
        <cfset CompInfoStruct.VADE_TOPLAMI = VADE_TOPLAMI>
        <cfset CompInfoStruct.BAKIYE = GetCompInfo.BAKIYE>
        <cfset CompInfoStruct.RISK = GetCompInfo.RISK>
        <cfset CompInfoStruct.PLASIYER = GetCompInfo.PLASIYER>
        <cfif len(GetCompInfo.PLASIYER)>
            <cfset CompInfoStruct.PLASIYER = GetCompInfo.PLASIYER>
            <cfset CompInfoStruct.PLASIYER_ID = GetCompInfo.PLASIYER_ID>
        <cfelse>
            <cfset CompInfoStruct.PLASIYER = '#session.ep.NAME# #session.ep.SURNAME#'>
            <cfset CompInfoStruct.PLASIYER_ID = session.ep.userid>
        </cfif>
        <cfset CompInfoStruct.PRICE_LISTS = ArrayNew(1)>
        <cfloop query="getPriceLists">
            <cfset PriceListStruct = StructNew()>
            <cfset PriceListStruct.IS_DEFAULT = getPriceLists.IS_DEFAULT>
            <cfset PriceListStruct.PRICE_CATID = getPriceLists.PRICE_CATID>
            <cfset PriceListStruct.PRICE_CAT = getPriceLists.PRICE_CAT>
            <cfset ArrayAppend(CompInfoStruct.PRICE_LISTS,PriceListStruct)>
        </cfloop>
        
        <cfset InfoArray[1] = CompInfoStruct>
    <cfelseif attributes.q_type eq "SaleableStock">
        <cfquery name="getSaleableStock" datasource="#dsn2#">   
                SELECT D.DEPARTMENT_HEAD,SL.COMMENT,D.DEPARTMENT_ID,SL.LOCATION_ID,CONVERT(nvarchar,D.DEPARTMENT_ID)+'-'+CONVERT(nvarchar,SL.LOCATION_ID) DEPT FROM (
select * from #dsn3#.PRODUCT_PLACE where PRODUCT_PLACE_ID IN(
select PRODUCT_PLACE_ID from #dsn3#.PRODUCT_PLACE_ROWS  where PRODUCT_ID=#attributes.type_id#)
) AS TBL
INNER JOIN #dsn#.DEPARTMENT AS D ON D.DEPARTMENT_ID=TBL.STORE_ID
INNER JOIN #dsn#.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=TBL.LOCATION_ID AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID

        </cfquery>
        <cfset stockStruct = StructNew()>
        <cfset stockStruct.LAST_STOCK = 10>
        <cfset stockStruct.DEPT = getSaleableStock.DEPARTMENT_ID>
        <cfset stockStruct.LOCATION = getSaleableStock.LOCATION_ID>
        <cfset stockStruct.DEPARTMENT_LOCATION = getSaleableStock.DEPT>
        <cfset stockStruct.DEPT_NAME = "#getSaleableStock.DEPARTMENT_HEAD# #getSaleableStock.COMMENT#">
        <cfset stockStruct.STATUS = 1>
        <cfset InfoArray = ArrayNew(1)>
        <cfset InfoArray[1] = stockStruct>
    </cfif>
    <cfcatch>
        <cfset catchStruct = StructNew()>
        <cfset catchStruct.MESSAGE = cfcatch>
       <!---- <cfset catchStruct.FILE = cfcatch.Cause.NextException.TagContext[1].TEMPLATE>
        <cfset catchStruct.LINE = cfcatch.Cause.NextException.TagContext[1].LINE>---->
        <cfset InfoArray = ArrayNew(1)>
        <cfset InfoArray[1] = catchStruct>

    </cfcatch>
    <cffinally>
        <cfoutput>
            
        </cfoutput>
    </cffinally>
</cftry>

