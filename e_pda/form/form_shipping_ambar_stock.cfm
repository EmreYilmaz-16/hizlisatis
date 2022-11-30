<cfset default_process_type = 113> <!---Dikkat Firmaya Göre Değişebilir--->
<cfparam name="attributes.department_in_id" default="">
<cfparam name="attributes.department_out_id" default="">
<cfquery name="get_process_cat" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_process_type# AND 
        SPCF.FUSE_NAME = 'pda.form_shipping_ambar_stock' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat.recordcount>
	<script type="text/javascript">
		alert("İşlem Kategorisi Tanımlayınız!");
		history.back();	
	</script>
</cfif>
<cfquery name="get_stock_info" datasource="#dsn3#">
	SELECT        
    	SB.STOCK_ID, 
        SB.BARCODE, 
        S.PRODUCT_NAME, 
        S.STOCK_CODE, 
        S.STOCK_CODE_2
	FROM            
    	STOCKS_BARCODES AS SB INNER JOIN
       	STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID
	WHERE        
    	SB.STOCK_ID = #f_stock_id#
</cfquery>
<cfquery name="get_store_type" datasource="#dsn3#">
	SELECT        
    	COUNT(*) AS RAF
	FROM            
    	PRODUCT_PLACE
	WHERE        
    	LOCATION_ID = #ListGetAt(attributes.department_out_id,2,"-")#  AND 
        STORE_ID = #ListGetAt(attributes.department_in_id,1,"-")# AND 
        PLACE_STATUS = 1
</cfquery>
<cfif get_store_type.raf gt 0>
    <cfquery name="get_ambar_fis" datasource="#dsn2#">
        SELECT        
            SUM(SFR.AMOUNT) AS AMOUNT, 
            PP.SHELF_CODE, 
            S.STOCK_CODE, 
            S.PRODUCT_ID, 
            S.PROPERTY, 
            S.BARCOD, 
            S.PRODUCT_NAME,
            SFR.STOCK_ID
        FROM            
            STOCK_FIS AS SF INNER JOIN
            STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID INNER JOIN
            #dsn3_alias#.PRODUCT_PLACE AS PP ON SFR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID INNER JOIN
            #dsn3_alias#.STOCKS AS S ON SFR.STOCK_ID = S.STOCK_ID
        WHERE        
            SF.REF_NO = '#attributes.deliver_paper_no#' AND 
            SFR.STOCK_ID = #f_stock_id#
        GROUP BY 
            PP.SHELF_CODE, 
            S.STOCK_CODE, 
            S.PRODUCT_ID, 
            S.PROPERTY, 
            S.BARCOD, 
            S.PRODUCT_NAME,
            SFR.STOCK_ID
    </cfquery>
    <cfquery name="get_shelf_stock" datasource="#dsn2#">
        SELECT        
            PP.SHELF_CODE, 
            PPR.AMOUNT, 
            PP.PRODUCT_PLACE_ID, 
            ISNULL((
                    SELECT        
                        REAL_STOCK
                    FROM            
                        GET_STOCK_LAST_SHELF
                    WHERE        
                        SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND 
                        STOCK_ID = PPR.STOCK_ID
            ), 0) AS REAL_STOCK
        FROM            
            #dsn3_alias#.PRODUCT_PLACE AS PP LEFT OUTER JOIN
            #dsn3_alias#.PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
        WHERE        
            PPR.STOCK_ID = #f_stock_id#
        ORDER BY
            REAL_STOCK DESC
    </cfquery>
<cfelse>

	<cfquery name="get_ambar_fis" datasource="#dsn2#">
		SELECT        
        	SUM(SFR.AMOUNT) AS AMOUNT, 
            S.STOCK_CODE, 
            S.PRODUCT_ID, 
            S.PROPERTY, 
            S.BARCOD, 
            S.PRODUCT_NAME, 
            SFR.STOCK_ID
		FROM            
        	STOCK_FIS AS SF INNER JOIN
         	STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID INNER JOIN
          	#dsn3_alias#.STOCKS AS S ON SFR.STOCK_ID = S.STOCK_ID
		WHERE 
        	SF.REF_NO = '#attributes.deliver_paper_no#' AND 
            SFR.STOCK_ID = #f_stock_id# AND 
            SF.DEPARTMENT_OUT = #ListGetAt(attributes.department_out_id,1,"-")#  AND 
            SF.LOCATION_OUT = #ListGetAt(attributes.department_out_id,2,"-")# 
		GROUP BY 
        	S.STOCK_CODE, 
            S.PRODUCT_ID, 
            S.PROPERTY, 
            S.BARCOD, 
            S.PRODUCT_NAME, 
            SFR.STOCK_ID
   	</cfquery>
    <cfquery name="get_depo_stok" datasource="#dsn2#">
    	SELECT 
        	PRODUCT_STOCK 
       	FROM 
        	PRTOTM_GET_STOCK_LOCATION_TOTAL 
       	WHERE  
        	DEPO = '#attributes.department_out_id#' AND 
            STOCK_ID =#f_stock_id#
    </cfquery>
    
</cfif>
<cfquery name="get_ambar_fis_group" datasource="#dsn2#">
		SELECT        
        	SUM(SFR.AMOUNT) AS AMOUNT
		FROM            
        	STOCK_FIS AS SF INNER JOIN
         	STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
		WHERE 
        	SF.REF_NO = '#attributes.deliver_paper_no#' AND 
            SFR.STOCK_ID = #f_stock_id#
</cfquery>
<cfif get_ambar_fis_group.recordcount>
	<cfset all_amount = get_ambar_fis_group.amount>
<cfelse>
	<cfset all_amount = 0>
</cfif>
<style type="text/css">
.boxtext {
	text-decoration: none;
	background-color: #e6e6fe;
	margin: 0px;
	padding: 0px;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
}
.tablo {
	text-decoration: none;
	margin: 0px;
	padding: 0px;
	border-top-width: 1px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-color: aec7f0;
	border-right-color: aec7f0;
	border-bottom-color: aec7f0;
	border-left-color: aec7f0;
}
table,td,th,div{
    font-size:13px;
		font-weight: 600;
}
.form-title{
    font-size:13px;
}
input{
	  font-size:13px !important;
}
</style>
<script language="javascript" type="text/javascript">
  var row_count = <cfoutput>#get_ambar_fis.recordcount#</cfoutput>;
  var barcod = '';
  var stockid = '';
  var spectmainid = '';
  var stockcode = '';
  var amount = '';
  var ekle = 0;
  var cikar = 0;
  var islemtipi = 0;//0-ekle 1-çıkar
  var buton = 0;// <1-buton pasif, >0-buton aktif
</script>

<cfform name="form_basket">
  <cfinput id="txt_department_out" name="txt_department_out" type="hidden" value="#attributes.department_out_id#">
  <cfinput id="txt_department_in" name="txt_department_in" type="hidden" value="#attributes.department_in_id#">
  <cfinput id="process_cat_id" type="hidden" name="process_cat_id" value="#get_process_cat.process_cat_id#">
  <cfinput id="fis_tipi" type="hidden" name="fis_tipi" value="#default_process_type#">
  <div style="width:100%">
  	<table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
	  	    <tr>
  <td colspan="4">
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  
  </td>
  </tr>
    	<tr class="color-list" height="20px">
    		<td colspan="4"><strong><cfoutput>#get_stock_info.product_name#</cfoutput></strong></td>
    	</tr>
    	<tr class="color-list">
      		<td colspan="4">
            	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
          			<tr class="color-list">
            			<td width="45px">Miktar</td>
            			<cfif get_store_type.raf gt 0><td width="75px">Raf</td></cfif>
            			<td width="95px">Barcode</td>
            			<td>Kontrol</td>
       	  			</tr>
          			<tr class="color-list">
            			<td>
                        	<input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:40px; text-align:right" value="" />
                      	</td>
            			<cfif get_store_type.raf gt 0>
            				<td>
                            	<input id="add_other_shelf" name="add_other_shelf" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:75px;" value="" />
                          	</td>
           				</cfif>
            			<td>
                        	<cfinput id="add_other_barcod" name="add_other_barcod" readonly="yes" type="text" value="#get_stock_info.BARCODE#" style="width:110px;" >
                       	</td>
            			<td nowrap="nowrap">
            				<cfinput type="text" value="#all_amount#" name="all_amount" id="all_amount" class="boxtext" style="text-align:right; font-weight:bold; width:30px">/
        					<cfinput type="text" value="#attributes.paket_sayisi#" name="paket_sayisi" id="paket_sayisi" class="boxtext" style="text-align:right;font-weight:bold;width:30px">
            			</td>
          			</tr>
        		</table>
         	</td>
    	</tr>
    	<tr class="color-list">
      		<td width="90" align="center">Barkod</td>
      		<td width="90" align="left">Ürün Adı</td>
      		<td width="40" align="right">Mikt.</td>
      		<cfif get_store_type.raf gt 0>
      			<td align="left">Raf</td>
      		</cfif>
    	</tr>
    	<tr class="color-list">
      		<td align="left" colspan="4">
        		<form name="product_row" id="product_row" method="post">
          			<table name="table1" id="table1" border="0" cellpadding="0" cellspacing="0" width="100%" class="tablo">
          				<cfoutput query="get_ambar_fis">
            				<cfinput type="hidden" value="#stock_id#" name="stockid#currentrow#" id="stockid#currentrow#" />
                			<cfinput type="hidden" value="" name="spectmainid#currentrow#" id="spectmainid#currentrow#" />
          	 				<tr id="row#currentrow#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                				<td><cfinput type="text" value="#barcod#" name="barcod#currentrow#" id="barcod#currentrow#" size="13" class="boxtext" readonly="yes" /></td>
                    			<td><cfinput type="text" value="#PRODUCT_NAME#" name="stockcode#currentrow#" id="stockcode#currentrow#" size="11" class="boxtext" readonly="yes" /></td>
                    			<td><cfinput type="text" value="#amount#" name="amount#currentrow#" id="amount#currentrow#" size="4" class="boxtext" readonly="yes" style="text-align:right" /></td>
                    			<cfif get_store_type.raf gt 0>
                    				<td><cfinput type="text" value="#shelf_code#" name="shelf_code#currentrow#" id="shelf_code#currentrow#" size="8" class="boxtext" readonly="yes" style="text-align:right" /></td>
                    			</cfif>
                			</tr>
           				</cfoutput>
          			</table>
          			<cfinput type="hidden" id="row_count" name="row_count" value="#get_ambar_fis.recordcount#" />
        		</form>
          	</td>
    	</tr>
    	<tr class="color-list">
      		<td colspan="4" valign="middle" align="center">
				<cfif get_store_type.raf gt 0>
                    <select name="shelf_select" style="width:100px; text-align:center">
                        <cfoutput query="get_shelf_stock">
                            <option value="">#SHELF_CODE# - #REAL_STOCK#</option>
                        </cfoutput>
                    </select>
                <cfelse>
                    Depo Miktarı : <cfoutput>#AmountFormat(get_depo_stok.product_stock)#</cfoutput>
                </cfif>
                <input type="hidden" id="department_in" name="department_in" value="" />
                <input type="hidden" id="action_id" name="action_id" value="" />
                <input id="geri" name="geri" value="Vazgeç" type="button" onClick="history.go(-1);" />
                <input id="sil" name="sil" value="Sil" type="button" style="width:30px" onClick="kontrol_sil();" />
                <input id="onay" name="Onay" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="kontrol_kayit();" />
   	  		</td>
    	</tr>
  	</table>
  </div>
</cfform>
<script language="javascript" type="text/javascript">
	document.getElementById('add_other_amount').focus();
	setTimeout("document.getElementById('add_other_amount').select();",1000);	
	function actionidolustur()
	{
	  var j = 0;
	  for(i=1;i<=row_count;i++)
	  {
		  if(document.getElementById('amount'+i).value > 0)
		  {
			if (j > 0)
			document.getElementById('action_id').value = document.getElementById('action_id').value + ',';
			document.getElementById('action_id').value = document.getElementById('action_id').value + i + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('stockid'+i).value + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('amount'+i).value + '-';
			<cfif get_store_type.raf gt 0>
				document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('shelf_code'+i).value 
			</cfif>
			j++;
		  }
		  document.getElementById('row_count').value = j;
	  }
	}

	function buton_kontrol()
	{
		if (islemtipi == 0)
			buton++;
		else if (buton>0)
			buton--;
		if (buton < 1)
			document.getElementById('onay').disabled = true;
		else
			document.getElementById('onay').disabled = false;
	}
	
	function get_stock(barcode)
    {
	 	barcod = ''; stockid = ''; stockcode = ''; spectmainid = ''; //ilk önce sıfırlıyoruz
	 	k_= 0;
	 	if (k_ == 0)
     	{
		 	var new_sql = "SELECT SB.STOCK_ID,SB.BARCODE,PU.MAIN_UNIT,PU.MULTIPLIER,S.PRODUCT_NAME FROM STOCKS_BARCODES AS SB INNER JOIN              PRODUCT_UNIT AS PU ON SB.UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID WHERE SB.BARCODE= '"+barcode+"'";
		 	var get_product = wrk_query(new_sql,'dsn3');
		 	if (get_product.STOCK_ID == undefined)
		 	{
				ekle = 1;
				cikar = 1;
				k_=1;
				alert('Ürün Bulunamadı');
		 	}
		 	else
		 	{	
				document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*-1);
				if (document.getElementById('all_amount').value*1 <= document.getElementById('paket_sayisi').value*1)
				{
					stockid = get_product.STOCK_ID;
					stockcode = get_product.PRODUCT_NAME;
					barcode = get_product.BARCODE;
					buton_kontrol();
				}
				else
				{
					alert('Sevk Emrinden Fazla Çıkış Yaptınız !');
					document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*1);
					document.getElementById('add_other_amount').focus();
					ekle=1;
				}
    		}
		}
		else
		{
			barcod = ''; stockid = ''; stockcode = ''; spectmainid = '';
			return false;
		}
	}
	function add_amount()
	{
		if(row_count >0) /*ilk Satırdan sonrası*/
	  	{
		  for(i=1;i<=row_count;i++)
		  {
			  <cfif get_store_type.raf gt 0>
				  if(document.getElementById('stockid'+i).value == stockid && document.getElementById('shelf_code'+i).value == shelf_code)
				  {
					  var stock_sql = "SELECT ISNULL(S.REAL_STOCK, 0) AS REAL_STOCK FROM GET_STOCK_LAST_SHELF AS S INNER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS P ON S.SHELF_NUMBER = P.PRODUCT_PLACE_ID WHERE P.SHELF_CODE = '"+shelf_code+"' AND S.STOCK_ID ="+stockid;
					  var get_real_stock = wrk_query(stock_sql,'dsn2');
					  if(get_real_stock.REAL_STOCK==undefined)
					  get_real_stock.REAL_STOCK = 0;
					  if((get_real_stock.REAL_STOCK*1) < document.getElementById('amount'+i).value - (-1 * amount))
					  {
						ekle=1;
						alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock.REAL_STOCK);
						document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (1 * amount);
						document.getElementById('add_other_amount').focus();
					  }
					  else
					  {
						document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
						ekle=1;
					  }
				  }
			  <cfelse>
				  if(document.getElementById('stockid'+i).value == stockid)
				  {
					  var stock_sql = "SELECT PRODUCT_STOCK FROM PRTOTM_GET_STOCK_LOCATION_TOTAL WHERE  DEPO = '"+form_basket.txt_department_out.value+"' AND STOCK_ID ="+stockid;
					  var get_real_stock = wrk_query(stock_sql,'dsn2');
					  if(get_real_stock.PRODUCT_STOCK==undefined)
					  get_real_stock.PRODUCT_STOCK = 0;
					  if((get_real_stock.PRODUCT_STOCK*1) < (-1 * amount))
					  {
						ekle=1;
						alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock.PRODUCT_STOCK);
						document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*1);
						document.getElementById('add_other_amount').focus();
					  }
					  else
					  {
						document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
						ekle=1;
					  }
				  }
			  </cfif>
		  }
		}
		else
		{
			<cfif get_store_type.raf gt 0>
				var stock_sql_1 = "SELECT ISNULL(S.REAL_STOCK, 0) AS REAL_STOCK FROM GET_STOCK_LAST_SHELF AS S INNER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS P ON S.SHELF_NUMBER = P.PRODUCT_PLACE_ID WHERE P.SHELF_CODE = '"+shelf_code+"' AND S.STOCK_ID ="+stockid;
				
				var get_real_stock_1 = wrk_query(stock_sql_1,'dsn2');
				if(get_real_stock_1.REAL_STOCK==undefined)
				get_real_stock_1.REAL_STOCK = 0;
				if((get_real_stock_1.REAL_STOCK*1) < (1*amount))
				{
					ekle=1;
					alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock_1.REAL_STOCK);
					document.getElementById('add_other_amount').focus();
				}
				/*else
				{
					document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
					ekle=1;
				}*/
			<cfelse>
			
				var stock_sql_1 = "SELECT PRODUCT_STOCK FROM PRTOTM_GET_STOCK_LOCATION_TOTAL WHERE  DEPO = '"+form_basket.txt_department_out.value+"' AND STOCK_ID ="+stockid;
				var get_real_stock_1 = wrk_query(stock_sql_1,'dsn2');
				if(get_real_stock_1.PRODUCT_STOCK==undefined)
				get_real_stock_1.PRODUCT_STOCK = 0;
				if((get_real_stock_1.PRODUCT_STOCK*1) < (1*amount))
				{
					ekle=1;
					alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock_1.PRODUCT_STOCK);
					document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*1);
					document.getElementById('add_other_amount').focus();
				}
				/*else
				{
					document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
					ekle=1;
				}*/
			</cfif>
		}
	}
	
	function add_row(barcode)
	{
		<cfif get_store_type.raf eq 0>
			get_stock(barcode);
		</cfif>
		{
			  amount = document.getElementById('add_other_amount').value;
			  add_amount();
			  if (ekle == 0)
			  {
				row_count++;
				document.getElementById('row_count').value = row_count;
				var newRow;
				var newCell;	
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="hidden" value="'+stockid+'" name="stockid'+row_count+'" id="stockid'+row_count+'" /><input type="hidden" value="'+spectmainid+'" name="spectmainid'+row_count+'" id="spectmainid'+row_count+'" /><input type="text" value="'+barcode+'" name="barcod'+row_count+'" id="barcod'+row_count+'" size="13" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" value="'+stockcode+'" name="stockcode'+row_count+'" id="stockcode'+row_count+'" size="13" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" style="text-align:center" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="5" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" value="'+shelf_code+'" name="shelf_code'+row_count+'" id="shelf_code'+row_count+'" size="8" class="boxtext" readonly="yes" style="text-align:right" />';
			  }
			  else
			  {
				 ekle = 0;
			  }
		}
	}
</script>

<script language="JavaScript">
	document.onkeydown = checkKeycode
	function checkKeycode(e) 
	{
		var keycode;
		if (window.event) keycode = window.event.keyCode;
		else if (e) keycode = e.which;
		if (keycode == 13)
		{
			<cfif get_store_type.raf gt 0>
				if (document.getElementById('add_other_shelf').value.length >0)
				{
					search_shelf(document.getElementById('add_other_shelf').value);
				}
				else
				{
					alert('Raf Borkodu Hatalı');
					document.getElementById('add_other_shelf').value = '';


					document.getElementById('add_other_shelf').focus();	
				}
			<cfelse>
				if (document.getElementById('add_other_barcod').value.length >0) 
				{
					add_row(document.getElementById('add_other_barcod').value);
					/*document.getElementById('add_other_barcod').value = '';*/
					document.getElementById('add_other_amount').value = '';
					document.getElementById('add_other_amount').focus();
				}
				else
				{
					alert('Barcod Hatalı');
					document.getElementById('add_other_barcod').value = '';
					document.getElementById('add_other_barcode').focus();
				}
			</cfif>
		}
	}
	function search_shelf(shelf_8)
	{
		var giris_depo = document.all.txt_department_out.value;
		var shelf_sql = "SELECT PRODUCT_PLACE_ID, STORE_ID, LOCATION_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND SHELF_CODE = '"+shelf_8+"'";
		var get_shelf = wrk_query(shelf_sql,'dsn3');
		if(get_shelf.recordcount)
		{
			var giris_depo_s = get_shelf.STORE_ID.toString()+'-'+get_shelf.LOCATION_ID.toString();
			if(giris_depo != giris_depo_s)
			{
					alert('Seçtiğiniz Raf Giriş Lokasyonunda Değildir.!');	
					document.getElementById('add_other_shelf').value = '';
					document.getElementById('add_other_shelf').focus();	
			}
			else
			{
				if (document.getElementById('add_other_barcod').value.length >0)
				{
					var new_sql = "SELECT SB.STOCK_ID, SB.BARCODE, S.PRODUCT_NAME, PP.SHELF_CODE FROM STOCKS_BARCODES AS SB INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID INNER JOIN PRODUCT_PLACE_ROWS AS PPR ON S.PRODUCT_ID = PPR.PRODUCT_ID INNER JOIN PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID = PP.PRODUCT_PLACE_ID WHERE SB.BARCODE = '"+document.getElementById('add_other_barcod').value+"' AND PP.SHELF_CODE ='"+document.getElementById('add_other_shelf').value+"'";
		 			var get_product = wrk_query(new_sql,'dsn3');
					if (get_product.STOCK_ID == undefined)
					{
						alert('Ürün Bulunamadı');
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_shelf').focus();
					}
					else
					{	
						document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*-1);
						if (document.getElementById('all_amount').value*1 <= document.getElementById('paket_sayisi').value*1)
						{
						stockid = get_product.STOCK_ID;
						stockcode = get_product.PRODUCT_NAME;
						barcode = get_product.BARCODE;
						shelf_code = get_product.SHELF_CODE; 
						buton_kontrol();
						add_row(barcode);
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_amount').value = '';
						document.getElementById('add_other_amount').focus();
						}
						else
						{
							alert('Sevk Emrinden Fazla Çıkış Yaptınız !');
							document.getElementById('all_amount').value = document.getElementById('all_amount').value - (document.getElementById('add_other_amount').value*1);
							document.getElementById('add_other_shelf').value = '';
							document.getElementById('add_other_amount').focus();
						}
					}
				}
				else if (document.getElementById('add_other_barcod').value.length == 0)
				{
						document.getElementById('add_other_barcod').focus();	
				}
				/*else
				{
						alert('Ürün Barkodu Hatalı');
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_shelf').focus();
				}*/
			}
		}
		else
		{
			alert('Seçtiğiniz Raf Bulunamadı!');
			document.getElementById('add_other_shelf').value = '';
			document.getElementById('add_other_shelf').focus();
		}
	}
</script>
<script language="javascript" type="text/javascript">
		function kontrol_kayit()
		{
			if(form_basket.txt_department_out.value == "")
			{
				alert('Depo Seçmelisiniz.');
				return false;
			}
			else if(form_basket.txt_department_out.value.indexOf('-') == -1)
			{
				alert('Lütfen giriş için doğru depo seçiniz.');
				return false;
			}
			else
			{
			actionidolustur();
			window.location.href='<cfoutput>#request.self#?fuseaction=epda.emptypopup_add_prtotm_shipping_ambar_stock_q&shelf_type=#get_store_type.raf#&date1=#attributes.date1#&date2=#attributes.date2#&is_type=#attributes.is_type#&keyword=#attributes.keyword#&dep_in=#attributes.department_in_id#&dep_out=#attributes.department_out_id#&ref_no=#attributes.deliver_paper_no#&ship_id=#attributes.ship_id#&f_stock_id=#f_stock_id#&</cfoutput>&action_id='+document.getElementById('action_id').value+'&fis_tipi='+document.form_basket.fis_tipi.value+'&process_cat='+document.form_basket.process_cat_id.value;
			}
		}
		function kontrol_sil()
		{
			var sil_kontrol = confirm('Ambar Fişini Silmek İster misiniz ?');
			if(sil_kontrol== true)
			window.location.href='<cfoutput>#request.self#?fuseaction=epda.emptypopup_del_prtotm_shipping_ambar_stock_q&shelf_type=#get_store_type.raf#&date1=#attributes.date1#&date2=#attributes.date2#&is_type=#attributes.is_type#&keyword=#attributes.keyword#&dep_in=#attributes.department_in_id#&dep_out=#attributes.department_out_id#&ref_no=#attributes.deliver_paper_no#&ship_id=#attributes.ship_id#&f_stock_id=#f_stock_id#&type=1'</cfoutput>;
		}
</script>