<cfquery name="getOnayData" datasource="#dsn3#">
    EXEC GET_ONAY '#attributes.DELIVER_PAPER_NO#'
</cfquery>

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
        <button type="button" class="btn btn-danger" onclick="OnaylaCanim(#FIS_ID#,'#UNIQUE_RELATION_ID#',#KALAN#,#session.EP.userid#,#PERIOD_ID#,'#DSN3#',this)">Onayla</button>
    </td>
</tr>
</cfoutput>
</tbody>
</cf_big_list>

<script>
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
            el.setAttribute("class","btn btn-success");
        })
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