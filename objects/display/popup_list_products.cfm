<cf_box title="Ürün Listesi" scroll="1" collapsable="1" resize="1" popup_box="1" draggable="1">
<cfparam name="attributes.actType" default="">
<cfparam name="attributes.SIPARIS_MIKTARI" default="1">
<cfparam name="attributes.columnsa" default="">
<cfparam name="attributes.arrayid" default="">
<div class="row">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="display: flex;flex-wrap: wrap;align-content: end;justify-content: flex-start;align-items: baseline;">
        <div class="form-group">
            <input class="form-control" type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
        <button class="btn btn-success" type="button" onclick="Filtre()">
            <span class="icn-md icon-search pull-right"></span>
            Filtrele
        </button>
    </div>
</div>

<cfif attributes.actType eq 4 or attributes.actType eq 5>
    <form name="product_form" onsubmit="event.preventDefault(); return false;">
</cfif>
<table>
<tr>
	
	<cfoutput><input type="hidden" name="PRICE_CAT" id="PRICE_CAT" value="#attributes.price_cat#">
	<input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="#attributes.price_catid#">
	<input type="hidden" name="company_name" id="company_name" value="#attributes.company_name#">
	<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
	<input type="hidden" name="question_id" id="question_id" value="#attributes.question_id#">
    <input type="hidden" name="actType" id="actType" value="#attributes.actType#">
    <input type="hidden" name="SIPARIS_MIKTARI" id="SIPARIS_MIKTARI" value="#attributes.SIPARIS_MIKTARI#">
    <input type="hidden" name="arrayid" id="arrayid" value="#attributes.arrayid#">
    <input type="hidden" name="columnsa" id="columnsa" value="#attributes.columnsa#">
	</cfoutput>

    <td>
        <div class="form-group">
            
            
        </div>
    </td>
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="hidden" name="get_company_id" id="get_company_id" value="">
            <input type="text" class="form-control form-control-lg" name="get_comp_name" id="get_comp_name" value="" placeholder="Tedarikçi" onfocus="AutoComplete_Create('get_comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID','get_company_id','','3','250',1,'applyFilters(1)');" autocomplete="off" style=""><div id="get_comp_name_div_2" name="get_comp_name_div_2" class="completeListbox" autocomplete="on" style="width: 259px; max-height: 150px; overflow: auto; position: absolute; left: 173.422px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_comp_name=product_form.get_comp_name&field_comp_id=product_form.get_company_id&call_function=applyFilters(1)');"></span>
        </div>
    </div>
    </td>
   <!--- <td>
        <div class="form-group">
            
            <input type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
    </td>---->
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
           
            <input type="text" name="miktar" class="form-control form-control-lg" id="miktar" onkeyup="Filtrele(this,event)" onchange="this.value=commaSplit(this.value)" value="<cfoutput>#TLFormat(1)#</cfoutput>" placeholder="Miktar" ></div>
            
            
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">		
            <input type="hidden" name="search_product_catid" id="search_product_catid" value="">
            <input type="hidden" name="product_catid" id="product_catid" value="">
            <input disabled="" type="text" class="form-control form-control-lg" name="product_cat" id="product_cat" placeholder="Kategori" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,search_product_catid','','3','200',1,'applyFilters(1)');" autocomplete="off" style=""><div id="product_cat_div_2" name="product_cat_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 768.953px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-text btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_form.product_catid&field_hierarchy=product_form.search_product_catid&field_name=product_form.product_cat&caller_function=applyFilters&caller_function_paremeter=1');"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="Hidden" name="brand_id"  id="brand_id">
            <input disabled=""  type="Text" class="form-control form-control-lg" name="brand_name" id="brand_name" placeholder="Marka" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100',1,'applyFilters(1)');" autocomplete="off" style=""><div id="brand_name_div_2" name="brand_name_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 932.375px; top: 79px; z-index: 159; display: none;"></div>
            <span class="input-group-text btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_extra_product_brands&brand_id=product_form.brand_id&brand_name=product_form.brand_name&caller_function=applyFilters&caller_function_parameter=1');"></span>
        </div></div>
    </td>
</tr>

</table>
<cfif attributes.actType eq 4 or 0 eq 5>
</form>
</cfif>
<div id="product_list"></div>

<button class="btn btn-danger" onclick="closeBoxDraggable(getModalId())">Kapat</button>

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

    var question_id = document.getElementById("question_id").value
    
    var actType=document.getElementById("actType").value
    var arrayid=document.getElementById("arrayid").value
    var siparis_miktari=document.getElementById("SIPARIS_MIKTARI").value
    var columnsa=document.getElementById("columnsa").value
    var miktar = document.getElementById("miktar").value
    miktar = filterNum(miktar);

    if (kw.length > 0) AddRess += "&Keyword=" + kw; else AddRess += "&Keyword=";
    if(question_id.length>0) AddRess+="&question_id="+question_id; else AddRess+="&question_id=0";
    if (cni.length > 0 && cn.length > 0) AddRess += "&getCompId=" + cni; else AddRess += "&getCompId=";
    if (product_cat.length > 0 && search_product_catid.length > 0) AddRess += "&hiearchy=" + search_product_catid; else AddRess += "&hiearchy=";
    if (brand_name.length > 0 && brand_id.length > 0) AddRess += "&brand_id=" + brand_id; else AddRess += "&brand_id=";
    if (price_cat.length > 0 && price_catid.length > 0) AddRess += "&price_catid=" + price_catid; else AddRess += "&price_catid=";
    if (company_name.length > 0 && company_id.length > 0) AddRess += "&company_id=" + company_id; else AddRess += "&company_id=";
    AddRess += "&miktar=" + miktar;
    AddRess += "&actType=" + actType;
    AddRess += "&arrayid=" + arrayid;
    AddRess += "&columnsa=" + columnsa;
    AddRess += "&SIPARIS_MIKTARI=" + siparis_miktari;
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

function getModalId(){
var e=document.getElementsByClassName("ui-draggable-box")[0]
	var modal_id=list_last(e.getAttribute("id"),"_")
	return modal_id
}

function Filtrele(el, ev) {
    if (ev.keyCode == 13) {
        sayfaYukle();
    }
}
function Filtre() {
    sayfaYukle();
}
</script>

</cf_box>