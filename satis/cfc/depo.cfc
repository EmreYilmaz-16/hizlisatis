
<cfcomponent>
<cfset CURRENT_YEAR=year(now())>
<cfset PAST_YEAR=year(now())-1>
<cfset TPAST_YEAR=year(now())-2>
    <cfset dsn=application.systemparam.dsn>
    <cfscript>
        if(isdefined("session.pda") and isDefined("session.pda.userid"))
        {
            session_base.money = session.pda.money;
            session_base.money2 = session.pda.money2;
            session_base.userid = session.pda.userid;
            session_base.company_id = session.pda.our_company_id;
            session_base.our_company_id = session.pda.our_company_id;
            session_base.period_id = session.pda.period_id;
        }
        else if(isdefined("session.ep") and isDefined("session.ep.userid"))
        {
            session_base.money = session.ep.money;
            session_base.money2 = session.ep.money2;
            session_base.userid = session.ep.userid;
            session_base.company_id = session.ep.company_id;
            session_base.period_id = session.ep.period_id;
        }
    </cfscript>
    <cffunction name="getDepartmentEmployees" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfquery name="getDepEmployees" datasource="#dsn#">
            SELECT E.EMPLOYEE_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,DEPARTMENT_ID,LOCATION_ID FROM(
                SELECT EMPLOYEE_ID AS EMP_ID ,DEPARTMENT_ID,LOCATION_ID FROM  workcube_metosan_1.DEPARTMENT_PERSONALS 
        ) AS T
        LEFT JOIN #dsn#.EMPLOYEES AS E ON E.EMPLOYEE_ID=T.EMP_ID
        WHERE DEPARTMENT_ID=#arguments.DEPARTMENT_ID# AND LOCATION_ID=#arguments.LOCATION_ID# AND EMPLOYEE_ID IS NOT NULL
        </cfquery>
        <cfset returnArr=arrayNew(1)>
        <CFSET RETURN_DATA.RECORD_COUNT=getDepEmployees.recordCount>
        <cfloop query="getDepEmployees">
            <cfscript>
                EMPLOYEE={
                    EMPLOYEE_ID=EMPLOYEE_ID,
                    EMPLOYEE_NAME=EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME=EMPLOYEE_SURNAME
                };
                arrayAppend(returnArr,EMPLOYEE);
            </cfscript>
        </cfloop>
<CFSET RETURN_DATA.EMPLOYEES=returnArr>
<cfreturn Replace(SerializeJSON(RETURN_DATA),'//','')>
    </cffunction>
   
   
   
    <cffunction name="getDepartmentWorks" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        
        <cfset dataSources=deserializeJSON(arguments.dataSources)>
        <cfquery name="getEmp" datasource="#dataSources.dsn3#">
            SELECT * FROM DEPARTMENT_PERSONALS where DEPARTMENT_ID=#arguments.DEPARTMENT_ID# and LOCATION_ID=#arguments.LOCATION_ID#
        </cfquery>
      
        <cfquery name="getDepWorks" datasource="#dataSources.dsn#">
            SELECT DISTINCT  O.RECORD_DATE,
SR.DELIVER_PAPER_NO,SR.COMPANY_ID,C.NICKNAME,SR.DELIVERY_DATE,DEPARTMENT_LOCATION,COMMENT,SR.SHIP_RESULT_ID,DELIVER_DEPT,DELIVER_LOCATION,SRR.PREPARE_PERSONAL,SRR.SHIP_RESULT_ROW_ID
,(SELECT COUNT(*) FROM #dataSources.DSN3#.ORDER_ROW where ORDER_ID =O.ORDER_ID AND DELIVER_DEPT=ORR.DELIVER_DEPT AND DELIVER_LOCATION=ORR.DELIVER_LOCATION) AS TTS
,#dataSources.DSN#.getEmployeeWithId(SR.RECORD_EMP) AS KAYDEDEN
FROM #dataSources.dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
LEFT JOIN #dataSources.dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
LEFT JOIN #dataSources.dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN #dataSources.dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
LEFT JOIN (
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#CURRENT_YEAR#_1.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn#_#CURRENT_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
UNION ALL 
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#PAST_YEAR#_1.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn#_#PAST_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
UNION ALL 
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#TPAST_YEAR#_1.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn#_#TPAST_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dataSources.dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN #dataSources.dsn#.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
INNER JOIN  #dataSources.dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
WHERE 1=1 
--AND SRR.SHIP_RESULT_ID=18
AND ORR.DELIVER_DEPT IN(#arguments.DEPARTMENT_ID#)
AND ORR.DELIVER_LOCATION IN (#arguments.LOCATION_ID#)
AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)
AND SRR.PREPARE_PERSONAL IS NULL
--AND ORR.ORDER_ROW_CURRENCY =-6
ORDER BY O.RECORD_DATE
        </cfquery>
          <cfif getEmp.recordcount eq 1>
            <cfloop query="getDepWorks" >
                <CFQUERY name="UPDD" datasource='#datasources.dsn3#'>
                    UPDATE PRTOTM_SHIP_RESULT_ROW SET PREPARE_PERSONAL=#getEmp.EMPLOYEE_ID# where SHIP_RESULT_ROW_ID=#SHIP_RESULT_ROW_ID#
                </CFQUERY> 
            </cfloop>
          </cfif>

          <cfquery name="getDepWorks" datasource="#dataSources.dsn#">
            SELECT DISTINCT  O.RECORD_DATE,
                SR.DELIVER_PAPER_NO,SR.COMPANY_ID,C.NICKNAME,SR.DELIVERY_DATE,DEPARTMENT_LOCATION,COMMENT,SR.SHIP_RESULT_ID,DELIVER_DEPT,DELIVER_LOCATION,SRR.PREPARE_PERSONAL
                ,(SELECT COUNT(*) FROM #dataSources.DSN3#.ORDER_ROW where ORDER_ID =O.ORDER_ID AND DELIVER_DEPT=ORR.DELIVER_DEPT AND DELIVER_LOCATION=ORR.DELIVER_LOCATION) AS TTS
                ,#dataSources.DSN#.getEmployeeWithId(SR.RECORD_EMP) AS KAYDEDEN
                FROM #dataSources.dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
                LEFT JOIN #dataSources.dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
                LEFT JOIN #dataSources.dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
                LEFT JOIN #dataSources.dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
                LEFT JOIN (
                    SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#CURRENT_YEAR#_1.STOCK_FIS AS SF 
                    LEFT JOIN #dataSources.dsn#_#CURRENT_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
                    UNION ALL
                    SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#PAST_YEAR#_1.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn#_#PAST_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
UNION ALL
                    SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn#_#TPAST_YEAR#_1.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn#_#TPAST_YEAR#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
                ) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
                LEFT JOIN #dataSources.dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
                LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
                LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
                LEFT JOIN #dataSources.dsn#.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
                INNER JOIN  #dataSources.dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
                WHERE 1=1             
                AND ORR.DELIVER_DEPT IN(#arguments.DEPARTMENT_ID#)
                AND ORR.DELIVER_LOCATION IN (#arguments.LOCATION_ID#)
                AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)
                AND SRR.PREPARE_PERSONAL IS NULL
                ORDER BY O.RECORD_DATE
        </cfquery>
         <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">                
 
            <cfdump var="#getDepWorks#">
           </cfsavecontent>
           <cffile action="write" file = "c:\PBS\depocfc_getDepartmentWorks.html" output="#control5#"></cffile>
        <cfset workArr=arrayNew(1)>
        <cfloop query="getDepWorks">
            <cfscript> aWork={
                DELIVER_PAPER_NO=DELIVER_PAPER_NO,
                NICKNAME=NICKNAME,
                SHIP_RESULT_ID=SHIP_RESULT_ID,
                TTS=TTS,
                KAYDEDEN=KAYDEDEN,
                IS_SVK=1
            };
            arrayAppend(workArr,aWork);
        </cfscript>
        </cfloop>
<cfquery name="getDemands" datasource="#datasources.dsn3#">
SELECT IR.QUANTITY,ISNULL(S.AMOUNT,0) AS AMOUNT,I.INTERNAL_NUMBER,I.DEPARTMENT_OUT,I.LOCATION_OUT,I.PROJECT_ID,workcube_metosan.getEmployeeWithId(EP.EMPLOYEE_ID) AS KAYDEDEN,I.INTERNAL_ID FROM #datasources.dsn3#.INTERNALDEMAND AS I
LEFT JOIN #datasources.dsn3#.INTERNALDEMAND_ROW AS IR ON IR.I_ID=I.INTERNAL_ID
LEFT JOIN (	SELECT SUM(AMOUNT) AMOUNT,WRK_ROW_RELATION_ID FROM (
			SELECT AMOUNT,WRK_ROW_RELATION_ID FROM #dataSources.dsn#_#CURRENT_YEAR#_1.SHIP_ROW AS S
			UNION
			SELECT AMOUNT,WRK_ROW_RELATION_ID FROM #dataSources.dsn#_#PAST_YEAR#_1.SHIP_ROW AS S 
            UNION
			SELECT AMOUNT,WRK_ROW_RELATION_ID FROM #dataSources.dsn#_#TPAST_YEAR#_1.SHIP_ROW AS S 
            ) AS T GROUP BY WRK_ROW_RELATION_ID )
			S ON S.WRK_ROW_RELATION_ID=IR.WRK_ROW_ID
LEFT JOIN #datasources.dsn#.EMPLOYEE_POSITIONS AS EP ON EP.POSITION_CODE=I.FROM_POSITION_CODE
WHERE DEMAND_TYPE=0 AND IR.PREPARE_PERSONAL IS NULL AND I.DEPARTMENT_OUT=#arguments.DEPARTMENT_ID# AND I.LOCATION_OUT=#arguments.LOCATION_ID# AND IR.QUANTITY-ISNULL(S.AMOUNT,0)>0 AND I.PROJECT_ID IS NOT NULL
</cfquery>
<cfloop query="getDemands">
    <cfscript> aWork={
        DELIVER_PAPER_NO=INTERNAL_NUMBER,
        NICKNAME="İç Talep",
        SHIP_RESULT_ID=INTERNAL_ID,
        TTS=0,
        KAYDEDEN=KAYDEDEN,
        IS_SVK=0
    };
    arrayAppend(workArr,aWork);
</cfscript>
</cfloop>

        <cfreturn Replace(SerializeJSON(workArr),'//','')>
    </cffunction>
    <cffunction name="setWorkEmployee" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfset dataSources=deserializeJSON(arguments.dataSources)>
      <cfset arguments.ship_id=listGetAt(arguments.empo,2,"-")>
      <cfset arguments.EMPLOYEE_ID=listGetAt(arguments.empo,1,"-")>
      <cfif arguments.IS_SVK eq 0>
        <cfquery name="upd" datasource="#datasources.dsn3#">
            UPDATE INTERNALDEMAND_ROW SET PREPARE_PERSONAL=#arguments.EMPLOYEE_ID# WHERE I_ID IN(#arguments.SHIP_ID#)
        </cfquery>

      <cfelse>
      <cfquery name="GETWORKS" datasource="#dataSources.dsn3#">
            SELECT  AMOUNT,DELIVER_DEPT,DELIVER_LOCATION,PRODUCT_NAME,PRODUCT_PLACE_ID,QUANTITY,SHELF_CODE,SHIP_RESULT_ROW_ID,STOCK_ID FROM (
SELECT ORR.QUANTITY,SF.AMOUNT,S.PRODUCT_NAME,PP.SHELF_CODE,ORR.DELIVER_DEPT,ORR.DELIVER_LOCATION,S.STOCK_ID,SRR.SHIP_RESULT_ROW_ID,PP.PRODUCT_PLACE_ID
FROM #dataSources.dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
LEFT JOIN #dataSources.dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
LEFT JOIN #dataSources.dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
LEFT JOIN (
SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dataSources.dsn2#.STOCK_FIS AS SF 
LEFT JOIN #dataSources.dsn2#.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dataSources.dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
LEFT JOIN #dataSources.dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
WHERE SRR.SHIP_RESULT_ID=#arguments.SHIP_ID#
AND ORR.DELIVER_DEPT IN(#arguments.DEPARTMENT_ID#) AND DELIVER_LOCATION IN(#arguments.LOCATION_ID#)
) AS TSL
        </cfquery>
        <cfdump var="#GETWORKS#">
        <cfset rows_=valueList(GETWORKS.SHIP_RESULT_ROW_ID)>
        <cfquery name="upo" datasource="#dataSources.dsn3#">
            UPDATE PRTOTM_SHIP_RESULT_ROW SET PREPARE_PERSONAL=#arguments.EMPLOYEE_ID# WHERE SHIP_RESULT_ROW_ID IN(#rows_#)
        </cfquery>
        </cfif>
    </cffunction>
</cfcomponent>