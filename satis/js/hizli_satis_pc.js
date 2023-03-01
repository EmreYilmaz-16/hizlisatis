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
    !(hizliForm.company_id.value == "") ||
    !(hizliForm.consumer_id.value == "")
  ) {
    if (hizliForm.company_id.value != "") {
      str_adrlink =
        "&field_long_adres=hizliForm.ship_address&field_adress_id=hizliForm.ship_address_id";
      if (hizliForm.city_id != undefined)
        str_adrlink = str_adrlink + "&field_city=hizliForm.city_id";
      if (hizliForm.county_id != undefined)
        str_adrlink = str_adrlink + "&field_county=hizliForm.county_id";
      member_type_ = "partner";
      openBoxDraggable(
        "index.cfm?fuseaction=objects.popup_list_member_address&is_comp=1&company_id=" +
          hizliForm.company_id.value +
          "&member_name=" +
          hizliForm.company_name.value +
          "&member_type=" +
          member_type_ +
          "" +
          str_adrlink
      );
      return true;
    } else {
      str_adrlink =
        "&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id";
      if (hizliForm.city_id != undefined)
        str_adrlink = str_adrlink + "&field_city=form_basket.city_id";
      if (hizliForm.county_id != undefined)
        str_adrlink = str_adrlink + "&field_county=form_basket.county_id";
      member_type_ = "consumer";
      openBoxDraggable(
        "index.cfm?fuseaction=objects.popup_list_member_address&is_comp=0&consumer_id=" +
          hizliForm.consumer_id.value +
          "&member_name=" +
          hizliForm.partner_name.value +
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
