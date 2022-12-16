<style>
        .prtMoneyBox{
        text-align:right !important;
        padding:0 !important;
    }
</style>

    <link rel="stylesheet" href="/JS/codemirror-5.65.0/lib/codemirror.css">
    <script src="/JS/codemirror-5.65.0/lib/codemirror.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/edit/matchbrackets.js"></script>
    <script src="/JS/codemirror-5.65.0/mode/sql/sql.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/show-hint.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/sql-hint.js"></script>


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