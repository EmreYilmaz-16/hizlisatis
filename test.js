//var b = document.getElementById("basket_header_add_2");
//var OrderId = getParameterByName("order_id");
//var OrderEvent = getParameterByName("event");
//SevkButonunuEkle(OrderId);
var YetKiliPersoneller = [2, 3, 4, 999];
var DpParams = {
  ProcessStageAutoInc: true,
  ProcessStageAutoIncIds: [137, 138, 47, 115],
  ProcessStageAutoIncDescr: [
    "Sipariş Hazırlanıyor",
    "Sipariş Onay Talep",
    "Sevkiyat Planı Yapılacak",
    "Planlama Yapıldı",
  ],
};
function process_cat_dsp_function() {
  var ProcessStageElement = document.getElementById("process_stage");
  var ActiveProcessStage = ProcessStageElement.value;
  SayfaSekillendir(ActiveProcessStage, AktifKullaniciId);
}

function MaliyetKontroluYap() {
  var OnayDurum = true;
  var ReturnValue = false;
  var _BI = document.getElementsByTagName("tr");
  var HataDurumu = false;
  for (let index = 0; index < _BI.length; index++) {
    var _E = _BI[index];
    if (_E.hasAttribute("basketitem")) {
      var ProductId = $(_E).find("input[name='product_id']").val();
      if (ProductId) {
        SatirRenklendir(_E, -1);
        var DocumentPrice = $(_E).find("input[name='price_other']").val();
        var DocumentMoney = $(_E).find("select[name='other_money']").val();
        var QueryString = SorguGetir(1, ProductId);
        var QueryResult = wrk_query(QueryString);
        console.log(QueryResult);
        if (QueryResult.recordcount > 0) {
          var MaliyetObject_1 = MaliyetObjesiOlustur(
            QueryResult.PURCHASE_NET_LOCATION_ALL[0],
            QueryResult.PURCHASE_NET_MONEY_LOCATION[0]
          );
          var MaliyetObject_2 = MaliyetObjesiOlustur(
            QueryResult.PURCHASE_NET_SYSTEM_2_LOCATION_ALL[0],
            QueryResult.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION[0]
          );
          var MaliyetObject_3 = MaliyetObjesiOlustur(
            QueryResult.PURCHASE_NET_SYSTEM_LOCATION_ALL[0],
            QueryResult.PURCHASE_NET_SYSTEM_MONEY_LOCATION[0]
          );
          var MaliyeteTabiFiyat = 0;
          if (DocumentMoney == MaliyetObject_1.ParaBirimi) {
            MaliyeteTabiFiyat = MaliyetObject_1.Maliyet;
          } else if (DocumentMoney == MaliyetObject_2.ParaBirimi) {
            MaliyeteTabiFiyat = MaliyetObject_2.Maliyet;
          } else if (DocumentMoney == MaliyetObject_3.ParaBirimi) {
            MaliyeteTabiFiyat = MaliyetObject_3.Maliyet;
          }
          DocumentPrice = parseFloat(filterNum(DocumentPrice));
          if (DocumentPrice < MaliyeteTabiFiyat) {
            HataDurumu = true;
            SatirRenklendir(_E, 1);
          }
        } else {
          HataDurumu = true;
          SatirRenklendir(_E, 2);
        }
      }
    }
  }
  if (!HataDurumu) {
    //  SurecleriDegistir(47,"Sevkiyat Planı Yapılacak")
    return false;
  } else {
    alert(
      "Maliyetin Altında(Turuncu) veya Maliyet Tanımlanmamış(Mavi) Ürünler Var Sepeti İnceleyiniz"
    );
    // SurecleriDegistir(137,"Sipariş Onay Talep")
    return true;
  }

  console.table({
    Yetkili: YetKiliPersoneller,
    AktifSüreç: ActiveProcessStage,
    OrderId: OrderId,
    OrderEvent: OrderEvent,
  });
}
function SevkButonunuEkle(OrderId) {
  var elem = document.getElementsByClassName("detailHeadButton");
  $(elem[0].children).prepend(
    "<li class='dropdown' id='transformation'><a style='color:#fcba03' title='Sevkiyat Planı Oluştur'onclick='pencereac(1," +
      OrderId +
      ")'><i class='icon-bell'></i></a></li>"
  );
}

function SorguGetir(SorguId) {
  var sorgu = "";
  if (SorguId == 1) {
    sorgu =
      "SELECT PURCHASE_NET_MONEY AS PURCHASE_NET_MONEY_LOCATION,PURCHASE_NET	AS PURCHASE_NET_LOCATION_ALL,PURCHASE_NET_SYSTEM AS PURCHASE_NET_SYSTEM_LOCATION_ALL,PURCHASE_NET_SYSTEM_MONEY AS PURCHASE_NET_SYSTEM_MONEY_LOCATION,PURCHASE_NET_SYSTEM_2 AS PURCHASE_NET_SYSTEM_2_LOCATION_ALL,PURCHASE_NET_SYSTEM_MONEY_2 AS PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,PRODUCT_COST_ID";
    sorgu +=
      " FROM catalystTest_1.PRODUCT_COST WHERE PRODUCT_COST_ID=(SELECT MAX(PRODUCT_COST_ID) from catalystTest_1.PRODUCT_COST where PRODUCT_ID=" +
      arguments[1] +
      ")";
  }
  return sorgu;
}

function MaliyetObjesiOlustur(FIYAT, PB) {
  var MaliyetObject = {
    Maliyet: FIYAT,
    ParaBirimi: PB,
  };
  return MaliyetObject;
}

function SatirRenklendir(satir, renk_id) {
  var Renk = "Orange";
  if (renk_id == 1) {
    Renk = "Red";
  } else if (renk_id == 1) {
    Renk = "aqua";
  } else if (renk_id == -1) {
    Renk = "none";
  }
  satir.setAttribute(
    "style",
    "color:white !important;background-color:" + Renk + " !important"
  );
}

function SurecleriDegistir(SurecId, Aciklama) {
  $("#process_stage").find("option").remove().end();
  $("#process_stage").html(
    "<option value='" + SurecId + "'>" + Aciklama + "</option>"
  );
}

function satirdis() {
  $("input[name='Price']").attr("readonly", true);
  $("input[name='other_money_value']").attr("readonly", true);
  $("input[name='price_other']").attr("readonly", true);
  $("input[name='row_lasttotal']").attr("readonly", true);
  $("input[name='tax_price']").attr("readonly", true);
  $("input[name='row_total']").attr("readonly", true);
  //   $(".fa-ellipsis-v").parent().remove()

  var Elipsies = $(".fa-ellipsis-v");
  for (let i = 0; i < Elipsies.length; i++) {
    var E = Elipsies[i];
    //console.log(E.parentElement.id)
    if (E.parentElement.id == "product_popup") {
      console.log(E.parentElement.id);
    } else {
      E.parentElement.remove();
    }
  }
  var elemans = $("select[name='other_money']");
  for (let i = 0; i < elemans.length; i++) {
    var el = elemans[i];
    var opt = $(el).find("option");
    for (let j = 0; j < opt.length; j++) {
      var op = opt[j];
      //console.log($(op).is("selected"))
      var ddd = $(op).attr("selected");
      if (ddd == "selected") {
        console.log(ddd);
      } else {
        op.remove();
      }
    }
  }
}

function SayfaSekillendir(ActiveStage, uid) {
  var HataDurumu = MaliyetKontroluYap();
  if (!HataDurumu) {
    if (DpParams.ProcessStageAutoInc == true) {
      var PsIndex = DpParams.ProcessStageAutoIncIds.findIndex(
        (p) => p == ActiveStage
      );
      if (PsIndex >= 0) {
        if (PsIndex != DpParams.ProcessStageAutoIncIds.length - 1) {
          SurecleriDegistir(
            DpParams.ProcessStageAutoIncIds[PsIndex],
            DpParams.ProcessStageAutoIncDescr[PsIndex]
          );
        }
      }
    }
  } else {
    SurecleriDegistir(137, "Sipariş Onay Talep");
    console.log("Yetkili Kontrolü");
    var isYetkili = YetKiliPersoneller.findIndex((p) => p == uid);
    if (isYetkili >= 0) {
    }
  }
}

process_cat_dsp_function();
