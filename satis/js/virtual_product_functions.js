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

function saveProduct() {
  var formData = getFormOfferProductFormData();
}
function UpdateVirtualOfferProduct(modal_id) {
  var formData = getFormOfferProductFormData();
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=UpdateOfferProduct",
    data: formData,
    success: function (retDat) {
      console.log(retDat);
      var obj = JSON.parse(retDat);
     /* AddRow(
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
        "-2",
        0,
        0,
        obj.UNIT,
        "",
        "",
        1,
        "",
        "",
        1
      );*/
      closeBoxDraggable(modal_id);
    },
  });
}
function saveVirtualOfferProduct(modal_id) {
  var formData = getFormOfferProductFormData();
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveOfferProduct",
    data: formData,
    success: function (retDat) {
      console.log(retDat);
      var obj = JSON.parse(retDat);
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
        "-2",
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

function getFormOfferProductFormData() {
  var UNIT = document.getElementById("MAIN_UNIT").value;
  var DESCRIPTION = document.getElementById("PRODUCT_DESCRIPTION").value;
  var PRODUCT_NAME = document.getElementById("PRODUCT_NAME").value;
  var PRODUCT_ID = document.getElementById("vp_id").value;
  var PRODUCT_CATID = document.getElementById("PRODUCT_CATID").value;

  var formData = {
    PRODUCT_NAME: PRODUCT_NAME,
    DESCRIPTION: DESCRIPTION,
    UNIT: UNIT,
    PRODUCT_ID: PRODUCT_ID,
    PRODUCT_CATID: PRODUCT_CATID,
    dsn3: generalParamsSatis.dataSources.dsn3,
  };
  return formData;
}
