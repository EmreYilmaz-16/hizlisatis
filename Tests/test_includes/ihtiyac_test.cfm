<cfquery name="q1" datasource="#dsn#">
    
	  IF EXISTS(SELECT * FROM sys.tables where name = 'STOCK_ID_LIST_PBS')
            BEGIN
                DROP TABLE workcube_metosan_1.STOCK_ID_LIST_PBS
            END
</cfquery>
<cfquery name="q2" datasource="#dsn#">
    
    IF EXISTS(SELECT * FROM sys.tables where name = 'GROUPED_STOCK_ID_LIST_PBS')
          BEGIN
              DROP TABLE workcube_metosan_1.GROUPED_STOCK_ID_LIST_PBS
          END
</cfquery>
<cfquery name="q2" datasource="#dsn#">
    
    IF EXISTS(SELECT * FROM sys.tables where name = 'TREE_LIST_PBS')
          BEGIN
              DROP TABLE workcube_metosan_1.TREE_LIST_PBS
          END
</cfquery>
<cfquery name="q2" datasource="#dsn#">
    
    IF EXISTS(SELECT * FROM sys.tables where name = 'TREE_LIST_PBS_A')
          BEGIN
              DROP TABLE workcube_metosan_1.TREE_LIST_PBS_A
          END
</cfquery>

<cfquery name="q3" datasource="#dsn#">
    SELECT ORR.PRODUCT_NAME,POR.PRODUCTION_ORDER_ID,ORR.ORDER_ROW_ID,S.STOCK_ID,ORR.QUANTITY  INTO workcube_metosan_1.STOCK_ID_LIST_PBS  FROM workcube_metosan_1.ORDER_ROW AS ORR 
	LEFT JOIN workcube_metosan_1.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
	LEFT JOIN workcube_metosan_1.PRODUCTION_ORDERS_ROW AS POR ON POR.ORDER_ROW_ID=ORR.ORDER_ROW_ID
	LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
	WHERE ORR.ORDER_ROW_CURRENCY=-5 AND O.ORDER_DATE >='2024-01-01' AND O.ORDER_DATE<='2024-12-31'
	AND S.IS_PRODUCTION=1 AND POR.PRODUCTION_ORDER_ID IS NULL

</cfquery>


<cfquery name="q4" datasource="#dsn#">
    SELECT SUM(QUANTITY) QUANTITY,STOCK_ID INTO workcube_metosan_1.GROUPED_STOCK_ID_LIST_PBS FROM workcube_metosan_1.STOCK_ID_LIST_PBS  GROUP BY STOCK_ID
</cfquery>


<cfquery name="cr1" datasource="#dsn3#">
    CREATE TABLE workcube_metosan_1.TREE_LIST_PBS(STOCK_ID INT ,AMOUNT FLOAT)
</cfquery>
<cfquery name="cr1" datasource="#dsn3#">
    CREATE TABLE workcube_metosan_1.TREE_LIST_PBS_A(STOCK_ID INT ,AMOUNT FLOAT)
</cfquery>
<cfquery name="getSID" datasource="#dsn3#">
    SELECT * FROM GROUPED_STOCK_ID_LIST_PBS 
</cfquery>

<cfloop query="getSID">
    <cfquery name="GETT" datasource="#DSN3#">
        SELECT * FROM PRODUCT_TREE WHERE STOCK_ID=#STOCK_ID# AND RELATED_ID IS NOT NULL
    </cfquery>
    <cfloop query="GETT">
        <cfquery name="INS1" datasource="#DSN3#">
            INSERT INTO workcube_metosan_1.TREE_LIST_PBS(STOCK_ID,AMOUNT) VALUES (#RELATED_ID#,#getSID.QUANTITY*AMOUNT#)
        </cfquery>
    </cfloop>
</cfloop>


<cfquery name="GETSID2" datasource="#DSN3#">
    SELECT * FROM TREE_LIST_PBS
</cfquery>
<cfloop query="GETSID2">
    <cfquery name="GETT" datasource="#DSN3#">
        SELECT * FROM PRODUCT_TREE WHERE STOCK_ID=#STOCK_ID# AND RELATED_ID IS NOT NULL
    </cfquery>
    <cfloop query="GETT">
        <cfquery name="INS1" datasource="#DSN3#">
            INSERT INTO workcube_metosan_1.TREE_LIST_PBS(STOCK_ID,AMOUNT) VALUES (#RELATED_ID#,#GETSID2.AMOUNT*AMOUNT#)
        </cfquery>
         <cfquery name="INS1" datasource="#DSN3#">
            INSERT INTO workcube_metosan_1.TREE_LIST_PBS_A(STOCK_ID,AMOUNT) VALUES (#RELATED_ID#,#GETSID2.AMOUNT*AMOUNT#)
        </cfquery>
    </cfloop>
</cfloop>

<cfquery name="GETSID3" datasource="#DSN3#">
    SELECT * FROM TREE_LIST_PBS_A
</cfquery>
<cfloop query="GETSID3">
    <cfquery name="GETT" datasource="#DSN3#">
        SELECT * FROM PRODUCT_TREE WHERE STOCK_ID=#STOCK_ID# AND RELATED_ID IS NOT NULL
    </cfquery>
    <cfloop query="GETT">
        <cfquery name="INS1" datasource="#DSN3#">
            INSERT INTO workcube_metosan_1.TREE_LIST_PBS(STOCK_ID,AMOUNT) VALUES (#RELATED_ID#,#GETSID3.AMOUNT*AMOUNT#)
        </cfquery>
         
    </cfloop>
</cfloop>