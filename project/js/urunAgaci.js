var o = new Object();
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
var _compId;
var _priceCatId;
var SonAgac = new Array();
var idA = 1000;
var isUpdated = false;
var idB = 5000;
function ngetTree(
  product_id,
  is_virtual,
  dsn3,
  btn,
  tip = 1,
  li = "",
  pna = "",
  stg = ""
) {
  console.log(arguments);
  if (tip == 1) {
    var pn = btn.parentElement.children[0].innerText;
    $("#pnamemain").val(pna);
    $("#vp_id").val(product_id);
    $("#is_virtual").val(is_virtual);
    $("#pstage").val(stg);
    $.ajax({
      url:
        "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
        product_id +
        "&isVirtual=" +
        is_virtual +
        "&ddsn3=" +
        dsn3 +
        "&company_id=" +
        _compId +
        "&price_catid=" +
        _priceCatId,
      success: function (asd) {
        var jsonStr = strToJson(asd);
        o = JSON.parse(jsonStr);
        console.log(o);
        AgaciYaz(o, 0, "0", 1);
        var esd = document.getElementById("TreeArea");
        esd.innerHTML = "";

        esd.appendChild(ulx);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
        MaliyetHesapla();
      },
    });
  } else if (tip == 2) {
    $.ajax({
      url:
        "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
        product_id +
        "&isVirtual=" +
        is_virtual +
        "&ddsn3=" +
        dsn3 +
        "&company_id=" +
        _compId +
        "&price_catid=" +
        _priceCatId,
      success: function (asd) {
        var jsonStr = strToJson(asd);
        o = JSON.parse(jsonStr);
        console.log(o);
        console.log("Buradayım");
        //   partnerEkle(o);
        var et = AgaciYaz_12(o, 0, "", 0);
        li.appendChild(et);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
        MaliyetHesapla();
        /* console.log(o);
        ;*/
        /*AgaciYaz(o, 0, "0", 1);
        var esd = document.getElementById("TreeArea");
        esd.innerHTML = "";

        esd.appendChild(ulx);
        
       ;
        ;*/
      },
    });
  } else if (tip == 3) {
    $.ajax({
      url:
        "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
        product_id +
        "&isVirtual=" +
        is_virtual +
        "&ddsn3=" +
        dsn3 +
        "&company_id=" +
        _compId +
        "&price_catid=" +
        _priceCatId,
      success: function (asd) {
        var jsonStr = strToJson(asd);
        o = JSON.parse(jsonStr);
        console.log(o);
        console.log("Buradayım");
        //   partnerEkle(o);
       /* var et = AgaciYaz_12(o, 0, "", 0);
        var e = document.getElementById("ppidarea").children[0];
        var li = document.createElement("li");    
        li.appendChild(et);*/
        AddRowItemVirtual(o.PRODUCT_ID,o.PRODUCT_NAME,'',0,0,0,'TL',0,0,0,0);

        //e.appendChild(li);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
        MaliyetHesapla();
        /* console.log(o);
        ;*/
        /*AgaciYaz(o, 0, "0", 1);
        var esd = document.getElementById("TreeArea");
        esd.innerHTML = "";

        esd.appendChild(ulx);
        
       ;
        ;*/
      },
    });
  }
}
function patnerEkle(oo) {
  console.log(oo);
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

function AgaciYaz(arr, isoq, address = "0", vrt = "1") {
  console.log("AgaciYaz Virtual=" + vrt);
  var upProduct = ProductDesingSetting.find(
    (p) => p.paramName == "update_real_product"
  ).paramValue;
  ulx.innerHTML = "";
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");

  ul.setAttribute("data-is_virtual", vrt);

  ul.setAttribute("data-seviye", isoq);
  ul.setAttribute("id", idA);
  idA = idA + 1;
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
    spn.setAttribute("name", "product_name_");
    var qname = VIRTUAL_PRODUCT_TREE_QUESTIONS.find(
      (p) => p.QUESTION_ID == arr[i].QUESTION_ID
    );
    var str = arr[i].PRODUCT_NAME;
    if (qname != undefined) {
      qname =
        "<span style='color:var(--danger)'>(" + qname.QUESTION + ")</span>";
    } else {
      qname = "";
    }
    spn.innerHTML = arr[i].PRODUCT_NAME + " " + qname;

    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-stock_id", arr[i].STOCK_ID);
    li.setAttribute("data-price", arr[i].PRICE);
    li.setAttribute("data-other_money", arr[i].MONEY);
    li.setAttribute("data-discount", arr[i].DISCOUNT);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);
    li.setAttribute("data-question_id", arr[i].QUESTION_ID);
    li.setAttribute("data-idb", idB);
    idB++;

    var diva = document.createElement("div");
    var btn = buttonCreator(
      "",
      "btn btn-outline-success",
      "onclick",
      "getitem(this)",
      "+"
    );
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var inp = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      arr[i].AMOUNT
    );
    diva.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    if (upProduct == "OFF" && arr[i].IS_VIRTUAL != 1) {
      inp.setAttribute("readonly", "true");
      btn.setAttribute("disabled", "true");
      btn2.setAttribute("disabled", "true");
      btn3.setAttribute("disabled", "true");
    }

    diva.appendChild(inp);
    diva.appendChild(btn);
    diva.appendChild(btn3);
    diva.appendChild(btn2);
    var divb = document.createElement("div");
    divb.setAttribute("style", "display:flex");
    divb.appendChild(spn);
    divb.appendChild(diva);
    li.appendChild(divb);

    //  li.setAttribute("onclick", "getitem(this)");

    li.setAttribute("class", "list-group-item");
    if (arr[i].AGAC.length > 0) {
      li.appendChild(
        AgaciYaz(arr[i].AGAC, arr[i].RNDM_ID, address, arr[i].IS_VIRTUAL)
      );
    } else {
    }

    ul.appendChild(li);
  }

  ulx.appendChild(ul);
  return ul;
}
/*
attributeArr:[
  {
    att:'',
    vl:''
  }
]
*/
function buttonCreator(style, cls, ev, evvl, itext) {
  var btn = document.createElement("button");
  btn.innerText = itext;
  if (ev.length > 0) btn.setAttribute(ev, evvl);
  btn.setAttribute("type", "button");
  btn.setAttribute("class", cls);
  if (style.length > 0) btn.setAttribute("style", style);
  return btn;
}
function inputCreator(type, name, ev, evl, cls, style, vl) {
  var inp = document.createElement("input");
  inp.setAttribute("type", type);
  inp.setAttribute(ev, evl);
  inp.setAttribute("class", cls);
  inp.setAttribute("style", style);
  inp.setAttribute("value", vl);
  inp.setAttribute("name", name);
  return inp;
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
function newDraft() {
  var enmae = prompt("Ürün Adı");
  console.log(enmae);
  if (enmae == null || enmae.trim().length == 0) return false;
  idA = 1000;
  console.log("Yeni Taslak");
  var project_id = getParameterByName("project_id");
  var q =
    "select * from workcube_metosan_1.GetCatParamsPBS where PROJECT_ID=" +
    project_id;
  var res = wrk_query(q, "dsn3");
  var p_cat_id = res.PRODUCT_CATID[0];
  var p_unit = res.PRODUCT_UNIT[0];
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=NewDraft&PRODUCT_NAME=" +
      enmae +
      "&PRODUCT_CATID=" +
      p_cat_id +
      "&PRODUCT_UNIT=" +
      p_unit +
      "&PROJECT_ID=" +
      project_id +
      "&ddsn3=workcube_metosan_1",
    success: function (retDat) {
      console.log(retDat);
      getProjectProducts(project_id);
    },
  });
  /*var d = document.createElement("div");
  d.setAttribute("id", "ppidarea");
  var ul = document.createElement("ul");
  ul.setAttribute("id", idA);
  ul.setAttribute("data-is_virtual", "1");
  ul.setAttribute("class", "list-group");
  idA++;
  d.appendChild(ul);
  var e = document.getElementById("TreeArea");
  e.innerHTML = "";
  $("#pnamemain").val("");
  $("#vp_id").val("");
  $("#is_virtual").val("1");
  //var project_id = $("#project_id").val();
  $("#pstage").val("");
  e.appendChild(d);
  $("#pnamemain").val(enmae);*/
}
function AddRowItem(
  PRODUCT_ID,
  PRODUCT_NAME,
  STOCK_CODE,
  STOCK_ID,
  PRICE,
  DISCOUNT_RATE,
  MONEY,
  LAST_COST,
  PRICE,
  IS_MANUEL,
  COLUMNSA
) {
  console.log(arguments);
  if (COLUMNSA == 0) {
    var e = document.getElementById("ppidarea").children[0];
    var li = document.createElement("li");
    li.setAttribute("data-product_id", PRODUCT_ID);
    li.setAttribute("data-stock_id", STOCK_ID);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-price", PRICE);
    li.setAttribute("data-other_money", MONEY);
    li.setAttribute("data-discount", DISCOUNT_RATE);
    li.setAttribute("class", "list-group-item");
    li.setAttribute("data-idb", idB);
    idB++;
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.innerText = PRODUCT_NAME;

    div.appendChild(span);
    var div2 = document.createElement("div");
    div2.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var input = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      1
    );
    input.setAttribute("readonly", "true");
    var button = buttonCreator("", "btn btn-outline-success", "", "", "+");
    button.setAttribute("disabled", "true");
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var elsx = e.getAttribute("data-is_virtual");
    if (parseInt(elsx) == 1) {
      input.removeAttribute("readonly");
    }
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    div2.appendChild(input);
    div2.appendChild(button);
    div2.appendChild(btn3);
    div2.appendChild(btn2);
    div.appendChild(div2);
    li.appendChild(div);
    e.appendChild(li);
  } else {
    var e = document.getElementById(COLUMNSA);
    var li = document.createElement("li");
    li.setAttribute("data-product_id", PRODUCT_ID);
    li.setAttribute("data-stock_id", STOCK_ID);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-price", PRICE);
    li.setAttribute("data-other_money", MONEY);
    li.setAttribute("data-discount", DISCOUNT_RATE);
    li.setAttribute("class", "list-group-item");
    li.setAttribute("data-idb", idB);
    idB++;
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.innerText = PRODUCT_NAME;

    div.appendChild(span);
    var div2 = document.createElement("div");
    div2.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var input = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      1
    );
    input.setAttribute("readonly", "true");
    var button = buttonCreator("", "btn btn-outline-success", "", "", "+");
    button.setAttribute("disabled", "true");
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    div2.appendChild(input);
    div2.appendChild(button);
    div2.appendChild(btn3);
    div2.appendChild(btn2);
    div.appendChild(div2);
    li.appendChild(div);
    e.appendChild(li);
  }

  var q = wrk_query(
    "SELECT * FROM PRODUCT_TREE WHERE STOCK_ID=" + STOCK_ID,
    "dsn3"
  );
  console.log(q.recordcount);
  if (q.recordcount > 0) {
    ngetTree(STOCK_ID, 0, "workcube_metosan_1", "", 2, li);
  }
  MaliyetHesapla();
}


function AddRowItemVirtual(
  PRODUCT_ID,
  PRODUCT_NAME,
  STOCK_CODE,
  STOCK_ID,
  PRICE,
  DISCOUNT_RATE,
  MONEY,
  LAST_COST,
  PRICE,
  IS_MANUEL,
  COLUMNSA
) {
  console.log(arguments);
  if (COLUMNSA == 0) {
    var e = document.getElementById("ppidarea").children[0];
    var li = document.createElement("li");
    li.setAttribute("data-product_id", PRODUCT_ID);
    li.setAttribute("data-stock_id", STOCK_ID);
    li.setAttribute("data-is_virtual", 1);
    li.setAttribute("data-price", PRICE);
    li.setAttribute("data-other_money", MONEY);
    li.setAttribute("data-discount", DISCOUNT_RATE);
    li.setAttribute("class", "list-group-item");
    li.setAttribute("data-idb", idB);
    idB++;
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.innerText = PRODUCT_NAME;

    div.appendChild(span);
    var div2 = document.createElement("div");
    div2.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var input = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      1
    );
    input.setAttribute("readonly", "true");
    var button = buttonCreator("", "btn btn-outline-success", "", "", "+");
    button.setAttribute("disabled", "true");
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var elsx = e.getAttribute("data-is_virtual");
    if (parseInt(elsx) == 1) {
      input.removeAttribute("readonly");
    }
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    div2.appendChild(input);
    div2.appendChild(button);
    div2.appendChild(btn3);
    div2.appendChild(btn2);
    div.appendChild(div2);
    li.appendChild(div);
    e.appendChild(li);
  } else {
    var e = document.getElementById(COLUMNSA);
    var li = document.createElement("li");
    li.setAttribute("data-product_id", PRODUCT_ID);
    li.setAttribute("data-stock_id", STOCK_ID);
    li.setAttribute("data-is_virtual", 1);
    li.setAttribute("data-is_virtual", 1);
    li.setAttribute("data-price", PRICE);
    li.setAttribute("data-other_money", MONEY);
    li.setAttribute("data-discount", DISCOUNT_RATE);
    li.setAttribute("class", "list-group-item");
    li.setAttribute("data-idb", idB);
    idB++;
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.innerText = PRODUCT_NAME;

    div.appendChild(span);
    var div2 = document.createElement("div");
    div2.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var input = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      1
    );
    input.setAttribute("readonly", "true");
    var button = buttonCreator("", "btn btn-outline-success", "", "", "+");
    button.setAttribute("disabled", "true");
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    div2.appendChild(input);
    div2.appendChild(button);
    div2.appendChild(btn3);
    div2.appendChild(btn2);
    div.appendChild(div2);
    li.appendChild(div);
    e.appendChild(li);
  }

  var q = wrk_query(
    "SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=" + STOCK_ID,
    "dsn3"
  );
  console.log(q.recordcount);
  if (q.recordcount > 0) {
    ngetTree(STOCK_ID, 1, "workcube_metosan_1", "", 2, li);
  }
  MaliyetHesapla();
}




function AgacGetir(agacim, sx = 0) {
  console.log(sx);
  sx++;
  var at = new Array();
  for (let i = 0; i < agacim.length; i++) {
    // console.log(agacim[i])
    var pid = agacim[i].getAttribute("data-product_id");
    var sid = agacim[i].getAttribute("data-stock_id");
    var p_cat_id = agacim[i].getAttribute("data-product_catid");
    var is_virtual = agacim[i].getAttribute("data-is_virtual");
    var question_id = agacim[i].getAttribute("data-question_id");
    var price = agacim[i].getAttribute("data-price");
    var money = agacim[i].getAttribute("data-other_money");
    var discount = agacim[i].getAttribute("data-discount");
    //console.log(agacim[i])
    obj = agacim[i];
    var amount = $(obj).find("input[name='amount']")[0].value;
    var pname = $(obj).find("span[name='product_name_']")[0].innerText;
    var agacItem = new Object();
    agacItem.PRODUCT_ID = pid;
    agacItem.PRODUCT_NAME = pname;
    agacItem.AMOUNT = amount;
    agacItem.IS_VIRTUAL = is_virtual;
    agacItem.STOCK_ID = sid;
    agacItem.QUESTION_ID = question_id;
    agacItem.PRICE = price;
    agacItem.MONEY = money;
    agacItem.DISCOUNT = discount;
    if (p_cat_id != undefined) {
      agacItem.PRODUCT_CATID = p_cat_id;
    } else {
      agacItem.PRODUCT_CATID = 0;
    }
    agacItem.PRODUCT_TREE = new Array();
    var a = agacim[i].children;
    // obj=a
    //console.log(a)
    var agaciVar = false;
    var agac;
    for (let j = 0; j < a.length; j++) {
      if (a[j].tagName == "UL") {
        agaciVar = true;
        var agac = a[j].children;
      }
    }
    console.log(agac);
    if (agaciVar == true) {
      agacItem.AGAC = AgacGetir(agac, sx);
    }

    at.push(agacItem);
  }
  SonAgac.push(at);
  //console.log(at)
  return at;
}

function Kaydet() {
  var obj = "";
  var ee = document.getElementById("ppidarea");
  var agacim12 = ee.children[0].children;
  SonAgac.splice(0, SonAgac.length);
  AgacGetir(agacim12);
  console.log(SonAgac);
  UrunKaydet();
}
function addProdMain(idbb = 0) {
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_add_vp_project&idb=" + idbb
  );
}

function addProdMain_(idb) {
  var pname = document.getElementById("productNameVp").value;
  var p_cat_id = document.getElementById("productCatIdVp").value;
  var li = document.createElement("li");
  li.setAttribute("data-product_id", 0);
  li.setAttribute("data-stock_id", 0);
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("class", "list-group-item");
  li.setAttribute("data-idb", idB);
  idB++;
  var span = document.createElement("span");
  span.setAttribute("name", "product_name_");
  span.innerText = pname;
  //prompt("Ürün Adı");
  li.setAttribute("data-product_catid", p_cat_id);
  var div = document.createElement("div");
  div.setAttribute("style", "display:flex");
  div.appendChild(span);
  var div2 = document.createElement("div");
  div2.setAttribute(
    "style",
    "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
  );
  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("onchange", "MaliyetHesapla();");
  input.setAttribute("class", "form-control form-control-sm");
  input.setAttribute("style", "width:33%");
  input.setAttribute("name", "amount");
  input.setAttribute("value", 1);
  input.setAttribute("readonly", "true");
  var button = document.createElement("button");
  button.setAttribute("type", "button");
  button.setAttribute("class", "btn btn-outline-success");
  button.setAttribute("onclick", "OpenBasketProducts_Pars(this)");
  button.innerText = "+";
  var btn2 = document.createElement("button");
  btn2.innerText = "-";
  btn2.setAttribute("onclick", "remItem(this)");
  btn2.setAttribute("type", "button");
  btn2.setAttribute("class", "btn btn-outline-danger");

  var btn3 = document.createElement("button");
  btn3.innerText = "VP";
  btn3.setAttribute("onclick", "addProdSub(this)");
  btn3.setAttribute("type", "button");
  btn3.setAttribute("class", "btn btn-outline-warning");

  var btn4 = buttonCreator(
    "",
    "btn btn-outline-primary",
    "onclick",
    "setQuestion(this)",
    "Q"
  );
  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
  div2.appendChild(btn4);
  div2.appendChild(btn2);
  div.appendChild(div2);
  li.appendChild(div);
  /*var ul = document.createElement("ul");
  li.appendChild(ul);*/
  if (idb == 0) {
    var e = document.getElementById("ppidarea").children[0];
    e.appendChild(li);
  } else {
    var ul = document.createElement("ul");
    ul.setAttribute("id", idA);
    ul.setAttribute("data-is_virtual", 1);
    ul.setAttribute("class", "list-group");
    idA++;
    ul.appendChild(li);
    document.getElementByIdb(idb).appendChild(ul);
  }
  agacGosterEkle();
  sortableYap();
  MaliyetHesapla();
}

function OpenBasketProducts_Pars(el) {
  var es = el.parentElement.parentElement.parentElement.children;
  console.log(es);
  var sonul;
  for (let i = 0; i < es.length; i++) {
    var ls = es[i];
    // console.log(ls)
    if (ls.tagName == "UL") {
      sonul = ls;
    }
  }
  console.log(sonul);
  if (sonul != undefined) {
    var idd = sonul.getAttribute("id");
    OpenBasketProducts(idd, "5");
  } else {
    var ul = document.createElement("ul");
    ul.setAttribute("id", idA);
    ul.setAttribute("data-is_virtual", 1);
    ul.setAttribute("class", "list-group");
    var es = el.parentElement.parentElement.parentElement;
    es.appendChild(ul);
    OpenBasketProducts(idA, "5");
    idA++;
  }
}
function addProdSub(el) {
  var idbb =
    el.parentElement.parentElement.parentElement.getAttribute("data-idb");
  addProdMain(idbb);
}
function addProdSub_(el) {
  //console.log(el.parentElement)
  var es = el.parentElement.parentElement.parentElement.children;
  console.log(es);

  var sonul;
  for (let i = 0; i < es.length; i++) {
    var ls = es[i];
    // console.log(ls)
    if (ls.tagName == "UL") {
      sonul = ls;
    }
  }
  console.log(sonul);

  var li = document.createElement("li");
  li.setAttribute("data-product_id", 0);
  li.setAttribute("data-stock_id", 0);
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("class", "list-group-item");
  li.setAttribute("data-idb", idB);
  idB++;
  var span = document.createElement("span");
  span.setAttribute("name", "product_name_");
  span.innerText = prompt("Ürün Adı");
  var div = document.createElement("div");
  div.setAttribute("style", "display:flex");
  div.appendChild(span);
  var div2 = document.createElement("div");
  div2.setAttribute(
    "style",
    "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
  );
  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("onchange", "MaliyetHesapla();");
  input.setAttribute("class", "form-control form-control-sm");
  input.setAttribute("style", "width:33%");
  input.setAttribute("name", "amount");
  input.setAttribute("value", 1);
  input.setAttribute("readonly", "true");
  var button = document.createElement("button");
  button.setAttribute("type", "button");
  button.setAttribute("class", "btn btn-outline-success");
  button.setAttribute("onclick", "OpenBasketProducts_Pars(this)");
  button.innerText = "+";
  var btn2 = document.createElement("button");
  btn2.innerText = "-";
  btn2.setAttribute("onclick", "remItem(this)");
  btn2.setAttribute("type", "button");
  btn2.setAttribute("class", "btn btn-outline-danger");

  var btn3 = document.createElement("button");
  btn3.innerText = "VP";
  btn3.setAttribute("onclick", "addProdSub(this)");
  btn3.setAttribute("type", "button");
  btn3.setAttribute("class", "btn btn-outline-warning");
  var btn4 = buttonCreator(
    "",
    "btn btn-outline-primary",
    "onclick",
    "setQuestion(this)",
    "Q"
  );
  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
  div2.appendChild(btn4);
  div2.appendChild(btn2);
  div.appendChild(div2);
  li.appendChild(div);
  if (sonul == undefined) {
    sonul = document.createElement("ul");
    sonul.setAttribute("class", "list-group");
    sonul.setAttribute("id", idA);
    idA++;
    sonul.appendChild(li);
    el.parentElement.parentElement.parentElement.appendChild(sonul);
  } else {
    sonul.appendChild(li);
  }
  agacGosterEkle();
  sortableYap();
  MaliyetHesapla();
}
function getCats(el, ev) {
  console.log(ev);
  var bul = false;
  if (ev.type == "change") {
    if (el.value.length > 3) {
      bul = true;
    }
  } else if (ev.type == "keyup") {
    if (el.value.length > 3 && ev.keyCode == 13) {
      bul = true;
    }
  }
  if (bul) {
    var q = wrk_query(
      "SELECT * FROM PRODUCT_CAT WHERE PRODUCT_CAT LIKE '%" +
        el.value +
        "%' OR HIERARCHY LIKE '%" +
        el.value +
        "%'",
      "dsn3"
    );
    if (q.recordcount > 0) {
      var tt = document.getElementById("tblCat");
      $("#tblCat").html("");
      tt.innerHtml = "";
      for (let i = 0; i < q.recordcount; i++) {
        var cid = q.PRODUCT_CATID[i];
        var cn = q.PRODUCT_CAT[i];
        var hi = q.HIERARCHY[i];
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        var a = document.createElement("a");
        a.setAttribute("href", "javascript://");
        a.setAttribute("onclick", "setCat(" + cid + ",'" + cn + "')");
        a.innerText = hi;
        td.appendChild(a);
        tr.appendChild(td);

        var td = document.createElement("td");
        var a = document.createElement("a");
        a.setAttribute("href", "javascript://");
        a.setAttribute("onclick", "setCat(" + cid + ",'" + cn + "')");
        a.innerText = cn;
        td.appendChild(a);
        tr.appendChild(td);

        tt.appendChild(tr);
      }
    }
    $("#catRdiv").show(500);
  }
}

function setCat(id, cat) {
  $("#productCatIdVp").val(id);
  $("#productCatVp").val(cat);
  $("#catRdiv").hide(500);
}

function loadQuestions() {
  var q = "SELECT QUESTION_ID,QUESTION FROM VIRTUAL_PRODUCT_TREE_QUESTIONS";
  var r = wrk_query(q, "dsn3");
  $("#saquestion").html("");
  var opt = document.createElement("option");
  opt.setAttribute("value", "");
  opt.innerText = "Alternatif Sorusu";
  document.getElementById("saquestion").appendChild(opt);
  for (let i = 0; i < r.recordcount; i++) {
    var id = r.QUESTION_ID[i];
    var nm = r.QUESTION[i];
    var opt = document.createElement("option");
    opt.setAttribute("value", id);
    opt.innerText = nm;
    document.getElementById("saquestion").appendChild(opt);
  }
}

function addAltrnativeQ(dsn3, modalid) {
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_add_alternative_question_pbs"
  );
}

function saveAlternative(dsn3, modalid) {
  var QUESTION_NAME = document.getElementById("questionName").value;
  $.ajax({
    url:
      "/AddOns/Partner/cfc/generalFunctions.cfc?method=saveAlternative&QUESTION_NAME=" +
      QUESTION_NAME +
      "&dsn3=" +
      dsn3,
    success: function (retDat) {
      console.log(retDat);
      closeBoxDraggable(modalid);
      loadQuestions();
    },
  });
}

function agacGosterEkle() {
  var e = $("#ppidarea *ul");
  for (let i = 0; i < e.length; i++) {
    var ees = e[i].parentElement;
    console.log(ees.tagName);
    if (ees.tagName == "LI") {
      var btn = document.createElement("button");
      var ix = document.createElement("i");
      ix.setAttribute("class", "icn-md icon-down");
      btn.setAttribute("class", "btn btn-sm btn-link");
      btn.appendChild(ix);
      btn.setAttribute(
        "onclick",
        "$(this.parentElement.parentElement.lastChild).toggle(500)"
      );
      console.log(btn);
      ees.children[0].prepend(btn);
    }
  }
}

function sortableYap() {
  var e = $("#ppidarea *ul").sortable({
    connectWith: ".list-group",
    sort: function (event, ui) {
      console.log("sort");
    },
    start: function (event, ui) {
      console.log("start");
    },
    stop: function (event, ui) {
      console.log("stop");
    },
    update: function (event, ui) {
      console.log("update");
    },
    receive: function (event, ui) {
      console.log("receive");
      console.log(ui.sender[0]);
      console.log(event.target);
    },
  });
  return true;
}

function virtuallariYerlestir() {
  var e = $("#ppidarea *ul");
  for (let i = 0; i < e.length; i++) {
    var ees = e[i].parentElement;
    if (ees.getAttribute("id") == "ppidarea") {
      console.log("ek");
      e[i].setAttribute("data-is_virtual", "1");
      var emount = $(e[i]).find("input[name='amount']");
      console.log(emount);
      emount.removeAttr("readonly");
    } else {
      var eesa = ees.getAttribute("data-is_virtual");
      if (parseInt(eesa) == 1) {
        console.log(eesa);
        e[i].setAttribute("data-is_virtual", "1");
        var emount = $(e[i]).find("input[name='amount']");
        console.log(emount);
        emount.removeAttr("readonly");
      } else {
        var emount = $(e[i]).find("input[name='amount']");
        console.log(emount);
        emount.attr("readonly", "true");
      }
    }
  }
}

function AgaciYaz_12(arr, isoq, address = "0", vrt = "1", li) {
  var upProduct = ProductDesingSetting.find(
    (p) => p.paramName == "update_real_product"
  ).paramValue;
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");

  ul.setAttribute("data-is_virtual", vrt);

  ul.setAttribute("data-seviye", isoq);
  ul.setAttribute("id", idA);
  idA = idA + 1;
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
    spn.setAttribute("name", "product_name_");
    var qname = VIRTUAL_PRODUCT_TREE_QUESTIONS.find(
      (p) => p.QUESTION_ID == arr[i].QUESTION_ID
    );
    var str = arr[i].PRODUCT_NAME;
    if (qname != undefined) {
      qname =
        "<span style='color:var(--danger)'>(" + qname.QUESTION + ")</span>";
    } else {
      qname = "";
    }
    spn.innerHTML = arr[i].PRODUCT_NAME + " " + qname;

    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-stock_id", arr[i].STOCK_ID);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    ul.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);
    li.setAttribute("data-question_id", arr[i].QUESTION_ID);
    li.setAttribute("data-idb", idB);
    idB++;
    var diva = document.createElement("div");
    var btn = buttonCreator(
      "",
      "btn btn-outline-success",
      "onclick",
      "getitem(this)",
      "+"
    );
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var inp = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      arr[i].AMOUNT
    );
    diva.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    if (upProduct == "OFF" && arr[i].IS_VIRTUAL != 1) {
      inp.setAttribute("readonly", "true");
      btn.setAttribute("disabled", "true");
      btn2.setAttribute("disabled", "true");
      btn3.setAttribute("disabled", "true");
    }

    diva.appendChild(inp);
    diva.appendChild(btn);
    diva.appendChild(btn3);
    diva.appendChild(btn2);
    var divb = document.createElement("div");
    divb.setAttribute("style", "display:flex");
    divb.appendChild(spn);
    divb.appendChild(diva);
    li.appendChild(divb);

    //  li.setAttribute("onclick", "getitem(this)");

    li.setAttribute("class", "list-group-item");
    if (arr[i].AGAC.length > 0) {
      li.appendChild(
        AgaciYaz_12(arr[i].AGAC, arr[i].RNDM_ID, address, arr[i].IS_VIRTUAL)
      );
    } else {
    }

    ul.appendChild(li);
  }

  return ul;
}

function AgaciYaz_13(arr, isoq, address = "0", vrt = "1", li) {
  var upProduct = ProductDesingSetting.find(
    (p) => p.paramName == "update_real_product"
  ).paramValue;
  
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");

  ul.setAttribute("data-is_virtual", vrt);

  ul.setAttribute("data-seviye", isoq);
  ul.setAttribute("id", idA);
  idA = idA + 1;
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
    spn.setAttribute("name", "product_name_");
    var qname = VIRTUAL_PRODUCT_TREE_QUESTIONS.find(
      (p) => p.QUESTION_ID == arr[i].QUESTION_ID
    );
    var str = arr[i].PRODUCT_NAME;
    if (qname != undefined) {
      qname =
        "<span style='color:var(--danger)'>(" + qname.QUESTION + ")</span>";
    } else {
      qname = "";
    }
    spn.innerHTML = arr[i].PRODUCT_NAME + " " + qname;

    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-stock_id", arr[i].STOCK_ID);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    ul.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);
    li.setAttribute("data-question_id", arr[i].QUESTION_ID);
    li.setAttribute("data-idb", idB);
    idB++;
    var diva = document.createElement("div");
    var btn = buttonCreator(
      "",
      "btn btn-outline-success",
      "onclick",
      "getitem(this)",
      "+"
    );
    var btn2 = buttonCreator(
      "",
      "btn btn-outline-danger",
      "onclick",
      "remItem(this)",
      "-"
    );
    var inp = inputCreator(
      "text",
      "amount",
      "onchange",
      "MaliyetHesapla();",
      "form-control form-control-sm",
      "width:33%",
      arr[i].AMOUNT
    );
    diva.setAttribute(
      "style",
      "display:flex;align-items:baseline;float:right;margin-left:auto;justify-content: flex-end"
    );
    var btn3 = buttonCreator(
      "",
      "btn btn-outline-primary",
      "onclick",
      "setQuestion(this)",
      "Q"
    );
    if (upProduct == "OFF" && arr[i].IS_VIRTUAL != 1) {
      inp.setAttribute("readonly", "true");
      btn.setAttribute("disabled", "true");
      btn2.setAttribute("disabled", "true");
      btn3.setAttribute("disabled", "true");
    }

    diva.appendChild(inp);
    diva.appendChild(btn);
    diva.appendChild(btn3);
    diva.appendChild(btn2);
    var divb = document.createElement("div");
    divb.setAttribute("style", "display:flex");
    divb.appendChild(spn);
    divb.appendChild(diva);
    li.appendChild(divb);

    //  li.setAttribute("onclick", "getitem(this)");

    li.setAttribute("class", "list-group-item");
    if (arr[i].AGAC.length > 0) {
      li.appendChild(
        AgaciYaz_12(arr[i].AGAC, arr[i].RNDM_ID, address, arr[i].IS_VIRTUAL)
      );
    } else {
    }

    ul.appendChild(li);
  }

  return ul;
}

function UrunKaydet() {
  var agacim = SonAgac[SonAgac.length - 1];
  var product_name = $("#pnamemain").val();
  var product_id = $("#vp_id").val();
  var is_virtual = $("#is_virtual").val();
  var project_id = $("#project_id").val();
  var stg = $("#pstage").val();
  var BasketData = {
    PRODUCT_NAME: product_name,
    PRODUCT_ID: product_id,
    IS_VIRTUAL: is_virtual,
    PROJECT_ID: project_id,
    PRODUCT_STAGE: stg,
    PRODUCT_TREE: agacim,
  };

  if (BasketData) {
    var mapForm = document.createElement("form");
    mapForm.target = "Map";
    mapForm.method = "POST"; // or "post" if appropriate
    mapForm.action =
      "/index.cfm?fuseaction=project.emptypopup_query_save_project_product";

    var mapInput = document.createElement("input");
    mapInput.type = "hidden";
    mapInput.name = "data";
    mapInput.value = JSON.stringify(BasketData);
    mapForm.appendChild(mapInput);

    document.body.appendChild(mapForm);

    map = window.open(
      "/index.cfm?fuseaction=project.emptypopup_query_save_project_product",
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

function setQuestion(el) {
  var e = el.parentElement.parentElement.parentElement;
  console.log(e);
  var ev = e.getAttribute("data-idb");
  console.log(ev);
  openBoxDraggable(
    "index.cfm?fuseaction=project.emptypopup_mini_tools&tool_type=alternativeQuestion&idb=" +
      ev
  );
}

function setAQuestions(idb, queid, modalid, QUESTION_NAME) {
  var el = document.getElementByIdb(idb);
  el.setAttribute("data-question_id", queid);
  var es = $(el).find("span[name='product_name_']")[0];
  var span = document.createElement("span");
  span.innerText = "(" + QUESTION_NAME + ")";
  span.setAttribute("style", "color:var(--danger)");
  es.appendChild(span);
  closeBoxDraggable(modalid);
}

document.getElementByIdb = function (idb) {
  var str = idb.toString();
  var el = $("*").find("* [data-idb='" + str + "']")[0];
  return el;
};

function MaliyetHesapla() {
  var TotalPrice = 0;
  var Products = $("#ppidarea *li");
  Products.each(function (ix, Product) {
    // console.log(Product)
    //console.log($(Product).find("input[name='amount']"))
    var miktar = $(Product).find("input[name='amount']").val();
    var price = Product.getAttribute("data-price");
    var money = Product.getAttribute("data-other_money");
    var discount = Product.getAttribute("data-discount");
    //console.log(price,money,discount)

    if (price == undefined || price.length == 0) price = 0;
    if (money == undefined || money.trim().length == 0) money = "TL";
    if (discount == undefined || discount.length == 0) discount = 0;
    price = parseFloat(price);
    discount = parseFloat(discount);
    miktar = parseFloat(miktar);
    var Rate2 = moneyArr[moneyArr.findIndex((p) => p.MONEY == money)].RATE2;
    Rate2 = parseFloat(Rate2);
    var indirimli = price - (price * discount) / 100;
    var Tprice = indirimli * Rate2 * miktar;
    console.log(Tprice);
    TotalPrice += Tprice;
  });
  var Mn = commaSplit(TotalPrice);
  $("#maliyet").val(Mn);
}

function updateStage(el, projectId) {
  var vp_id = document.getElementById("vp_id").value;
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=updateStage&vp_id=" +
      vp_id +
      "&psatge=" +
      el.value +
      "&ddsn3=workcube_metosan_1",
    success: function (retDat) {
      console.log(retDat);
      getProjectProducts(projectId);
    },
  });
}
function getProjectProducts(projectId) {
  // var vp_id = document.getElementById("vp_id").value;
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=getProjectProducts&PROJECT_ID=" +
      projectId +
      "&ddsn3=workcube_metosan_1",
    success: function (retDat) {
      console.log(retDat);
      $("#leftMenuProject").html(retDat);
    },
  });
}
/*
 <cfargument name="vp_id">
        <cfargument name="psatge">
        <cfargument name="projectId">
        <cfargument name="ddsn3">
*/

function addToCurrentTree(vp_id) {
  var e = ngetTree(vp_id, 1, "workcube_metosan_1", "", 3, "", "", "");
}
