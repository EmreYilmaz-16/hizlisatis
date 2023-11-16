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
<cfparam name="attributes.department_in_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,2)#">
<cfparam name="attributes.department_out_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,1)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,1)#">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.DEPARTMENT_ID IN (#default_departments#) AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		SL.STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID
</cfquery>
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
table, td, th, div {
    font-size: 13px;
    font-family: 'Roboto', sans-serif !important;
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
<cfform name="add_stock_count" method="post" action="#request.self#?fuseaction=epda.prtotm_qstokc_count_file" enctype="multipart/form-data"> 
<div style="width:100%">
  <table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
    <tr>
  <td colspan="4"><a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Sevkiyata"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;</td>
  </tr>
    <tr class="color-list">
      <td colspan="3">
      	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
          <tr class="color-list">
            <td align="center" width="45px">Miktar</td>
            <td align="center" width="95px">Barcode</td>
            <td align="center">Raf</td>
            <td></td>
       	  </tr>
          <tr height="25px" class="color-list">
            <td><input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:40px; text-align:right" value="" /></td>
            <td><input id="add_other_barcod" name="add_other_barcod" type="text" value="" style="width:90px;" ></td>
            <td><input id="add_other_shelf" name="add_other_shelf" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:60px;" value="" /></td>
            <td>
              <table>
              	<tr>
                    <td id="shelf_select_td" style="display:none">
                        <select name="shelf_select" id="shelf_select" style="width:70px;height:20px;text-align:center">
                            <option value="">Ürün Rafları</option>
                        </select>
                    </td>
                  </tr>
                </table>
			</td>
          </tr>
          <tr height="25px"  class="color-list">
            <td align="center">Depo</td>
            <td colspan="3">
              <select name="txt_department_in" style="width:163px;height:20px" onchange="document.getElementById('department_in').value = this.value">
                <cfoutput query="get_all_location" group="department_id">
                  <option disabled="disabled"  value="#department_id#"<cfif attributes.department_in_id eq department_id>selected</cfif>>#department_head#</option>
                 <cftry>  
				  <cfoutput>
                  <option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_in_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#
                    <cfif not status>
                      -
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                    </option>
                  </cfoutput>
				  <cfcatch></cfcatch>
				</cftry>  </cfoutput>
              </select>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="color-list">
      <td width="75" align="center">Barkod</td>
      <td width="65" align="left">Raf</td>
      <td width="35" align="right">Mikt.</td>
    </tr>
    <tr class="color-list">
      <td align="left" colspan="3"><!---  kontrol edilen tablo--->
        <form name="product_row" id="product_row" method="post">
          <table name="table1" id="table1" border="0" cellpadding="0" cellspacing="0" width="100%" class="tablo">
          </table>
        </form>
        <!---  kontrol edilen tablo---></td>
    </tr>
    <tr class="color-list">
      <td colspan="3" align="right">
      	<input type="hidden" id="department_in" name="department_in" value="" />
      	<input type="hidden" id="row_count" name="row_count" value="0" />
        <input type="hidden" id="action_id" name="action_id" value="" />
        <input id="onay" name="Onay" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="kontrol_kayit();" /></td>
        
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
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('shelf_code'+i).value 
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
	 	/*shelf_code = '';*/ barcod = ''; stockid = ''; stockcode = ''; spectmainid = ''; //ilk önce sıfırlıyoruz
	 	k_= 0;
	 	if (k_ == 0)
     	{
			var new_sql = "SELECT SB.STOCK_ID,SB.BARCODE,PU.MAIN_UNIT,PU.MULTIPLIER, S.PRODUCT_NAME FROM STOCKS_BARCODES AS SB INNER JOIN              PRODUCT_UNIT AS PU ON SB.UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID WHERE SB.BARCODE= '"+barcode+"'";
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
				stockid = get_product.STOCK_ID;
				stockcode = get_product.PRODUCT_NAME;
				barcode = get_product.BARCODE;
				document.getElementById('add_other_shelf').focus();
				set_shelfs(stockid);
				buton_kontrol();
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
	  	document.getElementById('shelf_select_td').style.display='none';
		for(i=1;i<=row_count;i++)
		{
			if(document.getElementById('stockid'+i).value == stockid)
			{
				if(document.getElementById('stockid'+i).value == stockid && document.getElementById('shelf_code'+i).value == shelf_code)
				{
					document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
					if (document.getElementById('frm_row'+i).style.display == 'none')
						document.getElementById('frm_row'+i).style.display='block';
					ekle=1;
				}
			}
		}
	}
	
	function add_row(barcode)
	{
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
				newCell.innerHTML = '<input type="text" value="'+shelf_code+'" name="shelf_code'+row_count+'" id="shelf_code'+row_count+'" size="11" class="boxtext" readonly="yes" style="text-align:right" />';
				
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" style="text-align:right" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="8" class="boxtext" readonly="yes"  style="text-align:" />';
				
			  }
			  else
			  {
				 ekle = 0;
			  }
		}
	}
	function include(arr, obj) 
	{
    	for(var i=0; i<arr.length; i++) 
		{
        	if (arr[i] == obj) return true;
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
			if (document.getElementById('add_other_barcod').value.length == '' && document.getElementById('add_other_shelf').value.length >0)
			{
				alert('Önce Ürün Barkodu Okutunuz');
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_shelf').value = '';
				document.getElementById('add_other_amount').value = 1;
				document.getElementById('add_other_barcod').focus();	
			
			}
			else
			{
				if (document.getElementById('add_other_barcod').value.length >0 && document.getElementById('add_other_shelf').value.length >0)	
				search_shelf(document.getElementById('add_other_shelf').value);
				else
				get_stock(document.getElementById('add_other_barcod').value);
			}
		}
	}
	function search_shelf(shelf_8)
	{
		var giris_depo = document.all.txt_department_in.value;
		var shelf_sql = "SELECT PRODUCT_PLACE_ID, STORE_ID, LOCATION_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND SHELF_CODE = '"+shelf_8+"'";
		var get_shelf = wrk_query(shelf_sql,'dsn3');
		if(get_shelf.recordcount)
		{
			var giris_depo_s = get_shelf.STORE_ID.toString()+'-'+get_shelf.LOCATION_ID.toString();
			if(giris_depo != giris_depo_s)
			{
					alert('Seçtiğiniz Raf Giriş Lokasyonunda Yoktur.!');	
					document.getElementById('add_other_barcod').value = '';
					document.getElementById('add_other_shelf').value = '';
					document.getElementById('add_other_barcod').focus();	
			}
			else
			{
				if (document.getElementById('add_other_barcod').value.length > 0)
				{
					var new_sql = "SELECT SB.STOCK_ID, SB.BARCODE, S.PRODUCT_NAME, PP.SHELF_CODE FROM STOCKS_BARCODES AS SB INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID INNER JOIN PRODUCT_PLACE_ROWS AS PPR ON S.PRODUCT_ID = PPR.PRODUCT_ID INNER JOIN PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID = PP.PRODUCT_PLACE_ID WHERE SB.BARCODE = '"+document.getElementById('add_other_barcod').value+"' AND PP.SHELF_CODE ='"+document.getElementById('add_other_shelf').value+"'";
		 			var get_product = wrk_query(new_sql,'dsn3');
					if (get_product.STOCK_ID == undefined)
					{
						alert('Ürün Bu Rafa Tanıtılmamış');
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_shelf').focus();
					}
					else
					{	
						stockid = get_product.STOCK_ID;
						stockcode = get_product.PRODUCT_NAME;
						barcode = get_product.BARCODE;
						shelf_code = get_product.SHELF_CODE; 
						buton_kontrol();
						add_row(barcode);
						document.getElementById('add_other_barcod').value = '';
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_amount').value = '';
						document.getElementById('add_other_amount').focus();
					}
				}
				else if (document.getElementById('add_other_barcod').value.length == 0)
				{
						document.getElementById('add_other_barcod').focus();	
				}
				else
				{
						alert('Ürün Barkodu Hatalı');
						document.getElementById('add_other_barcod').value = '';
						document.getElementById('add_other_shelf').value = '';
						document.getElementById('add_other_barcod').focus();
				}
			}
		}
		else
		{
			alert('Seçtiğiniz Raf Hiç Tanımlanmamış!');
			document.getElementById('add_other_shelf').value = '';
			document.getElementById('add_other_shelf').focus();
		}
	}
	function set_shelfs(xyz)
	{
		document.getElementById('shelf_select_td').style.display='';
		var product_shelfs = wrk_query("SELECT PP.SHELF_CODE, PPR.AMOUNT, PP.PRODUCT_PLACE_ID, ISNULL((SELECT REAL_STOCK FROM GET_STOCK_LAST_SHELF WHERE SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND STOCK_ID = PPR.STOCK_ID),0) AS REAL_STOCK FROM <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS PP LEFT OUTER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID WHERE PPR.STOCK_ID = "+xyz+" ORDER BY REAL_STOCK DESC","dsn2");
		var option_count = document.getElementById('shelf_select').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('shelf_select').options[x] = null;
		if(product_shelfs.recordcount != 0)
		{	
			for(var xx=0;xx<product_shelfs.recordcount;xx++)
			{
				document.getElementById('shelf_select').options[xx]=new Option(product_shelfs.SHELF_CODE[xx],product_shelfs.PRODUCT_PLACE_ID[xx],product_shelfs.AMOUNT[xx]);
			}
			var depo_stock_sql = "SELECT ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK FROM PRTOTM_GET_STOCK_LOCATION_TOTAL WHERE  DEPO = '"+add_stock_count.txt_department_out.value+"' AND STOCK_ID ="+xyz;
			var depo_stock = wrk_query(depo_stock_sql,'dsn2');
			document.getElementById('add_other_amount').value = depo_stock.PRODUCT_STOCK;
		}
		else
			document.getElementById('shelf_select').options[0] = new Option('Raf Tanımsız','');
	}
</script>
<script language="javascript" type="text/javascript">
		function kontrol_kayit()
		{
			if(add_stock_count.txt_department_in.value == "")
			{
				alert('Depo Seçmelisiniz.');
				return false;
			}
			else if(add_stock_count.txt_department_in.value.indexOf('-') == -1)
			{
				alert('Lütfen giriş için doğru depo seçiniz.');
				return false;
			}
			else
				document.getElementById("add_stock_count").submit();
		}
		
</script>