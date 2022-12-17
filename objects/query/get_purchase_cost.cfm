<!---<cfquery name="GET_PURCHASE_COST" datasource="#DSN2#" maxrows="5">
	SELECT DISTINCT
		I.INVOICE_ID,
		IR.PRICE, 
		IR.PRICE_OTHER,
		IR.OTHER_MONEY, 
		IR.NAME_PRODUCT, 
		IR.DISCOUNT1,
		IR.DISCOUNT2, 
		IR.DISCOUNT3, 
		IR.DISCOUNT4, 
		IR.DISCOUNT5, 
		I.INVOICE_DATE,
		I.COMPANY_ID,
		I.CONSUMER_ID,
		IR.UNIT,
		IR.STOCK_ID,
        I.INVOICE_CAT,
		PC.PROCESS_TYPE,
		PC.PROCESS_CAT
	FROM	
		INVOICE_ROW AS IR,
		INVOICE AS I,
		#dsn3_alias#.SETUP_PROCESS_CAT PC
	WHERE
	<cfif isdefined("attributes.stock_id")>
		IR.STOCK_ID=#attributes.stock_id# AND
	</cfif>
	<cfif isdefined("attributes.is_store_module")>
		I.DEPARTMENT_ID IN
			(
				SELECT 
					DEPARTMENT_ID
				FROM 
					#dsn_alias#.DEPARTMENT D
				WHERE
					D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			) AND
	</cfif>
	    I.PURCHASE_SALES = 0 AND
		ISNULL(I.IS_IPTAL,0)=0 AND
		I.INVOICE_ID = IR.INVOICE_ID AND
		I.INVOICE_CAT=PC.PROCESS_TYPE AND
		I.PROCESS_CAT = PC.PROCESS_CAT_ID
	ORDER BY
		I.INVOICE_DATE DESC
</cfquery>--->
<cfset cyear=year(now())>
<cfset byear=cyear-1>
<cfset dyear=byear-1>
<cfquery name="getPeriods" datasource="#dsn#">
select PERIOD_YEAR from SETUP_PERIOD WHERE OUR_COMPANY_ID=1 and PERIOD_YEAR <> #year(now())#
</cfquery>
<cfquery name="GET_PURCHASE_COST" datasource="#DSN2#" maxrows="5">


SELECT IR.PRICE
	,IR.PRICE_OTHER
	,I.INVOICE_DATE
	,I.INVOICE_ID
	,I.COMPANY_ID	
	,IR.DISCOUNT1
	,IR.DISCOUNT2
	,IR.DISCOUNT3
	,IR.DISCOUNT4
	,IR.DISCOUNT5
	,I.SALE_EMP
	,PC.PROCESS_CAT	
	,IR.AMOUNT
	,I.CONSUMER_ID
	,IR.UNIT
	,IR.OTHER_MONEY
FROM catalystTest_#cyear#_1.INVOICE I
	,catalystTest_#cyear#_1.INVOICE_ROW IR
	,#dsn3#.SETUP_PROCESS_CAT AS PC
WHERE I.INVOICE_ID = IR.INVOICE_ID
	AND IR.STOCK_ID = #attributes.stock_id#
	AND I.PURCHASE_SALES = 0
	AND I.PROCESS_CAT = PC.PROCESS_CAT_ID
<cfloop query="getPeriods">
UNION ALL

SELECT IR.PRICE
	,IR.PRICE_OTHER
	,I.INVOICE_DATE
	,I.INVOICE_ID
	,I.COMPANY_ID	
	,IR.DISCOUNT1
	,IR.DISCOUNT2
	,IR.DISCOUNT3
	,IR.DISCOUNT4
	,IR.DISCOUNT5
	,I.SALE_EMP
	,PC.PROCESS_CAT	
	,IR.AMOUNT
	,I.CONSUMER_ID
	,IR.UNIT
	,IR.OTHER_MONEY
FROM catalystTest_#PERIOD_YEAR#_1.INVOICE I
	,catalystTest_#PERIOD_YEAR#_1.INVOICE_ROW IR
	,#dsn3#.SETUP_PROCESS_CAT AS PC
WHERE I.INVOICE_ID = IR.INVOICE_ID
	AND IR.STOCK_ID = #attributes.stock_id#
	AND I.PURCHASE_SALES = 0
	AND I.PROCESS_CAT = PC.PROCESS_CAT_ID
</cfloop>
ORDER BY I.INVOICE_DATE DESC
</cfquery>


