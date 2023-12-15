<cf_box title="Depo Fişi">
<cfset default_process_type = 113>
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_MK_TO_RF_DEP, 
        DEFAULT_MK_TO_RF_LOC
	FROM            
    	PRTOTM_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif not get_default_departments.recordcount>
	<script type="text/javascript">
		alert("Default Depo Ayarları Yapılmamış! Sistem Yöneticinizle Görüşün");
		history.back();	
	</script>
</cfif>

<cfset default_departments = '#get_default_departments.DEFAULT_MK_TO_RF_DEP#'> <!---Depo seçiminde select satırına gelecek Lokasyonların depatmanları tanımlanır--->
<cfparam name="attributes.department_in_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,1)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,1)#">
<cfparam name="attributes.department_out_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,1)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,1)#">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT        
    	D.DEPARTMENT_HEAD, 
        SL.DEPARTMENT_ID, 
        SL.LOCATION_ID, 
        SL.STATUS, 
        SL.COMMENT, 
        TBL.STORE_ID
	FROM            
    	STOCKS_LOCATION AS SL INNER JOIN
    	DEPARTMENT AS D ON SL.DEPARTMENT_ID = D.DEPARTMENT_ID INNER JOIN
      	BRANCH AS B ON D.BRANCH_ID = B.BRANCH_ID LEFT OUTER JOIN
     	(
        	SELECT        
            	STORE_ID, LOCATION_ID
         	FROM            
            	#dsn3_alias#.PRODUCT_PLACE
        	GROUP BY STORE_ID, LOCATION_ID
    	) AS TBL ON SL.LOCATION_ID = TBL.LOCATION_ID AND SL.DEPARTMENT_ID = TBL.STORE_ID
	WHERE        
    	D.DEPARTMENT_ID IN (#default_departments#) AND 
        SL.STATUS = 1 AND 
        TBL.STORE_ID IS NULL
</cfquery>
<cfquery name="get_process_cat" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_process_type# AND 
        SPCF.FUSE_NAME = 'pda.form_add_ambar_fis' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat.recordcount>
	<script type="text/javascript">
		alert("İşlem Kategorisi Tanımlayınız!");
		history.back();	
	</script>
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
</style>
<script language="javascript" type="text/javascript">
  var row_count = 0;
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
  	<cfinput id="process_cat_id" type="hidden" name="process_cat_id" value="#get_process_cat.process_cat_id#">
  	<cfinput id="fis_tipi" type="hidden" name="fis_tipi" value="#default_process_type#">
  	<input type="hidden" name="kuponlist" value="" />
  	<input type="hidden" name="active_period" value="#session.pda.period_id#" />
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
 		<tr class="color-list">
      		<td colspan="4">
            	<table cellpadding="0" cellspacing="0" width="100%">
          			<tr>
                        <td>&nbsp;&nbsp;Miktar&nbsp;</td>
                        <td><input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:30px; text-align:right" value="1" /></td>
                        <td nowrap="nowrap">&nbsp;&nbsp;&nbsp;Barkod&nbsp;</td>
                        <td><input id="add_other_barcod" name="add_other_barcod" type="text" value="" style="width:100%;" ></td>
          			</tr>
                  	<input id="del_other_amount" name="del_other_amount" type="hidden"  onfocus="islemtipi=1;" value="1" />
                  	<input id="del_other_barcod" name="del_other_barcod" type="hidden" value="" style="width:90px;" >
        		</table>
          	</td>
    	</tr>
    	<tr class="color-list">
      		<td colspan="4">
      			<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
           			<tr class="color-list">
            			<td align="center" width="50%">Çıkış Depo</td>
            			<td align="center" width="50%">Giriş Depo</td>
           			</tr>
           			<tr class="color-list">
            			<td>
              				<select name="txt_department_out" id="txt_department_out" style="width:100px" onchange="document.getElementById('department_out').value = this.value">
                				<cfoutput query="get_all_location" group="department_id">
                  					<option disabled="disabled" value="#department_id#"<cfif attributes.department_out_id eq department_id>selected</cfif>>#department_head#</option>
                  						<cfoutput>
                    						<option> <!--- <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_out_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status>-<cf_get_lang_main no='82.Pasif'></cfif>---->
                    						</option>
                  						</cfoutput> 
								</cfoutput>
              				</select>
          				</td>
            			<td width="93%">
              				<select name="txt_department_in" style="width:100px" onchange="document.getElementById('department_in').value = this.value">
                				<cfoutput query="get_all_location" group="department_id">
                  					<option disabled="disabled" value="#department_id#"<cfif attributes.department_in_id eq department_id>selected</cfif>>#department_head#</option>
                  					<cfoutput>
                    					<option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_in_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status>-<cf_get_lang_main no='82.Pasif'></cfif>
                    					</option>
                  					</cfoutput> 
								</cfoutput>
              				</select>
              			</td>
          			</tr>
        		</table>
         	</td>
    	</tr>
    	<tr class="color-list">
          <td width="70" align="center">Barkod</td>
          <td align="left">Ürün Adı</td>
          <td width="30" align="right">Miktar</td>
    	</tr>
    	<tr class="color-list">
      		<td align="left" colspan="4"><!---  kontrol edilen tablo--->
        		<form name="product_row" id="product_row" method="post">
          			<table name="table1" id="table1" border="0" cellpadding="0" cellspacing="0" width="100%" class="tablo">
          			</table>
        		</form>
     		</td>
    	</tr>
    	<tr class="color-list">
      		<td colspan="6" align="right">
                <input type="hidden" id="department_in" name="department_in" value="" />
                <input type="hidden" id="row_count" name="row_count" value="0" />
                <input type="hidden" id="action_id" name="action_id" value="" />
                <input id="onay" name="Onay" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="kontrol_kayit();" />
          	</td>
    	</tr>
  	</table>
    </div>
</cfform>
<script language="javascript" type="text/javascript">
	document.getElementById('add_other_barcod').focus();
	setTimeout("document.getElementById('add_other_barcod').select();",1000);	
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
			document.getElementById('action_id').value = document.getElementById('action_id').value + '0'
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
	 	carpan = ''; birim = ''; barcod = ''; stockid = ''; stockcode = ''; spectmainid = ''; //ilk önce sıfırlıyoruz
	 	k_= 0;
		if(document.getElementById('add_other_amount').value.length == 0)
		{
			alert('Miktar Giriniz');
			k_=1;
			return false;
		}
	 	var uzunluk = barcode.length;
	 	if(uzunluk > 9)
	 	{
			if(barcode.substr(0,1)=='j')//Bazı barkod okuyucular okuduktan sonra başına j harfi koyuyor kontrol için yapıldı
			{
				barcode = barcode.substring(1,9);
			}
	 	}
		
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
		 	{	carpan = get_product.MULTIPLIER;
				birim = get_product.MAIN_UNIT;
				stockid = get_product.STOCK_ID;
				stockcode = get_product.PRODUCT_NAME;
				barcode = get_product.PRODUCT_BARCOD;
				buton_kontrol();
    		}
		}
		else
		{
			carpan = ''; birim = ''; barcod = ''; stockid = ''; stockcode = ''; spectmainid = '';
			return false;
		}
	}
	function add_amount()
	{
	  if(row_count >0) /*ilk Satırdan sonrası*/
	  {
		  for(i=1;i<=row_count;i++)
		  {
				  var stock_sql = "SELECT PRODUCT_STOCK FROM PRTOTM_GET_STOCK_LOCATION_TOTAL WHERE  DEPO = '"+form_basket.txt_department_out.value+"' AND STOCK_ID ="+stockid;
				  var get_real_stock = wrk_query(stock_sql,'dsn2');
				  if (get_real_stock.PRODUCT_STOCK == undefined)
					get_real_stock.PRODUCT_STOCK = 0;
				  if(get_real_stock.PRODUCT_STOCK < document.getElementById('amount'+i).value - (-1 * amount) && document.getElementById('stockid'+i).value == stockid)
				  {
					ekle=1;
					alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock.PRODUCT_STOCK);
					document.getElementById('add_other_amount').focus();
					return false;
				  }
				  else
				  {
					  if(document.getElementById('stockid'+i).value == stockid)
					  {
						document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
						if (document.getElementById('frm_row'+i).style.display == 'none')
							document.getElementById('frm_row'+i).style.display='block';
						ekle=1;
					  }
				  }
		   }
	   }
	   else
	   {
		    var stock_sql = "SELECT PRODUCT_STOCK FROM PRTOTM_GET_STOCK_LOCATION_TOTAL WHERE  DEPO = '"+form_basket.txt_department_out.value+"' AND STOCK_ID ="+stockid;
			var get_real_stock = wrk_query(stock_sql,'dsn2');
			if (get_real_stock.PRODUCT_STOCK == undefined)
				get_real_stock.PRODUCT_STOCK = 0;
			if(get_real_stock.PRODUCT_STOCK < amount)
			{
				ekle=1;
				alert("Yetersiz Stok. Çıkış Lokasyonundaki Stok Miktarı : "+get_real_stock.PRODUCT_STOCK);
				document.getElementById('add_other_amount').focus();
			}
			else
			{
				document.getElementById('txt_department_out').disabled = true;
			}
	   }
	}
	
	function add_row(barcode)
	{
		get_stock(barcode);
		if (k_==0)
		{
			  amount = ''; 
			  amount = document.getElementById('add_other_amount').value;
			  if (ekle == 0)
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
				newCell.innerHTML = '<input type="hidden" value="'+stockid+'" name="stockid'+row_count+'" id="stockid'+row_count+'" /><input type="hidden" value="'+spectmainid+'" name="spectmainid'+row_count+'" id="spectmainid'+row_count+'" /><input type="text" value="'+barcode+'" name="barcod'+row_count+'" id="barcod'+row_count+'" size="14" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" value="'+stockcode+'" name="stockcode'+row_count+'" id="stockcode'+row_count+'" size="23" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" style="text-align:right" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="4" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="hidden" value="'+birim+'" name="birim'+row_count+'" id="birim'+row_count+'" />';
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
	function checkKeycode(e) {
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	if (keycode == 13)
		{
			if ((document.getElementById('add_other_barcod').value.length > 0) && (islemtipi==0))
			{
				add_row(document.getElementById('add_other_barcod').value);
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_amount').value = '1';
				document.getElementById('add_other_barcod').focus();
			}
			else
			{
				alert('Barcod Hatalı');
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_barcode').focus();
			}
		}
	}
</script>
<script language="javascript" type="text/javascript">
		function kontrol_kayit()
		{
			if(form_basket.txt_department_in.value == form_basket.txt_department_out.value)
			{
				alert('Giriş ve Çıkış Lokasyonu Farklı Olmalıdır.');
				return false;
			}
			else
			{
			actionidolustur();
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=epda.prtotm_Qadd_ambar_fis&dep_in='+form_basket.txt_department_in.value+'&dep_out='+form_basket.txt_department_out.value+'&action_id='+document.getElementById('action_id').value+'&fis_tipi='+form_basket.fis_tipi.value+'&process_cat='+form_basket.process_cat_id.value;
			}
		}
		
</script>
</cf_box>