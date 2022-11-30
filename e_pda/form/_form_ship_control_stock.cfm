<cfsetting showdebugoutput="yes">
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn1#">
    SELECT
    	BARCOD,
        STOCK_CODE,
        STOCK_CODE_2,
        PRODUCT_NAME,
        SUM(PAKETSAYISI) AS PAKETSAYISI,
        STOCK_ID
	FROM
    	(SELECT
        	STOCKS.STOCK_CODE,
            STOCKS.STOCK_CODE_2,
            PRODUCT.BARCOD,
            PRODUCT.PRODUCT_NAME,
            DERIVEDTBL_4.PAKETSAYISI,
            STOCKS.STOCK_ID, 
        	1 AS KADEME
        FROM
        	STOCKS RIGHT OUTER JOIN
            PRODUCT ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID RIGHT OUTER JOIN
            (SELECT
            	DERIVEDTBL_3.SHIP_ID,
                SUM(DERIVEDTBL_3.AMOUNT * #dsn3_alias#.PRODUCT_TREE.AMOUNT) AS PAKETSAYISI,
                #dsn3_alias#.PRODUCT_TREE.RELATED_ID
            FROM
            	PRODUCT AS PRODUCT_7 INNER JOIN
                (SELECT
                	#dsn2_alias#.SHIP_ROW.SHIP_ID, 
                    #dsn2_alias#.SHIP_ROW.AMOUNT * KARMA_PRODUCTS.PRODUCT_AMOUNT AS AMOUNT, 
                    KARMA_PRODUCTS.PRODUCT_ID
                 FROM
                 	KARMA_PRODUCTS RIGHT OUTER JOIN
                    PRODUCT AS PRODUCT_1 ON 
                   	KARMA_PRODUCTS.KARMA_PRODUCT_ID = PRODUCT_1.PRODUCT_ID RIGHT OUTER JOIN
                    #dsn2_alias#.SHIP_ROW ON 
                    PRODUCT_1.PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
                 WHERE
                 	(#dsn2_alias#.SHIP_ROW.SHIP_ID = #ship_id#) AND (#dsn2_alias#.SHIP_ROW.STOCK_ID = #f_stock_id#) AND
                    (PRODUCT_1.IS_KARMA = 1)) AS DERIVEDTBL_3 ON PRODUCT_7.PRODUCT_ID = DERIVEDTBL_3.PRODUCT_ID LEFT OUTER JOIN
                    #dsn3_alias#.PRODUCT_TREE RIGHT OUTER JOIN
                    STOCKS AS STOCKS_5 ON #dsn3_alias#.PRODUCT_TREE.STOCK_ID = STOCKS_5.STOCK_ID ON 
                    DERIVEDTBL_3.PRODUCT_ID = STOCKS_5.PRODUCT_ID
          	WHERE
            	(PRODUCT_7.PACKAGE_CONTROL_TYPE = 2) AND
                #dsn3_alias#.PRODUCT_TREE.RELATED_ID IN (
                										SELECT     
                                                         	STOCK_ID
                                                        FROM          
                                                           	#dsn3_alias#.STOCKS
                                                        WHERE      
                                                           	STOCK_CODE LIKE N'01.151.01.01%' OR STOCK_CODE LIKE N'01.151.02.09%'
                										)
            GROUP BY DERIVEDTBL_3.SHIP_ID,
            #dsn3_alias#.PRODUCT_TREE.RELATED_ID) AS DERIVEDTBL_4 ON 
            STOCKS.STOCK_ID = DERIVEDTBL_4.RELATED_ID
	UNION
    SELECT
    	STOCKS_4.STOCK_CODE,
        STOCKS_4.STOCK_CODE_2,
        PRODUCT_5.BARCOD,
        PRODUCT_5.PRODUCT_NAME,
        DERIVEDTBL_2.PAKETSAYISI,
        STOCKS_4.STOCK_ID, 
        2 AS KADEME
	FROM
    	STOCKS AS STOCKS_4 RIGHT OUTER JOIN
        PRODUCT AS PRODUCT_5 ON STOCKS_4.PRODUCT_ID = PRODUCT_5.PRODUCT_ID RIGHT OUTER JOIN
        (SELECT
        	PRODUCT_TREE_1.RELATED_ID,
            SUM(PRODUCT_TREE_1.AMOUNT * SHIP_ROW_3.AMOUNT) AS PAKETSAYISI
         FROM
         	PRODUCT AS PRODUCT_4 LEFT OUTER JOIN
            #dsn3_alias#.PRODUCT_TREE AS PRODUCT_TREE_1 RIGHT OUTER JOIN
            STOCKS AS STOCKS_3 ON PRODUCT_TREE_1.STOCK_ID = STOCKS_3.STOCK_ID ON 
            PRODUCT_4.PRODUCT_ID = STOCKS_3.PRODUCT_ID RIGHT OUTER JOIN
            #dsn2_alias#.SHIP_ROW AS SHIP_ROW_3 ON 
            PRODUCT_4.PRODUCT_ID = SHIP_ROW_3.PRODUCT_ID
         WHERE
         	(PRODUCT_4.IS_KARMA = 0) AND
            (SHIP_ROW_3.SHIP_ID = #ship_id#) AND (SHIP_ROW_3.STOCK_ID = #f_stock_id#) AND
            (PRODUCT_4.PACKAGE_CONTROL_TYPE = 2) AND
            PRODUCT_TREE_1.RELATED_ID IN (
            								SELECT     
                                             	STOCK_ID
                                           	FROM          
                                              	#dsn3_alias#.STOCKS
                                            WHERE      
                                              	STOCK_CODE LIKE N'01.151.01.01%' OR STOCK_CODE LIKE N'01.151.02.09%'
                						)
    	 GROUP BY PRODUCT_TREE_1.RELATED_ID) AS DERIVEDTBL_2 ON STOCKS_4.STOCK_ID = DERIVEDTBL_2.RELATED_ID
	UNION
	SELECT
    	STOCKS_2.STOCK_CODE,
        STOCKS_2.STOCK_CODE_2,
        PRODUCT_3.BARCOD,
        PRODUCT_3.PRODUCT_NAME,
        SUM(SHIP_ROW_2.AMOUNT) AS AMOUNT,
        STOCKS_2.STOCK_ID, 
        3 AS KADEME
	FROM
    	PRODUCT AS PRODUCT_3 LEFT OUTER JOIN
        STOCKS AS STOCKS_2 ON PRODUCT_3.PRODUCT_ID = STOCKS_2.PRODUCT_ID RIGHT OUTER JOIN
       	#dsn2_alias#.SHIP_ROW AS SHIP_ROW_2 ON PRODUCT_3.PRODUCT_ID = SHIP_ROW_2.PRODUCT_ID
	WHERE
    	(PRODUCT_3.IS_KARMA = 0) AND
        (SHIP_ROW_2.SHIP_ID = #ship_id#) AND (SHIP_ROW_2.STOCK_ID = #f_stock_id#) AND
        (PRODUCT_3.PACKAGE_CONTROL_TYPE = 1)
	GROUP BY
    	STOCKS_2.STOCK_CODE,
        STOCKS_2.STOCK_CODE_2,
        PRODUCT_3.BARCOD,
        PRODUCT_3.PRODUCT_NAME,
        STOCKS_2.STOCK_ID
	UNION
    SELECT
    	STOCKS_1.STOCK_CODE,
        STOCKS_1.STOCK_CODE_2,
        PRODUCT_2.BARCOD,
        PRODUCT_2.PRODUCT_NAME,
        DERIVEDTBL_1.PAKETSAYISI,
        STOCKS_1.STOCK_ID, 
        4 AS KADEME
	FROM
    	PRODUCT AS PRODUCT_2 LEFT OUTER JOIN
        STOCKS AS STOCKS_1 ON PRODUCT_2.PRODUCT_ID = STOCKS_1.PRODUCT_ID RIGHT OUTER JOIN
       	(SELECT
        	KARMA_PRODUCTS_1.PRODUCT_ID,
            SUM(SHIP_ROW_1.AMOUNT * KARMA_PRODUCTS_1.PRODUCT_AMOUNT) AS PAKETSAYISI
         FROM
         	KARMA_PRODUCTS AS KARMA_PRODUCTS_1 RIGHT OUTER JOIN
            PRODUCT AS PRODUCT_1 ON KARMA_PRODUCTS_1.KARMA_PRODUCT_ID = PRODUCT_1.PRODUCT_ID RIGHT OUTER JOIN
            #dsn2_alias#.SHIP_ROW AS SHIP_ROW_1 ON 
            PRODUCT_1.PRODUCT_ID = SHIP_ROW_1.PRODUCT_ID
         WHERE
         	(PRODUCT_1.IS_KARMA = 1) AND
            (SHIP_ROW_1.SHIP_ID = #ship_id#) AND (SHIP_ROW_1.STOCK_ID = #f_stock_id#)
       	 GROUP BY 
        	KARMA_PRODUCTS_1.PRODUCT_ID) AS DERIVEDTBL_1 ON 
            PRODUCT_2.PRODUCT_ID = DERIVEDTBL_1.PRODUCT_ID
   	WHERE
    	(PRODUCT_2.PACKAGE_CONTROL_TYPE = 1)) AS DERIVEDTBL
	GROUP BY
    	BARCOD,
        STOCK_CODE,
        STOCK_CODE_2,
        PRODUCT_NAME,
        STOCK_ID
    ORDER BY
		STOCK_CODE_2
</cfquery>
<cfquery name="get_detail_package_list" datasource="#dsn2#">
	SELECT 
		STOCK_ID,
		CONTROL_AMOUNT
	FROM 
		PRTOTM_SHIP_PACKAGE_LIST
	WHERE
		SHIP_ID = #URLDecode(URL.ship_id)# AND REF_STOCK_ID=#f_stock_id#
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
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset stock_id_list = ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')>
<table cellpadding="2" cellspacing="1" align="left" class="color-border">
<form name="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=pda.popup_add_ship_package_stock&SHIP_ID=#URLDecode(URL.ship_id)#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&f_stock_id=#f_stock_id#</cfoutput>">
	<tr class="color-list">
		<td colspan="5">
		<table cellpadding="2" cellspacing="1" width="75%">
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
    	<td width="70px">Kod</td>
        <td width="25px">Miktar</td>
        <td width="25px">Kntrl</td>
        <td width="15px">OK</td>
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
            #get_product_info.STOCK_CODE_2#-#get_product_info.PROPERTY7#/#get_product_info.PROPERTY13#
            </td>
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