<cfsetting showdebugoutput="yes">
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
    	SELECT
        	CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN 
                	PRODUCT_TREE_AMOUNT
               	ELSE
            		PAKETSAYISI
           	END 
            	AS PAKETSAYISI,
            CONTROL_AMOUNT,
            STOCK_ID,
            BARCOD,
            STOCK_CODE,
            PRODUCT_NAME
        FROM
            (
            SELECT
                SUM(PAKET_SAYISI) PAKETSAYISI,
                ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT,
                PAKET_ID STOCK_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT
            FROM
                (      
                SELECT     
                    SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) AS PAKET_SAYISI, 
                    TBL_1.CONTROL_AMOUNT, 
                    ESRR.SHIP_RESULT_ROW_ID, 
                    ORR.STOCK_ID AS MODUL_STOCK_ID, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT
                FROM  
                    PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                    PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID LEFT OUTER JOIN
                    (
                    SELECT     
                        SHIPPING_ID, 
                        STOCK_ID, 
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM          
                        PRTOTM_SHIPPING_PACKAGE_LIST
                    WHERE      
                        TYPE = 1
                    GROUP BY 
                        SHIPPING_ID, 
                        STOCK_ID
                    ) AS TBL_1 ON EPS.PAKET_ID = TBL_1.STOCK_ID AND ESR.SHIP_RESULT_ID = TBL_1.SHIPPING_ID
                WHERE     
                    ESR.SHIP_RESULT_ID = #attributes.ship_id# AND
                    ORR.STOCK_ID = #attributes.f_stock_id#
                GROUP BY 
                    EPS.PAKET_ID, 
                    TBL_1.CONTROL_AMOUNT, 
                    ESRR.SHIP_RESULT_ROW_ID, 
                    ORR.STOCK_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT
                ) TBL_3
            GROUP BY
                PAKET_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT
    		) AS TBL_4
    </cfquery>
<cfelse>
	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
    	SELECT
        	CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN 
                	PRODUCT_TREE_AMOUNT
               	ELSE
            		PAKETSAYISI
           	END 
            	AS PAKETSAYISI,
            CONTROL_AMOUNT,
            STOCK_ID,
            BARCOD,
            STOCK_CODE,
            PRODUCT_NAME
        FROM
            (
            SELECT
                SUM(PAKET_SAYISI) PAKETSAYISI,
                ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT,
                PAKET_ID STOCK_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT
            FROM
                (      
                SELECT     
                    TBL_1.CONTROL_AMOUNT, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    SIR.SHIP_ROW_ID, 
                    SIR.AMOUNT * EPS.PAKET_SAYISI AS PAKET_SAYISI, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT
                FROM         
                    (
                    SELECT     
                        SHIPPING_ID, 
                        STOCK_ID, 
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM          
                        PRTOTM_SHIPPING_PACKAGE_LIST
                    WHERE      
                        TYPE = 2
                    GROUP BY 
                        SHIPPING_ID, 
                        STOCK_ID
                    ) TBL_1 RIGHT OUTER JOIN
                    PRTOTM_PAKET_SAYISI AS EPS INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID ON 
                    TBL_1.SHIPPING_ID = SIR.DISPATCH_SHIP_ID AND TBL_1.STOCK_ID = EPS.PAKET_ID
                WHERE     
                    SI.DISPATCH_SHIP_ID = #attributes.ship_id# AND
                    SIR.STOCK_ID = #attributes.f_stock_id#
                GROUP BY 
                    EPS.PAKET_ID, 
                    TBL_1.CONTROL_AMOUNT, 
                    S.BARCOD, 
                    SIR.SHIP_ROW_ID, 
                    SIR.AMOUNT, 
                    EPS.PAKET_SAYISI, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT
                ) TBL_3
            GROUP BY
                PAKET_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT
         	) AS TBL_4       
    </cfquery>
</cfif>
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
<cfquery name="get_detail_package_list" dbtype="query">
	SELECT * FROM GET_SHIP_PACKAGE_LIST WHERE CONTROL_AMOUNT > 0
</cfquery>
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset stock_id_list = ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')>
<table cellpadding="2" cellspacing="1" align="left" class="color-border">
	    <tr>
  <td colspan="4">
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  
  </td>
  </tr>
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=epda.prtotm_qadd_shipping_package_stock&SHIP_ID=#URLDecode(URL.ship_id)#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&f_stock_id=#attributes.f_stock_id#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#</cfoutput>">
	<tr class="color-list">
		<td colspan="5">
		<table cellpadding="2" cellspacing="1" width="100%">
			<tr>
            	<td colspan="5">
            		<table class="color-border">
                    	<tr class="color-list">
                        	<td><b>Ürün :<cfoutput>#product_name#</cfoutput></b></td>
            			</tr>
            		</table>
            	</td>
            </tr>
			<tr>
				<td>Miktar</td>
				<td><strong><input name="add_other_amount" type="text" value="<cfoutput>#TlFormat(attributes.add_other_amount,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:35px;"></strong></td>
				<td nowrap="nowrap">Ekle</td>                     


				<td><input name="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,add_other_amount.value,1);}" style="width:100px;"></td>
			</tr>
		</table>
		</td>
	</tr>
   	<tr class="color-list" height="20px">
    	<td width="45px">Barkod</td>
    	<td>Kod</td>
        <td width="25px">Miktar</td>
        <td width="25px">Kontrol</td>
        <td width="25px">OK</td>
    </tr>
	<cfset product_barcode_list = ''>
    <input type="hidden" name="f_stock_id" value="#f_stock_id#"/>
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
    <tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" valign="top">
		<td>
            <cfquery name="GET_BARCODE" datasource="#DSN3#">
				SELECT TOP 1 BARCODE FROM  STOCKS_BARCODES WHERE STOCK_ID=#STOCK_ID#
			</cfquery>
				#GET_BARCODE.BARCODE#
            <script language="javascript" type="text/javascript">
				<cfoutput>var product_name#stock_id# = '#product_name#';
						  var barkot#stock_id# = '#get_barcode.barcode#';
				</cfoutput>
			</script>
			<td>
            <!---#get_product_info.STOCK_CODE_2#-#get_product_info.PROPERTY7#/#get_product_info.PROPERTY13#--->
            	#product_name#
            </td>
            <input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="box" style="width:20px;">
			<cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,ValueList(GET_BARCODE.BARCODE),','))>	
            <td ><strong>
            <input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="box" style="width:20px;text-align:right;"></strong></td>
            <td ><strong>
          <input type="text" name="control_amount#STOCK_ID#" id="control_amount#STOCK_ID#" value="<cfif isdefined('control_amount#STOCK_ID#')>
            #Tlformat(Evaluate('control_amount#STOCK_ID#'),0)# <cfelse>#0#</cfif>" class="box" style="width:20px;text-align:right;color:FF0000;"></strong></td>
            <td>
            <img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
			<img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
			</td>
	</tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	<tr class="color-list">
		<td colspan="5" align="right"><input type="button" value="<cfif not get_detail_package_list.recordcount>Kaydet<cfelse>Güncelle</cfif>" onClick="if(confirm('Kaydetmek İstediğinizden Eminmisiniz?')) kontrol(); else return false;"></td><!--- <cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'> --->
	</tr>
	</form>
</table>
<script language="javascript">
setTimeout("document.getElementById('add_other_barcod').select();",1000);	
function add_product_to_barkod(barcode,amount,type)
{
	if(barcode.substr(0,1)=='j')//Bazı barkod okuyucular okuduktan sonra başına j harfi koyuyor kontrol için yapıldı
	{
	barcode = barcode.substring(1,9);
	}
	var amount = filterNum(amount,3)
	if(list_find('<cfoutput>#product_barcode_list#</cfoutput>',barcode,','))
	{
		var new_sql = "SELECT TOP 1 STOCK_ID FROM STOCKS_BARCODES WHERE BARCODE = '"+barcode+"'";
		var get_product = wrk_query(new_sql,'dsn1');
		//alert(document.getElementById('control_amount'+get_product.STOCK_ID));
			if(document.getElementById('control_amount'+get_product.STOCK_ID)==undefined)
				alert(barcode +' Nolu Ürünün Barkodlarında Sorun Var.')		
			else
			{
				if(document.all.changed_stock_id.value != "")//daha önceden bir satır eklenmişse alan dolmuş demektir ve yeni eklenecek alan için satırı renklendiyoruz bir alt satırda
					eval('row'+document.all.changed_stock_id.value).style.background='<cfoutput>#colorrow#</cfoutput>';
				if(type==1)//ekleme ise
				{		
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+' Ürününde Fazla Çıkış Var');
					else
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value))+parseFloat(amount)),3);	
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