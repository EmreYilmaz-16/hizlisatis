var cols = new Array();

$(document).ready(function () {
  var q = "SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=31";
  var res = wrk_query(q, "dsn3");
  console.log(res);
  addCol(res.STOCK_ID[0], res.QUANTITY[0], 1, 1);
});

function addCol(STOCK_ID, MIKTAR, isIo = 0, isMain = 0) {
  var ss =
    "SELECT S.STOCK_ID,S.PRODUCT_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,PU.MAIN_UNIT," +
    MIKTAR +
    "AS SIPARIS_MIKTARI, ";
  ss +=
    "ISNULL((SELECT SUM(STOCK_IN-STOCK_OUT) FROM " +
    generalParamsSatis.dataSources.dsn2 +
    ".STOCKS_ROW WHERE STOCK_ID=S.STOCK_ID AND STORE=45),0) AS BAKIYE";
  ss +=
    " FROM STOCKS AS S LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID WHERE S.PRODUCT_ID=" +
    STOCK_ID;
  var mainStok = wrk_query(ss, "dsn3");
  console.log(mainStok);
  var tree =
    "SELECT S.PRODUCT_CODE,S.PRODUCT_NAME,PT.AMOUNT,S.STOCK_ID,S.PRODUCT_ID,PU.MAIN_UNIT ";
  tree +=
    " ,ISNULL((SELECT SUM(STOCK_IN-STOCK_OUT) FROM " +
    generalParamsSatis.dataSources.dsn2 +
    ".STOCKS_ROW WHERE STOCK_ID=S.STOCK_ID AND STORE=45),0) AS BAKIYE";
  tree += " FROM PRODUCT_TREE AS PT ";
  tree += "LEFT JOIN STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID ";
  tree += "LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID ";
  tree +=
    "WHERE PT.STOCK_ID= (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID=" +
    STOCK_ID +
    ")";
  var treeRes = wrk_query(tree, "dsn3");
  var obj = {
    STOCK_ID: mainStok.STOCK_ID[0],
    PRODUCT_ID: mainStok.PRODUCT_ID[0],
    PRODUCT_CODE: mainStok.PRODUCT_CODE[0],
    PRODUCT_NAME: mainStok.PRODUCT_NAME[0],
    MAIN_UNIT: mainStok.MAIN_UNIT[0],
    BAKIYE: mainStok.BAKIYE[0],
    SIPARIS_MIKTARI: mainStok.SIPARIS_MIKTARI[0],
    isIo: isIo,
    IsMain: isMain,
    AgacRc: treeRes.recordcount,
    saveTree: 0,
    AGAC: [],
  };
  var col = new Array();
  if (treeRes.recordcount) {
    for (let i = 0; i < treeRes.recordcount; i++) {
      var agac = {
        PRODUCT_CODE: treeRes.PRODUCT_CODE[i],
        PRODUCT_NAME: treeRes.PRODUCT_NAME[i],
        AMOUNT: treeRes.AMOUNT[i],
        STOCK_ID: treeRes.STOCK_ID[i],
        PRODUCT_ID: treeRes.PRODUCT_ID[i],
        MAIN_UNIT: treeRes.MAIN_UNIT[i],
        BAKIYE: treeRes.BAKIYE[i],
        isIo: -1 * isIo,
      };
      obj.AGAC.push(agac);
    }
  }
  cols.push(obj);
  writeCols();
}
function writeCols() {
  var dv = document.getElementById("SepetDiv");
  dv.innerHTML = "";

  for (let i = 0; i < cols.length; i++) {
    var item = cols[i];
    var tree = cols[i].AGAC;
    var div_2 = document.createElement("div");
    div_2.setAttribute("class", "col");
    var table = document.createElement("table");

    table.setAttribute("border", 1);
    table.setAttribute("class", "table column_" + i);
    table.setAttribute("style", "border-spacing:0");
    TblListener(table, i);
    var tr = document.createElement("tr");
    var td = document.createElement("th");
    td.innerText = "Ürün Adı";
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = item.PRODUCT_NAME;
    tr.appendChild(td);
    var td = document.createElement("td");
    td.setAttribute("rowspan", 4);
    td.setAttribute("style", "text-align:center");
    var btn = document.createElement("button");
    btn.setAttribute("class", "btn btn-primary");
    btn.innerText = "0";
    btn.setAttribute("onclick", "SetIo(" + i + ",-1,this)");
    if (item.isIo == 0) {
      btn.setAttribute("class", "btn btn-primary");
      btn.innerText = "0";
    } else if (item.isIo == 1) {
      btn.setAttribute("class", "btn btn-success");
      btn.innerText = "+";
    } else {
      btn.setAttribute("class", "btn btn-danger");
      btn.innerText = "-";
    }
    td.appendChild(btn);
    tr.appendChild(td);
    table.appendChild(tr);
    var tr = document.createElement("tr");
    var td = document.createElement("th");
    td.innerText = "Ürün Kodu";
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = item.PRODUCT_CODE;
    tr.appendChild(td);
    table.appendChild(tr);
    var tr = document.createElement("tr");
    var td = document.createElement("th");
    td.innerText = "Sipariş Miktarı";
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = commaSplit(item.SIPARIS_MIKTARI);
    tr.appendChild(td);
    table.appendChild(tr);

    var tr = document.createElement("tr");
    var td = document.createElement("th");
    td.innerText = "Bakiye";
    tr.appendChild(td);
    var td = document.createElement("td");
    td.innerText = commaSplit(item.BAKIYE);
    tr.appendChild(td);
    table.appendChild(tr);

    var tr = document.createElement("tr");
    var td = document.createElement("td");
    td.setAttribute("colspan", 3);
    var table_2 = document.createElement("table");
    var tr_2 = document.createElement("tr");
    var td_2 = document.createElement("th");
    td_2.innerText = "Ürün";
    tr_2.appendChild(td_2);
    var td_2 = document.createElement("th");
    td_2.innerText = "Miktar";
    tr_2.appendChild(td_2);
    var td_2 = document.createElement("th");
    td_2.innerText = "Depo";
    tr_2.appendChild(td_2);
    var td_2 = document.createElement("th");
    td_2.innerText = "Birim";
    tr_2.appendChild(td_2);
    var td_2 = document.createElement("th");
    //td_2.innerText = "#";
    var btn = document.createElement("button");
    btn.innerText = "+";
    btn.setAttribute("class", "btn btn-warning");
    if (item.AgacRc > 0) {
    } else {
      btn.setAttribute(
        "onclick",
        "addTreeItem(" + i + "," + item.SIPARIS_MIKTARI + ")"
      );
    }

    btn.setAttribute("style", "width:30px");
    td_2.appendChild(btn);
    tr_2.appendChild(td_2);
    table_2.appendChild(tr_2);
    for (let j = 0; j < tree.length; j++) {
      var tr_2 = document.createElement("tr");
      var td_2 = document.createElement("th");
      td_2.innerText = tree[j].PRODUCT_NAME;
      tr_2.appendChild(td_2);
      var td_2 = document.createElement("th");
      td_2.innerText = tree[j].AMOUNT;
      tr_2.appendChild(td_2);
      var td_2 = document.createElement("th");
      // td_2.innerText = tree[j].BAKIYE;
      var a = document.createElement("a");
      a.innerText = commaSplit(tree[j].BAKIYE);
      if (parseFloat(tree[j].BAKIYE) <= 0) {
        a.setAttribute(
          "onclick",
          "showDemonte(" + tree[j].STOCK_ID + "," + item.SIPARIS_MIKTARI + ")"
        );
        a.setAttribute("style", "color:red");
      }
      td_2.appendChild(a);
      tr_2.appendChild(td_2);
      var td_2 = document.createElement("th");
      td_2.innerText = tree[j].MAIN_UNIT;
      tr_2.appendChild(td_2);
      var td_2 = document.createElement("th");
      var btn = document.createElement("button");
      btn.setAttribute("class", "btn btn-primary");
      btn.setAttribute("onclick", "SetIo(" + i + "," + j + ",this)");
      btn.setAttribute("style", "width:30px");
      if (tree[j].isIo == 0) {
        btn.setAttribute("class", "btn btn-primary");
        btn.innerText = "0";
      } else if (tree[j].isIo == 1) {
        btn.setAttribute("class", "btn btn-success");
        btn.innerText = "+";
      } else {
        btn.setAttribute("class", "btn btn-danger");
        btn.innerText = "-";
      }
      // isIo(i, j, btn);

      td_2.appendChild(btn);
      tr_2.appendChild(td_2);
      table_2.appendChild(tr_2);
    }
    td.appendChild(table_2);
    tr.appendChild(td);
    table.appendChild(tr);
    var tr = document.createElement("tr");
    var td = document.createElement("td");
    td.setAttribute("colspan", 3);
    var dva= document.createElement("div");
    dva.setAttribute("class", "form-group");
    var lbl = document.createElement("label");
    lbl.innerText = "Ağaç Kaydet";
	lbl.setAttribute("style","vertical-align: top;")
    dva.appendChild(lbl);
    var inpx = document.createElement("input");
    inpx.setAttribute("type", "checkbox");
    inpx.setAttribute("onclick", "saveTreeCheck(this," + i + ")");
    if(item.saveTree==1){inpx.setAttribute("checked","")}
	dva.appendChild(inpx);
	
    td.appendChild(dva);
    tr.appendChild(td);
    table.appendChild(tr);
    div_2.appendChild(table);
    dv.appendChild(div_2);
  }
}
function SetIo(col, x, elem) {
  elem.removeAttribute("class");
  if (x != -1) {
    console.log(cols[col].AGAC[x]);
    if (cols[col].AGAC[x].isIo == 0) {
      cols[col].AGAC[x].isIo = 1;
      elem.setAttribute("class", "btn btn-success");
      elem.innerText = "+";
    } else if (cols[col].AGAC[x].isIo == 1) {
      cols[col].AGAC[x].isIo = -1;
      elem.setAttribute("class", "btn btn-danger");
      elem.innerText = "-";
    } else {
      cols[col].AGAC[x].isIo = 0;
      elem.setAttribute("class", "btn btn-primary");
      elem.innerText = "0";
    }
  } else {
    if (cols[col].isIo == 0) {
      cols[col].isIo = 1;
      elem.setAttribute("class", "btn btn-success");
      elem.innerText = "+";
    } else if (cols[col].isIo == 1) {
      cols[col].isIo = -1;
      elem.setAttribute("class", "btn btn-danger");
      elem.innerText = "-";
    } else {
      cols[col].isIo = 0;
      elem.setAttribute("class", "btn btn-primary");
      elem.innerText = "0";
    }
  }
}

function showDemonte(STOCK_ID, MIKTAR) {
  openBoxDraggable(
    "index.cfm?fuseaction=objects.emptypopup_show_rel_demontaged_products&STOCK_ID=" +
      STOCK_ID +
      "&MIKTAR=" +
      MIKTAR
  );
}
function saveTreeCheck(el, col) {
  if ($(el).is(":checked") == true) {
    cols[col].saveTree = 1;
  } else {
    cols[col].saveTree = 0;
  }
}
function addTreeItem(col, SIPARIS_MIKTARI) {
  openProductPopup("", "", col, 3, SIPARIS_MIKTARI);
}
function addTreeItem_(
  PRODUCT_CODE,
  PRODUCT_NAME,
  AMOUNT,
  STOCK_ID,
  PRODUCT_ID,
  MAIN_UNIT,
  BAKIYE,
  isIo,
  col
) {
  var agac = {
    PRODUCT_CODE: PRODUCT_CODE,
    PRODUCT_NAME: PRODUCT_NAME,
    AMOUNT: AMOUNT,
    STOCK_ID: STOCK_ID,
    PRODUCT_ID: PRODUCT_ID,
    MAIN_UNIT: MAIN_UNIT,
    BAKIYE: BAKIYE,
    isIo: isIo,
  };
  cols[col].AGAC.push(agac);
}

function TblListener(tbl, coli) {
  $(tbl).on("contextmenu", function (ev) {
    $(".pbsContex").remove();
    ev.preventDefault();
    console.log(ev);
    var div = document.createElement("div");
    div.setAttribute("class", "pbsContex");
    $(div).attr(
      "style",
      "display:none;top:" + ev.clientY + "px;left:" + ev.clientX + "px"
    );
    var div3 = document.createElement("div");
    div3.setAttribute(
      "style",
      "border-top: solid 5px black;border-left: solid 5px black;width: 10px;height: 10px;"
    );
    var div2 = document.createElement("div");
    div2.setAttribute("class", "list-group");

    var a = document.createElement("a");
    var spn1 = document.createElement("span");
    spn1.setAttribute("class", "icon-times");
    spn1.setAttribute("style", "margin-right:10px");
    var spn2 = document.createElement("span");
    spn2.innerText = "Sil";
    a.appendChild(spn1);
    a.appendChild(spn2);
    if (coli == 0) {
      a.setAttribute("disabled", "");
    }
    a.setAttribute("class", "list-group-item");
    a.setAttribute("onclick", "removeCol(" + coli + ")");
    div2.appendChild(a);

    div.appendChild(div3);
    div.appendChild(div2);

    document.body.appendChild(div);
    $(div).show(500);
  });
}

function removeCol(col) {
  if (col == 0) {
    alert("Ana Ürünü Silemezsiniz");
    return false;
  }
  $(".column_" + col).remove();

  console.log(cols[col]);
  cols.splice(cols, 1);
}
