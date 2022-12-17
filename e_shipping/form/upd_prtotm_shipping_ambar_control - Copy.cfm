<cfsetting showdebugoutput="yes">
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
                    	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                  	FROM            
                     	#dsn2_alias#.STOCK_FIS AS SF INNER JOIN
                     	#dsn2_alias#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                  	WHERE        
                   		SF.FIS_TYPE = 113 AND 
                      	SF.REF_NO = '#attributes.ref_no#' AND 
                   		SFR.STOCK_ID = TBL.PAKET_ID
        	),0) AS CONTROL_AMOUNT
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
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),0)
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
                    ESR.SHIP_RESULT_ID = #attributes.ship_id#
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
                    	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                  	FROM            
                     	#dsn2_alias#.STOCK_FIS AS SF INNER JOIN
                     	#dsn2_alias#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                  	WHERE        
                   		SF.FIS_TYPE = 113 AND 
                      	SF.REF_NO = '#attributes.ref_no#' AND 
                   		SFR.STOCK_ID = TBL.PAKET_ID
          	),0) AS CONTROL_AMOUNT, 
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
                        	round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),0) 
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
                	SI.DISPATCH_SHIP_ID = #attributes.ship_id#
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
    <!---<cfquery name="get_record_date" datasource="#dsn3#">
    	SELECT     
        	TOP (1) RECORD_DATE,
            RECORD_EMP
		FROM         
        	PRTOTM_SHIPPING_PACKAGE_LIST
		WHERE     
        	SHIPPING_ID = #attributes.ship_id#
		ORDER BY 
        	SHIPPING_PACKAGE_ID DESC
    </cfquery>--->
<table class="dph">
	<tr> 
		<td class="dpht">Ambar Fişi Hazırlama Kontrol Listesi</td>
        <td style="text-align:right"><strong>Son Okutma Tarih ve Saati : </strong>
        <!---<cfif get_record_date.recordcount and len(get_record_date.RECORD_DATE)>
			<cfoutput>#get_emp_info(get_record_date.RECORD_EMP,0,0)# - #Dateformat(get_record_date.RECORD_DATE,'dd/mm/yyyy')# #timeformat(dateadd('h',session.ep.time_zone,get_record_date.RECORD_DATE),'HH:MM')#</cfoutput>
       	<cfelse>
        	
        </cfif>--->
        </td>
	</tr>
</table>    
<table id="kontrol_listesi" width="100%">
	<tr>
		<td>
        	<cf_medium_list>
                <thead>
                    <tr height="20px">
                        <th width="45px">Barkod</th>
                        <th width="70px">Kod</th>
                        <th>Ürün</th>
                        <th width="40px">Miktar</th>
                        <th width="40px">Kontrol</th>
                        <th width="40px">OK</th>
                    </tr>
    			</thead>
                <tbody>
					<cfoutput query="GET_SHIP_PACKAGE_LIST">
                        <tr height="20">
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE#</td>
                                <td>#product_name#</td>
                                <td style="text-align:right"><strong>#Tlformat(PAKETSAYISI,0)#</strong></td>
                                <td style="text-align:right"><strong>#Tlformat(control_amount,0)#</strong></td>
                                <td>
                                	<cfif control_amount eq 0>
                                    	<img src="images\closethin.gif" title="Ambar Fişi Yapılmadı">
                                    <cfelseif paketsayisi eq control_amount>
                                    	<img src="images\c_ok.gif" title="Hepsi Ambar Fişi Yapıldı">
                                    <cfelseif paketsayisi gt control_amount>
                               			<img src="images\warning.gif" title="Eksik Ambar Fişi Yapıldı">
                               		</cfif>
                                </td>
                        </tr>
                    </cfoutput>
            	</tbody>
                <tfoot>
                    <tr class="color-list">
                        <td colspan="6" align="right"><input type="button" value="Kapat" onClick="kontrol();"></td>
                    </tr>
             	</tfoot>
         	</cf_medium_list>
      	</td>
  	</tr>
</table>
<script language="javascript">
	function kontrol()
	{
		window.close();
	}
</script>