<cfquery name="getSettings" datasource="#dsn3#" result="Res">
    SELECT * FROM VIRTUAL_OFFER_SETTINGS
</cfquery>

<style>
    body{
background:white;
    }
</style>
<script>    
  <cfoutput>
    var generalParamsSatis={
        dataSources:{
            dsn:'#dsn#',
            dsn1:'#dsn1#',
            dsn2:'#dsn2#',
            dsn3:'#dsn3#'
        },
        userData:{
            user_id:#session.ep.USERID#,
            ourCompanyId:#session.ep.COMPANY_ID#,
            Money:'#session.ep.MONEY#',
            Money2:'#session.ep.MONEY2#',
            periodId:#session.ep.PERIOD_ID#,
            periodYear:#session.ep.PERIOD_YEAR#,
        },
        workingParams:{
            <cfloop list="#Res.COLUMNLIST#" item="ix">
                #ix#:#evaluate("getSettings.#ix#")#,
            </cfloop>
        }
    };
  </cfoutput>
</script>
<cf_box title="Hızlı Satış" >
 
    <cfform method="post" action="#request.self#" autocomplete="off">
        <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2,sayfa_3,sayfa_4,sayfa_5" divLang="Sipariş ;Sepet;sayfa3;sayfa4;sayfa5">
        <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
            <cfinclude template="order_header.cfm">
        </div>
        <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
            <cfinclude template="basket.cfm">
        </div>
        <div id="unique_sayfa_3" class="ui-info-text uniqueBox">sayfa3</div>
        <div id="unique_sayfa_4" class="ui-info-text uniqueBox">sayfa4</div>
        <div id="unique_sayfa_5" class="ui-info-text uniqueBox">sayfa5</div>
    </cfform>
    
</cf_box>

<!----

<script>
 <cfinclude template="../js/hizli_satis_pda.js">
    <cfinclude template="../js/basket.js">*/
</script>

----->
<script src="/AddOns/Partner/Tests/Includes/js/basket.js"></script>
<script src="/AddOns/Partner/Tests/Includes/js/hizli_satis_pda.js"/>
