<cfdump var="#attributes#">

<cfquery name="getRowData" datasource="#dsn2#">
SELECT S.PRODUCT_CODE,S.PRODUCT_NAME,SFR.AMOUNT,SFR.UNIT,SFR.UNIQUE_RELATION_ID,SFR.STOCK_FIS_ROW_ID 
,ISNULL(( SELECT SUM(KONTROL_AMOUNT) AS KONTROL_AMOUNT FROM workcube_metosan_1.PBS_PAKET_KONTROL WHERE ROW_ID=SFR.STOCK_FIS_ROW_ID),0) AS KONTROL_AMOUNT
FROM workcube_metosan_2023_1.STOCK_FIS_ROW AS SFR
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=SFR.STOCK_ID
WHERE  FIS_ID=#attributes.fis_id#
</cfquery>


<cf_big_list>
    <cfoutput query="getRowData">
        <tr>
            <td>#PRODUCT_CODE#</td>
            <td>#PRODUCT_NAME#</td>
            <td>#AMOUNT#</td>
            <td>#KONTROL_AMOUNT#</td>
            <td><button type="button" <cfif AMOUNT-KONTROL_AMOUNT EQ 0>class="btn btn-success"<cfelse>onclick="Kontrol_Et(#AMOUNT-KONTROL_AMOUNT#,#STOCK_FIS_ROW_ID#,'#UNIQUE_RELATION_ID#')" class="btn btn-primary"</cfif> >Kontrol Et</button></td>
        </tr>
    </cfoutput>
</cf_big_list>