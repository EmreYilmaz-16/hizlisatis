<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=11" name="rapor" id="rapor">
    <cf_ajax_list>
        <tr>
            <td>
                <div class="form-group">
                    <label class="col col-12"> Cari Hesap </label>
                    <div class="col col-12 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>" >
                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                            <input type="hidden" name="employee_id" id="employee_id" value="">
                            <input type="text" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250',true,'fill_country(0,0)');" autocomplete="off"><div id="company_div_2" name="company_div_2" class="completeListbox" autocomplete="on" style="width: 605px; max-height: 150px; overflow: auto; position: absolute; left: 35px; top: 113px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&field_emp_id=rapor.employee_id&field_name=rapor.company&select_list=1,2,3,9','list');"></span>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label class="col col-12">Müşteri Temsilcisi </label>
                    <div class="col col-12 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
                            <input type="text" name="pos_code_text" id="pos_code_text" style="width:110px;" value="<cfoutput>#attributes.pos_code_text#</cfoutput>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off"><div id="pos_code_text_div_2" name="pos_code_text_div_2" class="completeListbox" autocomplete="on" style="width: 605px; max-height: 150px; overflow: auto; position: absolute; left: 35px; top: 172px; z-index: 159; display: none;"></div>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1,9','list')"></span>
                        </div>
                    </div>
                </div>
            </td>
    
            <td>
                <div class="form-group">
                    <label class="col col-12">Satış Bölgesi </label>
                    <div class="col col-12 col-xs-12">
                        <select name="zone_id" id="zone_id">
                            <option value="">Seçiniz </option>
                            
                                <option <cfif attributes.zone_id eq 3>selected</cfif> value="3">AKDENİZ</option>
                            
                                <option <cfif attributes.zone_id eq 4>selected</cfif> value="4">DOĞU ANADOLU</option>
                            
                                <option <cfif attributes.zone_id eq 1>selected</cfif> value="1">EGE</option>
                            
                                <option <cfif attributes.zone_id eq 7>selected</cfif> value="7">GÜNEYDOĞU ANADOLU</option>
                            
                                <option <cfif attributes.zone_id eq 2>selected</cfif> value="2">İÇ ANADOLU</option>
                            
                                <option <cfif attributes.zone_id eq 6>selected</cfif> value="6">KARADENİZ</option>
                            
                                <option <cfif attributes.zone_id eq 5>selected</cfif> value="5">MARMARA</option>
                            
                        </select>	
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label class="col col-12">Müşteri Değeri </label>
                    <div class="col col-12 col-xs-12">
                        <select name="customer_value" id="customer_value">
                            <option   value="">Seçiniz </option>
                            
                                <option <cfif attributes.customer_value eq 2>selected</cfif> value="2">A</option>
                            
                                <option <cfif attributes.customer_value eq 4>selected</cfif> value="4">B</option>
                            
                                <option <cfif attributes.customer_value eq 5>selected</cfif> value="5">C</option>
                            
                                <option <cfif attributes.customer_value eq 6>selected</cfif> value="6">D</option>
                            
                                <option <cfif attributes.customer_value eq 7>selected</cfif> value="7">E</option>
                            
                        </select>
                    </div>
                </div>
            </td>
      
            <td>
                <div class="form-group">
                    <label class="col col-12">Borç /Alacak </label>
                    <div class="col col-12 col-xs-12">
                        <select name="duty_claim" id="duty_claim">
                            <option value="">Seçiniz </option>
                            <option <cfif attributes.duty_claim eq 1>selected</cfif> value="1">Borçlu Üyeler </option>
                            <option <cfif attributes.duty_claim eq 2>selected</cfif> value="2">Alacaklı Üyeler </option>
                        </select>
                    </div>
                </div>
            </td>
            <td>
                <div class="form-group">
                    <label class="col col-12" id="buy_status1">Alıcı  / Satıcı </label>
                    <div class="col col-12 col-xs-12" id="buy_status2">
                        <select name="buy_status" id="buy_status" style="width:150px;">
                            <option value="">Seçiniz </option>
                            <option <cfif attributes.buy_status eq 1>selected</cfif> value="1">Alıcı </option>
                            <option <cfif attributes.buy_status eq 2>selected</cfif> value="2">Satıcı </option>
                            <option <cfif attributes.buy_status eq 3>selected</cfif> value="3">Potansiyel </option>								
                        </select>
                    </div>
                </div>
            </td>
       
            <td>
                <div class="form-group">									
                    <label class="col col-12" id="cat_">Üye Kategorisi </label>
                    <div class="col col-12 col-xs-12" id="comp_cat">
                        <select name="member_cat_type" id="member_cat_type" style="height:75px;" multiple="">
                            
                                <option <cfif attributes.member_cat_type eq 13>selected</cfif>  value="13">İMALATÇI</option>
                            
                                <option <cfif attributes.member_cat_type eq 20>selected</cfif> value="20">JOHN DEERE</option>
                            
                                <option <cfif attributes.member_cat_type eq 14>selected</cfif> value="14">KAMU</option>
                            
                                <option <cfif attributes.member_cat_type eq 15>selected</cfif> value="15">KARA LİSTE</option>
                            
                                <option <cfif attributes.member_cat_type eq 16>selected</cfif> value="16">OEM</option>
                            
                                <option <cfif attributes.member_cat_type eq 17>selected</cfif> value="17">PERAKENDE</option>
                            
                                <option <cfif attributes.member_cat_type eq 18>selected</cfif> value="18">SATICI</option>
                            
                                <option <cfif attributes.member_cat_type eq 19>selected</cfif> value="19">TEDARIKÇİ</option>
                                                    
                        </select>
                    </div>
                    <div class="col col-12" id="cons_cat" style="display:none;">
                        <select name="consumer_cat_type" id="consumer_cat_type" multiple="">
                                                    
                        </select>
                    </div>
                </div>
            </td>
    
        <td>
            <input type="submit">
        </td>
    </tr>
    </cf_ajax_list>
  
   
   
 

   
 
  
    
</cfform>
<cfquery name="getc" datasource="#dsn#">
    select TOP 20 NICKNAME,C.COMPANY_ID,TT.* from workcube_metosan.COMPANY as C
OUTER APPLY(
    SELECT SUM(ISNULL(BR,0)) ALACAK,SUM(ISNULL(AR,0)) BORC,CONVERT(DECIMAL(18,2),SUM(ISNULL(AR,0)-ISNULL(BR,0))) AS BAKIYE,
CASE WHEN SUM(ISNULL(BR,0))>SUM(ISNULL(AR,0)) THEN 'A' ELSE 'B' END AS BA
 FROM (
SELECT 
ISNULL(FROM_CMP_ID,TO_CMP_ID) CMP,
CASE WHEN FROM_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS BR,
CASE WHEN TO_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS AR

 FROM workcube_metosan_2024_1.CARI_ROWS WHERE FROM_CMP_ID=C.COMPANY_ID OR TO_CMP_ID=C.COMPANY_ID
 GROUP BY FROM_CMP_ID,TO_CMP_ID

) AS TF
) AS TT
WHERE BORC IS NOT NULL 
<cfif isDefined("attributes.duty_claim") and len(attributes.duty_claim)>
    <cfif attributes.duty_claim eq 1>
        AND BA='B'
    <CFELSE>
        AND BA='A'
    </cfif>
</cfif>
<cfif isDefined("attributes.buy_status")  and len(attributes.buy_status)>
    <cfif attributes.buy_status eq 1>
        AND C.IS_BUYER=1
    <cfelseif attributes.buy_status EQ 2>
        AND C.IS_SELLER=1
    <cfelseif attributes.buy_status EQ 3>
        AND C.ISPOTANTIAL=1    
    </cfif>
</cfif>
<cfif isDefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
    AND C.COMPANYCAT_ID=#attributes.member_cat_type#
</cfif>
<cfif isDefined("attributes.customer_value") and len(attributes.customer_value)>
    AND C.COMPANY_VALUE_ID=#attributes.customer_value#
</cfif>
<cfif isDefined("attributes.zone_id") and len(attributes.zone_id)>
    AND C.SALES_COUNTY=#attributes.zone_id#
</cfif>
<cfif isDefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
    AND C.POS_CODE=#attributes.pos_code#
</cfif>
<cfif isDefined("attributes.company") and len(attributes.company)>
    AND C.COMPANY_ID=#attributes.company_id#
</cfif>
</cfquery>
<cf_big_list>
    <thead>
    <tr>
        <th>
            Cari
        </th>
        <th>
            Borç
        </th>
        <th>
            Alacak
        </th>
        <th>
            Bakiye
        </th>
        <th>
            B/A
        </th>
        <th>
            Ortalama Ödeme Vade
        </th>
        <th>
            Kalan Bakiye GÜn Ortalaması
        </th>
        <th>
            Kalan Bakiye Tarih Ortalaması
        </th>
        <th>Peşine Dönen Açık Fatura Toplamı</th>
        <th>Peşine Düşen Açık Fatura Gün</th>
    </tr>


</thead>
<tbody>
<cfoutput query="getc">
    <tr>
        <td>
            #NICKNAME#
        </td>
        <td>
            #BORC#
        </td>
        <td>
            #ALACAK#
        </td>
        <td>
            #BAKIYE#
        </td>
        <td>
            #BA#
        </td>
        <td>
            <cfset attributes.date1="01/01/#year(now())#">
            <cfset attributes.date2="31/12/#year(now())#">
            <cfset attributes.company_id=COMPANY_ID>
            <cfset attributes.is_ajax_popup=1>
            <cfinclude template="/V16/objects/display/dsp_make_age_pbs.cfm">
            
            #TLFORMAT(PBS_REPORT.PBS_TAF)#
        </td>
        <td>#tlformat(PBS_REPORT.PBS_FAF)#</td>
        <td>#dateFormat(PBS_REPORT.PBS_FAT,dateformat_style)#</td>
        <td>#tlformat(PBS_REPORT.PBS_KAF)#</td>
        <td>
            <cfquery name="GETO" dbtype="query">
                SELECT AVG(D_VALUE) AS DV FROM PBS_REPORT.DS_QUERY
            </cfquery>
            #GETO.DV#
        </td>
    </tr>
</cfoutput>
</tbody>
</cf_big_list>