function checkKontrol(el, id) {
  if ($(el).is(":checked")) {
    document.getElementById("txt_" + id).removeAttribute("disabled");
  } else {
    document.getElementById("txt_" + id).setAttribute("disabled", "disabled");
  }
}
function sbm(tip,employee_id) {
  var kntRes = parcaliKontrol(belgeId);

  var frm = document.getElementById("frm1");
  if (tip == 1) {
    $.get("/AddOns/Partner/satis/cfc/kontrol.cfc?method=emirver&svk_id="+belgeId+"&employee_id="+employee_id);
    var rs=wrk_query("SELECT MAX(EMIR_ID) AS EMIR_ID FROM FATURA_EMIR_PBS","DSN3")
    frm.action = "index.cfm?fuseaction=invoice.form_add_bill&is_from_pbs=1&emir_id="+rs.EMIR_ID[0];
  } else if (tip == 2) {
    frm.action = "index.cfm?fuseaction=stock.form_add_sale&is_from_pbs=1";
  }
  if (kntRes) {
    frm.submit();
  }
}

function parcaliKontrol(iid) {
  var q = wrk_query(
    "SELECT ISNULL(IS_PARCALI,0) as IS_PARCALI  FROM PRTOTM_SHIP_RESULT WHERE SHIP_RESULT_ID=" +
      belgeId,
    "dsn3"
  );
  //var rowX = 21;
  console.log(q);
  var hata = false;
  var rows = document.getElementsByClassName("rows");
  if (parseInt(q.IS_PARCALI[0]) != 0) {
    var rowY = 0;
    for (let i = 0; i < rows.length; i++) {
      var row = rows[i];
      var OrderQuantity = trim($(row).find(".order_quantity").text());
      OrderQuantity = parseFloat(OrderQuantity);
      var SevkQuantity = trim($(row).find(".qtyy").val());
      SevkQuantity = parseFloat(SevkQuantity);
      var cbx = $(row).find("input[type='checkbox']").is(":checked");

      // console.log("Order Quantity="+OrderQuantity+"Sevk Quantity="+SevkQuantity)
      if (cbx) {
        rowY++;
        if (OrderQuantity != SevkQuantity) {
          alert("Hazırlanan Miktar Sipariş Miktarı İle Uyuşmuyor");
          return false;
        } else if (SevkQuantity == 0) {
          alert("Hazırlanmamış Ürünler Var");
          return false;
        }
      }
    }
    if (rowX != rowY) {
      alert("Eksik Ürün Seçimi !");
      return false; //Sonra Açılacak
    }
  }
  for (let i = 0; i < rows.length; i++) {
    var row = rows[i];
    var OrderQuantity = trim($(row).find(".order_quantity").text());
    OrderQuantity = parseFloat(OrderQuantity);
    var SevkQuantity = trim($(row).find(".qtyy").val());
    SevkQuantity = parseFloat(SevkQuantity);
    var cbx = $(row).find("input[type='checkbox']").is(":checked");
    if (cbx) {
      if (SevkQuantity == 0) {
        alert("Miktar 0 Olamaz");
        return false;
      }
    }
  }
  return true;
}

function checkAll() {
  var cbx = $(".cssxbx");
  for (let i = 0; i < cbx.length; i++) {
    cbx[i].click();
  }
}
