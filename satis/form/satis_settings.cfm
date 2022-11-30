<cfif isDefined("attributes.is_submit")>

<cfquery name="upda" datasource="#dsn3#">
    UPDATE VIRTUAL_OFFER_SETTINGS SET IS_RAFSIZ=#attributes.IS_RAFSIZ#,
    IS_ALL_SEVK=#attributes.IS_ALL_SEVK#,
    IS_RANDOM_UNIQE_NAME=#attributes.IS_RANDOM_UNIQE_NAME#,
    IS_SAME_VIRTUAL_NAME=#attributes.IS_SAME_VIRTUAL_NAME#,
    IS_ZERO_QUANTITY=#attributes.IS_ZERO_QUANTITY#,
    MAX_DISCOINT=#attributes.MAX_DISCOINT#,
    SEVK_DEPARTMENT_ID=#attributes.SEVK_DEPARTMENT_ID#,
    SEVK_LOCATION_ID=#attributes.SEVK_LOCATION_ID#,
    MANUEL_CONTROL=#attributes.MANUEL_CONTROL#,
    MANUEL_CONTROL_AREA='#attributes.MANUEL_CONTROL_AREA#',
    MALIYET_CONTROL=#attributes.MALIYET_CONTROL#
</cfquery>
</cfif>
<cfquery name="getVSettings" datasource="#dsn3#">
    SELECT 
    IS_RAFSIZ,IS_ADD_QUANTITY,IS_SAME_VIRTUAL_NAME,
    IS_RANDOM_UNIQE_NAME,SEVK_DEPARTMENT_ID,SEVK_LOCATION_ID,
    IS_UPDATE_OFFER,IS_CHANGE_CARI,IS_ALL_SEVK,ADD_MANUAL_PRODUCT,
    IS_ZERO_QUANTITY,MAX_DISCOINT,
    MANUEL_CONTROL,MANUEL_CONTROL_AREA,MALIYET_CONTROL
    FROM workcube_metosan_1.VIRTUAL_OFFER_SETTINGS
</cfquery>
<cf_box title="Satış Parametreleri">
<cfform>
    <table class="table table-sm">
        <tr>
            <td style="vertical-align:middle">
               <div> 0 Fiyat Kayıt Edilebilir</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="IS_ZERO_QUANTITY">
                    <option <cfif getVSettings.IS_ZERO_QUANTITY eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.IS_ZERO_QUANTITY eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>   Sıfır Fiyatla Teklif Kayıt Edilmesine İzin Verir
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Default Sevk Departman Id</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <input type="text" name="SEVK_DEPARTMENT_ID" value="<cfoutput>#getVSettings.SEVK_DEPARTMENT_ID#</cfoutput>">
                                    
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>   Ürün Sevki için Kullanılacak Default Departman
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Default Sevk Location Id</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <input type="text" name="SEVK_LOCATION_ID" value="<cfoutput>#getVSettings.SEVK_LOCATION_ID#</cfoutput>">
                                    
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>   Ürün Sevki için Kullanılacak Default Lokasyon
                </div>
            </td>
        </tr>
             <tr>
            <td style="vertical-align:middle">
               <div> Rafsız Kayıt Yapılabilir</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="IS_RAFSIZ">
                    <option <cfif getVSettings.IS_RAFSIZ eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.IS_RAFSIZ eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Teklifte Rafsız Kayıt Yapılmasına Olanak Tanır
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Sanal Ürün Benzersiz Ürün Adı</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="IS_RANDOM_UNIQE_NAME">
                    <option <cfif getVSettings.IS_RANDOM_UNIQE_NAME eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.IS_RANDOM_UNIQE_NAME eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Sanal Ürün Oluşturulurken Otomatik Olarak Benzersiz Ürün Adı Oluşturulması
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Sanal Ürün Aynı İsimle Kayıt Edilebilir</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="IS_SAME_VIRTUAL_NAME">
                    <option <cfif getVSettings.IS_SAME_VIRTUAL_NAME eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.IS_SAME_VIRTUAL_NAME eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Sanal Ürün Oluşturulurken Sanal Ürünü Aynı İsimle Kayıt Edilmesine Olanak Tanır
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Tamamı Sevk</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="IS_ALL_SEVK">
                    <option <cfif getVSettings.IS_ALL_SEVK eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.IS_ALL_SEVK eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Teklifin Sevk Aşamasına Kadar İlerletilmesini Sağlar
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Mavi Uyarı</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="MANUEL_CONTROL">
                    <option <cfif getVSettings.MANUEL_CONTROL eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.MANUEL_CONTROL eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Teklifte Mavi Uyarı Gelsin mi
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Mavi Uyarı Ek Bilgi Alanı</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                
                <select name="MANUEL_CONTROL_AREA">
                    <cfloop from="1" to="40" index="i">
                        <option <cfif getVSettings.MANUEL_CONTROL_AREA eq 'PROPERTY#i#'>selected</cfif>  value="PROPERTY<cfoutput>#i#</cfoutput>">PROPERTY<cfoutput>#i#</cfoutput></option>
                    </cfloop>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>Mavi Uyarı İçin Ek Bilgilerde Kontrol Edilecek Alan
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Maliyet Kontrolü</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <select name="MALIYET_CONTROL">
                    <option <cfif getVSettings.MALIYET_CONTROL eq 1>selected</cfif> value="1">Evet</option>
                    <option <cfif getVSettings.MALIYET_CONTROL eq 0>selected</cfif> value="0">Hayır</option>
                </select>
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>  Teklifteki Kırmızı Maliyet Kontrol Uyarısnın Gelmesini Sağlar
                </div>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:middle">
               <div>Maksimum Belge İndirim Oranı</div>
            </td>
            <td style="vertical-align:middle">
                <div class="form-group">
                <input type="text" name="MAX_DISCOINT" value="<cfoutput>#getVSettings.MAX_DISCOINT#</cfoutput>">
                                    
            </div>
            </td>
            <td style="vertical-align:middle">
                <div class="alert alert-warning" style="padding:5px;margin-bottom:0px">
                 <span style="font-size:14pt">&lt;!&gt;</span>Maksimum Yapılabilecek Belge İndirim Oranı (KDV'Matrahı)
                </div>
            </td>
        </tr>
    </table>
    <input type="hidden" name="is_submit">
    <input type="submit">
</cfform>
</cf_box>