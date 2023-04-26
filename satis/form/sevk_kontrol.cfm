<cfparam name="attributes.islem" default="getir">
<cfif attributes.islem eq "getir">
<cf_box title="Sevk Kontrol">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&islem=getir">
        <div class="form-group">
            <input type="text" placeholder="SVK Numarası" id="svk_number" name="svk_number">
            
        </div>
        <input type="hidden" name="is_submit">
        <input type="submit">
    </cfform>
</cf_box>

<cfif isDefined("attributes.is_submit")>
    <cfquery name="getS" datasource="#dsn2#">
       
       SELECT FIS_NUMBER,FIS_DATE,FIS_ID,LOCATION_OUT,DEPARTMENT_OUT,workcube_metosan.getEmployeeWithId(SF.RECORD_EMP) AS RECORD_EMP ,SL.COMMENT,D.DEPARTMENT_HEAD

FROM #dsn2#.STOCK_FIS AS SF 
INNER JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=SF.LOCATION_OUT AND SL.DEPARTMENT_ID=SF.DEPARTMENT_OUT
INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID  WHERE REF_NO='#attributes.svk_number#'
    </cfquery>
    <cf_big_list>
        <thead>
            <tr>
                <th>Hazırlama</th>
                <th>Hazırlama Tarihi</th>
                <th>Hazırlama Deposu</th>
                <th>Hazırlayan</th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="getS">
            <tr>
                <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&islem=detay&ship_fis_id=#FIS_ID#">#FIS_NUMBER#</a></td>
                <td>#dateFormat(FIS_DATE,"dd/mm/yyyy")#</td>
                <td>#DEPARTMENT_HEAD#-#COMMENT#</td>
                <td>#RECORD_EMP#</td>
                
            </tr>
        </cfoutput>
    </tbody>
    </cf_big_list>
</cfif>
</cfif>
<cfif attributes.islem eq "detay">
    <cfquery name="getKontrol" datasource="#dsn2#">
SELECT ISNULL(PSK.KONTROL_AMOUNT,0) AS KONTROL_AMOUNT,SFR.AMOUNT AS KONTROL_EDILECEK,S.PRODUCT_NAME,S.PRODUCT_CODE,PSK.UNIQUE_RELATION_ID  FROM  #dsn2#.PRTOTM_SVK_KONTROL AS PSK
LEFT JOIN #dsn2#.STOCK_FIS_ROW AS SFR ON SFR.UNIQUE_RELATION_ID=PSK.UNIQUE_RELATION_ID
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=SFR.STOCK_ID
WHERE SHIP_FIS_ID=#attributes.ship_fis_id#
    </cfquery>
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&islem=kayit">
<cf_big_list>
    <thead>
        <tr>
            <th>Ürün K</th>
            <th>Ürün A</th>
            <th>Kontrol Edilen</th>
            <th>Kontrol Edilecek</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="getKontrol">
        <tr>            
            <td>#PRODUCT_CODE#</td>
            <td>#PRODUCT_NAME#</td>
            <td>#KONTROL_AMOUNT#</td>
            <td>#KONTROL_EDILECEK#</td>
            <td>
                <input type="checkbox" name="uniqKeys" value="#UNIQUE_RELATION_ID#">
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_big_list>
<cfoutput><input type="hidden" name="fis_id" value="#attributes.ship_fis_id#"></cfoutput>
<input type="submit" value="Kontrol Kaydet">
</cfform>

</cfif>

<cfif attributes.islem eq "kayit">
    <cfquery name="getKontrol" datasource="#dsn2#">
        SELECT ISNULL(PSK.KONTROL_AMOUNT,0) AS KONTROL_AMOUNT,SFR.AMOUNT AS KONTROL_EDILECEK,S.PRODUCT_NAME,S.PRODUCT_CODE,PSK.UNIQUE_RELATION_ID  FROM  #dsn2#.PRTOTM_SVK_KONTROL AS PSK
        LEFT JOIN #dsn2#.STOCK_FIS_ROW AS SFR ON SFR.UNIQUE_RELATION_ID=PSK.UNIQUE_RELATION_ID
        LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=SFR.STOCK_ID
        WHERE PSK.UNIQUE_RELATION_ID IN (
        <cfloop list="#attributes.uniqKeys#" item="ix">
            '#ix#',
        </cfloop>
        ''
        )
    </cfquery>
    <cfloop query="getKontrol">
        <cfquery name="upd" datasource="#dsn2#">
            UPDATE #dsn2#.PRTOTM_SVK_KONTROL SET KONTROL_AMOUNT=#KONTROL_EDILECEK# WHERE UNIQUE_RELATION_ID='#UNIQUE_RELATION_ID#' AND SHIP_FIS_ID=#attributes.fis_id#
        </cfquery>
    </cfloop> 
</cfif>