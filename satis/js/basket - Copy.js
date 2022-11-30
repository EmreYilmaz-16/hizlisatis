
var row_count = 0;
var rwww = "";
var rwwwx = "";
var rwwwxy = "";
var selectedCount = 0;
var rowCount = 0;
var tempProductData = "";
var selectedArr = [];
$(document).ready(function () {
    $("#barcode").focus()
    var w = window.innerWidth
    var x = (w / 3) - 31;
    $(".pbs_v").attr("style", "width:" + x + "px !important")


})

function openHose(id = "", row_id = "") {
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=1&row_id=" + row_id)
}


function FindProduct(ev, el, userid, dsn2, dsn1, dsn3, price_catid, comp_id) {
    var keyword = el.value;
    var elemanAtt = el.getAttribute("data-type");
    var pidElem = document.getElementById(elemanAtt + "_PId")
    var sidElem = document.getElementById(elemanAtt + "_SId")
    var NameElem = document.getElementById(elemanAtt + "_lbs")
    var priceElem = document.getElementById(elemanAtt + "_Prc")
    console.log(pidElem);
    console.log(sidElem);
    console.log(NameElem);
    console.log(priceElem);
    console.log(ev)
    if (ev.keyCode == 13 || ev.type == 'change') {
        $.ajax({
            url: "/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=getProduct",
            data: {
                keyword: keyword,
                userid: userid,
                dsn2: generalParamsSatis.dataSources.dsn2,
                dsn1: generalParamsSatis.dataSources.dsn1,
                dsn3: generalParamsSatis.dataSources.dsn3,
                dsn: generalParamsSatis.dataSources.dsn,
                price_catid: price_catid,
                comp_id: comp_id
            },
            success: function (returnData) {
                var obj = JSON.parse(returnData)
                console.log(obj)
                pidElem.value = obj.PRODUCT.PRODUCT_ID;
                sidElem.value = obj.PRODUCT.STOCK_ID;
                NameElem.innerText = obj.PRODUCT.PRODUCT_NAME;
                priceElem.value = obj.PRODUCT.PRICE;
                CalculateTube()
            }
        })
    }
}
function CalculateTube() {
    //LRekor_Prc,Tube_Prc,RRekor_Prc,AdditionalProduct_Prc,Kabuk_Prc,working_Prc
    //LRekor_Qty,Tube_Qty,RRekor_Qty,AdditionalProduct_Qty,marj,Kabuk_Qty,working_Qty
    var LRekor_Prc = document.getElementById("LRekor_Prc").value
    var Tube_Prc = document.getElementById("Tube_Prc").value
    var RRekor_Prc = document.getElementById("RRekor_Prc").value
    var AdditionalProduct_Prc = document.getElementById("AdditionalProduct_Prc").value

    var working_Prc = document.getElementById("working_Prc").value
    var Kabuk_Prc = document.getElementById("Kabuk_Prc").value






    var LRekor_Qty = document.getElementById("LRekor_Qty").value
    var Tube_Qty = document.getElementById("Tube_Qty").value
    var RRekor_Qty = document.getElementById("RRekor_Qty").value
    var AdditionalProduct_Qty = document.getElementById("AdditionalProduct_Qty").value
    var Kabuk_Qty = document.getElementById("Kabuk_Qty").value
    var working_Qty = document.getElementById("working_Qty").value
    var marj = document.getElementById("marj").value

    var maliyet = document.getElementById("maliyet")
    var Tf = (parseFloat(LRekor_Prc) * parseFloat(LRekor_Qty)) + (parseFloat(RRekor_Prc) * parseFloat(RRekor_Qty)) + (parseFloat(Tube_Prc) * parseFloat(Tube_Qty)) + (parseFloat(AdditionalProduct_Prc) * parseFloat(AdditionalProduct_Qty));
    Tf = Tf + (parseFloat(working_Prc) * parseFloat(working_Qty)) + (parseFloat(Kabuk_Prc) * parseFloat(Kabuk_Qty))
    Tf = Tf + ((Tf * parseFloat(marj)) / 100)
    maliyet.value = commaSplit(Tf, 2);
}

function calculateTubeRow(el) {
    var qty = el.value;
    CalculateTube()
}

function saveVirtualTube(dsn3, modal_id) {
    var p_name = window.prompt("Ürün Adı")
    if (p_name.length > 0) {
        var d = $("#TubeForm").serialize();
        $.ajax({
            url: "/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=saveVirtualTube",
            data: d + "&product_name=" + p_name + "&dsn3=" + generalParamsSatis.dataSources.dsn3,
            success: function (retDat) {
                console.log(retDat)
                var obj = JSON.parse(retDat)
                AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0);
                closeBoxDraggable(modal_id)
            }
        })
    } else {
        saveVirtualTube()
    }
}


function AddRow(pid, sid, is_virtual, qty, price, p_name, tax, discount_rate) {
    row_count++;
    rowCount = row_count;
    console.log(arguments)
    var tr = document.createElement("tr");
    tr.setAttribute("id", "row_" + row_count)
    tr.setAttribute("data-selected", "0")
    tr.setAttribute("data-rc", row_count)
    // tr.setAttribute("data-ProductType", row_count)
    tr.setAttribute("class", "sepetRow");
    //tr.setAttribute("onclick", "consoı('ÇiftTıklandı')")
    var td = document.createElement("td");
    var i_1 = document.createElement("input");
    i_1.setAttribute("name", "product_id_" + row_count);
    i_1.setAttribute("id", "product_id_" + row_count);
    i_1.setAttribute("type", "hidden");
    i_1.setAttribute("value", pid);

    var i_2 = document.createElement("input");
    i_2.setAttribute("name", "stock_id_" + row_count);
    i_2.setAttribute("id", "stock_id_" + row_count);
    i_2.setAttribute("type", "hidden");
    i_2.setAttribute("value", sid);

    var i_3 = document.createElement("input");
    i_3.setAttribute("name", "is_virtual_" + row_count);
    i_3.setAttribute("id", "is_virtual_" + row_count);
    i_3.setAttribute("type", "hidden");
    i_3.setAttribute("value", is_virtual);
    var cbx = document.createElement("input");
    cbx.setAttribute("type", "checkbox");
    cbx.setAttribute("data-row", row_count);
    cbx.setAttribute("onclick", "selectrw(this)");
    //<span class="icn-md icon-search"></span>

    var spn = document.createElement("span");
    spn.innerText = row_count;
    spn.setAttribute("id", "spn_" + row_count)
    // td.innerText = row_count;
    td.appendChild(spn);
    td.appendChild(i_1);
    td.appendChild(i_2);
    td.appendChild(i_3);
    td.appendChild(cbx);
    // td.appendChild(span);
    tr.appendChild(td);
    var td = document.createElement("td");

    var i_4 = document.createElement("input");
    i_4.setAttribute("name", "product_name_" + row_count);
    i_4.setAttribute("id", "product_name_" + row_count);
    i_4.setAttribute("type", "text");
    // i_4.setAttribute("class", "box");
    i_4.setAttribute("style", "width:40px")
    i_4.setAttribute("value", p_name);

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_4);
    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");

    var i_5 = document.createElement("input");
    i_5.setAttribute("name", "amount_" + row_count);
    i_5.setAttribute("id", "amount_" + row_count);
    i_5.setAttribute("type", "text");
    // i_5.setAttribute("class", "box");
    i_5.setAttribute("style", "width:20px")
    i_5.setAttribute("value", commaSplit(qty));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_5);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");

    var i_6 = document.createElement("input");
    i_6.setAttribute("name", "price_" + row_count);
    i_6.setAttribute("id", "price_" + row_count);
    i_6.setAttribute("type", "text");
    i_6.setAttribute("onchange", "hesapla('price'," + row_count + ")");
    // i_6.setAttribute("class", "box");
    i_6.setAttribute("style", "width:30px")
    i_6.setAttribute("value", commaSplit(price));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_6);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");

    var i_10 = document.createElement("input");
    i_10.setAttribute("name", "price_other_" + row_count);
    i_10.setAttribute("id", "price_other_" + row_count);
    i_10.setAttribute("type", "text");
    i_10.setAttribute("onchange", "hesapla('price_other'," + row_count + ")");
    // i_6.setAttribute("class", "box");
    i_10.setAttribute("style", "width:30px")
    i_10.setAttribute("value", commaSplit(price));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_10);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    var sel = document.createElement("select");
    sel.setAttribute("name", "other_money_" + row_count)
    sel.setAttribute("id", "other_money_" + row_count)
    sel.setAttribute("onchange", "hesapla('other_money'," + row_count + ")")
    for (let index = 0; index < moneyArr.length; index++) {
        const element = moneyArr[index];
        var option = document.createElement("option");
        option.setAttribute("value", element.MONEY);
        option.innerText = element.MONEY;
        sel.appendChild(option)

    }
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(sel);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    var i_7 = document.createElement("input");
    i_7.setAttribute("name", "row_nettotal_" + row_count);
    i_7.setAttribute("id", "row_nettotal_" + row_count);
    i_7.setAttribute("type", "text");
    // i_7.setAttribute("class", "box");
    // i_7.setAttribute("style", "width:30px")
    var tutar = parseFloat(filterNum(price)) * qty;
    i_7.setAttribute("value", commaSplit(tutar));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_7);
    var span = document.createElement("span");
    span.setAttribute("class", "icon-search");
    span.setAttribute("onclick", "showData(this)");
    span.setAttribute("data-row", row_count);

    div.appendChild(span);
    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "display:none");
    td.setAttribute("class", "hiddenR");

    var i_8 = document.createElement("input");
    i_8.setAttribute("name", "Tax_" + row_count);
    i_8.setAttribute("id", "Tax_" + row_count);
    i_8.setAttribute("value", commaSplit(tax))



    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_8);
    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "display:none");
    td.setAttribute("class", "hiddenR");

    var i_9 = document.createElement("input");
    i_9.setAttribute("name", "indirim1_" + row_count);
    i_9.setAttribute("id", "indirim1_" + row_count);
    i_9.setAttribute("value", commaSplit(discount_rate))

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_9);
    td.appendChild(div);
    tr.appendChild(td);

    var bask = document.getElementById("tbl_basket");
    bask.appendChild(tr);
    hesapla("price", rowCount)
}

function selectRow(row) {
    rwww = row;
    var rrs = rwww.getAttribute("data-selected");
    if (parseInt(rrs) == 0) {
        rwww.setAttribute("style", "background-color:#ffaaaa80")
        rwww.setAttribute("data-selected", "1")
        selectedCount++;
    } else {
        rwww.setAttribute("style", "background-color:white")
        rwww.setAttribute("data-selected", "0")
        selectedCount--
    }
}

function getProductWithBarcode(ev, el, userid, dsn2, dsn1, dsn3) {
    var keyword = el.value;
    console.log(ev);
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;





    if (ev.keyCode == 13 || ev.type == 'change' || ev.key == '*') {
        if (ev.key == '*') {
            keyword = keyword.slice(0, keyword.length - 1)
        }
        $.ajax({
            url: "/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=getProduct",
            data: {
                keyword: keyword,
                userid: userid,
                dsn2: generalParamsSatis.dataSources.dsn2,
                dsn1: generalParamsSatis.dataSources.dsn1,
                dsn3: generalParamsSatis.dataSources.dsn3,
                price_catid: price_catid,
                comp_id: comp_id
            },
            success: function (retDat) {
                var obj = JSON.parse(retDat)
                console.log(obj)
                var rafKodu = prompt("Raf Kodu");
                var q = "select DISTINCT SHELF_CODE,PPR.PRODUCT_PLACE_ID,PPR.PRODUCT_ID,PP.STORE_ID,PP.LOCATION_ID,PPR.PRODUCT_ID,SL.DEPARTMENT_LOCATION from #dsn3#.PRODUCT_PLACE_ROWS AS PPR"
                q += " LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID "
                q += " LEFT JOIN workcube_test.STOCKS_LOCATION AS SL ON  SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID "
                q += "WHERE PPR.PRODUCT_ID=" + obj.PRODUCT.PRODUCT_ID + " AND SHELF_CODE='" + rafKodu + "'"
                var rafData = wrk_query(q, 'dsn3')
                if (rafData.recordcount != 0) {
                    AddRow(obj.PRODUCT.PRODUCT_ID, obj.PRODUCT.STOCK_ID, 0, 1, parseFloat(obj.PRODUCT.PRICE).toString(), obj.PRODUCT.PRODUCT_NAME, obj.PRODUCT.TAX, obj.PRODUCT.DISCOUNT_RATE);
                    el.value = '';
                    $(el).focus();
                } else {
                    if (generalParamsSatis.workingParams.IS_RAFSIZ == 0) {
                        alert("Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır");
                    } else {
                        alert("Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır Rafsız Kayıt Yapılacaktır");
                        AddRow(obj.PRODUCT.PRODUCT_ID, obj.PRODUCT.STOCK_ID, 0, 1, parseFloat(obj.PRODUCT.PRICE).toString(), obj.PRODUCT.PRODUCT_NAME, obj.PRODUCT.TAX, obj.PRODUCT.DISCOUNT_RATE);
                        el.value = '';
                        $(el).focus();
                    }
                }
                // GetShelves(obj.PRODUCT.PRODUCT_ID)
            }
        }
        )
    }


}



function selectrw(el) {
    rwwwx = el
    if ($(rwwwx).is(":checked")) {
        var ix = rwwwx.getAttribute("data-row")
        var rw = document.getElementById("row_" + ix)
        rw.setAttribute("style", "background-color:#aaefff80")
        rw.setAttribute("data-selected", 1)
        // selectedCount++;
        //   selectedArr.push(rw);
    } else {
        var ix = rwwwx.getAttribute("data-row")
        var rw = document.getElementById("row_" + ix)
        rw.setAttribute("style", "background-color:#fff")
        rw.setAttribute("data-selected", 0);
        //selectedCount--;
    }
    /*if (selectedCount == 1) {

    }*/
    BasketSelControl();
}

function BasketSelControl() {
    // selectedArr = []
    ///for(let i=0;i<selectedArr.length;)
    selectedArr.splice(0, selectedArr.length)
    var UpdCell = document.getElementById("UpdateButtonCell");
    var RemCell = document.getElementById("RemoveButtonCell");
    var TubeGroupCell = document.getElementById("TubeGroupButtonCell");
    $(UpdCell).hide();
    $(RemCell).hide();
    $(TubeGroupCell).hide();

    var sepetRows = document.getElementsByClassName("sepetRow")
    for (let i = 0; i < sepetRows.length; i++) {
        var sepetRow = sepetRows[i];
        var isSelected = sepetRow.getAttribute("data-selected")
        console.log(isSelected)
        if (parseInt(isSelected) == 1) {
            selectedArr.push(sepetRow)
        }
    }
    if (selectedArr.length == 1) {
        var e = selectedArr[0]
        var RwId = e.getAttribute("data-rc")
        var isVirt = $(e).find("#is_virtual_" + RwId).val()
        var pid = $(e).find("#product_id_" + RwId).val()
        if (parseInt(isVirt) == 1) {
            var btnUpdate = document.getElementById("UpdateRow");

            btnUpdate.setAttribute("onclick", "openHose(" + pid + "," + RwId + ")")
            $(UpdCell).show();

        }

    }
    $(RemCell).show();
}
function showData(el) {
    rwwwxy = el
    var row_id = el.getAttribute("data-row");
    var p_name = document.getElementById("product_name_" + row_id).value
    var tax = document.getElementById("Tax_" + row_id).value
    var disc = document.getElementById("indirim1_" + row_id).value
    openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=5&rowid=" + row_id + "&p_name=" + p_name + "&tax=" + tax + "&disc=" + disc)
}

function saveRowExtra(row_id) {
    // row_extra_tax_tax
    var rtax = document.getElementById("row_extra_tax_tax").value
    var rdisc = document.getElementById("row_extra_disc").value
    //var p_name = document.getElementById("product_name_" + row_id).value
    var tax = document.getElementById("Tax_" + row_id).value = commaSplit(rtax)
    var disc = document.getElementById("indirim1_" + row_id).value = commaSplit(rdisc)
    hesapla("price", row_id)
}

function hesapla(input, sira) {
    var price_ = filterNum($("#price_" + sira).val(), 8);

    var price_other_ = filterNum($("#price_other_" + sira).val(), 8);

    var amount_ = filterNum($("#amount_" + sira).val(), 8);
    //  var cost_ = $("#cost" + sira).val();
    //  var manuel_ = $("#manuel" + sira).val();
    var indirim1_ = filterNum($("#indirim1_" + sira).val(), 8);
    var money_ = $("#other_money_" + sira).val();
    var r1 = filterNum($("#_txt_rate1_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);
    var r2 = filterNum($("#_txt_rate2_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);

    $("#qs_basket tbody tr[data-rc='" + sira + "']").css("background-color", "white");
    if (list_find("price,other_money", input)) {
        price_other_ = (price_ * r1) / r2;
    }
    else if (input == "price_other") {
        price_ = (price_other_ * r2) / r1;
    }
    var newNettotal = (price_ * (100 - indirim1_) / 100) * amount_;
    /* if (parseFloat((price_ * (100 - indirim1_) / 100)) < parseFloat(cost_))
         $("#qs_basket tbody tr[data-rc='" + sira + "']").css("background-color", "##ffa2a2");
     else if (manuel_ == 1) {
         $("#qs_basket tbody tr[data-rc='" + sira + "']").css("background-color", "lightblue");
     }*/
    $("#price_other_" + sira).val(commaSplit(price_other_, 4));
    $("#price_" + sira).val(commaSplit(price_, 4));
    $("#row_nettotal_" + sira).val(commaSplit(newNettotal, 4));
    toplamHesapla();
}
function toplamHesapla() {
    var price_total_ = 0;
    var nettotal_total_ = 0;
    var tax_total_ = 0
    var tax_price_total_ = 0;
    for (let i = 1; i <= rowCount; i++) {
        if ($("#price_" + i).val()) {
            let price_ = filterNum($("#price_" + i).val(), 8);
            let price_other_ = filterNum($("#price_other_" + i).val(), 8);
            let amount_ = filterNum($("#amount_" + i).val(), 8);
            let indirim1_ = filterNum($("#indirim1_" + i).val(), 8);
            let tax_ = $("#Tax_" + i).val();
            let money_ = $("#other_money_" + i).val();
            let nettotal_ = filterNum($("#row_nettotal_" + i).val(), 8);
            let r1 = filterNum($("#_txt_rate1_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);
            let r2 = filterNum($("#_txt_rate2_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);

            price_total_ += parseFloat(price_);
            nettotal_total_ += parseFloat(nettotal_);
            tax_total_ += parseFloat(nettotal_) * (parseInt(tax_) / 100);
            tax_price_total_ += parseFloat(nettotal_) * (1 + (parseInt(tax_) / 100));
        }
    }
    $("#subTotal").val(commaSplit(nettotal_total_, 4));
    $("#subTaxTotal").val(commaSplit(tax_total_, 4));
    $("#subWTax").val(commaSplit(tax_price_total_, 4));
}

function GetShelves(Pid) {
    $.ajax({
        url: '/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=getProductShelves',
        data: {
            dsn3: generalParamsSatis.dataSources.dsn3,
            dsn: generalParamsSatis.dataSources.dsn,
            product_id: Pid,
            success: function (retDat) {
                console.log(retDat)
                //  var obj = JSON.parse(retDat)
                //console.log(obj)
            }
        }
    })
}

function UpdVirtualTube(dsn3, modal_id) {
    //var p_name = window.prompt("Ürün Adı")

    var d = $("#TubeForm").serialize();
    $.ajax({
        url: "/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=UpdVirtualTube",
        data: d + "&dsn3=" + generalParamsSatis.dataSources.dsn3,
        success: function (retDat) {
            console.log(retDat)
            var obj = JSON.parse(retDat)
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })

}

function UpdRow(pid, sid, is_virtual, qty, price, p_name, tax, discount_rate, row_id) {
    $("#product_id_" + row_id).val(pid)
    $("#stock_id_" + row_id).val(sid)
    $("#is_virtual_" + row_id).val(is_virtual)
    $("#amount_" + row_id).val(qty)
    $("#price_" + row_id).val(price)
    $("#product_name_" + row_id).val(p_name)
    $("#Tax_" + row_id).val(tax)
    $("#indirim1_" + row_id).val(discount_rate)
    hesapla("price", row_id)
}

function RemSelected() {
    for (let i = 0; i < selectedArr.length; i++) {
        $(selectedArr[i]).remove()

    }
    selectedArr.splice(0, selectedArr.length)
    rowArrange();
}

function rowArrange() {
    var rows = document.getElementsByClassName("sepetRow")
    for (let i = 0; i < rows.length; i++) {
        var NeWid = i + 1;
        var row = rows[i];
        var Old_rw_id = row.getAttribute("data-rc")
        console.log(Old_rw_id)


        row.setAttribute("id", "row_" + NeWid)
        row.setAttribute("data-selected", "0")
        row.setAttribute("data-rc", NeWid)

        var p_name = document.getElementById("product_name_" + Old_rw_id);

        p_name.setAttribute("id", "product_name_" + NeWid)
        p_name.setAttribute("name", "product_name_" + NeWid)

        var product_id = document.getElementById("product_id_" + Old_rw_id);
        product_id.setAttribute("id", "product_id_" + NeWid)
        product_id.setAttribute("name", "product_id_" + NeWid)

        var stock_id = document.getElementById("stock_id_" + Old_rw_id);
        stock_id.setAttribute("id", "stock_id_" + NeWid)
        stock_id.setAttribute("name", "stock_id_" + NeWid)

        var is_virtual = document.getElementById("is_virtual_" + Old_rw_id);
        is_virtual.setAttribute("id", "is_virtual_" + NeWid)
        is_virtual.setAttribute("name", "is_virtual_" + NeWid)

        var amount = document.getElementById("amount_" + Old_rw_id);
        amount.setAttribute("id", "amount_" + NeWid)
        amount.setAttribute("name", "amount_" + NeWid)
        /* Partner -Rev 000001*/
        var partner = 0;
        /* Partner -Rev 000001*/
        var price = document.getElementById("price_" + Old_rw_id);
        price.setAttribute("id", "price_" + NeWid)
        price.setAttribute("name", "price_" + NeWid)

        var other_money = document.getElementById("price_other_" + Old_rw_id);
        other_money.setAttribute("id", "other_money_" + NeWid)
        other_money.setAttribute("name", "other_money_" + NeWid)

        var row_nettotal = document.getElementById("row_nettotal_" + Old_rw_id);
        row_nettotal.setAttribute("id", "row_nettotal_" + NeWid)
        row_nettotal.setAttribute("name", "row_nettotal_" + NeWid)


        var SearchIcon = $(row).find(".icon-search")[0];
        SearchIcon.setAttribute("data-row", NeWid)

        var Tax = document.getElementById("Tax_" + Old_rw_id);
        Tax.setAttribute("id", "Tax_" + NeWid)
        Tax.setAttribute("name", "Tax_" + NeWid)

        var indirim1 = document.getElementById("indirim1_" + Old_rw_id);
        indirim1.setAttribute("id", "indirim1_" + NeWid)
        indirim1.setAttribute("name", "indirim1_" + NeWid)

    }
    row_count = rows.length;
    rowCount = rows.length;
}


function SaveTube(dsn3, modal_id) {
    var p_name = window.prompt("Ürün Adı")
    if (p_name.length > 0) {
        var d = $("#TubeForm").serialize();
        $.ajax({
            url: "/AddOns/Partner/Tests/cfc/hizli_satis.cfc?method=saveTube",
            data: d + "&product_name=" + p_name + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&dsn1=" + generalParamsSatis.dataSources.dsn1,
            success: function (retDat) {
                console.log(retDat)
                var obj = JSON.parse(retDat)
                AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0);
                closeBoxDraggable(modal_id)
            }
        })
    } else {
        saveVirtualTube()
    }
}



