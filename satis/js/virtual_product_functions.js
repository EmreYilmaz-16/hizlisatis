function openVirtualProduct(id){
	  var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=4&row_id=" + row_id)
}
