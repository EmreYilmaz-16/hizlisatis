<cfsetting showdebugoutput="yes">
<cfif session.ep.company_id eq 1>
 	<cfset PRTOTM_department_id = 8> <!---Firmaya Göre Değişir---> <!---Bursa Depo--->
<cfelseif session.ep.company_id eq 2>
	<cfset PRTOTM_department_id = 5> <!---Firmaya Göre Değişir---> <!---İkitelli Depo--->
</cfif>
<cf_get_lang_set module_name="sales">
<cfquery name="get_emp" datasource="#dsn#">
	SELECT        
    	EMPLOYEE_ID, EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ADI
	FROM            
    	EMPLOYEE_POSITIONS
	WHERE        
        DEPARTMENT_ID = #PRTOTM_department_id# AND
        POSITION_STATUS = 1
</cfquery>
<cfquery name="get_default_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID, LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.POSITION_CODE# AND OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfif get_default_department.recordcount>
	<cfparam name="attributes.sales_departments" default="#get_default_department.DEPARTMENT_ID#-#get_default_department.LOCATION_ID#">
<cfelse>
	<cfparam name="attributes.sales_departments" default="">
    <script type="text/javascript">
     	alert("Kullanıcı İçin Default Depo Tanımlayınız!");
     	history.go(-1);
  	</script>
 	<cfabort>
</cfif>
<cfquery name="get_period_id" datasource="#dsn#">
    	SELECT        
        	PERIOD_YEAR
		FROM            
        	SETUP_PERIOD
		WHERE        
        	OUR_COMPANY_ID = #session.ep.company_id# AND 
            PERIOD_YEAR < #session.ep.period_year#
</cfquery>
<cfset last_year = session.ep.period_year -1>
<cfset lnk_str = ''><cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = DateAdd('d',-20,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfquery name="GET_SHIPPING" datasource="#dsn3#"><!---Sevk Planları ve Sevk Talepleri Listeleniyor--->
            SELECT 
				TOP (40)
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
                            ) AS DURUM
                        FROM       	
                            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                            #dsn_alias#.SHIP_METHOD AS SM ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID INNER JOIN
                            #dsn_alias#.EMPLOYEES AS E ON ESR.DELIVER_EMP = E.EMPLOYEE_ID INNER JOIN
                            #dsn_alias#.DEPARTMENT AS D ON ESR.DEPARTMENT_ID = D.DEPARTMENT_ID
                        WHERE 
                            IS_TYPE = 1
                            AND ISNULL(ESR.IS_SEVK_EMIR,0) = 1
                           	AND ESR.DEPARTMENT_ID = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                        	AND ESR.LOCATION_ID = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                            <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                                AND ESR.OUT_DATE >= #attributes.start_date#
                            </cfif>
                            <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                                AND ESR.OUT_DATE <= #attributes.finish_date#
                            </cfif>
                            <cfif isdefined('attributes.svk_number')>
                                AND 
                                    (
                                        ESR.DELIVER_PAPER_NO LIKE '%#attributes.svk_number#%'
                                    )
                            </cfif>
                            UNION ALL
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
                       	END AS DURUM
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
                        AND ISNULL(SI.IS_SEVK_EMIR,0)=1
                        AND SI.DEPARTMENT_OUT = #listgetat(attributes.SALES_DEPARTMENTS,1,'-')# 
                      	AND SI.LOCATION_OUT = #listgetat(attributes.SALES_DEPARTMENTS,2,'-')#
                        <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                            AND SI.DELIVER_DATE >= #attributes.start_date#
                        </cfif>
                        <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                            AND SI.DELIVER_DATE <= #attributes.finish_date#
                        </cfif>
                        <cfif isdefined('attributes.svk_number')>
                            AND 
                                (
                                   SI.DISPATCH_SHIP_ID LIKE '%#attributes.svk_number#%'
                                )
                        </cfif>
                    GROUP BY 
                    	O.ORDER_EMPLOYEE_ID,
                        SI.SEVK_EMIR_DATE,
                       	SI.IS_SEVK_EMIR,
                        SI.SEVK_EMP,
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
                        SC.CITY_NAME,
                        SCO.COUNTY_NAME,
                        O.ORDER_ID,
                        S.SHIP_ID
                ) AS TBL
            WHERE
                AMOUNT > 0 AND
                DURUM = 1
      		ORDER BY
            	SEVK_EMP,
                SEVK_EMIR_DATE	
</cfquery>
<cfif GET_SHIPPING.recordcount>
	<cfset type_1_list = ''>
    <cfset type_2_list = ''>
	<cfoutput query="GET_SHIPPING">
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
                                                    SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                                                FROM            
                                                    #dsn2_alias#.STOCK_FIS AS SF INNER JOIN
                                                    #dsn2_alias#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                                                WHERE        
                                                    SF.FIS_TYPE = 113 AND 
                                                    SF.REF_NO = '#DELIVER_PAPER_NO#' AND 
                                                    SFR.STOCK_ID = TBL.PAKET_ID
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
    	<cfif (AMBAR_CONTROL.PAKET_SAYISI eq AMBAR_CONTROL.CONTROL_AMOUNT) or GET_SHIPPING.DURUM eq 2>
        	<cfif IS_TYPE eq 1>
            	<cfset type_1_list = ListAppend(type_1_list,GET_SHIPPING.SHIP_RESULT_ID,',')>
            <cfelse>
            	<cfset type_2_list = ListAppend(type_2_list,GET_SHIPPING.SHIP_RESULT_ID,',')>
            </cfif>
        </cfif>
    </cfoutput>
     <cfif ListLen(type_1_list) or ListLen(type_1_list)>
        <cfquery name="get_shipping_clear" dbtype="query">
            <cfif ListLen(type_1_list)>
            SELECT
                *
            FROM
                GET_SHIPPING
            WHERE
                IS_TYPE = 1 AND
                SHIP_RESULT_ID NOT IN (#type_1_list#) AND
                IS_SEVK_EMIR = 1
                <cfif ListLen(type_2_list)>
                    UNION ALL
                </cfif>
            </cfif>
            <cfif ListLen(type_2_list)>
                SELECT
                    *
                FROM
                    GET_SHIPPING
                WHERE
                    IS_TYPE = 2 AND
                    SHIP_RESULT_ID NOT IN (#type_2_list#) AND
                    IS_SEVK_EMIR = 1
            </cfif>
            ORDER BY
                SEVK_EMP,
                SEVK_EMIR_DATE
        </cfquery>
  	<cfelse>
    	<cfquery name="get_shipping_clear" dbtype="query">
        	SELECT
                *
            FROM
                GET_SHIPPING
            
          	 ORDER BY
                SEVK_EMP,
                SEVK_EMIR_DATE
        </cfquery>
    </cfif>
    <cfquery name="get_svk_number" dbtype="query">
    	SELECT * FROM get_shipping_clear WHERE IS_SEVK_EMIR = 1 ORDER BY DELIVER_PAPER_NO
    </cfquery>
    <cfquery name="ikaz_query" dbtype="query">
    	SELECT
        	SEVK_EMP
      	FROM
        	get_shipping_clear
       	WHERE
        	SEVK_EMP = 0
    </cfquery>
<cfelse>
	<cfset get_shipping_clear.recordcount = 0>
    <cfset ikaz_query.recordcount = 0>
</cfif>
<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">

</cfform>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  		<tr class="color-border">
        	<td>
            	<table cellspacing="1" cellpadding="2" width="100%" border="0">
                    <tr class="color-header" style="height:35px">
                        <td class="form-title" style="width:30px;text-align:center"><cf_get_lang_main no='1165.Sira'></td>
                        <td class="form-title" style="width:95px;text-align:center"> Sevk No
                        </td>
                        <td class="form-title" style="width:60px;text-align:center"><cf_get_lang_main no='330.tarih'></td>
                        <td class="form-title" style="text-align:center"><cf_get_lang_main no='162.sirket'></td>
                        <td class="form-title" style="width:100px;text-align:center"><cf_get_lang_main no='487.Kaydeden'></td>
                        <td class="form-title" style="width:100px;text-align:center">Sevk Yöntemi</td>
                        <td class="form-title" style="width:170px;text-align:center">Şehir</td> 
                        <td class="form-title" style="width:280px;text-align:center">Açıklama</td>
                        <td class="form-title" style="width:150px;text-align:center">Hazırlayan</td>
                        <!-- sil -->
                        <td class="form-title" style="width:20px" nowrap="nowrap"></td>
                        <!-- sil -->
                	</tr>
        			<cfif get_shipping_clear.recordcount>
                    	<cfset attributes.totalrecords = get_shipping_clear.recordcount>
                        <cfoutput query="get_shipping_clear">
                                <tr style="height:30px" <cfif get_shipping_clear.SEVK_EMP gt 0>class="color-row"<cfelse>class="color-light"</cfif>>
                                    <td style="text-align:right">#currentrow#</td>
                                    <td style="text-align:center">#DELIVER_PAPER_NO#</td>
                                    <td style="text-align:center">#DateFormat(OUT_DATE,'dd/mm/yyyy')#</td>
                                    <td><cfif IS_TYPE eq 1>#UNVAN#<cfelse><strong>#DEPARTMENT_HEAD#</strong>-(#UNVAN#)</cfif></td>
                                    <td>#get_emp_info(order_employee_id,0,0)#</td>
                                    <td>#SHIP_METHOD#</td>
                                    <td style="text-align:left">#SEHIR#-#ILCE#</td>
                                    <td title="#NOTE#">#left(NOTE,70)#<cfif len(NOTE) gt 70>...</cfif></td>
                                    <td>
                                        <select name="sevk_emp_id_#SHIP_RESULT_ID#" id="sevk_emp_id_#SHIP_RESULT_ID#" style="width:150px" onChange="degisim(#is_type#,#SHIP_RESULT_ID#);">
                                            <option value="0" <cfif get_shipping_clear.SEVK_EMP eq 0>selected</cfif>>Seçiniz</option>
                                            <cfloop query="get_emp">
                                                <option value="#employee_id#" <cfif get_shipping_clear.SEVK_EMP eq employee_id>selected</cfif>>#adi#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                    <td style="text-align:center;<cfif DURUM neq 1>background-color:red</cfif>">
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=32&action_id=#is_type#-#SHIP_RESULT_ID#','page');">
                                            <img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" title="<cf_get_lang_main no='62.Yazdır'>">
                                        </a>
                                    </td>
                                </tr>
                        </cfoutput>
                        <tr>
                        	<form name="button_form" method="post" action="">
                            <td colspan="10">
                            	Filtre
                                <input type="text" name="svk_number" id="svk_number" class="box" style=" width:250px">
                            	<input type="button" name="goster" value="Getir" onClick="goster();">
                            
                            </td>
                            </form>
                        </tr>
                    <cfelse>
                    
                    <tr>
                        <td colspan="10"><cf_get_lang_main no='72.Kayit Yok'>!</td>
                    </tr>
                    </cfif>
       	      	</table>
          	</td>
      	</tr>
        <tr>
         	<td style="display:none">
            	<cfif ikaz_query.recordcount>
               		<audio autoplay="autoplay" controls="none">
                     	<source src="/images/production/dingdong.mp3" type="audio/mpeg">
                  	</audio>
              	</cfif>
         	</td>
    	</tr>
	</table>
<script language="javascript">
	pn_kontrol();
	function pn_kontrol()
	{
		geciktir1 = setTimeout("window.location.href='<cfoutput>#request.self#?fuseaction=eshipping.list_prtotm_shipping_portal</cfoutput>'", 100000);
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
				if(type == -2)
				{
					window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=32&action_id='+shipping_id_list);		
				}
			}
	}
	function degisim(is_type,action_id)
	{
		sevk_emp_id = document.getElementById('sevk_emp_id_'+action_id).value;
		window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=eshipping.emptypopup_upd_prtotm_sevk_emp&sevk_emp_id='+sevk_emp_id+'&is_type='+is_type+'&action_id='+action_id);
	}
	function goster()
	{
		svk_number = document.getElementById('svk_number').value;
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_PRTOTM_shipping_portal&svk_number='+svk_number;
	}
</script>
