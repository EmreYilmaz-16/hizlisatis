<cfset colorrow="red">
<cfsetting showdebugoutput="no">
<cfquery name="get_url" datasource="#dsn#">
	SELECT     
    	E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ADI
	FROM         
    	WRK_SESSION AS W INNER JOIN
     	EMPLOYEES AS E ON W.USERID = E.EMPLOYEE_ID
	WHERE     
    	W.ACTION_PAGE LIKE '#fuseaction#%' AND 
        W.ACTION_PAGE LIKE N'%ship_id=#attributes.ship_id#%' AND 
        E.EMPLOYEE_ID <> #session.ep.userid#
</cfquery>
<cfif get_url.recordcount>
	<cfset kullanici = get_url.adi>
	<script language="javascript">
		alert('Girmek İstediğiniz Sayfa Kullanılmaktadır');
		history.back();
	</script>
</cfif>
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
         	(
            SELECT     
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
         	FROM          
            	PRTOTM_SHIPPING_PACKAGE_LIST
         	WHERE      
            	TYPE = 1 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
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
                            SUM(ORR.QUANTITY * EPS.PAKET_SAYISI)
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
            	SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
           	FROM          
            	PRTOTM_SHIPPING_PACKAGE_LIST
        	WHERE      
            	TYPE = 2 AND 
                STOCK_ID = TBL.PAKET_ID AND 
                SHIPPING_ID = TBL.SHIP_RESULT_ID
          	) AS CONTROL_AMOUNT, SHIP_RESULT_ID
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
                        	SUM(SIR.AMOUNT * EPS.PAKET_SAYISI)
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
<!---<cfdump expand="yes" var="#GET_SHIP_PACKAGE_LIST#">
<cfabort>--->
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
<style>
table, td, th, div {
    font-size: 13px;
    font-family: 'Roboto', sans-serif !important;
	font-weight: 600;
}
.form-title{
    font-size:13px;
}
</style>
<div style="width:100%">
<table cellpadding="1" cellspacing="1" align="left" class="color-border" width="100%">
	    <tr>
  <td colspan="4">
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  
  </td>
  </tr>
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=epda.prtotm_qadd_shipping_pckg&SHIP_ID=#attributes.ship_id#&department_id=#attributes.department_id#&date1=#attributes.date1#&date2=#attributes.date2#&page=#attributes.page#&kontrol_status=#attributes.kontrol_status#&is_type=#attributes.is_type#</cfoutput>">
	<tr class="color-list">
		<td colspan="4" style="width:100%">
		<table cellpadding="0" cellspacing="1" width="100%">
			<tr height="20px">
            	<td colspan="4">
					<cfif attributes.is_type eq 1><b>Sevk No :</b><cfelse><b>Sevk Talep No :</b></cfif><cfoutput><b>#attributes.DELIVER_PAPER_NO#</cfoutput></b>&nbsp;&nbsp;
                    <b>Ok: <cfoutput><input type="text" name="total_control_amount" readonly="readonly" class="box"  style="width:35px;text-align:right;color:FF0000; font-weight:bold" id="total_control_amount" value="" /> / #get_total_control.PAKETSAYISI#</b></cfoutput>
                </td>
           	</tr>
			<tr>
				<td>Miktar</td>
				<td><strong><input name="add_other_amount" type="text" value="<cfoutput>#attributes.add_other_amount#</cfoutput>" class="moneybox" style="width:40px;"></strong></td>
				<td nowrap="nowrap">Ekle</td>                     
				<td><input name="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,add_other_amount.value,1);}" style="width:120px;"></td>
			</tr>
		</table>
		</td>
	</tr>
   	<tr class="color-list" height="20px">
    	<td>Kod</td>
        <td width="25px">Miktar</td>
        <td width="25px">Kontrol</td>
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
           	<td>#product_name#</td>        
                <input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="box" style="width:100;">
                <cfquery name="GET_BARCODE" datasource="#DSN3#">
                    SELECT TOP 1 BARCODE FROM  STOCKS_BARCODES WHERE STOCK_ID=#STOCK_ID#
                </cfquery>
                <cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,ValueList(GET_BARCODE.BARCODE),','))>	
            <td>
                <input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="box" style="width:25px;text-align:right;">
            </td>
            <td>
                <input type="text" id="control_amount#STOCK_ID#" name="control_amount#STOCK_ID#" readonly="yes" value="<cfif isdefined('control_amount#STOCK_ID#')>#Evaluate('control_amount#STOCK_ID#')#</cfif>" class="box"  style="width:25px;text-align:right;color:FF0000;">
          	</td>
            <td align="center" valign="middle">      
                <img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
                <img id="warning_#STOCK_ID#" name="warning_#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') eq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\warning.gif">
                <img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
            </td>
        </tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	<tr class="color-list">
		<td colspan="4" align="right"><input type="button" value="<cfif not get_detail_package_list.recordcount>Kaydet<cfelse>Güncelle</cfif>" onClick="if(confirm('Kaydetmek İstediğinizden Eminmisiniz?')) kontrol(); else return false;"></td>
	</tr>
	</form>
</table>
</div>
<script language="javascript">
document.getElementById('add_other_barcod').focus();
setTimeout("document.getElementById('add_other_barcod').select();",1000);	
function add_product_to_barkod(barcode,amount,type)
{	
	<cfoutput>
	var ship_id = #attributes.ship_id#;
	var is_type = #attributes.is_type#;
	</cfoutput>
	var uzunluk = barcode.length;
	var amount = amount
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
					if((document.getElementById('control_amount'+get_product.STOCK_ID).value*1)-(amount*-1) > (document.getElementById('amount'+get_product.STOCK_ID).value*1))
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+' Ürününde Fazla Çıkış Var');
					else
					{
						document.getElementById('control_amount'+get_product.STOCK_ID).value = (document.getElementById('control_amount'+get_product.STOCK_ID).value*1)+(amount*1);
						document.all.total_control_amount.value=(document.all.total_control_amount.value*1)+(amount*1);
					}
					if(document.getElementById('control_amount'+get_product.STOCK_ID).value == document.getElementById('amount'+get_product.STOCK_ID).value)
						document.getElementById('row'+get_product.STOCK_ID).style.display='none';
				}			
				else if(type==0)//silme ise	
					if(document.getElementById('control_amount'+get_product.STOCK_ID).value == 0 || document.getElementById('control_amount'+get_product.STOCK_ID).value < 0)
						alert('Çıkan Ürünlerin Sayısı 0 dan küçük olamaz');
					else		
						document.getElementById('control_amount'+get_product.STOCK_ID).value = (document.getElementById('control_amount'+get_product.STOCK_ID).value*1)-(amount*1);
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value == document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='none';}	
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value > document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='';}
							if(document.getElementById('control_amount'+get_product.STOCK_ID).value < document.getElementById('amount'+get_product.STOCK_ID).value)
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
		eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value = eval('document.all.control_amount'+list_getat("<cfoutput>#stock_id_list#</cfoutput>",i,",")).value
	}
	document.add_package.submit();
}
</script>