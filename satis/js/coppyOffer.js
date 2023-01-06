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
