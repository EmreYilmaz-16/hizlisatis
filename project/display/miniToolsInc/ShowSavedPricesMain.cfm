<cfquery name="getMains" datasource="#dsn3#">
    select *,workcube_metosan.getEmployeeWithId(RECORD_EMP) AS KAYDEDEN,ISNULL((
    SELECT SUM((((AMOUNT*PRICE)-((AMOUNT*PRICE)*DISCOUNT)/100))*RATE2) AS TUTAR FROM workcube_metosan_1.PROJECT_REAL_PRODUCTS_TREE_PRICES AS PTP
LEFT JOIN workcube_metosan_1.PROJECT_PRODUCTS_TREE_PRICES_MAIN_MONEY AS OM  ON OM.MONEY=PTP.OTHER_MONEY AND OM.MAIN_ID=PTP.MAIN_ID

 WHERE PTP.MAIN_ID=PROJECT_PRODUCTS_TREE_PRICES_MAIN.MAIN_ID AND UPPER_TRERE_ID=10000000

),0) AS TUTAR from workcube_metosan_1.PROJECT_PRODUCTS_TREE_PRICES_MAIN WHERE 
PROJECT_ID =#attributes.PROJECT_ID# AND MAIN_PRODUCT_ID=#attributes.MAIN_PRODUCT_ID#

</cfquery>

<cf_grid_list>
    <thead>
        <tr>
            <th>
                Kayıt Tarihi
            </th>
            <th>
                Kayıt Eden
            </th>
            <th>
                Ürün Tutarı
            </th>
            <th>
                
            </th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="getMains">
            <tr>
                <td>
                    #dateformat(RECORD_DATE,"dd/mm/yyyy")#
                </td>
                <td>
                    #KAYDEDEN#
                </td>
                <TD>#TLFORMAT(TUTAR)#</TD>
                <td>
                    <button onclick="FiyatlariYukle(#MAIN_ID#,'#attributes.modal_id#')">Fiyatları Yükle</button>
                </td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>