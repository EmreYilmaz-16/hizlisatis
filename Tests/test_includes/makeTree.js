var T = [];
var TObject = {
  PID: 1,
  SID: 1,
  IS_VIRTUAL: 1,
  QUANTITY: 1,
  PRODUCT_CAT: 1,
  PRODUCT_NAME: "ÜRÜN ADI",
  HIEARCHY: "ÜRE.HT.HID",
  PRODUCT_TREE: [],
  ORR_CURR: -1,
  SHELF_CODE: "",
  PRICE: 107.75,
};
function AddTreeItem(pos = 0) {
  var mc = document.getElementById("mcCat").value;
  if (mc.length == 0) {
    alert("Ürün Tipi Seçiniz");
    return false;
  }
  var tx = document.getElementById("t4").value;
  if (tx.length == 0) {
    alert("Ürün Adı Giriniz");
    document.getElementById("t4").focus();
    return false;
  }

  var div = document.createElement("div");
  var table = document.createElement(table);
  var tr = document.createElement("tr");
  var td = document.createElement("td");
  var TObject = {
    PID: 1,
    SID: 1,
    IS_VIRTUAL: 1,
    QUANTITY: 1,
    PRODUCT_CAT: 1,
    PRODUCT_NAME: "ÜRÜN ADI",
    HIEARCHY: "ÜRE.HT.HID",
    PRODUCT_TREE: [],
    ORR_CURR: -1,
    SHELF_CODE: "",
    PRICE: 107.75,
  };
}
