<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="ch.list_duty_claim">
<cfparam  name="attributes.SHOW_MEMBER_CODE" default="0">
<cf_get_lang_set module_name="ch">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.is_submitted" default="0">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="125">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.money_info" default="">
<cfparam name="attributes.due_info" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam  name="attributes.altlim" default="5000">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.vade_dev" default="">
<cfparam name="attributes.comp_status" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.vade_borc_ara_toplam" default="0">
<cfparam name="attributes.vade_alacak_ara_toplam" default="0">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.special_definition_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.IS_EXCELL" default="0">
<cfparam  name="attributes.pos_code" default="">
<cfparam  name="attributes.pos_code_text" default="">
<cfparam  name="attributes.EVENT" default="list">
<cfif not isdefined("is_revenue_duedate")>
	<cfset is_revenue_duedate = 0>
</cfif>
<cfscript>
	cmp_branch = createObject("component","v16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branchs = cmp_branch.get_branch();
</cfscript>
<cfquery name="get_company_cat" datasource="#dsn#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_sales_zones" datasource="#dsn#">
	SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_resource" datasource="#dsn#">
	SELECT RESOURCE_ID, RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<!---Tahsilat / Ödeme tipi alanının multiple olması için eklemiştir.--->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION,SPECIAL_DEFINITION_TYPE FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE IN (1,2)
</cfquery>
<cfform method="post" name="form_list_company" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_medium_list_search title="Borç Alacak Dökümü (Özel) : #dateformat(now(),'dd/mm/yyyy')# <a onclick='printDiv()'><div style='float:right'><img src='/images/print25.gif'></a></div>">
<cf_medium_list_search_area>
<input type="hidden" name="is_submitted" value="1">

<table>
    <tr>
        <td> 
            <div class="form-group" id="item-money_info">
                <label class="col col-12"><cf_get_lang no='201.Döviz Seçiniz'></label>
                <div class="col col-12">
                    <select name="money_info" id="money_info" onchange="kontrol_project(0);show_money_type();kontrol_asset(0);">
                    <option value="0">Türk Lirası</option>
                    <option value="1" <cfif isDefined("attributes.money_info") and attributes.money_info eq 1>selected</cfif>>2.<cf_get_lang_main no='265.Döviz'>
                    <option value="2" <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>selected</cfif>><cf_get_lang_main no='709.Islem Dövizi'></option>
                    </select>                        
                </div>
            </div>
        </td>
        <td rowspan="2" colspan="2">
            <div class="form-group" id="item-startdate2">
                <label class="col col-12"><cf_get_lang_main no='467.Islem Tarihi'></label>
                <div class="col col-6">
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang no='87.Baslangiç Tarihini Dogru Giriniz'></cfsavecontent>
                        <cfinput type="text" name="startdate2" value="#attributes.startdate2#" validate="#validate_style#" maxlength="10" message="#alert#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate2"></span>
                    </div>
                </div>
                <div class="col col-6">
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang no='86.Bitis Tarihini Dogru Giriniz'></cfsavecontent>
                        <cfinput type="text" name="finishdate2" value="#attributes.finishdate2#" validate="#validate_style#" maxlength="10" message="#alert#" style="width:62px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate2"></span>
                    </div>                        	
                </div>
            </div>
            <br>
            <div class="form-group" id="item-startdate">
                <label class="col col-12"><cf_get_lang_main no='469.Vade Tarihi'></label>
                <div class="col col-6">
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang no='87.Baslangiç Tarihini Dogru Giriniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="col col-6">
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang no='86.Bitis Tarihini Dogru Giriniz'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>                        	
                </div>
        </td>
        <td rowspan="3">
            <div class="form-group" id="item-member_cat_type">
                <label class="col col-12"><cf_get_lang_main no='2773.Üye Kategorileri'></label>
                <div class="col col-12">
                    <select name="member_cat_type" size="8" id="member_cat_type" multiple>
                        <option value="1_0" <cfif listfind(attributes.member_cat_type,'1_0',',')>selected</cfif>><cf_get_lang_main no='627.Kurumsal Üye Kategorileri'></option>
                        <cfoutput query="get_company_cat">
                        <option value="1_#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1_#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
                        <option value="2_0" <cfif listfind(attributes.member_cat_type,'2_0',',')>selected</cfif>><cf_get_lang_main no='628.Bireysel Üye Kategorileri'></option>
                        <cfoutput query="get_consumer_cat">
                        <option value="2_#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2_#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                        </cfoutput>
                        <option value="3_0" <cfif listfind(attributes.member_cat_type,'3_0',',')>selected</cfif>><cf_get_lang no='145.Bagli Kurumsal Üyeler'></option>
                        <option value="4_0" <cfif listfind(attributes.member_cat_type,'4_0',',')>selected</cfif>><cf_get_lang no='144.Bagli Bireysel Üyeler'></option>					
                        <option value="5_0" <cfif listfind(attributes.member_cat_type,'5_0',',')>selected</cfif>><cf_get_lang_main no='1463.Çalisanlar'></option>
                        <cfoutput query="get_all_ch_type">
                        <option value="5_#acc_type_id#" <cfif listfind(attributes.member_cat_type,'5_#acc_type_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#acc_type_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </td>
        <td>
            <label class="col">
                <cf_get_lang no='173.Sifir Bakiye Getirme'>
                <input type="checkbox" name="is_zero_bakiye" id="is_zero_bakiye" value="" <cfif isdefined("attributes.is_zero_bakiye")>checked</cfif>>
            </label>
            <br>
            <label class="col">
                Excell ?
                <input type="checkbox" value="1" id="is_excell" <cfif isDefined("attributes.is_excell") and attributes.is_excell eq 1>checked</cfif> name="is_excell">
            </label>
             <label class="col">
                Cari Kodu Göster
                <input type="checkbox" value="1" id="SHOW_MEMBER_CODE" <cfif isDefined("attributes.SHOW_MEMBER_CODE") and attributes.SHOW_MEMBER_CODE eq 1>checked</cfif> name="SHOW_MEMBER_CODE">
            </label>
            
        </td>
    </tr>
    <tr>
        <td>
            <div class="form-group" id="item-order_type">
                <label class="col col-12"><cf_get_lang_main no='1512.Sıralama'></label>
                <div class="col col-12">
                    <select name="order_type" id="order_type">
                        <option value="1" <cfif isDefined('attributes.order_type') and attributes.order_type eq 1>selected</cfif>><cf_get_lang no='148.Alfabetik'></option>
                        <option value="2" <cfif isDefined('attributes.order_type') and attributes.order_type eq 2>selected</cfif>><cf_get_lang no='150.Artan Bakiye'></option>
                        <option value="3" <cfif isDefined('attributes.order_type') and attributes.order_type eq 3>selected</cfif>><cf_get_lang no='149.Azalan Bakiye'></option>
                        <option value="4" <cfif isDefined('attributes.order_type') and attributes.order_type eq 4>selected</cfif>><cf_get_lang_main no='74.Kategori'></option>
                    </select>
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <td>
            <div class="form-group" id="item-buy_status">
                <label class="col col-12"><cf_get_lang no='200.Alici / Satici'></label>
                <div class="col col-12">
                    <select name="buy_status" id="buy_status">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <option value="1" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 1>selected</cfif>><cf_get_lang_main no='1321.Alici'></option>
                        <option value="2" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 2>selected</cfif>><cf_get_lang_main no='1461.Satici'></option>
                        <option value="3" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 3>selected</cfif>><cf_get_lang_main no ='165.Potansiyel'></option>
                    </select>
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-duty_claim">
                <label class="col col-12"><cf_get_lang_main no='455.Borç/Alacak'></label>
                <div class="col col-12">
                    <select name="duty_claim" id="duty_claim">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang_main no='768.Borçlu'><cf_get_lang_main no='5.Üyeler'></option>
                        <option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang no='156.Alacakli'><cf_get_lang_main no='5.Üyeler'></option>
                    </select>							                      	
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-altlim">	
                <label class="col col-12">Minumum Borç/Alacak Tutarı (TL)</label>
                <div class="col col-8"> 
                    <input  id="altlim" style="text-align:right" name="altlim" type="text" value="<cfoutput>#attributes.altlim#</cfoutput>">
                </div>
            </div>
        </td>
        <td><input type="submit"></td>
    </tr>
    <tr>
    <td>
    <div class="form-group" id="item-pos_code_text">
						<label class="col col-12">Temsilci </label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
								<input name="pos_code_text" type="text" id="pos_code_text" style="width:120px;" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','form_list_company','3','120');" value="<cfoutput>#attributes.pos_code_text#</cfoutput>" autocomplete="off"><div id="pos_code_text_div_2" name="pos_code_text_div_2" class="completeListbox" autocomplete="on" style="width: 345px; max-height: 150px; overflow: auto; position: absolute; left: 20px; top: 209.8px; z-index: 159; display: none;"></div>
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_code=form_list_company.pos_code&field_name=form_list_company.pos_code_text&select_list=1','list','popup_list_positions2');return false"></span>
							</div>
							
						</div>
					</div>
    </td>
    <td>
    <div class="form-group" id="item-sales_zones">
						<label class="col col-12">Satış Bölgesi </label>
						<div class="col col-12">
							<select name="sales_zones" id="sales_zones" style="width:150px;">
								<option value="">Seçiniz </option>
								
									<option value="1">Müşteri</option>
								
									<option value="3">Özel Hesap</option>
								
									<option value="2">Tedarikçi</option>
								
							</select>
						</div>
					</div>
    </td>

    </tr>
</table>

</cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>

	<cfif isdefined("attributes.is_project_group") or isdefined("attributes.is_asset_group")>
		<cfset attributes.money_info = ''>
	</cfif>
	<cfinclude template="/v16/ch/query/get_member.cfm">
<cfelse>
	<cfset get_member.recordcount = 0> 
</cfif>	
<cfscript>
	alacak = 0;
	borc = 0;
	alacak_2 = 0;
	borc_2 = 0;
	top_alacak_dev = 0;
	top_borc_dev = 0;
	top_alacak_dev_2 = 0;
	top_borc_dev_2 = 0;
	top_bakiye_dev = 0;
	sayfa_toplam_alacak = 0;
	sayfa_toplam_borc = 0;
	top_bakiye_dev_2 = 0;
	top_bakiye_dev_3 = 0;
	sayfa_toplam_alacak_2 = 0;
	sayfa_toplam_borc_2 = 0;
	sayfa_toplam_alacak_3 = 0;
	sayfa_toplam_borc_3 = 0;
	top_ceksenet = 0;
	top_ceksenet_ch = 0;
	top_ceksenet_other = 0;
	top_ceksenet2 = 0;
	top_ceksenet_ch2 = 0;
	top_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch = 0;
	sayfa_toplam_ceksenet_other = 0;
	sayfa_toplam_ceksenet_ch2 = 0;
	sayfa_toplam_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch3 = 0;
	sayfa_toplam_ceksenet_other3 = 0;
</cfscript>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<!----<cfdump  var="#get_member#">---->
<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
<cfif attributes.is_excell eq 1>
<cfscript>
    thesheet=spreadsheetNew("Borç Alacak");
    satir=1;
    kolon=1;
    myformatBold=structNew()
    myformatBold.bold="true";
    myformatBold.font="calibri";
    myformatBold.verticalalignment="vertical_center";
    myformatBold.fontsize=11;
    myformatnorm=structNew()
     myformatnorm.verticalalignment="vertical_center";
     myformatnorm.font="calibri";

    myformatMoney=structNew();
    myformatMoney.dataformat = "##,##0.00" 
    myformatMoney.verticalalignment="vertical_center";
    myformatMoney.font="calibri";
      myformatMoneyBold=structNew();
    myformatMoneyBold.dataformat = "##,##0.00" 
    myformatMoneyBold.verticalalignment="vertical_center";
    myformatMoneyBold.font="calibri";
    myformatMoneyBold.bold="true";
     myformatMoneyBold.fontsize=11;
     if (attributes.SHOW_MEMBER_CODE eq 1){
    spreadsheetSetCellValue(thesheet, "Cari Kod", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
    kolon=kolon+1;}
    spreadsheetSetCellValue(thesheet, "Cari Kart", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
    kolon=kolon+1;
     spreadsheetSetCellValue(thesheet, "Borç", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
    kolon=kolon+1;
     spreadsheetSetCellValue(thesheet, "Alacak", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
    kolon=kolon+1;
     spreadsheetSetCellValue(thesheet, "Bakiye", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
     kolon=kolon+1;
     spreadsheetSetCellValue(thesheet, "ParaBirimi", 1, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, 1, kolon);
    satir=satir+1;
    kolon=1;
</cfscript>
</cfif>
<!---<cfdump  var="#get_member#">
<cfquery name="get_member" dbtype="query">
select * from get_member order by FULLNAME
</cfquery>--->
</cfif>
<cfset EBORC=0>
<cfset EALACAK=0>
<cfset EBAKIYE=0>
<cfset EPARABIRIM="">
<div id="PrintArea">
<cf_big_list >
<cfscript>
ForExQuery=queryNew("Full_Name,Borc,Alacak,Bakiye,CURR,Adat","varchar,decimal,decimal,decimal,varchar,varchar")
</cfscript>
<thead>
<tr>
<th></th>
<cfif attributes.SHOW_MEMBER_CODE eq 1>
<th >Cari Kod</th>
</cfif>
<th >Cari kart</th>
<th>Borç</th>
<th>Alacak</th>
<th>Bakiye</th>
  <th style="text-align:right;"><cf_get_lang no='60.Adat'></th>
</tr>
</thead>
<tbody>
<cfset BorcToplam=0>
<cfset AlacakToplam=0>
<cfset BakiyeToplam=0>
<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
<cfset xsss=1>
<!----MEMBER_CODE---->
<cfloop query="get_Member">
<cfoutput>
<cfif (BAKIYE gte attributes.altlim or bakiye*-1 gte attributes.altlim) and 1 eq 1 >

<tr>
<td>#xsss#</td>
<cfset xsss=xsss+1>
<cfif attributes.SHOW_MEMBER_CODE eq 1>
<td><a class="tableyazi" href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#MEMBER_ID#">#MEMBER_CODE#</a></td>
</cfif>
<td><a class="tableyazi" href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#MEMBER_ID#">#FULLNAME#</a></td>
<cfif attributes.money_info eq 0>
<td style="text-align:right">#tlformat(BORC)#</td>
<td style="text-align:right">#tlformat(ALACAK)#</td>
<td style="text-align:right;"><a class="tableyazi"  href="#request.self#?fuseaction=ch.list_prtotm_extre&comp_id=#member_id#&company=#fullname#&list_type=0,4,3&is_submit=1">#tlformat(BAKIYE)#</a></td>
<cfscript>
 EBORC=BORC
EALACAK=ALACAK
EBAKIYE=BAKIYE
EPARABIRIM="TL"
</cfscript>
</cfif>
<cfif attributes.money_info eq 1>
<td style="text-align:right">#tlformat(BORC2)# #session.ep.money2#</td>
<td style="text-align:right">#tlformat(ALACAK2)# #session.ep.money2#</td>
<td  style="text-align:right"><a class="tableyazi"  href="#request.self#?fuseaction=ch.list_prtotm_extre&comp_id=#member_id#&company=#fullname#&list_type=2,4,3&is_submit=1">#tlformat(BAKIYE2)# #session.ep.money2#</a></td>
<cfscript>
 EBORC=BORC2
EALACAK=ALACAK2
EBAKIYE=BAKIYE2
EPARABIRIM="#session.ep.money2#"
</cfscript>
</cfif>
<cfif attributes.money_info eq 2>
<td style="text-align:right">#tlformat(BORC3)# #OTHER_MONEY#</td>
<td style="text-align:right">#tlformat(ALACAK3)# #OTHER_MONEY#</td>
<td  style="text-align:right"><a class="tableyazi" href="#request.self#?fuseaction=ch.list_prtotm_extre&comp_id=#member_id#&company=#fullname#&list_type=2,4,3&is_submit=1">#tlformat(BAKIYE3)# #OTHER_MONEY#</a></td>
<cfscript>
 EBORC=BORC3
EALACAK=ALACAK3
EBAKIYE=BAKIYE3
EPARABIRIM="#OTHER_MONEY#"
</cfscript>
</cfif>
<cfset XYZ="">
<td style="text-align:right">
         <cfset attributes.vade_alacak_ara_toplam=val(attributes.vade_alacak_ara_toplam)>
                    <cfset attributes.vade_borc_ara_toplam=val(attributes.vade_borc_ara_toplam)>
                    <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                        <cfset attributes.vade_alacak_ara_toplam = attributes.vade_alacak_ara_toplam + VADE_ALACAK_ARATOPLAM>
                        <cfset attributes.vade_borc_ara_toplam = attributes.vade_borc_ara_toplam + VADE_BORC_ARATOPLAM>
                        <cfif borc3+alacak3 gt 0>
                        <cfset XYZ= #TLFormat(((abs(vade_borc) * abs(borc3)) + (abs(vade_alacak) * abs(alacak3)))/(abs(borc3)+abs(alacak3)),0)#>
                        <cfelse>
                           <cfset XYZ=" 0*">
                        </cfif>
                        <cfif isDefined("attributes.due_info") and attributes.due_info neq 1>
                            <cfset XYZ=(#dateformat(date_add('d',(-1*TLFormat(((vade_borc * abs(borc)) + (vade_alacak * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),dateformat_style)#)>
                        </cfif>
                    <cfelse>
                        <cfset attributes.vade_alacak_ara_toplam = (attributes.vade_alacak_ara_toplam + VADE_ALACAK_ARATOPLAM)>
                        <cfset attributes.vade_borc_ara_toplam = attributes.vade_borc_ara_toplam + VADE_BORC_ARATOPLAM>
                        <cfif borc+alacak gt 0>
                        		<cfset kontrol_due_date = (dateformat(date_add('d',(-1*TLFormat(((vade_borc_1 * abs(borc)) + (vade_alacak_1 * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),"mm/dd/yyyy"))>
								<cfset kontrol_now_date = dateformat(now(),"mm/dd/YYYY") >
								<cfif DateCompare(kontrol_due_date,kontrol_now_date) gt 0 >
                              <cfset XYZ= "-"&#TLFormat(((abs(vade_borc_1) * abs(borc)) + (abs(vade_alacak_1) * abs(alacak)))/(abs(borc)+abs(alacak)),0)#>
                                <cfelse>
                                     <cfset XYZ=#TLFormat(((abs(vade_borc_1) * abs(borc)) + (abs(vade_alacak_1) * abs(alacak)))/(abs(borc)+abs(alacak)),0)#>
                                </cfif>
                            	
                        <cfelse>
                           <cfset XYZ="0">
                        </cfif>
                        <cfif isDefined("attributes.due_info") and attributes.due_info neq 1>
                            <cfset XYZ=(#dateformat(date_add('d',(-1*TLFormat(((vade_borc_1 * abs(borc)) + (vade_alacak_1 * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),dateformat_style)#)>
                        </cfif>
                    </cfif>
					#XYZ#
                    <cfif attributes.is_excell eq 1>
                    <cfscript>
                    if(attributes.SHOW_MEMBER_CODE eq 1){
                        spreadsheetSetCellValue(thesheet, "#get_Member.MEMBER_CODE#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatnorm, satir, kolon);
                        kolon=kolon+1;
                    }
                      spreadsheetSetCellValue(thesheet, "#get_Member.FULLNAME#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatnorm, satir, kolon);
                        kolon=kolon+1;
                        spreadsheetSetCellValue(thesheet, "#EBORC#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatMoney, satir, kolon);
                        kolon=kolon+1;
                        spreadsheetSetCellValue(thesheet, "#EALACAK#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatMoney, satir, kolon);
                        kolon=kolon+1;
                        spreadsheetSetCellValue(thesheet, "#EBakiye#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatMoney, satir, kolon);
                        kolon=kolon+1;
                        spreadsheetSetCellValue(thesheet, "#EPARABIRIM#", satir, kolon);
                        spreadsheetFormatCell(thesheet, myformatnorm, satir, kolon);
                        satir=satir+1;
                        kolon=1;
                    </cfscript>
                    </cfif>
					  <cfscript>   
         Qline=StructNew();
         Qline.Full_Name="#get_Member.FULLNAME#"
		   Qline.Borc=EBORC
		    Qline.ALACAK=EALACAK
			Qline.Bakiye=EBakiye
			Qline.CURR="#EPARABIRIM#"
			Qline.Adat="#XYZ#"                     
        ForExQuery.addRow(Qline)
        </cfscript>
        <cfset BorcToplam=BorcToplam+EBORC>
        <cfset AlacakToplam=AlacakToplam+EALACAK>
        <cfset BakiyeToplam=BakiyeToplam+EBakiye>
</td>
</tr>
</cfif>
</cfoutput>
</cfloop>
<cfif attributes.is_excell eq 1>
<cfscript>
  kolon=1;
   if(attributes.SHOW_MEMBER_CODE eq 1){
 spreadsheetSetCellValue(thesheet, "Toplam", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, satir, kolon);
    spreadsheetMergeCells(thesheet, satir, satir, kolon, kolon+1)
    spreadsheetFormatCell(thesheet, myformatBold, satir, kolon+1);
    kolon=kolon+2;
   }else{
 spreadsheetSetCellValue(thesheet, "Toplam", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, satir, kolon);
    kolon=kolon+1;
   }
   
    spreadsheetSetCellValue(thesheet, "#BorcToplam#", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatMoneyBold, satir, kolon);
    kolon=kolon+1;
    spreadsheetSetCellValue(thesheet, "#AlacakToplam#", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatMoneyBold, satir, kolon);
    kolon=kolon+1;
    spreadsheetSetCellValue(thesheet, "#BakiyeToplam#", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatMoneyBold, satir, kolon);
    kolon=kolon+1;
    spreadsheetSetCellValue(thesheet, "#EPARABIRIM#", satir, kolon);
    spreadsheetFormatCell(thesheet, myformatBold, satir, kolon);
    satir=satir+1;
    kolon=1;
</cfscript>
</cfif>
<cfif attributes.is_excell eq 1>

    <cfset file_name = "BorçAlacakDokumu_#dateformat(now(),'ddmmyyyy')#.xls">
    <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
    <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
    </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" name="theSheet" sheetname="Çek Analizi" overwrite=true>
    <script type="text/javascript">
        <cfoutput>
            get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
        </cfoutput>
    </script>
</cfif> 
<cfif 2 eq 1>
<!---<cfquery name="ForExQuery2" dbtype="query">
SELECT Islem_Tarihi
    ,Islem 
    ,Evr_No as 'Evrak No'
    ,INFO as 'Açiklama'
    ,BORC as 'Borç'
    ,ALACAK as 'Alacak'
    ,BAKIYE as 'Bakiye'
    ,CURR as 'Para Birimi'
    ,BORC_2 as 'Borç'
    ,ALACAK_2 as 'Alacak'
    ,BAKIYE_2 as 'Bakiye'
    ,CURR2 as 'Para Birimi' from ForExQuery
</cfquery>+--->
 <cfset file_name = "BORC_ALACAK_DOKUMU_#dateformat(now(),'ddmmyyyy')#.xls">
    <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
    <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
    <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
    </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" query="ForExQuery" sheetname="Cari Ekstre" overwrite="true"  />
    <cfheader name="Expires" value="#Now()#">

    <script type="text/javascript">
    <cfoutput>
    get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
    </cfoutput>
    </script>
</cfif>
<cfelse>
<tr><td colspan="7"></td></tr>
</cfif>
</tbody>
</cf_big_list>
</div>
<script>
function printDiv() 
{

   var divToPrint=document.getElementById('PrintArea');
console.log(divToPrint)
  var newWin=window.open('','Print-Window');

  newWin.document.open();

  newWin.document.write('<html><head><style>body{font-size:8.5pt !important;font-family: sans-serif;}td{font-size:8.5pt;font-family: sans-serif;padding-top:3px;padding-bottom:3px}tbody,thead{margin-top:10px;margin-bottom:10px}.b1{font-size:9pt;font-family: sans-serif;}a{color:black;text-decoration:none;font-family: sans-serif;}.b2{font-size:8.5pt;font-family: sans-serif;}</style></head><body onload="window.print()">'+divToPrint.innerHTML+'</body></html>');

  newWin.document.close();

   //setTimeout(function(){newWin.close();},10);

}
$("#topluextre").click(function(){
    if($(this).is(":checked")){
       $("#toplu").show()
    }else{
         $("#toplu").hide()
    }
})
</script>