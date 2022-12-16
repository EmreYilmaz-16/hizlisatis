function openVirtualProduct(id = "", row_id = ""){
	  var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=4&row_id=" + row_id)
    editorAdd();
}
function editorAdd(){
var d=document.getElementById("sonuc_div")
var v=window.innerHeight
var t=$(document.getElementById("PRODUCT_DESCRIPTION")).css("height")
t=parseInt(t)
v=parseInt(v)
$(d).css("height",(v-t)/1.5+"px")
$(d).css("width",(v-t)/1.5+"px")
  var mime = 'text/x-mssql';
  // get mime type

  window.editor = CodeMirror.fromTextArea(document.getElementById('PRODUCT_DESCRIPTION'), {
     mode: "simplemode"
  });
}
