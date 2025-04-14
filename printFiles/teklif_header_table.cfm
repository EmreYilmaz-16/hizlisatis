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