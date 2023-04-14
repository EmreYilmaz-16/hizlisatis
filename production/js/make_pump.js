var pupRowC = 0;

function AddArrItem(
  ArrNum,
  PRODUCT_ID,
  PRODUCT_NAME,
  PRODUCT_CODE,
  STOCK_ID,
  QUANTITY = 1,
  DESCRIPTION = "",
  IS_VIRTUAL = 0,
  PRICE = 0,
  DISCOUNT = 0,
  MONEY = "TL",
  COST = 0,
  PRICE_OTHER = 0,
  IS_MANUEL = 0
) {
  var Obj = {
    PRODUCT_ID: PRODUCT_ID,
    STOCK_ID: STOCK_ID,
    PRODUCT_NAME: PRODUCT_NAME,
    PRODUCT_CODE: PRODUCT_CODE,
    QUANTITY: QUANTITY,
    IS_VIRTUAL: IS_VIRTUAL,
    DESCRIPTION: DESCRIPTION,
    PRICE: PRICE,
    DISCOUNT: DISCOUNT,
    MONEY: MONEY,
    COST: COST,
    PRICE_OTHER: PRICE_OTHER,
    IS_MANUEL: IS_MANUEL,
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
  IsTreeUpdated = true;
  SatirlariYaz_2(ArrNum);
}
function SatirlariYaz_2(arb) {
  console.log(arb);
  var tbody = document.createElement("tbody");
  tbody.setAttribute("id", "tbod_" + arb);
  if (arb == 0) {
    document
      .getElementById("NamePumpa")
      .setAttribute("value", OlusacakUrun.PRODUCT_NAME);
    $("#NamePumpa").val(OlusacakUrun.PRODUCT_NAME);
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
    document
      .getElementById("PricePumpa")
      .setAttribute("value", OlusacakUrun.PRICE);
    document
      .getElementById("DiscountPumpa")
      .setAttribute("value", OlusacakUrun.DISCOUNT);

    if (parseInt(OlusacakUrun.PRODUCT_ID) != 0) {
      document.getElementById("NamePumpa").setAttribute("readonly", "true");
    }
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
      input.setAttribute("onchange", "ChangeRowQ(" + arb + "," + i + ",this)");
      input.setAttribute("value", BozulacakArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", BozulacakArr[i].PRICE);
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", BozulacakArr[i].DISCOUNT);
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
    $("#tbod_" + arb).remove();
    document.getElementById("tbl_" + arb).appendChild(tbody);
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
      input.setAttribute("onchange", "ChangeRowQ(" + arb + "," + i + ",this)");
      input.setAttribute("value", GirenArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", GirenArr[i].PRICE);
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", GirenArr[i].DISCOUNT);
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
    $("#tbod_" + arb).remove();
    document.getElementById("tbl_" + arb).appendChild(tbody);
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
      input.setAttribute("onchange", "ChangeRowQ(" + arb + "," + i + ",this)");
      input.setAttribute("value", CikanArr[i].QUANTITY);
      var div = document.createElement("div");
      div.setAttribute("class", "form-group");
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", CikanArr[i].PRICE);
      div.appendChild(input);
      var input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("value", CikanArr[i].DISCOUNT);
      div.appendChild(input);
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
    }
    $("#tbod_" + arb).remove();
    document.getElementById("tbl_" + arb).appendChild(tbody);
  }
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

function ChangeDesc(el) {
  OlusacakUrun.DESCRIPTION = el.value;
}

function ParaHesapla() {
  var TotalPrice = 0;
  var str =
    '[{"MONEY":"TL","RATE1":"1","RATE2":"1"},{"MONEY":"USD","RATE1":"1","RATE2":"19.0412"},{"MONEY":"EUR","RATE1":"1","RATE2":"20.2745"}]';
  var MoneyArr = JSON.parse(str);
  for (let i = 0; i < BozulacakArr.length; i++) {
    var Q = BozulacakArr[i].QUANTITY;
    var P = BozulacakArr[i].PRICE;
    var M = BozulacakArr[i].MONEY;
    var D = BozulacakArr[i].DISCOUNT;
    var R2 = MoneyArr.find((p) => p.MONEY == M).RATE2;

    var ix = Q * P;
    ix = ix * R2;
    ix = ix - (ix * D) / 100;
    //ix=Math.round(ix,2)
    ix = parseFloat(filterNum(commaSplit(ix, 2)));
    TotalPrice += ix;
    console.log(ix);
  }

  console.log(TotalPrice);

  for (let i = 0; i < CikanArr.length; i++) {
    var Q = CikanArr[i].QUANTITY;
    var P = CikanArr[i].PRICE;
    var M = CikanArr[i].MONEY;
    var D = CikanArr[i].DISCOUNT;
    var R2 = MoneyArr.find((p) => p.MONEY == M).RATE2;

    var ix = Q * P;
    ix = ix * R2;
    ix = ix - (ix * D) / 100;
    //ix=Math.round(ix,2)
    ix = parseFloat(filterNum(commaSplit(ix, 2)));
    TotalPrice += ix;
    console.log(ix);
  }

  console.log(TotalPrice);

  for (let i = 0; i < GirenArr.length; i++) {
    var Q = GirenArr[i].QUANTITY;
    var P = GirenArr[i].PRICE;
    var M = GirenArr[i].MONEY;
    var D = GirenArr[i].DISCOUNT;
    var R2 = MoneyArr.find((p) => p.MONEY == M).RATE2;

    var ix = Q * P;
    ix = ix * R2;
    ix = ix - (ix * D) / 100;
    //ix=Math.round(ix,2)
    ix = parseFloat(filterNum(commaSplit(ix, 2)));
    TotalPrice -= ix;
    console.log(ix);
  }

  console.log(TotalPrice);
  TotalPrice = parseFloat(filterNum(commaSplit(TotalPrice, 2)));
  return TotalPrice;
}

function SaveForPump() {
  var ix = $("#is_rotation").val();
  var cx = $("#Pumpa_cat").val();
  if (cx.length == 0) {
    alert("Kategori Seçiniz");
    return false;
  }
  if (OlusacakUrun.IS_VIRTUAL == 1) {
    var tp = ParaHesapla();
    OlusacakUrun.PRICE = tp;
  }

  var company_id = document.getElementById("company_id").value;
  var price_catid = document.getElementById("PRICE_CATID").value;
  var virman_id = document.getElementById("virman_id").value;
  var offer_data = {
    comp_id: company_id,
    price_catid: price_catid,
  };
  var ReturnObject = {
    OlusacakUrun: OlusacakUrun,
    BozulacakUrunler: BozulacakArr,
    GirenUrunler: GirenArr,
    CikanUrunler: CikanArr,
    Offer_data: offer_data,
    IsRotate: ix,
    HIERARCHY: cx,
    dataSources: generalParamsSatis.dataSources,
    BozulacakUrunlerArrLen: BozulacakArr.length,
    GirenUrunlerArrLen: GirenArr.length,
    CikanUrunlerArrLen: CikanArr.length,
    virman_id: virman_id,
  };
  if (parseInt(ix) == 1) {
    var xx = YonKontrol();
  } else {
    var xx = true;
  }
  console.log(ReturnObject);

  if (xx) {
    $.ajax({
      url: "/AddOns/Partner/satis/cfc/pump_functions.cfc?method=UpdatePumpa",
      data: "&FORM_DATA=" + JSON.stringify(ReturnObject),
      success: function (returnData) {
        IsTreeUpdated = false;
      },
    });
  }
}

function changeRotation(ela, tt = 0) {
  var ix = $("#is_rotation").val();
  var el=document.getElementById("btnRotate")
  console.log(ix);
  if (parseInt(ix) == 0) {
    if (tt != 1) {
      $("#is_rotation").val(1);
    }
    // document.getElementById("r").setAttribute("class","btn btn-success") .removeAttribute("class")
    el.removeAttribute("class");
    el.setAttribute("class", "btn btn-success");
  } else {
    if (tt != 1) {
      $("#is_rotation").val(0);
    }
    el.removeAttribute("class");
    el.setAttribute("class", "btn btn-secondary");
  }
}
function Temizle() {
  document.getElementById("NamePumpa").value = "";
  document.getElementById("NamePumpa").removeAttribute("readonly");
  /*document.getElementById("pidPumpa")=0
  document.getElementById("SidPumpa")=0
  document.getElementById("isVirtualPumpa")=0
  document.getElementById("PricePumpa")=0
  document.getElementById("DiscountPumpa")=0
  document.getElementById("is_rotation")=0*/
  OlusacakUrun = {
    PRODUCT_ID: 0,
    STOCK_ID: 0,
    PRODUCT_NAME: "",
    PRODUCT_CODE: "",
    QUANTITY: 0,
    IS_VIRTUAL: 1,
    DESCRIPTION: "",
    PRICE: 0,
    DISCOUNT: 0,
    MONEY: "TL",
  };
  SatirlariYaz_2(0);
}

function SetUrunAdi(el) {
  OlusacakUrun.PRODUCT_NAME = el.value;
  SatirlariYaz_2(0);
}

function YonKontrol() {
  var b = BozulacakArr.length;
  var hata = false;
  if (b == 0 || b > 1) {
    alert("Yön Değiştirirken Bozulacak Üründe 1 Adet Ürün Olmalı !");
    hata = true;
  }
  if (OlusacakUrun.IS_VIRTUAL == 1) {
    alert("Yön Değiştirmede Sanal Ürün Kullanamazsınız !");
    hata = true;
  }
  if (hata) {
    return false;
  } else {
    return true;
  }
}
function ChangeRowQ(arr, ix, el) {
  if (arr == 1) {
    BozulacakArr[ix].QUANTITY = parseFloat(el.value);
  }
  if (arr == 2) {
    GirenArr[ix].QUANTITY = parseFloat(el.value);
  }
  if (arr == 3) {
    CikanArr[ix].QUANTITY = parseFloat(el.value);
  }
}

$(document).ready(function () {
  SatirlariYaz_2(0);
  SatirlariYaz_2(1);
  SatirlariYaz_2(2);
  SatirlariYaz_2(3);
  changeRotation(document.getElementById("btnRotate"),1)
});
