function SentForm() {
  var id = document.getElementById("company_id").value;
  let compInfo = GetAjaxQuery("CompanyInfo", id);
  for (let i = 0; i < compInfo.PRICE_LISTS.length; i++) {
    console.log(compInfo.PRICE_LISTS[i]);
    if (compInfo.PRICE_LISTS[i].IS_DEFAULT == 1) {
      $("#price_catid").val(compInfo.PRICE_LISTS[i].PRICE_CATID);
    }
  }
  $("#frm_search").submit();
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

function AddRowA(
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
  row_uniq_id = ""
) {
  window.opener.AddRow(
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
    poduct_type,
    shelf_code,
    other_money,
    price_other,
    currency,
    is_manuel,
    cost,
    product_unit,
    product_name_other,
    detail_info_extra,
    fc,
    rowNum,
    deliver_date,
    is_production,
    row_uniq_id
  );
}
