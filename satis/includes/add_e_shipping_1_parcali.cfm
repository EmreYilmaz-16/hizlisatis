<cfset ATTRIBUTES.XML_MULTIPLE_COUNTING_FIS =1>
    <cfset ATTRIBUTES.FIS_DATE_H  ="00">
    <cfset ATTRIBUTES.FIS_DATE_M  ="0">
    <cftransaction>
    	<cfquery name="upd_order_row" datasource="#dsn3#"> <!---Sipariş Satırları Sevk Olacak--->
            UPDATE ORDER_ROW SET ORDER_ROW_CURRENCY = -6 WHERE ORDER_ID = #order_id#
        </cfquery> 
        <cfquery name="get_GEN_PAP" datasource="#DSN3#">
            SELECT        
                SHIP_FIS_NO,
                SHIP_FIS_NUMBER,
                SHIP_FIS_NO + '-' + CAST(SHIP_FIS_NUMBER+1 AS CHAR(6)) AS FISNO
            FROM            
                GENERAL_PAPERS
            WHERE        
                GENERAL_PAPERS_ID = 1
        </cfquery>
        <CFSET NEW_NUMBER = (get_GEN_PAP.SHIP_FIS_NUMBER*1) + 1>
        <cfquery name="ADD_SHIP_RESULT" datasource="#DSN3#" result="MAX_ID">
            INSERT INTO 
                PRTOTM_SHIP_RESULT
                (
                SHIP_METHOD_TYPE, 
                DELIVER_EMP, 
                DELIVER_PAPER_NO, 
                DELIVERY_DATE, 
                DEPARTMENT_ID, 
                SHIP_STAGE, 
                COMPANY_ID, 
                PARTNER_ID, 
                OUT_DATE, 
                IS_TYPE, 
                LOCATION_ID, 
                RECORD_EMP, 
                RECORD_IP, 
                RECORD_DATE
                )
            SELECT        
                 SHIP_METHOD, 
                ORDER_EMPLOYEE_ID, 
                '#get_GEN_PAP.FISNO#', 
                DELIVERDATE, 
                DELIVER_DEPT_ID, 
                #attributes.process_stage_eshipping#, 
                COMPANY_ID, 
                PARTNER_ID, 
                ORDER_DATE, 
                1 AS TYPE, 
                LOCATION_ID, 
                RECORD_EMP, 
                RECORD_IP, 
                RECORD_DATE
            FROM            
                ORDERS
            WHERE        
                ORDER_ID = #order_id#
        </cfquery>
        <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
            UPDATE GENERAL_PAPERS SET SHIP_FIS_NUMBER = #NEW_NUMBER# WHERE SHIP_FIS_NUMBER IS NOT NULL
        </cfquery>
        <cfquery name="ADD_SHIP_RESULT_ROW" datasource="#DSN3#">
            INSERT INTO 
            PRTOTM_SHIP_RESULT_ROW
                (
                SHIP_RESULT_ID, 
                ORDER_ID, 
                ORDER_ROW_ID, 
                ORDER_ROW_AMOUNT
                )
            SELECT        
                #MAX_ID.IDENTITYCOL#, 
                ORDER_ID, 
                ORDER_ROW_ID, 
                QUANTITY
            FROM            
                ORDER_ROW
            WHERE        
                ORDER_ROW_ID IN(#pbs_row_ids#)
        </cfquery>
    </cftransaction>
   

BİTTİ