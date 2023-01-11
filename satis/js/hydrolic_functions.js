function openHydrolic(id = "", row_id = "", tr = 0) {
  var comp_id = document.getElementById("company_id").value;
  var price_catid = document.getElementById("PRICE_CATID").value;
  if (tr == 0) {
    openBoxDraggable(
      "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" +
        id +
        "&price_catid=" +
        price_catid +
        "&comp_id=" +
        comp_id +
        "&type=2&row_id=" +
        row_id
    );
  } else {
    openBoxDraggable(
      "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" +
        id +
        "&price_catid=" +
        price_catid +
        "&comp_id=" +
        comp_id +
        "&type=2&row_id=" +
        row_id
    );
  }
}

function findHydrolic(ev, el) {
  var keyword = el.value;
  var comp_id = document.getElementById("company_id").value;
  var price_catid = document.getElementById("PRICE_CATID").value;
  if (ev.keyCode == 13) {
    var Product = getProductMultiUse(keyword, comp_id, price_catid);
    if (Product.RECORDCOUNT != 0) {
      var rw = $("#tblBaskHyd")
        .find("input[value=" + Product.PRODUCT.PRODUCT_ID + "]")
        .parent()
        .parent();
      if (rw.length != 0) {
        if (generalParamsSatis.workingParams.IS_ADD_QUANTITY == 0) {
          addHydrolicRow(Product);
        } else {
          if (Product.PRODUCT.MAIN_UNIT == "Adet") {
            var iid = rw.attr("data-row");
            var e = rw.find("#quantity_" + iid).val();
            var ev = parseFloat(filterNum(e));
            ev++;
            rw.find("#quantity_" + iid).val(commaSplit(ev));
          } else {
            addHydrolicRow(Product);
          }
        }
      } else {
        addHydrolicRow(Product);
      }
      CalculatehydrolicRow(hydRowCount);
    }
    el.value = "";
    $(el).focus();
  }
}

function addHydrolicRow(Product, qty = 1) {
  console.log(Product);
  hydRowCount++;
  var Tbl = document.getElementById("tblBaskHyd");
  var tr = document.createElement("tr");
  tr.setAttribute("data-row", hydRowCount);
  tr.setAttribute("id", "hydRow" + hydRowCount);
  var td = document.createElement("td");
  var i = document.createElement("i");
  i.setAttribute("class", "icn-md icon-minus");
  i.setAttribute("onclick", "removeRow(this," + hydRowCount + ")");
  td.innerText = hydRowCount;
  tr.appendChild(td);

  var td = document.createElement("td");
  var input = document.createElement("input");
  input.setAttribute("type", "hidden");
  input.setAttribute("name", "product_id_" + hydRowCount);
  input.setAttribute("id", "product_id_" + hydRowCount);
  input.setAttribute("value", Product.PRODUCT.PRODUCT_ID);
  td.appendChild(input);
  /* var input = document.createElement("input")
     input.setAttribute("type", "hidden")
     input.setAttribute("name", "money_" + hydRowCount)
     input.setAttribute("id", "money_" + hydRowCount)
     input.setAttribute("value", Product.PRODUCT.MONEY)
     td.appendChild(input)*/

  var input = document.createElement("input");
  input.setAttribute("type", "hidden");
  input.setAttribute("name", "stock_id_" + hydRowCount);
  input.setAttribute("id", "stock_id_id_" + hydRowCount);
  input.setAttribute("value", Product.PRODUCT.STOCK_ID);
  td.appendChild(input);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");

  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("name", "product_name_" + hydRowCount);
  input.setAttribute("id", "product_name_" + hydRowCount);
  input.setAttribute("value", Product.PRODUCT.PRODUCT_NAME);
  input.setAttribute("readonly", "true");

  div.appendChild(input);

  td.appendChild(div);
  tr.appendChild(td);

  var div = document.createElement("div");
  div.setAttribute("class", "form-group");

  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var input = document.createElement("input");
  input.setAttribute("type", "text");
  input.setAttribute("name", "quantity_" + hydRowCount);
  input.setAttribute("id", "quantity_" + hydRowCount);
  input.setAttribute("value", commaSplit(qty));
  input.setAttribute("class", "prtMoneyBox");
  input.setAttribute("onchange", "CalculatehydrolicRow(" + hydRowCount + ")");
  input.setAttribute("onClick", "sellinputAllVal(this)");
  div.appendChild(input);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:15%");
  var input = document.createElement("input");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  input.setAttribute("type", "text");
  input.setAttribute("name", "price_" + hydRowCount);
  input.setAttribute("class", "prtMoneyBox");
  input.setAttribute("id", "price_" + hydRowCount);
  input.setAttribute("onchange", "CalculatehydrolicRow(" + hydRowCount + ")");
  input.setAttribute("onclick", "sellinputAllVal(this)");
  input.setAttribute("value", commaSplit(Product.PRODUCT.PRICE));
  div.appendChild(input);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  var input2 = document.createElement("input");
  input2.setAttribute("type", "text");
  input2.setAttribute("name", "discount_" + hydRowCount);
  input2.setAttribute("id", "discount_" + hydRowCount);
  input2.setAttribute("value", commaSplit(Product.PRODUCT.DISCOUNT_RATE));
  input2.setAttribute("class", "prtMoneyBox");
  input2.setAttribute("onchange", "CalculatehydrolicRow(" + hydRowCount + ")");
  div.appendChild(input2);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:10%");
  var input = document.createElement("input");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  input.setAttribute("type", "text");
  input.setAttribute("readonly", "true");
  input.setAttribute("class", "prtMoneyBox");
  input.setAttribute("name", "money_" + hydRowCount);
  input.setAttribute("id", "money_" + hydRowCount);
  input.setAttribute("value", Product.PRODUCT.MONEY);
  div.appendChild(input);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:17%");
  var input = document.createElement("input");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  input.setAttribute("type", "text");
  input.setAttribute("readonly", "true");
  input.setAttribute("name", "netTDv_" + hydRowCount);
  input.setAttribute("id", "netTDv_" + hydRowCount);
  input.setAttribute("class", "prtMoneyBox");
  input.setAttribute("value", Product.PRODUCT.PRICE);
  div.appendChild(input);
  td.appendChild(div);
  tr.appendChild(td);

  var td = document.createElement("td");
  td.setAttribute("style", "width:17%");
  var input = document.createElement("input");
  var div = document.createElement("div");
  div.setAttribute("class", "form-group");
  input.setAttribute("type", "text");
  input.setAttribute("readonly", "true");
  input.setAttribute("name", "netT_" + hydRowCount);
  input.setAttribute("id", "netT_" + hydRowCount);
  input.setAttribute("class", "prtMoneyBox");
  input.setAttribute("value", Product.PRODUCT.PRICE);
  div.appendChild(input);
  td.appendChild(div);
  tr.appendChild(td);

  Tbl.appendChild(tr);
  CalculatehydrolicRow(hydRowCount);
}

function saveVirtualHydrolic(modal_id) {
  var pname = SetName(2); //prompt("Ürün Adı");
  $("#hydRwc").val(hydRowCount);
  $("#hydProductName").val(pname);
  var formData = getFormData($("#HydrolicForm"));
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hydrolic_functions.cfc?method=saveVirtualHydrolic",
    data: formData,
    success: function (retDat) {
      var obj = JSON.parse(retDat);
      //  AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, 2, '', 'TL', obj.PRICE);

      AddRow(
        obj.PID,
        0,
        "",
        "",
        1,
        1,
        obj.PRICE,
        obj.NAME,
        18,
        0,
        2,
        "",
        "TL",
        obj.PRICE,
        "-5",
        0,
        0,
        "Adet",
        "",
        "",
        1,
        "",
        "",
        1
      );

      closeBoxDraggable(modal_id);
    },
  });
}

function UpdateVirtualHydrolic(modal_id) {
  $("#hydRwc").val(hydRowCount);

  var formData = getFormData($("#HydrolicForm"));
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hydrolic_functions.cfc?method=updateVirtualHydrolic",
    data: formData,
    success: function (retDat) {
      var obj = JSON.parse(retDat);
      UpdRow(obj.PID, "", 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
      closeBoxDraggable(modal_id);
    },
  });
}

function saveRealHydrolic(modal_id) {
  $("#hydRwc").val(hydRowCount);

  var formData = getFormData($("#HydrolicForm"));
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hydrolic_functions.cfc?method=SaveRealHydrolic",
    data: formData,
    success: function (retDat) {
      var obj = JSON.parse(retDat);
     console.log(obj);
      if (obj.ROW_ID.length > 0) {
        UpdRow(
            obj.PRODUCT_ID,
            obj.STOCK_ID,
            0,
            1,
            obj.PRICE,
            obj.PRODUCT_NAME,
            18,
            0,
            obj.ROW_ID,
            obj.OFFER_ROW_CURRENCY,
            obj.STOCK_CODE,
            obj.MAIN_UNIT
          );
      } else {
        AddRow(
            obj.PRODUCT_ID,
            obj.STOCK_ID,
            obj.STOCK_CODE,
            obj.BRAND_NAME,
            0,
            obj.QUANTITY,
            obj.PRICE,
            obj.PRODUCT_NAME,
            obj.TAX,
            obj.DISCOUNT_RATE,
            obj.PRODUCT_TYPE,
            obj.SHELF_CODE,
            obj.OTHER_MONEY,
            obj.PRICE_OTHER,
            obj.OFFER_ROW_CURRENCY,
            obj.IS_MANUEL,
            obj.COST,
            obj.MAIN_UNIT,
            obj.PRODUCT_NAME_OTHER,
            obj.DETAIL_INFO_EXTRA,
            obj.FC,
            obj.ROW_NUM,
            obj.DELIVERDATE,
            obj.IS_PRODUCTION,
            obj.ROW_UNIQ_ID
          );
      }
     // closeBoxDraggable(modal_id);
    },
  });
}

function getFormData($form) {
  var unindexed_array = $form.serializeArray();
  var indexed_array = {};

  $.map(unindexed_array, function (n, i) {
    indexed_array[n["name"]] = n["value"];
  });

  return indexed_array;
}

function CalculatehydrolicRow(rw_id) {
  var dovv_ = $("input[name=_rd_money]:checked").val();
  var dow = document.getElementById("_hidden_rd_money_" + dovv_).value;
  /* var rate2 = filterNum($("#_txt_rate2_" + dovv_).val(), 4)*/
  var rate2 = moneyArr.find((p) => p.MONEY == dow).RATE2;
  console.log("RATE2=" + parseFloat(rate2));

  //var qty = document.getElementById("quantity_" + rw_id).value;
  var qty = $("#tblBaskHyd")
    .find("#quantity_" + rw_id)
    .val();
  qty = parseFloat(filterNum(commaSplit(qty)));

  //var prc = document.getElementById("price_" + rw_id).value;
  var prc = $("#tblBaskHyd")
    .find("#price_" + rw_id)
    .val();
  prc = parseFloat(filterNum(commaSplit(prc)));

  var dsc = $("#tblBaskHyd")
    .find("#discount_" + rw_id)
    .val();
  dsc = parseFloat(filterNum(commaSplit(dsc)));

  //var mny = document.getElementById("money_" + rw_id).value;
  var mny = $("#tblBaskHyd")
    .find("#money_" + rw_id)
    .val();
  var a = moneyArr.filter((p) => p.MONEY == mny);

  var rt_2 = a[0].RATE2;

  var netPrc = TutarHesapla(prc, qty, dsc, rt_2); //(qty * prc)*parseFloat(a[0].RATE2);
  var netPrcDV = TutarHesapla(prc, qty, dsc, 1);
  //document.getElementById("quantity_" + rw_id).value = commaSplit(filterNum(qty))
  $("#tblBaskHyd")
    .find("#quantity_" + rw_id)
    .val(commaSplit(qty));
  //document.getElementById("price_" + rw_id).value = commaSplit(filterNum(prc))
  $("#tblBaskHyd")
    .find("#price_" + rw_id)
    .val(commaSplit(prc));
  console.log(netPrc);

  document.getElementById("netT_" + rw_id).value = commaSplit(netPrc);
  document.getElementById("netTDv_" + rw_id).value = commaSplit(netPrcDV);
  CalculateHydSub();
}

function CalculateHydSub() {
  var total = 0;
  var marj = document.getElementById("marjHyd").value;
  document.getElementById("marjHyd").value = commaSplit(marj);
  marj = filterNum(marj);
  marj = parseFloat(marj);
  for (let i = 1; i <= hydRowCount; i++) {
    var netT = document.getElementById("netT_" + i).value;
    var mny = document.getElementById("money_" + i).value;
    var a = moneyArr.filter((p) => p.MONEY == mny);
    total = total + parseFloat(filterNum(netT)) * 1;
  }
  total = total + (total * marj) / 100;
  $("#hydSubTotal").val(commaSplit(total));
}

function TutarHesapla(price, quantity, discount, rate2) {
  var return_value = price * quantity;
  return_value = return_value - (return_value * discount) / 100;
  return_value = return_value * rate2;
  return return_value;
}
