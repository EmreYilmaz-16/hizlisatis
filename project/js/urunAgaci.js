var o = new Object();
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
var _compId;
var _priceCatId;
function ngetTree(product_id, is_virtual, dsn3) {
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
      product_id +
      "&isVirtual=" +
      is_virtual +
      "&ddsn3=" +
      dsn3,
    success: function (asd) {
      var jsonStr = strToJson(asd);
      o = JSON.parse(jsonStr);
      AgaciYaz(o, 0);
      var esd = document.getElementById("TreeArea");
      esd.innerHTML = "";

      esd.appendChild(ulx);
    },
  });
}
function strToJson(str) {
  var newStr = "";
  for (let i = 0; i < str.length; i++) {
    var currentChar = str.charAt(i).trim();
    if (currentChar == "," && str.charAt(i + 1).trim() == "]") {
      console.log("ebe");
      currentChar = "";
    }
    newStr += currentChar;
  }
  return newStr;
}

function AgaciYaz(arr, isoq, address = "0") {
  var upProduct = ProductDesingSetting.find(
    (p) => p.paramName == "update_real_product"
  ).paramValue;
  ulx.innerHTML = "";
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");
  ul.setAttribute("data-seviye", isoq);
  if (address != "0") {
    // ul.setAttribute("style", "width:90%");
  }
  var address = address;

  address += isoq.toString();
  for (let i = 0; i < arr.length; i++) {
    var li = document.createElement("li");
    if (isoq <= 0) {
      isoq = arr[i].RNDM_ID;
    }
    var spn = document.createElement("span");
    spn.setAttribute("name","product_name_")
    spn.innerHTML = arr[i].PRODUCT_NAME;

    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);

    var diva = document.createElement("div");
    var btn = document.createElement("button");
    btn.innerText = "+";
    btn.setAttribute("onclick", "getitem(this)");
    btn.setAttribute("type", "button");
    btn.setAttribute("class", "btn btn-outline-success");
    var inp = document.createElement("input");
    inp.setAttribute("type", "text");
    inp.setAttribute("onchange", "console.log(this)");
    inp.setAttribute("class", "form-control form-control-sm");
    inp.setAttribute("style", "width:33%");
    inp.setAttribute("value", arr[i].AMOUNT);
    inp.setAttribute("name", "amount");
    diva.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    if (upProduct == "OFF" && arr[i].IS_VIRTUAL != 1) {
      inp.setAttribute("readonly", "true");
      btn.setAttribute("disabled", "true");
    }
    diva.appendChild(inp);
    diva.appendChild(btn);
    var divb = document.createElement("div");
    divb.setAttribute("style", "display:flex");
    divb.appendChild(spn);
    divb.appendChild(diva);
    li.appendChild(divb);

    //  li.setAttribute("onclick", "getitem(this)");

    li.setAttribute("class", "list-group-item");
    if (arr[i].AGAC.length > 0) {
      li.appendChild(AgaciYaz(arr[i].AGAC, arr[i].RNDM_ID, address));
    } else {
    }

    ul.appendChild(li);
  }

  ulx.appendChild(ul);
  return ul;
}

function getitem(el) {
  sonEleman = el;
  console.log(el);
}

function getDs() {
  $("#TreeArea").dxTreeList({
    dataSource: employees,
    rootValue: -1,
    keyExpr: "ID",
    parentIdExpr: "Head_ID",
    columns: [
      {
        dataField: "Title",
        caption: "Position",
      },
      "Full_Name",
      "City",
      "State",
      "Mobile_Phone",
      {
        dataField: "Hire_Date",
        dataType: "date",
      },
    ],
    expandedRowKeys: [1],
    showRowLines: true,
    showBorders: true,
    columnAutoWidth: true,
  });
}

$(document).ready(function () {
  var d = document.getElementById("wrk_main_layout");
  d.removeAttribute("class");
  d.setAttribute("class", "container-fluid");
  LoadSettings();
  var PROJECT_ID = getParameterByName("project_id");
  var cp_id = wrk_query(
    "select COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_ID=" + PROJECT_ID,
    "DSN"
  ).COMPANY_ID[0];
  let compInfo = GetAjaxQuery("CompanyInfo", cp_id);
  _priceCatId = compInfo.PRICE_LISTS.find((p) => p.IS_DEFAULT == 1).PRICE_CATID;
  _compId = cp_id;
});

function LoadSettings() {
  var table = document.createElement("table");
  for (let i = 0; i < ProductDesingSetting.length; i++) {
    var tr = document.createElement("tr");
    var td = document.createElement("td");
    if (ProductDesingSetting[i].elementType == "bool") {
      var div = document.createElement("div");
      div.setAttribute("class", "custom-control custom-switch");
      var input = document.createElement("input");
      input.setAttribute("type", "checkbox");
      input.setAttribute("name", ProductDesingSetting[i].paramName);
      input.setAttribute("id", ProductDesingSetting[i].paramName);
      input.setAttribute("class", "custom-control-input");
      if (ProductDesingSetting[i].paramValue == "OFF")
        input.setAttribute("checked", "true");
      div.appendChild(input);
      var lbl = document.createElement("label");
      lbl.setAttribute("class", "custom-control-label");
      lbl.setAttribute("for", ProductDesingSetting[i].paramName);
      div.appendChild(lbl);
      td.appendChild(div);
    }
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = ProductDesingSetting[i].paramDescripton;
    tr.appendChild(td);
    table.appendChild(tr);
  }
  document.getElementById("settingsArea").appendChild(table);
}

/*
  <div class="custom-control custom-switch">
                <input type="checkbox" class="custom-control-input" id="customSwitch1">
                <label class="custom-control-label" for="customSwitch1">Toggle this switch element</label>
              </div>
*/

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

function getParameterByName(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return "";
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function OpenBasketProducts(col = "", actType = "5") {
  var cp_id = _compId;
  var cp_name = _compId;

  var p_cat = _priceCatId;
  var p_cat_id = _priceCatId;
  openBoxDraggable(
    "http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=" +
      p_cat +
      "&PRICE_CATID=" +
      p_cat_id +
      "&company_id=" +
      cp_id +
      "&company_name=" +
      cp_name +
      "&columnsa=" +
      col +
      "&actType=" +
      actType +
      "&question_id=" +
      ""
  );
}
function newDraft(){
  console.log("Yeni Taslak")
}