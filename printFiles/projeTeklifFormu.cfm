

<cfquery name="getOfferRow" datasource="#DSN3#">
    SELECT * FROM PBS_OFFER_ROW WHERE OFFER_ID=#attributes.ACTION_ID#
</cfquery>
<cfif getOfferRow.recordCount eq 1>
    <cfif getOfferRow.IS_VIRTUAL eq 1>
        <CFSET PRINT_TYPE = 'VIRTUAL'>
    <cfelse>
        <CFSET PRINT_TYPE = 'NORMAL'>
    </cfif>
<cfelseif getOfferRow.recordCount gt 1>
    <CFSET PRINT_TYPE = 'MULTI'>
</cfif>
<cfabort>
<cfif  1 eq 1>
    <cftry>
 
    <CFSET attributes.offer_id = getOfferRow.OFFER_ID>
    <cfquery name="Our_Company" datasource="#dsn#">
        SELECT 
            ASSET_FILE_NAME3,
            ASSET_FILE_NAME3_SERVER_ID,
            COMPANY_NAME,
            TEL_CODE,
            TEL,TEL2,
            TEL3,
            TEL4,
            FAX,
            TAX_OFFICE,
            TAX_NO,
            ADDRESS,
            WEB,
            EMAIL
        FROM 
            OUR_COMPANY 
        WHERE 
        <cfif isDefined("SESSION.EP.COMPANY_ID")>
            COMP_ID = #SESSION.EP.COMPANY_ID#
        <cfelseif isDefined("SESSION.PP.COMPANY")>	
            COMP_ID = #SESSION.PP.COMPANY#
        </cfif>
    </cfquery>
    <cfquery name="CHECK" datasource="#DSN#">
        SELECT 
            ASSET_FILE_NAME2,
            ASSET_FILE_NAME2_SERVER_ID,
            COMPANY_NAME
        FROM 
            OUR_COMPANY 
        WHERE 
            <cfif isdefined("attributes.our_company_id")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
            <cfelse>
                <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                    COMP_ID = #session.ep.company_id#
                <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                    COMP_ID = #session.pp.company_id#
                <cfelseif isDefined("session.ww.our_company_id")>
                    COMP_ID = #session.ww.our_company_id#
                <cfelseif isDefined("session.cp.our_company_id")>
                    COMP_ID = #session.cp.our_company_id#
                </cfif> 
            </cfif> 
    </cfquery>
    <cfif isDefined('attributes.OFFER_ID')>
        <cfquery name="Get_Offer" datasource="#DSN#">
        SELECT
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_EMAIL,	
				PP.PROJECT_HEAD,
				PP.PROJECT_NUMBER,
                PP.PROJECT_ID,
                O.*
            FROM 
                #DSN3#.PBS_OFFER O , 
                workcube_metosan.EMPLOYEES E,
				workcube_metosan.PRO_PROJECTS AS PP 
            WHERE 
                O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#"> AND
                E.EMPLOYEE_ID = O.RECORD_MEMBER AND
				PP.PROJECT_ID=O.PROJECT_ID
           
        </cfquery>
    </cfif>
    <!--- Uye bilgileri --->
    <cfset Member_Code = "">
    <cfset Member_Name = "">
    <cfset Member_Mail = "">
    <cfset Member_TaxOffice = "">
    <cfset Member_TaxNo = "">
    <cfset Member_TelCode = "">
    <cfset Member_Tel = "">
    <cfset Member_Fax = "">
    <cfset Member_Address = "">
    <cfset Member_Semt = "">
    <cfset Member_County = "">
    <cfset Member_City = "">
    <cfset Member_Country = "">
    <cfif isdefined("Get_Offer.Company_Id") and Len(Get_Offer.Company_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                COMPANY_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                FULLNAME MEMBER_NAME,
                COMPANY_EMAIL MEMBER_EMAIL,
                TAXOFFICE MEMBER_TAXOFFICE,
                TAXNO MEMBER_TAXNO,
                COMPANY_TELCODE MEMBER_TELCODE,
                COMPANY_TEL1 MEMBER_TEL,
                COMPANY_FAX MEMBER_FAX,
                COMPANY_ADDRESS MEMBER_ADDRESS,
                SEMT MEMBER_SEMT,
                COUNTY MEMBER_COUNTY,
                CITY MEMBER_CITY,
                COUNTRY MEMBER_COUNTRY
            FROM
                COMPANY
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Company_Id#">
        </cfquery>
    <cfelseif isdefined("Get_Offer.Consumer_Id") and Len(Get_Offer.Consumer_Id)>
        <cfquery name="Get_Member_Info" datasource="#dsn#">
            SELECT
                CONSUMER_ID MEMBER_ID,
                MEMBER_CODE MEMBER_CODE,
                CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
                CONSUMER_EMAIL MEMBER_EMAIL,
                TAX_OFFICE MEMBER_TAXOFFICE,
                TAX_NO MEMBER_TAXNO,
                CONSUMER_WORKTELCODE MEMBER_TELCODE,
                CONSUMER_WORKTEL MEMBER_TEL,
                CONSUMER_FAXCODE + '' + CONSUMER_FAX MEMBER_FAX,
                WORKADDRESS MEMBER_ADDRESS,
                WORKSEMT MEMBER_SEMT,
                WORK_COUNTY_ID MEMBER_COUNTY,
                WORK_CITY_ID MEMBER_CITY,
                WORK_COUNTRY_ID MEMBER_COUNTRY
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Consumer_Id#">
        </cfquery>
    </cfif>
    <cfquery name="getProject" datasource="#dsn#">
        SELECT PROJECT_NUMBER,PROJECT_HEAD,SMC.MAIN_PROCESS_CAT,PP.PROJECT_EMP_ID FROM workcube_metosan.PRO_PROJECTS AS PP
INNER JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
WHERE PP. PROJECT_ID=#Get_Offer.PROJECT_ID#
    </cfquery>
    <cfif isdefined("Get_Member_Info") and Get_Member_Info.RecordCount>
        <cfset Member_Code = Get_Member_Info.Member_Code>
        <cfset Member_Name = Get_Member_Info.Member_Name>
        <cfset Member_Mail = Get_Member_Info.Member_Email>
        <cfset Member_TaxOffice = Get_Member_Info.Member_TaxOffice>
        <cfset Member_TaxNo = Get_Member_Info.Member_TaxNo>
        <cfset Member_TelCode = Get_Member_Info.Member_TelCode>
        <cfset Member_Tel = Get_Member_Info.Member_Tel>
        <cfset Member_Fax = Get_Member_Info.Member_Fax>
        <cfset Member_Address = Get_Member_Info.Member_Address>
        <cfset Member_Semt = Get_Member_Info.Member_Semt>
        
        <cfif Len(Get_Member_Info.Member_County)>
            <cfquery name="Get_County_Name" datasource="#dsn#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
            </cfquery>
            <cfset Member_County = Get_County_Name.County_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_City)>
            <cfquery name="Get_City_Name" datasource="#dsn#">
                SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
            </cfquery>
            <cfset Member_City = Get_City_Name.City_Name>
        </cfif>
        <cfif Len(Get_Member_Info.Member_Country)>
            <cfquery name="Get_Country_Name" datasource="#dsn#">
                SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
            </cfquery>
            <cfset Member_Country = Get_Country_Name.Country_Name>
        </cfif>
    </cfif>
    <cfif Len(Get_Offer.Partner_id)>
        <cfquery name="Get_Partner" datasource="#dsn#">
            SELECT COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME PARTNER_NAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Partner_id#">
        </cfquery>
        <cfset Partner_Name = Get_Partner.Partner_Name>
    <cfelse>
        <cfset Partner_Name = ''>
    </cfif>
    <cfif Len(Get_Offer.Ship_Method)>
        <cfquery name="Get_Ship_Method" datasource="#dsn#">
            SELECT
                SHIP_METHOD_ID,
                SHIP_METHOD
            FROM
                SHIP_METHOD
            WHERE 
                SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Offer.Ship_Method#">
        </cfquery>
    </cfif>
    <cfquery name="Get_Upper_Position" datasource="#dsn#">
        SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfif len (Get_Upper_Position.Upper_Position_Code)>
        <cfquery name="Get_Chief1_Name" datasource="#dsn#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Upper_Position.Upper_Position_Code#">
        </cfquery>
    </cfif>
    <cfquery name="Get_Offer_Plus" datasource="#dsn3#">
        SELECT
            PROPERTY1 AS EPOSTA,
            PROPERTY2 AS ILGILI,
            PROPERTY3 AS NOTLAR,
            PROPERTY4 AS TESLIM,
            PROPERTY5 AS ODEME,
            PROPERTY6 AS OPSIYON,
            PROPERTY7 AS ACIKLAMA
            
        FROM
            PBS_OFFER_INFO_PLUS
        WHERE
            PBS_OFFER_INFO_PLUS.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
    </cfquery>
    <cfif len(Get_Offer.Sales_Emp_Id)>
        <cfquery name="Get_Offer_Sales_Member" datasource="#dsn#">
            SELECT
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME,
                EP.POSITION_NAME,
                E.EMPLOYEE_EMAIL, 
                E.MOBILTEL,
                E.MOBILCODE
            FROM
                EMPLOYEES E
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getProject.PROJECT_EMP_ID#">
        </cfquery>
    </cfif>

    <cfquery name="Get_Money" datasource="#dsn3#">
        SELECT * FROM PBS_OFFER_MONEY WHERE ACTION_ID = #attributes.offer_id#
    </cfquery>
    <cfloop query="Get_Money">
        <cfset "Offer_Money_#Get_Money.Money_Type#" = Get_Money.Rate2>
    </cfloop>

    <cfquery name="Get_Money_Choose" dbtype="query">
        SELECT * FROM Get_Money WHERE IS_SELECTED = 1
    </cfquery>
    <cfset Offer_Money = Get_Money_Choose.Money_Type>
    <style>
        body { font-family: Arial, sans-serif; font-size: 12px; }
        table { width: 100%; border-collapse: collapse; }
        .header-table td { padding: 5px; vertical-align: top; }
        .info-table td { border: 1px solid #000; padding: 5px; }
        .info-table .label { font-weight: bold; background-color: #f5f5f5; width: 100px; }
        .section-title { font-weight: bold; text-align: center; font-size: 18px; padding: 10px; }
        .product-table th { background-color: #90ee90; padding: 6px; border: 1px solid #000; }
        .product-table td { padding: 5px; border: 1px solid #000; }
        .note-box { border: 1px solid #000; padding: 10px; margin-top: 10px; }
        .signature-box { padding: 10px; text-align: left; }
        .footer-contact { text-align: right; font-size: 11px; padding-right: 10px; }
    </style>
    <style>
        .product-table th {
            background-color: #90ee90;
            text-align: center;
            font-weight: bold;
            border: 1px solid #000;
            padding: 6px;
        }
    
        .product-table td {
            border: 1px solid #000;
            padding: 6px;
        }
    
        .toggle-icon {
            font-weight: bold;
            display: inline-block;
            width: 16px;
            text-align: center;
        }
    </style>
      <form method="post" name="siparis_etiket">
        <table class="etiketForm">
            <tr>
                <th class="formbold" style="text-align:left;">Ürün Özel Kodu</th>
            </tr>
            <tr>
                <td>
                    <select name="offer_type">
                        <option value="0" <cfif isDefined("form.offer_type") and form.offer_type eq 0>selected</cfif>>Açık Teklif</option>
                        <option value="1" <cfif isDefined("form.offer_type") and form.offer_type eq 1>selected</cfif>>Kapalı Teklif</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:right;">
                    <input type="hidden" name="isSubmit" value="1">
                    <input type="submit" value='Teklif Şablonu Oluştur'>
                    <button type="button" onclick="FiyatGosterGizle()">Fiyat Göster/Gizle</button>
                    <script>
                        function FiyatGosterGizle(params) {
                            var elems= document.getElementsByClassName("FiyatAlan");
                            for (var i = 0; i < elems.length; i++) {
                                if (elems[i].style.display == "none") {
                                    elems[i].style.display = "table-cell";
                                } else {
                                    elems[i].style.display = "none";
                                }
                            }
                        }
                    </script>
                </td>
            </tr>
        </table>
    </form>
    <table>
        <tr>
            <td>
                <table style="width:100%">
                    <tr>
                        <td colspan="2" >
                            <table style="width:100%;" align="center" border="1">
                                <tr>
                                    <td colspan="2" style="text-align:center"><cfif isDefined("attributes.method")><img src="<cfif isdefined("attributes.method")>http://erp.metosan.com.tr/documents/settings/3B355075-DEF5-E025-AE27746DDF7BCBF8.png<cfelse>http://erp.metosan.com.tr/documents/thumbnails/middle/A1A06B48-C977-8625-AA41F2A8941A0F13.PNG</cfif>" border="0" style="max-width: 250px;height: 88px;width: 270px;"></cfif></td>
                                    <td colspan="4" style="text-align:center;vertical-align:middle;max-width: 300px;width: 300px;"><h2 style="margin-top: 15px;">PROJE TEKLİF FORMU</h2></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width:100%; " align="center" border="1">
                                <tr>
                                    <td><b>Firma</b></td>
                                    <td><b>:</b></td>
                                    <td colspan="4"><cfoutput>#Member_Name#</cfoutput></td>

                                    <td><b>Tarih</b></td>
                                    <td><b>:</b></td>
                                    <td><cfoutput>#dateTimeFormat(Get_Offer.Offer_Date, 'dd.mm.yyyy hh:nn:ss')#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>Tel/Faks</b></td>
                                    <td><b>:</b></td>
                                    <td><cfif isDefined("Member_Tel")><cfoutput>#Member_Tel#</cfoutput></cfif></td>

                                    <td><b>E-Posta</b></td>
                                    <td><b>:</b></td>
                                    <td><cfoutput>#Get_Offer_Plus.EPOSTA#</cfoutput></td>
                                    
                                    <td><b>Ref. No</b></td>
                                    <td>:</td>
                                    <td><cfoutput>#Get_Offer.PROJECT_HEAD#<BR>#Get_Offer.PROJECT_NUMBER#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>İlgili</b></td>
                                    <td><b>:</b></td>
                                    <td colspan="7"><cfoutput>#Get_Offer_Plus.ILGILI#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td><b>Konu</b></td>
                                    <td><b>:</b></td>
                                    <td colspan="7"><cfoutput>#getProject.MAIN_PROCESS_CAT# - #getProject.PROJECT_HEAD# - #getProject.PROJECT_NUMBER#</cfoutput></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <table style="width:99.4%;" align="center" border="1">
                            <tr>
                                <td colspan="3">
                                    <p style="margin-left:20px">
                                        Firmamızdan talep etmiş olduğunuz <cfoutput>#getProject.MAIN_PROCESS_CAT#</cfoutput> ile ilgili teklifimiz aşağıda dikkatinize sunulmuştur. Teklifimizin olumlu karşılanacağını ümit eder, çalışmalarınızda başarılar dileriz.<br>
                                        Saygılarımızla,
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:center" colspan="2">
                                    <cfif len(Get_Offer.Sales_Emp_Id)>
                                        <cfoutput>#Get_Offer_Sales_Member.Fullname#</cfoutput> <br>
                                        <cfoutput>#Get_Offer_Sales_Member.POSITION_NAME#</cfoutput>
                                    </cfif>
                                </td>
                                <td style="text-align:center">
                                    <cfoutput>#Get_Offer_Sales_Member.Employee_Email#</cfoutput><br>
                                    <cfoutput>+90 (#Get_Offer_Sales_Member.MobilCode#) #Get_Offer_Sales_Member.MobilTel#</cfoutput><br>
                                    www.metosan.com.tr
                                </td>
                            </tr>
                        </table>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>
    <!-- Ürün Tablosu -->
<cftry>

<cfif PRINT_TYPE eq 'VIRTUAL'>
    <cfinclude template="virtual_teklif_print.cfm">
<cfelseif PRINT_TYPE eq 'NORMAL'>
  <cfinclude template="normal_teklif_print.cfm">
<cfelseif PRINT_TYPE eq 'MULTI'>
    <cfinclude template="multi_teklif_print.cfm">
</cfif>
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>

</cftry>
