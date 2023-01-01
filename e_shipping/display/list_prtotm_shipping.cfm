<cfsetting showdebugoutput="yes">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.order_employee" default="#get_emp_info(session.ep.userid,0,0)# ">
<cfparam name="attributes.order_employee_id" default="#session.ep.userid#">
<cfparam name="attributes.listing_type" default="2">
<cfparam name="attributes.sort_type" default="3">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.report_type_id" default="3">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.t_point" default="0">
<cfparam name="attributes.SHIP_METHOD_ID" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.totalrecords" default="0">
<cfquery name="get_default_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID, LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.POSITION_CODE# AND OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfif get_default_department.recordcount>
	<cfparam name="attributes.sales_departments" default="#get_default_department.DEPARTMENT_ID#-#get_default_department.LOCATION_ID#">
<cfelse>
	<cfparam name="attributes.sales_departments" default="">
</cfif>
<cfquery name="get_locations" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID
  	FROM 
    	EMPLOYEE_POSITION_BRANCHES 
  	WHERE  
    	POSITION_CODE = #session.ep.POSITION_CODE# AND 
        LOCATION_CODE IS NOT NULL AND
        BRANCH_ID IN
        			(
        				SELECT        
                        	BRANCH_ID
						FROM            
                        	BRANCH
						WHERE        
                        	BRANCH_STATUS = 1 AND 
                            COMPANY_ID = #session.ep.COMPANY_ID#
        			)
</cfquery>
<cfif not get_locations.recordcount>
	<script type="text/javascript">
     	alert("Bu Şirket İçin Tanımlanmış Depo ve Lokasyon Bulunamamıştır!");
     	history.go(-1);
  	</script>
 	<cfabort>
<cfelse>
	<cfset condition_departments_list = ValueList(get_locations.DEPARTMENT_ID)>
    <cfset condition_departments_list = ListDeleteDuplicates(condition_departments_list,',')>
</cfif>
<cfset cat_criter1 = '01.152.'>
<cfset cat_criter2 = '01.153.'>
<cfset lnk_str = '#cat_criter1#,#cat_criter2#'>
<cfif len(attributes.SHIP_METHOD_ID)>
	<cfset lnk_str = lnk_str &',#attributes.SHIP_METHOD_ID#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif> 
<cfif len(attributes.city_name)>
	<cfset lnk_str = lnk_str &',#attributes.city_name#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.sales_departments)>
	<cfset lnk_str = lnk_str &',#attributes.sales_departments#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif> 
<cfif len(attributes.prod_cat)>
	<cfset lnk_str = lnk_str &',#attributes.prod_cat#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif> 
<cfif len(attributes.product_id)>
	<cfset lnk_str = lnk_str &',#attributes.product_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.consumer_id)>
	<cfset lnk_str = lnk_str &',#attributes.consumer_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.company_id)>
	<cfset lnk_str = lnk_str &',#attributes.company_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.order_employee_id)>
	<cfset lnk_str = lnk_str &',#attributes.order_employee_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.finish_date)>
	<cfset lnk_str = lnk_str &',#attributes.finish_date#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.start_date)>
	<cfset lnk_str = lnk_str &',#attributes.start_date#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.listing_type)>
	<cfset lnk_str = lnk_str &',#attributes.listing_type#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.sort_type)>
	<cfset lnk_str = lnk_str &',#attributes.sort_type#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.branch_id)>
	<cfset lnk_str = lnk_str &',#attributes.branch_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif len(attributes.zone_id)>
	<cfset lnk_str = lnk_str &',#attributes.zone_id#'>
<cfelse>
	<cfset lnk_str = lnk_str &','&' '>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cfset lnk_str = lnk_str & ",1">
<cfelse>
    <cfset lnk_str = lnk_str & ",0">
</cfif>
<cfset son_row = 0>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif isdefined("attributes.form_varmi")>
	<!---Birleştirdikten sonra adres veya sevk yöntemi değiştirilmiş mi kontrol ediliyor--->
    <cfquery name="get_period_id" datasource="#dsn#">
    	SELECT        
        	PERIOD_YEAR
		FROM            
        	SETUP_PERIOD
		WHERE        
        	OUR_COMPANY_ID = #session.ep.company_id# AND 
            PERIOD_YEAR < #session.ep.period_year#
    </cfquery>
	<cfquery name="hata_kontrol" datasource="#dsn3#">
    	SELECT     
        	SHIP_RESULT_ID
		FROM         
        	(
            SELECT     
            	ESR.SHIP_RESULT_ID, 
                O.SHIP_METHOD, 
                O.CITY_ID, 
                O.COUNTY_ID
         	FROM          
            	PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
        	WHERE
            	1=1      
            	<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                   AND ESR.OUT_DATE >= #attributes.start_date#
             	</cfif>
                <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                   AND ESR.OUT_DATE <= #attributes.finish_date#
                </cfif>
        	GROUP BY 
            	ESR.SHIP_RESULT_ID, 
                O.SHIP_METHOD, 
                O.CITY_ID, 
                O.COUNTY_ID
        	) AS TBL
		GROUP BY 
        	SHIP_RESULT_ID
		HAVING      
        	COUNT(*) > 1
    </cfquery>
    <cfquery name="cari_kontrol" datasource="#dsn3#"> <!---Sevk Planı Hazırlandıktan sonra Cari Değişmiş mi ?--->
    	SELECT     
        	SHIP_RESULT_ID, 
            COMPANY_ID, 
            CONSUMER_ID, 
            COMP_ID, 
            CONS_ID
		FROM         
        	(
            SELECT     
            	ESR.SHIP_RESULT_ID, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                ESR.COMPANY_ID AS COMP_ID, 
                ESR.CONSUMER_ID AS CONS_ID
        	FROM          
            	PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
       		WHERE      
            	1 = 1
      		GROUP BY 
        		ESR.SHIP_RESULT_ID, 
            	O.COMPANY_ID, 
                O.CONSUMER_ID, 
                ESR.COMPANY_ID, 
                ESR.CONSUMER_ID
          	) AS TBL
		WHERE     
        	COMPANY_ID <> COMP_ID OR CONSUMER_ID <> CONS_ID
    </cfquery>
    <cfif hata_kontrol.recordcount>
    	<cfset tip =1>
    	<cfset hata_id_list = Valuelist(hata_kontrol.SHIP_RESULT_ID)>
        <cfquery name="GET_SHIPPING" datasource="#dsn3#"> 
        	SELECT     
                O.ORDER_NUMBER,
                O.ORDER_ID,
                ESR.DELIVER_PAPER_NO,
                ESR.SHIP_RESULT_ID,  
                SC.CITY_NAME, 
                SCO.COUNTY_NAME, 
                SM.SHIP_METHOD, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                O.EMPLOYEE_ID,
                ESR.OUT_DATE
			FROM         
            	PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID LEFT OUTER JOIN
                #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID LEFT OUTER JOIN
                #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID LEFT OUTER JOIN
                #dsn_alias#.SHIP_METHOD AS SM ON O.SHIP_METHOD = SM.SHIP_METHOD_ID
			WHERE     
            	ESR.SHIP_RESULT_ID IN (#hata_id_list#)
			GROUP BY 
            	O.ORDER_NUMBER,
                O.ORDER_ID, 
                ESR.DELIVER_PAPER_NO, 
                ESR.SHIP_RESULT_ID,
                SC.CITY_NAME, 
                SCO.COUNTY_NAME, 
                SM.SHIP_METHOD, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                O.EMPLOYEE_ID,
                ESR.OUT_DATE
			ORDER BY 
        		ESR.SHIP_RESULT_ID
       	</cfquery>
  	<cfelseif cari_kontrol.recordcount>
    	<cfset tip =2>
    	<cfset hata_id_list = Valuelist(cari_kontrol.SHIP_RESULT_ID)>
        <cfquery name="GET_SHIPPING" datasource="#dsn3#"> 
        	SELECT     
                O.ORDER_NUMBER,
                O.ORDER_ID,
                ESR.DELIVER_PAPER_NO,
                ESR.SHIP_RESULT_ID,
                ESR.COMPANY_ID COMP_ID,
                ESR.CONSUMER_ID CONS_ID,  
                SC.CITY_NAME, 
                SCO.COUNTY_NAME, 
                SM.SHIP_METHOD, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                O.EMPLOYEE_ID,
                ESR.OUT_DATE
			FROM         
            	PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID LEFT OUTER JOIN
                #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID LEFT OUTER JOIN
                #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID LEFT OUTER JOIN
                #dsn_alias#.SHIP_METHOD AS SM ON O.SHIP_METHOD = SM.SHIP_METHOD_ID
			WHERE     
            	ESR.SHIP_RESULT_ID IN (#hata_id_list#)
			GROUP BY 
            	O.ORDER_NUMBER,
                O.ORDER_ID, 
                ESR.DELIVER_PAPER_NO, 
                ESR.SHIP_RESULT_ID,
                ESR.COMPANY_ID,
                ESR.CONSUMER_ID,
                SC.CITY_NAME, 
                SCO.COUNTY_NAME, 
                SM.SHIP_METHOD, 
                O.COMPANY_ID, 
                O.CONSUMER_ID, 
                O.EMPLOYEE_ID,
                ESR.OUT_DATE
			ORDER BY 
        		ESR.SHIP_RESULT_ID
       	</cfquery>
    <cfelse>
        <cfquery name="GET_SHIPPING" datasource="#dsn3#"><!---Sevk Planları ve Sevk Talepleri Listeleniyor--->
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
                <cfif listing_type neq 3>
                    <cfif not len(attributes.branch_id)>
                        SELECT   
                        	(
                                SELECT DISTINCT 
                                	O.ORDER_ID
								FROM            
                                	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                         			ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                         			ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ) AS ORDER_ID,  
                        	(
                                SELECT DISTINCT 
                                	O.ORDER_EMPLOYEE_ID
								FROM            
                                	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                         			ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                         			ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ) AS ORDER_EMPLOYEE_ID,
                            ESR.SEVK_EMIR_DATE,
                            ISNULL(ESR.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR,
                            ISNULL(ESR.SEVK_EMP,0) SEVK_EMP,
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
                                SELECT DISTINCT 
                                    SC.CITY_NAME
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID INNER JOIN
                                    #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ) AS SEHIR,
                            (
                                SELECT DISTINCT 
                                    SCO.COUNTY_NAME
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID INNER JOIN
                                    #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ) AS ILCE,
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
                            ) AS DURUM,
                            (
                            SELECT     
                                SUM(SEVK_DURUM) AS SEVK_DURUM
                            FROM         
                                (
                                SELECT     
                                    SEVK_DURUM
                                FROM          
                                    (
                                    SELECT     
                                        CASE 
                                            WHEN ORR.ORDER_ROW_CURRENCY = - 3 THEN 1 
                                            WHEN ORR.ORDER_ROW_CURRENCY = - 6 THEN 4
                                            WHEN ORR.ORDER_ROW_CURRENCY = - 8 THEN 1 
                                            WHEN ORR.ORDER_ROW_CURRENCY = - 9 THEN 1
                                            WHEN ORR.ORDER_ROW_CURRENCY = - 10 THEN 1
                                            ELSE 2
                                        END AS SEVK_DURUM
                                    FROM          
                                        PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                        ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
                                    WHERE      
                                        ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                                    ) AS TBL2
                                GROUP BY SEVK_DURUM
                                ) AS TBL3
                            ) AS SEVK_DURUM
                        FROM       	
                            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                            #dsn_alias#.SHIP_METHOD AS SM ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID INNER JOIN
                            #dsn_alias#.EMPLOYEES AS E ON ESR.DELIVER_EMP = E.EMPLOYEE_ID INNER JOIN
                            #dsn_alias#.DEPARTMENT AS D ON ESR.DEPARTMENT_ID = D.DEPARTMENT_ID
                        WHERE 
                            IS_TYPE = 1
                            AND ESR.DEPARTMENT_ID IN (#condition_departments_list#)
                            <cfif isdefined('attributes.product_id') and len(attributes.product_id)>
                                AND ESR.SHIP_RESULT_ID IN
                                                    (
                                                    SELECT DISTINCT 
                                                        ESRR.SHIP_RESULT_ID
                                                    FROM          
                                                        PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
                                                    WHERE      
                                                        ORR.PRODUCT_ID = #attributes.product_id#
                                                    )
                            </cfif>
                            <cfif isdefined('attributes.prod_cat') and len(attributes.prod_cat)>
                                AND ESR.SHIP_RESULT_ID IN
                                                        (
                                                        SELECT DISTINCT 
                                                            ESRR.SHIP_RESULT_ID
                                                        FROM          
                                                            PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                                            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                            STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
                                                        WHERE      
                                                            S.STOCK_CODE LIKE N'#attributes.prod_cat#%'
                                                        )                          
                            </cfif>
                            <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                                AND ESR.DEPARTMENT_ID = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                                AND ESR.LOCATION_ID = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                                
                            </cfif>
                            <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                                AND ESR.OUT_DATE >= #attributes.start_date#
                            </cfif>
                            <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                                AND ESR.OUT_DATE <= #attributes.finish_date#
                            </cfif>
                        <cfif listing_type eq 1>      
                            UNION ALL
                        </cfif>
                    </cfif>
                </cfif>
                <cfif listing_type neq 2>
                    SELECT
                    	O.ORDER_ID,
                    	O.ORDER_EMPLOYEE_ID,
                        SI.SEVK_EMIR_DATE,
                       	ISNULL(SI.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR,
                        ISNULL(SI.SEVK_EMP,0) as SEVK_EMP,
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
                        SC.CITY_NAME AS SEHIR,
                        SCO.COUNTY_NAME ILCE,
                        ISNULL(SUM(SIR.AMOUNT), 0) AS AMOUNT,
                        CASE
                            WHEN 
                            	S.SHIP_ID IS NOT NULL 
                           	THEN 2
                            WHEN 
                            	S.SHIP_ID IS NULL 
                          	THEN 1
                       	END AS DURUM,
                        (
                        	SELECT     
                              	SUM(SEVK_DURUM) AS SEVK_DURUM
                         	FROM         
                            	(
                                    SELECT     
                                        SEVK_DURUM
                                    FROM          
                                        (
                                        	SELECT        
                                            	CASE 
                                                	WHEN ORDER_ROW_CURRENCY = - 6 THEN 4 
                                                    WHEN ORDER_ROW_CURRENCY = - 9 THEN 1 
                                                    WHEN ORDER_ROW_CURRENCY = - 8 THEN 1 
                                                    WHEN ORDER_ROW_CURRENCY = - 3 THEN 1 
                                                    WHEN ORDER_ROW_CURRENCY = - 10 THEN 1 
                                              		ELSE 2 
                                              	END AS SEVK_DURUM
											FROM            
                                            	ORDER_ROW AS ORR_ INNER JOIN
                         						#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR_ ON ORR_.ORDER_ROW_ID = SIR_.ROW_ORDER_ID
											WHERE        
                                            	SIR_.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID
                                        ) AS TBL1
                                    GROUP BY 
                                        SEVK_DURUM
                           		) AS TBL2
                        ) AS SEVK_DURUM
                    FROM         
                      	#dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                        ORDER_ROW AS ORW ON SIR.ROW_ORDER_ID = ORW.ORDER_ROW_ID INNER JOIN
                        ORDERS AS O ON ORW.ORDER_ID = O.ORDER_ID INNER JOIN
                        #dsn_alias#.DEPARTMENT AS D ON SI.DEPARTMENT_IN = D.DEPARTMENT_ID LEFT OUTER JOIN
                        #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID LEFT OUTER JOIN
                        #dsn_alias#.SHIP_METHOD AS SM ON SI.SHIP_METHOD = SM.SHIP_METHOD_ID LEFT OUTER JOIN
                        #dsn_alias#.EMPLOYEES AS E ON SI.RECORD_EMP = E.EMPLOYEE_ID LEFT OUTER JOIN
                        #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID LEFT OUTER JOIN
                        #dsn2_alias#.SHIP AS S ON SI.DISPATCH_SHIP_ID = S.DISPATCH_SHIP_ID
                    WHERE
                        1=1 AND
                        SI.DEPARTMENT_OUT IN (#condition_departments_list#)
                        <cfif isdefined('attributes.product_id') and len(attributes.product_id)>
                            AND SI.DISPATCH_SHIP_ID IN
                                                    (
                                                    SELECT     
                                                        SI.DISPATCH_SHIP_ID
                                                    FROM         
                                                        #dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                                                        STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID
                                                    WHERE     
                                                        S.PRODUCT_ID = #attributes.product_id#
                                                    GROUP BY 
                                                        SI.DISPATCH_SHIP_ID
                                                    ) 
                        </cfif>
                        <cfif isdefined('attributes.prod_cat') and len(attributes.prod_cat)>
                            AND SI.DISPATCH_SHIP_ID IN
                                                    (
                                                    SELECT     
                                                        SI.DISPATCH_SHIP_ID
                                                    FROM         
                                                        #dsn2_alias#.SHIP_INTERNAL AS SI INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                                                        STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID
                                                    WHERE     
                                                        S.STOCK_CODE LIKE N'#attributes.prod_cat#%'
                                                    GROUP BY 
                                                        SI.DISPATCH_SHIP_ID
                                                    )                          
                        </cfif>
                        <cfif isdefined('attributes.SALES_DEPARTMENTS') and len(attributes.SALES_DEPARTMENTS)>
                            AND SI.DEPARTMENT_OUT = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 



                            AND SI.LOCATION_OUT = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                        </cfif>
                        <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                            AND SI.DELIVER_DATE >= #attributes.start_date#
                        </cfif>
                        <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                            AND SI.DELIVER_DATE <= #attributes.finish_date#
                        </cfif>
                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                            AND SI.DEPARTMENT_IN IN
                                                    (
                                                    SELECT     
                                                        DEPARTMENT_ID
                                                    FROM         
                                                        #dsn_alias#.DEPARTMENT
                                                    WHERE     
                                                        BRANCH_ID = #attributes.branch_id#
                                                    )
                        </cfif>      
                    GROUP BY 
                    	O.ORDER_EMPLOYEE_ID,
                        SI.DISPATCH_SHIP_ID,
                        SI.SEVK_EMIR_DATE,
                       	SI.IS_SEVK_EMIR,
                        SI.SEVK_EMP,
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
                        SC.CITY_NAME,
                        SCO.COUNTY_NAME,
                        O.ORDER_ID,
                        S.SHIP_ID
                </cfif> 
                ) AS TBL
            WHERE
                AMOUNT > 0
                <cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and len(attributes.order_employee)>
                  	AND	ORDER_EMPLOYEE_ID = #attributes.order_employee_id#
             	</cfif>
                <cfif isdefined('attributes.city_name') and len(attributes.city_name)>
                    AND SEHIR ='#attributes.city_name#' 
                </cfif>
                <cfif isdefined('attributes.SHIP_METHOD_ID') and len(attributes.SHIP_METHOD_ID)>
                    AND SHIP_METHOD_TYPE ='#attributes.SHIP_METHOD_ID#' 
                </cfif>
                <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                    AND COMPANY_ID =#attributes.company_id#
                </cfif>
                <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                    AND CONSUMER_ID =#attributes.consumer_id# 
                </cfif>
                <cfif len(attributes.keyword)>
                    AND 
                    	(
                        REFERENCE_NO LIKE '%#attributes.keyword#%' OR
                        DELIVER_PAPER_NO LIKE '%#attributes.keyword#%' OR
                        SHIP_FIS_NO LIKE '%#attributes.keyword#%'
                        )
                </cfif>
              	<cfif len(attributes.zone_id)>  
                	AND (
                    	COMPANY_ID IN 	
                    				(
                                        SELECT     
                                        	COMPANY_ID
										FROM         
                                        	#dsn_alias#.COMPANY
										WHERE     
                                        	SALES_COUNTY IN
                          									(
                                                            	SELECT     
                                                                	SZ_ID
                            									FROM          
                                                                	#dsn_alias#.SALES_ZONES
                            									WHERE      
                                                                	SZ_HIERARCHY LIKE '#attributes.zone_id#%'
                                                           	) 
                                   	)
                       	OR
                   		CONSUMER_ID IN 	
                    				(
                                        SELECT     
                                        	CONSUMER_ID
										FROM         
                                        	#dsn_alias#.CONSUMER
										WHERE     
                                        	SALES_COUNTY IN
                          									(
                                                            	SELECT     
                                                                	SZ_ID
                            									FROM          
                                                                	#dsn_alias#.SALES_ZONES
                            									WHERE      
                                                                	SZ_HIERARCHY LIKE '#attributes.zone_id#%'
                                                           	) 
                                   	)
                                    
                  		)  
              	</cfif>
    			<cfif attributes.report_type_id eq 1>
                	AND DURUM = 1
                <cfelseif attributes.report_type_id eq 2>
                	AND DURUM = 2
                <cfelseif attributes.report_type_id eq 3>
                	AND SEVK_DURUM = 4
               	 <cfelseif attributes.report_type_id eq 4>
                	AND SEVK_DURUM = 6
                </cfif>
            ORDER BY
            SHIP_RESULT_ID DESC,
                <cfif sort_type eq 1>
                    OUT_DATE
                <cfelseif sort_type eq 2>
                    OUT_DATE desc
                <cfelseif sort_type eq 3>
                    DELIVER_PAPER_NO
                <cfelseif sort_type eq 4>
                    DELIVER_PAPER_NO desc
                <cfelseif sort_type eq 5>
                    IS_TYPE,DEPARTMENT_ID,UNVAN, SHIP_FIS_NO
                </cfif>
        </cfquery>
        <cfset arama_yapilmali = 0>
        <cfset attributes.totalrecords = GET_SHIPPING.recordcount>
	</cfif>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_order_list.recordcount = 0>
</cfif>
<cfquery name="get_department_name" datasource="#DSN#">
	SELECT 
		SL.LOCATION_ID,
		SL.COMMENT,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID
	FROM
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE 
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#)
        AND D.DEPARTMENT_ID IN (#condition_departments_list#)
	ORDER BY
		D.DEPARTMENT_HEAD,
		SL.COMMENT
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_kur" datasource="#dsn#">
	SELECT (RATE2/RATE1) RATE,MONEY,RECORD_DATE FROM MONEY_HISTORY ORDER BY MONEY_HISTORY_ID DESC
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD ORDER BY SHIP_METHOD
</cfquery>
<cfquery name="GET_PRODUCT_CATS" datasource="#dsn1#">
	SELECT     
    	PC.HIERARCHY, 
        PC.PRODUCT_CAT
	FROM         
    	PRODUCT_CAT AS PC INNER JOIN
        PRODUCT_CAT_OUR_COMPANY AS PCOC ON PC.PRODUCT_CATID = PCOC.PRODUCT_CATID
	WHERE     
    	PCOC.OUR_COMPANY_ID = #session.ep.company_id# 
 	ORDER BY
    	PRODUCT_CAT
</cfquery>

<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_big_list_search title="Sevkiyat İşlemleri">
    <cf_big_list_search_area>
        <cf_object_main_table>
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_object_table column_width_list="50,150">

                <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                <cf_object_tr id="form_ul_keyword" title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                    <cf_object_td>
                        <cfinput type="text" name="keyword" maxlength="50" style="width:150px;" value="#attributes.keyword#">                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_">Tümü</cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                        <select name="report_type_id" id="report_type_id" style="width:120px;height:20px">
							<option value="" <cfif attributes.report_type_id eq ''>selected</cfif>>Tümü</option>
							<option value="1" <cfif attributes.report_type_id eq '1'>selected</cfif>>Açık Sevkler</option>
                            <option value="2" <cfif attributes.report_type_id eq '2'>selected</cfif>>Kapalı Sevkler</option>
                            <option value="3" <cfif attributes.report_type_id eq '3'>selected</cfif>>Hazır Sevkler</option>
                            <option value="4" <cfif attributes.report_type_id eq '4'>selected</cfif>>Kısmi Hazır Sevkler</option>
					</select>                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,75">
                <cfsavecontent variable="header_"><cf_get_lang_main no='247.Satis Bölgesi'></cfsavecontent>
                <cf_object_tr id="zone_id" title="#header_#">
                    <cf_object_td>
                        <select name="zone_id" id="zone_id" style="width:100px;height:20px">
						<option value=""><cf_get_lang_main no='247.Satis Bölgesi'></option>
						<cfoutput query="sz">
							<option value="#SZ_HIERARCHY#" <cfif attributes.zone_id eq SZ_HIERARCHY>selected</cfif>>#sz_name#</option>
						</cfoutput>
					</select>                    
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
           
            <cf_object_table column_width_list="185">
                <cfsavecontent variable="header_">Sıralama</cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="sort_type" id="sort_type" style="width:180px;height:20px">
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>>Teslim Tarihine Göre Artan</option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Teslim Tarihine Gre Azalan</option>
                            <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Belge Numarasına Göre Artan</option>
                            <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Belge Numarasına Göre Azalan</option>
                            <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Şirket Adına Göre Artan</option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="95">
                <cfsavecontent variable="header_">Liste Tipi</cfsavecontent>
                <cf_object_tr id="form_ul_sort_type" title="#header_#">
                    <cf_object_td>
                        <select name="listing_type" id="listing_type" style="width:90px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>>Tümü</option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>>Sevk Planları</option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>>Sevk Talepler</option>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table> 
            <cf_object_table column_width_list="90">
                <cfsavecontent variable="header_">Tarih</cfsavecontent>
                <cf_object_tr id="form_ul_start_date" title="#header_#">
                    <cf_object_td>
                        <cfif session.ep.our_company_info.unconditional_list>
                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                        <cfelse>
                            <cfsavecontent variable="message">Baslangi Tarihi Kontrol Ediniz</cfsavecontent>
                            <cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                        </cfif>
                        <cf_wrk_date_image date_field="start_date">                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90">
                <cfsavecontent variable="header_">Tarih</cfsavecontent>
                <cf_object_tr id="form_ul_finish_date" title="#header_#">
                    <cf_object_td>
                        <cfif session.ep.our_company_info.unconditional_list>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                        <cfelse>
                            <cfsavecontent variable="message">Bitis Tarihi Kontrol Ediniz</cfsavecontent>
                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                        </cfif>
                        <cf_wrk_date_image date_field="finish_date">                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>    
            
            <cf_object_table column_width_list="150">
                <cf_object_tr id="">
                    <cf_object_td>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=eshipping.popup_list_prtotm_shipping_graph</cfoutput>','longpage');" class="tableyazi">
                        	<img src="../../../images/graph.gif" align="absmiddle" border="0" title="Sevkiyat Perspektif" />
                      	</a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=eshipping.popup_list_partner_shipping_deliver</cfoutput>','longpage');" class="tableyazi">
                        	<img src="../../../images/target_customer.gif" align="absmiddle" border="0" title="Sevk Planı Açılacak Siparişler" />
                      	</a>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        <cf_wrk_search_button search_function='input_control()'>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>        
        </cf_object_main_table>
    </cf_big_list_search_area>
    <cf_big_list_search_detail_area>
        <cf_object_main_table>
            <cf_object_table column_width_list="100,140">
                <cfsavecontent variable="header_">Satış Yapan</cfsavecontent>
                <cf_object_tr id="form_ul_order_employee" title="#header_#">
                    <cf_object_td type="text" td_style="text-align:right;">Satış Yapan</cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee_id#</cfoutput></cfif>">
                        <input name="order_employee" type="text" id="order_employee" style="width:115px;" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee#</cfoutput></cfif>" autocomplete="off">	
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=order_form.order_employee_id&field_name=order_form.order_employee&is_form_submitted=1&select_list=1','list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>		   
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="90,140">
                <cfsavecontent variable="header_"><cf_get_lang_main no='107.Cari Hesap'></cfsavecontent>
                <cf_object_tr id="form_ul_member_name" title="#header_#">
                    <cf_object_td  td_style="text-align:right;" type="text"><cf_get_lang_main no='107.Cari Hesap'></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                        <input name="member_name" type="text" id="member_name" style="width:115px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                        <cfset str_linke_ait="&field_consumer=order_form.consumer_id&field_comp_id=order_form.company_id&field_member_name=order_form.member_name&field_type=order_form.member_type">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif fusebox.circuit eq "store">&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.order_form.member_name.value),'list');">
                            <img src="/images/plus_thin.gif" style="vertical-align:bottom">
                        </a>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,145">
                <cfsavecontent variable="header_"><cf_get_lang_main no='245.Ürün'></cfsavecontent>
                <cf_object_tr id="form_ul_product_name" title="#header_#">
                    <cf_object_td td_style="text-align:right;" type="text"><cf_get_lang_main no='245.Ürün'></cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                        <input name="product_name" type="text" id="product_name" style="width:120px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=order_form.product_id&field_name=order_form.product_name&keyword='+encodeURIComponent(document.order_form.product_name.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,145">
                <cfsavecontent variable="header_"><cf_get_lang_main no='1604.rn Kategorileri'></cfsavecontent>
                <cf_object_tr id="form_ul_prod_cat" title="#header_#">
                    <cf_object_td>
                        <select name="prod_cat" id="prod_cat" style="width:140px;height:20px">
                            <option value=""><cf_get_lang_main no='1604.rn Kategorileri'></option>
                            <cfoutput query="GET_PRODUCT_CATS">
                            	<cfif listlen(hierarchy,".") gte 4>
                                <option value="#hierarchy#"<cfif (attributes.prod_cat eq hierarchy) and len(attributes.prod_cat) eq len(hierarchy)> selected</cfif>>#product_cat#</option>
                                </cfif>
                            </cfoutput>
                        </select>                       
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
             <cf_object_table column_width_list="75">
              	<cfsavecontent variable="header_">Şube</cfsavecontent>
               	<cf_object_tr id="form_ul_branch_id" title="#header_#">
                 	<cf_object_td>
                    	<select name="branch_id" id="branch_id" style="width:70px;height:20px">
                        	<option value=""><cf_get_lang_main no='41.Sube'></option>
                         	<cfoutput query="get_branch">
                           		<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                   		</select>        
              		</cf_object_td>
           		</cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,135">
                <cfsavecontent variable="header_">Depo- Lokasyon</cfsavecontent>
                <cf_object_tr id="form_ul_sales_departments" title="#header_#">
                    <cf_object_td>
                        <select name="sales_departments" id="sales_departments" style="width:130px;height:20px">
                            <option value="">Depo- Lokasyon</option>
                            <cfoutput query="get_department_name">
                                <option value="#department_id#-#location_id#" <cfif isdefined("attributes.sales_departments") and attributes.sales_departments is '#department_id#-#location_id#'>selected</cfif>>#department_head#-#comment#</option>
                            </cfoutput>
                        </select>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="105">
                <cfsavecontent variable="header_">Şehir</cfsavecontent>
                <cf_object_tr id="form_city_name" title="#header_#">
                    <cf_object_td>
                        <select name="city_name" id="city_name" style="width:100px;height:20px">
                            <option value="">Şehir</option>
                            <cfoutput query="get_city">
                                <option value="#city_name#" <cfif isdefined("attributes.city_name") and attributes.city_name is '#city_name#'>selected</cfif>>#city_name#</option>
                            </cfoutput>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>   
         	<cf_object_table column_width_list="105">
                <cfsavecontent variable="header_">Sevk Yöntemi</cfsavecontent>
                <cf_object_tr id="form_ship_method" title="#header_#">
                    <cf_object_td>
                        <select name="SHIP_METHOD_ID" id="SHIP_METHOD_ID" style="width:100px;height:20px">
                            <option value="">Sevk Yöntemi</option>
                            <cfoutput query="GET_SHIP_METHOD">
                                <option value="#SHIP_METHOD_ID#" <cfif isdefined("attributes.SHIP_METHOD_ID") and attributes.SHIP_METHOD_ID eq SHIP_METHOD_ID>selected</cfif>>#SHIP_METHOD#</option>
                            </cfoutput>
                        </select>                 
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
        </cf_object_main_table>                               
    </cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
	<table class="big_list">
		<thead>
			<tr height="15">
				<th rowspan="2" style="width:30px;text-align:center" class="header_icn_txt"><cf_get_lang_main no='1165.Sira'></th>
				<th rowspan="2" style="width:55px;text-align:center"><cf_get_lang_main no='75.no'></th>
				<th rowspan="2" style="width:60px;text-align:center"><cf_get_lang_main no='330.tarih'></th>
				<th rowspan="2" style="text-align:center"><cf_get_lang_main no='162.sirket'></th>
				<th rowspan="2" style="width:100px;text-align:center"><cf_get_lang_main no='487.Kaydeden'></th>
				<th rowspan="2" style="width:100px;text-align:center">Sevk Yöntemi</th>
                <th colspan="5" style="width:100px;text-align:center">Süreç Kontrol</th>
				<th rowspan="2" style="width:100px;text-align:center">Takip</th>
                <th rowspan="2" style="width:50px;text-align:center">S.Puan</th>
                <th rowspan="2" style="width:90px;text-align:center">Şehir</th> 
				<th rowspan="2" style="width:180px;text-align:center">Açıklama</th>
				<!-- sil -->
				<th rowspan="2" style="width:20px" class="header_icn_none" nowrap="nowrap">
                	
                	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=79&action_id=#lnk_str#</cfoutput>','wide');"><img src="/images/print_plus.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>">
               		</a>
                </th>
                <th rowspan="2" style="width:20px;text-align:center"><input type="checkbox" alt="Hepsini Seç" onClick="grupla(-1);"></th>
				<!-- sil -->


			</tr>
            <tr height="10">
            	<!---<th style="width:20px;text-align:center">RZV</th>
                <th style="width:20px;text-align:center">GRŞ</th>--->
                <th style="width:20px;text-align:center">SVK</th>
                <th style="width:20px;text-align:center">HZR</th>
                <th style="width:20px;text-align:center">CNT</th>
                <th style="width:20px;text-align:center">İRS</th>
                <th style="width:20px;text-align:center">FTR</th>

            </tr>
		</thead>
		<tbody>
        	<cfset t_point =#attributes.t_point#>
        	<cfif isdefined("attributes.form_varmi") and GET_SHIPPING.recordcount>
            	<cfif hata_kontrol.recordcount or cari_kontrol.recordcount> <!---Hatalı İşlemler Varsa Listeleniyor--->
					<cfoutput query="GET_SHIPPING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    	<tr>
                    		<td>#currentrow#</td>
                            <td style="text-align:center">
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','page');" class="tableyazi" title="Sevk Fişine Git">
	                                #DELIVER_PAPER_NO#
                                </a>
							</td>
                            <td style="text-align:center">#DateFormat(OUT_DATE,'dd/mm/yyyy')#</td>
                            <td>
                            	<cfif len(company_id)>
                                	#get_par_info(COMPANY_ID,1,1,0)#
                                <cfelseif len(consumer_id)>
									#get_cons_info(CONSUMER_ID,0,0)#
                                <cfelseif len(employee_id)>
									#get_emp_info(EMPLOYEE_ID,0,0)# 
								</cfif>
                            </td>
                            <td>
                            	<cfif tip eq 2>
                                	<cfif len(comp_id)>
                                        #get_par_info(COMP_ID,1,1,0)#
                                    <cfelseif len(cons_id)>
                                        #get_cons_info(CONS_ID,0,0)#
                                    </cfif>
                                </cfif>
                            </td>
                            <td>#SHIP_METHOD#</td>
                            <td align="center" colspan="5">
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.detail_order&order_id=#order_id#','wide');" class="tableyazi" title="Satış Siparişine Git">
                                    #ORDER_NUMBER#
                              	</a>
                            </td>
                            <td style="text-align:center">#CITY_NAME#<br />#COUNTY_NAME#</td>
                            <td colspan="4"><font color="red">
                            	<strong>Hata #tip# : </strong>
                            	<cfif tip eq 1>
                                	Birleştirme İşleminden Sonra Teslim Yeri veya Sevk Yöntemi Değiştirilen Sipariş Hatası</font>
                          		<cfelseif tip eq 2>
                            		Sevk Planlama İşleminden Sonra Cari Hesap Değiştirilen Sipariş Hatası
                            	</cfif>
                            </td>
                    </cfoutput>
                <cfelse>
					<cfoutput query="GET_SHIPPING" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif IS_TYPE eq 1>	
                            <cfquery name="GET_PUAN" datasource="#DSN3#"> <!---Satış Puanları Toplanıyor--->
                                SELECT
                                    ORR.STOCK_ID, 
                                    ORR.PRODUCT_ID, 
                                    ORR.QUANTITY,
                                    ORR.ORDER_ID FIS_ID,
                                    ORR.ORDER_ROW_ID FIS_ROW_ID,
                                    ISNULL(PIP.PROPERTY1, 0) AS PUAN
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
                                    PRODUCT_INFO_PLUS AS PIP ON ORR.PRODUCT_ID = PIP.PRODUCT_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
                            </cfquery>
                        <cfelse>
                            <cfquery name="GET_PUAN" datasource="#DSN2#">
                                SELECT     
                                    ISNULL(PIP.PROPERTY1, 0) AS PUAN, 
                                    SIR.AMOUNT AS QUANTITY, 
                                    SIR.PRODUCT_ID, 
                                    SIR.STOCK_ID, 
                                    SI.DISPATCH_SHIP_ID, 
                                    SIR.SHIP_ROW_ID, 
                                    ORR.ORDER_ID AS FIS_ID, 
                                    ORR.ORDER_ROW_ID AS FIS_ROW_ID
                                FROM
                                    SHIP_INTERNAL AS SI INNER JOIN
                                    SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                                    #dsn3_alias#.ORDER_ROW AS ORR ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID LEFT OUTER JOIN
                                    #dsn3_alias#.PRODUCT_INFO_PLUS AS PIP ON SIR.PRODUCT_ID = PIP.PRODUCT_ID
                                WHERE     
                                    SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                            </cfquery>
                            <cfquery name="get_order_id" datasource="#dsn3#">
                                SELECT TOP (1) ORDER_ID, IS_INSTALMENT FROM ORDERS WHERE ORDER_NUMBER = N'#SHIP_FIS_NO#'
                            </cfquery>
                        </cfif>
                        <cfset row_point = 0>
                        <cfquery name="get_order_id_list" dbtype="query">
                            SELECT
                                FIS_ID
                            FROM

                                GET_PUAN
                            GROUP BY
                                FIS_ID
                        </cfquery>
                        <cfset order_id_list = Valuelist(get_order_id_list.FIS_ID)>
                        <cfset order_row_id_list = Valuelist(GET_PUAN.FIS_ROW_ID)>
                        <cfloop query="GET_PUAN">
                            <cfif len(GET_PUAN.puan) and isnumeric(GET_PUAN.puan)>
                                <cfset row_point = row_point + GET_PUAN.puan*GET_PUAN.QUANTITY>
                                <cfset t_point =t_point+GET_PUAN.puan*GET_PUAN.QUANTITY>
                            </cfif>
                        </cfloop>
                        <cfif listlen(order_row_id_list)>
                            <!---<cfquery name="get_sevk_durum" datasource="#dsn3#"><!--- Rezerve edilen üretim planları veya satınalma siparişlerinin depoya girişleri kontrol ediliyor--->
                                SELECT     
                                    SUM(SEVK_DURUM) AS SEVK_DURUM
                                FROM         
                                    (
                                    SELECT     
                                        SEVK_DURUM
                                    FROM          
                                        (
                                        SELECT     
                                            CASE 
                                                WHEN ORDER_ROW_CURRENCY = - 6 THEN 4 
                                                WHEN ORDER_ROW_CURRENCY = - 9 THEN 1 
                                                WHEN ORDER_ROW_CURRENCY = - 8 THEN 1 
                                                WHEN ORDER_ROW_CURRENCY = - 3 THEN 1 
                                                WHEN ORDER_ROW_CURRENCY = - 10 THEN 1 
                                                ELSE 2 
                                            END AS SEVK_DURUM
                                        FROM          
                                            ORDER_ROW
                                        WHERE      
                                            ORDER_ROW_ID IN (#order_row_id_list#) 
                                        ) AS TBL1
                                    GROUP BY 
                                        SEVK_DURUM
                                    ) AS TBL2
                            </cfquery>--->
                            <cfset last_year = session.ep.period_year -1>
                            <cfquery name="get_invoice_durum" datasource="#dsn3#">
                            	SELECT        
                                	SUM(ORR.QUANTITY) - SUM(TBLB.AMOUNT) AS KALAN
								FROM            
                                	ORDER_ROW AS ORR LEFT OUTER JOIN
                             		(
                                    	SELECT        
                                        	WRK_ROW_RELATION_ID, 
                                            SUM(AMOUNT) AS AMOUNT
                               			FROM            
                                        	(
                                            	SELECT        
                                            		AMOUNT, 
                                                    WRK_ROW_RELATION_ID
                                           		FROM            
                                                	#dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW
                                            	UNION ALL
                                             	SELECT        
                                                	IR.AMOUNT, 
                                                    IR.WRK_ROW_RELATION_ID
                                             	FROM            
                                                	#dsn#_#session.ep.period_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                                                 	#dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID
                                              	<cfif get_period_id.recordcount>
                                                	UNION ALL
                                                    SELECT        
                                                        AMOUNT, 
                                                        WRK_ROW_RELATION_ID
                                                    FROM            
                                                        #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW
                                                    UNION ALL
                                                    SELECT        
                                                        IR.AMOUNT, 
                                                        IR.WRK_ROW_RELATION_ID
                                                    FROM            
                                                        #dsn#_#last_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                                                        #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS
                                                </cfif>
                                          	) AS TBLA
                               			GROUP BY 
                                         	WRK_ROW_RELATION_ID
                               		) AS TBLB ON ORR.WRK_ROW_ID = TBLB.WRK_ROW_RELATION_ID  COLLATE SQL_Latin1_General_CP1_CI_AS
								WHERE        
                                	ORR.ORDER_ROW_ID IN (#order_row_id_list#)
                            </cfquery>
                       	<cfelse>
                        	<cfset get_invoice_durum.recordcount =0>
                       		<!---<cfset get_sevk_durum.sevk_durum = 4>--->
                     	</cfif>
                            <tr>
                                <td>#currentrow#</td>
                                <td style="text-align:center">
                                    <cfif IS_TYPE eq 1>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','page');" class="tableyazi" title="Sevk Fişine Git">
                                        #DELIVER_PAPER_NO#
                                        </a>
                                    <cfelse>
                                        <strong>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.upd_dispatch_internaldemand&ship_id=#DELIVER_PAPER_NO#','wide');" class="tableyazi" title="Sevk Talebine Git">
                                                #DELIVER_PAPER_NO#
                                            </a>
                                        </strong>
                                        <br>
                                        <cfset fuse_type = 'sales'>
                                        <cfif get_order_id.is_instalment eq 1>
                                            <cfset page_type = 'upd_fast_sale'>
                                        <cfelse>
                                            <cfset page_type = 'detail_order'>
                                        </cfif>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#get_order_id.order_id#','wide');" class="tableyazi" title="Satış Siparişine Git">
                                        #SHIP_FIS_NO#
                                        </a>
                                    </cfif>        
                                </td>
                                <td style="text-align:center">#DateFormat(OUT_DATE,'dd/mm/yyyy')#</td>
                                <td>
                                    <cfif IS_TYPE eq 1>
                                        #UNVAN#
                                    <cfelse>
                                        <strong>        
                                        #DEPARTMENT_HEAD#<br>
                                        </strong>
                                        (#UNVAN#)
                                    </cfif>
                                </td>
                                <td>#get_emp_info(order_employee_id,0,0)#</td>
                                <td>#SHIP_METHOD#</td>
                                <td style="text-align:center"> <!---Sevk Indicator--->
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.popup_upd_prtotm_shipping_sevk&iid=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Sevk Emri Ver">
                                        <cfif  sevk_durum eq 2>
                                            <img src="../../../images/yellow_glob.gif" border="0" title="Tamamı Açık" />
                                        <cfelseif  sevk_durum eq 1>
                                            <img src="../../../images/red_glob.gif" border="0" title="Tamamı Kapatıldı" />
                                        <cfelseif  sevk_durum eq 6>
                                            <img src="../../../images/green_glob.gif" border="0"title="Kısmi Sevk" />
                                        <cfelseif  sevk_durum eq 4>
                                            <img src="../../../images/blue_glob.gif" border="0"title="Ürünlerin Tamamı Hazır" />
                                        <cfelseif  sevk_durum eq 5>
                                            <img src="../../../images/black_glob.gif" border="0"title="Düzeltimesi Gereken Sevk Talebi" />
                                        </cfif>
                                    </a>
                                </td>
                                <cfif IS_TYPE eq 1>    
                                    <cfquery name="AMBAR_CONTROL" datasource="#DSN3#">
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                        FROM         
                                            (
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                SELECT 
                                                	SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                                               	FROM
                                                	( 
                                                    SELECT        
                                                        SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                    FROM            
                                                        #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                        #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                    WHERE        
                                                        SF.FIS_TYPE = 113 AND 
                                                        SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                        SFR.STOCK_ID = TBL.PAKET_ID
                                                    <cfif get_period_id.recordcount>
                                                        UNION ALL
                                                        SELECT        
                                                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                        FROM            
                                                            #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                            #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                        WHERE        
                                                            SF.FIS_TYPE = 113 AND 
                                                            SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                            SFR.STOCK_ID = TBL.PAKET_ID
                                                    </cfif>
                                                	) AS TBL_5
                                                ) AS CONTROL_AMOUNT
                                            FROM         
                                                (
                                                SELECT
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM
                                                    (     
                                                    SELECT     
                                                        CASE 
                                                            WHEN 
                                                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                            THEN 
                                                                S.PRODUCT_TREE_AMOUNT 
                                                            ELSE 
                                                                SUM(ORR.QUANTITY * EPS.PAKET_SAYISI)
                                                        END 
                                                            AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    FROM          
                                                        PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                                        PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                                                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                                                        STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                                                    WHERE      
                                                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    ) AS TBL1
                                                GROUP BY
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="AMBAR_CONTROL" datasource="#DSN3#">
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                                        FROM         
                                            (		
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                  SELECT 
                                                	SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                                               	FROM
                                                	( 
                                                    SELECT        
                                                        SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                    FROM            
                                                        #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                        #dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                    WHERE        
                                                        SF.FIS_TYPE = 113 AND 
                                                        SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                        SFR.STOCK_ID = TBL.PAKET_ID
                                                    <cfif get_period_id.recordcount>
                                                        UNION ALL
                                                        SELECT        
                                                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                        FROM            
                                                            #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                                                            #dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                        WHERE        
                                                            SF.FIS_TYPE = 113 AND 
                                                            SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                            SFR.STOCK_ID = TBL.PAKET_ID
                                                    </cfif>
                                                	) AS TBL_5
                                                ) AS CONTROL_AMOUNT, SHIP_RESULT_ID
                                            FROM         
                                                (
                                                SELECT     
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM          
                                                    (
                                                    SELECT     
                                                        CASE 
                                                            WHEN 
                                                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                            THEN 
                                                                S.PRODUCT_TREE_AMOUNT 
                                                            ELSE 
                                                                SUM(SIR.AMOUNT * EPS.PAKET_SAYISI)
                                                        END 
                                                            AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                                                    FROM          
                                                        STOCKS AS S INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                                                    WHERE      
                                                        SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID
                                                    ) AS TBL1
                                                GROUP BY 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery> 
								</cfif>
                                <td style="text-align:center"> <!---Hazırlama Indicator--->
                                	<cfif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.PAKET_SAYISI eq 0 and AMBAR_CONTROL.CONTROL_AMOUNT eq 0>
                                    	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/plus_ques.gif" border="0" title="Barkod Yok.">
                                        </a>
                                     <cfelseif AMBAR_CONTROL.recordcount AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0>
                                     	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/red_glob.gif" border="0" title="Sevk Edildi.">
                                        </a>
                                     <cfelseif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.CONTROL_AMOUNT eq 0>
                                     	<cfif IS_SEVK_EMIR eq 1>
                                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/blue_glob.gif" border="0" title="Sevk Emri Verildi.">
                                            </a>
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/yellow_glob.gif" border="0" title="Sevk Edilmedi.">
                                            </a>
                                        </cfif>
                                     <cfelseif AMBAR_CONTROL.recordcount AND AMBAR_CONTROL.PAKET_SAYISI gt AMBAR_CONTROL.CONTROL_AMOUNT>
                                     	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/green_glob.gif" border="0" title="Eksik Sevkiyat.">
                                        </a>
                                     <cfelseif AMBAR_CONTROL.recordcount AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) lt ceiling(AMBAR_CONTROL.CONTROL_AMOUNT)>
                                     	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="Detay Göster"><img src="/images/black_glob.gif" border="0" title="Fazla Sevkiyat">  
                                        </a>
                                     </cfif>
                                </td>
                                <cfif IS_TYPE eq 1>    
                                    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#"> <!---Paket Kontrolü kontrol ediliyor--->
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT,
                                            ISNULL(SUM(CONTROL_AMOUNT2), 0) AS CONTROL_AMOUNT2
                                        FROM         
                                            (
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 1 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT,
                                               	(
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT2
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST_REPEAT
                                                WHERE      
                                                    TYPE = 1 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT2
                                            FROM         
                                                (
                                                SELECT
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM
                                                    (     
                                                    SELECT     
                                                        CASE 
                                                            WHEN 
                                                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                            THEN 
                                                                S.PRODUCT_TREE_AMOUNT 
                                                            ELSE 
                                                                SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) 
                                                        END 
                                                            AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    FROM          
                                                        PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                                        PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                                                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                                                        STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                                                    WHERE      
                                                        ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        ESR.SHIP_RESULT_ID,
                                                        ESRR.ORDER_ROW_ID
                                                    ) AS TBL1
                                                GROUP BY
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
    
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#">
                                        SELECT     
                                            ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                            ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT,
                                            ISNULL(SUM(CONTROL_AMOUNT2), 0) AS CONTROL_AMOUNT2
                                        FROM         
                                            (		
                                            SELECT     
                                                PAKET_SAYISI AS PAKETSAYISI, 
                                                PAKET_ID AS STOCK_ID, 
                                                BARCOD, 
                                                STOCK_CODE, 
                                                PRODUCT_NAME,
                                                (
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 2 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT, 
                                                (
                                                SELECT     
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT2
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST_REPEAT
                                                WHERE      
                                                    TYPE = 2 AND 
                                                    STOCK_ID = TBL.PAKET_ID AND 
                                                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                                                ) AS CONTROL_AMOUNT2,
                                                SHIP_RESULT_ID
                                            FROM         
                                                (
                                                SELECT     
                                                    SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                FROM          
                                                    (
                                                    SELECT     
                                                        CASE 
                                                            WHEN 
                                                                S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                                                            THEN 
                                                                S.PRODUCT_TREE_AMOUNT 
                                                            ELSE 
                                                                SUM(SIR.AMOUNT * EPS.PAKET_SAYISI)
                                                        END 
                                                            AS PAKET_SAYISI, 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                                                    FROM          
                                                        STOCKS AS S INNER JOIN
                                                        PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                                                        #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                                                    WHERE      
                                                        SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
                                                    GROUP BY 
                                                        EPS.PAKET_ID, 
                                                        S.BARCOD, 
                                                        S.STOCK_CODE, 
                                                        S.PRODUCT_NAME, 
                                                        S.PRODUCT_TREE_AMOUNT, 
                                                        SIR.SHIP_ROW_ID, 
                                                        SI.DISPATCH_SHIP_ID
                                                    ) AS TBL1
                                                GROUP BY 
                                                    PAKET_ID, 
                                                    BARCOD, 
                                                    STOCK_CODE, 
                                                    PRODUCT_NAME, 
                                                    PRODUCT_TREE_AMOUNT, 
                                                    SHIP_RESULT_ID
                                                ) AS TBL
                                            ) AS TBL2
                                    </cfquery>
                                </cfif> 
                                
                                <td style="text-align:center"> <!---El Terminali 1 Kontrol Indicator--->
                                    <cfif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI eq 0 and PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/plus_ques.gif" border="0" title="Barkod Yok." />
                                        </a>
                                    <cfelseif PACKEGE_CONTROL.recordcount AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/red_glob.gif" border="0" title="Kontrol Edildi.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/yellow_glob.gif" border="0" title="Kontrol Edilmedi.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) gt ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">	
                                            <img src="/images/green_glob.gif" border="0" title="Kontrol Eksik."> 
                                        </a>  
                                     </cfif>
                                </td>
                                
                                <!---<td style="text-align:center"> <!---El Terminali 2 Kontrol Indicator--->
                                    <cfif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI eq 0 and PACKEGE_CONTROL.CONTROL_AMOUNT2 eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control_repeat&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/plus_ques.gif" border="0" title="Barkod Yok." />
                                        </a>
                                    <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI - PACKEGE_CONTROL.CONTROL_AMOUNT2 eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control_repeat&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/red_glob.gif" border="0" title="Kontrol Edildi.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.CONTROL_AMOUNT2 eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control_repeat&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">
                                            <img src="/images/yellow_glob.gif" border="0" title="Kontrol Edilmedi.">
                                        </a>
                                     <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI gt PACKEGE_CONTROL.CONTROL_AMOUNT2>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_term_control_repeat&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="Detay Göster">	
                                            <img src="/images/green_glob.gif" border="0" title="Kontrol Eksik."> 
                                        </a>  
                                     </cfif>
                                </td>--->
                                
                                	    
                                <td style="text-align:center"> <!---İrsaliye Indicator--->
                                    <cfif IS_TYPE eq 1>
                                        <cfif DURUM eq 1>
                                        	<cfif ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_sale&order_id=#order_id_list#&order_row_id=#order_row_id_list#','longpage');" class="tableyazi" title="Satış İrsaliyesi Oluştur">
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="Tamamı Açık" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="Önce Ambar Fişi Oluşturun" />
                                            </cfif>
                                        <cfelseif DURUM eq 2>
                                            <img src="../../../images/red_glob.gif" border="0" title="Tamamı Sevkedildi" />
                                        <cfelseif DURUM eq 3>
                                        	<cfif ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.form_add_sale&order_id=#order_id_list#&order_row_id=#order_row_id_list#','longpage');" class="tableyazi" title="Satış İrsaliyesi Oluştur">
                                                    <img src="../../../images/green_glob.gif" border="0"title="Kısmi Kapandı" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/green_glob.gif" border="0"title="Kısmi Kapandı" />
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfif DURUM eq 1>
                                        	<cfif ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.add_ship_dispatch&dispatch_ship_id=#SHIP_RESULT_ID#','longpage');" class="tableyazi" title="Depolararası Sevk İrsaliyesi Oluştur">
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="Tamamı Açık" />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="Önce Ambar Fişi Oluşturun" />
                                            </cfif>
                                        <cfelseif DURUM eq 2>

                                            <img src="../../../images/red_glob.gif" border="0" title="Tamamı Sevkedildi" />
                                        </cfif>
                                    </cfif>
                                </td>
                                <td style="text-align:center">
                                	<cfif get_invoice_durum.recordcount and len(get_invoice_durum.kalan)>
                                    	<cfif get_invoice_durum.kalan lt 0>
                                    		<img src="../../../images/green_glob.gif" border="0" title="Kısmi Faturalandı " />
                                       	<cfelse>
                                        	<img src="../../../images/red_glob.gif" border="0" title="Tam Faturalandı " />
                                        </cfif>
                                    <cfelse>
                                    	<cfif DURUM eq 1>
                                        	<cfif ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.form_add_bill&order_id=#order_id#&order_row_id=#order_row_id_list#','longpage');" class="tableyazi" title="Toptan Satış Faturası Oluştur">
                                                    <img src="../../../images/yellow_glob.gif" border="0" title="Tamamı Faturalanacak " />
                                                </a>
                                            <cfelse>
                                            	<img src="../../../images/yellow_glob.gif" border="0" title="Önce Ambar Fişi Oluşturun" />
                                            </cfif>
                                       	<cfelse>
                                        	<img src="../../../images/yellow_glob.gif" border="0" title="Fatura Emirlerden Kesilebilir " />
                                        </cfif>
                                    </cfif>
                                </td> <!---Fatura Indicator--->
								<td>#get_emp_info(sevk_emp,0,0)# </td>
                                <td style="text-align:right"><cfif isnumeric(GET_PUAN.puan)><cfif GET_PUAN.puan eq 0><font color="red">#Tlformat(row_point,2)#</font><cfelse>#Tlformat(row_point,2)#</cfif><cfelse><font color="red">-</font></cfif></td>
                                <td style="text-align:center">#SEHIR#<br />#ILCE#</td>
                                <td title="#NOTE#">#left(NOTE,70)#<cfif len(NOTE) gt 70>...</cfif></td>
                                
                                <td style="text-align:center;<cfif DURUM neq 1>background-color:red</cfif>"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=32&action_id=#is_type#-#SHIP_RESULT_ID#','page');"><img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>">
                                </td>
                                <td style="text-align:right">
                                	<cfset birlesme_izni = 0>
                                    <cfif IS_TYPE eq 1>
                                        <cfif ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 and ceiling(PACKEGE_CONTROL.recordcount) AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0 and DURUM eq 1  and get_invoice_durum.kalan lt 0>
                                            <cfquery name="get_shipping_group" dbtype="query">
                                                SELECT
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID,
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID,
                                                    </cfif>
                                                    SEHIR,
                                                    ILCE,
                                                    SHIP_METHOD_TYPE,
                                                    ORDER_ID,
                                                    COUNT(*) AS SAYI
                                                FROM
                                                    GET_SHIPPING
                                                WHERE
                                                    IS_TYPE = 1 AND
                                                    ORDER_ID = #ORDER_ID# AND
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID = #COMPANY_ID#
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID = #CONSUMER_ID#
                                                    </cfif>
                                                GROUP BY
                                                    <cfif len(COMPANY_ID)>
                                                        COMPANY_ID,
                                                    <cfelseif len(CONSUMER_ID)>
                                                        CONSUMER_ID,
                                                    </cfif>
                                                    SEHIR,
                                                    ILCE,
                                                    SHIP_METHOD_TYPE,
                                                    ORDER_ID
                                            </cfquery>
                                            
                                            <cfif get_shipping_group.SAYI gt 1>
                                                <!---<img src="/images/starton.gif" border="0" title="Birleşebilir" />--->
                                                <cfset birlesme_izni = 1>
                                            <cfelse>       
                                                <!---<img src="/images/stop.gif" border="0" title="Birleşemez" />--->
                                            </cfif>
                                        <cfelse>      
                                            <!---<img src="/images/stop.gif" border="0" title="Birleşemez" />--->   
                                        </cfif>
                                    <cfelse>
                                        <!---<img src="/images/stop.gif" border="0" title="Birleşemez" /> --->      
                                    </cfif>
                                    <cfif DURUM eq 1>
                                        <input type="checkbox" name="select_production" value="#IS_TYPE#-#SHIP_RESULT_ID#-#birlesme_izni#">
                                    </cfif>
                                    <cfif birlesme_izni eq 1>
                                        <img src="/images/starton.gif" border="0" title="Birleşebilir" />
                                    <cfelse>
                                    	<img src="/images/stop.gif" border="0" title="Birleşemez" />
                                    </cfif>
                                </td>
                            </tr>
                            <cfset son_row = currentrow>
                    </cfoutput>
              	</cfif>      
            <cfelse>
			<tr>
				<td colspan="17"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayit Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
			</tr>
            </cfif>	
		</tbody>
        <cfif isdefined("attributes.form_varmi")>
            <tfoot>
            	<form name="button_form" method="post" action="">
                <tr>
                	<cfif isdefined('tip')>
                    	<td colspan="17">
                        	<font color="red">
                            	Önce Hataları Düzeltmelisiniz!!!
                            </font>
                      	</td>      
                  	<cfelse>
						<cfif attributes.totalrecords gt son_row>
                            <cfoutput>
                                <td style="text-align:left;" colspan="12">Sayfa Toplam</td>
                                <td style="text-align:right;" >#Tlformat(t_point,2)#</td>
                                <td style="text-align:right;" colspan="4">
                               		<input type="text" name="send_date" id="send_date" value="#dateformat(DateAdd('d',1,now()),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                    <cf_wrk_date_image date_field="send_date">
                                    <input type="button" name="gonder" value="Gönder" onClick="grupla(-4);">
                                	<input type="button" name="birles" value="Birleştir" onClick="grupla(-3);">
                                    <input type="button" value="Toplu Yazdır" onClick="grupla(-2);">
                                </td>
                            </cfoutput>
                        <cfelse>
                            <cfoutput>
                                <td style="text-align:left;" colspan="12">Genel Toplam</td>
                                <td style="text-align:right;" >#Tlformat(t_point,2)#</td>
                                <td style="text-align:right;" colspan="4">
                                	<input type="text" name="send_date" id="send_date" value="#dateformat(DateAdd('d',1,now()),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                    <cf_wrk_date_image date_field="send_date">
                                    <input type="button" name="gonder" value="Gönder" onClick="grupla(-4);">
                                    <input type="button" name="birles" value="Birleştir" onClick="grupla(-3);">
                                    <input type="button" value="Toplu Yazdır" onClick="grupla(-2);">
                                </td>
                            </cfoutput>
                         </cfif>     
                	</cfif>
                </tr>
                </form>
            </tfoot>
        </cfif>
	</table>
<cfset url_str = 'sales.list_PRTOTM_shipping'>
<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
	<cfset url_str = url_str & "&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset url_str = url_str & "&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.product_id") and len(attributes.product_id) and isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset url_str = url_str & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and isdefined("attributes.short_code_name") and len(attributes.short_code_name)>
	<cfset url_str = url_str & "&short_code_id=#attributes.short_code_id#&short_code_name=#attributes.short_code_name#">
</cfif>
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
	<cfset url_str = url_str & "&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
</cfif>

<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
	<cfset url_str = url_str & "&prod_cat=#attributes.prod_cat#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
	<cfset url_str = url_str & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)> 
	<cfset url_str = url_str & "&order_employee_id=#attributes.order_employee_id#&order_employee=#attributes.order_employee#">
</cfif>
<cfif isdefined("attributes.sales_member_id") and len(attributes.sales_member_id)>
	<cfset url_str = url_str & "&sales_member_id=#attributes.sales_member_id#&sales_member_name=#attributes.sales_member_name#">
</cfif>
<cfif isdefined("attributes.sales_departments") and len(attributes.sales_departments)>
	<cfset url_str = "#url_str#&sales_departments=#attributes.sales_departments#">
</cfif>
<cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>

	<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
</cfif>

<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
	<cfset url_str = "#url_str#&zone_id=#attributes.zone_id#">
</cfif>
<cfif isdefined("attributes.city_name") and len(attributes.city_name)>

	<cfset url_str = "#url_str#&city_name=#attributes.city_name#">
</cfif>
<cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>
	<cfset url_str = "#url_str#&ship_method_id=#attributes.ship_method_id#">
</cfif>

<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined('attributes.report_type_id')>
	<cfset url_str = url_str & "&report_type_id=#attributes.report_type_id#">
</cfif>
<cfif len(t_point)>

	<cfset url_str = url_str & "&t_point=#t_point#">
</cfif>
<cfset url_str = url_str & "&sort_type=#attributes.sort_type#">
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#attributes.fuseaction#&#url_str#&form_varmi=1">
<script language="javascript">
	function input_control()
		{
			if(document.all.branch_id.value !='' && document.all.listing_type.value ==2)
			{
				alert('Liste Tipi Sevk Planları İle Şubeyi Birlikte Seçemezsiniz!!!.');
				return false
			}
			else
			{
				return true
			}
		}
	function grupla(type)
		{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
			shipping_id_list = '';
			chck_leng = document.getElementsByName('select_production').length;
			for(ci=0;ci<chck_leng;ci++)
			{
				var my_objets = document.all.select_production[ci];
				if(chck_leng == 1)
					var my_objets =document.all.select_production;
				if(type == -1)
				{//hepsini seç denilmişse	
					if(my_objets.checked == true)
						my_objets.checked = false;
					else
						my_objets.checked = true;
				}
				else
				{
					if(my_objets.checked == true)
						shipping_id_list +=my_objets.value+',';
				}
			}
			shipping_id_list = shipping_id_list.substr(0,shipping_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(shipping_id_list!='')
			{
				if(type == -3)
				{
					var soru = confirm('Birleştirilen Sevk Planını Tekrar Geri Alamazsınız. Emin misiniz?.');
					if(soru==true)
					{
						window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=eshipping.emptypopup_qupd_prtotm_shipping_row&shipping_id_list='+shipping_id_list);
					}
				}
				else if(type == -4)
				{
					var soru = confirm('Sevkiyatları ilgili Tarihe Gönderiyorum. Emin misiniz?.');
					if(soru==true)
					{
						send_date = document.getElementById('send_date').value;
						if(send_date.length>0)
						window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_upd_PRTOTM_shipping_date&shipping_id_list='+shipping_id_list+'&send_date='+send_date);
						else
						{
							alert('Gönderilecek Tarih Boş Olamaz !');
							return false;
						}
					}
				}
				else if(type == -2)
				{
					window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=32&action_id='+shipping_id_list);		
				}
			}
		}
</script>