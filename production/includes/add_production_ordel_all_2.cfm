
<cfif (attributes.finish_h_1 eq attributes.start_h_1) and (attributes.finish_m_1 eq attributes.start_m_1)>
<cfset emreTarih="#attributes.start_date_1# #attributes.start_h_1#:#attributes.start_m_1#">








<cfset attributes.deliver_date=dateAdd("n", 30, emreTarih)>
<cfset attributes.deliver_date_1=dateAdd("n", 30, emreTarih)>
<cfset attributes.finish_h_1=hour(attributes.deliver_date)>
<cfset attributes.finish_m_1=minute(attributes.deliver_date)>


</cfif>

<!----<div style="color:red">2-<cfoutput>#attributes.start_date#</cfoutput></div>---->

<cfif not isdefined("new_keyword_")>
	<cfset new_keyword_ = "">
</cfif>
<cfparam name="prod_ind" default="1">
<cfif not isdefined('is_ok')><!--- Çoklu sayfadan da gelse sadece 1 kere include edilsin.. --->
	<cfinclude template="/v16/workdata/get_main_spect_id.cfm">
	<cfset is_ok = 1>
</cfif>
<cfparam name="attributes.total_production_product" default="1">
<cfparam name="attributes.total_production_product_all" default="1">
<cfif not isdefined("is_op")>
	<cfparam name="attributes.deep_level_op" default="0">
	<cfset is_op = 1>
</cfif>
<cfparam name="prod_ind" default="1"><!--- normal üretim emri ekleme sayfasından geliyorsa 1 tane ürün olacağından 1 atıyoruz direkt olarak... --->
<cfscript>
	attributes.production_row_count = Evaluate("attributes.production_row_count_#prod_ind#");
	attributes.is_time_calculation = Evaluate("attributes.is_time_calculation_#prod_ind#");
	attributes.is_line_number = Evaluate("attributes.is_line_number_#prod_ind#");
	if(isdefined("attributes.is_operator_display_#prod_ind#"))
		attributes.is_operator_display = Evaluate("attributes.is_operator_display_#prod_ind#");//talep üretim ayrımını burdan yapıcaz..
	else
		attributes.is_operator_display = 0;
	attributes.start_date = Evaluate("attributes.start_date_#prod_ind#");
	attributes.start_m = Evaluate("attributes.start_m_#prod_ind#");
	attributes.start_h = Evaluate("attributes.start_h_#prod_ind#");
	attributes.finish_m = Evaluate("attributes.finish_m_#prod_ind#");
	attributes.finish_h = Evaluate("attributes.finish_h_#prod_ind#");
	attributes.deliver_date= Evaluate("attributes.deliver_date_#prod_ind#");
	if(isdefined("attributes.works_prog_#prod_ind#"))
		attributes.works_prog = Evaluate("attributes.works_prog_#prod_ind#");
	else
		attributes.works_prog = 1;
	attributes.production_type = 1; //Evaluate("attributes.production_type_#prod_ind#");
	attributes.project_id = Evaluate("attributes.project_id_#prod_ind#");
	if(isdefined("attributes.demand_no_#prod_ind#"))
		attributes.demand_no = Evaluate("attributes.demand_no_#prod_ind#");
	if(isdefined('attributes.demand_no') and len(attributes.demand_no))
		attributes.demand_no = attributes.demand_no;
	else
		attributes.demand_no = '';
	if(isdefined("attributes.wrk_row_relation_id_#prod_ind#"))
		attributes.wrk_row_relation_id = Evaluate("attributes.wrk_row_relation_id_#prod_ind#");
	else
		attributes.wrk_row_relation_id = '';
	if(isdefined("attributes.work_id_#prod_ind#"))
		attributes.work_id = Evaluate("attributes.work_id_#prod_ind#");
	if(isdefined('attributes.work_id') and len(attributes.work_id))
		attributes.work_id = attributes.work_id;
	else
		attributes.work_id = '';
	if(isdefined("attributes.work_head_#prod_ind#"))
		attributes.work_head = Evaluate("attributes.work_head_#prod_ind#");
	if(isdefined('attributes.work_head') and len(attributes.work_head))
		attributes.work_head = attributes.work_head;
	else
		attributes.work_head = '';
</cfscript>



<cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0><!--- Zaman Hesaplaması Yapılmamış denmiş ise her üretim için başlangıç ve bitiş saatini atıycaz. --->
	<cfif isdefined('attributes.start_date') and isdate(attributes.start_date) and len(attributes.start_m) and len(attributes.start_h)>
<cfset attributes.start_date=createodbcdatetime(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
		
		<cfset attributes.start_date = dateadd("n",attributes.start_m,dateadd("h",attributes.start_h ,attributes.start_date))><!--- - session.ep.time_zone --->
	<cfelse>
		<!---<cfset attributes.start_date =''>--->
	</cfif>
	
	<cfif isdefined('attributes.deliver_date') and isdate(attributes.deliver_date) and len(attributes.finish_h) and len(attributes.finish_m)>
	<!----	<cfset attributes.deliver_date=createodbcdatetime(attributes.deliver_date)>
		<cf_date tarih = "attributes.deliver_date">
		<cfset attributes.deliver_date = date_add("n",attributes.finish_m,date_add("h",attributes.finish_h ,attributes.deliver_date))><!--- - session.ep.time_zone --->---->
	<cfelse>
	<!---	<cfset attributes.deliver_date = '' >---->
	</cfif>
	
<cfelse>
	<!--- Zaman Hesaplaması Yapılsın Denilmiş ise --->
	<cfparam name="n_now_#prod_ind#" default="">
	<cfset xxx_list = ''><!--- Bu liste iç içe kırılımı olan ürünlerde alttaki ürünlerin daha önce üretilmesi için kullanılıyor. --->
	<cfset new_production_row_count_list = ''><!--- Bu değişken ise ürünlerin hangi sırada üretileceğini tutar --->
	<cfloop to="#attributes.production_row_count#" from="1" index="indexx">
		<cfif isdefined('attributes.product_is_production_#prod_ind#_#indexx#')><!--- Üretilsin diye seçilmiş ise! --->
			<cfif (ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') eq 1 and len(xxx_list))><!--- 1.ci kırılımdaki ürünler ise --->
				<cfif ListLen(xxx_list,'-')>
					<cfloop from="#ListLen(xxx_list,'-')#" to="1" index="real_index" step="-1"><!--- burdaki loop'u listeyi tersine çevirmek için kullanıyoruz. --->
						<cfset new_production_row_count_list = ListAppend(new_production_row_count_list,ListGetAt(xxx_list,real_index,'-'),',')>
					</cfloop>
				</cfif>
				<cfset xxx_list =''><!--- 1.ci kırılımdaki ürüne denk geldiğinde bu listeyi sıfırlıyoruz,sonraki 1.ci kırılım ürünleride kendi içinde gruplasın diye! --->
			</cfif>
			<cfset xxx_list = ListAppend(xxx_list,'#ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),4,',')#','-')>
			 <cfif indexx eq attributes.production_row_count and listlen(xxx_list) and not ListFind(new_production_row_count_list,xxx_list,',')>
				<cfoutput>
					<cfloop from="#ListLen(xxx_list,'-')#" to="1" index="real_index_" step="-1">
						<cfset new_production_row_count_list = ListAppend(new_production_row_count_list,ListGetAt(xxx_list,real_index_,'-'),',')>
					</cfloop>
				</cfoutput>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfset new_production_row_count_list = ListAppend(new_production_row_count_list,0,',')><!--- Son olarak ana ürün üretileceği için onun numarası olan 0'ı ekliyoruz. --->
	<cfloop list="#new_production_row_count_list#" index="indexx">
		<cfif listlen(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),',') eq 4><!--- bu kontrol sonrada kalkacak! --->
			<cfset setup_time = ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),4,',')>
		<cfelse>
			<cfset setup_time = 0 >
		</cfif>
	
		<!--- 
			<cfscript> 
			'production_times#indexx#'=get_production_times(
				station_id : ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,','),
				shift_id : attributes.works_prog,
				stock_id : ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),1,','),
				amount : Evaluate('attributes.product_amount_#prod_ind#_#indexx#'),
				production_type : attributes.production_type,
				setup_time_min : setup_time,
				_now_ : Evaluate("n_now_#prod_ind#")
			);
			</cfscript>
		--->
		
		<cfif len(Evaluate('attributes.station_id_#prod_ind#_#indexx#'))><cfelse><cfset "attributes.station_id_#prod_ind#_#indexx#"="0,0,0,0,-1,4,4,4,4"></cfif>
		<cfscript> 
		if(attributes.works_prog is '')
			works_program = 1;
		else
		works_program = attributes.works_prog;
			'production_times#indexx#'=get_production_times(
				station_id : ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,','),
				shift_id : works_program,
				stock_id : ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),1,','),
				amount : Evaluate('attributes.product_amount_#prod_ind#_#indexx#'),
				production_type : attributes.production_type,
				setup_time_min : setup_time,
				_now_ : Evaluate("n_now_#prod_ind#")
				
			);
		</cfscript>
		<cfset x_now_ = dateadd('h',session.ep.TIME_ZONE,now())>
		<cfif not isdefined('production_times#indexx#')><!--- Olası bir hata olduğunda zamanı ayarlasın --->
			<cfset 'production_times#indexx#' = "#DateFormat(x_now_,'YYYYMMDD')#,#TimeFormat(x_now_,timeformat_style)#,#DateFormat(dateadd('h',1,x_now_),'YYYYMMDD')#,#TimeFormat(dateadd('h',1,x_now_),timeformat_style)#">
		</cfif>
		<cfset s_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),1,','),4)>
		<cfset s_ay = mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),5,2)>
		<cfset s_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),7,2)>
		<cfset s_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
		<cfset s_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
		
		<cfset f_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),3,','),4)>
		<cfset f_ay = mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),5,2)>
		<cfset f_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),7,2)>
		<cfset f_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
		<cfset f_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
		<cfset 'startdate_fn_#prod_ind#_#indexx#' = CreateDateTime(s_yil,s_ay,s_gun,s_saat,s_dakika,0)>
		<cfset 'finishdate_fn_#prod_ind#_#indexx#' = CreateDateTime(f_yil,f_ay,f_gun,f_saat,f_dakika,0)>
		<cfset XYZ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',')>
		<cfif isdefined("last_start_#XYZ#")>
			<cfif isdefined('attributes.station_id_#prod_ind#_#indexx#')>
				<cfif indexx neq 0 and ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',') neq evaluate('last_station_#XYZ#')>
					<cfset 'startdate_fn_#prod_ind#_#indexx#' = evaluate('last_start_#XYZ#')>
					<cfset 'finishdate_fn_#prod_ind#_#indexx#' = evaluate('last_finish_#XYZ#')>
				</cfif>
			<cfelse>
				<cfif indexx neq 0 and ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') eq ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx+1#'),3,',')>
					<cfset 'startdate_fn_#prod_ind#_#indexx#' = evaluate('last_start_#XYZ#')>
					<cfset 'finishdate_fn_#prod_ind#_#indexx#' = evaluate('last_finish_#XYZ#')>
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined('XYZ') and XYZ gt ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') and ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#indexx#'),3,',') neq 1>
			<cfset "n_now_#prod_ind#" = '' >
		<cfelse>
			<cfset "n_now_#prod_ind#" = Evaluate('finishdate_fn_#prod_ind#_#indexx#') >
		</cfif>
		<cfset "last_start_#XYZ#" = Evaluate('startdate_fn_#prod_ind#_#indexx#')>
		<cfset "last_station_#XYZ#" = ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',')>
		<cfset "last_finish_#XYZ#" = Evaluate('finishdate_fn_#prod_ind#_#indexx#')>
		-<cfstoredproc procedure="ADD_PRODUCTION_ORDER_CASH" datasource="#DSN3#">
			<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_#prod_ind#_#indexx#')#">
			<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_#prod_ind#_#indexx#')#">
			<cfprocparam cfsqltype="cf_sql_integer" value="#ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#indexx#'),1,',')#">
		</cfstoredproc>
	</cfloop>
</cfif>
<cfif isdefined("attributes.show_lot_no_counter") and attributes.show_lot_no_counter>
	<cfset lot_system_paper_no = attributes.lot_no>
<cfelse>
	<cf_papers paper_type="production_lot"><!--- Lotnumarası sadece 1 kere alınacak --->
	<cfscript>
		lot_system_paper_no=paper_code & '-' & paper_number;
		lot_system_paper_no_add=paper_number;
	</cfscript>
	<cfif not len(lot_system_paper_no_add)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='623.Lütfen Lot Belge Numaralarınızı Tanımlayınız'> !");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
	<cfstoredproc procedure="UPD_GENERAL_PAPERS_LOT_NUMBER" datasource="#dsn3#"><cfprocparam cfsqltype="cf_sql_integer" value="#lot_system_paper_no_add#"></cfstoredproc>
</cfif>
<cfloop from="0" to="#attributes.production_row_count#" index="sayac">
	<cfif isdefined('attributes.product_is_production_#prod_ind#_#sayac#') or sayac eq 0><!--- Eğer Üret Seçeneği Seçilmiş ise yada sadece ana ürün ise bu bloğa girer --->
		<cf_papers paper_type="prod_order"><!--- Belge Numarası her üretim için tek tek alınıyor! --->
		<cfscript>
			system_paper_no=paper_code & '-' & paper_number;
			system_paper_no_add=paper_number;
		</cfscript>
		<cfif len(new_keyword_)>
			<cfset new_keyword_ = "#new_keyword_#,#system_paper_no#">
		<cfelse>
			<cfset new_keyword_ = "#system_paper_no#">	
		</cfif>
		<cfif not len(system_paper_no_add)>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='1890.Lütfen Belge Numaralarınızı Tanımlayınız'> !");
				history.go(-1);
			</script>
			<cfabort>
		</cfif>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cfset production_stock_id = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),1,',')>
				<cfif sayac eq 0><!--- Sadece Ana Ürünün spect_id'si spect_var_id'yi tutuyor diğerleri ise spect_main_id'yi tutuyor bu sebeble diğerlerinde spect_id'ler yeniden oluşturulucak specer fonksiyonu ile --->
					<cfset spect_id = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),2,',')>
					<cfset spect_main_id___ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),5,',')>
					<cfquery name="GET_SPECT" datasource="#DSN3#">
						<cfif len(spect_id) and spect_id gt 0>
							 SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = #spect_id#
						<cfelse>
							SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id___#
						</cfif>
					</cfquery>
					<cfset spec_var_name=GET_SPECT.SPECT_VAR_NAME>
					<cfset production_level = 0><!--- Ana ürün 0.cı kırılım. --->
					<cfset production_step = 0><!--- Üretim adımı --->
				<cfelse><!--- Ana Ürün değilse main_spect'id'yi kullanarak yeni bir spect oluşturuyoruz! --->
					<cfset spect_main_id___ = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),2,',')>
					<cfif spect_main_id___ eq 0><!--- SpectMainID değeri 0dan büyüksa,yani ürün üretilen bir ürün olduğu halde eğerki ağaçta spect seçilmemiş ise burda o ürün için ağacındaki varsayılan MAIN spect değerini alıcaz. --->
						<cfscript>
							create_spect_from_product_tree = get_main_spect_id(production_stock_id);
							if(len(create_spect_from_product_tree.SPECT_MAIN_ID))
								spect_main_id___ = create_spect_from_product_tree.SPECT_MAIN_ID;
						</cfscript> 
					</cfif>
					<cfif spect_main_id___ gt 0><!--- Bir üst satırda yapılan eşleştirmeye rağmen spect_main_id hala 0 ise bu şu anlama geliyor;ÜrünDetayında üretiliyor seçilmiş fakat,ürünün bir ağacı yok yada var ancak ağacı varyasyonlanmamış --->
						<cfquery name="get_spec_main_name" datasource="#dsn3#">
							SELECT SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #spect_main_id___#
						</cfquery>
						<cfset spec_var_name = get_spec_main_name.SPECT_MAIN_NAME> 
						<cfset production_level = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),3,',')><!--- Diğer ürünlerin ağaçta kaçıncı kırılım olduğu --->
						<cfset production_step = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_#sayac#'),4,',')><!--- Üretimin kaçıncı adımda olduğunu alıyoruz,bu değişken silinmesin,verilen üretim emirlerini kontrol ederken kullanlılıyor. --->
					</cfif>			
				</cfif>
				<cfif sayac eq 0 or spect_main_id___ gt 0><!--- Ana Ürünse veya sarf ürünlerde spect seçilmiş ürünler ise --->
					<cfif Evaluate('attributes.product_amount_#prod_ind#_#sayac#') contains ','>
						<cfset quantity = filterNum(Evaluate('attributes.product_amount_#prod_ind#_#sayac#'),8)>
					<cfelse>
						<cfset quantity = Evaluate('attributes.product_amount_#prod_ind#_#sayac#')>
					</cfif>
					<cfset ____po_related_id____ =''>
					<!--- bu if manuel olarak en fazla 10 kırılım olabileceği düşünelerak yazıldı muhtemelen bundan fazlasıda olmaz,bunun için bir fonksiyon yerine manuel yazmak daha kolay olduğu için böle yazıldı..İlerde fonksiyon ilede halledilebilir. Ayrıca yukarıda üretim emirlerinin zamanlarını hesaplama kısmıda düzenlenmeli buraya göre......--->
					<cfif production_level gt 0>
						<cfif production_level gte 1 and isdefined('po_related_id_#prod_ind#_#production_level-1#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-1#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-1#')>
						<cfelseif production_level gte 2 and isdefined('po_related_id_#prod_ind#_#production_level-2#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-2#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-2#')>
						<cfelseif production_level gte 3 and isdefined('po_related_id_#prod_ind#_#production_level-3#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-3#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-3#')>
						<cfelseif production_level gte 4 and isdefined('po_related_id_#prod_ind#_#production_level-4#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-4#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-4#')>
						<cfelseif production_level gte 5 and isdefined('po_related_id_#prod_ind#_#production_level-5#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-5#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-5#')>
						<cfelseif production_level gte 6 and isdefined('po_related_id_#prod_ind#_#production_level-6#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-6#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-6#')>
						<cfelseif production_level gte 7 and isdefined('po_related_id_#prod_ind#_#production_level-7#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-7#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-7#')>
						<cfelseif production_level gte 8 and isdefined('po_related_id_#prod_ind#_#production_level-8#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-8#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-8#')>
						<cfelseif production_level gte 9 and isdefined('po_related_id_#prod_ind#_#production_level-9#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-9#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-9#')>
						<cfelseif production_level gte 10 and isdefined('po_related_id_#prod_ind#_#production_level-10#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-10#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-10#')>
						<cfelseif production_level gte 11 and isdefined('po_related_id_#prod_ind#_#production_level-11#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-11#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-11#')>
						<cfelseif production_level gte 12 and isdefined('po_related_id_#prod_ind#_#production_level-12#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-12#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-12#')>
						<cfelseif production_level gte 13 and isdefined('po_related_id_#prod_ind#_#production_level-13#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-13#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-13#')>
						<cfelseif production_level gte 14 and isdefined('po_related_id_#prod_ind#_#production_level-14#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-14#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-14#')>
						<cfelseif production_level gte 15 and isdefined('po_related_id_#prod_ind#_#production_level-15#') and len(Evaluate('po_related_id_#prod_ind#_#production_level-15#'))>
							<cfset ____po_related_id____ = Evaluate('po_related_id_#prod_ind#_#production_level-15#')>
						</cfif>
					</cfif>
					<cfif len(spect_main_id___)>
						<cfquery name="get_tree_operations" datasource="#dsn3#">
							SELECT STOCK_ID,OPERATION_TYPE_ID,IS_PROPERTY,AMOUNT FROM SPECT_MAIN_ROW WHERE STOCK_ID IS NULL AND SPECT_MAIN_ID = #spect_main_id___# AND IS_PROPERTY IN (0,3,4)
						</cfquery>
					</cfif>
					<cfif isdefined('attributes.station_id_#prod_ind#_#sayac#') and ListLen(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),',') gt 5>
						<cfset _EXIT_DEP_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),6,',')>
						<cfset _EXIT_LOC_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),7,',')>
						<cfset _PRODUCTION_DEP_ID=ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),8,',')>
						<cfset _PRODUCTION_LOC_ID= ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),9,',')>
					<cfelse>
						<cfset _EXIT_DEP_ID=''>
						<cfset _EXIT_LOC_ID=''>
						<cfset _PRODUCTION_DEP_ID=''>
						<cfset _PRODUCTION_LOC_ID= ''>
					</cfif>
				
					<cfset wrk_id_new = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#'>
					<!--- ÜRETİM EMRİ EKLENİYOR --->


					<cfstoredproc procedure="ADD_PRODUCTION_ORDER_PBS" datasource="#dsn3#">
						<cfif production_level eq 0 and isdefined('attributes.po_related_id_main') and len(attributes.po_related_id_main)><!--- Bir üretimin detayından ilişkili bir üretim ekleniyorsa --->
							<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.po_related_id_main#">
						<cfelseif len(____po_related_id____)><!--- Verilen Üretim emrinde seçilen ürünün ağacında bulunan üretilen ürünler için siparişi verilen ürün ile ilgili bağlantıları kuruyoruz. --->
							<cfprocparam cfsqltype="cf_sql_integer" value="#____po_related_id____#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfprocparam cfsqltype="cf_sql_integer" value="#production_stock_id#"> <!---OK---->
						<cfprocparam cfsqltype="cf_sql_float" value="#quantity#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"><!---OK---->
							<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes"><!---OK---->

							
						<cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0 and isdate(attributes.start_date)>
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						<cfelseif isdefined('startdate_fn_#prod_ind#_#sayac#')>	
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_#prod_ind#_#sayac#')#">
						<cfelseif isdefined('startdate_fn_1_0')>	
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('startdate_fn_1_0')#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">	
						</cfif><!---OK---->

						<cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 0 and isdate(attributes.deliver_date)>
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date#">
						<cfelseif isdefined('finishdate_fn_#prod_ind#_#sayac#')>	
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_#prod_ind#_#sayac#')#">
						<cfelseif isdefined('finishdate_fn_1_0')>	
							<cfprocparam cfsqltype="cf_sql_timestamp" value="#Evaluate('finishdate_fn_1_0')#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
						</cfif><!---OK---->

						<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_integer" value="1"><!---OK---->

						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfprocparam cfsqltype="cf_sql_varchar" value="#system_paper_no#"><!---OK---->

						<cfif isdefined('attributes.detail')>
							<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
						</cfif><!---OK---->

						<cfif isdefined("attributes.process_stage")>
							<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->

						<cfif isdefined('attributes.station_id_#prod_ind#_#sayac#') and len(ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')) and ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',') gt 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#ListGetAt(Evaluate('attributes.station_id_#prod_ind#_#sayac#'),1,',')#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif>
						<!---OK---->
						<cfif len(spect_id) and spect_id gt 0 and sayac eq 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#spect_id#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!--- Sadece Ana Ürün için spect_var_id oluşturuyoruz. ---><!---OK---->
						<cfif isdefined("spec_var_name") and len(spec_var_name)>
							<cfprocparam cfsqltype="cf_sql_varchar" value="#spec_var_name#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif isdefined('attributes.stock_reserved')>
							<cfprocparam cfsqltype="cf_sql_bit" value="#attributes.stock_reserved#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_bit" value="0">
						</cfif><!---OK---->
						<cfif isdefined('attributes.is_demontaj') and attributes.is_demontaj eq 1>
							<cfprocparam cfsqltype="cf_sql_bit" value="#attributes.is_demontaj#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_bit" value="0">
						</cfif><!---OK---->
						<cfprocparam cfsqltype="cf_sql_varchar" value="#lot_system_paper_no#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_varchar" value="#production_step#"><!---OK---->
						<cfprocparam cfsqltype="cf_sql_integer" value="#spect_main_id___#"><!---OK---->
						<cfif attributes.is_operator_display eq 1 and attributes.is_stage eq 4>
							<cfprocparam cfsqltype="cf_sql_integer" value="0">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.is_stage#">
						</cfif><!---OK---->

						<cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new#"><!---OK---->
						<cfif isdefined('attributes.demand_no') and len(attributes.demand_no)>
							<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.demand_no#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif len(_EXIT_DEP_ID) and _EXIT_DEP_ID gt 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#_EXIT_DEP_ID#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif len(_EXIT_LOC_ID) and _EXIT_LOC_ID gt 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#_EXIT_LOC_ID#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif len(_PRODUCTION_DEP_ID) and _PRODUCTION_DEP_ID gt 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#_PRODUCTION_DEP_ID#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif len(_PRODUCTION_LOC_ID) and _PRODUCTION_LOC_ID gt 0>
							<cfprocparam cfsqltype="cf_sql_integer" value="#_PRODUCTION_LOC_ID#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif isdefined('attributes.work_id') and len(attributes.work_id) and len(attributes.work_head)>
							<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
						</cfif><!---OK---->
						<cfif isdefined('attributes.wrk_row_relation_id') and len(attributes.wrk_row_relation_id)>
							<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.wrk_row_relation_id#">
						<cfelse>
							<cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
						</cfif><!---OK---->
					</cfstoredproc>
					
					<cfstoredproc procedure="UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER" datasource="#dsn3#">
						<cfprocparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
					</cfstoredproc>

					<cfstoredproc procedure="GET_PRODUCTION_ORDER_MAX" datasource="#dsn3#">
						<cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new#">
						<cfprocresult name="GET_MAX">
					</cfstoredproc>
					
					<cfif production_level gte 0>
						<cfset 'po_related_id_#prod_ind#_#production_level#' = GET_MAX.PID >
					</cfif>
					<cfset product_tree_id_list = ''>
					<cfset operation_type_id_list = ''>
					<cfset amount_list = ''>
					<cfset deep_level_list = ''>
					<cfscript>
						//writeoutput("deep_level_op:#attributes.deep_level_op#<br>");
						writeTree_operation(production_stock_id,0,0,0);
					</cfscript>
					<cfif len(product_tree_id_list)>
						<cfloop query="get_tree_operations">
							<cfset _OPERATION_TYPE_ID_ = get_tree_operations.OPERATION_TYPE_ID>
							<cfset _AMOUNT_ = get_tree_operations.AMOUNT>
							<cfstoredproc procedure="GET_WORKSTATIONS_PRODUCTS" datasource="#dsn3#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#_OPERATION_TYPE_ID_#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#production_stock_id#">
								<cfprocresult name="GET_OPERATIONS_STATIONS">
							</cfstoredproc>
							<!--- OPERASYON EKLENİYOR --->
							<cfstoredproc procedure="ADD_PRODUCTION_OPERATION" datasource="#dsn3#">	
								<cfprocparam cfsqltype="cf_sql_integer" value="#GET_MAX.PID#">	
								<cfif GET_OPERATIONS_STATIONS.recordcount>
									<cfprocparam cfsqltype="cf_sql_integer" value="#GET_OPERATIONS_STATIONS.STATION_ID#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
								</cfif>
								<cfif GET_OPERATIONS_STATIONS.recordcount>
									<cfprocparam cfsqltype="cf_sql_float" value="#GET_OPERATIONS_STATIONS.PRODUCTION_TIME#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
								</cfif>
								<cfprocparam cfsqltype="cf_sql_integer" value="#_OPERATION_TYPE_ID_#">
								<cfprocparam cfsqltype="cf_sql_float" value="#_AMOUNT_*quantity#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
								<cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
								<cfprocparam cfsqltype="cf_sql_integer" value="0">
							</cfstoredproc>
						</cfloop>
					</cfif>
					<CFSET PARTNER_P_ORDER_ID=get_max.pid>
					<cfif not isdefined("attributes.kontrol_order_#prod_ind#")><cfset "attributes.kontrol_order_#prod_ind#" = 1></cfif>
					<cfloop from="1" to="#listlen(Evaluate('attributes.order_row_id_#prod_ind#'),',')#" index="i">
						<!--- URETIM EMRI SIPARIS ILISKISI ILGILI TABLOYA EKLENIYOR. --->
						<cfif len(Evaluate('attributes.order_row_id_#prod_ind#')) and Evaluate('attributes.order_row_id_#prod_ind#') gt 0 and evaluate("attributes.kontrol_order_#prod_ind#") eq 1>
							 <cfstoredproc procedure="ADD_PRODUCTION_ORDERS_ROW" datasource="#DSN3#">
							 	<cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#listgetat(Evaluate('attributes.order_id_#prod_ind#'),i,',')#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#listgetat(Evaluate('attributes.order_row_id_#prod_ind#'),i,',')#">
								<cfif attributes.is_stage eq -1>
									<cfprocparam cfsqltype="cf_sql_integer" value="0">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_integer" value="1">
								</cfif>	
							 </cfstoredproc>
						</cfif>
					</cfloop>
					<!--- üretim emrine sarf ekleniyor --->
					<cfparam name="phantom_stock_id_list" default="0">
					<cfparam name="phantom_spec_main_id_list" default="0">
					<cfparam name="phantom_line_number_list" default="0">
					<cfset phantom_stock_id_list = ''>
					<cfset phantom_spec_main_id_list = ''>
					<cfset phantom_line_number_list = ''>
					<cfset main_product_spec_main_id = spect_main_id___>
					<cfif isdefined("main_product_spec_main_id") and main_product_spec_main_id gt 0>
						<cfscript>
							writeTree_order(main_product_spec_main_id,1);
						</cfscript>
					</cfif>
					<cfquery name="get_sub_product" datasource="#dsn3#">
						SELECT
							SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
							SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
							SPECT_MAIN_ROW.DETAIL AS DETAIL, 
							ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
							STOCKS.PRODUCT_ID,
							STOCKS.STOCK_ID,
							PRODUCT_UNIT.PRODUCT_UNIT_ID,
							0 IS_PHANTOM,
							SPECT_MAIN_ROW.IS_SEVK,
							SPECT_MAIN_ROW.IS_PROPERTY,
							ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
							ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
							0 AS SUB_SPEC_MAIN_ID,
							SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
							ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
							ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
						FROM
							SPECT_MAIN,
							SPECT_MAIN_ROW,
							STOCKS,
							PRODUCT_UNIT,
							PRICE_STANDART
						WHERE
							PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
							PRICE_STANDART.PURCHASESALES = 1 AND
							PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							STOCKS.STOCK_STATUS = 1	AND
							SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
							SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
							SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
							SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
							ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
							STOCKS.STOCK_ID NOT IN (0)
							<cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
								AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
							</cfif>
						<cfif phantom_spec_main_id_list gt 0><!--- eğer phantom ürün var ise... --->
							<cfif isdefined('phantom_line_number_list') and len(phantom_line_number_list)>
								<!---**** sira numarasina gore sarflar listelenmek istendiginde fantom urunlerin siralari karisikliga yol aciyordu. Sıra numaralarına gore loop yaparak bir ust sira numarasini tutmak icin yapıldı. --->
								<cfloop from="1" to="#listlen(phantom_line_number_list)#" index="ln">
									UNION ALL
										SELECT
											SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
											SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
											SPECT_MAIN_ROW.DETAIL AS DETAIL, 
											ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
											STOCKS.PRODUCT_ID,
											STOCKS.STOCK_ID,
											PRODUCT_UNIT.PRODUCT_UNIT_ID,
											1 IS_PHANTOM,
											SPECT_MAIN_ROW.IS_SEVK,
											SPECT_MAIN_ROW.IS_PROPERTY,
											ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
											ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
											SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
											SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
											ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
											#listgetat(phantom_line_number_list,ln)# MAIN_LINE_NUMBER<!--- SARFIN BAGLI OLDUGU URUNUN SIRA NUMARASINI GETIRIYORUZ. FANTOM URUNLERIN SIRAYI BOZMAMASI ICIN GEREKIYOR. --->
										FROM
											SPECT_MAIN,
											SPECT_MAIN_ROW,
											STOCKS,
											PRODUCT_UNIT,
											PRICE_STANDART
										WHERE
											PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
											PRICE_STANDART.PURCHASESALES = 1 AND
											PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
											STOCKS.STOCK_STATUS = 1	AND
											SPECT_MAIN.SPECT_MAIN_ID IN (#listgetat(phantom_spec_main_id_list,ln)#) AND
											SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
											SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
											SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
											ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
											<cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
											PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
											STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
								</cfloop>
							<cfelse>
								UNION ALL
									SELECT
										SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
										SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
										SPECT_MAIN_ROW.DETAIL AS DETAIL, 
										ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
										STOCKS.PRODUCT_ID,
										STOCKS.STOCK_ID,
										PRODUCT_UNIT.PRODUCT_UNIT_ID,
										1 IS_PHANTOM,
										SPECT_MAIN_ROW.IS_SEVK,
										SPECT_MAIN_ROW.IS_PROPERTY,
										ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
										ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
										SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
										SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
										ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
										ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
									FROM
										SPECT_MAIN,
										SPECT_MAIN_ROW,
										STOCKS,
										PRODUCT_UNIT,
										PRICE_STANDART
									WHERE
										PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
										PRICE_STANDART.PURCHASESALES = 1 AND
										PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
										STOCKS.STOCK_STATUS = 1	AND
										SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
										SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
										SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
										SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
										ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
										<cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
										PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
										STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
							</cfif>
						</cfif>
						<cfif isdefined('attributes.is_line_number') and attributes.is_line_number eq 1>
							ORDER BY
								MAIN_LINE_NUMBER,
								LINE_NUMBER
						</cfif>
					</cfquery>
					<cfif get_sub_product.recordcount>
						<cfoutput query="get_sub_product">
							<cfset _AMOUNT_ = AMOUNT>
							<cfif isdefined('multipler_#SUB_SPEC_MAIN_ID#')>
								<cfset _AMOUNT_ = Evaluate('multipler_#SUB_SPEC_MAIN_ID#')*AMOUNT>
							</cfif>
							<cfif is_free_amount eq 1>
								<cfset amount_ = _AMOUNT_>
							<cfelse>
								<cfset amount_ = _AMOUNT_ * get_max.AMOUNT>
							</cfif>
							<cfset wrk_id_new_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#get_max.pid#S#STOCK_ID#'>
							<cfstoredproc procedure="ADD_PRODUCTION_ORDERS_STOCKS_PBS" datasource="#dsn3#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
								<cfif len(RELATED_MAIN_SPECT_ID)>
									<cfprocparam cfsqltype="cf_sql_integer" value="#RELATED_MAIN_SPECT_ID#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
								</cfif>
								<cfprocparam cfsqltype="cf_sql_float" value="#amount_#">
								<cfprocparam cfsqltype="cf_sql_integer" value="2">
								<cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
								<cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#IS_PHANTOM#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#IS_SEVK#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#IS_PROPERTY#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#IS_FREE_AMOUNT#">
								<cfprocparam cfsqltype="cf_sql_float" value="#FIRE_AMOUNT#">
								<cfprocparam cfsqltype="cf_sql_float" value="#FIRE_RATE#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ROW_ID#">
								<cfprocparam cfsqltype="cf_sql_bit" value="1">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new_sarf#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#MAIN_LINE_NUMBER#">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#DETAIL#">
							</cfstoredproc>
						</cfoutput>
					</cfif>
					<!--- URETIM EMRINE FIRE EKLENIYOR. --->
					<!--- 
					<cfstoredproc procedure="GET_SUB_PRODUCT_FIRE" datasource="#dsn3#">
						<cfprocparam cfsqltype="cf_sql_integer" value="#spect_main_id___#">
						<cfprocresult name="GET_SUB_PRODUCT_FIRE">
					</cfstoredproc>
					--->
					<cfquery name="GET_SUB_PRODUCT_FIRE" datasource="#dsn3#">
						SELECT
								SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
								CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
								THEN
									SPECT_MAIN_ROW.FIRE_AMOUNT
								ELSE
									CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
									THEN
									SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
									ELSE
									SPECT_MAIN_ROW.AMOUNT
									END
								END AS AMOUNT ,
								ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
								STOCKS.PRODUCT_ID,
								STOCKS.STOCK_ID,
								PRODUCT_UNIT.PRODUCT_UNIT_ID,
								0 AS IS_PHANTOM,
								SPECT_MAIN_ROW.IS_SEVK,
								SPECT_MAIN_ROW.IS_PROPERTY,
								ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
								ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
								SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,
								SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
								SPECT_MAIN_ROW.LINE_NUMBER,
								ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
							FROM
								SPECT_MAIN,
								SPECT_MAIN_ROW,
								STOCKS,
								PRODUCT_UNIT,
								PRICE_STANDART
							WHERE
								PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
								PRICE_STANDART.PURCHASESALES = 1 AND
								PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
								STOCKS.STOCK_STATUS = 1	AND
								ISNULL(IS_PHANTOM,0) = 0 AND
								SPECT_MAIN.SPECT_MAIN_ID = #spect_main_id___# AND
								SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
								SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
								(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0) AND
								PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
								STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
								<cfif len(phantom_stock_id_list)><!--- FANTOM ÜRÜNLERİ SARF LİSTESİNDEN ÇIKARIYORUZ.AŞAĞIDA FHANTOMLARIN SPECLERİNDEN FAYDALANARAK BU ÇIKARTTIĞIMIZ ÜRÜNÜN BİLEŞENLERİNİ DAHİL EDİCEZ.. --->
								AND STOCKS.STOCK_ID NOT IN (#phantom_stock_id_list#)
							</cfif>
								<cfif phantom_spec_main_id_list gt 0><!--- eğer phantom ürün var ise... --->
							<cfif isdefined('phantom_line_number_list') and len(phantom_line_number_list)><!---**** sira numarasina gore sarflar listelenmek istendiginde fantom urunlerin siralari karisikliga yol aciyordu. Sıra numaralarına gore loop yaparak bir ust sira numarasini tutmak icin yapıldı. --->
								<cfloop from="1" to="#listlen(phantom_line_number_list)#" index="ln">
									UNION ALL
										SELECT
											SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
											 CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
											THEN
												SPECT_MAIN_ROW.FIRE_AMOUNT
											ELSE
												CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
												THEN
												SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
												ELSE
												SPECT_MAIN_ROW.AMOUNT
												END
											END AS AMOUNT ,
											ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
											STOCKS.PRODUCT_ID,
											STOCKS.STOCK_ID,
											PRODUCT_UNIT.PRODUCT_UNIT_ID,
											1 IS_PHANTOM,
											SPECT_MAIN_ROW.IS_SEVK,
											SPECT_MAIN_ROW.IS_PROPERTY,
											ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
											ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
											SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
											SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
											ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
											#listgetat(phantom_line_number_list,ln)# MAIN_LINE_NUMBER<!--- SARFIN BAGLI OLDUGU URUNUN SIRA NUMARASINI GETIRIYORUZ. FANTOM URUNLERIN SIRAYI BOZMAMASI ICIN GEREKIYOR. --->
										FROM
											SPECT_MAIN,
											SPECT_MAIN_ROW,
											STOCKS,
											PRODUCT_UNIT,
											PRICE_STANDART
										WHERE
											PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
											PRICE_STANDART.PURCHASESALES = 1 AND
											PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
											STOCKS.STOCK_STATUS = 1	AND
											SPECT_MAIN.SPECT_MAIN_ID IN (#listgetat(phantom_spec_main_id_list,ln)#) AND
											SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
											SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
											SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
											(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0) AND
											ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
											<cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
											PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
											STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
								</cfloop>
							<cfelse>
								UNION ALL
									SELECT
										SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
										 CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
										THEN
											SPECT_MAIN_ROW.FIRE_AMOUNT
										ELSE
											CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
											THEN
											SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
											ELSE
											SPECT_MAIN_ROW.AMOUNT
											END
										END AS AMOUNT ,
										ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
										STOCKS.PRODUCT_ID,
										STOCKS.STOCK_ID,
										PRODUCT_UNIT.PRODUCT_UNIT_ID,
										1 IS_PHANTOM,
										SPECT_MAIN_ROW.IS_SEVK,
										SPECT_MAIN_ROW.IS_PROPERTY,
										ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
										ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
										SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
										SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
										ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
										ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER
									FROM
										SPECT_MAIN,
										SPECT_MAIN_ROW,
										STOCKS,
										PRODUCT_UNIT,
										PRICE_STANDART
									WHERE
										PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
										PRICE_STANDART.PURCHASESALES = 1 AND
										PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
										STOCKS.STOCK_STATUS = 1	AND
										SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
										SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
										SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
										(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0) AND
										SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
										ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
										<cfif get_max.is_demontaj eq 1> SPECT_MAIN_ROW.IS_SEVK = 0 AND</cfif> <!--- IS_PROPERTY = 0 YANI SADE CE SARFLAR GELSİN. --->
										PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
										STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
							</cfif>
						</cfif>
					</cfquery>
					<!--- <cfdump var="#spect_main_id___#"> <cfdump var="#get_sub_product_fire#"> --->
					<cfif get_sub_product_fire.recordcount>
						<cfoutput query="get_sub_product_fire">
						<cfset amount_ = AMOUNT * get_max.AMOUNT>
							<cfset wrk_id_new_fire = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#U#get_max.pid#F#STOCK_ID#'>
							<cfstoredproc procedure="ADD_PRODUCTION_ORDERS_STOCKS" datasource="#dsn3#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">
								<cfif len(RELATED_MAIN_SPECT_ID)>
									<cfprocparam cfsqltype="cf_sql_integer" value="#RELATED_MAIN_SPECT_ID#">
								<cfelse>
									<cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
								</cfif>
								<cfprocparam cfsqltype="cf_sql_float" value="#amount_#">
								<cfprocparam cfsqltype="cf_sql_integer" value="3">
								<cfprocparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
								<cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#0#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#IS_SEVK#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#IS_PROPERTY#">
								<cfprocparam cfsqltype="cf_sql_bit" value="#IS_FREE_AMOUNT#">
								<cfprocparam cfsqltype="cf_sql_float" value="#FIRE_AMOUNT#">
								<cfprocparam cfsqltype="cf_sql_float" value="#FIRE_RATE#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#SPECT_MAIN_ROW_ID#">
								<cfprocparam cfsqltype="cf_sql_bit" value="1">
								<cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_id_new_fire#">
								<cfprocparam cfsqltype="cf_sql_integer" value="#LINE_NUMBER#">
							</cfstoredproc>
						</cfoutput>
					</cfif>
				</cfif>
			</cftransaction>
		</cflock>
	</cfif>
</cfloop>
<cfquery name="GET_PAPER" datasource="#dsn3#">
	SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #Evaluate('po_related_id_#prod_ind#_0')#
</cfquery>
<!--- SİSTEM PAPER KONTROL --->
<!--- İsbak Üretim Emri Seri No Generate py --->
<cfif isdefined("attributes.is_generate_serial_nos") and attributes.is_generate_serial_nos eq 1>
	<cfset my_stock_id = ListGetAt(Evaluate('attributes.product_values_#prod_ind#_0'),1,',')>
	<cfquery name="get_product_guaranty" datasource="#dsn3#">
		SELECT S.STOCK_CODE,S.IS_SERIAL_NO,S.PRODUCT_ID, G.TAKE_GUARANTY_CAT_ID FROM STOCKS S LEFT JOIN PRODUCT_GUARANTY G ON G.PRODUCT_ID = S.PRODUCT_ID WHERE S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_stock_id#">
	</cfquery>
	<cfif get_product_guaranty.IS_SERIAL_NO>
		<cfset year_ = mid(session.ep.period_year,3,2)>
		<cfset lot_no_ = listlast(lot_system_paper_no,'-')>
		<cfset attributes.amount = Evaluate('attributes.product_amount_#prod_ind#_0')>
		<cfset attributes.department_id = _PRODUCTION_DEP_ID>
		<cfset attributes.guarantycat_id = get_product_guaranty.TAKE_GUARANTY_CAT_ID>
		<cfset attributes.location_id = _PRODUCTION_LOC_ID>
		<cfset attributes.method = 0><!--- Standart Oluşturma--->
		<cfset attributes.m_type = 3><!--- Sondan Artmalı --->
		<cfset attributes.process_cat = 1194>
		<cfset attributes.process_number = get_paper.p_order_no>
		<cfset attributes.product_amount = quantity>
		<cfset attributes.stock_id = my_stock_id>
		<cfset attributes.ship_start_no = year_&lot_no_>
		<cfset attributes.ship_start_no_orta = listlast(get_product_guaranty.STOCK_CODE,'.')>
		<cfset attributes.ship_start_no_son = 001>
		<cfset attributes.start_date = dateformat(now(),dateformat_style)>
		<cfset is_generate_serial_nos = 1>
		<cfset uploaded_file = dateformat(now(),dateformat_style)>
		<cfset take_get = 0>
		<cfset attributes.take_get = 0>
		<cfset attributes.rma_no = "">
		<cfset attributes.wrk_row_id = "">
		<cfset attributes.process_id = Evaluate('po_related_id_#prod_ind#_0')>
		<cfset attributes.company_id = -1>
		<cfset attributes.partner_id = -1>
		<cfset attributes.consumer_id = -1>
		<cfset attributes.spect_id = spect_id>
		<cfset attributes.main_stock_id = "">
		<cfset attributes.process_date = attributes.start_date>
		<cfset attributes.lot_no = "">
		<cfset attributes.product_id = get_product_guaranty.product_id>
		<cfset attributes.order_type_ = 1> <!--- Ana Emir --->
		<cfinclude template="/v16/objects/query/add_stock_serial_no.cfm">
	</cfif>
	<!---İlişkili Üretm Emri için --->
	<cfset attributes.p_order_id = Evaluate('po_related_id_#prod_ind#_0')>
	<cfscript>
		related_production_list=attributes.p_order_id;
		WriteRelatedProduction2(attributes.p_order_id);
	</cfscript>
	<cfset p_order_id_ = related_production_list>
	<cfquery name="get_related_orders" datasource="#dsn3#">
		<cfloop list="#p_order_id_#" index="i">
			SELECT
				PO.P_ORDER_ID,
				PO.P_ORDER_NO,
				PO.STOCK_ID,
				PO.SPECT_VAR_ID,
				PO.QUANTITY,
				S.STOCK_CODE,
				S.PRODUCT_NAME,
				WORKSTATIONS.PRODUCTION_DEP_ID,
				WORKSTATIONS.PRODUCTION_LOC_ID,
				PO.LOT_NO
			FROM
				STOCKS S,
				PRODUCTION_ORDERS PO LEFT JOIN WORKSTATIONS
				ON PO.STATION_ID = WORKSTATIONS.STATION_ID
			WHERE
				S.STOCK_ID = PO.STOCK_ID AND
				PO_RELATED_ID = #i#
			<cfif listfind(p_order_id_,i) neq 0 and listlast(p_order_id_) neq i>UNION</cfif>
		</cfloop>
	</cfquery>
	<cfif get_related_orders.recordcount>
		<cfoutput query="get_related_orders">
			<cfquery name="get_product_guaranty2" datasource="#dsn3#">
				SELECT S.STOCK_CODE,S.IS_SERIAL_NO,S.PRODUCT_ID, G.TAKE_GUARANTY_CAT_ID FROM STOCKS S LEFT JOIN PRODUCT_GUARANTY G ON G.PRODUCT_ID = S.PRODUCT_ID WHERE S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_related_orders.stock_id#">
			</cfquery>
			<cfif get_product_guaranty2.IS_SERIAL_NO>
				<cfset year_ = mid(session.ep.period_year,3,2)>
				<cfset lot_no_ = listlast(get_related_orders.lot_no,'-')>
				<cfset attributes.amount = filterNum(get_related_orders.quantity)>
				<cfset attributes.department_id = get_related_orders.PRODUCTION_DEP_ID>
				<cfset attributes.guarantycat_id = get_product_guaranty2.TAKE_GUARANTY_CAT_ID>
				<cfset attributes.location_id = get_related_orders.PRODUCTION_LOC_ID>
				<cfset attributes.method = 0>
				<cfset attributes.m_type = 3>
				<cfset attributes.process_cat = 1194>
				<cfset attributes.process_number = get_related_orders.p_order_no>
				<cfset attributes.product_amount = filterNum(get_related_orders.quantity)>
				<cfset attributes.stock_id = get_related_orders.stock_id>
				<cfset attributes.ship_start_no = year_&lot_no_>
				<cfset attributes.ship_start_no_orta = listlast(get_product_guaranty2.STOCK_CODE,'.')>
				<cfset attributes.ship_start_no_son = 001>
				<cfset attributes.start_date = dateformat(now(),dateformat_style)>
				<cfset is_generate_serial_nos = 1>
				<cfset uploaded_file = dateformat(now(),dateformat_style)>
				<cfset take_get = 0>
				<cfset attributes.take_get = 0>
				<cfset attributes.rma_no = "">
				<cfset attributes.wrk_row_id = "">
				<cfset attributes.process_id = get_related_orders.p_order_id>
				<cfset attributes.company_id = -1>
				<cfset attributes.partner_id = -1>
				<cfset attributes.consumer_id = -1>
				<cfset attributes.spect_id = get_related_orders.spect_var_id>
				<cfset attributes.main_stock_id = "">
				<cfset attributes.lot_no = "">
				<cfset attributes.product_id = get_product_guaranty2.product_id>
				<cfset attributes.order_type_ = 2> 
				<cfset attributes.product_id = get_product_guaranty2.product_id>
				<cfinclude template="/v16/objects/query/add_stock_serial_no.cfm">
			</cfif>
		</cfoutput>
	 </cfif>
</cfif>
<cfif isdefined("attributes.show_lot_no_counter") and attributes.show_lot_no_counter>
	<cfset attributes.stock_id =ListGetAt(Evaluate('attributes.product_values_#prod_ind#_0'),1,',')>
	<cfquery name="get_lot_counter" datasource ="#dsn3#">
		SELECT * FROM #dsn1#.LOT_NO_COUNTER WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery> 
	<cfif get_lot_counter.recordcount and len(get_lot_counter.lot_number)>
		<cfset new_lot = add_one(get_lot_counter.LOT_NUMBER)>
		<cfquery name="upd_lot" datasource="#dsn3#">
			UPDATE #dsn1#.LOT_NO_COUNTER
			SET LOT_NUMBER = '#new_lot#'
			WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfquery>
	</cfif>
</cfif>
<cfif not isdefined("is_import_prod")>
	<cfquery name="GET_PAPER" datasource="#dsn3#">
		SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #Evaluate('po_related_id_#prod_ind#_0')#
	</cfquery>
	<!----<cf_workcube_process
		is_upd='1' 
		data_source='#dsn3#'
		old_process_line='0' 
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_id='#Evaluate('po_related_id_#prod_ind#_0')#'
		action_table='PRODUCTION_ORDERS'
		action_column='P_ORDER_ID'
		action_page='#request.self#?fuseaction=prod.order&event=upd&upd=#Evaluate('po_related_id_#prod_ind#_0')#' 
		warning_description = 'Üretim Emri : #get_paper.p_order_no#'>
	----->
	<!----<cf_add_log log_type="1" action_id="#Evaluate('po_related_id_#prod_ind#_0')#" action_name="#get_paper.p_order_no#" paper_no="#get_paper.p_order_no#" process_stage="#attributes.process_stage#" data_source="#dsn3#">----->
	<cfset attributes.actionId = Evaluate('po_related_id_#prod_ind#_0')>
	<cfquery name="DELETE_PRODUCTION_ORDER_CASH" datasource="#dsn3#">
		DELETE FROM PRODUCTION_ORDERS_CASH
	</cfquery>
	<cfoutput>
	<cfif attributes.total_production_product_all eq 1>
	<!----	<script type="text/javascript">
			<cfif isdefined("attributes.fusect") and attributes.fusect contains 'production.list_production_orders'>
				window.location.href ="#request.self#?fuseaction=production.list_production_orders&event=upd&upd=#Evaluate('po_related_id_#prod_ind#_0')#";
			<cfelse>
				window.location.href ="#request.self#?fuseaction=prod.order&event=upd&upd=#Evaluate('po_related_id_#prod_ind#_0')#";
			</cfif>
		</script>---->
	<cfelse>
		<!----<script type="text/javascript">
			window.location.href ="#request.self#?fuseaction=prod.order&is_submitted=1&keyword=#new_keyword_#";
		</script>----->
	</cfif>
	</cfoutput>
</cfif>
