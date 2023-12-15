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
        SL.STATUS = 1  
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
<cfform name="add_stock_count" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_PRTOTM_stock_count_loc_file" enctype="multipart/form-data"> 
<div style="width:100%">
  <table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
    <tr>
  <td colspan="4"><a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;</td>
  </tr>
    <tr class="color-list">
      <td colspan="3">
      	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
          <tr class="color-list">
            <td align="center" width="65px">Miktar</td>
            <td align="center" width="150px">Barcode</td>
       	  </tr>
          <tr height="25px" class="color-list">
            <td><input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:45px; text-align:right" value="" /></td>
            <td><input id="add_other_barcod" name="add_other_barcod" type="text" value="" style="width:140px;" ></td>
          </tr>
          <tr height="25px" class="color-list">
            <td align="center">Depo</td>
            <td>
              <select name="txt_department" id="txt_department" style="width:140px" onchange="document.getElementById('txt_department_in').value = this.value">
               <cftry>
				<cfoutput query="get_all_location" group="department_id">
                  <option disabled="disabled"  value="#department_id#"<cfif attributes.department_in_id eq department_id>selected</cfif>>#department_head#</option>
                  <cfoutput>
                    <option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_in_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#
                    <cfif not status>
                      -
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                    </option>
                  </cfoutput> </cfoutput> <cfcatch></cfcatch>
				</cftry>
              </select>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="color-list">
      <td width="85px" align="center">Barkod</td>
      <td align="left">Ürün Adı</td>
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
      	<input type="hidden" id="txt_department_in" name="txt_department_in" value="" />
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
			var new_sql = "SELECT SB.STOCK_ID,SB.BARCODE,PU.MAIN_UNIT,PU.MULTIPLIER, S.PRODUCT_NAME FROM STOCKS_BARCODES AS SB INNER JOIN PRODUCT_UNIT AS PU ON SB.UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID WHERE SB.BARCODE= '"+barcode+"'";
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
		for(i=1;i<=row_count;i++)
		{
			if(document.getElementById('stockid'+i).value == stockid)
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
	function add_row(barcode)
	{
		{
			  get_stock(barcode);
			  document.getElementById('txt_department').disabled = true;
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
				newCell.innerHTML = '<input type="text" value="'+stockcode+'" name="stockcode'+row_count+'" id="stockcode'+row_count+'" size="23" class="boxtext" readonly="yes" style="text-align:right" />';
				
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" style="text-align:right" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="6" class="boxtext" readonly="yes"  style="text-align:" />';
				
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
			if (document.getElementById('add_other_barcod').value.length > 0)
			{
				add_row(document.getElementById('add_other_barcod').value);
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_amount').value = '1';
				document.getElementById('add_other_barcod').focus();
			}
			else
			{
				alert('Ürün Barkod Karakter Sayısı Hatalı');
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_barcod').focus();	
			}
		}
	}
</script>
<script language="javascript" type="text/javascript">
		function kontrol_kayit()
		{
			if(add_stock_count.txt_department.value == "")
			{
				alert('Depo Seçmelisiniz.');
				return false;
			}
			else if(add_stock_count.txt_department.value.indexOf('-') == -1)
			{
				alert('Lütfen giriş için doğru depo seçiniz.');
				return false;
			}
			else
				document.getElementById("txt_department_in").value = document.getElementById("txt_department").value;
				document.getElementById("add_stock_count").submit();
		}
		
</script>