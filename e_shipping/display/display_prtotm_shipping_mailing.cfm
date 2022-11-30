<cfset zeki_mail = 'zekianil@gmail.com'>
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            COMPANY_ID, 
          	EMPLOYEE_ID, 
         	CONSUMER_ID,
            PARTNER_ID,
         	ISNULL((
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
         	FROM          
            	PRTOTM_SHIPPING_PACKAGE_LIST_REPEAT
         	WHERE      
            	TYPE = 1 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
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
                SHIP_RESULT_ID,
                COMPANY_ID, 
               	EMPLOYEE_ID, 
             	CONSUMER_ID,
                PARTNER_ID
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
                    ESRR.ORDER_ROW_ID,
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID,
                    O.PARTNER_ID
                FROM          
                    PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                  	PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                  	ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                  	PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                  	STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                  	ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
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
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID,
                    O.PARTNER_ID
             	) AS TBL1
          	GROUP BY
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                COMPANY_ID, 
               	EMPLOYEE_ID, 
             	CONSUMER_ID,
                PARTNER_ID
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
            COMPANY_ID, 
         	EMPLOYEE_ID, 
         	CONSUMER_ID, 
         	PARTNER_ID,
            ISNULL((
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
           	FROM          
            	PRTOTM_SHIPPING_PACKAGE_LIST_REPEAT
        	WHERE      
            	TYPE = 2 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
          	),0) AS CONTROL_AMOUNT, SHIP_RESULT_ID
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
               	COMPANY_ID, 
              	EMPLOYEE_ID, 
             	CONSUMER_ID, 
              	PARTNER_ID
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
                    SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID,
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID, 
                    O.PARTNER_ID
         		FROM          
                   	ORDERS AS O INNER JOIN
                 	ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID RIGHT OUTER JOIN
                 	STOCKS AS S INNER JOIN
                 	PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                	#dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                	#dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID ON 
                  	ORR.ORDER_ROW_ID = SIR.ROW_ORDER_ID
           		WHERE      
                	SI.DISPATCH_SHIP_ID = #attributes.ship_id#
             	GROUP BY 
                	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID,
                    O.COMPANY_ID, 
                    O.EMPLOYEE_ID, 
                    O.CONSUMER_ID, 
                    O.PARTNER_ID
           		) AS TBL1
         	GROUP BY 
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID,
                COMPANY_ID, 
              	EMPLOYEE_ID, 
             	CONSUMER_ID, 
              	PARTNER_ID
       		) AS TBL
    </cfquery>
</cfif>
<cfif attributes.is_type eq 1>
	<cfquery name="get_order_info" datasource="#dsn3#">
        SELECT     
            O.ORDER_NUMBER, 
            O.ORDER_DATE, 
            O.ORDER_ID,
            O.ORDER_EMPLOYEE_ID,
            O.SHIP_ADDRESS
        FROM         
            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
            PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
            ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
            ORDERS AS O ON ORR.ORDER_ID = O.ORDER_ID
        WHERE    
            ESR.SHIP_RESULT_ID = #attributes.ship_id#
        GROUP BY 
            O.ORDER_NUMBER, 
            O.ORDER_DATE, 
            O.ORDER_ID,
            O.ORDER_EMPLOYEE_ID,
            O.SHIP_ADDRESS
  	</cfquery>
<cfelse>
	<cfquery name="get_order_info" datasource="#dsn3#">
        SELECT     
            O.ORDER_ID, 
            O.ORDER_NUMBER, 
            O.ORDER_DATE, 
            O.ORDER_EMPLOYEE_ID,
            O.SHIP_ADDRESS
        FROM         
            ORDERS AS O INNER JOIN
            ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID RIGHT OUTER JOIN
            #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
            #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON 
            ORR.ORDER_ROW_ID = SIR.ROW_ORDER_ID
        WHERE     
            SI.DISPATCH_SHIP_ID = #attributes.ship_id#
        GROUP BY 
            O.ORDER_ID, 
            O.ORDER_NUMBER, 
            O.ORDER_DATE, 
            O.ORDER_EMPLOYEE_ID,
            O.SHIP_ADDRESS
   	</cfquery>
</cfif>
<cfif len(get_order_info.order_employee_id)>
	<cfquery name="get_emp_mail_info" datasource="#dsn#">
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_order_info.order_employee_id#
	</cfquery>
<cfelse>
	<cfset get_emp_mail_info.EMPLOYEE_EMAIL = ''>
</cfif>
<cfquery name="get_member_group" dbtype="query">
	SELECT
    	COMPANY_ID, 
      	EMPLOYEE_ID, 
       	CONSUMER_ID, 
      	PARTNER_ID
   	FROM
    	GET_SHIP_PACKAGE_LIST
    GROUP BY
    	COMPANY_ID, 
      	EMPLOYEE_ID, 
       	CONSUMER_ID, 
      	PARTNER_ID
</cfquery>
<cfif len(get_member_group.CONSUMER_ID)>
    <cfquery name="GET_CONS_INFO" datasource="#dsn#">
        SELECT 
            CONSUMER_NAME+ '' +CONSUMER_SURNAME as UNVAN, 
            CONSUMER_EMAIL AS EMAIL, 
            CONSUMER_HOMETELCODE AS TELCODE, 
            CONSUMER_HOMETEL AS TEL, 
            MOBIL_CODE, 
            MOBILTEL,
            TAX_ADRESS
        FROM 
            CONSUMER 
        WHERE 
            CONSUMER_ID = #get_member_group.CONSUMER_ID#
    </cfquery>
<cfelseif len(get_member_group.COMPANY_ID)>
	<cfquery name="GET_CONS_INFO" datasource="#dsn#">
		SELECT     
        	FULLNAME AS UNVAN, 
            COMPANY_TELCODE AS TELCODE, 
            COMPANY_TEL1 AS TEL, 
            COMPANY_EMAIL AS EMAIL, 
            MOBIL_CODE, 
            MOBILTEL,
            COMPANY_ADDRESS AS TAX_ADRESS
		FROM         
         	COMPANY
		WHERE     
        	COMPANY_ID = #get_member_group.COMPANY_ID#
	</cfquery>
</cfif>
<cfset email_list = ''>
<cfif len(get_cons_info.email) or len(get_emp_mail_info.EMPLOYEE_EMAIL)> 
	<cfif len(get_cons_info.email)>
		<cfset email_list = get_cons_info.email>
   	</cfif>
   	<cfif len(get_emp_mail_info.EMPLOYEE_EMAIL)>
    	<cfset email_list = '#email_list#,#get_emp_mail_info.EMPLOYEE_EMAIL#'>
    </cfif>
</cfif>
<cfoutput>
<cfif len(email_list)> 
    <cfmail from="info@caginburo.com (Caginburo.com)" to="#email_list#" type="html" subject="Sevkiyat Bilgileri">
        <table style="display: inline-table;font-family:Calibri;font-size:10pt;text-align:center;border:1px solid ##d1d1d1;border-radius:3px;-khtml-border-radius:3px;-webkit-border-radius:3px;-moz-border-radius:3px;" border="0" cellpadding="0" cellspacing="0" width="595">
            <tr>
                <td>
                    <table style="display: inline-table;" align="left" border="0" cellpadding="0" cellspacing="0" width="595">
                        <tr>
                            <td>
                                <a href="http://www.caginofis.com" target="_blank"><img name="caginofiscomlogo" src="http://www.caginofis.com/images/mail/caginofiscomlogo.jpg" width="407" height="108" border="0" id="caginofiscomlogo" alt="Çağın Ofis Mobilyalarında Makam Takımları, Çalışma Masaları, Bankolar, Toplantı Masaları, Makam Koltukları, Çalışma Koltukları, Ofis Kanepeleri, Masalar, Sandalyeler, Dolaplar, Sehpalar ve Ofis Mobilya aksesuarları bulunuyor." />
                                </a>
                            </td>
                            <td>
                                <table style="display: inline-table;" align="left" border="0" cellpadding="0" cellspacing="0" width="188">
                                    <tr>
                                        <td style="width:188;height:82;"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="display: inline-table;" align="left" border="0" cellpadding="0" cellspacing="0" width="188">
                                                <tr>
                                                    <td>
                                                        <img name="bosluk" src="http://www.caginofis.com/images/mail/bosluk.jpg" width="48" height="26" border="0" id="bosluk" alt="" />
                                                    </td>
                                                    <td>
                                                        <a href="http://www.facebook.com/caginofismobilyalari" target="_blank"><img name="facebook" src="http://www.caginofis.com/images/mail/facebook.jpg" width="23" height="26" border="0" id="facebook" alt="Facebook" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="http://www.twitter.com/CaginOfis" target="_blank"><img name="twitter" src="http://www.caginofis.com/images/mail/twitter.jpg" width="22" height="26" border="0" id="twitter" alt="Twitter" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="http://www.youtube.com/caginburo" target="_blank"><img name="youtube" src="http://www.caginofis.com/images/mail/youtube.jpg" width="22" height="26" border="0" id="youtube" alt="Youtube" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="http://www.pinterest.com/caginofis" target="_blank"><img name="pinterest" src="http://www.caginofis.com/images/mail/pinterest.jpg" width="22" height="26" border="0" id="pinterest" alt="Pinterest" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="http://instagram.com/caginofismobilyalari/" target="_blank"><img name="instragram" src="http://www.caginofis.com/images/mail/instagram.jpg" width="22" height="26" border="0" id="instagram" alt="Instagram" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a href="http://plus.google.com/u/0/+Caginburomobilya" target="_blank"><img name="googleplus" src="http://www.caginofis.com/images/mail/googleplus.jpg" width="29" height="26" border="0" id="googleplus" alt="Google Plus" />
                                                        </a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <hr style="border:1px ##CCCCCC solid;"></hr>
            <tr>
                <td style="text-align:left;padding:20px 30px;">
                    <p>Sayın <strong><cfoutput>#get_cons_info.UNVAN#</cfoutput></strong>,</p>
                    <p>#dATEfORMAT(get_order_info.ORDER_DATE,'dd/mm/yyyy')# vermiş olduğunuz sipariş; hazırlanmış,</p>
                    <p>sevkiyat kontrolü yapılmış ve araçla tarafınıza teslim edilmek üzere gönderilmiştir.</p>
                    <p><strong style="font-size:15px"></strong></p>
                    <table style="border-collapse:collapse;width:100%;border-top:1px solid ##dddddd;border-left:1px solid ##dddddd;margin-bottom:20px">
                        <thead>
                            <tr>
                                <td style="font-size:12px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:left;padding:7px;color:##222222" colspan="2">Sipariş Detayları</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="font-size:12px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:left;padding:7px">
                                    <b>Sipariş Numarası:</b> #get_order_info.order_number#<br>
                                    <b>Sipariş Tarihi:</b> #DateFormat(get_order_info.ORDER_DATE,'DD/MM/YYYY')#<br>
                                </td>
                                <td style="font-size:12px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:left;padding:7px">
                                    <b>E-Posta:</b> <a href="#get_cons_info.email#" target="_blank">#get_cons_info.email#</a><br>
                                    <b>Telefon:</b> #get_cons_info.TELCODE# #get_cons_info.TEL# - #get_cons_info.mobil_code# #get_cons_info.mobiltel# <br>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <table style="border-collapse:collapse;width:100%;border-top:1px solid ##dddddd;border-left:1px solid ##dddddd;margin-bottom:20px;font-size:9pt;">
                        <thead>
                            <tr>
                                <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:left;padding:7px;color:##222222;width:50%;height:30px;">
                                    Ürün
                                </td>
                                <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:center;padding:7px;color:##222222;width:10%;">
                                    Sipariş
                                </td>
                                <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:center;padding:7px;color:##222222;width:10%;">
                                    Teslim
                                </td>
                                <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:center;padding:7px;color:##222222;width:10%;">
                                    Kalan
                                </td>
                            </tr>
                        </thead>
                        <cfset netTotal_ =0>
                        <cfloop query="GET_SHIP_PACKAGE_LIST">
                            <tbody>
                                <tr>
                                    <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:left;padding:7px">#product_name#</td>
                                    <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:center;padding:7px">#PAKETSAYISI#</td>
                                    <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:center;padding:7px">#control_amount#</td>
                                    <td style="border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:center;padding:7px">#PAKETSAYISI-control_amount#</td>
                                </tr>
                            </tbody>
                        </cfloop>
        
                    </table>
                    <br>
                    <table style="border-collapse:collapse;width:100%;border-top:1px solid ##dddddd;border-left:1px solid ##dddddd;margin-bottom:20px">
                        <tr>
                            <td style="font-size:12px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:left;padding:7px;color:##222222">
                                Fatura Adresi
                            </td>
                            <td style="font-size:12px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;background-color:##efefef;font-weight:bold;text-align:left;padding:7px;color:##222222" width="50%">
                                Sevk Adresi
                            </td>
                        </tr>
                        <tbody>
                            <tr>
                                <td style="font-size:10px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:left;padding:7px">
                                    <cfif isdefined('get_cons_info') and get_cons_info.recordcount>
                                        <b>#get_cons_info.UNVAN#</b>
                                    </cfif>
                                    <p>#GET_CONS_INFO.TAX_ADRESS#</p>
                                </td>
                                <td style="font-size:10px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:left;padding:7px">
                                    <cfif isdefined('get_cons_info') and get_cons_info.recordcount>
                                        <b>#get_cons_info.UNVAN#</b>
                                    </cfif>
                                    <p>#get_order_info.SHIP_ADDRESS#</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <table>
                        <td style="text-align: left;width: 100%;">
                            <p>Bizi tercih ettiğiniz için teşekkür ederiz.</p>
                            <p> </p>
                            <p>Saygılarımızla,</p>
                            <p><a href="http://www.caginofis.com" target="_blank">www.caginofis.com</a></p>
                        </td>
                    </table>
                </td>
            </tr>
        </table> 
    </cfmail>
  	<table style="display: inline-table;font-family:Calibri;font-size:10pt;text-align:center;border:1px solid ##d1d1d1;border-radius:3px;-khtml-border-radius:3px;-webkit-border-radius:3px;-moz-border-radius:3px;" border="0" cellpadding="0" cellspacing="0" width="595">
      	<tr>
         	<td style="font-size:24px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:center; vertical-align:middle;padding:7px">Mail Başarıyla Gönderilmiştir</td>
      	</tr>
        <tr>
        	<td style="vertical-align:bottom"><input type="button" value="Kapat" onClick="kapat()"></td>
        </tr>
  	</table>
<cfelse>
	<table style="display: inline-table;font-family:Calibri;font-size:10pt;text-align:center;border:1px solid ##d1d1d1;border-radius:3px;-khtml-border-radius:3px;-webkit-border-radius:3px;-moz-border-radius:3px;" border="0" cellpadding="0" cellspacing="0" width="595">
      	<tr>
         	<td style="font-size:18px;border-right:1px solid ##dddddd;border-bottom:1px solid ##dddddd;text-align:center; vertical-align:middle;padding:7px">Mevcut Mail Adresi Bulunamadığından Gönderilememiştir.</td>
      	</tr>
        <tr>
        	<td style="vertical-align:bottom"><input type="button" value="Kapat" onClick="kapat()"></td>
        </tr>
  	</table>
</cfif>
</cfoutput>
<script language="javascript">
	function kapat()
	{
		window.close();	
	}
</script>