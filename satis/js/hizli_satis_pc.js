function HataGoster(mesaj, tip, sure) {
  //success,warning,danger
  var d = document.createElement("div");
  d.setAttribute(
    "style",
    "  border: 1px solid;position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);padding: 10px;);z-index:999999;font-size:22pt"
  );
  d.setAttribute("class", "alert alert-" + tip);
  $(d).html(mesaj);
  document.body.appendChild(d);
  $(d).show(500);

  window.setTimeout(function () {
    $(d).remove();
  }, sure);
}
function openNoteBox() {
  if ($("#company_id_").val())
    openBoxDraggable(
      "index.cfm?fuseaction=objects.ajax_extra_notes_list&style=1&design_id=1&is_special=0&action_type=0&is_delete=1&action_section=COMPANY_ID&action_id=" +
        $("#company_id_").val() +
        "&is_open_det=1"
    );
}
function openPayMethods() {
  if ($("#company_id_").val()) {
    let url_param = "";
    if ($("#c_dueday_").val().length > 0)
      url_param = "&dueday=" + $("#c_dueday_").val();
    openBoxDraggable(
      "index.cfm?fuseaction=objects.popup_extra_paymethods" + url_param,
      "PayMethodModal"
    );
  }
}

function fillPayMethod(paymethod, paymethod_id, dueday, vehicle, type) {
  $("#paymethod_id_").val(paymethod_id);
  $("#paymethod_").val("Ödeme Yöntemi: " + paymethod);
  $("#dueday_").val(dueday);
  $("#paymethod_vehicle_").val(vehicle);
  if (type == 1) $("#c_dueday_").val(dueday);

  closeBoxDraggable("PayMethodModal");
}
function GetAjaxQuery(type, type_id) {
  var CompanyInfo = new Object();
  var url =
    "/index.cfm?fuseaction=objects.get_qs_info&ajax=1&ajax_box_page=1&isAjax=1";
  var myAjaxConnector = GetAjaxConnector();
  if (myAjaxConnector) {
    data = "type_id=" + type_id + "&q_type=" + type;
    myAjaxConnector.open("post", url + "&xmlhttp=1", false);
    myAjaxConnector.setRequestHeader(
      "If-Modified-Since",
      "Sat, 1 Jan 2000 00:00:00 GMT"
    );
    myAjaxConnector.setRequestHeader(
      "Content-Type",
      "application/x-www-form-urlencoded; charset=utf-8"
    );
    myAjaxConnector.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    myAjaxConnector.send(data);
    if (myAjaxConnector.readyState == 4 && myAjaxConnector.status == 200) {
      try {
        CompanyInfo = eval(
          myAjaxConnector.responseText.replace(/\u200B/g, "")
        )[0];
      } catch (e) {
        CompanyInfo = false;
      }
    }
  }
  return CompanyInfo;
}

function fillFields() {
  if (!list_find("37,38,39,40", window.event.keyCode)) {
    $("#item-comp_info input[readonly]").val("");
    let comp_id = $("#company_id_").val();
    let compInfo = GetAjaxQuery("CompanyInfo", comp_id);
    console.log("Buralarda Çalıştı");
    console.log(comp_info);
    $("#city_name").val(compInfo.CITY);
    $("#county_name").val(compInfo.COUNTY);
    $("#tax_no").val(compInfo.TAXNO);
    $("#phone").val(compInfo.PHONE);
    $("#customer_value").val(compInfo.CUSTOMER_VALUE);

    $("#plasiyer").val(compInfo.PLASIYER);
    $("#plasiyer_id").val(compInfo.PLASIYER_ID);

    fillPayMethod(
      compInfo.PAYMETHOD,
      compInfo.PAYMETHOD_ID,
      compInfo.VADE,
      compInfo.PAYMENT_VEHICLE,
      1
    );

    if (compInfo.BAKIYE.toString().length > 0)
      $("#bakiye").val("Bakiye: " + commaSplit(compInfo.BAKIYE));
    if (compInfo.BAKIYE < 0) $("#bakiye").css("color", "red");
    else $("#bakiye").css("color", "green");

    if (compInfo.RISK.toString().length > 0)
      $("#risk").val("Risk: " + commaSplit(compInfo.RISK));
    if (compInfo.RISK < 0) $("#risk").css("color", "red");
    else $("#risk").css("color", "green");

    $("#plasiyer").val(compInfo.PLASIYER);

    let url_params = "&comp_id=" + comp_id;
    $("#price_list option").remove();
    compInfo.PRICE_LISTS.forEach((list, index) => {
      let selected_status = "";
      if (list.IS_DEFAULT == 1) {
        selected_status = "selected";
        url_params += "&price_catid=" + list.PRICE_CATID;
      }
      let newOption =
        "<option value='" +
        list.PRICE_CATID +
        "' " +
        selected_status +
        ">" +
        list.PRICE_CAT +
        "</option>";
      $("#price_list").append(newOption);
    });
    $("#product_list").html("");
    if (compInfo.PRICE_LISTS.length > 0) loadProductList(url_params);
    else alert("Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz!");
  }
}
function applyFilters(type) {
  if (
    !list_find("37,38,39,40", window.event.keyCode) &&
    (window.event.keyCode == "13" || type > 0) &&
    $("#company_id_").val() &&
    $("#price_list").val()
  ) {
    $("#product_list").text("");
    var url_params = "";
    url_params += "&keyword=" + $("#keyword").val();
    url_params += "&comp_id=" + $("#company_id_").val();
    /* if($("#get_comp_name").val() && $("#get_company_id").val())
             url_params += '&get_company='+$("#get_company_id").val();
         if($("#product_cat").val() && $("#search_product_catid").val())
             url_params += '&product_hierarchy='+$("#search_product_catid").val();
         if($("#brand_name").val() && $("#brand_id").val())
             url_params += '&brand_id='+$("#brand_id").val();
         url_params += '&sort_type='+$("#sort_type").val();
         url_params += '&price_catid='+$("#price_list").val();
         url_params += '&maxrows='+$("#maxrows").val();*/
    //loadProductList(url_params);
  }
}
var currentProductPage = 0;
function nextPage(syf) {
  var uri = filtreleriAl();
  AjaxPageLoad(
    "index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" +
      uri +
      "&sayfa=" +
      syf,
    "product_list",
    1,
    "Yükleniyor"
  );
  currentProductPage = syf;
}
function beforePage(syf) {
  var uri = filtreleriAl();
  AjaxPageLoad(
    "index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" +
      uri +
      "&sayfa=" +
      syf,
    "product_list",
    1,
    "Yükleniyor"
  );
  currentProductPage = syf;
}

function filtreleriAl() {
  var AddRess = "";
  var kw = document.getElementById("keyword").value;
  var cni = document.getElementById("get_company_id").value;
  var cn = document.getElementById("get_comp_name").value;

  var product_cat = document.getElementById("product_cat").value;
  var search_product_catid = document.getElementById(
    "search_product_catid"
  ).value;

  var brand_id = document.getElementById("brand_id").value;
  var brand_name = document.getElementById("brand_name").value;

  var price_catid = document.getElementById("PRICE_CATID").value;
  var price_cat = document.getElementById("PRICE_CAT").value;

  var company_name = document.getElementById("company_name").value;
  var company_id = document.getElementById("company_id").value;

  var miktar = document.getElementById("miktar").value;
  miktar = filterNum(miktar);

  if (kw.length > 0) AddRess += "&Keyword=" + kw;
  else AddRess += "&Keyword=";
  if (cni.length > 0 && cn.length > 0) AddRess += "&getCompId=" + cni;
  else AddRess += "&getCompId=";
  if (product_cat.length > 0 && search_product_catid.length > 0)
    AddRess += "&hiearchy=" + search_product_catid;
  else AddRess += "&hiearchy=";
  if (brand_name.length > 0 && brand_id.length > 0)
    AddRess += "&brand_id=" + brand_id;
  else AddRess += "&brand_id=";
  if (price_cat.length > 0 && price_catid.length > 0)
    AddRess += "&price_catid=" + price_catid;
  else AddRess += "&price_catid=";
  if (company_name.length > 0 && company_id.length > 0)
    AddRess += "&company_id=" + company_id;
  else AddRess += "&company_id=";
  AddRess += "&miktar=" + miktar;
  return AddRess;
}

function sayfaYukle() {
  var uri = filtreleriAl();
  var syf = 0;
  AjaxPageLoad(
    "index.cfm?fuseaction=product.emptypopup_list_pbs_product_ajax" +
      uri +
      "&sayfa=" +
      syf,
    "product_list",
    1,
    "Yükleniyor"
  );
}
function Filtrele(el, ev) {
  //console.log(ev);
  if (ev.keyCode == 13 || ev.type == "click") {
    sayfaYukle();
  }
}

//document.write("hi")
/*
*****************Fonksiyonlar**********
getCustomer         ---Müşteri Listesini Getirir
showCustomerDiv     ---Müşteri Listesini Gösterir
HideCustomerDiv     ---Müşteri Listesini Gizler
setCompany          ---Müşteri Seçer Teklif Üst Bilgilierini Doldurur
GetAjaxQuery        ---Ajax Sorgu atar
TabCntFunction      ---menüler Arası Geçişte ki Çalışacak Fonksiyonların Yazıldığı yer
add_adress          ---Sevk Adresi Menüsünü Getirir
pbs_DatetimeFormat  ---sqlden gelen tarih saat bilgisi js formatına dönüştrürürü
getParameterByName  ---urlden gönderilen parametrenin değerini alır
*/

function getCustomer(ev, el) {
  var keyword = el.value;
  if (ev.keyCode == 13 || el.value.length >= 3) {
    /* $.ajax({
             url: "/index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=2",
             data: {
                 keyword: keyword
             },
             success: function (retDat) {
                 console.log(retDat)
                 var e = document.getElementById("cmpDiv");
                 $(e).html(retDat);
                 $(e).show(500);
             }
         })*/
    ShowCustomerDiv();
    AjaxPageLoad(
      "index.cfm?fuseaction=objects.emptypopup_get_company_partner&keyword=" +
        keyword,
      "cmpDiv",
      1,
      "Yükleniyor"
    );
  }
}

function ShowCustomerDiv() {
  var e = document.getElementById("cmpDiv");
  $(e).show(500);
}
function HideCustomerDiv() {
  var e = document.getElementById("cmpDiv");
  $(e).hide(500);
}

function setCompany(id, name, partner_id, partner_name, ttype = 1) {
  let compInfo = GetAjaxQuery("CompanyInfo", id);
  console.log(compInfo.PRICE_LISTS.length);
  if (compInfo.PRICE_LISTS.length == 0) {
    alert("Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz");
    return false;
  }
  $("#company_id").val(id);

  $("#company_name").val(name);
  $("#cnamear").text(name);
  $("#company_partner_id").val(partner_id);
  $("#company_partner_name").val(partner_name);
  //$("#BAKIYE").val(commaSplit(compInfo.BAKIYE, 2))
  //  $("#RISK").val(commaSplit(compInfo.RISK, 2))
  $("#PAYMETHOD").val(compInfo.PAYMETHOD);
  $("#PAYMETHOD_ID").val(compInfo.PAYMETHOD_ID);
  $("#SHIP_METHOD").val(compInfo.SHIP_METHOD);
  $("#SHIP_METHOD_ID").val(compInfo.SHIP_METHOD_ID);
  $("#VADE").val(compInfo.VADE);
  $("#plasiyer").val(compInfo.PLASIYER);
  $("#plasiyer_id").val(compInfo.PLASIYER_ID);
  var e = $("#qs_basket").find("input:radio");
  for (let i = 0; i < e.length; i++) {
    var a = e[i].parentElement.nextElementSibling.innerText;

    if (a == compInfo.SEL_MONEY) e[i].click();
  }
  console.log(compInfo);
  if (compInfo.BAKIYE.toString().length > 0)
    $("#BAKIYE").val("BAKIYE: " + commaSplit(compInfo.BAKIYE));
  if (compInfo.BAKIYE < 0) $("#BAKIYE").css("color", "red");
  else $("#BAKIYE").css("color", "green");

  if (compInfo.RISK.toString().length > 0)
    $("#RISK").val("Risk: " + commaSplit(compInfo.RISK));
  if (compInfo.RISK < 0) $("#RISK").css("color", "red");
  else $("#RISK").css("color", "green");

  for (let i = 0; i < compInfo.PRICE_LISTS.length; i++) {
    console.log(compInfo.PRICE_LISTS[i]);
    if (compInfo.PRICE_LISTS[i].IS_DEFAULT == 1) {
      $("#PRICE_CATID").val(compInfo.PRICE_LISTS[i].PRICE_CATID);
      $("#PRICE_CAT").val(compInfo.PRICE_LISTS[i].PRICE_CAT);
      CompanyData.PRICE_CAT = compInfo.PRICE_LISTS[i].PRICE_CATID;
    }
  }
  CompanyData.COMPANY_ID = id;
  CompanyData.NICK_NAME = name;

  // console.log(compInfo);
  HideCustomerDiv();
  setAddress(id);
  if (ttype == 1) {
    sayfaYukle();
  }
  if (compInfo.NOTE_COUNT > 0) {
    ShowMessage(id);
  }
}

function GetAjaxQuery(type, type_id) {
  var CompanyInfo = new Object();
  var url =
    "/index.cfm?fuseaction=objects.get_qs_info_partner&ajax=1&ajax_box_page=1&isAjax=1";
  var myAjaxConnector = GetAjaxConnector();
  if (myAjaxConnector) {
    data = "type_id=" + type_id + "&q_type=" + type;
    myAjaxConnector.open("post", url + "&xmlhttp=1", false);
    myAjaxConnector.setRequestHeader(
      "If-Modified-Since",
      "Sat, 1 Jan 2000 00:00:00 GMT"
    );
    myAjaxConnector.setRequestHeader(
      "Content-Type",
      "application/x-www-form-urlencoded; charset=utf-8"
    );
    myAjaxConnector.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    myAjaxConnector.send(data);
    if (myAjaxConnector.readyState == 4 && myAjaxConnector.status == 200) {
      try {
        CompanyInfo = eval(
          myAjaxConnector.responseText.replace(/\u200B/g, "")
        )[0];
      } catch (e) {
        CompanyInfo = false;
      }
    }
  }
  return CompanyInfo;
}

function emptyFunction() {
  return true;
}
function TabCntFunction(a, b, c, d, e, f) {
  console.log("Emre");
  console.log(arguments);
  var c = $("#company_id").val();
  var s = $("#SHIP_METHOD_ID").val();
  var o = $("#PAYMETHOD").val();
  var hata = false;
  if (c.length > 0) {
  } else {
    alert("Müşteri Seçmediniz");
    hata = true;
  }
  if (s.length > 0) {
  } else {
    alert("Sevk Yöntemi Seçmediniz");
    hata = true;
  }
  if (o.length > 0) {
  } else {
    alert("Ödeme Yöntemi Seçmediniz");
    hata = true;
  }
  if (hata) {
    return false;
  } else {
    return true;
  }
}

function add_adress() {
  if (
    !(product_form.company_id.value == "") ||
    !(product_form.consumer_id.value == "")
  ) {
    if (product_form.company_id.value != "") {
      str_adrlink =
        "&field_long_adres=product_form.ship_address&field_adress_id=product_form.ship_address_id";
      if (product_form.city_id != undefined)
        str_adrlink = str_adrlink + "&field_city=product_form.city_id";
      if (product_form.county_id != undefined)
        str_adrlink = str_adrlink + "&field_county=product_form.county_id";
      member_type_ = "partner";
      openBoxDraggable(
        "index.cfm?fuseaction=objects.popup_list_member_address&is_comp=1&company_id=" +
          product_form.company_id.value +
          "&member_name=" +
          product_form.company_name.value +
          "&member_type=" +
          member_type_ +
          "" +
          str_adrlink
      );
      return true;
    } else {
      str_adrlink =
        "&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id";
      if (product_form.city_id != undefined)
        str_adrlink = str_adrlink + "&field_city=form_basket.city_id";
      if (product_form.county_id != undefined)
        str_adrlink = str_adrlink + "&field_county=form_basket.county_id";
      member_type_ = "consumer";
      openBoxDraggable(
        "index.cfm?fuseaction=objects.popup_list_member_address&is_comp=0&consumer_id=" +
          product_form.consumer_id.value +
          "&member_name=" +
          product_form.partner_name.value +
          "&member_type=" +
          member_type_ +
          "" +
          str_adrlink
      );
      return true;
    }
  } else {
    alert(" Cari Hesap Seçmelisiniz !");
    return false;
  }
}

function setAddress(comp_id) {
  var res = wrk_query(
    "SELECT COMPANY_ADDRESS,CITY,COUNTY FROM COMPANY WHERE COMPANY_ID=" +
      comp_id,
    "dsn"
  );
  console.log(res);

  document.getElementById("city_id").value = res.CITY[0];
  document.getElementById("county_id").value = res.COUNTY[0];
  document.getElementById("ship_address_id").value = -1;
  document.getElementById("ship_address").value = res.COMPANY_ADDRESS[0];
}

function pbs_DatetimeFormat(dte) {
  var D = new Date(dte);
  console.log(D);
  var tarih = date_format(dte);
  console.log(tarih);

  var H = D.getHours().toString();
  console.log(H);
  var M = D.getMinutes().toString();
  console.log(M);
  if (H.length == 1) {
    H = "0" + H;
  }
  if (M.length == 1) {
    M = "0" + M;
  }
  tarih = tarih + " " + H + ":" + M;
  return tarih;
}

function isChCntPbs(el) {
  if ($(el).is(":checked")) {
    $("#sales_type_m").show();
    document.getElementById("siparis").checked = true;
  } else {
    $("#sales_type_m").hide();
    document.getElementById("sales_type_1").checked = false;
  }
}
function snl_teklif_chek(el) {
  if ($(el).is(":checked")) {
  } else {
    el.checked = true;
  }
}
function siparis_check(el) {
  if ($(el).is(":checked")) {
    // $("#sales_type_m").show()
    //  document.getElementById("siparis").checked = true
  } else {
    document.getElementById("sevkiyat").checked = false;
    document.getElementById("sales_type_1").checked = false;
    $("#sales_type_m").hide();
  }
}
function getParameterByName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return "";
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}
function getSevkYontem(el) {
  var q = wrk_query(
    "SELECT  SHIP_METHOD_ID,SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD LIKE '%" +
      el.value +
      "%' "
  );
  console.log(q);
  var es = document.getElementById("cmpDiv");
  $(es).html("");
  var tbl = document.createElement("table");
  for (let i = 0; i < q.recordcount; i++) {
    var tr = document.createElement("tr");
    var td = document.createElement("td");
    var a = document.createElement("a");
    a.innerText = q.SHIP_METHOD[i];
    a.setAttribute(
      "onclick",
      "setSevkYontem(" + q.SHIP_METHOD_ID[i] + ",'" + q.SHIP_METHOD[i] + "')"
    );
    td.appendChild(a);
    tr.appendChild(td);
    tbl.appendChild(tr);
  }
  var es = document.getElementById("cmpDiv");
  es.appendChild(tbl);
  $(es).show();
}

function setSevkYontem(id, txt) {
  var es = document.getElementById("cmpDiv");

  document.getElementById("SHIP_METHOD").value = txt;
  document.getElementById("SHIP_METHOD_ID").value = id;
  $(es).hide();
}

function getOdemeYontem(el) {
  var q = wrk_query(
    "select PAYMETHOD,PAYMETHOD_ID,DUE_DAY from SETUP_PAYMETHOD WHERE PAYMETHOD LIKE '%" +
      el.value +
      "%' ",
    "dsn"
  );
  console.log(q);
  var es = document.getElementById("cmpDiv");
  $(es).html("");
  var tbl = document.createElement("table");
  for (let i = 0; i < q.recordcount; i++) {
    var tr = document.createElement("tr");
    var td = document.createElement("td");
    var a = document.createElement("a");
    a.innerText = q.PAYMETHOD[i];
    a.setAttribute(
      "onclick",
      "setOdemeYontem(" +
        q.PAYMETHOD_ID[i] +
        ",'" +
        q.PAYMETHOD[i] +
        "'," +
        q.DUE_DAY[i] +
        ")"
    );
    td.appendChild(a);
    tr.appendChild(td);
    tbl.appendChild(tr);
  }
  var es = document.getElementById("cmpDiv");
  es.appendChild(tbl);
  $(es).show();
}

function setOdemeYontem(id, txt, due) {
  var es = document.getElementById("cmpDiv");

  document.getElementById("PAYMETHOD").value = txt;
  document.getElementById("PAYMETHOD_ID").value = id;
  document.getElementById("VADE").value = due;
  $(es).hide();
}

function openPriceList(
  type,
  pid_,
  sid_,
  tax,
  cost,
  manuel,
  product_name,
  stock_code,
  brand,
  indirim1,
  deliver_dept,
  basket_row_departman,
  deliver_date,
  amount,
  unit,
  price,
  other_money,
  price_other,
  product_name_other,
  detail_info_extra,
  row_nettotal
) {
  var price_params = "&product_id=" + pid_ + "&stock_id=" + sid_;
  if ($("#company_id_").val()) {
    price_params += "&company_id=" + $("#company_id_").val();
  }
  if (type == 0) {
    price_params += "&tax=" + tax;
    price_params += "&cost=" + cost;
    price_params += "&manuel=" + manuel;
    price_params += "&product_name=" + product_name;
    price_params += "&stock_code=" + stock_code;
    price_params += "&brand=" + brand;
    price_params += "&indirim1=" + indirim1;
    price_params += "&basket_row_departman=" + basket_row_departman;
    price_params += "&deliver_date=" + deliver_date;
    price_params += "&amount=" + amount;
    price_params += "&unit=" + unit;
    price_params += "&price=" + price;
    price_params += "&other_money=" + other_money;
    price_params += "&price_other=" + price_other;
    price_params += "&product_name_other=" + product_name_other;
    price_params += "&detail_info_extra=" + detail_info_extra;
    price_params += "&row_nettotal=" + row_nettotal;
  } else {
    price_params += "&satir=" + type;
  }
  openBoxDraggable(
    "index.cfm?fuseaction=objects.popup_extra_product_prices" + price_params
  );
}

function ShowMessage(company_id) {
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_show_company_notes&style=1&design_id=1&is_special=0&action_type=0&is_delete=1&action_section=COMPANY_ID&action_id=" +
      company_id +
      "&is_open_det=1"
  );
}

function openCariExtre() {
  var cp_id = $("#company_id").val();
  if (cp_id.length > 0) {
    windowopen(
      "http://erp.metosan.com.tr/index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=" +
        cp_id
    );
  } else {
    alert("Müşteri Seçmediniz");
  }
}
function openAnaliz(d1, d2) {
  var cp_id = $("#company_id").val();
  var cp_name = $("#company_name").val();
  if (cp_id.length > 0) {
    var uri =
      "http://erp.metosan.com.tr/index.cfm?fuseaction=report.sale_analyse_report&company_id=" +
      cp_id +
      "&company=" +
      cp_name +
      "&date1=" +
      d1 +
      "&date2=" +
      d2 +
      "&form_submitted=1&process_type_select=235&process_type_=235,42,222,43,30,32,179,199,120,123,190,191,236,122,223,200,121,193,240,216,201,189,34,204,38,203,198,33,225,35,192,237,229,224,194,127,205,176,206,36,207,29,209,31";
    windowopen(uri, "list");
  } else {
    alert("Müşteri Seçmediniz");
  }
}
function setProjects(PROJECT_ID, PROJECT_HEAD) {
  //var keyWord=el.value;
  document.getElementById("project_id").value = PROJECT_ID;
  document.getElementById("project_name").value = PROJECT_HEAD;
}
/*
"report.sale_analyse_report
  &PRODUCT_ID=
  &PRODUCT_NAME=
  &IMS_CODE_ID=
  IMS_CODE_NAME=
  &SUP_COMPANY_ID=
  &SUP_COMPANY=
  &PRODUCT_EMPLOYEE_ID=
  &EMPLOYEE_NAME=
  &POS_CODE=
  &POS_CODE_TEXT=
  CONSUMER_ID=
  &COMPANY_ID=22781
  &EMPLOYEE_ID2=
  &COMPANY=PARTNER BİLGİ SİTEMLERİ SANAYİ VE TİCARET LTD.ŞTİ
  &EMPLOYEE_ID=
  &EMPLOYEE=
  &SALES_MEMBER_ID=
  &SALES_MEMBER_TYPE=
  &SALES_MEMBER=
  &BRAND_ID=
  &BRAND_NAME=
  &MODEL_ID=
  &MODEL_NAME=
  &PRODUCT_TYPES=
  &SEARCH_PRODUCT_CATID=
  &PRODUCT_CAT=
  &REF_MEMBER_ID=
  &REF_MEMBER_TYPE=
  &REF_MEMBER=
  &PROJECT_ID=
  &PROJECT_HEAD=
  &PROMOTION_ID=
  &PROM_HEAD=
  &SHIP_METHOD_ID=
  &SHIP_METHOD_NAME=
  &SECTOR_CAT_ID=
  &SEGMENT_ID=
  &COUNTRY_ID=
  &CITY_ID=
  &COUNTY_ID=
  &COMMETHOD_ID=
  &ZONE_ID=
  &PROCESS_TYPE_SELECT=235
  &PROCESS_TYPE_=235,42,222,43,30,32,179,199,120,123,190,191,236,122,223,200,121,193,240,216,201,189,34,204,38,203,198,33,225,35,192,237,229,224,194,127,205,176,206,36,207,29,209,31&PRICE_CATID=&RESOURCE_ID=&CUSTOMER_VALUE_ID=&REPORT_TYPE=1&USE_EFATURA=&GRAPH_TYPE=&DATE1=01/01/2023&DATE2=17/05/2023&REPORT_SORT=1&MAXROWS=20&FORM_SUBMITTED=&WRK_SEARCH_BUTTON=Çalıştır"
*/
