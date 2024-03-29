﻿<cf_box title="Sevkiyat Kontrol">
<cfquery name="getOnayData" datasource="#dsn3#">
    EXEC GET_ONAY '#attributes.DELIVER_PAPER_NO#'
</cfquery>
<cfif getOnayData.recordCount>
<button id="btnEmir" onclick="SaveKesimEmir(<CFOUTPUT>'#attributes.DELIVER_PAPER_NO#',#session.ep.userid#</CFOUTPUT>)" disabled="yes" class="ui-wrk-btn ui-wrk-btn-busy">Fatura Kesim Talebi Oluştur</button>
<cfelse>
    <button id="btnEmir" onclick="SaveKesimEmir(<CFOUTPUT>'#attributes.DELIVER_PAPER_NO#',#session.ep.userid#</CFOUTPUT>)"  class="ui-wrk-btn ui-wrk-btn-success">Fatura Kesim Talebi Oluştur</button>
</cfif>
<cf_big_list>
    <thead>
    <tr>
        <th>
            Ürün
        </th>
        <th>
            Marka
        </th>
        <th>
            Ölçü
        </th>
        <th>
            Hazırlanan Miktar
        </th>
        
        <th>
            Onaylanan Miktar
        </th>
        <th>
            Birim
        </th>
        <th>

        </th>
    </tr>
</thead>
<tbody>
<cfoutput query="getOnayData">
<tr>
    <td>
        #PRODUCT_NAME#
    </td>
    <td>
        #BRAND_NAME#
    </td>
    <td>
        #DETAIL_INFO_EXTRA#
    </td>
    <td>
        #SF_MIK#
    </td>
    <td>
        #ONY_MIK#
    </td>
    <td>
        #MAIN_UNIT#
    </td>
    <td>
        <CFSET KALAN=SF_MIK-ONY_MIK>
        <button type="button" class="ui-wrk-btn ui-wrk-btn-red" onclick="OnaylaCanim(#FIS_ID#,'#UNIQUE_RELATION_ID#',#KALAN#,#session.EP.userid#,#PERIOD_ID#,'#DSN3#',this)">Onayla</button>
    </td>
</tr>
</cfoutput>
</tbody>
</cf_big_list>

<script>
<cfoutput>
    var REC_COUNT=#getOnayData.recordCount#;
</cfoutput>
    function OnaylaCanim(FIS_ID,UNIQUE_RELATION_ID,AMOUNT,EMPLOYEE_ID,PERIOD_ID,DSN3,el) {
        $.ajax({
            url:"/AddOns/Partner/cfc/pdaServis.cfc?method=OnaylaCanim",
            data:{
                PERIOD_ID:PERIOD_ID,
                FIS_ID:FIS_ID,
                EMPLOYEE_ID:EMPLOYEE_ID,
                UNIQUE_RELATION_ID:UNIQUE_RELATION_ID,
                AMOUNT:AMOUNT,
                DSN3:DSN3
            }
        }).done(function(reta){
            console.log(reta)
            el.setAttribute("class","ui-wrk-btn ui-wrk-btn-success");
            el.innerText="Onaylandı";
            REC_COUNT--;
            if(REC_COUNT==0){
                document.getElementById("btnEmir").removeAttribute("disabled");
                document.getElementById("btnEmir").setAttribute("class","ui-wrk-btn ui-wrk-btn-success");
            }
        })
    }
    function SaveKesimEmir(DELIVER_PAPER_NO,EMPLOYEE_ID) {
       var Res= wrk_query("SELECT DELIVER_PAPER_NO,SHIP_RESULT_ID FROM PRTOTM_SHIP_RESULT WHERE DELIVER_PAPER_NO='"+DELIVER_PAPER_NO+"'","DSN3")
       var belgeId=Res.SHIP_RESULT_ID[0];
        $.post("/AddOns/Partner/satis/cfc/kontrol.cfc?method=emirver&svk_id="+belgeId+"&employee_id="+EMPLOYEE_ID);
        window.close();
    }
</script>


<!----------
    ORR_MIK	SF_MIK	FIS_ID	STOCK_ID	ONY_MIK	UNIQUE_RELATION_ID	DETAIL_INFO_EXTRA	SHIP_METHOD	PRODUCT_CODE	PRODUCT_NAME	MAIN_UNIT	BRAND_NAME
50	50	82682	3929	0	PBS4520231201082633021Z	NULL	10	TM.KP.HK.TK.13928	56-61 MM TAKVİYELİ KELEPÇE	Adet	KYZ

<cfargument name="FIS_ID">
        <cfargument name="PERIOD_ID">
        <cfargument name="EMPLOYEE_ID">
        <cfargument name="UNIQUE_RELATION_ID">
        <cfargument name="AMOUNT">
        <cfargument name="DSN3">
---------->
</cf_box>