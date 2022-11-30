<cf_get_lang_set module_name="stock">
<cfparam name="attributes.department_id" default="#ListGetAt(session.pda.user_location,1,'-')#">
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
		D.IS_STORE IN (1,3) AND
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
  <input type="hidden" name="active_period" value="#session.pda.period_id#" />
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
      <td colspan="3"><table cellpadding="0" cellspacing="0" width="40%">
          <table>
          <tr>
            <td>Miktar</td>
            <td><input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" style="width:40px;" value="1" /></td>
            <td nowrap="nowrap">Ekle</td>
            <td><input id="add_other_barcod" name="add_other_barcod" type="text" value="" style="width:120px;" onfocus="islemtipi=0;"></td>
          </tr>
          <tr>
            <td height="22">Miktar</td>
            <td ><input id="del_other_amount" name="del_other_amount" type="text" class="moneybox" style="width:40px;" value="1" /></td>
            <td nowrap="nowrap">Çıkar</td>
            <td><input id="del_other_barcod" name="del_other_barcod" type="text" value="" style="width:120px;" onfocus="islemtipi=1;"></td>
          </tr>
        </table></td>
    </tr>
    <tr class="color-list">
      <td colspan="3"><table width="100%" border="0">
          <table>
          <tr>
            <td width="7%"><cf_get_lang no="96.Giriş Depo"></td>
            <td width="93%"><!--- Giriş Depo --->
              <select name="txt_department_in" style="width:170px" onchange="document.getElementById('department_in').value = this.value">
                <option value="">
                <cf_get_lang no='171.Tüm Depolar'>
                </option>
                <cfoutput query="get_all_location" group="department_id">
                  <option value="#department_id#"<cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
                  <cfoutput>
                    <option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#
                    <cfif not status>
                      -
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                    </option>
                  </cfoutput> </cfoutput>
              </select>
              <!--- //Giriş Depo ---></td>
          </tr>
        </table></td>
    </tr>
    <tr class="color-list">
      <td width="65" align="left">Barkod</td>
      <td width="115" align="left">Paket Kodu</td>
      <td width="32" align="right">Miktar</td>
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
      <td colspan="6" align="right">
      	<input type="hidden" id="department_in" name="department_in" value="" />
      	<input type="hidden" id="row_count" name="row_count" value="0" />
        <input type="hidden" id="action_id" name="action_id" value="" />
        <input id="onay" name="Onay" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="if (kontrol_kayit()==true) onay();" /></td>
    </tr>
  </table>
</cfform>
<!--- Dönem kontrolü--->
<cfif isDefined("session.pda.company_id") and form.active_period neq session.pda.period_id>
  <script language="JavaScript">
		alert("	<cf_get_lang no ='522.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
  <cfabort>
</cfif>
<!--- emptypopup_add_ship_fis_process--->
<script language="javascript" type="text/javascript">
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
		document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('stockid'+i).value + '-';
		document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('spectmainid'+i).value + '-';
		document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('amount'+i).value;
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
 var new_sql = "SELECT STOCK_ID, STOCK_CODE_2, BARCOD FROM STOCKS WHERE (BARCOD = '"+barcode+"')";
 var get_product = wrk_query(new_sql,'dsn1');
 if (get_product.STOCK_ID == undefined)
 {
  ekle = 1;
  cikar = 1;
  alert('Ürün Bulunamadı');
 }
 else
 {
  stockid = get_product.STOCK_ID;
  stockcode = get_product.STOCK_CODE_2;
  barcode = get_product.BARCOD;
  var max_spec = "SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = "+stockid+" AND  SPECT_STATUS=1";
  var get_spec_ = wrk_query(max_spec,'dsn3');
  if(get_spec_.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
  var SPECT_MAIN_ID = get_spec_.SPECT_MAIN_ID; else var SPECT_MAIN_ID ='';
  spectmainid = SPECT_MAIN_ID;
  buton_kontrol();
 }
}

function del_amount()
{
  for(i=1;i<=row_count;i++)
  {
	  if(document.getElementById('stockid'+i).value == stockid)
	  {
		 if (document.getElementById('amount'+i).value > document.getElementById('del_other_amount').value)
		 {
		  	document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - amount;
			cikar = 1;
		 }
	  }
  }
}

function del_row(barcode)
{
  get_stock(barcode);
  amount = ''; amount = document.getElementById('del_other_amount').value;
  if (cikar == 0)
  {
  	del_amount();
  }
  if (cikar == 0)
  {
	  for(i=1;i<=row_count;i++)
	  {
		  if(document.getElementById('stockid'+i).value == stockid)
		  {
			 if (document.getElementById('amount'+i).value <= document.getElementById('del_other_amount').value)
			 {
				//////alert(document.getElementById('amount'+i).value+'---'+i);
				//document.getElementById('table1').deleteRow(i-1);
				document.getElementById('frm_row'+i).style.display='none';
		  		document.getElementById('amount'+i).value = '0';
				//row_count--;
			 }
		  }
	  }
  }
  else
  {
	 cikar = 0;
  }
}

function add_amount()
{
  for(i=1;i<=row_count;i++)
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

function add_row(barcode)
{
  get_stock(barcode);
  amount = ''; amount = document.getElementById('add_other_amount').value;
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
	newCell.innerHTML = '<input type="hidden" value="'+stockid+'" name="stockid'+row_count+'" id="stockid'+row_count+'" /><input type="hidden" value="'+spectmainid+'" name="spectmainid'+row_count+'" id="spectmainid'+row_count+'" /><input type="text" value="'+barcode+'" name="barcod'+row_count+'" id="barcod'+row_count+'" size="13" class="boxtext" readonly="yes" />';
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input type="text" value="'+stockcode+'" name="stockcode'+row_count+'" id="stockcode'+row_count+'" size="23" class="boxtext" readonly="yes" />';
	newCell = newRow.insertCell();
	newCell.innerHTML = '<input type="text" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="3" class="boxtext" readonly="yes" />';
  }
  else
  {
	 ekle = 0;
  }
}
</script>

<script language="JavaScript">
document.onkeydown = checkKeycode
function checkKeycode(e) {
var keycode;
if (window.event) keycode = window.event.keyCode;
else if (e) keycode = e.which;
//alert("keycode: " + keycode);
if (keycode == 13)
	{
		if ((document.getElementById('add_other_barcod').value.length == 13) && (islemtipi==0))
		{
			add_row(document.getElementById('add_other_barcod').value);
			document.getElementById('add_other_barcod').value = '';
			document.getElementById('add_other_amount').value = '1';
			document.getElementById('add_other_barcod').focus();
		}
		else if ((document.getElementById('del_other_barcod').value.length == 13) && (islemtipi==1))
		{
			del_row(document.getElementById('del_other_barcod').value);
			document.getElementById('del_other_barcod').value = '';
			document.getElementById('del_other_amount').value = '1';
			document.getElementById('del_other_barcod').focus();
		}
		else
		{
			alert('Barcod Hatalı');
			document.getElementById('add_other_barcod').value = '';
			document.getElementById('add_other_barcod').focus();
		}
	}
}
</script>
<script language="javascript" type="text/javascript">
		function onay()
		{
			var cevap = confirm('<cf_get_lang_main no="123.Kaydetmek istediğinizden eminmisiniz.">');
			if (cevap == true)
			{
				actionidolustur();
				//alert('kaydedildi');
				kabul();
			}
			else
				red();
		}
		function kabul()
		{
			//alert('AjaxPageLoad');
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=pda.add_stok_fis&department_in='+document.getElementById('department_in').value+'&action_id='+document.getElementById('action_id').value;
		}
		function red()
		{
		//	alert('kaydedilmedi');
		}

		function kontrol_kayit()
		{
			if(form_basket.txt_department_in.value == "")
			{
				alert('Depo Seçmelisiniz.');
				return false;
			}
			else if(form_basket.txt_department_in.value.indexOf('-') == -1)
			{
				alert('Lütfen giriş için doğru depo seçiniz.');
				return false;
			}
			else
			{
				return true;
			}
		}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
