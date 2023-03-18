var pupRowC = 0;
var ArrForPum = [];
var GirenArr = [];
var CikanArr = [];
var BozulacakArr = [];
var OlusacakUrun;

function AddArrItem(
  ArrNum,
  PRODUCT_ID,
  PRODUCT_NAME,
  PRODUCT_CODE,
  STOCK_ID,
  QUANTITY = 1
) {
  var Obj = {
    PRODUCT_ID: PRODUCT_ID,
    STOCK_ID: STOCK_ID,
    PRODUCT_NAME: PRODUCT_NAME,
    PRODUCT_CODE: PRODUCT_CODE,
    QUANTITY: QUANTITY,
  };
  if (ArrNum == 1) {
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

  if (arb == 1) {
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

function addProdToArr(
  PRODUCT_ID,
  PRODUCT_NAME,
  PRODUCT_CODE,
  STOCK_ID,
  IN_OUT,
  QUANTITY = 1
) {
  var Obj = {
    PRODUCT_ID: PRODUCT_ID,
    STOCK_ID: STOCK_ID,
    PRODUCT_NAME: PRODUCT_NAME,
    PRODUCT_CODE: PRODUCT_CODE,
    IN_OUT: IN_OUT,
    QUANTITY: QUANTITY,
  };
  var ix = ArrForPum.findIndex((p) => p.PRODUCT_ID == PRODUCT_ID);
  if (ix == -1) {
    ArrForPum.push(Obj);
  } else {
    ArrForPum[ix] = Obj;
  }

  SatirlariYaz();
}

function SatirlariYaz() {
  $("#tb1").remove();
  var tbody = document.createElement("tbody");
  tbody.setAttribute("id", "tb1");
  var tbl = document.getElementById("pump_basket");
  for (let i = 0; i < ArrForPum.length; i++) {
    var tr = document.createElement("tr");
    tr.setAttribute("data-pid", ArrForPum[i].PRODUCT_ID);
    tr.setAttribute("data-sid", ArrForPum[i].STOCK_ID);
    tr.setAttribute("data-inout", ArrForPum[i].IN_OUT);
    tr.setAttribute("data-ix", i);
    var td = document.createElement("td");
    td.innerText = ArrForPum[i].PRODUCT_CODE;
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = ArrForPum[i].PRODUCT_NAME;
    tr.appendChild(td);
    var td = document.createElement("td");
    var input = document.createElement("input");
    input.setAttribute("type", "text");
    input.setAttribute("onchange", "ChangeRowQ(" + i + ",this)");
    input.setAttribute("value", ArrForPum[i].QUANTITY);
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(input);
    td.appendChild(div);
    tr.appendChild(td);
    var td = document.createElement("td");
    var btn = document.createElement("button");
    btn.setAttribute("type", "button");
    if (ArrForPum[i].IN_OUT == -1) {
      btn.setAttribute("class", "btn btn-danger");
      btn.innerText = "-";
    } else {
      btn.setAttribute("class", "btn btn-success");
      btn.innerText = "+";
    }

    btn.setAttribute("onclick", "changeRowIO(" + i + ",this)");
    td.appendChild(btn);
    tr.appendChild(td);
    tbody.appendChild(tr);
  }
  tbl.appendChild(tbody);
}

function changeRowIO(ix, el) {
  ArrForPum[ix].IN_OUT = ArrForPum[ix].IN_OUT * -1;
  SatirlariYaz();
}

function ChangeRowQ(ix, el) {
  ArrForPum[ix].QUANTITY = el.value;
  SatirlariYaz();
}

function silPumpRow(ix) {
  ArrForPum.splice(ix, 1);
}

function AddOlusacak() {}

function AddBozulacak() {}

function AddPumpaVirtual() {}
