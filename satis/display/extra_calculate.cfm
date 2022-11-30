

<cfparam name="attributes.modal_id" default="0">
<span style="border-radius: 20px; background-color:white;" id="scrollList">
    <table class="tblPassedOrders" style="padding:20px;">
        <tbody>
            <tr>
                <td>Ölçü (mm)</td>
                <td><div class="form-group">
                    <input type="text" name="measure" id="measure" class="moneybox" onKeyUp="return(FormatCurrency(this,event,'2'));" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'2');">
                </div>
                </td>
            </tr>
            <tr>
                <td>Kesim Adeti</td>
                <td><div class="form-group"><input type="text" name="cut_pcs" id="cut_pcs" class="moneybox" onKeyUp="return(FormatCurrency(this,event,'2'));" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'2');"></div></td>
            </tr>
            <tr>
                <td><button type="button" class="btn btn-success" style="width:100%;" onClick="calculateUnit(<cfoutput>#attributes.pid_#,#attributes.sid_#,'#attributes.stock_code#','#attributes.brand#',#attributes.is_virtual#,#attributes.amount#,#attributes.price#,'#attributes.product_name#',#attributes.tax#,#attributes.indirim1#,#attributes.product_type#,'#attributes.shelf_code#','#attributes.other_money#',#attributes.price_other#,-6,#attributes.manuel#,#attributes.cost#,'#attributes.unit#','','',1,'#attributes.modal_id#',#attributes.rowNum#</cfoutput>);">Ürün Ekle</button></td>
                <td><button type="button"  style="width:100%;" class="btn btn-danger" onClick="closeThis('<cfoutput>#attributes.modal_id#</cfoutput>',<cfoutput>#attributes.rowNum#</cfoutput>);">İptal</button></td>
            </tr>
        </tbody>
    </table>
</span>

<script>
 $(document).ready(function(){
        $("#measure").focus();
        $("#measure").on("keyup",()=>{if(window.event.keyCode == "13")$("#cut_pcs").focus();});
        $("#cut_pcs").on("keyup",()=>{if(window.event.keyCode == "13")calculateUnit();});
    });    
    function calculateUnit(
    product_id,
    stock_id,
    stock_code,
    brand_name,
    is_virtual,
    quantity,
    price,
    product_name,
    tax,
    discount_rate,
    poduct_type = 0,
    shelf_code = '',
    other_money = 'TL',
    price_other,
    currency = "-6",
    is_manuel = 0,
    cost = 0,
    product_unit = 'Adet',
    product_name_other='',
    detail_info_extra='',
    fc=1,
    modal_id,
    rowNum
    ){
        let measure = parseFloat(filterNum($("#measure").val()));
        let cut_pcs = parseFloat(filterNum($("#cut_pcs").val()));
        if(!measure || measure <= 0)
        {
            alert("Ölçü Giriniz!");
            return false;
        }
        if(!cut_pcs || cut_pcs <= 0)
        {
            alert("Kesim Adeti Giriniz!");
            return false;
        }
        var newQ = parseFloat((measure*cut_pcs)/1000);
        var newD = ReplaceAll(measure.toString(),".",",")+"MMx"+ReplaceAll(cut_pcs.toString(),".",",")+"AD";
        console.log(rowNum)

        AddRow(
        product_id,
    stock_id,
    stock_code,
    brand_name,
    is_virtual,
    newQ,
    price,
    product_name,
    tax,
    discount_rate,
    poduct_type,
    shelf_code ,
    other_money ,
    price_other,
    currency,
    is_manuel,
    cost,
    product_unit,
    product_name_other,
    newD,
    fc,
    rowNum)
    
    closeBoxDraggable(modal_id);
}
function closeThis(modal_id,rowNum){
    closeBoxDraggable(modal_id);
   
    
}
</script>

