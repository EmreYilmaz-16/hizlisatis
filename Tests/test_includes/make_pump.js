﻿var pupRowC = 0;
var ArrForPum = [];
var GirenArr = [];
var CikanArr = [];
var BozulacakArr = [];
var OlusacakUrun = {
  PRODUCT_ID: 0,
  STOCK_ID: 0,
  PRODUCT_NAME: "",
  PRODUCT_CODE: "",
  QUANTITY: 0,
  IS_VIRTUAL: 0,
  DESCRIPTION: "",
};

function AddArrItem(
  ArrNum,
  PRODUCT_ID,
  PRODUCT_NAME,
  PRODUCT_CODE,
  STOCK_ID,
  QUANTITY = 1,
  DESCRIPTION = "",
  IS_VIRTUAL = 0
) {
  var Obj = {
    PRODUCT_ID: PRODUCT_ID,
    STOCK_ID: STOCK_ID,
    PRODUCT_NAME: PRODUCT_NAME,
    PRODUCT_CODE: PRODUCT_CODE,
    QUANTITY: QUANTITY,
    IS_VIRTUAL: IS_VIRTUAL,
    DESCRIPTION: DESCRIPTION,
  };
  if (ArrNum == 0) {
    OlusacakUrun = Obj;
  } else if (ArrNum == 1) {
    var ix = BozulacakArr.findIndex((p) => p.PRODUCT_ID == PRODUCT_ID);
    if (ix == -1) BozulacakArr.push(Obj);
  } else if (ArrNum == 2) {
    var ix = GirenArr.findIndex((p) => p.PRODUCT_ID == PRODUCT_ID);
    if (ix == -1) GirenArr.push(Obj);
  } else if (ArrNum == 3) {
    var ix = CikanArr.findIndex((p) => p.PRODUCT_ID == PRODUCT_ID);
    if (ix == -1) CikanArr.push(Obj);
  }

  SatirlariYaz_2(ArrNum);
}
function SatirlariYaz_2(arb) {
  var tbody = document.createElement("tbody");
  tbody.setAttribute("id", "tbod_" + arb);
  if (arb == 0) {
    document
      .getElementById("NamePumpa")
      .setAttribute("value", OlusacakUrun.PRODUCT_NAME);
    document
      .getElementById("pidPumpa")
      .setAttribute("value", OlusacakUrun.PRODUCT_ID);
    document
      .getElementById("SidPumpa")
      .setAttribute("value", OlusacakUrun.STOCK_ID);
    document
      .getElementById("isVirtualPumpa")
      .setAttribute("value", OlusacakUrun.IS_VIRTUAL);
    document
      .getElementById("AciklamaPUMPA")
      .setAttribute("value", OlusacakUrun.DESCRIPTION);
  } else if (arb == 1) {
    for (let i = 0; i < BozulacakArr.length; i++) {
      var tr = document.createElement("tr");
      tr.setAttribute("data-pid", BozulacakArr[i].PRODUCT_ID);
      tr.setAttribute("data-sid", BozulacakArr[i].STOCK_ID);
      tr.setAttribute("data-ix", i);
      var td = document.createElement("td");
      td.innerText = BozulacakArr[i].PRODUCT_CODE;
      tr.appendChild(td);
      var td = document.createElement("td");
      td.innerText = BozulacakArr[i].PRODUCT_NAME;
      tr.appendChild(td);
      var td = document.createElement("td");
      var input = document.createElement("input");
      input.setAttribute("type", "text");
      input.setAttribute("onchange", "ChangeRowQ(" + i + ",this)");
      input.setAttribute("value", BozulacakArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
  } else if (arb == 2) {
    for (let i = 0; i < GirenArr.length; i++) {
      var tr = document.createElement("tr");
      tr.setAttribute("data-pid", GirenArr[i].PRODUCT_ID);
      tr.setAttribute("data-sid", GirenArr[i].STOCK_ID);
      tr.setAttribute("data-ix", i);
      var td = document.createElement("td");
      td.innerText = GirenArr[i].PRODUCT_CODE;
      tr.appendChild(td);
      var td = document.createElement("td");
      td.innerText = GirenArr[i].PRODUCT_NAME;
      tr.appendChild(td);
      var td = document.createElement("td");
      var input = document.createElement("input");
      input.setAttribute("type", "text");
      input.setAttribute("onchange", "ChangeRowQ(" + i + ",this)");
      input.setAttribute("value", GirenArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
  } else if (arb == 3) {
    for (let i = 0; i < CikanArr.length; i++) {
      var tr = document.createElement("tr");
      tr.setAttribute("data-pid", CikanArr[i].PRODUCT_ID);
      tr.setAttribute("data-sid", CikanArr[i].STOCK_ID);
      tr.setAttribute("data-ix", i);
      var td = document.createElement("td");
      td.innerText = CikanArr[i].PRODUCT_CODE;
      tr.appendChild(td);
      var td = document.createElement("td");
      td.innerText = CikanArr[i].PRODUCT_NAME;
      tr.appendChild(td);
      var td = document.createElement("td");
      var input = document.createElement("input");
      input.setAttribute("type", "text");
      input.setAttribute("onchange", "ChangeRowQ(" + i + ",this)");
      input.setAttribute("value", CikanArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
  }
  $("#tbod_" + arb).remove();
  document.getElementById("tbl_" + arb).appendChild(tbody);
}
function OpenBasketProducts(
  ArrNum,
  question_id,
  from_row = 0,
  col = "",
  actType = "4",
  SIPARIS_MIKTARI = 1
) {
  var cp_id = document.getElementById("company_id").value;
  var cp_name = document.getElementById("company_id").value;

  var p_cat = document.getElementById("PRICE_CATID").value;
  var p_cat_id = document.getElementById("PRICE_CATID").value;
  openBoxDraggable(
    "http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=" +
      p_cat +
      "&PRICE_CATID=" +
      p_cat_id +
      "&company_id=" +
      cp_id +
      "&company_name=" +
      cp_name +
      "&question_id=" +
      question_id +
      "&columnsa=" +
      col +
      "&actType=" +
      actType +
      "&SIPARIS_MIKTARI=" +
      SIPARIS_MIKTARI +
      "&arrayid=" +
      ArrNum
  );
}

function AddVpIS() {}

function ChangeDesc(el) {
  OlusacakUrun.DESCRIPTION = el.value;
}
