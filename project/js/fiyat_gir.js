$(document).ready(function () {
  SetEventListeners()
  var RR=wrk_query("SELECT * FROM PROJECT_PRODUCTS_TREE_PRICES_MAIN WHERE IS_AKTIF=1 AND  PROJECT_ID="+ProjectData.PROJECT_ID+"AND IS_VIRTUAL="+list_getat(ProjectData.PRODUCT,2,"**")+" AND  MAIN_PRODUCT_ID="+list_getat(ProjectData.PRODUCT,1,"**"),"DSN3")
  
  
  if(RR.recordcount>0){
    //FiyatlariYukle(RR.MAIN_ID,"")
  }else{
    FiyatlariGetir()
  }
})
function getProjectProducts(el, ev) {
  if (ev.keyCode == 13) {
    var project_number = el.value;
    var ProjectResult = wrk_query(
      "SELECT TOP 10 PROJECT_ID,PROJECT_NUMBER,COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_HEAD='" +
      project_number +
      "'",
      "DSN"
    );
    var CompanyInfo = wrk_query("SELECT PRICE_CAT,COMPANY_ID FROM COMPANY_CREDIT WHERE COMPANY_ID=" + ProjectResult.COMPANY_ID[0], "DSN");
    //price_cat,company_id
    document.getElementById("price_cat").value = CompanyInfo.PRICE_CAT[0];
    document.getElementById("company_id").value = CompanyInfo.COMPANY_ID[0];
    document.getElementById("project_id").value = ProjectResult.PROJECT_ID[0];
    var Products = wrk_query(
      "SELECT * FROM LIST_PROJECT_PRODUCTS_PBS WHERE PROJECT_ID=" +
      ProjectResult.PROJECT_ID[0],
      "DSN3"
    );
    if (Products.recordcount > 0) {
      console.log("Kayıt Var");
      document
        .getElementById("product")
        .setAttribute("class", "productFound");
    } else {
      document
        .getElementById("product")
        .setAttribute("class", "productNotFound");
    }
    $("#ProductrVirtualOptGroup").html("");
    $("#ProductrRealOptGroup").html("");
    for (let i = 0; i < Products.recordcount; i++) {
      var opt = document.createElement("option");
      opt.value = Products.STOCK_ID[i] + "**" + Products.IS_VIRTUAL[i];
      opt.innerText = Products.PRODUCT_NAME[i];
      if (Products.IS_VIRTUAL[i] == 1) {
        document.getElementById("ProductrVirtualOptGroup").appendChild(opt);
      } else {
        document.getElementById("ProductrRealOptGroup").appendChild(opt);
      }
    }
  } else {
    // document.getElementById("ProductOptGroup").parentElement.setAttribute("class","productDefault")
  }
}

document.getSubElementsByRowId = function (idb) {
  var str = idb.toString();
  var el = $("*").find("* [upper_ptid='" + str + "']");
  return el;
};
function FiyatlariHesapla() {
  for (let i = 0; i < 10; i++) {

    var Rows = document.getElementsByClassName("basket_row")
    for (let Row of Rows) {
      //console.log(Row)
      var UpperRowId = Row.getAttribute("upper_ptid")
      //console.log(UpperRowId)
      var RowId = Row.getAttribute("pit_id")
      // console.log(RowId)
      var x = document.getSubElementsByRowId(RowId)
      document.getElementsByName("PRICETL_" + RowId)[0].setAttribute("style", "color:red !important;background:#80808045 !important;text-align:right")
      document.getElementsByName("PRICETL_" + RowId)[0].setAttribute("disabled", "disabled")
      document.getElementsByName("AMOUNT_" + RowId)[0].setAttribute("style", "color:red !important;background:#80808045 !important;text-align:right")
      document.getElementsByName("AMOUNT_" + RowId)[0].setAttribute("disabled", "disabled")
      document.getElementsByName("PRICE_" + RowId)[0].setAttribute("style", "color:green !important;background:#80808045 !important;text-align:right")
      if (x.length > 0) {
        document.getElementsByName("PRICE_" + RowId)[0].setAttribute("style", "color:red !important;background:#80808045 !important;text-align:right")
        document.getElementsByName("PRICE_" + RowId)[0].setAttribute("disabled", "disabled")

        var Tf = 0;
        for (let XX of x) {
          var XXRow = XX.getAttribute("pit_id");
          var Miktar = document.getElementsByName("AMOUNT_" + XXRow)[0].value
          Miktar = parseFloat(filterNum(Miktar))
          var Fiyat = document.getElementsByName("PRICETL_" + XXRow)[0].value
          Fiyat = parseFloat(filterNum(Fiyat))

          var Discount = document.getElementsByName("DISCOUNT_" + XXRow)[0].value
          Discount = parseFloat(filterNum(Discount))

          Tf = Tf + (Miktar * Fiyat)
          Tf = Tf - ((Tf * Discount) / 100)

        }
        document.getElementsByName("PRICETL_" + RowId)[0].setAttribute("value", commaSplit(Tf))
        var MMIK = document.getElementsByName("AMOUNT_" + RowId)[0].value
        MMIK = parseFloat(filterNum(MMIK))
        var DISM = document.getElementsByName("DISCOUNT_" + RowId)[0].value
        DISM = parseFloat(filterNum(DISM))
        var TY = Tf * MMIK
        TY = TY - ((TY * DISM) / 100)
        document.getElementsByName("TOTAL_" + RowId)[0].setAttribute("value", commaSplit(TY))

      } else {
        var Miktar = document.getElementsByName("AMOUNT_" + RowId)[0].value
        Miktar = parseFloat(filterNum(Miktar))
        var Fiyat = document.getElementsByName("PRICETL_" + RowId)[0].value
        Fiyat = parseFloat(filterNum(Fiyat))

        var Discount = document.getElementsByName("DISCOUNT_" + RowId)[0].value
        Discount = parseFloat(filterNum(Discount))

        var Tf = 0
        Tf = Tf + (Miktar * Fiyat)
        Tf = Tf - ((Tf * Discount) / 100)
        document.getElementsByName("TOTAL_" + RowId)[0].setAttribute("value", commaSplit(Tf))
      }
    }

  }
  var GenelToplam = 0;
  for (let Row of Rows) {
    var UpperRowId = Row.getAttribute("upper_ptid")
    var RowId = Row.getAttribute("pit_id")
    if (UpperRowId == "10000000") {
      var RT = document.getElementsByName("TOTAL_" + RowId)[0].value
      GenelToplam = GenelToplam + parseFloat(filterNum(RT))
    }

  }
  document.querySelector("#BasketForm > tfoot > tr > td:nth-child(2) > input[type=text]").value = commaSplit(GenelToplam)
  console.log(GenelToplam)
  var Rows = document.getElementsByClassName("basket_row")
  for (let Row of Rows) {
    //  console.log(Row)
    var RowId = Row.getAttribute("pit_id")
    var x = document.getSubElementsByRowId(RowId)

    if (x.length > 0) {
      var MainMoney = document.getElementsByName("OTHER_MONEY_" + RowId)[0].innerText
      var Px = moneyArr.findIndex(p => p.MONEY == MainMoney);
      var TlPrice = document.getElementsByName("PRICETL_" + RowId)[0].value
      TlPrice = parseFloat(filterNum(TlPrice))
      var Rate2 = moneyArr[Px].RATE2
      var Cp = TlPrice / Rate2
      console.log(Cp)
      document.getElementsByName("PRICE_" + RowId)[0].value = commaSplit(Cp)
    }

  }

}



function FiyatlariGetir() {
  var Rows = document.getElementsByClassName("basket_row")
  for (let Row of Rows) {
    var RowId = Row.getAttribute("pit_id")
    var PRODUCT_ID = document.getElementsByName("PRODUCT_ID" + RowId)[0].value
    var IS_VIRTUAL = document.getElementsByName("IS_VIRTUAL" + RowId)[0].value
    var x = document.getSubElementsByRowId(RowId)
    if (x.length == 0) {
      $.ajax({
        url: "/AddOns/Partner/project/cfc/product_design.cfc?method=getPriceFunk_AJAX",
        data: {
          PRODUCT_ID: PRODUCT_ID,
          IS_VIRTUAL: IS_VIRTUAL,
          COMPANY_ID: ProjectData.COMPANY_ID,
          PRICE_CATID: ProjectData.PRICE_CAT,
          ddsn3: "workcube_metosan_1",
          ROW_ID: RowId
        },
        success: function retDat(params) {
          console.log(params)
          var PriceObject = JSON.parse(params)
          console.log(PriceObject)
          if (PriceObject.MONEY.length == 0) {
            PriceObject.MONEY = "TL"
          }
          try {
            document.getElementsByName("OTHER_MONEY_" + PriceObject.ROW_ID)[0].innerText = PriceObject.MONEY
          } catch (error) {
            console.warn("Hatalı Olan Row" + PriceObject.ROW_ID)
            console.log(document.getElementsByName("OTHER_MONEY_" + PriceObject.ROW_ID)[0])
          }
          if (!PriceObject.PRICE) {
            console.warn(PriceObject)
            PriceObject.PRICE = 0
          }


          document.getElementsByName("PRICE_" + PriceObject.ROW_ID)[0].value = commaSplit(PriceObject.PRICE)
          var ix = moneyArr.findIndex(p => p.MONEY == PriceObject.MONEY)
          var Rate2 = moneyArr[ix].RATE2
          console.log(Rate2)
          var PS = PriceObject.PRICE * Rate2
          console.log(PS)
          document.getElementsByName("PRICETL_" + PriceObject.ROW_ID)[0].value = commaSplit(PS)
          document.getElementsByName("DISCOUNT_" + PriceObject.ROW_ID)[0].value = commaSplit(PriceObject.DISCOUNT)
          console.log(RowId)
          //DISCOUNT_5779
          FiyatlariHesapla()

        }
      })

    } else {
      $.ajax({
        url: "/AddOns/Partner/project/cfc/product_design.cfc?method=getPriceFunk_AJAX",
        data: {
          PRODUCT_ID: PRODUCT_ID,
          IS_VIRTUAL: IS_VIRTUAL,
          COMPANY_ID: ProjectData.COMPANY_ID,
          PRICE_CATID: ProjectData.PRICE_CAT,
          ddsn3: "workcube_metosan_1",
          ROW_ID: RowId
        },
        success: function retDat(params) {
          console.log(params)
          var PriceObject = JSON.parse(params)
          console.log(PriceObject)
          if (PriceObject.MONEY.length == 0) {
            PriceObject.MONEY = "TL"
          }
          document.getElementsByName("OTHER_MONEY_" + PriceObject.ROW_ID)[0].innerText = PriceObject.MONEY

          console.log(RowId)
          //DISCOUNT_5779
          FiyatlariHesapla()

        }
      })
    }
  }
}
function SetEventListeners() {
  var Rows = document.getElementsByClassName("basket_row")
  for (let Row of Rows) {

    var RowId = Row.getAttribute("pit_id")
    var PRODUCT_ID = document.getElementsByName("PRODUCT_ID" + RowId)[0].value
    var IS_VIRTUAL = document.getElementsByName("IS_VIRTUAL" + RowId)[0].value
    var x = document.getSubElementsByRowId(RowId)
    // console.log(x)
    if (x.length == 0) {

      document.getElementsByName("PRICE_" + RowId)[0].setAttribute("onchange", "satirHesapla(this)")
      document.getElementsByName("AMOUNT_" + RowId)[0].setAttribute("onchange", "satirHesapla(this)")
      document.getElementsByName("DISCOUNT_" + RowId)[0].setAttribute("onchange", "satirHesapla(this)")
    } else {
      document.getElementsByName("AMOUNT_" + RowId)[0].setAttribute("onchange", "satirHesapla(this)")
      document.getElementsByName("DISCOUNT_" + RowId)[0].setAttribute("onchange", "satirHesapla(this)")
    }

  }
}

function satirHesapla(e) {
  var RowId = e.getAttribute("data-rowid")
  console.log(RowId)
  var PRICE = document.getElementsByName("PRICE_" + RowId)[0].value
  document.getElementsByName("PRICE_" + RowId)[0].value = commaSplit(PRICE)
  var PRICE = document.getElementsByName("PRICE_" + RowId)[0].value;
  PRICE = parseFloat(filterNum(PRICE))
  var OTHER_MONEY = document.getElementsByName("OTHER_MONEY_" + RowId)[0].innerText
  //var DISCOUNT=document.getElementsByName("DISCOUNT_"+RowId).value

  var DISCOUNT = document.getElementsByName("DISCOUNT_" + RowId)[0].value
  document.getElementsByName("DISCOUNT_" + RowId)[0].value = commaSplit(DISCOUNT)
  var DISCOUNT = document.getElementsByName("DISCOUNT_" + RowId)[0].value;
  DISCOUNT = parseFloat(filterNum(DISCOUNT))

  var AMOUNT = document.getElementsByName("AMOUNT_" + RowId)[0].value
  document.getElementsByName("AMOUNT_" + RowId)[0].value = commaSplit(AMOUNT)
  var DISCOUNT = document.getElementsByName("AMOUNT_" + RowId)[0].value;
  DISCOUNT = parseFloat(filterNum(AMOUNT))

  var ix = moneyArr.findIndex(p => p.MONEY == OTHER_MONEY)
  var Rate2 = moneyArr[ix].RATE2
  console.log(Rate2)
  var TlFiyat = PRICE * Rate2

  document.getElementsByName("PRICETL_" + RowId)[0].value = commaSplit(TlFiyat)

  FiyatlariHesapla()
}

function KaydetCanim() {
  var Rows = document.getElementsByClassName("basket_row")
  var ProductTreeArray = [];
  for (let Row of Rows) {
    var RowId = Row.getAttribute("pit_id")
    var UPPER_TREE_ID = Row.getAttribute("upper_ptid")
    var PRODUCT_ID = document.getElementsByName("PRODUCT_ID" + RowId)[0].value
    var IS_VIRTUAL = document.getElementsByName("IS_VIRTUAL" + RowId)[0].value
    var PRICE = document.getElementsByName("PRICE_" + RowId)[0].value
    var AMOUNT = document.getElementsByName("AMOUNT_" + RowId)[0].value
    var DISCOUNT = document.getElementsByName("DISCOUNT_" + RowId)[0].value
    var OTHER_MONEY = document.getElementsByName("OTHER_MONEY_" + RowId)[0].innerText
    var O = {
      PRODUCT_TREE_ID: RowId,
      UPPER_PRODUCT_TREE_ID: UPPER_TREE_ID,
      PRODUCT_ID: PRODUCT_ID,
      IS_VIRTUAL: IS_VIRTUAL,
      PRICE: parseFloat(filterNum(PRICE)),
      DISCOUNT: parseFloat(filterNum(DISCOUNT)),
      AMOUNT: parseFloat(filterNum(AMOUNT)),
      OTHER_MONEY
    }
    ProductTreeArray.push(O)
  }
  ProjectData.PRODUCT_TREE = ProductTreeArray
  ProjectData.KURLAR = moneyArr
  console.log(ProjectData)
  $.ajax({
    url: "/AddOns/Partner/project/cfc/product_design.cfc?method=SaveTreePrices",
    data: { FORM_DATA: JSON.stringify(ProjectData) },
    method: "POST"

  })
}


function OpenPricesInte() {
  var ProductId = list_getat(ProjectData.PRODUCT, 1, "**")
  var IS_VIRTUAL = list_getat(ProjectData.PRODUCT, 2, "**")
  openBoxDraggable("index.cfm?fuseaction=project.emptypopup_mini_tools&project_id=" + ProjectData.PROJECT_ID + "&is_virtual="+IS_VIRTUAL+"&main_product_id=" + ProductId + "&tool_type=ShowSavedPriceMain")
}

function FiyatlariYukle(MAIN_ID,modalid) {
  var ProductId = list_getat(ProjectData.PRODUCT, 1, "**")
  var IS_VIRTUAL = list_getat(ProjectData.PRODUCT, 2, "**")
  
  if(parseInt(IS_VIRTUAL)==0){
    var Prices = wrk_query("SELECT  * FROM PROJECT_REAL_PRODUCTS_TREE_PRICES WHERE MAIN_ID="+MAIN_ID, "DSN3")
  }else {
    var Prices = wrk_query("SELECT  * FROM PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES WHERE MAIN_ID="+MAIN_ID, "DSN3")
  }
  for (let i = 0; i < Prices.recordcount; i++) {
    var PRICE = Prices.PRICE[i];
    var DISCOUNT = Prices.DISCOUNT[i];
    var PRODUCT_TREE_ID = Prices.PRODUCT_TREE_ID[i];
    document.getElementsByName("PRICE_" + PRODUCT_TREE_ID)[0].value = commaSplit(PRICE)
    document.getElementsByName("DISCOUNT_" + PRODUCT_TREE_ID)[0].value = commaSplit(DISCOUNT)
  }
  var Rows = document.getElementsByClassName("basket_row")
  for (let Row of Rows) {
    var RowId = Row.getAttribute("pit_id")
    var e = document.getElementsByName("PRICE_" + RowId)[0]
    satirHesapla(e)
  }
  alert("Fiyatlar Yüklendi");
  closeBoxDraggable(modalid)
}