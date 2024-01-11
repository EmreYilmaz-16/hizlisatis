<cfparam name="attributes.Keyword" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.report_type_id" default="3">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.order_employee" default="#get_emp_info(session.ep.userid,0,0)# ">
<cfparam name="attributes.order_employee_id" default="#session.ep.userid#">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.MEMBER_NAME" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">



<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.prod_cat" default="">


<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.city_name" default="">


<cfparam name="attributes.t_point" default="0">
<cfparam name="attributes.SHIP_METHOD_ID" default="">

<cfparam name="attributes.totalrecords" default="0">
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

<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
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

<cf_box >
    <cfoutput>
   
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#" id="form1" name="Form1"> 
        <cf_box_search>     
        <table>
            <tr>
                <td>
                    <div class="form-group">
                        <input type="text" name="Keyword" id="Keyword" value="#attributes.Keyword#">
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <select name="report_type_id" id="report_type_id" style="width:120px;height:20px">
                            <option value="">Tümü</option>
							<option <cfif attributes.report_type_id eq 1>selected</cfif> value="1">Açık Sevkler</option>
                            <option <cfif attributes.report_type_id eq 2>selected</cfif> value="2">Kapalı Sevkler</option>
                            <option <cfif attributes.report_type_id eq 3>selected</cfif> value="3">Hazır Sevkler</option>
                            <option <cfif attributes.report_type_id eq 4>selected</cfif> value="4">Kısmi Hazır Sevkler</option>
					    </select>
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <select name="zone_id" id="zone_id" style="width:100px;height:20px">
                            <option value=""><cf_get_lang_main no='247.Satis Bölgesi'></option>
                            <cfloop query="sz">
                                <option value="#SZ_HIERARCHY#" <cfif attributes.zone_id eq SZ_HIERARCHY>selected</cfif>>#sz_name#</option>
                            </cfloop>
                        </select> 
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <select name="sort_type" id="sort_type" style="width:180px;height:20px">
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>>Teslim Tarihine Göre Artan</option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>>Teslim Tarihine Gre Azalan</option>
                            <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>>Belge Numarasına Göre Artan</option>
                            <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Belge Numarasına Göre Azalan</option>
                            <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>>Şirket Adına Göre Artan</option>
                        </select>   
                    </div>
                </td>
                <td>
                    <div class="form-group">
                        <select name="listing_type" id="listing_type" style="width:90px;height:20px">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>>Tümü</option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>>Sevk Planları</option>
                            <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>>Sevk Talepler</option>
                        </select>   
                    </div>
                </td>
            <td>
                <div class="form-group" style="display:flex">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                        <cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
            </td>
            <td style="display:flex">
                <div class="form-group">
                    <cf_wrk_search_button search_function='input_control()'>
                </div>
            </td>
            </tr>
        </table>
    </cf_box_search>
    <cf_box_search_detail>
<table>
    <tr>
        <td>
            <div class="form-group" id="item-order_employee">
                <!---order_employee
order_employee_id---->
                <label>Gönderen</label>
                <div >
                    <div class="input-group">
                        <input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfif isDefined("attributes.order_employee") and len(attributes.order_employee) and isdefined("attributes.order_employee_id") and  len(attributes.order_employee_id)><cfoutput>#attributes.order_employee_id#</cfoutput></cfif>">
                        <input name="order_employee" type="text" id="order_employee" onFocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','120');" value="<cfif isDefined("attributes.order_employee") and len(attributes.order_employee) and len(attributes.order_employee_id)><cfoutput>#attributes.order_employee#</cfoutput></cfif>" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=Form1.order_employee_id&field_name=Form1.order_employee&select_list=1');"></span>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-member_name">
                <label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>						
                <div class="col col-12">
                    <div class="input-group">
                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                        <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                        <input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                        <input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                        <cfset str_linke_ait="&field_consumer=Form1.consumer_id&field_comp_id=Form1.company_id&field_member_name=Form1.member_name&field_type=Form1.member_type">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=2,3&keyword='+encodeURIComponent(document.Form1.member_name.value));"></span>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-product_name">
                <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                <div class="col col-12">
                    <div class="input-group">
                        <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                        <input name="product_name" type="text" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=Form1.product_id&field_name=Form1.product_name&keyword='+encodeURIComponent(document.Form1.product_name.value));"></span>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <div class="form-group">
                <label class="col col-12">Ürün Kategorileri</label>                
                <select name="prod_cat" id="prod_cat" style="width:140px;height:20px">
                    <option value="">Seç</option>
                    <cfloop query="GET_PRODUCT_CATS">
                        <cfif listlen(hierarchy,".") gte 4>
                        <option value="#hierarchy#"<cfif (attributes.prod_cat eq hierarchy) and len(attributes.prod_cat) eq len(hierarchy)> selected</cfif>>#product_cat#</option>
                        </cfif>
                    </cfloop>
                </select> 
            </div>
        </td>
        <td>
            <div class="form-group">
                <label class="col col-12">Şube</label>                
                <select name="branch_id" id="branch_id" style="width:70px;height:20px">
                    <option value="">Seç</option>
                     <cfloop query="get_branch">
                           <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                    </cfloop>
                   </select>   
            </div>
        </td>
        <td>
            <div class="form-group">
                <label class="col col-12">Lokasyon</label>                
                <select name="sales_departments" id="sales_departments" style="width:130px;height:20px">
                    <option value="">Seç</option>
                    <cfloop query="get_department_name">
                        <cfset sla="#department_id#-#location_id#">
                       <cftry> <option value="#department_id#-#location_id#" <cfif isdefined("attributes.sales_departments") and attributes.sales_departments eq sla>selected</cfif>>#department_head#-#comment#</option><cfcatch></cfcatch></cftry>
                    </cfloop>
                </select>
            </div>
        </td>
        <td>
            <div class="form-group">
                <label class="col col-12">Şehir</label>                
                <select name="city_name" id="city_name" style="width:100px;height:20px">
                    <option value="">Seç</option>
                    <cfloop query="get_city">
                        <option value="#city_name#" <cfif isdefined("attributes.city_name") and attributes.city_name is '#city_name#'>selected</cfif>>#city_name#</option>
                    </cfloop>
                </select>  
            </div>
        </td>
        <td>
            <div class="form-group">
                <label class="col col-12">Sevk Yöntemi</label>           
                <select name="SHIP_METHOD_ID" id="SHIP_METHOD_ID" style="width:100px;height:20px">
                    <option value="">Seç</option>
                    <cfloop query="GET_SHIP_METHOD">
                        <option value="#SHIP_METHOD_ID#" <cfif isdefined("attributes.SHIP_METHOD_ID") and attributes.SHIP_METHOD_ID eq SHIP_METHOD_ID>selected</cfif>>#SHIP_METHOD#</option>
                    </cfloop>
                </select> 
            </div>
        </td>
    </tr>
</table>

    </cf_box_search_detail>
    
<input type="hidden" name="is_submit" value="1">
    </cfform>
</cfoutput>
</cf_box>
<cfset this_year=year(now())>
<cfset past_year=year(now())-1>
<cf_box title="Sevkiyat İşlemleri">
<cf_big_list>
    <thead>
        <tr>
            <th>
                #
            </th>
            <th>
                No
            </th>
            <th>
                Tarih
            </th>
            <th>
                Şirket
            </th>
            <th>
                Üye Bakiyesi
            </th>
            <th>
                Kaydeden
            </th>
            <th>
                Sevk Yöntemi
            </th>
            <th>
                INF
            </th>
            <th>
                SVK
            </th>
            <th>
                HZR
            </th>
            <th>
                KNT
            </th>
            <th>
                İRS
            </th>
            <th>
                FTR
            </th>
            <th>
                Kontrol Eden
            </th>
            <th>
                Şehir
            </th>
            <th>
                Açıklama
            </th>
            <th></th>
            <th></th>

            
        </tr>
    </thead>


<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfif len(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    </cfif>
<cfquery name="getData" datasource="#dsn3#">


SELECT
    *
FROM
    (
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
        '' AS SEHIR,
        '' AS ILCE,
        (CASE WHEN ESR.COMPANY_ID IS NOT NULL THEN COMPANY.NICKNAME
      WHEN ESR.CONSUMER_ID IS NOT NULL THEN ISNULL(CONSUMER_NAME,'') + ' ' + ISNULL(CONSUMER_SURNAME,'') ELSE '' END) AS UNVAN,
        0 AS IS_INSTALMENT,

        (SELECT ISNULL(SUM(ORR.QUANTITY), 0) AS AMOUNT
        FROM
            #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
            #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
        WHERE ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID 
) AS AMOUNT,

        (SELECT SUM(DURUM)
        FROM (
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
                #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
                #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                #dsn3#.ORDERS AS O WITH (NOLOCK) ON ORR.ORDER_ID = O.ORDER_ID
            WHERE      
		ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
            GROUP BY CASE 
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
		END
										
	) AS DURUM_K) AS DURUM,
        (
	SELECT SUM(SEVK_DURUM)
        FROM (
		SELECT
                (CASE 
				WHEN ORR.ORDER_ROW_CURRENCY = - 3 THEN 1 
				WHEN ORR.ORDER_ROW_CURRENCY = - 6 THEN 4
				WHEN ORR.ORDER_ROW_CURRENCY = - 8 THEN 1 
				WHEN ORR.ORDER_ROW_CURRENCY = - 9 THEN 1
				WHEN ORR.ORDER_ROW_CURRENCY = - 10 THEN 1
				ELSE 2
			END) AS SEVK_DURUM
            FROM
                #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
                #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
            WHERE      
			ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
            GROUP BY CASE 
				WHEN ORR.ORDER_ROW_CURRENCY = - 3 THEN 1 
				WHEN ORR.ORDER_ROW_CURRENCY = - 6 THEN 4
				WHEN ORR.ORDER_ROW_CURRENCY = - 8 THEN 1 
				WHEN ORR.ORDER_ROW_CURRENCY = - 9 THEN 1
				WHEN ORR.ORDER_ROW_CURRENCY = - 10 THEN 1
				ELSE 2
			END
		) AS SEVK_DURUM_K
	) AS SEVK_DURUM,

        (
SELECT
            SUM(ORR.QUANTITY)-SUM(ISNULL(ORR.DELIVER_AMOUNT,0))  AS INVOICE_DURUM
        FROM
            #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
            #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID
        WHERE      
	ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID) AS INVOICE_DURUM,

        (SELECT

            (CASE WHEN ISNULL(SUM(PAKETSAYISI), 0)=0 AND ISNULL(SUM(CONTROL_AMOUNT), 0)=0 THEN '1-BARKOD YOK'
     WHEN ROUND((ISNULL(SUM(PAKETSAYISI), 0)-ISNULL(SUM(CONTROL_AMOUNT), 0)),0) = 0 THEN '2-SEVK EDILDI'
	 WHEN ISNULL(SUM(CONTROL_AMOUNT), 0) = 0 AND ISNULL(ESR.IS_SEVK_EMIR,0) = 1 THEN '3-SEVK EMRI VERILDI'
	 WHEN ISNULL(SUM(CONTROL_AMOUNT), 0) = 0 AND ISNULL(ESR.IS_SEVK_EMIR,0) <> 1 THEN '4-SEVK EDILMEDI'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) > ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN '5-EKSIK SEVKIYAT'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) < ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN '6-FAZLA SEVKIYAT' ELSE '' END) AS AMBAR_DURUM


        FROM
            (
SELECT
                PAKET_SAYISI AS PAKETSAYISI,
                PAKET_ID AS STOCK_ID,
                (
SELECT
                    SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                
                FROM
                    ( 
                            SELECT
                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                        FROM
                            #dsn#_#this_year#_1.STOCK_FIS AS SF WITH (NOLOCK) INNER JOIN
                            #dsn#_#this_year#_1.STOCK_FIS_ROW AS SFR WITH (NOLOCK) ON SF.FIS_ID = SFR.FIS_ID
                        WHERE        
        SF.FIS_TYPE = 113 AND
                            SF.REF_NO = ESR.DELIVER_PAPER_NO AND
                            SFR.STOCK_ID = TBL.PAKET_ID

                    UNION ALL
                        SELECT
                            SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                        FROM
                            #dsn#_#past_year#_1.STOCK_FIS AS SF WITH (NOLOCK) INNER JOIN
                            #dsn#_#past_year#_1.STOCK_FIS_ROW AS SFR WITH (NOLOCK) ON SF.FIS_ID = SFR.FIS_ID
                        WHERE        
            SF.FIS_TYPE = 113 AND
                            SF.REF_NO = ESR.DELIVER_PAPER_NO AND
                            SFR.STOCK_ID = TBL.PAKET_ID
                                                        
    ) AS TBL_5
) AS CONTROL_AMOUNT
            FROM
                (
SELECT
                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                    PAKET_ID,
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
                        S.PRODUCT_TREE_AMOUNT,
                        ESRX.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID
                    FROM
                        #dsn3#.PRTOTM_SHIP_RESULT AS ESRX WITH (NOLOCK) INNER JOIN
                        #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) ON ESRX.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                        #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                        #dsn3#.XPRTOTM_PAKET_SAYISI AS EPS WITH (NOLOCK) ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                        #dsn3#.STOCKS AS S WITH (NOLOCK) ON EPS.PAKET_ID = S.STOCK_ID
                    WHERE      
        ESRX.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID
                    GROUP BY 
        EPS.PAKET_ID,  
        S.PRODUCT_TREE_AMOUNT, 
        ESRX.SHIP_RESULT_ID,
        ESRR.ORDER_ROW_ID
    ) AS TBL1
                GROUP BY
    PAKET_ID, 
    PRODUCT_TREE_AMOUNT, 
    SHIP_RESULT_ID
) AS TBL
) AS TBL2) AS AMBAR_KONTROL,

        (SELECT

            (CASE WHEN ISNULL(SUM(PAKETSAYISI), 0)=0 AND ISNULL(SUM(CONTROL_AMOUNT), 0)=0 THEN 'BARKOD YOK'
     WHEN ROUND((ISNULL(SUM(PAKETSAYISI), 0)-ISNULL(SUM(CONTROL_AMOUNT), 0)),0) = 0 THEN 'KONTROL EDILDI'
	 WHEN ISNULL(SUM(CONTROL_AMOUNT), 0) = 0  THEN 'KONTROL EDILMEDI'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) > ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN 'KONTROL EKSIK'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) < ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN 'TESLIMAT MIKTARI DUSURULMUS' ELSE '' END) AS PAKET_KONTROL

        
        FROM
            (
    SELECT
                PAKET_SAYISI AS PAKETSAYISI,
                PAKET_ID AS STOCK_ID,
                (
        SELECT
                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                FROM
                    #dsn3#.PRTOTM_SHIPPING_PACKAGE_LIST WITH (NOLOCK)
                WHERE      
            TYPE = 1 AND
                    STOCK_ID = TBL.PAKET_ID AND
                    SHIPPING_ID = TBL.SHIP_RESULT_ID
        ) AS CONTROL_AMOUNT
            FROM
                (
        SELECT
                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                    PAKET_ID,
                    PRODUCT_TREE_AMOUNT,
                    SHIP_RESULT_ID
                FROM
                    (     
                                    SELECT
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI,
                            EPS.PAKET_ID,
                            S.PRODUCT_TREE_AMOUNT,
                            ESRR.SHIP_RESULT_ID,
                            ESRR.ORDER_ROW_ID
                        FROM
                            #dsn3#.SPECTS AS SP WITH (NOLOCK) INNER JOIN
                            #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
                            #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID ON SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID INNER JOIN
                            #dsn3#.STOCKS AS S WITH (NOLOCK) INNER JOIN
                            #dsn3#.XPRTOTM_PAKET_SAYISI AS EPS WITH (NOLOCK) ON S.STOCK_ID = EPS.PAKET_ID ON SP.SPECT_MAIN_ID = 0 INNER JOIN
                            #dsn3#.STOCKS AS S1 WITH (NOLOCK) ON ORR.STOCK_ID = S1.STOCK_ID
                        WHERE      
                ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID AND
                            ISNULL(S1.IS_PROTOTYPE,0) = 1
                        GROUP BY 
                EPS.PAKET_ID, 
                S.PRODUCT_TREE_AMOUNT, 
                ESRR.SHIP_RESULT_ID,
                ESRR.ORDER_ROW_ID
                    UNION ALL
                        SELECT
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),2) AS PAKET_SAYISI,
                            EPS.PAKET_ID,
                            S.PRODUCT_TREE_AMOUNT,
                            ESRR.SHIP_RESULT_ID,
                            ESRR.ORDER_ROW_ID
                        FROM
                            #dsn3#.PRTOTM_SHIP_RESULT_ROW AS ESRR WITH (NOLOCK) INNER JOIN
                            #dsn3#.ORDER_ROW AS ORR WITH (NOLOCK) ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                            #dsn3#.XPRTOTM_PAKET_SAYISI AS EPS WITH (NOLOCK) ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                            #dsn3#.STOCKS AS S WITH (NOLOCK) ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                            #dsn3#.STOCKS AS S1 WITH (NOLOCK) ON ORR.STOCK_ID = S1.STOCK_ID
                        WHERE      
                ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID AND
                            ISNULL(S1.IS_PROTOTYPE,0) = 0
                        GROUP BY 
                EPS.PAKET_ID, 
                S.PRODUCT_TREE_AMOUNT, 
                ESRR.SHIP_RESULT_ID,
                ESRR.ORDER_ROW_ID
            ) AS TBL1
                GROUP BY
            PAKET_ID, 
            PRODUCT_TREE_AMOUNT, 
            SHIP_RESULT_ID
        ) AS TBL
    ) AS TBL2) AS PAKET_KONTROL

    FROM
        #dsn3#.PRTOTM_SHIP_RESULT AS ESR WITH (NOLOCK)
        INNER JOIN
        #dsn#.SHIP_METHOD AS SM WITH (NOLOCK)
        ON ESR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
        INNER JOIN
        #dsn#.EMPLOYEES AS E WITH (NOLOCK)
        ON ESR.DELIVER_EMP = E.EMPLOYEE_ID
        INNER JOIN
        #dsn#.DEPARTMENT AS D WITH (NOLOCK)
        ON ESR.DEPARTMENT_ID = D.DEPARTMENT_ID
        LEFT OUTER JOIN
        #dsn#.COMPANY WITH (NOLOCK)
        ON (COMPANY.COMPANY_ID=ESR.COMPANY_ID)
        LEFT OUTER JOIN
        #dsn#.CONSUMER WITH (NOLOCK)
        ON (CONSUMER.CONSUMER_ID=ESR.CONSUMER_ID)
    WHERE ESR.IS_TYPE = 1 
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


<tbody>
<cfoutput query="getData">
    <tr>
        <td>#currentrow#</td>
        <td style="text-align:center">
        <cfif IS_TYPE eq 1>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping&iid=#SHIP_RESULT_ID#','list');" class="tableyazi" title="<cf_get_lang_main no='3528.Sevk Fişine Git'>">
            #DELIVER_PAPER_NO#
            </a>
        <cfelse>
            <strong>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.add_dispatch_internaldemand&event=upd&ship_id=#DELIVER_PAPER_NO#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3531.Sevk Talebine Git'>">
                    #DELIVER_PAPER_NO#
                </a>
            </strong>
            <br>
            <cfset fuse_type = 'sales'>
            <cfif IS_INSTALMENT eq 1>
                    <cfset page_type = 'list_order_instalment&event=upd'>
            <cfelse>
                <cfset page_type = 'list_order&event=upd'>
            </cfif>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#order_id_list#','longpage');" class="tableyazi" title="<cf_get_lang_main no='3532.Satış Siparişine Git'>">
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
    <cfif ListFind(session.ep.user_level,25)>
        <td style="text-align:right">
        <CFTRY>
            <cfif IS_TYPE eq 1>
                <cfset bak.rc =0>
                <cfif len(company_id)>
                    <cfquery name="get_bakiye" datasource="#dsn2#">
                        SELECT        
                            BAKIYE3, 
                            OTHER_MONEY
                        FROM      
                            COMPANY_REMAINDER_MONEY
                        WHERE        
                            COMPANY_ID = #company_id#
                    </cfquery>
                <cfelseif len(consumer_id)>
                    <cfquery name="get_bakiye" datasource="#dsn2#">
                        SELECT        
                            BAKIYE3, 
                            OTHER_MONEY
                        FROM      
                            CONSUMER_REMAINDER_MONEY
                        WHERE        
                            CONSUMER_ID = #consumer_id#
                    </cfquery>
                </cfif>
                <cfset bak.rc=get_bakiye.recordCount>
                <cfif bak.rc>
                    <cfloop query="get_bakiye">
                    <font style="color:<cfif bakiye3 lte 0>blue<cfelse>red</cfif>">
                        #TlFormat(BAKIYE3,2)# #OTHER_MONEY# 
                       </font><cfif bak.rc gt get_bakiye.currentrow><br/></cfif>
                    </cfloop>
                </cfif>
            </cfif>
            <cfcatch></cfcatch>
        </CFTRY>
        </td>
    </cfif>
    <td>#get_emp_info(DELIVER_EMP,0,0)#</td>
    <td>#SHIP_METHOD#
        <br>
    <cfquery name="getPm" datasource="#dsn#">
            SELECT SP.PAYMETHOD FROM workcube_metosan.COMPANY_CREDIT AS CC 
            INNER JOIN workcube_metosan.SETUP_PAYMETHOD AS SP ON CC.PAYMETHOD_ID=SP.PAYMETHOD_ID
            WHERE CC.COMPANY_ID=#company_id#
    </cfquery>
    <b>Ö.Y:(#getPm.PAYMETHOD#)</b>
    </td>
    <td style="text-align:center">
        <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=eshipping.emptypopup_list_e_shipping_status_info&iid=#SHIP_RESULT_ID#','page')">
        <img src="../../../images/idea.gif" border="0" title="Durum" />
    </a>
    </td>
    <td style="text-align:center"> <!---Sevk Indicator--->
        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_list_e_shipping_info&iid=#SHIP_RESULT_ID#&is_type=#is_type#','page');" class="tableyazi" title="<cf_get_lang_main no='3533.Sevk Emri Ver'>">
            <cfif  SEVK_DURUM eq 2><!---- Buydu :#request.self#?fuseaction=sales.popup_upd_ezgi_shipping_sevk&iid=#SHIP_RESULT_ID#&is_type=#is_type#---->
                <img src="../../../images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='1305.Açık'>" />
            <cfelseif  SEVK_DURUM eq 1>
                <img src="../../../images/red_glob.gif" border="0" title="<cf_get_lang_main no='669.Hepsi'> <cf_get_lang_main no='3272.Kapalı'>" />
            <cfelseif  SEVK_DURUM eq 6>
                <img src="../../../images/green_glob.gif" border="0"title="<cf_get_lang_main no='3534.Kısmi Sevk'>" />
            <cfelseif  SEVK_DURUM eq 4>
                <img src="../../../images/blue_glob.gif" border="0"title="<cf_get_lang_main no='3535.Tüm Ürünler Hazır'>" />
            <cfelseif  SEVK_DURUM eq 5>
                <img src="../../../images/black_glob.gif" border="0"title="<cf_get_lang_main no='3536.Düzeltilmesi Gereken Sevk Talebi'>" />
            </cfif>
        </a>
    </td>
    <td style="text-align:center"> <!---Hazırlama Indicator--->
        <cfset NN=listGetAt(AMBAR_KONTROL,1,"-")>
        <cfif NN EQ 1>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                <img src="/images/plus_ques.gif" border="0" title="<cf_get_lang_main no='2178.Barkod Yok'>">
            </a>
         <cfelseif NN EQ 2>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                <img src="/images/red_glob.gif" border="0" title="<cf_get_lang_main no='3137.Sevk Edildi'>.">
            </a>
         <cfelseif NN EQ 3>
            <cfif IS_SEVK_EMIR eq 1>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                    <img src="/images/blue_glob.gif" border="0" title="<cf_get_lang_main no='3538.Sevk Emri Verildi.'>">
                </a>
            <cfelse>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/yellow_glob.gif" border="0" title="<cf_get_lang_main no='3138.Sevk Edilmedi'>.">
                </a>
            </cfif>
         <cfelseif NN EQ 5>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>">
                <img src="/images/green_glob.gif" border="0" title="<cf_get_lang_main no='3139.Eksik Sevkiyat'>.">
            </a>
         <cfelseif NN EQ 6>
            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=eshipping.emptypopup_upd_prtotm_shipping_ambar_control&ref_no=#DELIVER_PAPER_NO#&ship_id=#SHIP_RESULT_ID#&is_type=#is_type#','wide');" class="tableyazi" title="<cf_get_lang_main no='3537.Detay Göster'>"><img src="/images/black_glob.gif" border="0" title="<cf_get_lang_main no='3140.Fazla Sevkiyat'>">  
            </a>
        </cfif>
    </tr>
</cfoutput>
</tbody>

</cfif>
</cf_big_list>
</cf_box>
<script>
    function input_control(params) {
        $("#form1").submit();
    }
</script>