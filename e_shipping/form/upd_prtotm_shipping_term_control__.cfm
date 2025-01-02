<cfsetting showdebugoutput="yes">
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_RF_TO_SV_DEP, 
        DEFAULT_RF_TO_SV_LOC
	FROM            
    	PRTOTM_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid# AND
        ISNULL(POWER_USER,0) = 1
        
</cfquery>
<cfif not get_default_departments.recordcount>
	<cfset type = 0>
<cfelse>
	<cfset type = 1>
</cfif>
<cfquery name="get_status" datasource="#dsn3#">
	SELECT TOP (1) ISNULL(CONTROL_STATUS,1) AS CONTROL_STATUS FROM PRTOTM_SHIPPING_PACKAGE_LIST WHERE SHIPPING_ID = #attributes.ship_id#
</cfquery>
<cfif get_status.recordcount>
	<cfset kontrol_status = get_status.CONTROL_STATUS>
<cfelse>
	<cfset kontrol_status = 1>
</cfif>
<cfif kontrol_status eq 2>
	<cfif attributes.is_type eq 1>
        <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
            SELECT     
                PAKET_SAYISI AS PAKETSAYISI, 
                PAKET_ID AS STOCK_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME,
                ISNULL((
                SELECT     
                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                FROM          
                    PRTOTM_SHIPPING_PACKAGE_LIST
                WHERE      
                    TYPE = 1 AND 
                    STOCK_ID = TBL.PAKET_ID AND 
                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                ),0) AS CONTROL_AMOUNT,
                SHIP_RESULT_ID,
                DELIVER_PAPER_NO
            FROM         
                (
                SELECT
                    SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME, 
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID,
                    DELIVER_PAPER_NO
                FROM
                    (     
                    SELECT     
                        round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID,
                        ESR.DELIVER_PAPER_NO
                    FROM          
                        PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                        PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                        ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                        PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                        STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                    WHERE      
                        ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                        S.IS_PROTOTYPE = 0
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID,
                        ESR.DELIVER_PAPER_NO
                   	UNION ALL
                   	SELECT
                    	round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID,
                        ESR.DELIVER_PAPER_NO
                    FROM          
                     	SPECTS AS SP INNER JOIN
                     	PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                     	PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                      	ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID ON SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID INNER JOIN
                     	STOCKS AS S INNER JOIN
                     	PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID --ON SP.SPECT_MAIN_ID = EPS.MODUL_SPECT_ID
                    WHERE      
                        ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                        S.IS_PROTOTYPE = 1
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        ESR.SHIP_RESULT_ID,
                        ESRR.ORDER_ROW_ID,
                        ESR.DELIVER_PAPER_NO
                    ) AS TBL1
                GROUP BY
                    PAKET_ID, 
                    BARCOD, 
                    STOCK_CODE, 
                    PRODUCT_NAME, 
                    PRODUCT_TREE_AMOUNT, 
                    SHIP_RESULT_ID,
                    DELIVER_PAPER_NO
                ) AS TBL
        </cfquery>
    <cfelse>
        <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
            SELECT     
                PAKET_SAYISI AS PAKETSAYISI, 
                PAKET_ID AS STOCK_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME,
                ISNULL((
                SELECT     
                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                FROM          
                    PRTOTM_SHIPPING_PACKAGE_LIST
                WHERE      
                    TYPE = 2 AND 
                    STOCK_ID = TBL.PAKET_ID AND 
                    SHIPPING_ID = TBL.SHIP_RESULT_ID
                ),0) AS CONTROL_AMOUNT, 
                SHIP_RESULT_ID,
                SHIP_RESULT_ID AS DELIVER_PAPER_NO
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
                        round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
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
                        SI.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                        ISNULL(S.IS_PROTOTYPE,0) = 0
                    GROUP BY 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                        SI.DISPATCH_SHIP_ID
                 	UNION ALL
                    SELECT     
                        round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),3) AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                        SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
                    FROM    
                    	SPECTS AS SP INNER JOIN
                     	#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                     	#dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON SP.SPECT_VAR_ID = SIR.SPECT_VAR_ID INNER JOIN
                     	STOCKS AS S INNER JOIN
                    	PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID --ON SP.SPECT_MAIN_ID = EPS.MODUL_SPECT_ID
                    WHERE      
                        SI.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                        ISNULL(S.IS_PROTOTYPE,0) = 1
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
        </cfquery>
    </cfif> 
    <cfquery name="GET_SHIP_PACKAGE_LIST_group" dbtype="query">
        SELECT
            SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT,
            SUM(PAKETSAYISI) AS PAKET_SAYISI
        FROM
            GET_SHIP_PACKAGE_LIST	
    </cfquery>
<cfelse>
	<cfif attributes.is_type eq 1>
        <cfquery name="get_order_rows" datasource="#dsn3#">
            SELECT        
                E.ORDER_ROW_ID, 
                ORR.PRODUCT_NAME, 
                ORR.QUANTITY, 
                ORR.SPECT_VAR_ID,
                E.SHIP_RESULT_ROW_ID as ROW_ID, 
                S.STOCK_ID, 
                S.PRODUCT_ID, 
                S.PRODUCT_CODE,
                (SELECT DELIVER_PAPER_NO FROM PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID = E.SHIP_RESULT_ID) as DELIVER_PAPER_NO
            FROM            
                PRTOTM_SHIP_RESULT_ROW AS E INNER JOIN
                ORDER_ROW AS ORR ON E.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
            WHERE        
                E.SHIP_RESULT_ID = #attributes.ship_id#
        </cfquery>
    <cfelse>
        <cfquery name="get_order_rows" datasource="#dsn3#">
            SELECT    
            	ORR.SPECT_VAR_ID,    
                ORR.PRODUCT_NAME, 
                ORR.QUANTITY, 
                S.STOCK_ID, 
                S.PRODUCT_ID, 
                S.PRODUCT_CODE, 
                IR.SHIP_ROW_ID as ROW_ID, 
                ORR.ORDER_ROW_ID,
                IR.DISPATCH_SHIP_ID as DELIVER_PAPER_NO
            FROM            
                #dsn2_alias#.SHIP_INTERNAL_ROW AS IR INNER JOIN
                ORDER_ROW AS ORR ON IR.ROW_ORDER_ID = ORR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
            WHERE        
                IR.DISPATCH_SHIP_ID = #attributes.ship_id#
        </cfquery>
    </cfif>
</cfif>
<cfquery name="get_record_date" datasource="#dsn3#">
    	SELECT     
        	TOP (1) RECORD_DATE,
            RECORD_EMP
		FROM         
        	PRTOTM_SHIPPING_PACKAGE_LIST
		WHERE     
        	SHIPPING_ID = #attributes.ship_id#
		ORDER BY 
        	SHIPPING_PACKAGE_ID DESC
</cfquery>
<table class="dph">
	<tr> 
		<td class="dpht"><cfoutput>#getLang('stock',517)# - (<cfif kontrol_status eq 2>#getLang('main',3581)#<cfelse>#getLang('main',3582)#</cfif>)</cfoutput></td>
        <td style="text-align:right">
        	<cfif kontrol_status eq 1>
        		<a style="cursor:pointer" onclick="upd_ship_select();"><img src="images/clinick.gif"  title="<cf_get_lang_main no='3583.Sevk Edilemeyeni Temizle'>" border="0"></a>
            <cfelse>
				<cfif attributes.is_type eq 1 AND kontrol_status eq 2 AND GET_SHIP_PACKAGE_LIST_group.CONTROL_AMOUNT eq GET_SHIP_PACKAGE_LIST_group.PAKET_SAYISI>
                	<a style="cursor:pointer" onclick="upd_ship_change();"><img src="images/workflow_list.gif"  title="<cf_get_lang_main no='3584.Sevkiyat Kontrolü Satır Bazına Çevir'>" border="0"></a>
                </cfif>
            </cfif>
        </td>
	</tr>
</table>    
<table id="kontrol_listesi" width="100%">
	<tr>
		<td>
        	<cf_medium_list>
                <thead>
                    <tr height="20px">
                        <th width="45px"><cf_get_lang_main no='221.Barkod'></th>
                        <th width="70px"><cf_get_lang_main no='1173.Kod'></th>
                        <th><cf_get_lang_main no='245.Ürün'></th>
                        <th width="40px"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="40px"><cfoutput>#getLang('account',134)#</cfoutput></th>
                        <th width="20px"><cfoutput>#getLang('crm',1066)#</cfoutput></th>
                    </tr>
    			</thead>
                <tbody>
                	<cfif kontrol_status eq 2>
						<cfoutput query="GET_SHIP_PACKAGE_LIST">
                            <tr height="20">
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE#</td>
                                <td>#product_name#</td>
                                <td style="text-align:right"><strong>#Tlformat(PAKETSAYISI,3)#</strong></td>
                                 <input type="hidden" name="kalan_amount" id="kalan_amount_#currentrow#" value="#Tlformat(PAKETSAYISI,3)#"/>
                                <td style="text-align:right">
                                	<cfif type eq 1>
                                        <input name="control_amount" id="control_amount_#currentrow#" value="#Tlformat(control_amount,3)#" style="text-align:right; width:50px" class="box"/>
                                    <cfelse>
                                        <strong>#Tlformat(CONTROL_AMOUNT,3)#</strong>
                                    </cfif>
                                </td>
                                <td style="text-align:center">
                                	<cfif control_amount eq 0>
                                        <cfif type eq 1>
                                            <a href="javascript://" class="tableyazi" onclick="gonder(0,#currentrow#);">
                                               <img src="images\closethin.gif" title="Okuma Yapılmadı">
                                            </a>
                                        <cfelse>
                                            <img src="images\closethin.gif" title="<cf_get_lang_main no='3585.Okuma Yapılmadı'>">
                                        </cfif>
                                    <cfelseif paketsayisi eq control_amount>
                                    	<img src="images\c_ok.gif" title="<cf_get_lang_main no='3577.Hepsi Okundu'>">
                                    <cfelseif paketsayisi gt control_amount>
                                        <cfif type eq 1>
                                            <a href="javascript://" class="tableyazi" onclick="gonder(0,#currentrow#);">
                                                <img src="images\warning.gif" title="<cf_get_lang_main no='3586.Eksik Okuma'>">
                                            </a>
                                        <cfelse>
                                            <img src="images\warning.gif" title="<cf_get_lang_main no='3586.Eksik Okuma'>">
                                        </cfif>
                               		<cfelse>
                                    	<a href="javascript://" class="tableyazi" onclick="gonder(0,#currentrow#);">
                                               <img src="images\closethin.gif" title="<cf_get_lang_main no='3587.Fazla Okutuldu'>">
                                            </a>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                   	<cfelse>
                    	<cfoutput query="get_order_rows">
                        	<cfif attributes.is_type eq 1>
                                <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
                                    SELECT
                                        CASE
                                            WHEN 
                                                PRODUCT_TREE_AMOUNT IS NOT NULL
                                            THEN 
                                                PRODUCT_TREE_AMOUNT
                                            ELSE
                                                PAKETSAYISI
                                        END 
                                            AS PAKETSAYISI,
                                        CONTROL_AMOUNT,
                                        STOCK_ID,
                                        BARCOD,
                                        STOCK_CODE,
                                        PRODUCT_NAME,
                                        SPECT_MAIN_ID
                                    FROM
                                        (
                                        SELECT
                                            SUM(PAKET_SAYISI) PAKETSAYISI,
                                            ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT,
                                            PAKET_ID STOCK_ID,
                                            BARCOD,
                                            STOCK_CODE,
                                            PRODUCT_NAME,
                                            PRODUCT_TREE_AMOUNT,
                                            SPECT_MAIN_ID
                                        FROM
                                            (      
                                            SELECT     
                                                SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) AS PAKET_SAYISI, 
                                                TBL_1.CONTROL_AMOUNT, 
                                                ESRR.SHIP_RESULT_ROW_ID, 
                                                ORR.STOCK_ID AS MODUL_STOCK_ID, 
                                                EPS.PAKET_ID, 
                                                S.BARCOD, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID
                                            FROM  
                                                PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                                                ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                                                PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                                                STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID LEFT OUTER JOIN
                                                (
                                                SELECT     
                                                    SHIPPING_ID, 
                                                    STOCK_ID, 
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 1 AND
                        							SHIPPING_ROW_ID = #get_order_rows.ROW_ID#
                                                GROUP BY 
                                                    SHIPPING_ID, 
                                                    STOCK_ID
                                                ) AS TBL_1 ON EPS.PAKET_ID = TBL_1.STOCK_ID AND ESR.SHIP_RESULT_ID = TBL_1.SHIPPING_ID INNER JOIN
                                                STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                                            WHERE     
                                                ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                                                ESRR.SHIP_RESULT_ROW_ID = #get_order_rows.ROW_ID# AND
                                                ISNULL(S1.IS_PROTOTYPE,0) = 0
                                            GROUP BY 
                                                EPS.PAKET_ID, 
                                                TBL_1.CONTROL_AMOUNT, 
                                                ESRR.SHIP_RESULT_ROW_ID, 
                                                ORR.STOCK_ID, 
                                                S.BARCOD, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                ORR.SPECT_VAR_ID
                                          	UNION ALL
                                            SELECT     
                                                SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) AS PAKET_SAYISI, 
                                                TBL_1.CONTROL_AMOUNT, 
                                                ESRR.SHIP_RESULT_ROW_ID, 
                                                ORR.STOCK_ID AS MODUL_STOCK_ID, 
                                                EPS.PAKET_ID, 
                                                S.BARCOD, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID
                                            FROM  
                                           		STOCKS AS S INNER JOIN
                         						PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID 
                                                
                                                INNER JOIN
                      							PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                        						PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                         						ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID 
                                                LEFT OUTER JOIN
                                                (
                                                SELECT     
                                                    SHIPPING_ID, 
                                                    STOCK_ID, 
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 1 AND
                        							SHIPPING_ROW_ID = #get_order_rows.ROW_ID#
                                                GROUP BY 
                                                    SHIPPING_ID, 
                                                    STOCK_ID
                                                ) AS TBL_1 ON EPS.PAKET_ID = TBL_1.STOCK_ID AND ESR.SHIP_RESULT_ID = TBL_1.SHIPPING_ID INNER JOIN
                                                STOCKS AS S1 ON ORR.STOCK_ID = S1.STOCK_ID
                                            WHERE     
												ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                                                ESRR.SHIP_RESULT_ROW_ID = #get_order_rows.ROW_ID# AND
                                                ISNULL(S1.IS_PROTOTYPE,0) = 1
                                            GROUP BY 
                                                EPS.PAKET_ID, 
                                                TBL_1.CONTROL_AMOUNT, 
                                                ESRR.SHIP_RESULT_ROW_ID, 
                                                ORR.STOCK_ID, 
                                                S.BARCOD, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                ORR.SPECT_VAR_ID
                                            ) TBL_3
                                        GROUP BY
                                            PAKET_ID,
                                            BARCOD,
                                            STOCK_CODE,
                                            PRODUCT_NAME,
                                            PRODUCT_TREE_AMOUNT,
                                            SPECT_MAIN_ID
                                        ) AS TBL_4
                                </cfquery>
                            <cfelse>
                                <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
                                    SELECT
                                        CASE
                                            WHEN 
                                                PRODUCT_TREE_AMOUNT IS NOT NULL
                                            THEN 
                                                PRODUCT_TREE_AMOUNT
                                            ELSE
                                                PAKETSAYISI
                                        END 
                                            AS PAKETSAYISI,
                                        CONTROL_AMOUNT,
                                        STOCK_ID,
                                        BARCOD,
                                        STOCK_CODE,
                                        PRODUCT_NAME,
                                        SPECT_MAIN_ID
                                    FROM
                                        (
                                        SELECT
                                            SUM(PAKET_SAYISI) PAKETSAYISI,
                                            ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT,
                                            PAKET_ID STOCK_ID,
                                            BARCOD,
                                            STOCK_CODE,
                                            PRODUCT_NAME,
                                            PRODUCT_TREE_AMOUNT,
                                            SPECT_MAIN_ID
                                        FROM
                                            (      
                                            SELECT     
                                                TBL_1.CONTROL_AMOUNT, 
                                                EPS.PAKET_ID, 
                                                S.BARCOD, 
                                                SIR.SHIP_ROW_ID, 
                                                SIR.AMOUNT * EPS.PAKET_SAYISI AS PAKET_SAYISI, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = SIR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID
                                            FROM         
                                                (
                                                SELECT     
                                                    SHIPPING_ID, 
                                                    STOCK_ID, 
                                                    SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                                FROM          
                                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                                WHERE      
                                                    TYPE = 2 AND
                        							SHIPPING_ROW_ID = #get_order_rows.ROW_ID#
                                                GROUP BY 
                                                    SHIPPING_ID, 
                                                    STOCK_ID
                                                ) TBL_1 RIGHT OUTER JOIN
                                                PRTOTM_PAKET_SAYISI AS EPS INNER JOIN
                                                STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                                                #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                                                #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID ON 
                                                TBL_1.SHIPPING_ID = SIR.DISPATCH_SHIP_ID AND TBL_1.STOCK_ID = EPS.PAKET_ID
                                            WHERE     
                                                SI.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                                                SIR.SHIP_ROW_ID = #get_order_rows.ROW_ID#
                                            GROUP BY 
                                                EPS.PAKET_ID, 
                                                TBL_1.CONTROL_AMOUNT, 
                                                S.BARCOD, 
                                                SIR.SHIP_ROW_ID, 
                                                SIR.AMOUNT, 
                                                EPS.PAKET_SAYISI, 
                                                S.STOCK_CODE, 
                                                S.PRODUCT_NAME,
                                                S.PRODUCT_TREE_AMOUNT,
                                                SIR.SPECT_VAR_ID
                                            ) TBL_3
                                        GROUP BY
                                            PAKET_ID,
                                            BARCOD,
                                            STOCK_CODE,
                                            PRODUCT_NAME,
                                            PRODUCT_TREE_AMOUNT,
                                            SPECT_MAIN_ID
                                        ) AS TBL_4       
                                </cfquery>
                            </cfif>
                            <tr height="20">
                                <td></td>
                                <td><b>#PRODUCT_CODE#</b></td>
                                <td><b>#PRODUCT_NAME#</b></td>
                                <td style="text-align:right"><b>#Tlformat(QUANTITY,3)#</b></td>
                                <td></td>
                                <td></td>
                          	</tr>
                            <cfif GET_SHIP_PACKAGE_LIST.recordcount>
                            	<cfloop query="#GET_SHIP_PACKAGE_LIST#">
                                	<cfset 'stock_id_#get_order_rows.ROW_ID#_#GET_SHIP_PACKAGE_LIST.currentrow#' = GET_SHIP_PACKAGE_LIST.STOCK_ID>
                                	<tr height="20">
                                        <td>#BARCOD#</td>
                                        <td>#STOCK_CODE#</td>
                                        <td>#product_name#</td>
                                        <td style="text-align:right">#Tlformat(PAKETSAYISI,3)#</td>
                                         <input type="hidden" name="kalan_amount_#get_order_rows.ROW_ID#_#currentrow#" id="kalan_amount_#get_order_rows.ROW_ID#_#GET_SHIP_PACKAGE_LIST.currentrow#" value="#Tlformat(PAKETSAYISI,3)#"/>
                                        <td style="text-align:right">
                                            <cfif type eq 1>
                                                <input name="control_amount_#get_order_rows.ROW_ID#_#GET_SHIP_PACKAGE_LIST.currentrow#" id="control_amount_#get_order_rows.ROW_ID#_#GET_SHIP_PACKAGE_LIST.currentrow#" value="#Tlformat(control_amount,3)#" style="text-align:right; width:50px" class="box"/>
                                            <cfelse>
                                                #Tlformat(CONTROL_AMOUNT,3)#
                                            </cfif>
                                        </td>
                                        <td style="text-align:center">
                                            <cfif control_amount eq 0>
                                                <cfif type eq 1>
                                                    <a href="javascript://" class="tableyazi" onclick="gonder(#get_order_rows.ROW_ID#,#GET_SHIP_PACKAGE_LIST.currentrow#);">
                                                       <img src="images\closethin.gif" title="<cf_get_lang_main no='3585.Okuma Yapılmadı'>">
                                                    </a>
                                                <cfelse>
                                                    <img src="images\closethin.gif" title="<cf_get_lang_main no='3585.Okuma Yapılmadı'>">
                                                </cfif>
                                            <cfelseif paketsayisi eq control_amount>
                                                <img src="images\c_ok.gif" title="<cf_get_lang_main no='3577.Hepsi Okundu'>">
                                            <cfelseif paketsayisi gt control_amount>
                                            	<cfif type eq 1>
                                                    <a href="javascript://" class="tableyazi" onclick="gonder(#get_order_rows.ROW_ID#,#GET_SHIP_PACKAGE_LIST.currentrow#);">
                                                        <img src="images\warning.gif" title="<cf_get_lang_main no='3586.Eksik Okuma'>">
                                                    </a>
                                                <cfelse>
                                                    <img src="images\warning.gif" title="<cf_get_lang_main no='3586.Eksik Okuma'>">
                                                </cfif>
                                            <cfelse>
                                                <a href="javascript://" class="tableyazi" onclick="gonder(#get_order_rows.ROW_ID#,#GET_SHIP_PACKAGE_LIST.currentrow#);">
                                                 	<img src="images\closethin.gif" title="<cf_get_lang_main no='3587.Fazla Okutuldu'>">
                                               	</a>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfloop>
                            </cfif>
                       	</cfoutput>
                   	</cfif>
            	</tbody>
                <tfoot>
                    <tr class="color-list">
                    	<td colspan="3">
                        	<strong><cf_get_lang_main no='3588.Son Okutma Tarih ve Saati'> : </strong>
							<cfif get_record_date.recordcount and len(get_record_date.RECORD_DATE)>
                                <cfoutput>#get_emp_info(get_record_date.RECORD_EMP,0,0)# - #Dateformat(get_record_date.RECORD_DATE,'DD/MM/YYYY')# #timeformat(dateadd('h',session.ep.time_zone,get_record_date.RECORD_DATE),'HH:MM')#</cfoutput>
                            <cfelse>
                                
                            </cfif>
                        </td>
                        <td colspan="3" style="text-align:right">
                        	<cfif type eq 1>
                            	<input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="kontrol(0);">&nbsp;
                        		<input type="button" value="<cf_get_lang_main no='3589.Sevk Kontrol Oluştur'>" name="sevk_kontrol" id="sevk_kontrol" onClick="kontrol(1);" style="width:140px;">
                            <cfelse>
                            	<input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="kontrol(0);">
                            </cfif>
                        </td>
                    </tr>
             	</tfoot>
         	</cf_medium_list>
      	</td>
  	</tr>
</table>
<form name="aktar_form" method="post">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
	<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
    <cfif kontrol_status eq 2>
    	<input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#GET_SHIP_PACKAGE_LIST.DELIVER_PAPER_NO#</cfoutput>" />
    <cfelse>
    	<input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#get_order_rows.DELIVER_PAPER_NO#</cfoutput>" />
        <input type="hidden" name="convert_ref_stock_id" id="convert_ref_stock_id" value="">
        <input type="hidden" name="convert_ship_id" id="convert_ship_id" value="">
    </cfif>
    <input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>" />
</form>
<script language="javascript">
	function gonder(row_id,rowi)
	{
		<cfif kontrol_status eq 2>
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
				rowa = #currentrow#;
				if(rowi == rowa)
				{
					document.getElementById("control_amount_"+rowi).value =  document.getElementById("kalan_amount_"+rowi).value;
					
				}
			</cfoutput>
		<cfelse>
			<cfoutput query="get_order_rows">
				<cfloop from="1" to="50" index="i">
					rowad = #get_order_rows.ROW_ID#;
					rowa = #i#;
					if(rowi == rowa && row_id == rowad)
						document.getElementById("control_amount_"+row_id+"_"+rowi).value =  document.getElementById("kalan_amount_"+row_id+"_"+rowi).value;
				</cfloop>
			</cfoutput>
		</cfif>
	}
	function kontrol(type)
	{
		if(type==0)
		window.close();
		if(type==1)
		{
			var convert_list ="";
			var convert_ship_list="";
			var convert_ref_stock_id="";
			var convert_list_amount ="";
			<cfif kontrol_status eq 2>
				<cfoutput query="GET_SHIP_PACKAGE_LIST">
					if(filterNum(document.getElementById('control_amount_#currentrow#').value) >= 0)
					{
						stock_id = #stock_id#;
						convert_list += stock_id+',';
						convert_list_amount += filterNum(document.getElementById('control_amount_#currentrow#').value)+',';
					}
				</cfoutput>
			<cfelse>
				<cfoutput query="get_order_rows">
					<cfloop from="1" to="250" index="i">
						<cfif isdefined('stock_id_#get_order_rows.ROW_ID#_#i#')>
							if(filterNum(document.getElementById('control_amount_#get_order_rows.ROW_ID#_#i#').value) >=0 && document.getElementById('control_amount_#get_order_rows.ROW_ID#_#i#').value != '')
							{
								stock_id = #Evaluate('stock_id_#get_order_rows.ROW_ID#_#i#')#;
								ship_row_id = #get_order_rows.ROW_ID#;
								ref_stock_id = #get_order_rows.STOCK_ID#;
								convert_list += stock_id+',';
								convert_ref_stock_id += ref_stock_id+',';
								convert_ship_list += ship_row_id+',';
								convert_list_amount += filterNum(document.getElementById('control_amount_#get_order_rows.ROW_ID#_#i#').value)+',';
							}
						</cfif>
					</cfloop>
				</cfoutput>
			</cfif>
			<cfif kontrol_status eq 2>
				document.getElementById('convert_stocks_id').value=convert_list;
				document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			<cfelse>
				document.getElementById('convert_stocks_id').value=convert_list;
				document.getElementById('convert_ship_id').value=convert_ship_list;
				document.getElementById('convert_ref_stock_id').value=convert_ref_stock_id;
				document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			</cfif>
			if(convert_list)//Ürün Seçili ise
			{
				 windowopen('','wide','cc_paym');
				 if(type==1)
				 {
					 aktar_form.action="<cfoutput>#request.self#?fuseaction=sales.emptypopup_add_PRTOTM_shipping_control_fis&is_type=#attributes.is_type#&kontrol_status=#kontrol_status#</cfoutput>";
					 document.getElementById('sevk_kontrol').disabled=true;
				 }
				 aktar_form.target='cc_paym';
				 aktar_form.submit();
			 }
			 else
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
		}
	}
	function upd_ship_select()
	{
		sor = confirm('<cf_get_lang_main no='3590.Sevk Edilemeyen Satırlar Plandan Çıkarılacaktır'> !');	
		if(sor==true)
			window.location ="<cfoutput>#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping_clear&ship_id=#attributes.ship_id#&is_type=#attributes.is_type#</cfoutput>";
		else
			return false;
	}
	function upd_ship_change()
	{
		sor = confirm('<cf_get_lang_main no='3591.Sevkiyat Kontrol Satır Bazına Döndürülecektir'> !');	
		if(sor==true)
			window.location ="<cfoutput>#request.self#?fuseaction=sales.emptypopup_upd_PRTOTM_shipping_clear&change=1&ship_id=#attributes.ship_id#&is_type=#attributes.is_type#</cfoutput>";
		else
			return false;
	}
</script>