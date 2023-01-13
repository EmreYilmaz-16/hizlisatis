<cfparam name="attributes.is_excell" default="0">
<cf_report_list>
<cf_report_list_search_area>
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=det&report_id=38" name="order_form">
<input type="hidden" name="is_submit">


<table><tr><td>
<div class="form-group" id="item-product_id">
												
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id">
									<input name="product_name" type="text" id="product_name" placeholder=" Ürün " onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_names&product_id=order_form.product_id&field_name=order_form.product_name&keyword='+encodeURIComponent(document.order_form.product_name.value));"></span>
								</div>
							</div>
						</div></td>
						<td>
						<div class="form-group" id="item-product_id">
						<div class="input-group">
										
											<input type="hidden" name="EMPO_ID" id="EMPO_ID">
											<input type="hidden" name="PARTO_ID" id="PARTO_ID">
											<input type="text" name="PARTNER_NAMEO" placeholder="Satış Çalışanı" id="PARTNER_NAMEO" value="" style="width:140px;" onfocus="AutoComplete_Create('PARTNER_NAMEO','POSITION_NAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,EMPLOYEE_ID','PARTO_ID,EMPO_ID','','3','130');">											
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&field_name=order_form.PARTNER_NAMEO&field_id=order_form.PARTO_ID&field_EMP_id=order_form.EMPO_ID')"></span>
																	
									</div></div>
						</td>
                        <td>
                        <div class="form-group">
					<div class="input-group">
						<input type="text" name="keyword" id="keyword" placeholder=" Sipariş No " value="" maxlength="50">
					</div>
				</div>
                        </td>

                        <td>
                        <div class="form-group" id="item-currency_id">	
							
							<div class="col col-12">
								<select name="currency_id" id="currency_id">
									<option value=""> Aşama </option>
									<option value="-7"> Eksik Teslimat </option>
									<option value="-8"> Fazla Teslimat </option>
									<option value="-6"> Sevk </option>
									<option value="-5"> Üretim </option>
									<option value="-4"> Kısmi Üretim </option>
									<option value="-3"> Kapatıldı </option>
									<option value="-2"> Tedarik </option>
									<option value="-1"> Açık </option>
									<option value="-9"> İptal </option>
									<option value="-10"> Kapatıldı(Manuel) </option>
								</select>          
							</div>
						</div>
                        </td>
                        <td><div class="form-group">
					<div class="input-group">
						<select name="status" id="status">
							<option value=""> Tümü </option>
							<option value="0"> Pasif </option>
							<option value="1" selected=""> Aktif </option>
						</select>
					</div>
				</div></td>
				<td>
					<div class="form-group">
						<input type="checkbox" value="1" name="is_excell">
						<label>Excel ?</label>
					</div>
				</td>
                        <td><input type="submit"></td>
                        </tr></table>
                        
                        
</cfform>
</cf_report_list_search_area>
<cfif isDefined("attributes.is_submit")>
<cfquery name="get_reserv" datasource="#dsn3#">
SELECT DISTINCT TOP 1000  (ISNULL(RSO, 0) - ISNULL(SO, 0)) SOR
	,(ISNULL(RSI, 0) - ISNULL(SI, 0)) AS SIR
	,TBL.ORDER_ID
	,TBL.STOCK_ID
	,O.ORDER_DATE
    ,O.ORDER_STATUS
	,O.ORDER_NUMBER
	,O.ORDER_EMPLOYEE_ID
	,S.STOCK_CODE
	,S.PRODUCT_NAME
	,TBL.ORDER_WRK_ROW_ID	
	,ORR.ORDER_ROW_CURRENCY,
	case 
		WHEN ORR.ORDER_ROW_CURRENCY =-1 THEN 'AÇIK'
		WHEN ORR.ORDER_ROW_CURRENCY =-2 THEN 'TEDARIK'
		WHEN ORR.ORDER_ROW_CURRENCY =-3 THEN 'KAPATILDI'
		WHEN ORR.ORDER_ROW_CURRENCY =-4 THEN 'KISMİ ÜRETİM'
		WHEN ORR.ORDER_ROW_CURRENCY =-5 THEN 'ÜRETİM'
		WHEN ORR.ORDER_ROW_CURRENCY =-6 THEN 'SEVK'
		WHEN ORR.ORDER_ROW_CURRENCY =-7 THEN 'EKSİK TESLİMAT'
		WHEN ORR.ORDER_ROW_CURRENCY =-8 THEN 'FAZLA TESLİMAT'
		WHEN ORR.ORDER_ROW_CURRENCY =-9 THEN 'iPTAL'
		WHEN ORR.ORDER_ROW_CURRENCY =-10 THEN 'MANUEL KAPATILDI'
		END AS DURUM
FROM (
	SELECT SUM(RESERVE_STOCK_IN) AS RSI
		,SUM(RESERVE_STOCK_OUT) AS RSO
		,SUM(STOCK_IN) AS SI
		,SUM(STOCK_OUT) AS SO
		,ORDER_ID
		,STOCK_ID		
		,ORDER_WRK_ROW_ID
	FROM #dsn3#.ORDER_ROW_RESERVED
	--WHERE ORDER_ID = 9
	GROUP BY ORDER_ID
		,STOCK_ID
		,ORDER_WRK_ROW_ID
	) AS TBL
LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID = TBL.ORDER_ID
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID = TBL.STOCK_ID
LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.WRK_ROW_ID=TBL.ORDER_WRK_ROW_ID
WHERE 1 = 1
	AND (
		(ISNULL(RSO, 0) - ISNULL(SO, 0)) > 0
		OR (ISNULL(RSI, 0) - ISNULL(SI, 0)) > 0
		)
    <cfif isDefined("attributes.product_id") and len(attributes.product_id)>
		and S.STOCK_ID IN (SELECT STOCK_ID FROM #DSN1#.STOCKS WHERE PRODUCT_ID=#attributes.product_id#)
	</cfif>
    <cfif len(attributes.keyword)>
        AND TBL.ORDER_NUMBER LIKE '%#attributes.keyword#%'
    </cfif>
    <cfif len(attributes.currency_id)>
		AND ORR.ORDER_ROW_CURRENCY=#attributes.currency_id#
    </cfif>
    <cfif len(attributes.status)>
    AND ORDER_STATUS=#attributes.status#
    </cfif>
	   <cfif len(attributes.PARTNER_NAMEO)>
    AND ORDER_EMPLOYEE_ID=#attributes.EMPO_ID#
    </cfif>
		--+AND ORR.ORDER_ROW_CURRENCY=-10		
		--AND O.ORDER_ID=215808
	--	AND TBL.ORDER_ID IS NULL
		ORDER BY ORDER_DATE
</cfquery>
<cfif attributes.is_excell eq 1>
	<cfscript>
		theSheet=spreadsheetNew("the sheet");
		satir =1;
		sutun=1;
		spreadsheetAddRow(theSheet,"SNo.,Stok Kodu,Ürün Adı,Sipariş No,Sipariş Tarihi,S.Çalışanı,Aşama,Rezerve Stok Çıkış,Rezerve Stok Giriş",satir);
		satir=satir+1;
	</cfscript>
</cfif>
<div id="ListContent">
<cf_grid_list>
<thead>
<tr>
<th></th>
<th>Stok Kodu</th>
<th>Ürün Adı</th>
<th>Sipariş No</th>
<th>Sipariş Tarihi</th>
<th>S.Çalışanı</th>
<th>Aşama</th>
<th>Reserve Stok Çıkış</th>
<th>Reserve Stok Giriş</th>
<th></th>
</tr>
</thead>
<tbody>

<cfoutput query="get_reserv">
<tr>
    <td>#currentrow#</td>
    <td><a onclick="windowopen('index.cfm?fuseaction=objects.popup_detail_product&sid=#STOCK_ID#','page')">#STOCK_CODE#</a></td>
    <td>#PRODUCT_NAME#</td>
    <td><a href="index.cfm?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#" target="_blank" >#ORDER_NUMBER#</a></td>
    <td>#dateformat(ORDER_DATE,"dd/mm/yyyy")#</td>
	<td>#getEmpInfo(ORDER_EMPLOYEE_ID)#</td>
    <td>#ORDER_ROW_CURRENCY#-#DURUM#</td>
    <td>#SOR#</td>
    <td>#SIR#</td>
    <td><!----<a href="index.cfm?fuseaction=#attributes.fuseaction#&event=2&wrk_row_id=#ORDER_WRK_ROW_ID#&order_id=#ORDER_ID#&stock_id=#STOCK_ID#&OCURRENCY=#ORDER_ROW_CURRENCY#" target="_blank">Sil</a> ---->
    <a  class="ui-ripple-btn" onclick="silSatir(this,'#ORDER_WRK_ROW_ID#',#ORDER_ID#,#STOCK_ID#,#ORDER_ROW_CURRENCY#)">Sil</a></td>
	<cfif attributes.is_excell eq 1>
		<cfscript>
			spreadsheetAddRow(theSheet,"#currentrow#,#STOCK_CODE#,#PRODUCT_NAME#,#ORDER_NUMBER#,#ORDER_DATE#,#getEmpInfo(ORDER_EMPLOYEE_ID)#,#DURUM#,#SOR#,#SIR#",satir);
			satir=satir+1;
		</cfscript>
	</cfif>
</tr>
</cfoutput>
</tbody>
</cf_grid_list>
</div>
<cfif attributes.is_excell eq 1>
	<cfset file_name = "RezerveStoklar#dateformat(now(),'ddmmyyyy')#.xls">
    <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
    <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
    </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" name="theSheet" sheetname="Rezerve Stoklar" overwrite=true>
    <script type="text/javascript">
        <cfoutput>
            get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
        </cfoutput>
    </script>
</cfif>
</cfif>


<script>
var pppp;
    function silSatir(elem,wrk_row,order,stock,orc){
             $.ajax({
            url: "/index.cfm?fuseaction=objects.remove_reserved_partner&event=2&wrk_row_id="+wrk_row+"&order_id="+order+"&stock_id="+stock+"&OCURRENCY="+orc,
            success: function (retData) {              
              pppp=elem; 
              pppp.parentElement.parentElement.remove()
               /*$("#tbl_kumas").html(axxxx)*/
               // $("#mdl_11").html(retData)
                 //myModal.show()
            }

        });
           
    }
</script>
</cf_report_list>
<cffunction  name="getEmpInfo">
	<cfargument  name="employee_id" default="0">
	<cfquery name="gete" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=#ARGUMENTS.employee_id#
	</cfquery>
	<cfreturn "#gete.EMPLOYEE_NAME# #gete.EMPLOYEE_SURNAME#">
</cffunction>