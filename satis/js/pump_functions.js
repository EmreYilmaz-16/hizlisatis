function openPump (id = "", row_id = "", tr = 0) {
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    if (tr == 0) {
      openBoxDraggable(
        "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=5&id=" +
          id +
          "&price_catid=" +
          price_catid +
          "&comp_id=" +
          comp_id +
          "&type=2&row_id=" +
          row_id
      );
    } else {
      openBoxDraggable(
        "index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=5&id=" +
          id +
          "&price_catid=" +
          price_catid +
          "&comp_id=" +
          comp_id +
          "&type=2&row_id=" +
          row_id
      );
    }
  }