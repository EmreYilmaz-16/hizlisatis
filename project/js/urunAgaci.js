var o = new Object();
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
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
    inp.setAttribute("style","width:33%");
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
