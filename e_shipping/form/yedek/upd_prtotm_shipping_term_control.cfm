<cfsetting showdebugoutput="yes">
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_RF_TO_SV_DEP, 
        DEFAULT_RF_TO_SV_LOC
	FROM            
    	PRTOTM_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif not get_default_departments.recordcount>
	<cfset type = 0>
<cfelse>
	<cfset type = 1>
</cfif>
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
                    CASE 
                        WHEN 
                            S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                        THEN 
                            S.PRODUCT_TREE_AMOUNT 
                        ELSE 
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3)
                    END 
                        AS PAKET_SAYISI, 
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
                    ESR.SHIP_RESULT_ID = #attributes.ship_id#
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
                	CASE 
                    	WHEN 
                        	S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                      	THEN 
                        	S.PRODUCT_TREE_AMOUNT 
                      	ELSE 
                        	round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),3)
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
		<td class="dpht">Paket Kontrol Listesi</td>
        <td style="text-align:right"><strong>Son Okutma Tarih ve Saati : </strong>
        <cfif get_record_date.recordcount and len(get_record_date.RECORD_DATE)>
			<cfoutput>#get_emp_info(get_record_date.RECORD_EMP,0,0)# - #Dateformat(get_record_date.RECORD_DATE,'DD/MM/YYYY')# #timeformat(dateadd('h',session.ep.time_zone,get_record_date.RECORD_DATE),'HH:MM')#</cfoutput>
       	<cfelse>
        	
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
                        <th width="45px">Barkod</th>
                        <th width="70px">Kod</th>
                        <th>Ürün</th>
                        <th width="40px">Miktar</th>
                        <th width="40px">Kontrol</th>
                        <th width="20px">OK</th>
                    </tr>
    			</thead>
                <tbody>
					<cfoutput query="GET_SHIP_PACKAGE_LIST">
                        <tr height="20">
                                <td>#BARCOD#</td>
                                <td>#STOCK_CODE#</td>
                                <td>#product_name#</td>
                                <td style="text-align:right"><strong>#Tlformat(PAKETSAYISI,3)#</strong></td>
                                 <input type="hidden" name="kalan_amount" id="kalan_amount_#currentrow#" value="#Tlformat(PAKETSAYISI,3)#"/>
                                <td style="text-align:right">
                                	<cfif type eq 1>
                                        <input name="control_amount" id="control_amount_#currentrow#" value="#Tlformat(0,3)#" style="text-align:right; width:50px" readonly="readonly" class="box"/>
                                    <cfelse>
                                        <strong>#Tlformat(CONTROL_AMOUNT,3)#</strong>
                                    </cfif>
                                </td>
                                <td style="text-align:center">
                                	<cfif control_amount eq 0>
                                        <cfif type eq 1>
                                            <a href="javascript://" class="tableyazi" onclick="gonder(#currentrow#);">
                                               <img src="images\closethin.gif" title="Okuma Yapılmadı">
                                            </a>
                                        <cfelse>
                                            <img src="images\closethin.gif" title="Okuma Yapılmadı">
                                        </cfif>
                                    <cfelseif paketsayisi eq control_amount>
                                    	<img src="images\c_ok.gif" title="Hepsi Okundu">
                                    <cfelseif paketsayisi gt control_amount>
                                        <cfif type eq 1>
                                            <a href="javascript://" class="tableyazi" onclick="gonder(#currentrow#);">
                                                <img src="images\warning.gif" title="Eksik Okuma">
                                            </a>
                                        <cfelse>
                                            <img src="images\warning.gif" title="Eksik Okuma">
                                        </cfif>
                               		</cfif>
                                </td>
                        </tr>
                    </cfoutput>
            	</tbody>
                <tfoot>
                    <tr class="color-list">
                        <td colspan="6" style="text-align:right">
                        	<cfif type eq 1>
                            	<input type="button" value="Kapat" onClick="kontrol(0);">&nbsp;
                        		<input type="button" value="Sevk Kontrol Oluştur" name="ambar_fisi" id="ambar_fisi" onClick="kontrol(1);" style="width:140px;">
                            <cfelse>
                            	<input type="button" value="Kapat" onClick="kontrol(0);">
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
    <input type="hidden" name="ref_no" id="ref_no" value="<cfoutput>#GET_SHIP_PACKAGE_LIST.DELIVER_PAPER_NO#</cfoutput>" />
    <input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>" />
</form>
<script language="javascript">
	function gonder(rowi)
	{
		<cfoutput query="GET_SHIP_PACKAGE_LIST">
			rowa = #currentrow#;
			if(rowi == rowa)
			{
				document.getElementById("control_amount_"+rowi).value =  document.getElementById("kalan_amount_"+rowi).value;
			}
		</cfoutput>
	}
	function kontrol(type)
	{
		if(type==0)
		window.close();
		if(type==1)
		{
			var convert_list ="";
			var convert_list_amount ="";
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
				if(filterNum(document.getElementById('control_amount_#currentrow#').value) > 0)
				{
					stock_id = #stock_id#;
					convert_list += stock_id+',';
					convert_list_amount += filterNum(document.getElementById('control_amount_#currentrow#').value)+',';
				}
			</cfoutput>
			document.getElementById('convert_stocks_id').value=convert_list;
			document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			if(convert_list)//Ürün Seçili ise
			{
				 windowopen('','wide','cc_paym');
				 if(type==1)
				 {
					 aktar_form.action="<cfoutput>#request.self#?fuseaction=eshipping.emptypopup_add_prtotm_shipping_control_fis&is_type=#attributes.is_type#&kontrol_status=2</cfoutput>";
					 document.getElementById('ambar_fisi').disabled=true;
				 }
				 aktar_form.target='cc_paym';
				 aktar_form.submit();
			 }
			 else
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
		}
	}
</script>