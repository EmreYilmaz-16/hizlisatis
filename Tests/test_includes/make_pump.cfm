<cf_box title="Make Pump">
<input type="hidden" name="company_id" id="company_id" value="22781">
<input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="17"> 

<button type="button" class="btn btn-primary" onclick="OpenBasketProducts()">+</button>
<button type="button" class="btn btn-secondary" onclick="changeRotation(this)">Yön Değiştir</button>
<input type="hidden" name="is_rotation" id="is_rotation" value="0">

<table class="pump_basket" id="pump_basket">


</table>

</cf_box>


<script>
var pupRowC=0;
function changeRotation(el) {
    var r=document.getElementById("is_rotation").value;
    r=parseInt(r);
    if(r==1){
        el.removeAttribute("class");
        el.setAttribute("class","btn btn-secondary")
        document.getElementById("is_rotation").value=0
    }else{
        el.removeAttribute("class");
        el.setAttribute("class","btn btn-success")
        document.getElementById("is_rotation").value=1
    }
}

    function OpenBasketProducts(question_id,from_row = 0, col = "",actType = "",SIPARIS_MIKTARI = 1) {
  var cp_id = document.getElementById("company_id").value;
  var cp_name = document.getElementById("company_id").value;

  var p_cat = document.getElementById("PRICE_CATID").value;
  var p_cat_id = document.getElementById("PRICE_CATID").value;
  openBoxDraggable(
    "http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=" +
      p_cat +
      "&PRICE_CATID=" +
      p_cat_id +
      "&company_id=" +
      cp_id +
      "&company_name=" +
      cp_name +
      "&question_id=" +
      question_id +
      "&columnsa=" +
      col +
      "&actType=" +
      actType +
      "&SIPARIS_MIKTARI=" +
      SIPARIS_MIKTARI
  );
}
</script>