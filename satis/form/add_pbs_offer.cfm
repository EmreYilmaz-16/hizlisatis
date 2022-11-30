<link rel="stylesheet" href="/AddOns/Partner/satis/style/pbs_offer_pc.css">
<cfparam name="attributes.offer_id" default="">
<cf_catalystheader>
    <cfinclude template="../includes/virtual_offer_parameters.cfm">
  <cf_box>
    <cfform name="product_form">
    <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2,sayfa_3"  divLang="<img src='/images/e-pd/customer.png' style='width:35px' > ;<img src='/images/e-pd/basket.png' style='width:35px'>;<img src='/images/e-pd/sigma.png' style='width:35px'>" >
     
        <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/order_header_normal.cfm">
        </div>
        <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
            <span id="cnamear" style="margin:0;padding:0" class="pageCaption font-green-sharp bold">&nbsp;</span>
            <cfinclude template="../includes/product_list.cfm">
            <cfinclude template="../includes/basket_normal.cfm">
            
        </div>
        <div id="unique_sayfa_3" class="ui-info-text uniqueBox">
            <cfinclude template="../includes/basket_footer_normal.cfm">
        </div>
    </cfform>
</cf_box>

<script src="/AddOns/Partner/satis/js/basket_pc.js"></script>
<script src="/AddOns/Partner/satis/js/hizli_satis_pc.js"></script>
<script src="/AddOns/Partner/satis/js/virtual_operations.js"></script>
