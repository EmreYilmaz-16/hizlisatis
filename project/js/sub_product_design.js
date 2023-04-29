function ngetTree(product_id, is_virtual) {
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
      product_id +
      "&isVirtual=" +
      is_virtual,
  });
}
