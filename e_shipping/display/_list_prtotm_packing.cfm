<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.list_type" default="1">
<cfparam name="attributes.is_form_submitted" default="">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.is_form_submitted)>
  	<cfquery name="get_packing" datasource="#dsn3#">
    	SELECT
        	*,
            CASE
            	WHEN TBL1.COMPANY_ID IS NOT NULL THEN
                   (
                    SELECT     
                      	NICKNAME
					FROM         
                    	#dsn_alias#.COMPANY
					WHERE     
                   		COMPANY_ID = TBL1.COMPANY_ID
                  	)
             	WHEN TBL1.CONSUMER_ID IS NOT NULL THEN      
                   	(	
                  	SELECT     
                     	CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS ISIM
					FROM         
                      	#dsn_alias#.CONSUMER
					WHERE     
                		CONSUMER_ID = TBL1.CONSUMER_ID
               		)
              	WHEN TBL1.EMPLOYEE_ID IS NOT NULL THEN
                  	(
                   	SELECT     
                    	EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM
					FROM         
                  		#dsn_alias#.EMPLOYEES
					WHERE     
                     	EMPLOYEE_ID = TBL1.EMPLOYEE_ID
                 	)
          	END AS UNVAN
       	FROM
        	(
            SELECT   
                1 AS TYPE, 
                TBL.COMPANY_ID, 
                TBL.CONSUMER_ID, 
                TBL.EMPLOYEE_ID,
                TBL.DELIVER_PAPER_NO, 
                TBL.SHIP_RESULT_ID, 
                TBL.ORDER_NUMBER, 
                TBL.ORDER_ID, 
                EP.PACKING_NO, 
                EP.RECORD_DATE, 
                EP.RECORD_EMP, 
                EPR.STOCK_ID, 
                EPR.SPECT_MAIN_ID, 
                S.STOCK_CODE, 
                S.BARCOD, 
                S.PRODUCT_NAME, 
                SUM(EPR.AMOUNT) AS PAKET_AMOUNT
            FROM         
                (
                SELECT     
                    O.COMPANY_ID, 
                    O.CONSUMER_ID, 
                    O.EMPLOYEE_ID,
                    ESR.DELIVER_PAPER_NO, 
                    ESR.SHIP_RESULT_ID, 
                    O.ORDER_NUMBER, 
                    ESRR.ORDER_ID
                FROM          
                    PRTOTM_SHIP_RESULT_ROW AS ESRR INNER JOIN
                    PRTOTM_SHIP_RESULT AS ESR ON ESRR.SHIP_RESULT_ID = ESR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
                GROUP BY 
                    O.COMPANY_ID,
                    O.CONSUMER_ID, 
                    O.EMPLOYEE_ID, 
                    ESR.DELIVER_PAPER_NO, 
                    ESR.SHIP_RESULT_ID, 
                    O.ORDER_NUMBER, 
                    ESRR.ORDER_ID
                ) AS TBL INNER JOIN
                PRTOTM_PACKING AS EP ON TBL.SHIP_RESULT_ID = EP.SHIP_RESULT_ID INNER JOIN
                PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID INNER JOIN
                STOCKS AS S ON EPR.STOCK_ID = S.STOCK_ID
            WHERE     
                EP.TYPE = 1
            GROUP BY 
                TYPE,
                TBL.COMPANY_ID,
                TBL.CONSUMER_ID, 
                TBL.EMPLOYEE_ID, 
                TBL.DELIVER_PAPER_NO, 
                TBL.SHIP_RESULT_ID, 
                TBL.ORDER_NUMBER, 
                TBL.ORDER_ID, 
                EP.PACKING_NO, 
                EP.RECORD_DATE, 
                EP.RECORD_EMP, 
                EPR.STOCK_ID, 
                EPR.SPECT_MAIN_ID, 
                S.STOCK_CODE, 
                S.BARCOD, 
                S.PRODUCT_NAME
            UNION ALL
            SELECT     
                2 AS TYPE, 
                TBL.COMPANY_ID, 
                TBL.CONSUMER_ID, 
                TBL.EMPLOYEE_ID, 
                TBL.DELIVER_PAPER_NO, 
                TBL.SHIP_RESULT_ID, 
                TBL.ORDER_NUMBER, 
                TBL.ORDER_ID, 
                EP.PACKING_NO, 
                EP.RECORD_DATE, 
                EP.RECORD_EMP, 
                EPR.STOCK_ID, 
                EPR.SPECT_MAIN_ID, 
                S.STOCK_CODE, 
                S.BARCOD, 
                S.PRODUCT_NAME, 
                SUM(EPR.AMOUNT) AS PAKET_AMOUNT
            FROM         
                (
                SELECT     
                    O.COMPANY_ID, 
                    O.CONSUMER_ID, 
                    O.EMPLOYEE_ID, 
                    CAST(SIR.DISPATCH_SHIP_ID AS VARCHAR(50)) AS DELIVER_PAPER_NO,
                    SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID, 
                    O.ORDER_NUMBER, 
                    O.ORDER_ID
                FROM          
                    #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID INNER JOIN
                    ORDER_ROW AS ORR INNER JOIN
                    ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID ON SIR.ROW_ORDER_ID = ORR.ORDER_ROW_ID
                GROUP BY 
                    O.COMPANY_ID, 
                    O.CONSUMER_ID, 
                    O.EMPLOYEE_ID, 
                    O.ORDER_NUMBER, 
                    SI.DISPATCH_SHIP_ID, 
                    O.ORDER_ID, 
                    SIR.DISPATCH_SHIP_ID
                ) AS TBL INNER JOIN
                PRTOTM_PACKING AS EP ON TBL.SHIP_RESULT_ID = EP.SHIP_RESULT_ID INNER JOIN
                PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID INNER JOIN
                STOCKS AS S ON EPR.STOCK_ID = S.STOCK_ID
            WHERE     
                EP.TYPE = 2 AND 
                EP.PERIOD_ID = 6
            GROUP BY 
                EP.TYPE, 
                TBL.COMPANY_ID, 
                TBL.CONSUMER_ID, 
                TBL.EMPLOYEE_ID, 
                TBL.DELIVER_PAPER_NO, 
                TBL.SHIP_RESULT_ID, 
                TBL.ORDER_NUMBER, 
                TBL.ORDER_ID, 
                EP.PACKING_NO, 
                EP.RECORD_DATE, 
                EP.RECORD_EMP, 
                EPR.STOCK_ID, 
                EPR.SPECT_MAIN_ID, 
                S.STOCK_CODE, 
                S.BARCOD, 
                S.PRODUCT_NAME
            ) AS TBL1
		ORDER BY 
        	DELIVER_PAPER_NO, 
            PRODUCT_NAME
	</cfquery>
    <cfset arama_yapilmali = 1> 
<cfelse>
    <cfset arama_yapilmali = 0>   
</cfif>    
<cfform name="search_product" method="post" action="#request.self#?fuseaction=sales.popup_list_PRTOTM_packing">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
    <cf_big_list_search title="Paket Listesi" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td></td>
                    <td>
                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.popup_add_PRTOTM_list_packing"><img src="/images/kasa.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></td>
                    <td width="20">
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button search_function='input_control()'><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>

    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px">S.No</th>
                <th style="text-align:center; width:200px">Üye Adı</th>
                <th style="text-align:center; width:70px">Sevk No</th>
                <th style="text-align:center; width:70px">Paket Tarihi</th>
                <th style="text-align:center; width:100px">Paketleyen</th>
                <th style="text-align:center; width:60px">Paket No</th>
                <th style="text-align:center; width:90px">Stok Kodu</th>
                <th style="text-align:center;">Ürün Adı</th>
                <th style="text-align:center; width:80px">Paketteki Miktar</th>
                <th style="text-align:center; width:25px">
                	
                </th>
            </tr>
        </thead>
        <tbody>
            <cfif len(attributes.is_form_submitted) and get_packing.recordcount gt 0>
				<cfoutput query="get_packing">
                	<tr>
                        <td style="text-align:right;" nowrap="nowrap">#currentrow#</td>
                        <td style="text-align:left;" nowrap="nowrap">#unvan#</td>
                        <td style="text-align:center;" nowrap="nowrap">#DELIVER_PAPER_NO#</td>
                        <td style="text-align:center;" nowrap="nowrap">#DateFormat(RECORD_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:left;" nowrap="nowrap">#get_emp_info(RECORD_EMP,0,0)# </td>
                        <td style="text-align:center;" nowrap="nowrap">#PACKING_NO#</td>
                        <td style="text-align:center;" nowrap="nowrap">#STOCK_CODE#</td>
                        <td style="text-align:left;" nowrap="nowrap">#PRODUCT_NAME#</td>
                        <td style="text-align:right;" nowrap="nowrap">#TlFormat(PAKET_AMOUNT,0)# Ad.</td>
                        <td style="text-align:center;" nowrap="nowrap"> <!---<cfif PRINT_COUNT gt 0>bgcolor="orange"</cfif>>
                        	<cfset action_ids = '1-#SHIP_RESULT_ID#-#PACKING_ID#'>
                        	<a  href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=32&action_id=#action_ids#','page');">
                          		<img src="/images/print2.gif" title="Yazdır">
                         	</a>--->
                        </td>
					</tr>
              	</cfoutput>
                <tfoot>
                    <tr>
                        <td colspan="12" height="22" style="text-align:right">
                       
                        </td>
                    </tr>
                </tfoot>
            <cfelse>
                <tr> 
                    <td colspan="12" height="20"><cfif arama_yapilmali eq 0><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>
<script language="javascript">
	function input_control()
	{
		return true;
	}
</script>