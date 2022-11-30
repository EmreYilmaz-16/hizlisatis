<cfsetting showdebugoutput="yes">
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
    	SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            ISNULL(
                	(
                   	SELECT     
                    	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                  	FROM         
                    	workcube_rendimobilya_2015_1.dbo.PRTOTM_SHIP_PACKAGE_LIST
                   	WHERE     
                     	STOCK_ID = TBL1.PAKET_ID AND 
                     	SHIP_ID = TBL1.SHIP_ID
                 	)
           		, 0) AS CONTROL_AMOUNT,
            SHIP_ID
		FROM         
        	(
            SELECT     
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_ID
			FROM         
            	(
                	SELECT     
                    	CASE 
                        	WHEN 
                            	S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                          	THEN 
                            	S.PRODUCT_TREE_AMOUNT 
                     		ELSE 
                            	round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI), 0) 
                     	END AS PAKET_SAYISI, 
                        EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                    	SI.SHIP_ID
                 	FROM          
                       	STOCKS AS S INNER JOIN
                     	PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                     	workcube_rendimobilya_2015_1.dbo.SHIP_ROW AS SIR INNER JOIN
                     	workcube_rendimobilya_2015_1.dbo.SHIP AS SI ON SIR.SHIP_ID = SI.SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
                	WHERE      
                    	SI.SHIP_ID = #attributes.ship_id#
             		GROUP BY 
                    	EPS.PAKET_ID, 
                        S.BARCOD, 
                        S.STOCK_CODE, 
                        S.PRODUCT_NAME, 
                        S.PRODUCT_TREE_AMOUNT, 
                        SIR.SHIP_ROW_ID, 
                        SI.SHIP_ID
                   	) AS TBL
				GROUP BY 
                	PAKET_ID, BARCOD, STOCK_CODE, PRODUCT_NAME, PRODUCT_TREE_AMOUNT, SHIP_ID
       		) AS TBL1
</cfquery>
<cfquery name="get_url" datasource="#dsn2#">
	SELECT
    	DELIVER_STORE_ID,
        LOCATION
    FROM
    	SHIP
    WHERE
    	SHIP_ID = #attributes.ship_id#
</cfquery>
<!---<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>--->
<cfquery name="get_detail_package_list" dbtype="query">
	SELECT 
    	SUM(CONTROL_AMOUNT) AS CONTROLAMOUNT,
        SUM(PAKETSAYISI ) AS PAKETSAYISI
   	FROM
    	GET_SHIP_PACKAGE_LIST	 
</cfquery>
<cfset stock_id_list = ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')>
<table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=pda.popup_add_ship_package_store&SHIP_ID=#URLDecode(URL.ship_id)#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#</cfoutput>">
	<tr class="color-list">
		<td colspan="4">
		<table cellpadding="2" cellspacing="1" width="98%">
            <tr height="20px">
            	<td colspan="4">
					<b>İrsaliye No : <cfoutput>#URLDecode(URL.belge_no)#</cfoutput></b>&nbsp;&nbsp;
                    <b>Ok: <cfoutput><input type="text" name="total_control_amount" readonly="readonly" class="box"  style="width:25px;text-align:right;color:FF0000; font-weight:bold" id="total_control_amount" value="#get_detail_package_list.CONTROLAMOUNT#" /> / #get_detail_package_list.PAKETSAYISI#</b></cfoutput>
                </td>
           	</tr>
			<tr>
				<td>Miktar</td>
				<td><strong><input name="add_other_amount" type="text" readonly="yes" value="<cfoutput>#TlFormat(attributes.add_other_amount,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:40px;"></strong></td>
				<td nowrap="nowrap">Ekle</td>                     
				<td><input name="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,add_other_amount.value,1);}" style="width:120px;"></td>
			</tr>
		</table>
		</td>
	</tr>
   	<tr class="color-list" height="20px">
    	<!---<td width="45px">Barkod</td>--->
    	<td>Ürün</td>
        <td width="25px">Miktar</td>
        <td width="25px">Kontrol</td>
        <td width="25px">OK</td>
    </tr>    
	<cfset product_barcode_list = ''>
	<input type="hidden" name="stock_id_list" value="<cfoutput>#stock_id_list#</cfoutput>">
	<cfoutput query="GET_SHIP_PACKAGE_LIST">
		<tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <!---<td>#BARCOD#</td>--->
            <td>#PRODUCT_NAME#</td>        
			<input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="box" style="width:100;">
			<cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,BARCOD))>	
            <td>
            	<input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="box" style="width:25px;text-align:right;">
			</td>
            <td>
            <input type="text" name="control_amount#STOCK_ID#" id="control_amount#STOCK_ID#" readonly="yes" value="#Tlformat(CONTROL_AMOUNT,0)#" class="box"  style="width:25px;text-align:right;color:FF0000;">
			<!---<div style="position:absolute; width:15;" align="right">--->
            <td>
                <img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif CONTROL_AMOUNT eq 0 or (CONTROL_AMOUNT neq 0 and control_amount neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
                <img id="warning_#STOCK_ID#" name="warning_#STOCK_ID#"<cfif CONTROL_AMOUNT eq 0 or (CONTROL_AMOUNT neq 0 and control_amount eq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\warning.gif">
                <img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif CONTROL_AMOUNT eq 0 or (CONTROL_AMOUNT neq 0 and control_amount lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
			<!---</div>--->
			</td>
	</tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	<tr class="color-list">
		<td colspan="5" align="right"><input type="button" value="<cfif not get_detail_package_list.CONTROLAMOUNT gt 0>Kaydet<cfelse>Güncelle</cfif>" onClick="if(confirm('Kaydetmek İstediğinizden Eminmisiniz?')) kontrol(); else return false;"></td><!--- <cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'> --->
	</tr>
	</form>
</table>
<script language="javascript">
setTimeout("document.getElementById('add_other_barcod').select();",1000);	
function add_product_to_barkod(barcode,amount,type)
{	
	<cfoutput>
		var ship_id = #attributes.ship_id#;
	</cfoutput>
	var uzunluk = barcode.length;
	if(uzunluk > 9)
	{
		if(barcode.substr(0,1)=='j')//Bazı barkod okuyucular okuduktan sonra başına j harfi koyuyor kontrol için yapıldı
		{
			lot_number = barcode.substring(1,9);
			barcode = barcode.substring(9,17);
		}
		else
		{
		lot_number = barcode.substring(0,8);
		barcode = barcode.substring(8,16);	
		}
		var lot_sql = "SELECT TOP (1) SHIP_RESULT_ID FROM PRTOTM_SHIP_BARCOD WHERE SHIP_RESULT_ID ="+ship_id+"  AND IS_TYPE ="+is_type+"  AND LOT_NO = '"+lot_number+"' AND BARCOD = '"+barcode+"'";
		var get_lot_number = wrk_query(lot_sql,'dsn2');
		var uzunluk_lot = get_lot_number.SHIP_RESULT_ID;
		if(uzunluk_lot === undefined)
		{
		alert('Bu Ürün Bu Sevkiyata Ait Değildir.!!!');
		return false;
		}
	}
	else
	{
		if(barcode.substr(0,1)=='j')//Bazı barkod okuyucular okuduktan sonra başına j harfi koyuyor kontrol için yapıldı
		{
		barcode = barcode.substring(1,9);
		}
	}
	var amount = filterNum(amount,3)
	if(list_find('<cfoutput>#product_barcode_list#</cfoutput>',barcode,','))
	{
		var new_sql = "SELECT TOP 1 STOCK_ID FROM STOCKS_BARCODES WHERE BARCODE = '"+barcode+"'";
		var get_product = wrk_query(new_sql,'dsn1');
			if(document.getElementById('control_amount'+get_product.STOCK_ID)==undefined)
				alert('Ürünün Barkodlarında Sorun Var.')		
			else
			{
				if(document.all.changed_stock_id.value != "")//daha önceden bir satır eklenmişse alan dolmuş demektir ve yeni eklenecek alan için satırı renklendiyoruz bir alt satırda
					eval('row'+document.all.changed_stock_id.value).style.background='<cfoutput>#colorrow#</cfoutput>';
				if(type==1)//ekleme ise
				{		
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+' Ürününde Fazla Çıkış Var');
					else
					{
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value))+parseFloat(amount)),3);
						document.all.total_control_amount.value=commaSplit(parseFloat(parseFloat(filterNum(document.all.total_control_amount.value))+parseFloat(amount)),0);
					}
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
						document.getElementById('row'+get_product.STOCK_ID).style.display='none';
				}			
				else if(type==0)//silme ise	
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == 0 || filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) < 0)
						alert('Çıkan Ürünlerin Sayısı 0 dan küçük olamaz');
					else		
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value))-parseFloat(amount)),3);
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='none';}	
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) > document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='';}
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) < document.getElementById('amount'+get_product.STOCK_ID).value)
								eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
			document.all.add_other_barcod.value='';
			/*document.all.del_other_barcod.value='';*/
			document.all.changed_stock_id.value = get_product.STOCK_ID;
			eval('row'+get_product.STOCK_ID).style.background='FFCCCC';
			}	
		}
	else
		alert('Kayıtlı Barkod Yok!')
}

function kontrol()
{

	for(i=1;i<=<cfoutput>#listlen(stock_id_list,',')#</cfoutput>;i++)
	{
		eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value = filterNum(eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value,3)
	}
	document.add_package.submit();
}
</script>