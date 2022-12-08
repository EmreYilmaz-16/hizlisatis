

function openHydrolic(id = "", row_id = "", tr = 0) {
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    if (tr == 0) {
        openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=2&row_id=" + row_id)
    } else {
        openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=2&row_id=" + row_id)
    }

}


function findHydrolic(ev, el) {
    var keyword = el.value;
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    if (ev.keyCode == 13) {
        var Product = getProductMultiUse(keyword, comp_id, price_catid);
        if (Product.RECORDCOUNT != 0) {
            var rw = $("#tblBaskHyd").find("input[value=" + Product.PRODUCT.PRODUCT_ID + "]").parent().parent()
            if (rw.length != 0) {
                if (generalParamsSatis.workingParams.IS_ADD_QUANTITY == 0) {
                    addHydrolicRow(Product)
                } else {
                    if (Product.PRODUCT.MAIN_UNIT == "Adet") {
                        var iid = rw.attr("data-row")
                        var e = rw.find("#quantity_" + iid).val()
                        var ev = parseFloat(filterNum(e))
                        ev++;
                        rw.find("#quantity_" + iid).val(commaSplit(ev))
                    } else {
                        addHydrolicRow(Product)
                    }
                }
            } else {
                addHydrolicRow(Product)
            }
            CalculatehydrolicRow(hydRowCount);
        }
        el.value = '';
        $(el).focus();
    }
}

function addHydrolicRow(Product) {
    hydRowCount++
    var Tbl = document.getElementById("tblBaskHyd")
    var tr = document.createElement("tr")
    tr.setAttribute("data-row", hydRowCount)
    tr.setAttribute("id", "hydRow" + hydRowCount);
    var td = document.createElement("td")
    var i = document.createElement("i")
    i.setAttribute("class", "icn-md icon-minus")
    i.setAttribute("onclick", "removeRow(this," + hydRowCount + ")");
    td.innerText = hydRowCount;
    tr.appendChild(td)

    var td = document.createElement("td")
    var input = document.createElement("input")
    input.setAttribute("type", "hidden")
    input.setAttribute("name", "product_id_" + hydRowCount)
    input.setAttribute("id", "product_id_" + hydRowCount)
    input.setAttribute("value", Product.PRODUCT.PRODUCT_ID)
    td.appendChild(input)

    var input = document.createElement("input")
    input.setAttribute("type", "hidden")
    input.setAttribute("name", "stock_id_" + hydRowCount)
    input.setAttribute("id", "stock_id_id_" + hydRowCount)
    input.setAttribute("value", Product.PRODUCT.STOCK_ID)
    td.appendChild(input)

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");

    var input = document.createElement("input")
    input.setAttribute("type", "text")
    input.setAttribute("name", "product_name_" + hydRowCount)
    input.setAttribute("id", "product_name_" + hydRowCount)
    input.setAttribute("value", Product.PRODUCT.PRODUCT_NAME)
    input.setAttribute("readonly", "true")
    div.appendChild(input)
    td.appendChild(div)
    tr.appendChild(td)

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");

    var td = document.createElement("td")
    td.setAttribute("style", "width:10%")
    var input = document.createElement("input")
    input.setAttribute("type", "text")
    input.setAttribute("name", "quantity_" + hydRowCount)
    input.setAttribute("id", "quantity_" + hydRowCount)
    input.setAttribute("value", commaSplit(1))
    input.setAttribute("class", "prtMoneyBox")
    input.setAttribute("onchange", "CalculatehydrolicRow(" + hydRowCount + ")")
    input.setAttribute("onClick", "sellinputAllVal(this)")
    div.appendChild(input)
    td.appendChild(div)
    tr.appendChild(td)

    var td = document.createElement("td")
    td.setAttribute("style", "width:15%")
    var input = document.createElement("input")
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    input.setAttribute("type", "text")
    input.setAttribute("name", "price_" + hydRowCount)
    input.setAttribute("class", "prtMoneyBox")
    input.setAttribute("id", "price_" + hydRowCount)
    input.setAttribute("onchange", "CalculatehydrolicRow(" + hydRowCount + ")")
    input.setAttribute("onclick", "sellinputAllVal(this)")
    input.setAttribute("value", commaSplit(Product.PRODUCT.PRICE))
    div.appendChild(input)
    td.appendChild(div)
    tr.appendChild(td)

    var td = document.createElement("td")
    td.setAttribute("style", "width:10%")
    var input = document.createElement("input")
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    input.setAttribute("type", "text")
    input.setAttribute("readonly", "true")
    input.setAttribute("class", "prtMoneyBox")
    input.setAttribute("name", "money_" + hydRowCount)
    input.setAttribute("id", "money_" + hydRowCount)
    input.setAttribute("value", Product.PRODUCT.MONEY)
    div.appendChild(input)
    td.appendChild(div)
    tr.appendChild(td)


    var td = document.createElement("td")
    td.setAttribute("style", "width:17%")
    var input = document.createElement("input")
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    input.setAttribute("type", "text")
    input.setAttribute("readonly", "true")
    input.setAttribute("name", "netT_" + hydRowCount)
    input.setAttribute("id", "netT_" + hydRowCount)
    input.setAttribute("class", "prtMoneyBox")
    input.setAttribute("value", Product.PRODUCT.PRICE)
    div.appendChild(input)
    td.appendChild(div)
    tr.appendChild(td)

    Tbl.appendChild(tr)
}

function saveVirtualHydrolic(modal_id) {
    var pname = SetName(2) //prompt("Ürün Adı");
    $("#hydRwc").val(hydRowCount);
    $("#hydProductName").val(pname);
    var formData = getFormData($("#HydrolicForm"));
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveVirtualHydrolic",
        data: formData,
        success: function (retDat) {

            var obj = JSON.parse(retDat)
            AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, 2, '', 'TL', obj.PRICE);
            closeBoxDraggable(modal_id)
        }
    })

}

function UpdateVirtualHydrolic(modal_id) {
    $("#hydRwc").val(hydRowCount);

    var formData = getFormData($("#HydrolicForm"));
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=updateVirtualHydrolic",
        data: formData,
        success: function (retDat) {

            var obj = JSON.parse(retDat)
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })
}