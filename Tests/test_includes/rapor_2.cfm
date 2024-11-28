<link rel="stylesheet" type="text/css" href="/JS/DataTables/datatables.css"/>
<cfparam name="attributes.isexpbx" default="0">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cf_box title="Cari Ödeme Ve Tahsilat Raporu (Proje Bazlı)">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=12&event=det&report_id=48" name="rapor" id="rapor">
    <input type="hidden" name="is_submit">
    <table class="table">
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
                <label>
                    <input type="checkbox" name="isexpbx" value="1"> Excell
                </label>
            </td>
        <td>
            <input type="submit">
        </td>
    </tr>
</table>

</cfform>

</cf_box>
<cfif isDefined("attributes.is_submit")>
    <cfquery name="GETPM" datasource="#DSN3#">
    
        SELECT PAYMETHOD_ID,PAYMETHOD,DUE_DAY FROM workcube_metosan.SETUP_PAYMETHOD
        </cfquery>
        
        <cfloop query="GETPM">
            <CFSET "PAYMETHOD_#PAYMETHOD_ID#.PAYMETHOD"=PAYMETHOD>
            <CFSET "PAYMETHOD_#PAYMETHOD_ID#.DUE_DAY"=DUE_DAY>
        </cfloop>
<cfquery name="getc" datasource="#dsn#">
      select NICKNAME,C.COMPANY_ID,TT.*,PMS.*,EP.EMPLOYEE_NAME
      ,EP.EMPLOYEE_SURNAME from workcube_metosan.COMPANY as C
      LEFT JOIN workcube_metosan.EMPLOYEE_POSITIONS AS EP ON EP.POSITION_CODE=C.POS_CODE
    OUTER APPLY(
        SELECT PAYMETHOD_ID,REVMETHOD_ID FROM workcube_metosan.COMPANY_CREDIT where COMPANY_ID=C.COMPANY_ID
    ) as PMS
OUTER APPLY(
    SELECT SUM(ISNULL(BR,0)) ALACAK,SUM(ISNULL(AR,0)) BORC,CONVERT(DECIMAL(18,2),SUM(ISNULL(AR,0)-ISNULL(BR,0))) AS BAKIYE,
CASE WHEN SUM(ISNULL(BR,0))>SUM(ISNULL(AR,0)) THEN 'A' ELSE 'B' END AS BA
 FROM (
SELECT 
ISNULL(FROM_CMP_ID,TO_CMP_ID) CMP,
CASE WHEN FROM_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS BR,
CASE WHEN TO_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS AR

 FROM #dsn2#.CARI_ROWS WHERE FROM_CMP_ID=C.COMPANY_ID OR TO_CMP_ID=C.COMPANY_ID
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
    AND C.COMPANYCAT_ID IN(#attributes.member_cat_type#)
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

<cf_box >
    <cfif isDefined("attributes.isexpbx") and  attributes.isexpbx eq 1>
        <cfscript>
            theSheet = SpreadsheetNew("CariEkstre");
            SatirSayaci=1;
               myFormatRed=StructNew();
               myFormatRed.color="red";
               myFormatRed.bold="true";
           
               myFormatGreen=StructNew();
               myFormatGreen.color="green";
               myFormatGreen.bold="true";
           
               myformatBold=structNew();
               myformatBold.bold="true";
           
               myFormatBlue=StructNew();
               myFormatBlue.color="blue";
               myFormatBlue.bold="true";
           
               myformatSon=structNew();
               myformatSon.bold="true";
               myformatSon.bottomborder="medium";
           
               myFormatFatura=structNew();
               myFormatFatura.color="dark_teal";
               myFormatFatura.bold="true";
    
               numberFrm=structNew();
               numberFrm.dataformat="##,####0.00";
    
               hucre=1;
               spreadsheetAddRow(theSheet,"Cari Ödeme ve Tahsilat Raporu  (#dateFormat(now(),'dd.mm.yyyy')#)",SatirSayaci,hucre);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci,1,19);
               spreadsheetFormatRow(theSheet, myformatBold, SatirSayaci);
               SatirSayaci=SatirSayaci+1;
               hucre=1;
               SatirSayaci=3
                  SpreadsheetAddRow(theSheet,"Cari,Borç,Alacak,Bakiye,B/A,Satış Ödeme Yöntemi,Satış Vade Gün,Alış Ödeme Yöntemi,Alış Vade Gün,Müşteri Temsilcisi",SatirSayaci,hucre);
              /* spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,1,1);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,2,2);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,3,3);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,4,4);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,5,5);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,6,6);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,7,7);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,8,8);
               spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+1,9,9);*/
               SatirSayaci=2
                spreadsheetSetCellValue(theSheet,"Proje",SatirSayaci,10)
                  spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci,10,19);
                  spreadsheetFormatRow(theSheet, myformatBold, SatirSayaci);
                  SatirSayaci=SatirSayaci+1;
                  spreadsheetAddRow(theSheet,"Cari,Borç,Alacak,Bakiye,B/A,Satış Ödeme Yöntemi,Satış Vade Gün,Alış Ödeme Yöntemi,Alış Vade Gün,Proje No,Borç,Alacak,Bakiye,B/A,Ort. Ödeme Vade,Kalan Bakiye Gün Ort.,Kalan Bakiye Tarih Ort.,Peşine Düşen Açık Fatura Topl,Peşine Düşen Açık Fatura Gün,Müşteri Çek Riski,Müşteri Senet Riski,Müşteri Ciro Ödenmemiş Çek Senetlerin Toplamı",SatirSayaci,1);
               spreadsheetFormatRow(theSheet, myformatBold, SatirSayaci);
               SatirSayaci=SatirSayaci+1;
               
           </cfscript>
    </cfif>
<table  class="table" id="table_id">
    <thead>
    <tr>
        <th rowspan="2">
            Cari
        </th>
        <th rowspan="2">
            Borç
        </th>
        <th rowspan="2">
            Alacak
        </th>
        <th rowspan="2">
            Bakiye
        </th>
        <th rowspan="2">
            B/A
        </th>
        <th rowspan="2">Satış Ödeme Yöntemi</th>
        <th rowspan="2">Satış Vade Gün</th>
        <th rowspan="2">Alış Ödeme Yöntemi</th>
        <th rowspan="2">Alış Vade Gün</th>
        <th rowspan="2">Müşteri Temsilcisi</th>
        <th colspan="10">
            Proje
        </th>
       
    </tr>
    <tr>
        <th>Proje No</th>
        <th>Borç</th>
        <th>Alacak</th>
        <th>Bakiye</th>
        <th>B/A</th>
        <th>Ortalama Ödeme Vade</th>
        <th>Kalan Bakiye GÜn Ortalaması</th>
        <th>Kalan Bakiye Tarih Ortalaması</th>
        <th>Peşine Dönen Açık Fatura Toplamı</th>
        <th>Peşine Düşen Açık Fatura Gün</th>
        <th>Müşteri Çek Riski</th>
        <th>Müşteri Senet Riski</th>
        <th>Müşteri Ciro Ödenmemiş Evrak Toplamı</th>
    </tr>
</thead>
<tbody>
<cfoutput query="getc">
    <cfquery name="getpp" datasource="#dsn#">
                   
        SELECT DISTINCT * FROM (
          select PROJECT_ID,PROJECT_NUMBER,PROJECT_HEAD from workcube_metosan.PRO_PROJECTS where COMPANY_ID=#getc.COMPANY_ID#
          UNION ALL
          SELECT PROJECT_ID,PROJECT_NUMBER,PROJECT_HEAD FROM workcube_metosan.PRO_PROJECTS                         
             WHERE PROJECT_ID IN (
                 SELECT PROJECT_ID FROM workcube_metosan_2024_1.CARI_ROWS WHERE FROM_CMP_ID=#getc.COMPANY_ID# OR TO_CMP_ID=#getc.COMPANY_ID#
             )
             UNION ALL
             SELECT 0 AS PROJECT_ID,'' AS PROJECT_NUMBER,'PROJESIZ' AS PROJECT_HEAD                            
          )
             AS TF
             OUTER APPLY(
                   SELECT SUM(ISNULL(BR,0)) ALACAK,SUM(ISNULL(AR,0)) BORC,CONVERT(DECIMAL(18,2),SUM(ISNULL(AR,0)-ISNULL(BR,0))) AS BAKIYE,
CASE WHEN SUM(ISNULL(BR,0))>SUM(ISNULL(AR,0)) THEN 'A' ELSE 'B' END AS BA
FROM (
SELECT 
ISNULL(FROM_CMP_ID,TO_CMP_ID) CMP,
CASE WHEN FROM_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS BR,
CASE WHEN TO_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS AR
,PROJECT_ID
FROM workcube_metosan_2024_1.CARI_ROWS WHERE (FROM_CMP_ID=#getc.COMPANY_ID# OR TO_CMP_ID=#getc.COMPANY_ID# )and ISNULL(PROJECT_ID,0)=TF.PROJECT_ID
GROUP BY FROM_CMP_ID,TO_CMP_ID,PROJECT_ID
) as t

             ) AS TQ
             ORDER BY PROJECT_ID
     </cfquery>
     <cfquery name="get_pp_risk" datasource="#dsn2#">
        SELECT SUM(CEK_ODENMEDI) CEK_ODENMEDI,SUM(CEK_ODENMEDI2) CEK_ODENMEDI2,SUM(CEK_KARSILIKSIZ) CEK_KARSILIKSIZ,SUM(CEK_KARSILIKSIZ2) CEK_KARSILIKSIZ2,
SUM(SENET_ODENMEDI) SENET_ODENMEDI,SUM(SENET_ODENMEDI2) SENET_ODENMEDI2,SUM(SENET_KARSILIKSIZ) SENET_KARSILIKSIZ,SUM(SENET_KARSILIKSIZ2) SENET_KARSILIKSIZ2,
COMPANY_ID,ISNULL(PROJECT_ID,0) PROJECT_ID,ISNULL(SC,0) SC
 FROM (
SELECT * FROM workcube_metosan_2024_1.CEK_RISKI
UNION ALL
SELECT * FROM workcube_metosan_2024_1.SENET_RISKI

) AS T 
WHERE COMPANY_ID=#getc.COMPANY_ID#

GROUP BY COMPANY_ID,PROJECT_ID,SC

ORDER BY COMPANY_ID
     </cfquery>

<CFIF get_pp_risk.recordCount>
<cfloop query="get_pp_risk">
   <CFIF isDefined("M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")> <CFSET "M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=EVALUATE("M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")+CEK_ODENMEDI> <CFELSE> <CFSET "M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=CEK_ODENMEDI></CFIF>
    <CFIF isDefined("M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")> <CFSET "M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=EVALUATE("M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")+SENET_ODENMEDI> <CFELSE> <CFSET "M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=SENET_ODENMEDI></CFIF>
        <CFIF isDefined("MTXC.M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")> <CFSET "MTXC.M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=EVALUATE("MTXC.M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")+CEK_ODENMEDI> <CFELSE> <CFSET "MTXC.M_CEK_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=CEK_ODENMEDI></CFIF>
            <CFIF isDefined("MTXC.M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")> <CFSET "MTXC.M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=EVALUATE("MTXC.M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#")+SENET_ODENMEDI> <CFELSE> <CFSET "MTXC.M_SENET_RISKI_#COMPANY_ID#_#SC#_#PROJECT_ID#"=SENET_ODENMEDI></CFIF>

    
</cfloop>

</CFIF>


    <tr>
        <td rowspan="#getpp.recordCount+1#">
            #NICKNAME#
        </td>
        <td rowspan="#getpp.recordCount+1#">
            #tlformat(BORC)#
        </td>
        <td rowspan="#getpp.recordCount+1#">
            #tlformat(ALACAK)#
        </td>
        <td rowspan="#getpp.recordCount+1#">
            #tlformat(BAKIYE)#
        </td>
        <td rowspan="#getpp.recordCount+1#">
            #BA#
        </td>
        <cfif LEN(REVMETHOD_ID)>
            <td rowspan="#getpp.recordCount+1#">
                #evaluate("PAYMETHOD_#REVMETHOD_ID#.PAYMETHOD")#
            </td>
            <td rowspan="#getpp.recordCount+1#">
                #evaluate("PAYMETHOD_#REVMETHOD_ID#.DUE_DAY")#
            </td>
        <cfelse>
            <td rowspan="#getpp.recordCount+1#"></td>
            <td rowspan="#getpp.recordCount+1#"></td>
        </cfif>
        <cfif LEN(PAYMETHOD_ID)>
            <td rowspan="#getpp.recordCount+1#">
                #evaluate("PAYMETHOD_#PAYMETHOD_ID#.PAYMETHOD")#
            </td>
            <td rowspan="#getpp.recordCount+1#">
                #evaluate("PAYMETHOD_#PAYMETHOD_ID#.DUE_DAY")#
            </td>
        <cfelse>
            <td rowspan="#getpp.recordCount+1#"></td>
            <td rowspan="#getpp.recordCount+1#"></td>
        </cfif>
        <td rowspan="#getpp.recordCount+1#">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
    </tr>
       
    <cfif isDefined("attributes.isexpbx") and attributes.isexpbx eq 1>
        <cfscript>
            hucre=1;
            spreadsheetSetCellValue(theSheet,NICKNAME,SatirSayaci,hucre);
            hucre=hucre+1;
            spreadsheetSetCellValue(theSheet,BORC,SatirSayaci,hucre);
            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);
            hucre=hucre+1;
            spreadsheetSetCellValue(theSheet,ALACAK,SatirSayaci,hucre);
            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);
            hucre=hucre+1;
            spreadsheetSetCellValue(theSheet,BAKIYE,SatirSayaci,hucre);   
            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);         
            hucre=hucre+1;
            spreadsheetSetCellValue(theSheet,BA,SatirSayaci,hucre);        
            if(len(REVMETHOD_ID)){
                hucre=hucre+1; 
                spreadsheetSetCellValue(theSheet,evaluate("PAYMETHOD_#REVMETHOD_ID#.PAYMETHOD"),SatirSayaci,hucre);
                hucre=hucre+1; 
                spreadsheetSetCellValue(theSheet,evaluate("PAYMETHOD_#REVMETHOD_ID#.DUE_DAY"),SatirSayaci,hucre);
            }else{
                hucre=hucre+2;
            }
            if(len(PAYMETHOD_ID)){
                hucre=hucre+1; 
                spreadsheetSetCellValue(theSheet,evaluate("PAYMETHOD_#PAYMETHOD_ID#.PAYMETHOD"),SatirSayaci,hucre);
                hucre=hucre+1; 
                spreadsheetSetCellValue(theSheet,evaluate("PAYMETHOD_#PAYMETHOD_ID#.DUE_DAY"),SatirSayaci,hucre);
            }else{
                hucre=hucre+2;
            }
            hucre=hucre+1; 
            spreadsheetSetCellValue(theSheet,"#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#",SatirSayaci,hucre);
            if(getpp.recordCount gt 1){
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,1,1);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,2,2);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,3,3);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,4,4);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,5,5);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,6,6);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,7,7);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,8,8);
                spreadsheetMergeCells(theSheet,SatirSayaci,SatirSayaci+getpp.recordCount-1,9,9);
            }
           //SatirSayaci=SatirSayaci+1;
        </cfscript>
    </cfif>
           
                <cfloop query="getpp">
                    <cfset attributes.date1="01/01/#year(now())#">
                    <cfset attributes.date2="31/12/#year(now())#">
                    <cfset attributes.company_id=getc.COMPANY_ID>
                    <cfif PROJECT_ID EQ 0>
                        <CFSET PP_ID="">
                    <cfelse>
                        <CFSET PP_ID=PROJECT_ID>
                    </cfif>
                    <cfset attributes.project_id=PP_ID>
                    <cfset attributes.is_project_group=1>
                    <cfset attributes.is_ajax_popup=1>
                    <cfinclude template="/V16/objects/display/dsp_make_age_pbs.cfm">
                    <tr>
                        <CFSET PP_BKY=0>
                        <cfif len(getpp.BAKIYE)>
                            <CFSET PP_BKY=getpp.BAKIYE>
                        </cfif>
                        <td>#PROJECT_NUMBER#- #PROJECT_HEAD#</td>
                        <td>#TLFORMAT(getpp.BORC)#</td>
                        <td>#TLFORMAT(getpp.ALACAK)#</td>
                        <td>#TLFORMAT(getpp.BAKIYE)#</td>
                        <td>#getpp.BA#</td>
                        <td>#TLFORMAT(PBS_REPORT.PBS_TAF)#</td>
                        <td>#tlformat(PBS_REPORT.PBS_FAF)#</td>
                        <td>#dateFormat(PBS_REPORT.PBS_FAT,dateformat_style)#</td>
                        <td>#tlformat(PBS_REPORT.PBS_KAF)#</td>
                        <td><cfquery name="GETO" dbtype="query">SELECT AVG(D_VALUE) AS DV FROM PBS_REPORT.DS_QUERY</cfquery>#GETO.DV#</td>
                        
                        <td>
                            <cfif isDefined("M_CEK_RISKI_#COMPANY_ID#_1_#PROJECT_ID#")>
                                #tlformat(evaluate("M_CEK_RISKI_#COMPANY_ID#_#1#_#PROJECT_ID#"))#
                            <cfelse>
                                #TLFORMAT(0)#
                            </cfif>
                        </td>
                        <td>
                            <cfif isDefined("M_SENET_RISKI_#COMPANY_ID#_1_#PROJECT_ID#")>
                                #tlformat(evaluate("M_SENET_RISKI_#COMPANY_ID#_1_#PROJECT_ID#"))#
                            <cfelse>
                                #TLFORMAT(0)#
                            </cfif>
                        </td>
                        <td>
                            <cfset deger1=0>
                            <cfset deger2=0>
                            <cfif isDefined("M_CEK_RISKI_#COMPANY_ID#_0_#PROJECT_ID#")>
                                <cfset deger1=evaluate("M_CEK_RISKI_#COMPANY_ID#_0_#PROJECT_ID#")>
                            </cfif>
                            <cfif isDefined("M_SENET_RISKI_#COMPANY_ID#_0_#PROJECT_ID#")>
                                <cfset deger2=evaluate("M_SENET_RISKI_#COMPANY_ID#_0_#PROJECT_ID#")>
                            </cfif>
                            #tlformat(PP_BKY+deger1+deger2)#
                        </td>
                    </tr>
                    <cfif isDefined("attributes.isexpbx") and attributes.isexpbx eq 1>
                        <cfscript>
                            hucre=10;
                            spreadsheetSetCellValue(theSheet,"#PROJECT_NUMBER# - #PROJECT_HEAD#",SatirSayaci,hucre);
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,getpp.BORC,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,getpp.ALACAK,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,getpp.BAKIYE,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,getpp.BA,SatirSayaci,hucre);
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,PBS_REPORT.PBS_TAF,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,PBS_REPORT.PBS_FAF,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,dateformat(PBS_REPORT.PBS_FAT,"dd.mm.yyyy"),SatirSayaci,hucre);
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,PBS_REPORT.PBS_KAF,SatirSayaci,hucre);
                            spreadsheetFormatCell(theSheet,numberFrm,SatirSayaci,hucre);  
                            hucre=hucre+1;
                            spreadsheetSetCellValue(theSheet,GETO.DV,SatirSayaci,hucre);
                            SatirSayaci=SatirSayaci+1
                        </cfscript>
                    </cfif>
                </cfloop>
</cfoutput>
</tbody>
</table>
</cf_box>
<cfif  attributes.isexpbx eq 1>
    <cfset file_name = "CariFaliyetOzeti_#dateformat(now(),'ddmmyyyy')#.xls">
       <cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
       <cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
       <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
       </cfif>
   <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" name="theSheet"
       sheetname="MinumumMaximumStok" overwrite=true>
   
      <script type="text/javascript">
       <cfoutput>
       get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
       </cfoutput>
       </script>
   
   </cfif>
</cfif>
<!----<script type="text/javascript" charset="utf8" src="/js/datatables/DataTables-1.10.20/js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/Buttons-1.6.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/Buttons-1.6.1/js/buttons.flash.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/buttons/1.5.6/js/buttons.html5.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/buttons/1.5.6/js/buttons.print.min.js"></script>---->
<script type="text/javascript" src="/JS/DataTables/datatables.js"></script>
<script>
    $(document).ready( function () {
    $('#table_id').DataTable({
        dom: 'Bfrtip',
		   lengthMenu: [
            [ 10, 25, 50, -1 ],
            [ '10 rows', '25 rows', '50 rows', 'Show all' ]
        ],
        buttons: [
        'copy','excel', 'pdf', 'print','pageLength'
        ],
        "scrollX": true,
		"scrollY": true,
            
    } );
} );
</script>