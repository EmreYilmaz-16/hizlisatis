<cf_get_lang_set module_name="stock">
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<script language="javascript" type="text/javascript">
  var row_count = 0;
  var barcod = '';
  var stockid = '';
  var spectmain = '';
  var stockcode = '';
  var amount = '';
  var ekle = 0;
  var cikar = 0;
  var islemtipi = 0;//0-ekle 1-çıkar
  var buton = 0;// <1-buton pasif, >0-buton aktif
</script>
<cfparam name="attributes.deliver_paper_no" default="">
<cfparam name="attributes.ship_id" default="">
<cfquery name="get_belge_no" datasource="#dsn3#">
	SELECT     
    	TOP (1) EP.PACKING_NO
	FROM         
    	PRTOTM_PACKING AS EP INNER JOIN
        PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID
	ORDER BY 
    	EP.PACKING_NO DESC
</cfquery>
<cfif get_belge_no.recordcount>
	<cfset belge_no = get_belge_no.PACKING_NO + 1>  
<cfelse>
	<cfset belge_no = '10000001'>
</cfif>
<cfif attributes.type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
         	(
            SELECT     
            	SUM(EPR.AMOUNT) AS CONTROL_AMOUNT
			FROM         
            	PRTOTM_PACKING AS EP INNER JOIN
               	PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID
			WHERE     
            	EP.TYPE = 1 AND 
                EPR.STOCK_ID = TBL.PAKET_ID AND 
                EP.SHIP_RESULT_ID = TBL.SHIP_RESULT_ID
        	) AS CONTROL_AMOUNT
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
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),0) 
                    END 
                        AS PAKET_SAYISI, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID
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
                    ESRR.ORDER_ROW_ID
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
<cfelse>
   	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            (
            SELECT     
            	SUM(EPR.AMOUNT) AS CONTROL_AMOUNT
			FROM         
            	PRTOTM_PACKING AS EP INNER JOIN
               	PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID
			WHERE     
            	EP.TYPE = 2 AND 
                EPR.STOCK_ID = TBL.PAKET_ID AND 
                EP.SHIP_RESULT_ID = TBL.SHIP_RESULT_ID
          	) AS CONTROL_AMOUNT, 
            SHIP_RESULT_ID
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
                        	round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI),0) 
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
<cfquery name="get_detail_package_list" dbtype="query">
	SELECT * FROM GET_SHIP_PACKAGE_LIST WHERE CONTROL_AMOUNT > 0
</cfquery>
<cfquery name="get_total_control" dbtype="query">
	SELECT sum(CONTROL_AMOUNT) as CONTROL_AMOUNT, sum(PAKETSAYISI) PAKETSAYISI FROM GET_SHIP_PACKAGE_LIST
</cfquery>
<cfif not len(get_total_control.CONTROL_AMOUNT)>
	<cfset get_total_control.CONTROL_AMOUNT = 0 >
</cfif>
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset stock_id_list = ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')>
<table cellpadding="2" cellspacing="1" align="left" class="color-border">
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=pda.popup_add_shipping_package&SHIP_ID=#attributes.ship_id#&type=#attributes.type#</cfoutput>">
	<tr class="color-list">
		<td colspan="6">
            <table cellpadding="2" cellspacing="1" width="99%">
                <tr>
                    <td nowrap="nowrap"><b>Paket No :</b></td>
                    <td nowrap="nowrap"><input id="packet_number" class="boxtext" readonly name="packet_number" type="text" value="<cfoutput>#belge_no#</cfoutput>" style="width:60px;" ></td>
                    <td nowrap="nowrap"><b>Sevk No :</b></td>
                    <td nowrap="nowrap"><cfoutput>#attributes.deliver_paper_no#</cfoutput></td>
              	</tr>
                <tr>
                    <td nowrap="nowrap"><b>Miktar</b></td>
                    <td nowrap="nowrap"><strong><input name="add_other_amount" type="text" readonly="yes" value="<cfoutput>#TlFormat(attributes.add_other_amount,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:60px;"></strong></td>
                    <td nowrap="nowrap"><b>Ekle</b></td>                     
                    <td nowrap="nowrap"><input name="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,add_other_amount.value,1);}" style="width:120px;"></td>
                </tr>
            </table>
		</td>
	</tr>
   	<tr class="color-list" height="20px">
    	<td width="45px">Barkod</td>
    	<td>Kod</td>
        <td width="25px">Miktar</td>
        <td width="25px">Paketli</td>
        <td width="25px">İşlem</td>
        <td width="25px">OK</td>
    </tr>    
	<cfset product_barcode_list = ''>
	<input type="hidden" name="stock_id_list" value="<cfoutput>#stock_id_list#</cfoutput>">
	<cfoutput query="GET_SHIP_PACKAGE_LIST">
        <cfquery name="get_product_info" datasource="#dsn3#">
            SELECT  	PIP.PROPERTY7, 
                        PIP.PROPERTY13,
                        S.STOCK_CODE_2
            FROM       	STOCKS AS S LEFT OUTER JOIN
                        PRODUCT_INFO_PLUS AS PIP ON S.PRODUCT_ID = PIP.PRODUCT_ID
            WHERE     	(S.STOCK_ID = #STOCK_ID#)
        </cfquery>
        <tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>
                #BARCOD#
                <script language="javascript" type="text/javascript">
                    <cfoutput>var product_name#stock_id# = '#product_name#';
                              var barkot#stock_id# = '#barcod#';
                    </cfoutput>
                </script>
            </td>
           	<td>#product_name#</td>        
                <input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="box" style="width:100;">
                <cfquery name="GET_BARCODE" datasource="#DSN3#">
                    SELECT TOP 1 BARCODE FROM  STOCKS_BARCODES WHERE STOCK_ID=#STOCK_ID#
                </cfquery>
                <cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,ValueList(GET_BARCODE.BARCODE),','))>
            	
            <td><input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="box" style="width:25px;text-align:right;"></td>
            <td>
            	<input type="text" id="packed_amount#STOCK_ID#" name="packed_amount#STOCK_ID#" readonly="yes" value="#Tlformat(CONTROL_AMOUNT,0)#" class="box"  style="width:25px;text-align:right;color:FF0000;">
            </td>
            <td>
                <input type="text" id="control_amount#STOCK_ID#" name="control_amount#STOCK_ID#" readonly="yes" value="#Tlformat(0,0)#" class="box"  style="width:25px;text-align:right;color:FF0000;">
          	</td>
            <td align="center" valign="middle">      
                <!---<div style="position:absolute; width:15;" align="right">--->
                <img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
                <img id="warning_#STOCK_ID#" name="warning_#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') eq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\warning.gif">
                <img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
                <!---</div>--->
            </td>
        </tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	<tr class="color-list">
		<td colspan="6" align="right"><input type="button" value="<cfif not get_detail_package_list.recordcount>Kaydet<cfelse>Güncelle</cfif>" onClick="if(confirm('Kaydetmek İstediğinizden Eminmisiniz?')) kontrol(); else return false;"></td><!--- <cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'> --->
	</tr>
	</form>
</table>
<script language="javascript">
setTimeout("document.getElementById('add_other_barcod').select();",1000);	
function add_product_to_barkod(barcode,amount,is_type)
{	
	<cfoutput>
	var ship_id = #attributes.ship_id#;
	var type = #attributes.type#;
	</cfoutput>
	var uzunluk = barcode.length;
	if(uzunluk > 14)
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
		var lot_sql = "SELECT TOP (1) SHIP_RESULT_ID FROM PRTOTM_SHIPPING_BARCOD WHERE SHIP_RESULT_ID ="+ship_id+"  AND type ="+type+"  AND LOT_NO = '"+lot_number+"' AND BARCOD = '"+barcode+"'";
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
		barcode = barcode.substring(1,14);
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
				if(is_type==1)//ekleme ise
				{		
					
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) > filterNum(document.getElementById('amount'+get_product.STOCK_ID).value,3))
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+' Ürününde Fazla Çıkış Var');
					else
					{
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value))+parseFloat(amount)),3);
					}
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
						document.getElementById('row'+get_product.STOCK_ID).style.display='none';
				}			
				else if(is_type==0)//silme ise	
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
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
