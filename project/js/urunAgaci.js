var o = new Object();
var SP_FIYAT_HESAP_SONUC;
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
var _compId;
var _priceCatId;
var SonAgac = new Array();
var idA = 1000;
var isUpdated = false;
var idB = 5000;
var denemeButon = "";
function ngetTree(
  product_id,
  is_virtual,
  dsn3,
  btn,
  tip = 1,
  li = "",
  pna = "",
  stg = "",
  idba = ""
) {
  //console.log(arguments);
  if (tip == 1) {
    /* var pn = btn.parentElement.children[0].innerText;
    var */
    var sida = 0;
    if (is_virtual == 1) {
      var qqq = wrk_query(
        "SELECT PRODUCT_NAME FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=" +
          product_id,
        "DSN3"
      );
    } else {
      var qqq = wrk_query(
        "SELECT PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE PRODUCT_ID=" +
          product_id,
        "DSN3"
      );
      sida = qqq.STOCK_ID[0];
    }

    var pna = qqq.PRODUCT_NAME[0];
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
        _priceCatId +
        "&stock_id=" +
        sida,
      success: function (asd) {
        // var jsonStr = strToJson(asd);
        o = JSON.parse(asd);
        // console.log(o);
        AgaciYaz(o, 0, "0", 1);
        var esd = document.getElementById("TreeArea");
        esd.innerHTML = "";

        esd.appendChild(ulx);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
       // MaliyetHesapla();
       MaliyetHesapla2()
        GercekKontrol(product_id);
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
        // var jsonStr = strToJson(asd);
        o = JSON.parse(asd);
        // console.log(o);
        //  console.log("Buradayım");
        //   partnerEkle(o);
        var et = AgaciYaz_12(o, 0, "", 0);
        li.appendChild(et);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
      //  MaliyetHesapla();
      MaliyetHesapla2()
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
        // var jsonStr = strToJson(asd);
        o = JSON.parse(asd);
        /*  console.log(o);
                console.log("Buradayım");*/
        //   partnerEkle(o);
        /* var et = AgaciYaz_12(o, 0, "", 0);
                var e = document.getElementById("ppidarea").children[0];
                var li = document.createElement("li");
                li.appendChild(et);*/
        //AddRowItemVirtual(o.PRODUCT_ID,o.PRODUCT_NAME,'',0,0,0,'TL',0,0,0,0);

        //e.appendChild(li);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
        //MaliyetHesapla();
        MaliyetHesapla2()
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
  } else if (tip == 4) {
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
        //   var jsonStr = strToJson(asd);
        o = JSON.parse(asd);
        // console.log(o);
        //  console.log("Buradayım");
        //   partnerEkle(o);
        var et = AgaciYaz_12(o, 0, "", 0);
        $("#ppidarea").html("");
        document.getElementById("ppidarea").appendChild(et);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
        //MaliyetHesapla();
        MaliyetHesapla2()
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
  } else if (tip == 5) {
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
        // var jsonStr = strToJson(asd);
        o = JSON.parse(asd);
        // console.log(o);
        //  console.log("Buradayım");
        //   partnerEkle(o);
        var et = AgaciYaz_12(o, 0, "", 0);
        document.getElementByIdb(idba).appendChild(et);
        //$("#ppidarea").html("");
        //document.getElementById("ppidarea").appendChild(et);
        console.log(idba);
        agacGosterEkle();
        sortableYap();
        virtuallariYerlestir();
       // MaliyetHesapla();
       MaliyetHesapla2()
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
  //console.log(oo);
}

function strToJson(str) {
  console.log(str);
  var newStr = "";
  for (let i = 0; i < str.length; i++) {
    var currentChar = str.charAt(i).trim();
    if (currentChar == "," && str.charAt(i + 1).trim() == "]") {
      // console.log("ebe");
      currentChar = "";
    }
    newStr += currentChar;
  }
  console.log(newStr);
  return newStr;
}

function AgaciYaz(arr, isoq, address = "0", vrt = "1") {
  // console.log("AgaciYaz Virtual=" + vrt);
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
    spn.setAttribute("style", "display:inline-grid");
    var qname = VIRTUAL_PRODUCT_TREE_QUESTIONS.find(
      (p) => p.QUESTION_ID == arr[i].QUESTION_ID
    );
    var dName = arr[i].DISPLAYNAME;
    var str = arr[i].PRODUCT_NAME;
    if (qname != undefined) {
      qname =
        "<span name='question_name_' style='color:var(--danger)'>(" +
        qname.QUESTION +
        ")</span>";
    } else {
      qname = "";
    }
    if (dName != undefined && dName.length > 0) {
      dName =
        "<span name='display_name_' style='color:var(--success)'>(" +
        dName +
        ")</span>";
    } else {
      dName = "";
    }
    var sssx=makeFiyatSpan(arr[i].PRICE,arr[i].MONEY,"fiyatimis_"+idB)
    spn.innerHTML = arr[i].PRODUCT_NAME +"-"+sssx+ " " + qname + " " + dName;
    console.log(arr[i]); ///burası kalacak
    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-stock_id", arr[i].STOCK_ID);
    li.setAttribute("data-price", arr[i].PRICE);
    li.setAttribute("data-other_money", arr[i].MONEY);
    li.setAttribute("data-discount", arr[i].DISCOUNT);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);
    li.setAttribute("data-question_id", arr[i].QUESTION_ID);
    li.setAttribute("data-displayName", arr[i].DISPLAYNAME);
    //TESTET BURASI SATIR TUTARINI HESAPLAMAK İÇİN KONDU VERİ GELMEZSE NE OLUR KONTROL ET
    var prcs=parseFloat(arr[i].PRICE)
    var MNYX = moneyArr.findIndex((p) => p.MONEY == arr[i].MONEY);
    var RATE2MNY = moneyArr[MNYX].RATE2;
    RATE2MNY=parseFloat(RATE2MNY);
    var dpx = prcs - (prcs * arr[i].DISCOUNT) / 100;
    var nttl = dpx * arr[i].AMOUNT * RATE2MNY;
    var OX={
      line:329,
      PRODUCT_ID:arr[i].PRODUCT_ID,
      STOCK_ID:arr[i].STOCK_ID,
      AMOUNT:arr[i].AMOUNT,
      PRICE:prcs,
      MONEY:arr[i].MONEY,
      DISCOUNT:arr[i].DISCOUNT,
      IS_VIRTUAL:arr[i].IS_VIRTUAL,
      PRODUCT_TREE_ID:arr[i].PRODUCT_TREE_ID,
      QUESTION_ID:arr[i].QUESTION_ID,
      DISPLAYNAME:arr[i].DISPLAYNAME,
      RATE2MNY:RATE2MNY,
      NETTOTAL:nttl,
      MNYX:MNYX
    }
    console.table(OX);
    li.setAttribute("data-netTotal", nttl);

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
    var btn5 = buttonCreator(
      "",
      "btn btn-outline-info",
      "onclick",
      "LoadTree(this)",
      "Pr"
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
    diva.appendChild(btn5);
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
  // console.log(el);
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
  //LoadSettings();
  var PROJECT_ID = getParameterByName("project_id");
  var cp_id = wrk_query(
    "select COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_ID=" + PROJECT_ID,
    "DSN"
  ).COMPANY_ID[0];
  let compInfo = GetAjaxQuery("CompanyInfo", cp_id);
  _priceCatId = compInfo.PRICE_LISTS.find((p) => p.IS_DEFAULT == 1).PRICE_CATID;
  _compId = cp_id;
});
function makeFiyatSpan(itext,itext2,iid){
 var spn="<span id='"+iid+"'>"+commaSplit(itext)+" "+itext2+"</span>"
  // var spn=document.createElement("span");
  // spn.innerText=itext;
  // spn.id=iid;
return spn;

}

function LoadSettings() {
  $("#settingsArea").html("");
  var table = document.createElement("table");
  for (let i = 0; i < ProductDesingSetting.length; i++) {
    var tr = document.createElement("tr");
    var td = document.createElement("td");
    if (ProductDesingSetting[i].elementType == "bool") {
      var div = document.createElement("div");
      div.setAttribute("class", "custom-control custom-switch");
      div.setAttribute("onclick", "setSettings(this)");
      div.setAttribute("data-paramName", ProductDesingSetting[i].paramName);
      div.setAttribute("data-paramValue", ProductDesingSetting[i].paramValue);
      var input = document.createElement("input");
      input.setAttribute("type", "checkbox");
      input.setAttribute("name", ProductDesingSetting[i].paramName);
      input.setAttribute("id", ProductDesingSetting[i].paramName);
      input.setAttribute("class", "custom-control-input");
      if (ProductDesingSetting[i].paramValue == "ON")
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
  // console.log(enmae);
  if (enmae == null || enmae.trim().length == 0) return false;
  idA = 1000;
  //  console.log("Yeni Taslak");
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
      // console.log(retDat);
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
  COLUMNSA,
  AMOUNT
) {
  // console.log(arguments);
  if (COLUMNSA == 0) {
    var e = document.getElementById("ppidarea").children[0];
    var li = document.createElement("li");
    li.setAttribute("data-product_id", PRODUCT_ID);
    li.setAttribute("data-stock_id", STOCK_ID);
    li.setAttribute("data-is_virtual", 0);
    li.setAttribute("data-price", PRICE);
    li.setAttribute("data-standart_price", PRICE);
    li.setAttribute("data-other_money", MONEY);
    li.setAttribute("data-discount", DISCOUNT_RATE);
    li.setAttribute("class", "list-group-item");
    li.setAttribute("data-idb", idB);
    var amx=filterNum(AMOUNT);
    amx=parseFloat(amx);
    //TESTET BURASI SATIR TUTARINI HESAPLAMAK İÇİN KONDU VERİ GELMEZSE NE OLUR KONTROL ET
    var MNYX = moneyArr.findIndex((p) => p.MONEY == MONEY);
    var RATE2MNY = moneyArr[MNYX].RATE2;
    RATE2MNY=parseFloat(RATE2MNY);
    var dpx = PRICE - (PRICE * DISCOUNT_RATE) / 100;
    var nttl = dpx * RATE2MNY * amx;
    var OX={
      line:695,
      PRODUCT_ID:PRODUCT_ID,
      STOCK_ID:STOCK_ID,
      AMOUNT:amx,
      PRICE:PRICE,
      MONEY:MONEY,
      DISCOUNT:DISCOUNT_RATE,
      IS_VIRTUAL:0,
      PRODUCT_TREE_ID:0,
      QUESTION_ID:0,
      DISPLAYNAME:'',
      RATE2MNY:RATE2MNY,
      NETTOTAL:nttl,
      MNYX:MNYX
    }
console.table(OX);
    li.setAttribute("data-netTotal", nttl);
    
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.setAttribute("style", "display:inline-grid");
    var  soxx=makeFiyatSpan(PRICE,MONEY,"fiyatimis_"+idB)
    span.innerHtml = PRODUCT_NAME+'-'+soxx
    idB++;
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
      AMOUNT
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

    //TESTET BURASI SATIR TUTARINI HESAPLAMAK İÇİN KONDU VERİ GELMEZSE NE OLUR KONTROL ET
    var amx=filterNum(AMOUNT);
    amx=parseFloat(amx);
    var MNYX = moneyArr.findIndex((p) => p.MONEY == MONEY);
    var RATE2MNY = moneyArr[MNYX].RATE2;
    var dpx = PRICE - (PRICE * DISCOUNT_RATE) / 100;
    var nttl = dpx * RATE2MNY * amx;
    
    var OX={
      line:784,
      PRODUCT_ID:PRODUCT_ID,
      STOCK_ID:STOCK_ID,
      AMOUNT:amx,
      PRICE:PRICE,
      MONEY:MONEY,
      DISCOUNT:DISCOUNT_RATE,
      IS_VIRTUAL:0,
      PRODUCT_TREE_ID:0,
      QUESTION_ID:0,
      DISPLAYNAME:'',
      RATE2MNY:RATE2MNY,
      NETTOTAL:nttl,
      MNYX:MNYX
    }
console.table(OX);

    li.setAttribute("data-netTotal", nttl);
    
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.setAttribute("style", "display:inline-grid");
    var  soxx=makeFiyatSpan(PRICE,MONEY,"fiyatimis_"+idB)
    span.innerHtml = PRODUCT_NAME+'-'+soxx
    idB++;
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
      AMOUNT
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
  //console.log(q.recordcount);
  if (q.recordcount > 0) {
    ngetTree(STOCK_ID, 0, "workcube_metosan_1", "", 2, li);
  }
  MaliyetHesapla2();
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
  //console.log(arguments);
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

    //TESTET BURASI SATIR TUTARINI HESAPLAMAK İÇİN KONDU VERİ GELMEZSE NE OLUR KONTROL ET
    var MNYX = moneyArr.findIndex((p) => p.MONEY == MONEY);
    var RATE2MNY = moneyArr[MNYX].RATE2MNY;
    var dpx = PRICE - (PRICE * DISCOUNT_RATE) / 100;
    var nttl = dpx * RATE2MNY * AMOUNT;

    li.setAttribute("data-netTotal", nttl);
    
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.setAttribute("style", "display:inline-grid");
    var  soxx=makeFiyatSpan(PRICE,MONEY,"fiyatimis_"+idB)
    span.innerHtml = PRODUCT_NAME+'-'+soxx
    idB++;
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
    //TESTET BURASI SATIR TUTARINI HESAPLAMAK İÇİN KONDU VERİ GELMEZSE NE OLUR KONTROL ET
    var MNYX = moneyArr.findIndex((p) => p.MONEY == MONEY);
    var RATE2MNY = moneyArr[MNYX].RATE2MNY;
    var dpx = PRICE - (PRICE * DISCOUNT_RATE) / 100;
    var nttl = dpx * RATE2MNY * AMOUNT;
    li.setAttribute("data-netTotal", nttl);
    
    var div = document.createElement("div");
    div.setAttribute("style", "display:flex");
    var span = document.createElement("span");
    span.setAttribute("name", "product_name_");
    span.setAttribute("style", "display:inline-grid");
    var  soxx=makeFiyatSpan(PRICE,MONEY,"fiyatimis_"+idB)
    span.innerHtml = PRODUCT_NAME+'-'+soxx
    idB++;
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
  // console.log(q.recordcount);
  if (q.recordcount > 0) {
    ngetTree(STOCK_ID, 1, "workcube_metosan_1", "", 2, li);
  }
  MaliyetHesapla2()
}

function AgacGetir(agacim, sx = 0) {
  //  console.log(sx);
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
    var tutar = agacim[i].getAttribute("data-netTotal"); //DIKKAT BURAYA BAKILACAK
    var money = agacim[i].getAttribute("data-other_money");
    var discount = agacim[i].getAttribute("data-discount");
    var displayName = agacim[i].getAttribute("data-displayName");

    //console.log(agacim[i])
    obj = agacim[i];
    var amount = $(obj).find("input[name='amount']")[0].value;
    amount = filterNum(amount);
    var pname = $(obj).find("span[name='product_name_']")[0].innerText;
    var agacItem = new Object();
    agacItem.PRODUCT_ID = pid;
    agacItem.PRODUCT_NAME = pname;
    agacItem.AMOUNT = amount;
    agacItem.IS_VIRTUAL = is_virtual;
    agacItem.STOCK_ID = sid;
    agacItem.QUESTION_ID = question_id;
    agacItem.PRICE = price;
    agacItem.NET_TOTAL = tutar;
    agacItem.MONEY = money;
    agacItem.DISCOUNT = discount;
    agacItem.DISPLAY_NAME = displayName;
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
    // console.log(agac);
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
  //console.log(SonAgac);
  UrunKaydet();
}

function addProdMain(idbb = 0) {
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_add_vp_project&idb=" + idbb
  );
}

/*
    var pid = agacim[i].getAttribute("data-product_id");
    var sid = agacim[i].getAttribute("data-stock_id");
    var p_cat_id = agacim[i].getAttribute("data-product_catid");
    var is_virtual = agacim[i].getAttribute("data-is_virtual");
    var question_id = agacim[i].getAttribute("data-question_id");
    var price = agacim[i].getAttribute("data-price");
    var money = agacim[i].getAttribute("data-other_money");
    var discount = agacim[i].getAttribute("data-discount");
    var displayName = agacim[i].getAttribute("data-displayName");
    var question_id = agacim[i].getAttribute("data-question_id");
*/
function addProdMain_(idb, modal_id) {
  var pname = document.getElementById("productNameVp").value;
  var p_cat_id = document.getElementById("productCatIdVp").value;
  var li = document.createElement("li");
  li.setAttribute("data-product_id", 0);
  li.setAttribute("data-stock_id", 0);
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("data-price", 0);
  li.setAttribute("data-netTotal", 0);
  li.setAttribute("data-discount", 0);
  li.setAttribute("data-other_money", "TL");
  li.setAttribute("data-displayName", "");
  li.setAttribute("data-question_id", "");
  li.setAttribute("data-sta", 0);
  li.setAttribute("class", "list-group-item");
  li.setAttribute("data-idb", idB);

  var span = document.createElement("span");
  span.setAttribute("name", "product_name_");
  span.setAttribute("style", "display:inline-grid");
  var  soxx=makeFiyatSpan(PRICE,MONEY,"fiyatimis_"+idB)
  span.innerHtml = pname+'-'+soxx
  idB++;
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
  var btn5 = buttonCreator(
    "",
    "btn btn-outline-info",
    "onclick",
    "LoadTree(this)",
    "Pr"
  );
  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
  div2.appendChild(btn4);
  div2.appendChild(btn5);
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
  MaliyetHesapla2()
  closeBoxDraggable(modal_id);
}

function OpenBasketProducts_Pars(el) {
  var es = el.parentElement.parentElement.parentElement.children;
  // console.log(es);
  var sonul;
  for (let i = 0; i < es.length; i++) {
    var ls = es[i];
    // console.log(ls)
    if (ls.tagName == "UL") {
      sonul = ls;
    }
  }
  //console.log(sonul);
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
  // console.log(es);

  var sonul;
  for (let i = 0; i < es.length; i++) {
    var ls = es[i];
    // console.log(ls)
    if (ls.tagName == "UL") {
      sonul = ls;
    }
  }
  // console.log(sonul);

  var li = document.createElement("li");
  li.setAttribute("data-product_id", 0);
  li.setAttribute("data-stock_id", 0);
  li.setAttribute("data-is_virtual", 1);
  li.setAttribute("class", "list-group-item");
  li.setAttribute("data-idb", idB);
  idB++;
  var span = document.createElement("span");
  span.setAttribute("name", "product_name_");
  span.setAttribute("style", "display:inline-grid");
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
  var btn5 = buttonCreator(
    "",
    "btn btn-outline-info",
    "onclick",
    "LoadTree(this)",
    "Pr"
  );
  div2.appendChild(input);
  div2.appendChild(button);
  div2.appendChild(btn3);
  div2.appendChild(btn4);
  div2.appendChild(btn5);
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
  MaliyetHesapla2();
}

function getCats(el, ev) {
  // console.log(ev);
  var bul = false;
  if (ev.type == "change") {
    if (el.value.length > 5) {
      bul = true;
    }
  } else if (ev.type == "keyup") {
    if (ev.keyCode == 13) {
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
        var q2 = wrk_query(
          "select * from PRODUCT_CAT where HIERARCHY like '" +
            q.HIERARCHY[i] +
            "%' and HIERARCHY <>'" +
            q.HIERARCHY[i] +
            "'",
          "dsn3"
        );
        var cid = q.PRODUCT_CATID[i];
        var cn = q.PRODUCT_CAT[i];
        var hi = q.HIERARCHY[i];
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        var a = document.createElement("a");
        if (q2.recordcount == 0) {
          a.setAttribute("href", "javascript://");
          a.setAttribute("onclick", "setCat(" + cid + ",'" + cn + "')");
        }
        a.innerText = hi;
        td.appendChild(a);
        tr.appendChild(td);

        var td = document.createElement("td");
        var a = document.createElement("a");
        if (q2.recordcount == 0) {
          a.setAttribute("href", "javascript://");
          a.setAttribute("onclick", "setCat(" + cid + ",'" + cn + "')");
        }
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
      //console.log(retDat);
      closeBoxDraggable(modalid);
      loadQuestions();
    },
  });
}

function agacGosterEkle() {
  var e = $("#ppidarea *ul");
  for (let i = 0; i < e.length; i++) {
    var ees = e[i].parentElement;
    //console.log(ees.tagName);
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
      //console.log(btn);
      ees.children[0].prepend(btn);
    }
  }
}
/*
    <cfargument name="VP_ID">
    <cfargument name="PRICE" default="">
    <cfargument name="Discount" default="">
    <cfargument name="OtherMoney" default="">
    <cfargument name="DisplayName" default="">
    <cfargument name="ProductStage"default="" >
 
 */
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
      //  console.log("ek");
      e[i].setAttribute("data-is_virtual", "1");
      var emount = $(e[i]).find("input[name='amount']");
      //  console.log(emount);
      emount.removeAttr("readonly");
    } else {
      var eesa = ees.getAttribute("data-is_virtual");
      if (parseInt(eesa) == 1) {
        // console.log(eesa);
        e[i].setAttribute("data-is_virtual", "1");
        var emount = $(e[i]).find("input[name='amount']");
        //  console.log(emount);
        emount.removeAttr("readonly");
      } else {
        var emount = $(e[i]).find("input[name='amount']");
        // console.log(emount);
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
    spn.setAttribute("style", "display:inline-grid");
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
    var btn5 = buttonCreator(
      "",
      "btn btn-outline-info",
      "onclick",
      "LoadTree(this)",
      "Pr"
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
    diva.appendChild(btn5);
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
    spn.setAttribute("style", "display:inline-grid");
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
  var prc = $("#maliyet").val();
  prc = filterNum(prc);
  /*
   <cfargument name="VP_ID">
    <cfargument name="PRICE" default="">
    <cfargument name="Discount" default="">
    <cfargument name="OtherMoney" default="">
    <cfargument name="DisplayName" default="">
    <cfargument name="ProductStage"default="" >
*/
  var BasketData = {
    PRODUCT_NAME: product_name,
    PRODUCT_ID: product_id,
    IS_VIRTUAL: is_virtual,
    PROJECT_ID: project_id,
    PRODUCT_STAGE: stg,
    PRODUCT_TREE: agacim,
    PRICE: prc,
    MONEY: "TL",
    DISCOUNT: 0,
    DISPLAY_NAME: "",
    AGAC: [],
    SEVIYE: 0,
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
  // console.log(e);
  var ev = e.getAttribute("data-idb");
  var question_id = e.getAttribute("data-question_id");
  var displayName = e.getAttribute("data-displayname");
  if (displayName == null) {
    displayName = "";
  }
  //console.log(ev);
  openBoxDraggable(
    "index.cfm?fuseaction=project.emptypopup_mini_tools&tool_type=alternativeQuestion&idb=" +
      ev +
      "&question_id=" +
      question_id +
      "&displayName=" +
      displayName
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
function setAQuestions2(idb, modalid) {
  var el = document.getElementByIdb(idb);
  var qqqs = document.getElementById("aquestion");
  var queid = qqqs.value;
  var QUESTION_NAME = qqqs.options[qqqs.selectedIndex].text;
  var ds = document.getElementById("displayName").value;
  el.setAttribute("data-question_id", queid);
  el.setAttribute("data-displayName", ds);
  var es = $(el).find("span[name='product_name_']")[0];
  var qnn = $(el).find("span[name='question_name_']")[0];
  var qnn2 = $(el).find("span[name='display_name_']")[0];
  $(qnn).remove();
  $(qnn2).remove();
  var span = document.createElement("span");
  span.innerText = "(" + QUESTION_NAME + ")";
  span.setAttribute("name", "question_name_");
  span.setAttribute("style", "color:var(--danger)");
  es.appendChild(span);
  var span = document.createElement("span");
  span.innerText = "(" + ds + ") ";
  span.setAttribute("style", "color:var(--success)");
  span.setAttribute("name", "display_name_");
  es.appendChild(span);
  closeBoxDraggable(modalid);
}

document.getElementByIdb = function (idb) {
  var str = idb.toString();
  var el = $("*").find("* [data-idb='" + str + "']")[0];
  return el;
};
function MaliyetHesapla2() {
  var Products = $("#ppidarea *li");
  var TTutar=0;
  Products.each(function (ix, Product) {
    var tutar = Product.getAttribute("data-netTotal");
    TTutar = TTutar + parseFloat(tutar);
    console.table({
      satir:1859,
      tutar:tutar,
      TTutar:TTutar
    });
  });
   TTutar = commaSplit(TTutar);
  $("#maliyet").val(TTutar);
}
function MaliyetHesapla() {
  var TotalPrice = 0;
  var Products = $("#ppidarea *li");
  Products.each(function (ix, Product) {
    // console.log(Product)
    //console.log($(Product).find("input[name='amount']"))
    var miktar = $(Product).find("input[name='amount']").val();
    $(Product)
      .find("input[name='amount']")
      .val(commaSplit(filterNum(miktar)));
    miktar = filterNum(miktar);
    //li.setAttribute("data-netTotal", 0);
    var price = Product.getAttribute("data-price");
    var tutar = Product.getAttribute("data-netTotal");
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
    Product.setAttribute("data-netTotal", Tprice); //DIKKAT BU METODA BAK
    //console.log(Tprice);
    TotalPrice += Tprice;
  });
  var Mn = commaSplit(TotalPrice);
  $("#maliyet").val(Mn);
}

function GercekKontrol(id) {
  var q = wrk_query(
    "SELECT IS_CONVERT_REAL FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=" +
      id,
    "dsn3"
  );
  if (q.recordcount > 0) {
    console.log(q.IS_CONVERT_REAL[0]);
    var ex = q.IS_CONVERT_REAL[0];
    ex = parseInt(ex);
    console.log(ex);
    if (ex == 1) {
      var b = document.getElementById("teklifButton");
      b.removeAttribute("class");
      b.setAttribute("class", "btn btn-outline-warning");
      b.innerText = "Teklife Dönüştü";
      b.setAttribute("disabled", "disabled");
      var c = document.getElementById("silButon");
      c.setAttribute("disabled", "disabled");
    } else {
      var b = document.getElementById("teklifButton");
      b.removeAttribute("class");
      b.setAttribute("class", "btn btn-outline-secondary");
      b.innerText = "Teklif Ver";
      b.removeAttribute("disabled");
      var c = document.getElementById("silButon");
      c.removeAttribute("disabled");
    }
    return ex;
  }
  return 0;
}

function updateStage(el, projectId) {
  console.log(arguments);
  var vp_id = document.getElementById("vp_id").value;

  if (parseInt(el.value) == 340) {
    var vq = wrk_query(
      "select COUNT(*) as SCOUNT from VIRTUAL_PRODUCTS_PRT where PROJECT_ID =" +
        projectId +
        " AND PRODUCT_STAGE=340",
      "dsn3"
    );
    if (vq.SCOUNT[0] > 0) {
      alert("Onaylanmış Ürünler Var");
      return false;
    }
  }
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=updateStage&vp_id=" +
      vp_id +
      "&psatge=" +
      el.value +
      "&ddsn3=workcube_metosan_1",
    success: function (retDat) {
      //  console.log(retDat);
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
      //  console.log(retDat);
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

function addToCurrentTree(vp_id, product_name) {
  // var e = ngetTree(vp_id, 1, "workcube_metosan_1", "", 3, "", "", ""); AddRowItemVirtual
  //AddRowItemVirtual(o.PRODUCT_ID,o.PRODUCT_NAME;
  AddRowItemVirtual(vp_id, product_name, "", 0, 0, 0, "TL", 0, 0, 0, 0);
}

function convertToOffer() {
  var Maliyet = document.getElementById("maliyet").value;
  var company_id = _compId;
  var price_catid = _priceCatId;
  var vp_id = document.getElementById("vp_id").value;
  var project_id = document.getElementById("project_id").value;
  Maliyet = filterNum(Maliyet);
  var q =
    "select PROJECT_NUMBER+'-'+PROJECT_HEAD as PROJECT_HEAD from workcube_metosan.PRO_PROJECTS where PROJECT_ID=" +
    project_id;
  var res = wrk_query(q, "dsn");
  var project_name = res.PROJECT_HEAD[0];
  var pro = $("#ppidarea *li");
  var ProductList = new Array();
  for (let i = 0; i < pro.length; i++) {
    var prod = pro[i];
    var productName = $(prod.firstChild)
      .find("span[name='product_name_']")
      .text();
    var amount = $(prod.firstChild.lastChild)
      .find("input[name='amount']")
      .val();
    var pid = prod.getAttribute("data-product_id");
    var isVirtual = prod.getAttribute("data-is_virtual");
    var price = prod.getAttribute("data-price");
    var money = prod.getAttribute("data-money");
    var discount = prod.getAttribute("data-discount");
    var sett = getsettingByName("is_show_tree").paramValue;

    var O = {
      product_id: pid,
      isVirtual: isVirtual,
      price: price,
      money: money,
      discount: discount,
      productName: productName,
      amount: amount,
    };
    ProductList.push(O);
    //console.log(O);
  }

  var BasketData = {
    Maliyet: Maliyet,
    company_id: company_id,
    price_catid: price_catid,
    vp_id: vp_id,
    project_id: project_id,
    project_name: project_name,
    stock_id: 0,
    is_show_tree: sett,
    ProductList: ProductList,
  };
  var mapForm = document.createElement("form");
  mapForm.target = "Map";
  mapForm.method = "POST"; // or "post" if appropriate
  mapForm.action =
    "/index.cfm?fuseaction=sales.list_pbs_offer&event=add&act=convert&is_from_project=1";

  var mapInput = document.createElement("input");
  mapInput.type = "hidden";
  mapInput.name = "data";
  mapInput.value = JSON.stringify(BasketData);
  mapForm.appendChild(mapInput);

  document.body.appendChild(mapForm);

  map = window.open(
    "/index.cfm?fuseaction=sales.list_pbs_offer&event=add&act=convert",
    "Map",
    "status=0,title=0,height=600,width=800,scrollbars=1"
  );

  if (map) {
    mapForm.submit();
  } else {
    alert("You must allow popups for this map to work.");
  }
}

function getsettingByName(settingName) {
  for (let i = 0; i < ProductDesingSetting.length; i++)
    if (ProductDesingSetting[i].paramName == settingName)
      return { paramValue: ProductDesingSetting[i].paramValue, indx: i };
}

function setSettings(el) {
  var paramName = el.getAttribute("data-paramName");
  var paramValue = el.getAttribute("data-paramValue");
  console.log(paramName, paramValue);
  var newParamValue = "OFF";
  paramValue == "OFF" ? (newParamValue = "ON") : (newParamValue = "OFF");
  console.log(newParamValue);
  el.setAttribute("data-paramValue", newParamValue);
  var ix = getsettingByName(paramName).indx;
  ProductDesingSetting[ix].paramValue = newParamValue;
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=updateSettings&paramName=" +
      paramName +
      "&paramValue=" +
      newParamValue +
      "&ddsn3=workcube_metosan_1",
    success: function (returnDat) {
      console.log(returnDat);
     // LoadSettings();
    },
  });
}
function remVirtualProd(el) {
  console.log(el);
  var vp_id = document.getElementById("vp_id").value;
  var is_virtual = document.getElementById("is_virtual").value;
  console.log(vp_id);
  if (parseInt(is_virtual) == 1) {
    document.getElementById("VP_" + vp_id).remove();
    $.ajax({
      url:
        "/AddOns/Partner/project/cfc/product_design.cfc?method=DELVP&vp_id=" +
        vp_id +
        "&ddsn3=workcube_metosan_1",
      success: function () {},
    });
  } else {
    alert("Gerçek Ürünü Silemezsiniz !");
  }
}
function remItem(params) {
  var e = params.parentElement.parentElement.parentElement;
  $(e).remove();
}

function OpenSearchVP(ppd = 0, tip = 4) {
  openBoxDraggable(
    "index.cfm?fuseaction=product.emptypopup_list_virtualproducts&idb=" +
      ppd +
      "&type=" +
      tip
  );
}

function SearchWpT() {
  var KeyWord_1 = document.getElementById("txtKeyword").value;
  var KeyWord_2 = document.getElementById("txtKeywordProject").value;
  var projectCatId = document.getElementById("PCAT").value;
  var tool_type = "ListVP";
  var type = document.getElementById("type").value;
  var idb = document.getElementById("idb").value;
  var posting = $.get(
    "/index.cfm?fuseaction=project.emptypopup_mini_tools&autoComplete=1",
    {
      KeyWord_1: KeyWord_1,
      KeyWord_2: KeyWord_2,
      projectCatId: projectCatId,
      tool_type: tool_type,
      type: type,
      idb: idb,
    }
  );
  posting.done(function (data) {
    $("#resultArea").html(data);
    $("#working_div_main").remove();
  });
}
var elek = null;
function LoadTree(el) {
  elek = el;
  var p =
    elek.parentElement.parentElement.parentElement.getAttribute("data-price");
  var sp ="0"
  var om =
    elek.parentElement.parentElement.parentElement.getAttribute(
      "data-other_money"
    );
  var d =
    elek.parentElement.parentElement.parentElement.getAttribute(
      "data-discount"
    );
  var pid =
    elek.parentElement.parentElement.parentElement.getAttribute(
      "data-product_id"
    );
  var sid =
    elek.parentElement.parentElement.parentElement.getAttribute(
      "data-stock_id"
    );
  var idb =
    elek.parentElement.parentElement.parentElement.getAttribute("data-idb");
  var miktar = filterNum(
    elek.parentElement.getElementsByTagName("input")[0].value
  );
  if (p.length > 0) p = parseFloat(p);
  else p = 0;
  if (sp.length > 0) sp = parseFloat(sp);
  else sp = 0;
  if (d.length > 0) d = parseFloat(d);
  else d = 0;
  if (pid.length > 0) pid = parseFloat(pid);
  else pid = 0;
  if (sid.length > 0 && isNumber(sid)) sid = parseFloat(sid);
  else sid = 0;
  if (om.length > 0) om = om;
  else om = "TL";
  var Obj = {
    Price: p,
    StandartPrice: sp,
    OtherMoney: om,
    Discount: d,
    Pid: pid,
    Sid: sid,
    moneyArr: moneyArr,
    idb: idb,
    miktar: miktar,
  };
  console.table(Obj);
  var Str = JSON.stringify(Obj);
  //tool_type eq 'ShowPrice
  openBoxDraggable(
    "index.cfm?fuseaction=project.emptypopup_mini_tools&autoComplete=1&tool_type=ShowPrice&Data=" +
      Str
  );
}

function fiyatHesaplaPoppi(ts) {
  if (ts == 0) {
    var p = document.getElementById("fy_0003").value;
    var d = document.getElementById("fdy_0001").value;
    var tt = parseFloat(p) + (parseFloat(p) * parseFloat(d)) / 100;
    document.getElementById("fy_0002").value = tt;
  } else {
    /*   var p = document.getElementById("fy_0003").value;
  var d = document.getElementById("fdy_0001").value;
  var tt = parseFloat(p) + (parseFloat(p) * parseFloat(d)) / 100;
 */
    var p = document.getElementById("fy_0001").value;
    var d = document.getElementById("fdy_0001").value;
    var tt = parseFloat(p) - (parseFloat(p) * parseFloat(d)) / 100;
    document.getElementById("fy_0003").value = tt;
    // document.getElementById("fy_0002").value = tt;
  }
}

function SetPrice(idb, modal_id) {
  //TEMIZLE BU TEMIZLENECEK
  var Oms = document.getElementById("fy_0001").value;
  var om = document.getElementById("Omfy_0001").value; //para birimi
  var p = document.getElementById("fy_0003").value;
  var d = document.getElementById("fdy_0001").value;

  document.getElementByIdb(idb).setAttribute("data-price", p);
  document.getElementByIdb(idb).setAttribute("data-discount", d);
  document.getElementByIdb(idb).setAttribute("data-other_money", om);
  document.getElementByIdb(idb).setAttribute("data-netTotal", p);
 // MaliyetHesapla();
 
  closeBoxDraggable(modal_id);
}
function SetPrice2(idb, modal_id) {
  //BILGI BURASI YENİ FİYAT POPUPUNA GÖRE DÜZENLENDİ
  document
    .getElementByIdb(idb)
    .setAttribute("data-price", SP_FIYAT_HESAP_SONUC.SP_Fiyat);
  document
    .getElementByIdb(idb)
    .setAttribute("data-discount", SP_FIYAT_HESAP_SONUC.SP_Discount);
  document
    .getElementByIdb(idb)
    .setAttribute("data-other_money", SP_FIYAT_HESAP_SONUC.SP_SelectedMoney);
  document
    .getElementByIdb(idb)
    .setAttribute("data-netTotal", SP_FIYAT_HESAP_SONUC.Sp_Tutar);

  document.getElementById("fiyatimis_"+idb).innerText=commaSplit(SP_FIYAT_HESAP_SONUC.SP_Fiyat)+" "+SP_FIYAT_HESAP_SONUC.SP_SelectedMoney
  console.log(SP_FIYAT_HESAP_SONUC);
  MaliyetHesapla2()
  closeBoxDraggable(modal_id);
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
