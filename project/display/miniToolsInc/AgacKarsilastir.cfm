﻿<cf_box title="Üretim Ağacı Karşılaştır" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfquery name="gets" datasource="#dsn3#">
    EXEC workcube_metosan_1.URETIM_AGAC_KARSILASTIR #attributes.p_order_id#
</cfquery>
<cf_grid_list>
    <thead>
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
<th></th>
        <th>
            Ürün Kodu
        </th>
        <th>
            Ürün
        </th>
        <th>
            Miktar
        </th>
        <th></th>
    </tr>
</thead>
<tbody>
<cfoutput query="gets">
<tr>
    <td>#SARF_PRODUCT_CODE#</td>
    <td>#SARF_PRODUCT_NAME#</td>
    <td>#SARF_AMOUNT#</td>
    <td>
        
        <cfif SARF_AMOUNT gt AMOUNT><span style="color:orange" class="icn-md fa fa-arrow-up"></span></cfif>
        
        <cfif not LEN(PRODUCT_CODE) ><span style="color:orange" class="icn-md fa fa-arrow-up"></span><cfelse></cfif>
            <cfif LEN(PRODUCT_CODE) and len(SARF_PRODUCT_CODE)>  <cfif SARF_AMOUNT eq AMOUNT><span style="color:green" class="icn-md fa fa-check-circle"></span></cfif></cfif>
        </td>
    
    
    <td>#PRODUCT_CODE#</td>
    <td>#PRODUCT_NAME#</td>
    <td>#AMOUNT#</td>
    <td>
        <cfif AMOUNT gt SARF_AMOUNT><span style="color:red" class="icn-md fa fa-arrow-down"></span></cfif>
        <cfif not LEN(SARF_PRODUCT_CODE) ><span style="color:red" class="icn-md fa fa-arrow-down"></span><cfelse></cfif>
            <cfif LEN(PRODUCT_CODE) and len(SARF_PRODUCT_CODE)>  <cfif SARF_AMOUNT eq AMOUNT><span style="color:green" class="icn-md fa fa-check-circle"></span></cfif></cfif>
        </td>
    
</tr>
</cfoutput>
</tbody>
</cf_grid_list>
<!-------------
    S2.PRODUCT_CODE AS SARF_PRODUCT_CODE,S2.PRODUCT_NAME AS SARF_PRODUCT_NAME,T.A1 AS SARF_AMOUNT,S.PRODUCT_CODE,S.PRODUCT_NAME,T.AMOUNT
    ------------->
</cf_box>