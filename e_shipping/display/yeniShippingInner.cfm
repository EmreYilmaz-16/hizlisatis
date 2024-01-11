<cfparam name="attributes.Keyword" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.report_type_id" default="3">
<cfparam name="attributes.sort_type" default="1">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfquery name="SZ" datasource="#DSN#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cf_box title="E-Shipping">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <cfoutput>
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
                <div class="form-group">
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
            </tr>
        </table>
    </cfoutput>

    </cfform>
</cf_box>
<cfset this_year=year(now())>
<cfset past_year=year(now())-1>
<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
<cfquery name="getData" datasource="#dsn3#">
--SELECT * INTO [#dsn3#].XPRTOTM_PAKET_SAYISI FROM [#dsn3#].XPRTOTM_PAKET_SAYISI

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

            (CASE WHEN ISNULL(SUM(PAKETSAYISI), 0)=0 AND ISNULL(SUM(CONTROL_AMOUNT), 0)=0 THEN 'BARKOD YOK'
     WHEN ROUND((ISNULL(SUM(PAKETSAYISI), 0)-ISNULL(SUM(CONTROL_AMOUNT), 0)),0) = 0 THEN 'SEVK EDILDI'
	 WHEN ISNULL(SUM(CONTROL_AMOUNT), 0) = 0 AND ISNULL(ESR.IS_SEVK_EMIR,0) = 1 THEN 'SEVK EMRI VERILDI'
	 WHEN ISNULL(SUM(CONTROL_AMOUNT), 0) = 0 AND ISNULL(ESR.IS_SEVK_EMIR,0) <> 1 THEN 'SEVK EDILMEDI'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) > ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN 'EKSIK SEVKIYAT'
	 WHEN ROUND(ISNULL(SUM(PAKETSAYISI), 0),0) < ROUND(ISNULL(SUM(CONTROL_AMOUNT), 0),0) THEN 'FAZLA SEVKIYAT' ELSE '' END) AS AMBAR_DURUM

        --ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
        --ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
        FROM
            (
SELECT
                PAKET_SAYISI AS PAKETSAYISI,
                PAKET_ID AS STOCK_ID,
                (
SELECT
                    SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                ---BURADA DÖNEMDE LOOP ETMEM LAZIM
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

        --ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
        --   ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
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
    WHERE ESR.IS_TYPE = 1 AND ESR.OUT_DATE >= {ts '2023-11-01 00:00:00'} AND ESR.OUT_DATE <= {ts '2023-12-13 00:00:00'}
) AS TBL
WHERE
AMOUNT > 0
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





</cfif>