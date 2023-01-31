
<cfquery name="get_default_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID, LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.POSITION_CODE# AND OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfif get_default_department.recordcount>
	<cfparam name="attributes.sales_departments" default="#get_default_department.DEPARTMENT_ID#-#get_default_department.LOCATION_ID#">
<cfelse>
	<cfparam name="attributes.sales_departments" default="">
</cfif>
<cfquery name="get_shipping_default" datasource="#dsn3#">
	SELECT ISNULL(SHIPPING_CONTROL_TYPE,0) SHIPPING_CONTROL_TYPE FROM PRTOTM_SHIPPING_DEFAULTS
</cfquery>
<cfif get_shipping_default.recordcount>
	<cfparam name="attributes.e_shipping_type" default="#get_shipping_default.SHIPPING_CONTROL_TYPE#"> 
<cfelse>
	<cfparam name="attributes.e_shipping_type" default="0"> 
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
     	alert("<cf_get_lang_main no='3516.Bu Şirket İçin Tanımlanmış Depo ve Lokasyon Bulunamamıştır!'>");
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
        		ESR.DELIVER_PAPER_NO
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
                O.REF_NO, 
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
        		ESR.DELIVER_PAPER_NO
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
                            ESR.SHIP_RESULT_ID, 
                            ESR.NOTE, 
                            ESR.SEVK_EMIR_DATE,
                            ISNULL(ESR.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR,
                            ISNULL(ESR.SEVK_EMP,0) SEVK_EMP,
                            ESR.SHIP_FIS_NO, 
                            ESR.DELIVER_PAPER_NO, 
                            ESR.DELIVER_EMP,
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
                            ISNULL((
                                SELECT DISTINCT 
                                    SC.CITY_NAME
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID INNER JOIN
                                    #dsn_alias#.SETUP_CITY AS SC ON O.CITY_ID = SC.CITY_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ),'') AS SEHIR,
                            ISNULL((
                                SELECT DISTINCT 
                                    SCO.COUNTY_NAME
                                FROM         
                                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID INNER JOIN
                                    #dsn_alias#.SETUP_COUNTY AS SCO ON O.COUNTY_ID = SCO.COUNTY_ID
                                WHERE     
                                    ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                            ),'') AS ILCE,
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
                            	SELECT   DISTINCT     
                                	ISNULL(ORDERS.IS_INSTALMENT, 0) AS IS_INSTALMENT
								FROM         
                                	PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                         			ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                       				ORDERS ON ORR.ORDER_ID = ORDERS.ORDER_ID
								WHERE        
                                	ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID 
                            ) AS IS_INSTALMENT,
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
                            <cfif isdefined('attributes.SALES_DEPARTMENTS') and Listlen(attributes.SALES_DEPARTMENTS,'-') eq 2>
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
                        SI.DISPATCH_SHIP_ID SHIP_RESULT_ID,
                        (
                        SELECT     
                            ORDER_DETAIL
                        FROM          
                            ORDERS
                        WHERE      
                            ORDER_ID = O.ORDER_ID
                        ) AS NOTE,
                        SI.SEVK_EMIR_DATE,
                       	ISNULL(SI.IS_SEVK_EMIR,0) AS IS_SEVK_EMIR,
                        ISNULL(SI.SEVK_EMP,0) as SEVK_EMP,
                        O.ORDER_NUMBER AS SHIP_FIS_NO,
                        CAST(SI.DISPATCH_SHIP_ID AS VARCHAR(50)) AS DELIVER_PAPER_NO,
                        SI.DELIVER_EMP,
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
                        ISNULL(SC.CITY_NAME,0) AS SEHIR,
                        ISNULL(SCO.COUNTY_NAME,'') ILCE,
                        ISNULL(SUM(SIR.AMOUNT),'') AS AMOUNT,
                        O.IS_INSTALMENT,
                        CASE
                            WHEN S.SHIP_ID IS NOT NULL THEN 2
                            WHEN S.SHIP_ID IS NULL THEN 1
                            END
                        AS DURUM,
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
                        1=1
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
                        SI.DISPATCH_SHIP_ID,
                        O.ORDER_NUMBER, 
                        O.IS_INSTALMENT,
                        SI.SEVK_EMIR_DATE,
                       	SI.IS_SEVK_EMIR,
                        SI.SEVK_EMP,
                        SI.DELIVER_DATE, 
                        SI.DELIVER_EMP,
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
                <cfif isdefined('attributes.city_name') and len(attributes.city_name)>
                    AND SEHIR ='#attributes.city_name#' 
                </cfif>
                <cfif isdefined('attributes.SHIP_METHOD_ID') and len(attributes.SHIP_METHOD_ID)>
                    AND SHIP_METHOD_TYPE ='#attributes.SHIP_METHOD_ID#' 
                </cfif>
                <cfif isdefined('attributes.member_name') and len(attributes.member_name)>
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                        AND COMPANY_ID =#attributes.company_id#
                    </cfif>
                    <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                        AND CONSUMER_ID =#attributes.consumer_id# 
                    </cfif>
                </cfif>
                <cfif len(attributes.keyword)>
                    AND 
                    	(
                        REFERENCE_NO LIKE '%#attributes.keyword#%' OR
                        DELIVER_PAPER_NO LIKE '%#attributes.keyword#%'
                        )
                </cfif>
                <cfif len(attributes.order_employee_id) and len(attributes.order_employee)>
                	AND DELIVER_EMP = #attributes.order_employee_id#
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
            SHIP_RESULT_ID
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