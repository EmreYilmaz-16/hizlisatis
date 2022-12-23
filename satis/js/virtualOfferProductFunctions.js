function saveProduct() {
  var formData = getFormOfferProductFormData();
}

function saveVirtualOfferProduct() {
  var formData = getFormOfferProductFormData();
  $.ajax({
    url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveOfferProduct",
    data: formData,
    success: function (retDat) {
      console.log(retDat);
    },
  });
}

function getFormOfferProductFormData() {
  var UNIT = document.getElementById("MAIN_UNIT").value;
  var DESCRIPTION = document.getElementById("PRODUCT_DESCRIPTION").value;
  var PRODUCT_NAME = document.getElementById("PRODUCT_NAME").value;

  var formData = {
    PRODUCT_NAME: PRODUCT_NAME,
    DESCRIPTION: DESCRIPTION,
    UNIT: UNIT,
  };
  return formData;
}
