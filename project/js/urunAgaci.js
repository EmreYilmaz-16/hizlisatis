var o = new Object();
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
var _compId;
var _priceCatId;
var SonAgac = new Array();
var idA = 1000;
var isUpdated = false;
function ngetTree(product_id, is_virtual, dsn3, btn) {
  var pn = btn.parentElement.children[0].innerText;
  $("#pnamemain").val(pn);
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
    spn.innerHTML = arr[i].PRODUCT_NAME;

    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);

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
      "console.log(this)",
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
    diva.appendChild(btn2);
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
  idA = 1000;
  console.log("Yeni Taslak");
  var d = document.createElement("div");
  d.setAttribute("id", "ppidarea");
  var ul = document.createElement("ul");
  ul.setAttribute("id", idA);
  ul.setAttribute("data-is_virtual", "1");
  ul.setAttribute("class", "list-group");
  idA++;
  d.appendChild(ul);
  var e = document.getElementById("TreeArea");
  e.innerHTML = "";
  e.appendChild(d);
  $("#pnamemain").val(enmae);
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
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("class", "list-group-item");
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
      "console.log(this)",
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
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("class", "list-group-item");
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
      "console.log(this)",
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
}

function AgacGetir(agacim, sx = 0) {
  console.log(sx);
  sx++;
  var at = new Array();
  for (let i = 0; i < agacim.length; i++) {
    // console.log(agacim[i])
    var pid = agacim[i].getAttribute("data-product_id");

    //console.log(agacim[i])
    obj = agacim[i];
    var amount = $(obj).find("input[name='amount']")[0].value;
    var pname = $(obj).find("span[name='product_name_']")[0].innerText;
    var agacItem = new Object();
    agacItem.PRODUCT_ID = pid;
    agacItem.PRODUCT_NAME = pname;
    agacItem.AMOUNT = amount;
    agacItem.AGAC = new Array();
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
}
function addProdMain() {
  openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_add_vp_project");
}

function addProdMain_() {
  var pname = document.getElementById("productNameVp").value;
  var p_cat_id = document.getElementById("productCatIdVp").value;
  var li = document.createElement("li");
  li.setAttribute("data-product_id", 0);
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("class", "list-group-item");
  var span = document.createElement("span");
  span.setAttribute("name", "product_name_");
  span.innerText = pname;
  //prompt("Ürün Adı");
  span.setAttribute("data-product_catid", p_cat_id);
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
  input.setAttribute("onchange", "console.log(this)");
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

  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
  div2.appendChild(btn2);
  div.appendChild(div2);
  li.appendChild(div);
  /*var ul = document.createElement("ul");
  li.appendChild(ul);*/
  var e = document.getElementById("ppidarea").children[0];
  e.appendChild(li);
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
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("class", "list-group-item");
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
  input.setAttribute("onchange", "console.log(this)");
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

  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
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
