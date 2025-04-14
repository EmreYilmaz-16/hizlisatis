

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
<CFSET attributes.offer_id = getOfferRow.OFFER_ID>
<cfinclude template="teklif_header.cfm">
<cfinclude template="teklif_header_table.cfm">


<!-------------------
    <cftry>
 
  
    
    
   

    

    
    
    
     
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


    <!-----
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
----->----------------->