<cfquery name="gets" datasource="#dsn3#">
    EXEC workcube_metosan_1.URETIM_AGAC_KARSILASTIR #attributes.p_order_id#
</cfquery>
<table>
    <tr>
        <th colspan="4">
            Üretim Emri
        </th>
        <th colspan="4">
            Ürün Ağacı
        </th>
    </tr>
    <tr>
        <th>
            Ürün Kodu
        </th>
        <th>
            Ürün
        </th>
        <th>
            Miktar
        </th>

        <th>
            Ürün Kodu
        </th>
        <th>
            Ürün
        </th>
        <th>
            Miktar
        </th>
    </tr>

<cfoutput query="gets">
<tr>
    <td>#SARF_PRODUCT_CODE#</td>
    <td>#SARF_PRODUCT_NAME#</td>
    <td>#SARF_AMOUNT#</td>
    <td><cfif LEN(PRODUCT_CODE)><span style="color:green" class="icn-md fa fa-arrow-up"></span></cfif></td>
    
    
    <td>#PRODUCT_CODE#</td>
    <td>#PRODUCT_NAME#</td>
    <td>#AMOUNT#</td>
    <td><cfif LEN(SARF_PRODUCT_CODE)><span style="color:red" class="icn-md fa fa-arrow-down"></span></cfif></td>
    
</tr>
</cfoutput>
</table>
<!-------------
    S2.PRODUCT_CODE AS SARF_PRODUCT_CODE,S2.PRODUCT_NAME AS SARF_PRODUCT_NAME,T.A1 AS SARF_AMOUNT,S.PRODUCT_CODE,S.PRODUCT_NAME,T.AMOUNT
    ------------->