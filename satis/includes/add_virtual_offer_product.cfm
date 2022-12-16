<style>
        .prtMoneyBox{
        text-align:right !important;
        padding:0 !important;
    }
</style>




<cf_box title="Sanal Teklif Ürünü" scroll="1" collapsable="1" resize="1" popup_box="1">
<cfform name="OfferProductForm">
<div class="form-group">
    <label>Açıklama</label>
    <textarea name="PRODUCT_DESCRIPTION" id="PRODUCT_DESCRIPTION"></textarea>
</div>
</cfform>
</cf_box>



<script>
$(document).ready(function(){
  var mime = 'text/x-mssql';
  // get mime type

  window.editor = CodeMirror.fromTextArea(document.getElementById('PRODUCT_DESCRIPTION'), {
     mode: "simplemode"
  });
})

</script>