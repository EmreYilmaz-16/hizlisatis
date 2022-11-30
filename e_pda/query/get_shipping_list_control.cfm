
	<cfquery name="GET_SEVK_FIS" datasource="#DSN3#">
		SELECT 
        	*,
            CASE
            	WHEN TBL.COMPANY_ID IS NOT NULL THEN
                	(
                	SELECT     
                     	NICKNAME
                        FROM         
                            #dsn_alias#.COMPANY
                        WHERE     
                            COMPANY_ID = TBL.COMPANY_ID
                    )
            	WHEN TBL.CONSUMER_ID IS NOT NULL THEN      
                    (	
                        SELECT     
                            CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                        FROM         
                            #dsn_alias#.CONSUMER
                        WHERE     
                            CONSUMER_ID = TBL.CONSUMER_ID
                    )
         	END
              	AS UNVAN
       	FROM
        	(
            SELECT     
                ESR.SHIP_RESULT_ID, 
                ESR.NOTE, 
                ESR.SHIP_FIS_NO, 
                ESR.DELIVER_PAPER_NO, 
                ESR.REFERENCE_NO, 
                ESR.DELIVERY_DATE, 
                ESR.DEPARTMENT_ID, 
                ESR.COMPANY_ID, 
                ESR.CONSUMER_ID, 
                ESR.OUT_DATE, 
                ESR.IS_TYPE, 
                ESR.LOCATION_ID, 
                ESR.SHIP_METHOD_TYPE, 
                SM.SHIP_METHOD, 
                E.EMPLOYEE_NAME, 
                E.EMPLOYEE_SURNAME, 
                D.DEPARTMENT_HEAD,
                (
                 SELECT     
                 	ISNULL(SUM(ORR.QUANTITY), 0) AS AMOUNT
				FROM         
                	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    ORDERS ON ORR.ORDER_ID = ORDERS.ORDER_ID
				WHERE     
                	ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID 
                ) AS AMOUNT,
                (
                SELECT     
                	SUM(DURUM) AS DURUM
				FROM         
                	(
                    SELECT     
                    	DURUM
                  	FROM          
                    	(
                        SELECT     
                        	CASE 
                            	WHEN ORR.ORDER_ROW_CURRENCY = - 1 THEN 1 
                            	WHEN ORR.ORDER_ROW_CURRENCY = - 2 THEN 1 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 3 THEN 2 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 4 THEN 1 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 5 THEN 1 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 6 THEN 1 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 7 THEN 1 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 8 THEN 2 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 9 THEN 2 
                                WHEN ORR.ORDER_ROW_CURRENCY = - 10 THEN 2 
                                WHEN O.RESERVED = 0 THEN 0 
                  			END AS DURUM
                     	FROM          
                        	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                            ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
                     	WHERE      
                        	ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                     	) AS TBL2
                 	GROUP BY DURUM
                	) AS TBL3
                ) AS DURUM
            FROM       	
                PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                #dsn_alias#.SHIP_METHOD AS SM ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID INNER JOIN
                #dsn_alias#.EMPLOYEES AS E ON ESR.DELIVER_EMP = E.EMPLOYEE_ID INNER JOIN
                #dsn_alias#.DEPARTMENT AS D ON ESR.DEPARTMENT_ID = D.DEPARTMENT_ID
            WHERE 
                IS_TYPE = 1
                <cfif len(attributes.keyword) and  len(attributes.keyword) >
                	AND ESR.DELIVER_PAPER_NO LIKE '%#attributes.keyword#%'
                <cfelse>
					<cfif len(attributes.department_id)>
                        AND ESR.DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')# 
                        AND ESR.LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                    </cfif>
                    <cfif len(attributes.date1) and  len(attributes.date2) >
                        AND ESR.OUT_DATE BETWEEN #attributes.date1# AND #attributes.date2#
                    </cfif>
                </cfif>
          	UNION ALL
        	SELECT
            	SI.DISPATCH_SHIP_ID SHIP_RESULT_ID,
                (
                SELECT     
                	ORDER_DETAIL
                FROM          
                	ORDERS
                WHERE      
                	ORDER_ID = O.ORDER_ID
                ) AS NOTE,
                O.ORDER_NUMBER AS SHIP_FIS_NO,
                CAST(SI.DISPATCH_SHIP_ID AS VARCHAR(50)) AS DELIVER_PAPER_NO,
                '' AS REFERENCE_NO,
                SI.DELIVER_DATE AS DELIVERY_DATE,
                SI.DEPARTMENT_IN AS DEPARTMENT_ID,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                SI.DELIVER_DATE AS OUT_DATE,
                2 AS IS_TYPE,
                SI.LOCATION_IN AS LOCATION_ID,
                SI.SHIP_METHOD AS SHIP_METHOD_TYPE,
                SM.SHIP_METHOD,
                E.EMPLOYEE_NAME, 
                E.EMPLOYEE_SURNAME,
                D.DEPARTMENT_HEAD,
                ISNULL(SUM(SIR.AMOUNT), 0) AS AMOUNT,
                CASE
                	WHEN S.SHIP_ID IS NOT NULL THEN 2
                    WHEN S.SHIP_ID IS NULL THEN 1
                    END
               	AS DURUM     
			FROM         
            	#dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
           		#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
               	ORDER_ROW AS ORW ON SIR.ROW_ORDER_ID = ORW.ORDER_ROW_ID INNER JOIN
             	ORDERS AS O ON ORW.ORDER_ID = O.ORDER_ID INNER JOIN
              	#dsn_alias#.DEPARTMENT AS D ON SI.DEPARTMENT_IN = D.DEPARTMENT_ID LEFT OUTER JOIN
              	#dsn_alias#.SHIP_METHOD AS SM ON SI.SHIP_METHOD = SM.SHIP_METHOD_ID LEFT OUTER JOIN
             	#dsn_alias#.EMPLOYEES AS E ON SI.RECORD_EMP = E.EMPLOYEE_ID LEFT OUTER JOIN
              	#dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID LEFT OUTER JOIN
              	#dsn2_alias#.SHIP AS S ON SI.DISPATCH_SHIP_ID = S.DISPATCH_SHIP_ID
         	WHERE
            	1=1
                <cfif len(attributes.keyword) and  len(attributes.keyword) >
                	AND SI.DISPATCH_SHIP_ID LIKE '#attributes.keyword#%'
              	<cfelse>      
					<cfif len(attributes.department_id)>
                        AND SI.DEPARTMENT_OUT = #listgetat(attributes.department_id,1,'-')# 
                        AND SI.LOCATION_OUT = #listgetat(attributes.department_id,2,'-')#
                        
                    </cfif>
                    <cfif len(attributes.date1) and  len(attributes.date2) >
                        AND SI.DELIVER_DATE BETWEEN #attributes.date1# AND #attributes.date2#
                    </cfif>
                </cfif>
           	GROUP BY 
            	SI.DISPATCH_SHIP_ID,
                O.ORDER_NUMBER, 
                SI.DELIVER_DATE, 
                SI.DEPARTMENT_IN, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                SI.LOCATION_IN, 
                SI.SHIP_METHOD, 
                SM.SHIP_METHOD, 
                E.EMPLOYEE_NAME, 
                E.EMPLOYEE_SURNAME, 
                D.DEPARTMENT_HEAD, 
                O.ORDER_ID,
                S.SHIP_ID 
        	) AS TBL
    	WHERE
        	AMOUNT > 0
     	ORDER BY
        	IS_TYPE,UNVAN, SHIP_FIS_NO
	 </cfquery>
