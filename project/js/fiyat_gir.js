function getProjectProducts(el, ev) {
  if (ev.keyCode == 13) {
    var project_number = el.value;
    var ProjectResult = wrk_query(
      "SELECT TOP 10 PROJECT_ID,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_HEAD='" +
        project_number +
        "'",
      "DSN"
    );
    var Products = wrk_query(
      "SELECT TOP 5 PRODUCT_ID,PRODUCT_NAME,STOCK_ID,0 AS IS_VIRTUAL FROM STOCKS WHERE PROJECT_ID=" +
        ProjectResult.PROJECT_ID[0] +
        " UNION ALL SELECT VIRTUAL_PRODUCT_ID AS PRODUCT_ID,PRODUCT_NAME,VIRTUAL_PRODUCT_ID AS STOCK_ID,1  AS IS_VIRTUAL  FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID=" +
        ProjectResult.PROJECT_ID[0],
      "DSN3"
    );
    if (Products.recordcount > 0) {
      console.log("Kayıt Var");
      document
        .getElementById("ProductOptGroup")
        .parentElement.setAttribute("class", "productFound");
    } else {
      document
        .getElementById("ProductOptGroup")
        .parentElement.setAttribute("class", "productNotFound");
    }
    $("#ProductOptGroup").html("");
    for (let i = 0; i < Products.recordcount; i++) {
      var opt = document.createElement("option");
      opt.value = Products.STOCK_ID[i];
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
