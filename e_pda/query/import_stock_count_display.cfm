<!--- Sayım yapıldığı andaki stok miktarını FILE_IMPORTS_ROW a yazar, sadece kullanıcıya göstermek içindir
Daha sonra birleştirme ve fiş oluşturma işlemi yapmak için tekrar stok miktarları yazılır  AE20060104
--->
<cf_date tarih='attributes.process_date'>
<cfset get_stock_date = date_add("h",23,attributes.process_date)>
<cfset get_stock_date = date_add("n",59,get_stock_date)>

<cfif not isDefined("session.ep")>
	<cfset upload_folder = "#upload_folder#store#dir_seperator#">
	<cftry>
		<cffile
			action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	//dosya formatı için colum_3,colum_4... tarzı değişkenlerde degerleri tutar formda atlanarak seçebilirler diye döngü ile yazıldı 
	if(isdefined('attributes.add_file_format_1'))
	{
		clm_count=3;//3 cunku formdan eklenen üc alan var simdilik
		for(i=1;i lte 3;i=i+1)
		{
			if(len(evaluate('attributes.add_file_format_#i#')))
			{
				'colum_#clm_count#'=evaluate('attributes.add_file_format_#i#');
				temp_col=evaluate('colum_#clm_count#');
				'#temp_col#_count_colums' = clm_count;//dosyada hangi kolon oldugunu tutar
				clm_count=clm_count+1;
				continue;
			}
		}
	}
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	document_seperator = chr(attributes.seperator_type);
	dosya = Replace(dosya,'#document_seperator#'&'#document_seperator#','#document_seperator# #document_seperator#','all');
	dosya = Replace(dosya,'#document_seperator#'&'#document_seperator#','#document_seperator# #document_seperator#','all');
	dosya1 = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya1);
	barcod_id_list = "";
	//formdan gelen ek degerler icin liste
	if(isdefined('colum_3')) '#colum_3#_list' = '';
	if(isdefined('colum_4')) '#colum_4#_list' = '';
	if(isdefined('colum_5')) '#colum_5#_list' = '';
	
	for(i=1; i lte line_count;i=i+1)
	{
		if( listlen(dosya1[i],'#document_seperator#') lt 2)
		{
			error_flag=1;
			break;
		}
		temp_barcod = trim(listfirst(dosya1[i],'#document_seperator#'));
		temp_miktar = trim(listgetat(dosya1[i],2,'#document_seperator#'));
		if(len(temp_miktar) and Find(",",temp_miktar))
		{
			error_flag=1;
			break;
		}
		if(len(temp_barcod) and not listfind(barcod_id_list,temp_barcod,'#document_seperator#'))
			barcod_id_list = Listappend(barcod_id_list,temp_barcod,'#document_seperator#');
		
		if(isdefined('colum_3') and colum_3 neq 'DELIVER_DATE' and listlen(dosya1[i],'#document_seperator#') gt 2)
		{
			'temp_#colum_3#' = trim(listgetat(dosya1[i],3,'#document_seperator#'));
			if(len(evaluate('temp_#colum_3#')))
				'#colum_3#_list' = Listappend(evaluate('#colum_3#_list'),evaluate('temp_#colum_3#'),'#document_seperator#');
		}
		if(isdefined('colum_4') and colum_4 neq 'DELIVER_DATE' and listlen(dosya1[i],'#document_seperator#') gt 3)
		{
			'temp_#colum_4#' = trim(listgetat(dosya1[i],4,'#document_seperator#'));
			if(len(evaluate('temp_#colum_4#')))
				'#colum_4#_list' = Listappend(evaluate('#colum_4#_list'),evaluate('temp_#colum_4#'),'#document_seperator#');
		}
		if(isdefined('colum_5') and colum_5 neq 'DELIVER_DATE' and listlen(dosya1[i],'#document_seperator#') gt 4)
		{
			'temp_#colum_5#' = trim(listgetat(dosya1[i],5,'#document_seperator#'));
			if(len(evaluate('temp_#colum_5#')))
				'#colum_5#_list' = Listappend(evaluate('#colum_5#_list'),evaluate('temp_#colum_5#'),'#document_seperator#');
		}
	}
</cfscript>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
	<tr><td class="headbold">Stok Sayım Sonuçları (<cfoutput>#form.store#-#dateformat(get_stock_date,'dd/mm/yyyy')#</cfoutput>)</td></tr>
</table>
<cfif isdefined('error_flag') and error_flag eq 1>
	<script type="text/javascript">
		alert('Belgenizin Miktarlarını Kontrol Ediniz !');
		window.history.back();
	</script>
	<cftry>
			<cffile action="delete" file="#upload_folder##file_name#">
		<cfcatch type="Any">Dosya Silinemedi</cfcatch>  
	</cftry>
	<cfabort>
</cfif>
<cfif not listlen(barcod_id_list)>
	<script type="text/javascript">
		alert('Belgenizde '+ <cfif attributes.stock_identity_type eq 1>'Barkod Listesi'<cfelseif attributes.stock_identity_type eq 3>'Özel Kod Listesi'<cfelse>'Stok Kodu Listesi'</cfif>  + ' Bulunamadı. Lütfen Belgenizi Kontrol Ediniz !');
		window.history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_pro_stock_all" datasource="#DSN2#">
	SELECT
		SR.STOCK_IN,
		SR.STOCK_OUT,
	<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
		S.BARCODE,
		S1.STOCK_CODE_2,
		S1.STOCK_CODE,
	<cfelse>
		S.STOCK_CODE_2,
		S.STOCK_CODE,
	</cfif>
		SR.STOCK_ID,
		SR.SPECT_VAR_ID,
		SR.SHELF_NUMBER,
		SR.DELIVER_DATE
	FROM
	<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
		#dsn3_alias#.GET_STOCK_BARCODES S,
		#dsn3_alias#.STOCKS S1,
	<cfelse>
		#dsn3_alias#.STOCKS S,
	</cfif>
		STOCKS_ROW SR
	WHERE
		S.STOCK_ID = SR.STOCK_ID AND
		<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
			S1.STOCK_ID = S.STOCK_ID AND
		</cfif>
		SR.STORE = #attributes.department_id# AND
		SR.PROCESS_DATE <= #get_stock_date#	AND <!--- BK20050705 Sayımdaki tarih sorunu icin eklendi --->
		SR.STORE_LOCATION = #attributes.location_id# AND
	<cfif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 1>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			S.BARCODE = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		)
		<!--- inli yapımadı ayıraç ifade içinde gecebilir diye S.BARCODE IN (#ListQualify(barcod_id_list,"'")#)--->
	<cfelseif isdefined('attributes.stock_identity_type') and attributes.stock_identity_type eq 3>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			S.STOCK_CODE_2 = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		) 
		<!---S.STOCK_CODE_2 IN (#ListQualify(barcod_id_list,"'")#)--->
	<cfelse>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			S.STOCK_CODE = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		)
		<!---S.STOCK_CODE IN (#ListQualify(barcod_id_list,"'")#)--->
	</cfif>
</cfquery>

<cfquery name="get_product" datasource="#dsn3#">
	SELECT
	<cfif attributes.stock_identity_type eq 1>
		GET_STOCK_BARCODES.BARCODE,
		GET_STOCK_BARCODES.PRODUCT_ID,
		GET_STOCK_BARCODES.STOCK_ID,
	<cfelse>
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_ID,
	</cfif>
		STOCKS.STOCK_CODE,
		STOCKS.STOCK_CODE_2,
		STOCKS.PRODUCT_NAME,
		STOCKS.PROPERTY	,	
		STOCKS.TAX_PURCHASE,
		PRICE_STANDART.PRICE,
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		STOCKS.IS_PRODUCTION,
		STOCKS.IS_PROTOTYPE,
		(SELECT TOP 1 SM.SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = STOCKS.STOCK_ID AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC) SPECT_NEW
	FROM
	<cfif attributes.stock_identity_type eq 1>
		GET_STOCK_BARCODES,
	</cfif>
		STOCKS,
		PRODUCT_UNIT,
		PRICE_STANDART
	WHERE
		PRODUCT_UNIT.IS_MAIN = 1 AND
	<cfif attributes.stock_identity_type eq 1>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			GET_STOCK_BARCODES.BARCODE = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		)
		<!---GET_STOCK_BARCODES.BARCODE IN (#listqualify(barcod_id_list,"'")#)---> AND
		STOCKS.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID AND
		PRODUCT_UNIT.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID AND
	<cfelseif attributes.stock_identity_type eq 3>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			STOCKS.STOCK_CODE_2 = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		) 
		<!---STOCKS.STOCK_CODE_2 IN (#listqualify(barcod_id_list,"'")#)---> AND
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
	<cfelse>
		(
		<cfset count=0>
		<cfloop list="#barcod_id_list#" delimiters="#document_seperator#" index="barcode_ind">
			<cfset count=count+1>
			STOCKS.STOCK_CODE = '#barcode_ind#'
			<cfif listlen(barcod_id_list,document_seperator) gt count>OR</cfif>
		</cfloop>
		)
		<!---STOCKS.STOCK_CODE IN (#listqualify(barcod_id_list,"'")#)---> AND
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
	</cfif>
		PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
		PRICE_STANDART.PURCHASESALES = 0
	ORDER BY
		<cfif attributes.stock_identity_type eq 1>
			GET_STOCK_BARCODES.BARCODE
		<cfelseif attributes.stock_identity_type eq 3>
			STOCKS.STOCK_CODE_2
		<cfelse>
			STOCKS.STOCK_CODE 
		</cfif>
</cfquery>
<!---<cfif isdefined('SHELF_CODE_LIST') and listlen(SHELF_CODE_LIST,',')>---><!--- LİSTE BARCODE LİSTESİ İLE BİLRİKDE İSMİ DİNAMİK OLUŞUYOR --->
	<cfquery name="GET_PRODUCT_PLACE_ALL" datasource="#dsn3#">
		SELECT
			PRODUCT_PLACE_ID,
			SHELF_CODE
		FROM
			PRODUCT_PLACE
		WHERE
			<!---(
			<cfset count=0>
			<cfloop list="#SHELF_CODE_LIST#" delimiters="#document_seperator#" index="shlf_ind">
				<cfset count=count+1>
				SHELF_CODE = '#shlf_ind#'
				<cfif listlen(SHELF_CODE_LIST,document_seperator) gt count>OR</cfif>
			</cfloop>
			)
			AND---> LOCATION_ID  = #attributes.location_id#
			AND STORE_ID  = #attributes.department_id#
	</cfquery>
<!---</cfif>--->
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td>
		<table cellpadding="2" cellspacing="1" border="0" width="100%" class="color-row">
			<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cfquery name="add_file" datasource="#dsn2#">
					INSERT INTO
						FILE_IMPORTS
					(
						PROCESS_TYPE,
						PRODUCT_COUNT,
						FILE_NAME,
						FILE_SIZE,
						FILE_SERVER_ID,
						DEPARTMENT_ID,
						DEPARTMENT_LOCATION,
						STARTDATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						-5,
						#line_count#,
						'#file_name#',
						#file_size#,
						#fusebox.server_machine#,
						#attributes.department_id#,
						#attributes.location_id#,
						#attributes.process_date#,
						#NOW()#,
						'#CGI.REMOTE_ADDR#',
						<cfif isDefined("session.pda")>#session.pda.userid#<cfelse>#SESSION.EP.USERID#</cfif>
					)
				</cfquery>
				<cfquery name="get_sayim_max" datasource="#DSN2#">
					SELECT MAX(I_ID) AS FILE_IMPORT_ID FROM FILE_IMPORTS
				</cfquery> 
			<cfloop from="1" to="#line_count#" index="i">
				<cfset barcode = trim(listfirst(dosya1[i],"#document_seperator#"))> <!--- barcode degiskeni stok kodu  ve barkod degerleri icin ortak kullanılıyor --->
				<cfquery name="get_product_name" dbtype="query">
					SELECT 
						PRODUCT_NAME, 
						PROPERTY, 
						ADD_UNIT,
						PRODUCT_ID,
						STOCK_ID ,
						IS_PRODUCTION,
						IS_PROTOTYPE,
						SPECT_NEW
					FROM 
						get_product 
					WHERE 
						<cfif attributes.stock_identity_type eq 1>
							BARCODE='#barcode#'
						<cfelseif attributes.stock_identity_type eq 3>
							STOCK_CODE_2 = '#barcode#'
						<cfelse>
							STOCK_CODE = '#barcode#'
						</cfif>
				</cfquery>
				<cfif get_product_name.recordcount eq 1>
					<cfif get_product_name.ADD_UNIT is "Kg">
						<cfset amount = (listgetat(dosya1[i],2,"#document_seperator#")+0)/1000>
					<cfelse>
						<cfset amount = listgetat(dosya1[i],2,"#document_seperator#")+0>
					</cfif>
					<cfset spect_hata = 0>
					<cfset spec_main = "">
					<cfif isdefined('SPECT_MAIN_ID_count_colums') and listlen(dosya1[i],'#document_seperator#') gte SPECT_MAIN_ID_count_colums>
						<cfset spec_main = trim(listgetat(dosya1[i],SPECT_MAIN_ID_count_colums,"#document_seperator#"))>
					</cfif>
					<cfif not len(trim(spec_main))>
						<cfif get_product_name.is_production eq 1 and get_product_name.is_prototype eq 0 and len(get_product_name.spect_new)>
							<cfset spec_main = get_product_name.spect_new>
						<cfelseif get_product_name.is_production eq 1 and get_product_name.is_prototype eq 0 and not len(get_product_name.spect_new)>
							<cfset spect_hata = 2>
						<cfelseif get_product_name.is_production eq 1 and get_product_name.is_prototype eq 1>
							<cfset spect_hata = 1>
						</cfif>
					</cfif>
					<cfif ListLen(dosya1[i],"#document_seperator#") gt 2>
						<cfset satir_shelf = listgetat(dosya1[i],3,"#document_seperator#")>
						<cfif len(satir_shelf)>
							<cfquery name="GET_PRODUCT_PLACE" dbtype="query">
								SELECT
									PRODUCT_PLACE_ID,
									SHELF_CODE
								FROM
									GET_PRODUCT_PLACE_ALL
								WHERE
									SHELF_CODE='#satir_shelf#'
							</cfquery>
							<cfset shelf_id = GET_PRODUCT_PLACE.PRODUCT_PLACE_ID>
						<cfelse>
							<cfset shelf_id = "">
						</cfif>
					<cfelse>
						<cfset shelf_id = "">
					</cfif>
					<cfif isdefined('deliver_date_count_colums') and listlen(dosya1[i],'#document_seperator#') gte deliver_date_count_colums>
						<cfset deliver_date = trim(listgetat(dosya1[i],deliver_date_count_colums,"#document_seperator#"))>
					<cfelse>
						<cfset deliver_date = "">
					</cfif>
					<cf_date tarih='deliver_date'>

					<cfquery name="GET_PRO_STOCK" dbtype="query">
						SELECT
							SUM(STOCK_IN-STOCK_OUT) PRODUCT_STOCK
						FROM
							get_pro_stock_all
						WHERE
							<cfif attributes.stock_identity_type eq 1>
								BARCODE='#barcode#'
							<cfelseif attributes.stock_identity_type eq 3>
								STOCK_CODE_2 = '#barcode#'
							<cfelse>
								STOCK_CODE = '#barcode#'
							</cfif>
							<cfif len(spec_main)>
								AND SPECT_VAR_ID = #spec_main#
							</cfif>
							<cfif len(shelf_id)>
								AND SHELF_NUMBER = #shelf_id#
							</cfif>
							<cfif len(deliver_date) gt 5>
								AND DELIVER_DATE = #deliver_date#
							</cfif>		
					</cfquery>
					<cfif GET_PRO_STOCK.RECORDCOUNT>
						<cfset deger = GET_PRO_STOCK.PRODUCT_STOCK>
					<cfelse>
						<cfset deger = 0>
					</cfif>
					<cfif spect_hata eq 0>
						<cfoutput>
							<cfquery name="add_file_imports_row" datasource="#dsn2#">
								INSERT INTO
									FILE_IMPORTS_ROW
									(
										FILE_IMPORT_ID,
										PRODUCT_ID,
										STOCK_ID,
										STOCK_AMOUNT,
										AMOUNT
										<cfif attributes.stock_identity_type eq 1>
										,BARCODE
										</cfif>
										<cfif len(spec_main)>
										,SPECT_MAIN_ID
										</cfif>
										<cfif len(shelf_id)>
										,SHELF_NUMBER
										</cfif>
										<cfif len(deliver_date)>
										,DELIVER_DATE

										</cfif>
									)
									VALUES
									(
										#get_sayim_max.FILE_IMPORT_ID#,
										#get_product_name.product_id#,
										#get_product_name.stock_id#,
										#deger#,
										#amount#
										<cfif attributes.stock_identity_type eq 1>
										,'#barcode#'
										</cfif>
										<cfif len(spec_main)>
										,#spec_main#
										</cfif>
										<cfif len(shelf_id)>
										,#shelf_id#
										</cfif>
										<cfif len(deliver_date)>
										,#deliver_date#
										</cfif>
									)
							</cfquery>
					</cfoutput>	
					<cfelse>
						<cfset error_flag=1>
						<cfoutput>
						<tr>
							<td>
							#barcode# (<font color="##FF0000">Bu Ürün Üretiliyor <cfif spect_hata eq 1>ve Özelleştirilebilir</cfif> Olduğu İçin Spect Bilgisi Girmelisiniz !</font>) / miktar: #listgetat(dosya1[i],2,"#document_seperator#")#<br/>
							</td>
						</tr>
						</cfoutput>
					</cfif>
				<cfelse>
					<cfset error_flag=1>
					<cfoutput>
					<tr>
						<td>
						#barcode# (<font color="##FF0000"><cfif get_product_name.recordcount eq 0>Bu Ürün Kayıtlı Değil<cfelse>Ürün Bilgisi ile birden fazla kayıt bulundu</cfif> !</font>) / miktar: #listgetat(dosya1[i],2,"#document_seperator#")#<br/>
						</td>
					</tr>
					</cfoutput>
				</cfif>
			</cfloop>
			</cftransaction>
			</cflock>
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	<cfif isdefined('error_flag')>
		alert('Bazı Ürünler Kayıtlı Değil veya Ürün Bilgisi İle Eşlenen Birden Fazla Ürün Var!');
	</cfif>
	<cfif not isDefined("session.ep")>
	wrk_opener_reload();
	</cfif>
	//window.close();
</script>