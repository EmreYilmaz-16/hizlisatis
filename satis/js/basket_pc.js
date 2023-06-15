var HataArr = [];
var row_count = 0;
var rwww = "";
var rwwwx = "";
var rwwwxy = "";
var selectedCount = 0;
var rowCount = 0;
var tempProductData = "";
var selectedArr = [];
var CompanyData = new Object();
$(document).ready(function () {
  setDoom();
  if (getParameterByName("event") == "upd") {
    CalisanKontrolPbs();
  }
});

function setDoom() {
  $(".ui-form-list-btn").parent().hide();
  $("#basketArea")
    .find(".ui-scroll")
    .attr("style", "height:" + (window.innerHeight * 50) / 100 + "px;max");

  $("#scrollbarProject").attr("style", "margin-bottom:0;overflow-y:hidden");
  document.body.addEventListener("click", hideP);

  if (generalParamsSatis.workingParams.SHOW_HYDROLIC == 0) {
    $("#hydBtn").hide();
  }
  if (generalParamsSatis.workingParams.SHOW_PUMP == 0) {
    $("#pumpBtn").hide();
  }
  if (generalParamsSatis.workingParams.SHOW_TUBE == 0) {
    $("#hoseBtn").hide();
  }
  if (generalParamsSatis.workingParams.SHOW_VIRTUAL_PRODUCT == 0) {
    $("#vpBtn").hide();
  }
  FiyatTalepKontrol(0);
}

function hideP() {
  $(".pbsContex").remove();
}

/**
 *
 * @description Sepete Satır Ekler
 * @param {boolean} is_virtual Sanal Ürün Olup Olmama
 * @param {number} poduct_type Ürün Tipi 0-Normal Ürün 1-Hortum 2-Hidrolik 3-Pompa 4-Teklif Ürünü
 * @param {boolean} is_manuel Manuel Fiyat Kontrolü Ürün Ek Bilgi
 * @returns void
 *  TODO: Yön değişimi İçin AddRow Güncellenecek
 */

function AddRow(
  product_id,
  stock_id,
  stock_code,
  brand_name,
  is_virtual,
  quantity,
  price,
  product_name,
  tax,
  discount_rate,
  poduct_type = 0,
  shelf_code = "",
  other_money = "TL",
  price_other,
  currency = "-6",
  is_manuel = 0,
  cost = 0,
  product_unit = "Adet",
  product_name_other = "",
  detail_info_extra = "",
  fc = 0,
  rowNum = "",
  deliver_date = "",
  is_production = 0,
  row_uniq_id = "",
  description = "",
  rfls = "",
  converted_sid = 0
) {
  console.log(arguments);
  var form = $(document);
  var checkedValue = form.find("input[name=_rd_money]:checked").val();
  var BASKET_MONEY = document.getElementById(
    "_hidden_rd_money_" + checkedValue
  ).value;
  if (product_unit == "M" && fc == 0) {
    var calculate_params =
      "&pid_=" +
      product_id +
      "&sid_=" +
      stock_id +
      "&tax=" +
      tax +
      "&cost=" +
      cost +
      "&manuel=" +
      is_manuel +
      "&product_name=" +
      product_name +
      "&stock_code=" +
      stock_code +
      "&brand=" +
      brand_name +
      "&indirim1=" +
      discount_rate +
      "&amount=" +
      quantity +
      "&unit=" +
      product_unit +
      "&price=" +
      price +
      "&other_money=" +
      other_money +
      "&price_other=" +
      price_other;
    calculate_params += "&is_virtual=" + is_virtual;
    calculate_params += "&product_type=" + poduct_type;
    calculate_params += "&shelf_code=" + shelf_code;
    calculate_params += "&rowNum=" + row_count;
    openBoxDraggable(
      "index.cfm?fuseaction=objects.emptypopup_extra_calculate_pbs" +
        calculate_params
    );
    return true;
  }
  var q = "SELECT PP.SHELF_CODE  FROM PRODUCT_PLACE_ROWS AS PPR";
  q +=
    " LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID";
  q += " WHERE STOCK_ID=" + stock_id;
  var res = wrk_query(q, "dsn3");
  var RafKodu = "";
  if (shelf_code.length == 0) {
    if (res.recordcount > 0) {
      if (res.recordcount > 1 && fc == 0) {
        var calculate_params =
          "&pid_=" +
          product_id +
          "&sid_=" +
          stock_id +
          "&tax=" +
          tax +
          "&cost=" +
          cost +
          "&manuel=" +
          is_manuel +
          "&product_name=" +
          product_name +
          "&stock_code=" +
          stock_code +
          "&brand=" +
          brand_name +
          "&indirim1=" +
          discount_rate +
          "&amount=" +
          quantity +
          "&unit=" +
          product_unit +
          "&price=" +
          price +
          "&other_money=" +
          other_money +
          "&price_other=" +
          price_other;
        calculate_params += "&is_virtual=" + is_virtual;
        calculate_params += "&product_type=" + poduct_type;
        calculate_params += "&shelf_code=" + shelf_code;
        calculate_params += "&rowNum=" + row_count;
        openBoxDraggable(
          "index.cfm?fuseaction=objects.emptypopup_select_raf_pbs" +
            calculate_params
        );
        return true;
      } else {
        RafKodu = res.SHELF_CODE[0];
      }
    }
  } else {
    RafKodu = shelf_code;
  }
  row_count++;
  rowCount = row_count;
  var rsss = moneyArr.find((p) => p.MONEY == other_money);
  var prc = price_other * rsss.RATE2;

  if (price == 0) {
    var q =
      "SELECT ISNULL(workcube_metosan_1.GET_CURRENT_PRODUCT_PRICE(" +
      CompanyData.COMPANY_ID +
      "," +
      CompanyData.PRICE_CAT +
      "," +
      stock_id +
      "),0) AS FIYAT";
    var res = wrk_query(q, "dsn3");
    prc = res.FIYAT[0];
    price = res.FIYAT[0];
    price_other = res.FIYAT[0];
    other_money = "TL";
  }
  var tr = document.createElement("tr");
  /* console.log("Manuel From Attributes" + is_manuel);
  console.log(
    "Manuel From Working Params" +
      generalParamsSatis.workingParams.MANUEL_CONTROL
  );*/

  if (is_manuel == 1) {
    tr.setAttribute("style", "background-color:#86b5ff75 !important;");
  }
  tr.setAttribute("id", "row_" + row_count);
  tr.setAttribute("data-selected", "0");
  tr.setAttribute("data-rc", row_count);
  tr.setAttribute("data-ProductType", poduct_type);
  tr.setAttribute("class", "sepetRow");

  var td = document.createElement("td");
  var spn = document.createElement("span");
  spn.innerText = row_count;
  1;
  spn.setAttribute("id", "spn_" + row_count);
  td.appendChild(spn);
  var spn2 = document.createElement("span");
  if (row_count != 1) {
    spn2.setAttribute("class", "fa fa-arrow-up");
    spn2.setAttribute(
      "onclick",
      "moveRow(" + row_count + "," + (row_count - 1) + ")"
    );
  } else {
    spn2.setAttribute("class", "");
  }
  td.appendChild(spn2);
  tr.appendChild(td);

  var td = document.createElement("td");
  var cbx = document.createElement("input");
  cbx.setAttribute("type", "checkbox");
  cbx.setAttribute("data-row", row_count);
  cbx.setAttribute("onclick", "selectrw(this)");
  td.appendChild(cbx);
  tr.appendChild(td);

  var td = document.createElement("td");
  var i_1 = document.createElement("input");
  i_1.setAttribute("name", "product_id_" + row_count);
  i_1.setAttribute("id", "product_id_" + row_count);
  i_1.setAttribute("type", "hidden");
  i_1.setAttribute("value", product_id);

  var i_2 = document.createElement("input");
  i_2.setAttribute("name", "stock_id_" + row_count);
  i_2.setAttribute("id", "stock_id_" + row_count);
  i_2.setAttribute("type", "hidden");
  i_2.setAttribute("value", stock_id);

  var i_3 = document.createElement("input");
  i_3.setAttribute("name", "is_virtual_" + row_count);
  i_3.setAttribute("id", "is_virtual_" + row_count);
  i_3.setAttribute("type", "hidden");
  i_3.setAttribute("value", is_virtual);

  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "shelf_code_" + row_count);
  i_4.setAttribute("id", "shelf_code_" + row_count);
  i_4.setAttribute("type", "hidden");
  i_4.setAttribute("value", RafKodu);

  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "cost_" + row_count);
  i_5.setAttribute("id", "cost_" + row_count);
  i_5.setAttribute("type", "hidden");
  i_5.setAttribute("value", cost);

  var i_6 = document.createElement("input");
  i_6.setAttribute("name", "is_production_" + row_count);
  i_6.setAttribute("id", "is_production_" + row_count);
  i_6.setAttribute("type", "hidden");
  i_6.setAttribute("value", is_production);

  var i7 = document.createElement("input");
  i7.setAttribute("name", "row_uniq_id_" + row_count);
  i7.setAttribute("id", "row_uniq_id_" + row_count);
  i7.setAttribute("type", "hidden");
  if (row_uniq_id.length > 0) {
    i7.setAttribute("value", row_uniq_id);
  } else {
    var rwuid = GenerateUniqueId();
    i7.setAttribute("value", rwuid);
  }

  var i8 = document.createElement("input");
  i8.setAttribute("name", "is_manuel_" + row_count);
  i8.setAttribute("id", "is_manuel_" + row_count);
  i8.setAttribute("type", "hidden");
  i8.setAttribute("value", is_manuel);

  td.appendChild(i_1);
  td.appendChild(i_2);
  td.appendChild(i_3);
  td.appendChild(i_4);
  td.appendChild(i_5);
  td.appendChild(i_6);
  td.appendChild(i7);
  td.appendChild(i8);

  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "stock_code_" + row_count);
  i_4.setAttribute("id", "stock_code_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("readonly", "");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("class", "stockkodu");
  i_4.setAttribute("value", stock_code);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:15%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "product_name_" + row_count);
  i_4.setAttribute("id", "product_name_" + row_count);
  i_4.setAttribute("class", "urunadi");
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", product_name);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "brand_name_" + row_count);
  i_4.setAttribute("id", "brand_name_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("disabled", "");
  i_4.setAttribute("value", brand_name);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var rff = getRafSml(stock_id, RafKodu);
  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "department_name" + row_count);
  i_4.setAttribute("id", "department_name" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("disabled", "");
  i_4.setAttribute("value", rff);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "display:flex;align-items: baseline;");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  var sel_1 = AsamaYapici(row_count, currency);

  var satistl = document.createElement("span");
  satistl.setAttribute("class", "icon-detail");
  satistl.setAttribute(
    "onclick",
    "openBoxDraggable('index.cfm?fuseaction=objects.popup_detail_product&pid=" +
      product_id +
      "&sid=" +
      stock_id +
      "')"
  );
  div.appendChild(sel_1);

  td.appendChild(div);
  if (is_virtual != 1) {
    td.appendChild(satistl);
  }
  tr.appendChild(td);
  /*
 <a href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_detail_product&amp;pid=38109&amp;sid=38109')">
                <i class="icon-detail" title="Ürün Detay Bilgisi"></i>
            </a>
*/
  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "amount_" + row_count);
  i_5.setAttribute("id", "amount_" + row_count);
  i_5.setAttribute("type", "text");
  i_5.setAttribute("class", "prtMoneyBox");
  i_5.setAttribute("value", commaSplit(quantity, 2));
  i_5.setAttribute("onchange", "hesapla('price'," + row_count + ")");
  i_5.setAttribute("onClick", "sellinputAllVal(this)");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_5);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "main_unit_" + row_count);
  i_5.setAttribute("id", "main_unit_" + row_count);
  i_5.setAttribute("type", "text");
  i_5.setAttribute("style", "width:20px");
  i_5.setAttribute("readonly", "");
  i_5.setAttribute("value", product_unit);
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_5);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var sel = document.createElement("select");
  sel.setAttribute("name", "other_money_" + row_count);
  sel.setAttribute("id", "other_money_" + row_count);
  sel.setAttribute("onchange", "hesapla('other_money'," + row_count + ")");
  for (let index = 0; index < moneyArr.length; index++) {
    const element = moneyArr[index];
    var option = document.createElement("option");
    option.setAttribute("value", element.MONEY);
    option.innerText = element.MONEY;
    sel.appendChild(option);
  }
  sel.value = other_money;
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(sel);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_10 = document.createElement("input");
  i_10.setAttribute("name", "price_other_" + row_count);
  i_10.setAttribute("id", "price_other_" + row_count);
  i_10.setAttribute("type", "text");
  i_10.setAttribute("onchange", "hesapla('price_other'," + row_count + ")");
  i_10.setAttribute("class", "prtMoneyBox");
  i_10.setAttribute("style", "width:30px");
  i_10.setAttribute("value", commaSplit(price_other));

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_10);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_6 = document.createElement("input");
  i_6.setAttribute("name", "price_" + row_count);
  i_6.setAttribute("id", "price_" + row_count);
  i_6.setAttribute("type", "text");
  i_6.setAttribute("onchange", "hesapla('price'," + row_count + ")");
  i_6.setAttribute("onClick", "sellinputAllVal(this)");
  i_6.setAttribute("class", "prtMoneyBox");
  i_6.setAttribute("style", "width:30px");
  i_6.setAttribute("value", commaSplit(prc, 2));
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_6);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");

  var i_9 = document.createElement("input");
  i_9.setAttribute("name", "indirim1_" + row_count);
  i_9.setAttribute("id", "indirim1_" + row_count);
  i_9.setAttribute("value", commaSplit(discount_rate));
  i_9.setAttribute("type", "text");
  i_9.setAttribute(
    "onchange",
    "getSetNum(this)&hesapla('price'," + row_count + ")"
  );
  i_9.setAttribute("class", "prtMoneyBox");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_9);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var i_7 = document.createElement("input");
  i_7.setAttribute("name", "row_nettotal_" + row_count);
  i_7.setAttribute("id", "row_nettotal_" + row_count);
  i_7.setAttribute("type", "text");
  i_7.setAttribute("class", "prtMoneyBox");

  i_7.setAttribute("value", commaSplit(0, 2));

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_7);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:15%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "product_name_other_" + row_count);
  i_4.setAttribute("id", "product_name_other_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", product_name_other);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:8%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "detail_info_extra_" + row_count);
  i_4.setAttribute("id", "detail_info_extra_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", detail_info_extra);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var dtd = new Date();
  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "deliver_date_" + row_count);
  i_4.setAttribute("id", "deliver_date_" + row_count);
  i_4.setAttribute("type", "date");

  if (deliver_date.length > 0) {
    i_4.setAttribute("value", deliver_date);
  } else {
    i_4.setAttribute("value", dtd.toISOString().split("T")[0]);
  }

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "display:none");
  td.setAttribute("class", "hiddenR");
  var i_8 = document.createElement("input");
  i_8.setAttribute("name", "Tax_" + row_count);
  i_8.setAttribute("id", "Tax_" + row_count);
  i_8.setAttribute("value", commaSplit(tax));

  var i88 = document.createElement("input");
  i88.setAttribute("name", "converted_sid_" + row_count);
  i88.setAttribute("id", "converted_sid_" + row_count);
  i88.setAttribute("value", converted_sid);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_8);
  div.appendChild(i88);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  var input_11 = document.createElement("input");
  input_11.setAttribute("name", "description_" + row_count);
  input_11.setAttribute("id", "description_" + row_count);
  input_11.setAttribute("value", description);
  div.appendChild(input_11);
  td.appendChild(div);
  tr.appendChild(td);

  rowaListener(tr);
  var bask = document.getElementById("tbl_basket");
  bask.appendChild(tr);
  hesapla("other_money", rowCount);
  manuelControl();
  RowControlForVirtual();
}
function AddRow_pbso(
  product_id,
  stock_id,
  stock_code,
  brand_name,
  is_virtual,
  quantity,
  price,
  product_name,
  tax,
  discount_rate,
  poduct_type = 0,
  shelf_code = "",
  other_money = "TL",
  price_other,
  currency = "-6",
  is_manuel = 0,
  cost = 0,
  product_unit = "Adet",
  product_name_other = "",
  detail_info_extra = "",
  fc = 0,
  rowNum = "",
  deliver_date = "",
  is_production = 0,
  row_uniq_id = "",
  description = "",
  rfls = "",
  converted_sid = 0
) {
  console.log(arguments);
  var form = $(document);
  var checkedValue = form.find("input[name=_rd_money]:checked").val();
  var BASKET_MONEY = document.getElementById(
    "_hidden_rd_money_" + checkedValue
  ).value;
  if (product_unit == "M" && fc == 0) {
    var calculate_params =
      "&pid_=" +
      product_id +
      "&sid_=" +
      stock_id +
      "&tax=" +
      tax +
      "&cost=" +
      cost +
      "&manuel=" +
      is_manuel +
      "&product_name=" +
      product_name +
      "&stock_code=" +
      stock_code +
      "&brand=" +
      brand_name +
      "&indirim1=" +
      discount_rate +
      "&amount=" +
      quantity +
      "&unit=" +
      product_unit +
      "&price=" +
      price +
      "&other_money=" +
      other_money +
      "&price_other=" +
      price_other;
    calculate_params += "&is_virtual=" + is_virtual;
    calculate_params += "&product_type=" + poduct_type;
    calculate_params += "&shelf_code=" + shelf_code;
    calculate_params += "&rowNum=" + row_count;
    openBoxDraggable(
      "index.cfm?fuseaction=objects.emptypopup_extra_calculate_pbs" +
        calculate_params
    );
    return true;
  }
  var q = "SELECT PP.SHELF_CODE  FROM PRODUCT_PLACE_ROWS AS PPR";
  q +=
    " LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID";
  q += " WHERE STOCK_ID=" + stock_id;

  var RafKodu = "";
  if (shelf_code.length == 0 && stock_id != 0) {
    var res = wrk_query(q, "dsn3");
    if (res.recordcount > 0) {
      if (res.recordcount > 1 && fc == 0) {
        var calculate_params =
          "&pid_=" +
          product_id +
          "&sid_=" +
          stock_id +
          "&tax=" +
          tax +
          "&cost=" +
          cost +
          "&manuel=" +
          is_manuel +
          "&product_name=" +
          product_name +
          "&stock_code=" +
          stock_code +
          "&brand=" +
          brand_name +
          "&indirim1=" +
          discount_rate +
          "&amount=" +
          quantity +
          "&unit=" +
          product_unit +
          "&price=" +
          price +
          "&other_money=" +
          other_money +
          "&price_other=" +
          price_other;
        calculate_params += "&is_virtual=" + is_virtual;
        calculate_params += "&product_type=" + poduct_type;
        calculate_params += "&shelf_code=" + shelf_code;
        calculate_params += "&rowNum=" + row_count;
        openBoxDraggable(
          "index.cfm?fuseaction=objects.emptypopup_select_raf_pbs" +
            calculate_params
        );
        return true;
      } else {
        RafKodu = res.SHELF_CODE[0];
      }
    }
  } else {
    RafKodu = shelf_code;
  }
  row_count++;
  rowCount = row_count;
  var rsss = moneyArr.find((p) => p.MONEY == other_money);
  var prc = price_other * rsss.RATE2;

  if (price == 0) {
    var q =
      "SELECT ISNULL(workcube_metosan_1.GET_CURRENT_PRODUCT_PRICE(" +
      CompanyData.COMPANY_ID +
      "," +
      CompanyData.PRICE_CAT +
      "," +
      stock_id +
      "),0) AS FIYAT";
    var res = wrk_query(q, "dsn3");
    prc = res.FIYAT[0];
    price = res.FIYAT[0];
    price_other = res.FIYAT[0];
    other_money = "TL";
  }
  var tr = document.createElement("tr");
  /* console.log("Manuel From Attributes" + is_manuel);
  console.log(
    "Manuel From Working Params" +
      generalParamsSatis.workingParams.MANUEL_CONTROL
  );*/

  if (is_manuel == 1) {
    tr.setAttribute("style", "background-color:#86b5ff75 !important;");
  }
  tr.setAttribute("id", "row_" + row_count);
  tr.setAttribute("data-selected", "0");
  tr.setAttribute("data-rc", row_count);
  tr.setAttribute("data-ProductType", poduct_type);
  tr.setAttribute("class", "sepetRow");

  var td = document.createElement("td");
  var spn = document.createElement("span");
  spn.innerText = row_count;
  1;
  spn.setAttribute("id", "spn_" + row_count);
  td.appendChild(spn);
  var spn2 = document.createElement("span");
  if (row_count != 1) {
    spn2.setAttribute("class", "fa fa-arrow-up");
    spn2.setAttribute(
      "onclick",
      "moveRow(" + row_count + "," + (row_count - 1) + ")"
    );
  } else {
    spn2.setAttribute("class", "");
  }
  td.appendChild(spn2);
  tr.appendChild(td);

  var td = document.createElement("td");
  var cbx = document.createElement("input");
  cbx.setAttribute("type", "checkbox");
  cbx.setAttribute("data-row", row_count);
  cbx.setAttribute("onclick", "selectrw(this)");
  td.appendChild(cbx);
  tr.appendChild(td);

  var td = document.createElement("td");
  var i_1 = document.createElement("input");
  i_1.setAttribute("name", "product_id_" + row_count);
  i_1.setAttribute("id", "product_id_" + row_count);
  i_1.setAttribute("type", "hidden");
  i_1.setAttribute("value", product_id);

  var i_2 = document.createElement("input");
  i_2.setAttribute("name", "stock_id_" + row_count);
  i_2.setAttribute("id", "stock_id_" + row_count);
  i_2.setAttribute("type", "hidden");
  i_2.setAttribute("value", stock_id);

  var i_3 = document.createElement("input");
  i_3.setAttribute("name", "is_virtual_" + row_count);
  i_3.setAttribute("id", "is_virtual_" + row_count);
  i_3.setAttribute("type", "hidden");
  i_3.setAttribute("value", is_virtual);

  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "shelf_code_" + row_count);
  i_4.setAttribute("id", "shelf_code_" + row_count);
  i_4.setAttribute("type", "hidden");
  i_4.setAttribute("value", RafKodu);

  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "cost_" + row_count);
  i_5.setAttribute("id", "cost_" + row_count);
  i_5.setAttribute("type", "hidden");
  i_5.setAttribute("value", cost);

  var i_6 = document.createElement("input");
  i_6.setAttribute("name", "is_production_" + row_count);
  i_6.setAttribute("id", "is_production_" + row_count);
  i_6.setAttribute("type", "hidden");
  i_6.setAttribute("value", is_production);

  var i7 = document.createElement("input");
  i7.setAttribute("name", "row_uniq_id_" + row_count);
  i7.setAttribute("id", "row_uniq_id_" + row_count);
  i7.setAttribute("type", "hidden");
  if (row_uniq_id.length > 0) {
    i7.setAttribute("value", row_uniq_id);
  } else {
    var rwuid = GenerateUniqueId();
    i7.setAttribute("value", rwuid);
  }

  var i8 = document.createElement("input");
  i8.setAttribute("name", "is_manuel_" + row_count);
  i8.setAttribute("id", "is_manuel_" + row_count);
  i8.setAttribute("type", "hidden");
  i8.setAttribute("value", is_manuel);

  td.appendChild(i_1);
  td.appendChild(i_2);
  td.appendChild(i_3);
  td.appendChild(i_4);
  td.appendChild(i_5);
  td.appendChild(i_6);
  td.appendChild(i7);
  td.appendChild(i8);

  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "stock_code_" + row_count);
  i_4.setAttribute("id", "stock_code_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("readonly", "");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("class", "stockkodu");
  i_4.setAttribute("value", stock_code);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:15%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "product_name_" + row_count);
  i_4.setAttribute("id", "product_name_" + row_count);
  i_4.setAttribute("class", "urunadi");
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", product_name);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "brand_name_" + row_count);
  i_4.setAttribute("id", "brand_name_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("disabled", "");
  i_4.setAttribute("value", brand_name);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);
  var rff = rfls;
  /*if (rfls.length == 0) {
    rff = getRafSml(stock_id, RafKodu);
  } else {
    rff = rfls;
  }*/
  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "department_name" + row_count);
  i_4.setAttribute("id", "department_name" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("disabled", "");
  i_4.setAttribute("value", rff);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "display:flex;align-items: baseline;");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  var sel_1 = AsamaYapici(row_count, currency);

  var satistl = document.createElement("span");
  satistl.setAttribute("class", "icon-detail");
  satistl.setAttribute(
    "onclick",
    "openBoxDraggable('index.cfm?fuseaction=objects.popup_detail_product&pid=" +
      product_id +
      "&sid=" +
      stock_id +
      "')"
  );
  div.appendChild(sel_1);

  td.appendChild(div);
  if (is_virtual != 1) {
    td.appendChild(satistl);
  }
  tr.appendChild(td);
  /*
 <a href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_detail_product&amp;pid=38109&amp;sid=38109')">
                <i class="icon-detail" title="Ürün Detay Bilgisi"></i>
            </a>
*/
  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "amount_" + row_count);
  i_5.setAttribute("id", "amount_" + row_count);
  i_5.setAttribute("type", "text");
  i_5.setAttribute("class", "prtMoneyBox");
  i_5.setAttribute("value", commaSplit(quantity, 2));
  i_5.setAttribute("onchange", "hesapla('price'," + row_count + ")");
  i_5.setAttribute("onClick", "sellinputAllVal(this)");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_5);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var i_5 = document.createElement("input");
  i_5.setAttribute("name", "main_unit_" + row_count);
  i_5.setAttribute("id", "main_unit_" + row_count);
  i_5.setAttribute("type", "text");
  i_5.setAttribute("style", "width:20px");
  i_5.setAttribute("readonly", "");
  i_5.setAttribute("value", product_unit);
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_5);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:3%");
  var sel = document.createElement("select");
  sel.setAttribute("name", "other_money_" + row_count);
  sel.setAttribute("id", "other_money_" + row_count);
  sel.setAttribute("onchange", "hesapla('other_money'," + row_count + ")");
  for (let index = 0; index < moneyArr.length; index++) {
    const element = moneyArr[index];
    var option = document.createElement("option");
    option.setAttribute("value", element.MONEY);
    option.innerText = element.MONEY;
    sel.appendChild(option);
  }
  sel.value = other_money;
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(sel);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_10 = document.createElement("input");
  i_10.setAttribute("name", "price_other_" + row_count);
  i_10.setAttribute("id", "price_other_" + row_count);
  i_10.setAttribute("type", "text");
  i_10.setAttribute("onchange", "hesapla('price_other'," + row_count + ")");
  i_10.setAttribute("class", "prtMoneyBox");
  i_10.setAttribute("style", "width:30px");
  i_10.setAttribute("value", commaSplit(price_other));

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_10);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");
  var i_6 = document.createElement("input");
  i_6.setAttribute("name", "price_" + row_count);
  i_6.setAttribute("id", "price_" + row_count);
  i_6.setAttribute("type", "text");
  i_6.setAttribute("onchange", "hesapla('price'," + row_count + ")");
  i_6.setAttribute("onClick", "sellinputAllVal(this)");
  i_6.setAttribute("class", "prtMoneyBox");
  i_6.setAttribute("style", "width:30px");
  i_6.setAttribute("value", commaSplit(prc, 2));
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_6);

  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:5%");

  var i_9 = document.createElement("input");
  i_9.setAttribute("name", "indirim1_" + row_count);
  i_9.setAttribute("id", "indirim1_" + row_count);
  i_9.setAttribute("value", commaSplit(discount_rate));
  i_9.setAttribute("type", "text");
  i_9.setAttribute(
    "onchange",
    "getSetNum(this)&hesapla('price'," + row_count + ")"
  );
  i_9.setAttribute("class", "prtMoneyBox");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_9);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var i_7 = document.createElement("input");
  i_7.setAttribute("name", "row_nettotal_" + row_count);
  i_7.setAttribute("id", "row_nettotal_" + row_count);
  i_7.setAttribute("type", "text");
  i_7.setAttribute("class", "prtMoneyBox");

  i_7.setAttribute("value", commaSplit(0, 2));

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_7);

  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "width:15%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "product_name_other_" + row_count);
  i_4.setAttribute("id", "product_name_other_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", product_name_other);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:8%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "detail_info_extra_" + row_count);
  i_4.setAttribute("id", "detail_info_extra_" + row_count);
  i_4.setAttribute("type", "text");
  i_4.setAttribute("style", "width:40px");
  i_4.setAttribute("value", detail_info_extra);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);

  var dtd = new Date();
  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var i_4 = document.createElement("input");
  i_4.setAttribute("name", "deliver_date_" + row_count);
  i_4.setAttribute("id", "deliver_date_" + row_count);
  i_4.setAttribute("type", "date");

  if (deliver_date.length > 0) {
    i_4.setAttribute("value", deliver_date);
  } else {
    i_4.setAttribute("value", dtd.toISOString().split("T")[0]);
  }

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i_4);
  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  td.setAttribute("style", "display:none");
  td.setAttribute("class", "hiddenR");

  var i_8 = document.createElement("input");
  i_8.setAttribute("name", "Tax_" + row_count);
  i_8.setAttribute("id", "Tax_" + row_count);
  i_8.setAttribute("value", commaSplit(tax));

  var i88 = document.createElement("input");
  i88.setAttribute("name", "converted_sid_" + row_count);
  i88.setAttribute("id", "converted_sid_" + row_count);
  i88.setAttribute("value", converted_sid);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  div.appendChild(i88);
  div.appendChild(i_8);
  td.appendChild(div);
  tr.appendChild(td);
  var td = document.createElement("td");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  var input_11 = document.createElement("input");
  input_11.setAttribute("name", "description_" + row_count);
  input_11.setAttribute("id", "description_" + row_count);
  input_11.setAttribute("value", description);
  div.appendChild(input_11);
  td.appendChild(div);
  tr.appendChild(td);

  rowaListener(tr);
  var bask = document.getElementById("tbl_basket");
  bask.appendChild(tr);
  hesapla("other_money", rowCount);
  manuelControl();
  RowControlForVirtual();
  FiyatTalepKontrol(rowCount);
}
function AsamaYapici(rc, selv) {
  var sel_1 = document.createElement("select");
  sel_1.setAttribute("name", "orderrow_currency_" + rc);
  sel_1.setAttribute("id", "orderrow_currency_" + rc);
  var opt = document.createElement("option");
  opt.setAttribute("value", -5);
  opt.innerText = "Üretim";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -6);
  opt.innerText = "Sevk";

  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -2);
  opt.innerText = "Tedarik";
  sel_1.appendChild(opt);
  var opt = document.createElement("option");
  opt.setAttribute("value", -1);
  opt.innerText = "Açık";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -10);
  opt.innerText = "Kapatıldı";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", 1);
  opt.innerText = "Fiyat Talep";
  sel_1.appendChild(opt);

  sel_1.value = selv;
  return sel_1;
}

function manuelControl() {
  var rw = document.getElementsByClassName("sepetRow");
  for (let i = 1; i <= rw.length; i++) {
    var ism = document.getElementById("is_manuel_" + i).value;
    //console.log(ism);
    if (parseInt(ism) == 1) {
      $("#row_" + i).css("background", "#86b5ff75");
    }
    hesapla("other_money", i);
  }
}

function UpdRow(
  pid,
  sid,
  is_virtual,
  qty,
  price,
  p_name,
  tax,
  discount_rate,
  row_id,
  currency = -1,
  stock_code = "",
  main_unit = "Adet"
) {
  console.log("Basket PC Upd Row");
  console.log(arguments);
  $("#product_id_" + row_id).val(pid);
  $("#stock_id_" + row_id).val(sid);
  $("#is_virtual_" + row_id).val(is_virtual);
  if (qty > 0) {
    $("#amount_" + row_id).val(qty);
  }
  if (price > 0) {
    $("#price_" + row_id).val(price);
  }
  $("#product_name_" + row_id).val(p_name);
  $("#Tax_" + row_id).val(tax);
  if (discount_rate > 0) {
    $("#indirim1_" + row_id).val(discount_rate);
  }
  $("#orderrow_currency_" + row_id).val(currency);
  $("#stock_code_" + row_id).val(stock_code);
  $("#main_unit_" + row_id).val(main_unit);
  hesapla("price", row_id);
  RowControlForVirtual();
}

function ShelfControl(pid, RafCode) {
  var q =
    "select DISTINCT SHELF_CODE,PPR.PRODUCT_PLACE_ID,PPR.PRODUCT_ID,PP.STORE_ID,PP.LOCATION_ID,PPR.PRODUCT_ID,SL.DEPARTMENT_LOCATION from " +
    generalParamsSatis.dataSources.dsn3 +
    ".PRODUCT_PLACE_ROWS AS PPR";
  q +=
    " LEFT JOIN " +
    generalParamsSatis.dataSources.dsn3 +
    ".PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID ";
  q +=
    " LEFT JOIN " +
    generalParamsSatis.dataSources.dsn +
    ".STOCKS_LOCATION AS SL ON  SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID ";
  q += "WHERE PPR.PRODUCT_ID=" + pid + " AND SHELF_CODE='" + RafCode + "'";
  var rafData = wrk_query(q, "dsn3");
  if (rafData.recordcount != 0) {
    return true;
  } else {
    if (generalParamsSatis.workingParams.IS_RAFSIZ == 0) {
      alert("Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır");
      return false;
    } else {
      alert(
        "Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır Rafsız Kayıt Yapılacaktır"
      );
      return true;
    }
  }
}

function getRafSml(stock_id, rafcode) {
  var q =
    "SELECT PP.SHELF_CODE,SL.COMMENT,D.DEPARTMENT_HEAD,PP.LOCATION_ID,PP.STORE_ID FROM workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ";
  q +=
    " LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID=PP.PRODUCT_PLACE_ID";
  q +=
    " LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID";
  q +=
    " LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID";
  q +=
    " WHERE PPR.STOCK_ID=" + stock_id + " AND PP.SHELF_CODE='" + rafcode + "'";
  var res = wrk_query(q);
  if (res.recordcount > 0) {
    return res.DEPARTMENT_HEAD[0] + " " + res.COMMENT[0];
  } else {
    return "";
  }
}

function hesapla(input, sira) {
  var price_ = $("#price_" + sira).val();
  var price_other_ = $("#price_other_" + sira).val();
  /*var price_ = filterNum($("#price_" + sira).val(), 8);

  var price_other_ = filterNum($("#price_other_" + sira).val(), 8);*/

  if (price_.indexOf(",") != -1) {
    price_ = filterNum(price_, 8);
  } else {
    price_ = filterNum(commaSplit(price_), 8);
  }

  if (price_other_.indexOf(",") != -1) {
    //console.log("t");
    price_other_ = filterNum(price_other_, 8);
  } else {
    //console.log("y");
    price_other_ = filterNum(commaSplit(price_other_), 8);
  }

  var amount_ = filterNum($("#amount_" + sira).val(), 8);
  var cost_ = $("#cost_" + sira).val();
  var indirim1_ = filterNum($("#indirim1_" + sira).val(), 8);
  var money_ = $("#other_money_" + sira).val();
  var r1 = filterNum(
    $(
      "#_txt_rate1_" +
        $("input[id^='_hidden_rd_money_'][value='" + money_ + "']")
          .prop("id")
          .split("_")[4]
    ).val(),
    8
  );
  var r2 = filterNum(
    $(
      "#_txt_rate2_" +
        $("input[id^='_hidden_rd_money_'][value='" + money_ + "']")
          .prop("id")
          .split("_")[4]
    ).val(),
    8
  );

  $("#qs_basket tbody tr[data-rc='" + sira + "']").css(
    "background-color",
    "white"
  );
  if (list_find("price,other_money", input)) {
    price_other_ = (price_ * r1) / r2;
  } else if (input == "price_other") {
    price_ = (price_other_ * r2) / r1;
  }
  var newNettotal = ((price_ * (100 - indirim1_)) / 100) * amount_;
  if (generalParamsSatis.workingParams.MALIYET_CONTROL) {
    if (parseFloat((price_ * (100 - indirim1_)) / 100) < parseFloat(cost_)) {
      document
        .getElementById("row_" + sira)
        .setAttribute("style", "background-color:#ff06005c");
    } else {
      var exxc = parseInt(document.getElementById("is_manuel_" + sira).value);
      if (exxc == 0) {
        document.getElementById("row_" + sira).removeAttribute("style");
      }
    }
  }

  $("#price_other_" + sira).val(commaSplit(price_other_, 2));
  $("#price_" + sira).val(commaSplit(price_, 2));
  $("#row_nettotal_" + sira).val(commaSplit(newNettotal, 2));
  $("#amount_" + sira).val(commaSplit(amount_, 2));
  toplamHesapla();
  toplamHesapla_2();
}

function toplamHesapla() {
  var price_total_ = 0;
  var nettotal_total_ = 0;
  var tax_total_ = 0;
  var tax_price_total_ = 0;
  for (let i = 1; i <= rowCount; i++) {
    if ($("#price_" + i).val()) {
      let price_ = filterNum($("#price_" + i).val(), 8);
      let price_other_ = filterNum($("#price_other_" + i).val(), 8);
      let amount_ = filterNum($("#amount_" + i).val(), 8);
      let indirim1_ = filterNum($("#indirim1_" + i).val(), 8);
      let tax_ = $("#Tax_" + i).val();
      let money_ = $("#other_money_" + i).val();
      let nettotal_ = filterNum($("#row_nettotal_" + i).val(), 8);
      let r1 = filterNum(
        $(
          "#_txt_rate1_" +
            $("input[id^='_hidden_rd_money_'][value='" + money_ + "']")
              .prop("id")
              .split("_")[4]
        ).val(),
        8
      );
      let r2 = filterNum(
        $(
          "#_txt_rate2_" +
            $("input[id^='_hidden_rd_money_'][value='" + money_ + "']")
              .prop("id")
              .split("_")[4]
        ).val(),
        8
      );

      price_total_ += parseFloat(price_);
      nettotal_total_ += parseFloat(nettotal_);
      tax_total_ += parseFloat(nettotal_) * (parseInt(tax_) / 100);
      tax_price_total_ += parseFloat(nettotal_) * (1 + parseInt(tax_) / 100);
    }
  }
  $("#subTotal").val(commaSplit(nettotal_total_, 2));
  $("#subTaxTotal").val(commaSplit(tax_total_, 2));
  $("#subWTax").val(commaSplit(tax_price_total_, 2));
}
/**
 * !Toplam <br>
 * ?Bu Nedir<br>
 * TODO başka toplam hesaplanackmı \n<br>
 * *başka ne olmuş<br>
 * +buda yeniden olacak sanırm
 * -çıkarılacak bunlar
 */
function toplamHesapla_2() {
  var rows = document.getElementsByClassName("sepetRow");
  var netT = 0;
  var taxT = 0;
  var discT = 0;
  var grosT = 0;
  var kdv_matrah = 0;
  for (let i = 1; i <= rows.length; i++) {
    var prc = filterNum(document.getElementById("price_" + i).value);
    var qty = filterNum(document.getElementById("amount_" + i).value);
    var dsc = filterNum(document.getElementById("indirim1_" + i).value);
    var tax = filterNum(document.getElementById("Tax_" + i).value);
    var tts = prc * qty;
    var ds = (tts * dsc) / 100;
    var ttr = tts - ds;
    var tx = (ttr * tax) / 100;
    netT += ttr;
    taxT += tx;
    discT += ds;
    grosT += tts;
  }
  var d = parseFloat(filterNum($("#txt_disc").val()));
  $("#txt_disc").val(commaSplit(d, 3));
  var udc = (netT * generalParamsSatis.workingParams.MAX_DISCOINT) / 100;
  if (d > udc) {
    alert(
      "Genel İndirim İşlem Tutarının %" +
        generalParamsSatis.workingParams.MAX_DISCOINT +
        "'ndan büyük Olmaz İndirim 0'lanacaktır"
    );
    $("#txt_disc").val(commaSplit(0, 3));
    d = 0;
  }
  $("#txt_total").val(commaSplit(grosT, 3));
  discT += d;

  $("#txt_disc_total").val(commaSplit(discT, 3));
  netT = grosT - discT;
  $("#txt_nokdv_total").val(commaSplit(netT, 3));
  taxT = (netT * 18) / 100;
  $("#txt_kdv_total").val(commaSplit(taxT, 3));
  $("#txt_withkdv_total").val(commaSplit(netT + taxT, 3));
  $("#basket_bottom_total").val(commaSplit(netT + taxT, 3));
}

function sellinputAllVal(el) {
  el.select();
}

function GetBasketData() {
  var rows = document.getElementsByClassName("sepetRow");
  var OrderRows = new Array();
  for (let Old_rw_id = 1; Old_rw_id <= rows.length; Old_rw_id++) {
    var product_name = document.getElementById(
      "product_name_" + Old_rw_id
    ).value;
    var product_id = document.getElementById("product_id_" + Old_rw_id).value;
    var stock_id = document.getElementById("stock_id_" + Old_rw_id).value;
    var is_virtual = document.getElementById("is_virtual_" + Old_rw_id).value;
    var amount = document.getElementById("amount_" + Old_rw_id).value;
    var price = document.getElementById("price_" + Old_rw_id).value;
    var other_money = document.getElementById("other_money_" + Old_rw_id).value;

    var row_nettotal = document.getElementById(
      "row_nettotal_" + Old_rw_id
    ).value;
    var converted_sid = document.getElementById(
      "converted_sid_" + Old_rw_id
    ).value;
    var shelf_code = document.getElementById("shelf_code_" + Old_rw_id).value;
    var Tax = document.getElementById("Tax_" + Old_rw_id).value;
    var indirim1 = document.getElementById("indirim1_" + Old_rw_id).value;
    var price_other = document.getElementById("price_other_" + Old_rw_id).value;
    var orderrow_currency = document.getElementById(
      "orderrow_currency_" + Old_rw_id
    ).value;
    var product_name_other = document.getElementById(
      "product_name_other_" + Old_rw_id
    ).value;
    var detail_info_extra = document.getElementById(
      "detail_info_extra_" + Old_rw_id
    ).value;
    var deliver_date_bask = document.getElementById(
      "deliver_date_" + Old_rw_id
    ).value;
    var is_production = document.getElementById(
      "is_production_" + Old_rw_id
    ).value;
    var description = document.getElementById("description_" + Old_rw_id).value;
    var row_uniq_id = document.getElementById("row_uniq_id_" + Old_rw_id).value;
    if (!generalParamsSatis.workingParams.IS_ZERO_QUANTITY) {
      var p = filterNum(price);
      if (p <= 0) {
        alert("0 Fiyatlı Kayıt Yapamazsıznız");
        return false;
      }
    }
    var Obj = {
      product_name: product_name,
      product_id: product_id,
      stock_id: stock_id,
      is_virtual: is_virtual,
      amount: amount,
      price: price,
      other_money: other_money,
      row_nettotal: row_nettotal,
      shelf_code: shelf_code,
      Tax: Tax,
      indirim1: indirim1,
      price_other: price_other,
      orderrow_currency: orderrow_currency,
      product_name_other: product_name_other,
      detail_info_extra: detail_info_extra,
      deliver_date_bask: deliver_date_bask,
      is_production: is_production,
      row_uniq_id: row_uniq_id,
      description: description,
      converted_sid: converted_sid,
    };
    OrderRows.push(Obj);
  }

  var COMPANY_ID = document.getElementById("company_id").value;
  var MEMBER_NAME = document.getElementById("company_name").value;
  var PAYMETHOD = document.getElementById("PAYMETHOD").value;
  var PAYMETHOD_ID = document.getElementById("PAYMETHOD_ID").value;
  var VADE = document.getElementById("VADE").value;
  var COMPANY_PARTNER_NAME = document.getElementById(
    "company_partner_name"
  ).value;
  var COMPANY_PARTNER_ID = document.getElementById("company_partner_id").value;
  var PROCESS_STAGE = document.getElementById("process_stage").value;
  var SHIP_METHOD = document.getElementById("SHIP_METHOD").value;
  var SHIP_METHOD_ID = document.getElementById("SHIP_METHOD_ID").value;
  var ORDER_ID = document.getElementById("order_id").value;
  var SUBTOTAL = document.getElementById("subTotal").value;
  var SUBTAXTOTAL = document.getElementById("subTaxTotal").value;
  var SUBNETTOTAL = document.getElementById("subWTax").value;

  var GROSS_TOTAL = document.getElementById("txt_total").value;
  var AFTER_DISCOUNT = document.getElementById("txt_disc").value;
  var DISCOUNT_TOTAL = document.getElementById("txt_disc_total").value;
  var TOTAL_WITHOUT_KDV = document.getElementById("txt_nokdv_total").value;
  var TAX_TOTAL = document.getElementById("txt_kdv_total").value;
  var TOTAL_WITH_KDV = document.getElementById("txt_withkdv_total").value;

  var OFFER_DATE = document.getElementById("offer_date").value;
  var OFFER_HEAD = document.getElementById("offer_head").value;
  var SHIP_ADDRESS = document.getElementById("ship_address").value;
  var SHIP_ADDRESS_ID = document.getElementById("ship_address_id").value;
  var CITY_ID = document.getElementById("city_id").value;
  var COUNTY_ID = document.getElementById("county_id").value;
  var OFFER_DESCRIPTION = document.getElementById("offer_desc").value;
  var PRICE_CATID = document.getElementById("PRICE_CATID").value;
  var PROJECT_NAME = document.getElementById("project_name").value;
  var PROJECT_ID = document.getElementById("project_id").value;
  SUBTOTAL = filterNum(SUBTOTAL, 4);
  SUBTAXTOTAL = filterNum(SUBTAXTOTAL, 4);
  SUBNETTOTAL = filterNum(SUBNETTOTAL, 4);

  GROSS_TOTAL = filterNum(GROSS_TOTAL, 4);
  AFTER_DISCOUNT = filterNum(AFTER_DISCOUNT, 4);
  DISCOUNT_TOTAL = filterNum(DISCOUNT_TOTAL, 4);
  TOTAL_WITHOUT_KDV = filterNum(TOTAL_WITHOUT_KDV, 4);
  TAX_TOTAL = filterNum(TAX_TOTAL, 4);
  TOTAL_WITH_KDV = filterNum(TOTAL_WITH_KDV, 4);

  var form = $(document);
  var checkedValue = form.find("input[name=_rd_money]:checked").val();

  var ISLEM_TIPI_PBS = "";
  if ($("#snl_teklif").is(":checked")) {
    ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "1,";
  }
  if ($("#siparis").is(":checked")) {
    ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "2,";
  }
  if ($("#sevkiyat").is(":checked")) {
    ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "3,";
  }
  if ($("#sales_type_1").is(":checked")) {
    ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "4,";
  }
  var BASKET_MONEY = document.getElementById(
    "_hidden_rd_money_" + checkedValue
  ).value;
  var basket_rate_1 = document.getElementById(
    "_txt_rate1_" + checkedValue
  ).value;
  var basket_rate_2 = document.getElementById(
    "_txt_rate2_" + checkedValue
  ).value;
  var PLASIYER = document.getElementById("plasiyer").value;
  var PLASIYER_ID = document.getElementById("plasiyer_id").value;
  var BASKET_RATE_1 = filterNum(basket_rate_1, 4);
  var BASKET_RATE_2 = filterNum(basket_rate_2, 4);
  var Fs = getParameterByName("fuseaction");
  var OrderHeader = {
    COMPANY_ID: COMPANY_ID,
    PAYMETHOD: PAYMETHOD,
    PAYMETHOD_ID: PAYMETHOD_ID,
    VADE: VADE,
    COMPANY_PARTNER_NAME: COMPANY_PARTNER_NAME,
    COMPANY_PARTNER_ID: COMPANY_PARTNER_ID,
    MEMBER_NAME: MEMBER_NAME,
    PROCESS_STAGE: PROCESS_STAGE,
    SHIP_METHOD: SHIP_METHOD,
    SHIP_METHOD_ID: SHIP_METHOD_ID,
    ORDER_ID: ORDER_ID,
    OFFER_DATE: OFFER_DATE,
    OFFER_HEAD: OFFER_HEAD,
    SHIP_ADDRESS: SHIP_ADDRESS,
    SHIP_ADDRESS_ID: SHIP_ADDRESS_ID,
    CITY_ID: CITY_ID,
    COUNTY_ID: COUNTY_ID,
    ISLEM_TIPI_PBS: ISLEM_TIPI_PBS,
    PRICE_CATID: PRICE_CATID,
    PLASIYER: PLASIYER,
    PLASIYER_ID: PLASIYER_ID,
    FACT: Fs,
    OFFER_DESCRIPTION: OFFER_DESCRIPTION,
    PROJECT_NAME: PROJECT_NAME,
    PROJECT_ID: PROJECT_ID,
  };

  var OrderFooter = {
    SUBTOTAL: SUBTOTAL,
    SUBTAXTOTAL: SUBTAXTOTAL,
    SUBNETTOTAL: SUBNETTOTAL,
    BASKET_MONEY: BASKET_MONEY,
    BASKET_RATE_1: BASKET_RATE_1,
    BASKET_RATE_2: BASKET_RATE_2,
    GROSS_TOTAL: GROSS_TOTAL,
    AFTER_DISCOUNT: AFTER_DISCOUNT,
    DISCOUNT_TOTAL: DISCOUNT_TOTAL,
    TOTAL_WITHOUT_KDV: TOTAL_WITHOUT_KDV,
    TAX_TOTAL: TAX_TOTAL,
    TOTAL_WITH_KDV: TOTAL_WITH_KDV,
  };

  var Order = {
    OrderHeader: OrderHeader,
    OrderRows: OrderRows,
    OrderMoney: moneyArr,
    OrderFooter: OrderFooter,
    WORKING_PARAMS: generalParamsSatis.workingParams,
  };
  return Order;
}
function KntO() {
  var Hata = 0;
  var rows = document.getElementsByClassName("sepetRow");
  var Sip = document.getElementById("siparis");
  var isChecked = $(Sip).is(":checked");

  for (let i = 1; i <= rows.length; i++) {
    var d = $("#orderrow_currency_" + i).val();
    //console.log("Durum=" + d);
    //console.log(parseInt(d) == -5);
    //console.log(parseInt(d) == -2);
    if ((parseInt(d) == -5 || parseInt(d) == -2) && !isChecked) {
      alert("Sipariş Seçili Olması Gerekmektedir");
      Hata = true;
    }
    if (parseInt(d) == -1 && isChecked) {
      alert("Sipariş Yapmak İçin Açıkta Aşama Kalmış Olmaması Gerekmektedir ");
      Hata = true;
    }
    if (parseInt(d) == 1 && isChecked) {
      alert("Fiyat Talep Aşamasında  Kalmış Olmaması Gerekmektedir ");
      Hata = true;
    }
  }
  if (Hata) return false;
  else return true;
}

function SaveOrder() {
  var BasketData = GetBasketData();
  if (KntO()) {
    if (BasketData) {
      var mapForm = document.createElement("form");
      mapForm.target = "Map";
      mapForm.method = "POST"; // or "post" if appropriate
      mapForm.action =
        "/index.cfm?fuseaction=sales.emptypopup_query_save_order";

      var mapInput = document.createElement("input");
      mapInput.type = "hidden";
      mapInput.name = "data";
      mapInput.value = JSON.stringify(BasketData);
      mapForm.appendChild(mapInput);

      document.body.appendChild(mapForm);

      map = window.open(
        "/index.cfm?fuseaction=sales.emptypopup_query_save_order",
        "Map",
        "status=0,title=0,height=600,width=800,scrollbars=1"
      );

      if (map) {
        mapForm.submit();
      } else {
        alert("You must allow popups for this map to work.");
      }
    }
  }
}

function selectrw(el) {
  rwwwx = el;
  if ($(rwwwx).is(":checked")) {
    var ix = rwwwx.getAttribute("data-row");
    var rw = document.getElementById("row_" + ix);
    rw.setAttribute("style", "background-color:#aaefff80");
    rw.setAttribute("data-selected", 1);
  } else {
    var ix = rwwwx.getAttribute("data-row");
    var rw = document.getElementById("row_" + ix);
    rw.setAttribute("style", "background-color:#fff");
    rw.setAttribute("data-selected", 0);
  }

  BasketSelControl();
}
function groupControl() {
  return true;
}
function BasketSelControl() {
  selectedArr.splice(0, selectedArr.length);
  var groupButton = {
    icon: "icn-md fa fa-cubes",
    txt: "Grupla",
    evntType: "onclick",
    evnt: "groupControl()",
    att: "disabled",
  };
  var removeButton = {
    icon: "icn-md icon-remove",
    txt: "Seçili Olanları Sil",
    evntType: "onclick",
    evnt: "removeSelected(this)",
    att: "",
  };
  var UpdateButton = {
    icon: "icn-md fa fa-history",
    txt: "Güncelle",
    evntType: "onclick",
    evnt: "return true",
    att: "disabled",
  };
  var searchButton = {
    icon: "icn-md fa fa-history",
    txt: "Filtrele",
    evntType: "onclick",
    evnt: "filterBasket()",
    att: "",
  };
  var treeButton = {
    icon: "icn-md fa fa-tree",
    txt: "Ağaç Görüntüle",
    evntType: "onclick",
    evnt: "showTree(this)",
    att: "disabled",
  };
  var TurnButton = {
    icon: "icn-md fa fa-recycle",
    txt: "Fiyat Detay",
    evntType: "onclick",
    evnt: "TurnOut(this)",
    att: "disabled",
  };
  var ConvertRealButton = {
    icon: "icn-md icon-check",
    txt: "Gerçek Ürüne Dönüştür",
    evntType: "onclick",
    evnt: "ConvertRealProduct(this)",
    att: "disabled",
  };
  var buttonGroups = [];
  var sepetRows = document.getElementsByClassName("sepetRow");
  for (let i = 0; i < sepetRows.length; i++) {
    var sepetRow = sepetRows[i];
    var isSelected = sepetRow.getAttribute("data-selected");
    if (parseInt(isSelected) == 1) {
      selectedArr.push(sepetRow);
    }
  }
  if (selectedArr.length == 1) {
    var e = selectedArr[0];
    var RwId = e.getAttribute("data-rc");
    var Ptype = e.getAttribute("data-producttype");
    var ff = e.getAttribute("data-priceOffer");
    var isVirt = $(e)
      .find("#is_virtual_" + RwId)
      .val();
    var pid = $(e)
      .find("#product_id_" + RwId)
      .val();
    if (parseInt(isVirt) == 1) {
      if (parseInt(Ptype) == 1) {
        var UpdateButton = {
          icon: "icn-md fa fa-history",
          txt: "Güncelle",
          evntType: "onclick",
          evnt: "openHose(" + pid + "," + RwId + ")",
          att: "",
        };
      } else if (parseInt(Ptype) == 2) {
        var UpdateButton = {
          icon: "icn-md fa fa-history",
          txt: "Güncelle",
          evntType: "onclick",
          evnt: "openHydrolic(" + pid + "," + RwId + ",1)",
          att: "",
        };
      } else if (parseInt(Ptype) == 4) {
        var UpdateButton = {
          icon: "icn-md fa fa-history",
          txt: "Güncelle",
          evntType: "onclick",
          evnt: "openVirtualProduct(" + pid + "," + RwId + ")",
          att: "",
        };
      } else if (parseInt(Ptype) == 0 || parseInt(Ptype) == 99) {
        var ConvertRealButton = {
          icon: "icn-md icon-check",
          txt: "Gerçek Ürüne Dönüştür",
          evntType: "onclick",
          evnt: "ConvertRealProduct(" + pid + "," + RwId + ")",
          att: "",
        };
      }
    } else {
      var treeButton = {
        icon: "icn-md fa fa-tree",
        txt: "Ağaç Görüntüle",
        evntType: "onclick",
        evnt: "showTree(" + RwId + ")",
        att: "",
      };
    }
    if (parseInt(ff) == 1) {
      var TurnButton = {
        icon: "icn-md fa fa-recycle",
        txt: "Fiyat Talep Sonuçları",
        evntType: "onclick",
        evnt: "TurnOut(this," + RwId + ")",
        att: "",
      };
    }
  }
  buttonGroups.push(
    removeButton,
    UpdateButton,
    groupButton,
    treeButton,
    TurnButton,
    ConvertRealButton
  );
  //$(RemCell).show();
  return buttonGroups;
}
var elks = "";
function showTree(el) {
  elks = el;
  console.log(el);
  var sid = document.getElementById("stock_id_" + el).value;
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_show_tree_prt&stock_id=" + sid
  );
}
function TurnOut(el, rwid) {
  var unq = document.getElementById("row_uniq_id_" + rwid).value;
  openBoxDraggable(
    "index.cfm?fuseaction=sales.emptypopup_add_pbs_offer_price_offerings&OfferrowUniqId=" +
      unq +
      "&row_id=" +
      rwid
  );
}
function rowaListener(tr) {
  $(tr).on("contextmenu", function (ev) {
    $(".pbsContex").remove();
    ev.preventDefault();
    var div = document.createElement("div");
    div.setAttribute("class", "pbsContex");
    $(div).attr(
      "style",
      "display:none;top:" + ev.clientY + "px;left:" + ev.clientX + "px"
    );
    var div3 = document.createElement("div");
    div3.setAttribute(
      "style",
      "border-top: solid 5px black;border-left: solid 5px black;width: 10px;height: 10px;"
    );
    var div2 = document.createElement("div");
    div2.setAttribute("class", "list-group");

    var buttons = BasketSelControl();
    for (let i = 0; i < buttons.length; i++) {
      var ee = buttons[i];
      var a = document.createElement("a");
      var spn1 = document.createElement("span");
      spn1.setAttribute("class", ee.icon);
      spn1.setAttribute("style", "margin-right:10px");
      var spn2 = document.createElement("span");
      spn2.innerText = ee.txt;
      a.appendChild(spn1);
      a.appendChild(spn2);
      if (ee.att == "disabled") {
        a.setAttribute("disabled", "");
      }
      a.setAttribute("class", "list-group-item");
      a.setAttribute(ee.evntType, ee.evnt);
      div2.appendChild(a);
    }

    div.appendChild(div3);
    div.appendChild(div2);

    document.body.appendChild(div);
    $(div).show(500);
  });
}

function removeSelected(el) {
  RemSelected();
  $(el.parentElement.parentElement).remove();
}

function RemSelected() {
  for (let i = 0; i < selectedArr.length; i++) {
    $(selectedArr[i]).remove();
  }
  selectedArr.splice(0, selectedArr.length);
  rowArrange();
  toplamHesapla_2();
  toplamHesapla();
}

function rowArrange() {
  var rows = document.getElementsByClassName("sepetRow");
  for (let i = 0; i < rows.length; i++) {
    var NeWid = i + 1;
    var row = rows[i];
    var Old_rw_id = row.getAttribute("data-rc");

    row.setAttribute("id", "row_" + NeWid);
    row.setAttribute("data-selected", "0");
    row.setAttribute("data-rc", NeWid);

    var p_name = document.getElementById("product_name_" + Old_rw_id);
    var cbx = $(row).find("input:checkbox")[0];
    cbx.setAttribute("data-row", NeWid);
    p_name.setAttribute("id", "product_name_" + NeWid);
    p_name.setAttribute("name", "product_name_" + NeWid);
    var spn = document.getElementById("spn_" + Old_rw_id);
    spn.innerText = NeWid;
    spn.setAttribute("id", "spn_" + NeWid);

    var product_id = document.getElementById("product_id_" + Old_rw_id);
    product_id.setAttribute("id", "product_id_" + NeWid);
    product_id.setAttribute("name", "product_id_" + NeWid);

    var is_manuel = document.getElementById("is_manuel_" + Old_rw_id);
    is_manuel.setAttribute("id", "is_manuel_" + NeWid);
    is_manuel.setAttribute("name", "is_manuel_" + NeWid);

    var stock_id = document.getElementById("stock_id_" + Old_rw_id);
    stock_id.setAttribute("id", "stock_id_" + NeWid);
    stock_id.setAttribute("name", "stock_id_" + NeWid);

    var is_production = document.getElementById("is_production_" + Old_rw_id);
    is_production.setAttribute("id", "is_production_" + NeWid);
    is_production.setAttribute("name", "is_production_" + NeWid);

    var is_virtual = document.getElementById("is_virtual_" + Old_rw_id);
    is_virtual.setAttribute("id", "is_virtual_" + NeWid);
    is_virtual.setAttribute("name", "is_virtual_" + NeWid);

    var row_uniq_id = document.getElementById("row_uniq_id_" + Old_rw_id);
    row_uniq_id.setAttribute("id", "row_uniq_id_" + NeWid);
    row_uniq_id.setAttribute("name", "row_uniq_id_" + NeWid);

    var cost = document.getElementById("cost_" + Old_rw_id);
    cost.setAttribute("id", "cost_" + NeWid);
    cost.setAttribute("name", "cost_" + NeWid);

    var amount = document.getElementById("amount_" + Old_rw_id);
    amount.setAttribute("id", "amount_" + NeWid);
    amount.setAttribute("name", "amount_" + NeWid);
    var partner = 0;
    var price = document.getElementById("price_" + Old_rw_id);
    price.setAttribute("id", "price_" + NeWid);
    price.setAttribute("name", "price_" + NeWid);

    var stock_code = document.getElementById("stock_code_" + Old_rw_id);
    stock_code.setAttribute("id", "stock_code_" + NeWid);
    stock_code.setAttribute("name", "stock_code_" + NeWid);

    var brand_name = document.getElementById("brand_name_" + Old_rw_id);
    brand_name.setAttribute("id", "brand_name_" + NeWid);
    brand_name.setAttribute("name", "brand_name_" + NeWid);

    var main_unit = document.getElementById("main_unit_" + Old_rw_id);
    main_unit.setAttribute("id", "main_unit_" + NeWid);
    main_unit.setAttribute("name", "main_unit_" + NeWid);

    var product_name_other = document.getElementById(
      "product_name_other_" + Old_rw_id
    );
    product_name_other.setAttribute("id", "product_name_other_" + NeWid);
    product_name_other.setAttribute("name", "product_name_other_" + NeWid);

    var detail_info_extra = document.getElementById(
      "detail_info_extra_" + Old_rw_id
    );
    detail_info_extra.setAttribute("id", "detail_info_extra_" + NeWid);
    detail_info_extra.setAttribute("name", "detail_info_extra_" + NeWid);

    var deliver_date = document.getElementById("deliver_date_" + Old_rw_id);
    deliver_date.setAttribute("id", "deliver_date_" + NeWid);
    deliver_date.setAttribute("name", "deliver_date_" + NeWid);

    var other_money = document.getElementById("price_other_" + Old_rw_id);
    other_money.setAttribute("id", "price_other_" + NeWid);
    other_money.setAttribute("name", "price_other_" + NeWid);

    var other_money = document.getElementById("other_money_" + Old_rw_id);
    other_money.setAttribute("id", "other_money_" + NeWid);
    other_money.setAttribute("name", "other_money_" + NeWid);

    var row_nettotal = document.getElementById("row_nettotal_" + Old_rw_id);
    row_nettotal.setAttribute("id", "row_nettotal_" + NeWid);
    row_nettotal.setAttribute("name", "row_nettotal_" + NeWid);

    var converted_sid = document.getElementById("converted_sid_" + Old_rw_id);
    converted_sid.setAttribute("id", "converted_sid_" + NeWid);
    converted_sid.setAttribute("name", "converted_sid_" + NeWid);

    var shelf_code = document.getElementById("shelf_code_" + Old_rw_id);
    shelf_code.setAttribute("id", "shelf_code_" + NeWid);
    shelf_code.setAttribute("name", "shelf_code_" + NeWid);

    var orderrow_currency = document.getElementById(
      "orderrow_currency_" + Old_rw_id
    );
    orderrow_currency.setAttribute("id", "orderrow_currency_" + NeWid);
    orderrow_currency.setAttribute("name", "orderrow_currency_" + NeWid);
    var Tax = document.getElementById("Tax_" + Old_rw_id);
    Tax.setAttribute("id", "Tax_" + NeWid);
    Tax.setAttribute("name", "Tax_" + NeWid);

    var indirim1 = document.getElementById("indirim1_" + Old_rw_id);
    indirim1.setAttribute("id", "indirim1_" + NeWid);
    indirim1.setAttribute("name", "indirim1_" + NeWid);

    var description = document.getElementById("description_" + Old_rw_id);
    description.setAttribute("id", "description_" + NeWid);
    description.setAttribute("name", "description_" + NeWid);
  }
  row_count = rows.length;
  rowCount = rows.length;
}

function RowControlForVirtual() {
  var elems = document.getElementsByClassName("sepetRow");
  var sanal_varmı = false;
  for (let i = 1; i <= elems.length; i++) {
    var vi = document.getElementById("is_virtual_" + i);
    if (parseInt(vi.value) == 1) {
      sanal_varmı = true;
    }
  }
  if (sanal_varmı) {
    document.getElementById("siparis").setAttribute("disabled", "true");
    document.getElementById("sevkiyat").setAttribute("disabled", "true");
    $(document.getElementById("snl_teklif")).click();
  } else {
    document.getElementById("siparis").removeAttribute("disabled");
    document.getElementById("sevkiyat").removeAttribute("disabled");
  }
}

function getProductMultiUse(keyword, comp_id, price_catid) {
  var new_query = new Object();
  var req;

  function callpage(url) {
    req = false;
    if (window.XMLHttpRequest)
      try {
        req = new XMLHttpRequest();
      } catch (e) {
        req = false;
      }
    else if (window.ActiveXObject)
      try {
        req = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (e) {
        try {
          req = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {
          req = false;
        }
      }
    if (req) {
      function return_function_() {
        if (req.readyState == 4 && req.status == 200) {
          JSON.parse(req.responseText.replace(/\u200B/g, ""));
          new_query = JSON.parse(req.responseText.replace(/\u200B/g, ""));
        }
      }
      req.open("post", url + "&xmlhttp=1", false);
      req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      req.setRequestHeader("pragma", "nocache");

      req.send(
        "keyword=" +
          keyword +
          "&userid=" +
          generalParamsSatis.userData.user_id +
          "&dsn2=" +
          generalParamsSatis.dataSources.dsn2 +
          "&dsn1=" +
          generalParamsSatis.dataSources.dsn1 +
          "&dsn3=" +
          generalParamsSatis.dataSources.dsn3 +
          "&price_catid=" +
          price_catid +
          "&comp_id=" +
          comp_id
      );
      return_function_();
    }
  }

  //TolgaS 20070124 objects yetkisi olmayan partnerlar var diye fuseaction objects2 yapildi
  callpage("/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProduct");
  //alert(new_query);

  return new_query;
}

function getProductMultiUseA(keyword, comp_id, price_catid, question_id = 0) {
  var new_query = new Object();
  var req;

  function callpage(url) {
    req = false;
    if (window.XMLHttpRequest)
      try {
        req = new XMLHttpRequest();
      } catch (e) {
        req = false;
      }
    else if (window.ActiveXObject)
      try {
        req = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (e) {
        try {
          req = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {
          req = false;
        }
      }
    if (req) {
      function return_function_() {
        if (req.readyState == 4 && req.status == 200) {
          JSON.parse(req.responseText.replace(/\u200B/g, ""));
          new_query = JSON.parse(req.responseText.replace(/\u200B/g, ""));
        }
      }
      req.open("post", url + "&xmlhttp=1", false);
      req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      req.setRequestHeader("pragma", "nocache");

      req.send(
        "keyword=" +
          keyword +
          "&question_id=" +
          question_id +
          "&userid=" +
          generalParamsSatis.userData.user_id +
          "&dsn2=" +
          generalParamsSatis.dataSources.dsn2 +
          "&dsn1=" +
          generalParamsSatis.dataSources.dsn1 +
          "&dsn3=" +
          generalParamsSatis.dataSources.dsn3 +
          "&price_catid=" +
          price_catid +
          "&comp_id=" +
          comp_id +
          "&dsn=" +
          generalParamsSatis.dataSources.dsn
      );
      return_function_();
    }
  }

  //TolgaS 20070124 objects yetkisi olmayan partnerlar var diye fuseaction objects2 yapildi
  callpage(
    "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProductListpbs"
  );
  //alert(new_query);

  return new_query;
}

function openPriceListPartner(PRODUCT_ID, STOCK_ID, MAIN_UNIT, company_id) {
  var MoneyList = "";
  moneyArr.forEach(function (item, ix) {
    console.log(item.MONEY);
    MoneyList += item.MONEY + "=" + item.RATE2 + "&";
  });
  var uri =
    "index.cfm?fuseaction=objects.emptypopup_price_history_partner&" +
    MoneyList +
    "sepet_process_type=-1&product_id=" +
    PRODUCT_ID +
    "&stock_id=" +
    STOCK_ID +
    "&pid=" +
    PRODUCT_ID +
    "&product_name=&unit=" +
    MAIN_UNIT +
    "&row_id=0&company_id=" +
    company_id;
  openBoxDraggable(uri);
}

function searchCode(el, ev) {
  //urunadi stockkodu
  var kw = el.value;
  $(".stockkodu").filter(function () {
    $(this)
      .parent()
      .parent()
      .parent()
      .toggle($(this).val().toLowerCase().indexOf(kw.toLowerCase()) > -1);
  });
}

function searchName(el, ev) {
  var kw = el.value;
  $(".urunadi").filter(function () {
    $(this)
      .parent()
      .parent()
      .parent()
      .toggle($(this).val().toLowerCase().indexOf(kw.toLowerCase()) > -1);
  });
}

function moveRow(from_row_id, to_row_id) {
  if (from_row_id != 1) {
    var product_type_1 = $("#row_" + from_row_id).attr("data-producttype");
    var product_type_2 = $("#row_" + to_row_id).attr("data-producttype");

    var product_id_1 = $("#product_id_" + from_row_id).val();
    var stock_id_1 = $("#stock_id_" + from_row_id).val();
    var is_virtual_1 = $("#is_virtual_" + from_row_id).val();
    var shelf_code_1 = $("#shelf_code_" + from_row_id).val();
    var cost_1 = $("#cost_" + from_row_id).val();
    var is_production_1 = $("#is_production_" + from_row_id).val();
    var row_uniq_id_1 = $("#row_uniq_id_" + from_row_id).val();
    var stock_code_1 = $("#stock_code_" + from_row_id).val();
    var product_name_1 = $("#product_name_" + from_row_id).val();
    var brand_name_1 = $("#brand_name_" + from_row_id).val();
    var department_name1 = $("#department_name" + from_row_id).val();
    var amount_1 = $("#amount_" + from_row_id).val();
    var main_unit_1 = $("#main_unit_" + from_row_id).val();
    var other_money_1 = $("#other_money_" + from_row_id).val();
    var price_other_1 = $("#price_other_" + from_row_id).val();
    var price_1 = $("#price_" + from_row_id).val();
    var indirim1_1 = $("#indirim1_" + from_row_id).val();
    var row_nettotal_1 = $("#row_nettotal_" + from_row_id).val();
    var detail_info_extra_1 = $("#detail_info_extra_" + from_row_id).val();
    var deliver_date_1 = $("#deliver_date_" + from_row_id).val();
    var Tax_1 = $("#Tax_" + from_row_id).val();
    var orderrow_currency_1 = $("#orderrow_currency_" + from_row_id).val();
    var description_1 = $("#description_" + from_row_id).val();
    var product_name_other_1 = $("#product_name_other_" + from_row_id).val();

    var product_id_2 = $("#product_id_" + to_row_id).val();
    var stock_id_2 = $("#stock_id_" + to_row_id).val();
    var is_virtual_2 = $("#is_virtual_" + to_row_id).val();
    var shelf_code_2 = $("#shelf_code_" + to_row_id).val();
    var cost_2 = $("#cost_" + to_row_id).val();
    var is_production_2 = $("#is_production_" + to_row_id).val();
    var row_uniq_id_2 = $("#row_uniq_id_" + to_row_id).val();
    var stock_code_2 = $("#stock_code_" + to_row_id).val();
    var product_name_2 = $("#product_name_" + to_row_id).val();
    var brand_name_2 = $("#brand_name_" + to_row_id).val();
    var department_name2 = $("#department_name" + to_row_id).val();
    var amount_2 = $("#amount_" + to_row_id).val();
    var main_unit_2 = $("#main_unit_" + to_row_id).val();
    var other_money_2 = $("#other_money_" + to_row_id).val();
    var price_other_2 = $("#price_other_" + to_row_id).val();
    var price_2 = $("#price_" + to_row_id).val();
    var indirim1_2 = $("#indirim1_" + to_row_id).val();
    var row_nettotal_2 = $("#row_nettotal_" + to_row_id).val();
    var detail_info_extra_2 = $("#detail_info_extra_" + to_row_id).val();
    var deliver_date_2 = $("#deliver_date_" + to_row_id).val();
    var Tax_2 = $("#Tax_" + to_row_id).val();
    var orderrow_currency_2 = $("#orderrow_currency_" + to_row_id).val();
    var description_2 = $("#description_" + to_row_id).val();
    var product_name_other_2 = $("#product_name_other_" + to_row_id).val();

    $("#product_id_" + to_row_id).val(product_id_1);
    $("#product_id_" + from_row_id).val(product_id_2);
    $("#stock_id_" + to_row_id).val(stock_id_1);
    $("#stock_id_" + from_row_id).val(stock_id_2);
    $("#is_virtual_" + to_row_id).val(is_virtual_1);
    $("#is_virtual_" + from_row_id).val(is_virtual_2);
    $("#shelf_code_" + to_row_id).val(shelf_code_1);
    $("#shelf_code_" + from_row_id).val(shelf_code_2);
    $("#cost_" + to_row_id).val(cost_1);
    $("#cost_" + from_row_id).val(cost_2);
    $("#is_production_" + to_row_id).val(is_production_1);
    $("#is_production_" + from_row_id).val(is_production_2);
    $("#row_uniq_id_" + to_row_id).val(row_uniq_id_1);
    $("#row_uniq_id_" + from_row_id).val(row_uniq_id_2);
    $("#stock_code_" + to_row_id).val(stock_code_1);
    $("#stock_code_" + from_row_id).val(stock_code_2);
    $("#product_name_" + to_row_id).val(product_name_1);
    $("#product_name_" + from_row_id).val(product_name_2);
    $("#brand_name_" + to_row_id).val(brand_name_1);
    $("#brand_name_" + from_row_id).val(brand_name_2);
    $("#department_name" + to_row_id).val(department_name1);
    $("#department_name" + from_row_id).val(department_name2);
    $("#amount_" + to_row_id).val(amount_1);
    $("#amount_" + from_row_id).val(amount_2);
    $("#main_unit_" + to_row_id).val(main_unit_1);
    $("#main_unit_" + from_row_id).val(main_unit_2);
    $("#other_money_" + to_row_id).val(other_money_1);
    $("#other_money_" + from_row_id).val(other_money_2);
    $("#price_other_" + to_row_id).val(price_other_1);
    $("#price_other_" + from_row_id).val(price_other_2);
    $("#price_" + to_row_id).val(price_1);
    $("#price_" + from_row_id).val(price_2);
    $("#indirim1_" + to_row_id).val(indirim1_1);
    $("#indirim1_" + from_row_id).val(indirim1_2);
    $("#row_nettotal_" + to_row_id).val(row_nettotal_1);
    $("#row_nettotal_" + from_row_id).val(row_nettotal_2);
    $("#detail_info_extra_" + to_row_id).val(detail_info_extra_1);
    $("#detail_info_extra_" + from_row_id).val(detail_info_extra_2);
    $("#Tax_" + to_row_id).val(Tax_1);
    $("#Tax_" + from_row_id).val(Tax_2);
    $("#deliver_date_" + to_row_id).val(deliver_date_1);
    $("#deliver_date_" + from_row_id).val(deliver_date_2);
    $("#orderrow_currency_" + to_row_id).val(orderrow_currency_1);
    $("#orderrow_currency_" + from_row_id).val(orderrow_currency_2);

    $("#description_" + to_row_id).val(description_1);
    $("#description_" + from_row_id).val(description_2);

    $("#product_name_other_" + to_row_id).val(product_name_other_1);
    $("#product_name_other_" + from_row_id).val(product_name_other_2);

    document
      .getElementById("row_" + to_row_id)
      .setAttribute("data-producttype", product_type_1);
    document
      .getElementById("row_" + from_row_id)
      .setAttribute("data-producttype", product_type_2);

    hesapla("price", from_row_id);
    hesapla("price", to_row_id);
  }
}

function GenerateUniqueId() {
  var d = new Date();
  var dy = d - 1;
  var dd = d.toISOString().split("T")[0];
  var ds = d.toISOString().split("T")[1];
  var dd1 = dd.replaceAll("-", "");
  var ds1 = ds.replaceAll(":", "");
  ds1 = ds1.replaceAll(".", "");
  console.log(ds1);
  var RelId = "PBS" + generalParamsSatis.userData.user_id + "" + dd1 + "" + ds1;
  return RelId;
}

function getSetNum(el) {
  var v = el.value;
  if (v.length == 0) {
    el.value = commaSplit(0);
  } else {
    el.value = commaSplit(v);
  }
}

function CheckSatilabilir() {
  //var rows=document.getElementsByClassName("sepetRow");
  /* for (let i = 1; i <= row_count; i++) {
    var sid = document.getElementById("stock_id_" + i).value;
    var mik_ = document.getElementById("amount_" + i).value;
    var mik = parseFloat(filterNum(mik_));
    var rw = document.getElementById("row_" + i);
    // console.log(mik)
    if (parseInt(sid) != 0) {
      // console.log(sid)
      var q = wrk_query(
        "SELECT ISNULL(" +
          generalParamsSatis.dataSources.dsn2 +
          ".GET_SATILABILIR_STOCK(" +
          sid +
          "),0) as SATILABILIR",
        "dsn2"
      );
      //console.log(q)
      var ss = parseFloat(q.SATILABILIR[0]);
      //   console.log(ss)
      if (ss < mik) {
        rw.setAttribute("style", "background:#ff5959");
      }
    }
    // console.log(sid)
  }*/

  var sidArr = new Array();
  //var rows=document.getElementsByClassName("sepetRow");
  for (let i = 1; i <= row_count; i++) {
    var sid = document.getElementById("stock_id_" + i).value;
    var mik_ = document.getElementById("amount_" + i).value;
    var mik = parseFloat(filterNum(mik_));
    var rw = document.getElementById("row_" + i);
    var inx = sidArr.findIndex((p) => p.STOCK_ID == sid);
    if (inx == -1) {
      var O = new Object();
      O.STOCK_ID = sid;
      O.MIKTAR = mik;
      sidArr.push(O);
    } else {
      sidArr[inx].MIKTAR += mik;
    }
  }
  for (let i = 0; i < sidArr.length; i++) {
    var q = wrk_query(
      "SELECT ISNULL(" +
        generalParamsSatis.dataSources.dsn2 +
        ".GET_SATILABILIR_STOCK(" +
        sidArr[i].STOCK_ID +
        "),0) as SATILABILIR",
      "dsn2"
    );
    var ss = parseFloat(q.SATILABILIR[0]);
    console.log(ss);
    var dd = false;
    if (ss < sidArr[i].MIKTAR) {
      dd = true;
    }
    for (let j = 1; j <= row_count; j++) {
      var sid = document.getElementById("stock_id_" + j).value;
      var rw = document.getElementById("row_" + j);
      if (sid == sidArr[i].STOCK_ID) {
        if (dd) {
          rw.setAttribute("style", "background:#ff5959");
        } else {
          rw.removeAttribute("style");
        }
        console.log("miktar yok" + "row_" + j + "DD=" + dd);
      }
    }
  }
}

function openPump(iid) {
  windowopen(
    "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&type=3&id=" +
      iid +
      "&company_id=" +
      CompanyData.COMPANY_ID +
      "&PRICE_CATID=" +
      CompanyData.PRICE_CAT,
    "wwide"
  );
}

function FiyatTalepKontrol(i = 0) {
  if (i != 0) {
    var uniqid = $("#row_uniq_id_" + i).val();
    var curr = $("#orderrow_currency_" + i).val();
    if (parseInt(curr) == 1) {
      console.log(uniqid);
      var q =
        "SELECT * FROM PBS_OFFER_ROW_PRICE_OFFER WHERE UNIQUE_RELATION_ID='" +
        uniqid +
        "'";
      var res = wrk_query(q, "dsn3");
      if (parseInt(res.IS_ACCCEPTED[0]) == 1) {
        var r = document.getElementById("row_" + i);
        r.setAttribute("style", "background:#ffd70069");
        r.setAttribute("data-priceOffer", "1");
      }
    }
  } else {
    for (let i = 1; i <= row_count; i++) {
      var uniqid = $("#row_uniq_id_" + i).val();
      var curr = $("#orderrow_currency_" + i).val();
      if (parseInt(curr) == 1) {
        console.log(uniqid);
        var q =
          "SELECT * FROM PBS_OFFER_ROW_PRICE_OFFER WHERE UNIQUE_RELATION_ID='" +
          uniqid +
          "'";
        var res = wrk_query(q, "dsn3");
        if (parseInt(res.IS_ACCCEPTED[0]) == 1) {
          var r = document.getElementById("row_" + i);
          r.setAttribute("style", "background:#ffd70069");
          r.setAttribute("data-priceOffer", "1");
        }
        console.log(res);
      }
    }
  }
}

function setFiyatA(row, price, money, modal_id) {
  $("#price_" + row).val(price);
  $("#other_money_" + row).val(money);
  $("orderrow_currency_" + row).val(-6);
  hesapla("price", row);
  closeBoxDraggable(modal_id);
}

function ConvertRealProduct(pid, rwid) {
  $.ajax({
    url:
      "index.cfm?fuseaction=objects.emptypopup_createRealProductPbs&ajax=1&ajax_box_page=1&isAjax=1&VIRTUAL_PRODUCT_ID=" +
      pid +
      "&ROW_ID=" +
      rwid,
    success: function (retDat) {
      console.log(retDat);
      var O = JSON.parse(retDat.trim());
      console.log(O);
      var PidE = eval("O[0].PRODUCT_ID_" + pid + "");
      var SidE = eval("O[0].STOCK_ID_" + pid + "");
      document.getElementById("product_id_" + rwid).value = PidE;
      document.getElementById("stock_id_" + rwid).value = SidE;
      document.getElementById("is_virtual_" + rwid).value = 0;
    },
  });
}
