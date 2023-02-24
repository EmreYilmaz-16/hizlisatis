function openVirtualProduct(id = "", row_id = "") {
  var comp_id = document.getElementById("company_id").value;
  var price_catid = document.getElementById("PRICE_CATID").value;
  openBoxDraggable(
    "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" +
      id +
      "&price_catid=" +
      price_catid +
      "&comp_id=" +
      comp_id +
      "&type=4&row_id=" +
      row_id
  );
  editorAdd();
}
function editorAdd() {
  //$(d).css("height",(v-t)/1.5+"px")
  //$(d).css("width",(v-t)/1.5+"px")
  var mime = "text/x-mssql";
  // get mime type

  window.editor = CodeMirror.fromTextArea(
    document.getElementById("PRODUCT_DESCRIPTION"),
    {
      mode: "simplemode",
    }
  );
}

function saveProduct(modal_id) {
  var formData = getFormOfferProductFormData();
  if (formData) {
    $.ajax({
      url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveOfferRealProduct",
      data: formData,
      success: function (retDat) {
        console.log(retDat);
        var obj = JSON.parse(retDat);
        if (obj.ROW_ID != 0) {
          console.log("Row Id Geldi Update Çalışacak");
          UpdRow(
            obj.PRODUCT_ID,
            obj.STOCK_ID,
            0,
            0,
            0,
            obj.PRODUCT_NAME,
            18,
            0,
            obj.ROW_ID,
            -2,
            obj.STOCK_CODE,
            obj.MAIN_UNIT
          );
        } else {
          console.log("Row Id Gelmedi Update Add Çalışacak");
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

        closeBoxDraggable(modal_id);
      },
    });
  }
}
function UpdateVirtualOfferProduct(modal_id) {
  var formData = getFormOfferProductFormData();
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=UpdateOfferProduct",
    data: formData,
    success: function (retDat) {
      console.log(retDat);
      console.log("Çok Boktan Bir Yer Çalışıyor");
      var obj = JSON.parse(retDat);
      UpdRow(obj.PID, "", 1, 0, 0, obj.NAME, 18, 0, obj.ROW_ID, -1);
      closeBoxDraggable(modal_id);
    },
  });
}
function saveVirtualOfferProduct(modal_id) {
  var formData = getFormOfferProductFormData();
  if (formData) {
    $.ajax({
      url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveOfferProduct",
      data: formData,
      success: function (retDat) {
        console.log(retDat);
        var obj = JSON.parse(retDat);
        console.log("Çok Boktan Bir Yer Çalışıyor2");
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
          4,
          "",
          "TL",
          obj.PRICE,
          "-1",
          0,
          0,
          obj.UNIT,
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
}

function getFormOfferProductFormData() {
  var UNIT = document.getElementById("MAIN_UNIT").value;
  var DESCRIPTION = document.getElementById("PRODUCT_DESCRIPTION").value;
  var PRODUCT_NAME = document.getElementById("PRODUCT_NAME").value;
  var PRODUCT_ID = document.getElementById("vp_id").value;
  var PRODUCT_CATID = document.getElementById("PRODUCT_CATID").value;
  var ROW_ID = document.getElementById("row_id").value;
  var q =
    "SELECT * FROM PRODUCT WHERE PRODUCT_NAME LIKE '%" + PRODUCT_NAME + "%'";
  var r = wrk_query(q, "dsn1");
  if (r.recordcount > 0) {
    alert("Bu Ürün Daha Önce Oluşturulmuştur !");
    return false;
  }
  var formData = {
    PRODUCT_NAME: PRODUCT_NAME,
    DESCRIPTION: DESCRIPTION,
    UNIT: UNIT,
    PRODUCT_ID: PRODUCT_ID,
    PRODUCT_CATID: PRODUCT_CATID,
    ROW_ID: ROW_ID,
    EMPLOYEE_ID: generalParamsSatis.userData.user_id,
    dsn3: generalParamsSatis.dataSources.dsn3,
    dsn1: generalParamsSatis.dataSources.dsn1,
    dsn2: generalParamsSatis.dataSources.dsn2,
    dsn: generalParamsSatis.dataSources.dsn,
  };
  return formData;
}
