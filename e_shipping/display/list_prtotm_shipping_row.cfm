<cfquery name="get_orders_ship" datasource="#dsn3#">
	SELECT 
    	*
  	FROM
    	(
        SELECT     
            1 AS TYPE, 
            ORR.STOCK_ID, 
            ORR.SPECT_VAR_ID, 
            ORR.QUANTITY - ISNULL(ORR.DELIVER_AMOUNT, 0) AS BEKLEYEN, 
            ESR.OUT_DATE AS DELIVER_DATE, 
            CASE 
                WHEN O.COMPANY_ID IS NOT NULL THEN
                              (SELECT     NICKNAME
                                FROM          workcube_rendimobilya.dbo.COMPANY
                                WHERE      COMPANY_ID = O.COMPANY_ID) 
                WHEN O.CONSUMER_ID IS NOT NULL THEN
                              (SELECT     CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
                                FROM          workcube_rendimobilya.dbo.CONSUMER
                                WHERE      CONSUMER_ID = O.CONSUMER_ID) 
                WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                              (SELECT     EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
                                FROM          workcube_rendimobilya.dbo.EMPLOYEES
                                WHERE      EMPLOYEE_ID = O.EMPLOYEE_ID) 
            END AS UNVAN, 
            ESR.SHIP_RESULT_ID, 
            ESR.DELIVER_PAPER_NO
        FROM         
            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
            PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
            ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
        WHERE     
            O.ORDER_STATUS = 1 AND 
            O.RESERVED = 1 AND 
            O.PURCHASE_SALES = 1 AND 
            NOT (ORR.ORDER_ROW_CURRENCY IN (- 10, - 8, - 3, - 9)) AND 
            ORR.STOCK_ID IN (#attributes.stock_id#) AND 
            ESR.DEPARTMENT_ID = 5 AND 
            ESR.LOCATION_ID = 1
        UNION ALL
        SELECT     
            2 AS TYPE, 
            SIR.STOCK_ID, 
            SIR.SPECT_VAR_ID, 
            SIR.AMOUNT, 
            SI.DELIVER_DATE, 
            D.DEPARTMENT_HEAD + '-' + SI.DETAIL AS UNVAN, 
            SI.DISPATCH_SHIP_ID, 
            CAST(SI.DISPATCH_SHIP_ID AS CHAR(10)) AS DELIVER_PAPER_NO
        FROM         
            workcube_rendimobilya_2016_1.dbo.SHIP_INTERNAL AS SI INNER JOIN
            workcube_rendimobilya_2016_1.dbo.SHIP_INTERNAL_ROW AS SIR ON SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID LEFT OUTER JOIN
            workcube_rendimobilya.dbo.DEPARTMENT AS D ON SI.DEPARTMENT_IN = D.DEPARTMENT_ID LEFT OUTER JOIN
            workcube_rendimobilya_2016_1.dbo.SHIP AS SH ON SI.DISPATCH_SHIP_ID = SH.DISPATCH_SHIP_ID
        WHERE     
            SIR.STOCK_ID IN (#attributes.stock_id#) AND 
            SH.SHIP_ID IS NULL
    	) AS TBL
   	<cfif isdefined('attributes.start_date')>
  	WHERE
    	DELIVER_DATE >= '#DateFormat(attributes.start_date,"MM/DD/YYYY")#' 
        <cfif isdefined('attributes.finish_date')>
        	AND DELIVER_DATE < '#DateFormat(attributes.finish_date,"MM/DD/YYYY")#'
       	</cfif>
   	</cfif>
	ORDER BY
    	DELIVER_DATE
</cfquery>
<table class="dph">
	<tr> 
		<td class="dpht">Sevkiyat Rezerve Kontrol</td>
	</tr>
</table>
<cf_seperator id="iliskili_fatura" header="Sevk Belgeleri">
<table id="iliskili_fatura" width="100%">
	<tr>
		<td>
				 <cf_medium_list>
					<thead>
						<tr> 
                        	<th>Sıra No</th>
							<th>Sevk Plan No</th>
							<th>Sevk Plan Tarihi</th>
							<th>Müşteri</th>
							<th width="50" style="text-align:right;">Miktar</th>
						</tr>
					</thead>
					<tbody>
                    <cfset toplam_bekleyen = 0>
					<cfif get_orders_ship.recordcount>
                       	<cfoutput query="get_orders_ship">
                         	<tr>
                           		<td>#currentrow#</td>
                              	<td style="text-align:center;">
                                  	<cfif TYPE eq 1>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping&iid=#SHIP_RESULT_ID#','page');" class="tableyazi" title="Sevk Fişine Git">
                                        	#DELIVER_PAPER_NO#
                                        </a>
                                    <cfelse>
                                    	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.upd_dispatch_internaldemand&ship_id=#DELIVER_PAPER_NO#','longpage');" class="tableyazi" title="Sevk Talebine Git">
                                       		#DELIVER_PAPER_NO#
                                    	</a>
                                    </cfif>    	
                              	</td>
                             	<td style="text-align:center;">#DateFormat(DELIVER_DATE,'dd/mm/yyyy')#</td>
                              	<td>#UNVAN#</td>
                             	<td style="text-align:right;">#TLFormat(bekleyen)#</td>
                           	</tr>
                          	<cfset toplam_bekleyen = toplam_bekleyen + bekleyen>
                      	</cfoutput>
                    	<tr>
                        	<cfoutput>
                            	<td colspan="4"><strong>Toplam</strong></td>
                                <td style="text-align:right;"><strong>#TLFormat(toplam_bekleyen)#</strong></td>
                          	</cfoutput>
                     	</tr>
					</cfif>
					</tbody>
                    
				 </cf_medium_list>
</table>
