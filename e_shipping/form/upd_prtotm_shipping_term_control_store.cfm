<cfsetting showdebugoutput="yes">
   	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn2#">
        SELECT     
        	PAKET_ID, 
            SUM(PAKET_SAYISI) AS PAKETSAYISI, 
            ISNULL(
                    	(
                        	SELECT     
                            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                           	FROM         
                            	#dsn3_alias#.PRTOTM_SHIPPING_PACKAGE_LIST_COLLECT_STORE
                        	WHERE     
                            	STOCK_ID = TBL_3.PAKET_ID AND 
                                COLLECT_ID = TBL_3.COLLECT_ID
                      	), 
                        0) AS CONTROL_AMOUNT, 
            SUM(CONTROL_AMOUNT1) AS CONTROL_AMOUNT1, 
        	STOCK_CODE, 
            BARCOD, 
            PRODUCT_NAME,
            COLLECT_ID
		FROM         
        	(
            	SELECT   
                	TBL.COLLECT_ID,  
                	TBL.PAKET_ID, 
                    TBL.PAKET_SAYISI, 
                    
              		ISNULL(
                    	(
                        	SELECT     
                            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                          	FROM         
                            	#dsn3_alias#.PRTOTM_SHIPPING_PACKAGE_LIST
                         	WHERE     
                            	TYPE = 2 AND 
                                STOCK_ID = TBL.PAKET_ID AND 
                                SHIPPING_ID = TBL.DISPATCH_SHIP_ID
                     	), 
                        0) AS CONTROL_AMOUNT1, 
                	S.STOCK_CODE, 
                    S.BARCOD, 
               		S.PRODUCT_NAME
              	FROM          
                	(
                    	SELECT     
                        	EC.DISPATCH_SHIP_ID, 
                            EPS.PAKET_ID, 
                            EC.COLLECT_ID, 
                            EC.DEPARTMENT_IN, 
                            EC.SHIP_METHOD, 
                            EC.DEPARTMENT_OUT, 
                            SUM(EPS.PAKET_SAYISI * SIR.AMOUNT) AS PAKET_SAYISI
                    	FROM          
                        	PRTOTM_SHIP_INTERNAL_COLLECT AS EC INNER JOIN
                            SHIP_INTERNAL_ROW AS SIR ON EC.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID INNER JOIN
                            workcube_rendimobilya_1.dbo.PRTOTM_PAKET_SAYISI AS EPS ON SIR.STOCK_ID = EPS.MODUL_ID
                     	WHERE      
                        	EC.COLLECT_ID = '#attributes.collect_id#'
                     	GROUP BY 
                        	EC.DISPATCH_SHIP_ID, 
                            EPS.PAKET_ID, 
                            EC.COLLECT_ID, 
                            EC.DEPARTMENT_IN, 
                            EC.SHIP_METHOD, 
                            EC.DEPARTMENT_OUT
                 		) AS TBL INNER JOIN
                  	#dsn3_alias#.STOCKS S ON TBL.PAKET_ID = S.STOCK_ID
        		) AS TBL_3
		GROUP BY 
        	PAKET_ID, 
            STOCK_CODE, 
            BARCOD, 
            PRODUCT_NAME,
            COLLECT_ID
    </cfquery>
<table class="dph">
	<tr> 
		<td class="dpht">Paket Kontrol Listesi</td>
        <td style="text-align:right"><strong></strong>

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
                        <th width="40px">Paket Sayısı</th>
                        <th width="40px">Çıkış Kontrol</th>
                        <th width="40px">Mağaza Kontrol</th>
                    </tr>
    			</thead>
                <tbody>
					<cfoutput query="GET_SHIP_PACKAGE_LIST">
                        <tr height="20">
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE#</td>
                                <td>#product_name#</td>
                                <td style="text-align:right"><strong>#Tlformat(PAKETSAYISI,0)#</strong></td>
                                <td style="text-align:right"><strong>#Tlformat(control_amount1,0)#</strong></td>
                                <td style="text-align:right"><strong>#Tlformat(control_amount,0)#</strong></td>
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