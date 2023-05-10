<cfquery name="getMoney" datasource="#dsn#">
    SELECT SELECT
ISNULL(M,MONEY) AS MONEY,
ISNULL(R1,RATE1) AS RATE1,
ISNULL(R2,RATE2) AS RATE2,
MONEY_ID
 FROM (
SELECT SM.MONEY,SM.RATE1,SM.RATE2,SMH.*,SM.MONEY_ID
FROM workcube_metosan.SETUP_MONEY  AS SM
LEFT JOIN (
SELECT
TOP 3
RATE1 AS R1,RATE2 AS R2,MONEY AS M  FROM workcube_metosan.MONEY_HISTORY WHERE PERIOD_ID=3  AND DAY(RECORD_DATE)=10 AND MONTH(RECORD_DATE)=5 AND YEAR(RECORD_DATE)=2023 ORDER BY RECORD_DATE DESC
) AS SMH ON SMH.M=SM.MONEY
WHERE PERIOD_ID=#session.ep.PERIOD_ID#

) AS T
order by MONEY_ID
</cfquery>

<cf_box title="#attributes.p_name#" scroll="1" collapsable="1" resize="1" popup_box="1">
   <cfoutput>
    <cfform id="rowExra_#attributes.rowid#">
        <div class="form-group" >
            <label>Döviz Fiyatı</label>
            <input type="text" name="row_extra_price_other" id="row_extra_price_other" value="#attributes.price_other#">
           
        </div>
        <div class="form-group" >
            <label>Döviz</label>
            <select name="row_extra_other_money" id="row_extra_other_money">
                <cfloop query="getMoney">
                    <option <cfif attributes.other_money eq MONEY>selected</cfif> value="#MONEY#">#MONEY#</option>
                </cfloop>
            </select>
        </div>
    <div class="form-group" style="display:none">
        <label>Vergi</label>
        <input type="text" name="row_extra_tax" id="row_extra_tax_tax" value="#attributes.tax#">
       
    </div>
    <div class="form-group">
        <label>İndirim</label>
        <input type="text" name="row_extra_disc" id="row_extra_disc" value="#attributes.disc#">
       
    </div>
</cfform>

    <button class="btn btn-success" type="button" onclick="saveRowExtra(#attributes.rowid#,'#attributes.modal_id#')">Kaydet</button>    
    <button class="btn btn-danger" type="button" onclick="closeBoxDraggable(#attributes.modal_id#)">Kapat</button>    
</cfoutput>
</cf_box>

