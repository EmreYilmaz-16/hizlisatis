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