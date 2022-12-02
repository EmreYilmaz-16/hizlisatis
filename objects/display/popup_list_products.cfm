<div id="product_list"></div>



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
    return AddRess="";
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