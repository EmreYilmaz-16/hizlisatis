<cf_box title="Ürün Listesi">

<table>
<tr>
	
	<cfoutput><input type="hidden" name="PRICE_CAT" id="PRICE_CAT" value="#attributes.price_cat#">
	<input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="#attributes.price_catid#">
	<input type="hidden" name="company_name" id="company_name" value="#attributes.company_name#">
	<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#"></cfoutput>
    <td>
        <div class="form-group">
            
            <input type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
    </td>
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="hidden" name="get_company_id" id="get_company_id" value="">
            <input type="text" name="get_comp_name" id="get_comp_name" value="" placeholder="Tedarikçi" onfocus="AutoComplete_Create('get_comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID','get_company_id','','3','250',1,'applyFilters(1)');" autocomplete="off" style=""><div id="get_comp_name_div_2" name="get_comp_name_div_2" class="completeListbox" autocomplete="on" style="width: 259px; max-height: 150px; overflow: auto; position: absolute; left: 173.422px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_comp_name=product_form.get_comp_name&field_comp_id=product_form.get_company_id&call_function=applyFilters(1)');"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
            
            <input type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
    </td>
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
           
            <input type="text" name="miktar" id="miktar" onkeyup="Filtrele(this,event)" onchange="this.value=commaSplit(this.value)" value="<cfoutput>#TLFormat(1)#</cfoutput>" placeholder="Miktar" ></div>
            
            
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">		
            <input type="hidden" name="search_product_catid" id="search_product_catid" value="">
            <input type="hidden" name="product_catid" id="product_catid" value="">
            <input type="text" name="product_cat" id="product_cat" placeholder="Kategori" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,search_product_catid','','3','200',1,'applyFilters(1)');" autocomplete="off" style=""><div id="product_cat_div_2" name="product_cat_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 768.953px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_form.product_catid&field_hierarchy=product_form.search_product_catid&field_name=product_form.product_cat&caller_function=applyFilters&caller_function_paremeter=1');"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="Hidden" name="brand_id" id="brand_id">
            <input type="Text" name="brand_name" id="brand_name" placeholder="Marka" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100',1,'applyFilters(1)');" autocomplete="off" style=""><div id="brand_name_div_2" name="brand_name_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 932.375px; top: 79px; z-index: 159; display: none;"></div>
            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_extra_product_brands&brand_id=product_form.brand_id&brand_name=product_form.brand_name&caller_function=applyFilters&caller_function_parameter=1');"></span>
        </div></div>
    </td>
</tr>

</table>
<div id="product_list"></div>


<input type="hidden" name="company_id" value="#attributes.company_id#">
<input type="hidden" name="price_catid" value="#attributes.price_catid#">
<script>
var currentProductPage = 0;
function nextPage(syf) {
    var uri = filtreleriAl();
    AjaxPageLoad("index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" + uri + "&sayfa=" + syf, "product_list", 1, "Yükleniyor");
    currentProductPage = syf;
}
function beforePage(syf) {
    var uri = filtreleriAl();
    AjaxPageLoad("index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" + uri + "&sayfa=" + syf, "product_list", 1, "Yükleniyor");
    currentProductPage = syf;
}

function filtreleriAl() {
    var AddRess = "";
    
    var kw = document.getElementById("keyword").value;
    var cni = document.getElementById("get_company_id").value;
    var cn = document.getElementById("get_comp_name").value;

    var product_cat = document.getElementById("product_cat").value;
    var search_product_catid = document.getElementById("search_product_catid").value;

    var brand_id = document.getElementById("brand_id").value;
    var brand_name = document.getElementById("brand_name").value;

    var price_catid = document.getElementById("PRICE_CATID").value
    var price_cat = document.getElementById("PRICE_CAT").value

    var company_name = document.getElementById("company_name").value
    var company_id = document.getElementById("company_id").value

    var miktar = document.getElementById("miktar").value
    miktar = filterNum(miktar);

    if (kw.length > 0) AddRess += "&Keyword=" + kw; else AddRess += "&Keyword=";
    if (cni.length > 0 && cn.length > 0) AddRess += "&getCompId=" + cni; else AddRess += "&getCompId=";
    if (product_cat.length > 0 && search_product_catid.length > 0) AddRess += "&hiearchy=" + search_product_catid; else AddRess += "&hiearchy=";
    if (brand_name.length > 0 && brand_id.length > 0) AddRess += "&brand_id=" + brand_id; else AddRess += "&brand_id=";
    if (price_cat.length > 0 && price_catid.length > 0) AddRess += "&price_catid=" + price_catid; else AddRess += "&price_catid=";
    if (company_name.length > 0 && company_id.length > 0) AddRess += "&company_id=" + company_id; else AddRess += "&company_id=";
    AddRess += "&miktar=" + miktar;
    return AddRess
}
$(document).ready(function(){
	sayfaYukle();
})
function sayfaYukle() {
    var uri = filtreleriAl();
    var syf = 0;
    AjaxPageLoad("index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" + uri + "&sayfa=" + syf, "product_list", 1, "Yükleniyor");
}


</script>

</cf_box>