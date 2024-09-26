function saveIhtiyac() {
  var eee = document.getElementById("rowws");
  var EX = document.getElementsByName("PRODUCT")[0].value;
  var ix = eee.children.length;
  var SevkArr = new Array();
  var TedarikArr = new Array();
  var UretimArr = new Array();
  var DataObject = new Object();
  for (let i = 1; i <= ix; i++) {
    console.log(i);
    var pid = document.getElementById("product_id_" + i).value;
    var unit_id = document.getElementById("unit_id_" + i).value;
    var unit = document.getElementById("unit_" + i).value;
    var stock_id = document.getElementById("stock_id_" + i).value;
    var product_name = document.getElementById("product_name_" + i).innerText;
    var def_depo = document.getElementById("depo_" + i).value;
    var orderrow_currency = document.getElementById(
      "orderrow_currency_" + i
    ).value;
    var ihtiyac = document.getElementById("IHTIYAC_" + i).value;
    var item = new Object();
    item.PRODUCT_ID = pid;
    item.STOCK_ID = stock_id;
    item.PRODUCT_UNIT_ID = unit_id;
    item.PRODUCT_UNIT = unit;
    item.PRODUCT_NEED = ihtiyac;
    item.PRODUCT_NAME = product_name;
    item.DEPO = def_depo;
    item.FOR_PRODUCT_ID = list_getat(EX, 2, "_");
    console.log(orderrow_currency);

    if (parseFloat(ihtiyac) > 0) {
      if (parseInt(orderrow_currency) == -2) TedarikArr.push(item);
      if (parseInt(orderrow_currency) == -5) UretimArr.push(item);
      if (parseInt(orderrow_currency) == -6) {
        var qq =
          "select DISTINCT STORE_ID,SL.LOCATION_ID,D.DEPARTMENT_ID,DEPARTMENT_HEAD,COMMENT from workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR";
        qq +=
          " LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID=PP.PRODUCT_PLACE_ID";
        qq +=
          " LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=PP.STORE_ID";
        qq +=
          " LEFT JOIN workcube_metosan.STOCKS_LOCATION AS  SL ON SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID";
        qq +=
          " WHERE  PPR.STOCK_ID= (SELECT STOCK_ID FROM workcube_metosan_product.STOCKS WHERE PRODUCT_ID=" +
          pid +
          ")";
        var qqResult = wrk_query(qq, "dsn");
        console.log(qqResult);
        if (qqResult.recordcount > 1) {
          var str = "Ürün Birden Fazla Depoda Bulunmaktadır";
          for (let j = 0; j < qqResult.recordcount; j++) {
            str +=
              "\n (" +
              qqResult.STORE_ID[j] +
              "-" +
              qqResult.LOCATION_ID[j] +
              " ) " +
              qqResult.DEPARTMENT_HEAD[j] +
              " - " +
              qqResult.COMMENT[0];
          }
          var d = prompt(str);
          item.DEPO = d;
          SevkArr.push(item);
        } else {
          SevkArr.push(item);
        }
      }
    }
  }
  DataObject.SEVK = SevkArr;
  DataObject.TEDARIK = TedarikArr;
  DataObject.URETIM = UretimArr;
  DataObject.PROJECT_ID = PROJECT_ID;
  DataObject.FOR_PRODUCT_ID = list_getat(EX, 2, "_");
  var JsonString = JSON.stringify(DataObject);

  console.log(DataObject);

  var mapForm = document.createElement("form");
  mapForm.target = "Map";
  mapForm.method = "POST"; // or "post" if appropriate
  mapForm.action =
    "/index.cfm?fuseaction=project.emptypopup_add_project_need_documents";

  var mapInput = document.createElement("input");
  mapInput.type = "hidden";
  mapInput.name = "data";
  mapInput.value = JSON.stringify(DataObject);
  mapForm.appendChild(mapInput);

  document.body.appendChild(mapForm);

  map = window.open(
    "/index.cfm?fuseaction=project.emptypopup_add_project_need_documents",
    "Map",
    "status=0,title=0,height=600,width=800,scrollbars=1"
  );

  if (map) {
    mapForm.submit();
  } else {
    alert("You must allow popups for this map to work.");
  }
}

function ihtiyacKontrol(el, rw) {
  var i = document.getElementById("tms_" + rw).innerText;
  i = parseFloat(filterNum(i));
  console.log(i);
  var w = document.getElementById("TMK_" + rw).innerText;
  w = parseFloat(filterNum(w.split(" ")[0]));
  console.log(w);
  var b = document.getElementById("bky_" + rw).innerText;
  b = parseFloat(filterNum(b.split(" ")[0]));
  console.log(b);

  if (parseFloat(el.value) + i + b <= w) {
    $("#buton1").show();
  } else {
    $("#buton1").hide();
  }
}
