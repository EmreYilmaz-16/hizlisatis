function openHose(id = "", row_id = "") {
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=1&row_id=" + row_id)
}

function FindProduct(ev, el, userid, dsn2, dsn1, dsn3, price_catid, comp_id) {
    var keyword = el.value;
    var elemanAtt = el.getAttribute("data-type");
    var pidElem = document.getElementById(elemanAtt + "_PId")
    var sidElem = document.getElementById(elemanAtt + "_SId")
    var NameElem = document.getElementById(elemanAtt + "_lbs")
    var priceElem = document.getElementById(elemanAtt + "_Prc")
    var discountElem = document.getElementById(elemanAtt + "_DSC")
    var PC_ELEM = document.getElementById("PRODUCT_CAT")
    var PCID_ELEM = document.getElementById("PRODUCT_CATID")
    var PCHIE_ELEM = document.getElementById("HIEARCHY")
    console.log(pidElem);
    console.log(sidElem);
    console.log(NameElem);
    console.log(priceElem);
    console.log(ev)
    if (elemanAtt == "Tube") {
        //var q=wrk_query()
    }
    if ((ev.keyCode == 13 || ev.type == 'change') && keyword.length>5 ) {

        var Product = getProductMultiUse(keyword, comp_id, price_catid);
        if (Product.RECORDCOUNT != 0) {
            pidElem.value = Product.PRODUCT.PRODUCT_ID;
            sidElem.value = Product.PRODUCT.STOCK_ID;
            NameElem.innerText = Product.PRODUCT.PRODUCT_NAME;
            discountElem.value = Product.PRODUCT.DISCOUNT_RATE;
            priceElem.value = Product.PRODUCT.PRICE;
            if (elemanAtt == "Tube") {
                console.log(Product.PRODUCT.REL_CATNAME)
                PC_ELEM.value = Product.PRODUCT.REL_CATNAME
                PCID_ELEM.value = Product.PRODUCT.REL_CATID
                PCHIE_ELEM.value = Product.PRODUCT.REL_HIERARCHY
            }
            CalculateTube()
        } else {
            NameElem.innerText = "Ürün Bulunamadı";
        }


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


    var LRekor_DSC = document.getElementById("LRekor_DSC").value
    var Tube_DSC = document.getElementById("Tube_DSC").value
    var RRekor_DSC = document.getElementById("RRekor_DSC").value
    var AdditionalProduct_DSC = document.getElementById("AdditionalProduct_DSC").value
    var working_DSC = document.getElementById("working_DSC").value
    var Kabuk_DSC = document.getElementById("Kabuk_DSC").value



    var LRekor_Qty = document.getElementById("LRekor_Qty").value
    var Tube_Qty = document.getElementById("Tube_Qty").value
    var RRekor_Qty = document.getElementById("RRekor_Qty").value
    var AdditionalProduct_Qty = document.getElementById("AdditionalProduct_Qty").value
    var Kabuk_Qty = document.getElementById("Kabuk_Qty").value
    var working_Qty = document.getElementById("working_Qty").value
    var marj = document.getElementById("marj").value

    var maliyet = document.getElementById("maliyet")
    var TotalValue=0;
    
     TotalValue+=DegerLeriHesapla(LRekor_Prc,LRekor_DSC,LRekor_Qty);
     TotalValue+=DegerLeriHesapla(RRekor_Prc,RRekor_Qty,RRekor_DSC);
     TotalValue+=DegerLeriHesapla(Tube_Prc,Tube_DSC,Tube_Qty);
     TotalValue+=DegerLeriHesapla(AdditionalProduct_Prc,AdditionalProduct_DSC,AdditionalProduct_Qty);
     TotalValue+=DegerLeriHesapla(working_Prc,working_DSC,working_Qty);
     TotalValue+=DegerLeriHesapla(Kabuk_Prc,Kabuk_DSC,Kabuk_Qty);

   // var Tf = (parseFloat(LRekor_Prc) * parseFloat(LRekor_Qty)) + (parseFloat(RRekor_Prc) * parseFloat(RRekor_Qty)) + (parseFloat(Tube_Prc) * parseFloat(Tube_Qty)) + (parseFloat(AdditionalProduct_Prc) * parseFloat(AdditionalProduct_Qty));
    
    var Tf=TotalValue;
    //Tf = Tf + (parseFloat(working_Prc) * parseFloat(working_Qty)) + (parseFloat(Kabuk_Prc) * parseFloat(Kabuk_Qty))
    Tf = Tf + ((Tf * parseFloat(marj)) / 100)
    maliyet.value = commaSplit(Tf, 2);
}

function DegerLeriHesapla(p,d,q){
   var price=parseFloat(p);
   var discount=parseFloat(d);
   var quantity=parseFloat(q);

   var a=price-((price*discount)/100);
   var b=a*quantity;
   return b;
}

function calculateTubeRow(el) {
    var qty = el.value;
    CalculateTube()
}

function saveVirtualTube(dsn3, modal_id) {
    //var p_name = window.prompt("Ürün Adı")

    var p_name = SetName(1)

    var d = $("#TubeForm").serialize();
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveVirtualTube",
        data: d + "&product_name=" + p_name + "&dsn3=" + generalParamsSatis.dataSources.dsn3+"&employee_id="+generalParamsSatis.userData.user_id,
        success: function (retDat) {
            console.log(retDat)
            var obj = JSON.parse(retDat)
          
           AddRow(
            obj.PID,
            0,
            '',
            '',
            1,
            1,
            obj.PRICE,
            obj.NAME,
            20,
            0,
            1,
            '',
            'TL',
            obj.PRICE,
            "-5",
             0,
             0,
            'Adet',
            '',
            '',
             1,
             '',
             '',
            is_production = 1
        )

            closeBoxDraggable(modal_id)
        }
    })

}
function SetName(type, message = "Ürün Adı", old_name = "") {
    let name = old_name;
    var newName = ""
    if (generalParamsSatis.workingParams.IS_RANDOM_UNIQE_NAME == 1) {

        var d = new Date()
        var t = parseInt((d - 1) / 1)
        if (type == 1) {
            name = "Hortum-" + t
        }
        if (type == 2) {
            name = "Hidrolik-" + t
        }

    } else {
        name = prompt(message, old_name);
        debugger;
        if (name.trim().length > 0) {
            debugger;
            if (generalParamsSatis.workingParams.IS_SAME_VIRTUAL_NAME == 0) {
                while (true) {
                    name = prompt("Ürün Adı Kullanılmıştır \n Ürün Adı:")
                    var r = wrk_query("SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE PRODUCT_NAME='" + name + "'", "dsn3")
                    if (r.recordcount == 0) {
                        break;
                    }
                }
            }
        } else {
            while (name.length == 0) {
                name = prompt("Ürün Adı Boş Olamaz \n Ürün Adı:")
                if (name != null) {
                    console.warn("ok")
                } else {
                    name = "";
                }
            }
            if (generalParamsSatis.workingParams.IS_SAME_VIRTUAL_NAME == 0) {
                while (true) {
                    name = prompt("Ürün Adı Kullanılmıştır \n Ürün Adı:")
                    var r = wrk_query("SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE PRODUCT_NAME='" + name + "'", "dsn3")
                    if (r.recordcount == 0) {
                        break;
                    }
                }
            }
        }
    }
    return name;
}
function UpdVirtualTube(dsn3, modal_id) {
    //var p_name = window.prompt("Ürün Adı")

    var d = $("#TubeForm").serialize();
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=UpdVirtualTube",
        data: d + "&dsn3=" + generalParamsSatis.dataSources.dsn3+"&employee_id="+generalParamsSatis.userData.user_id,
        success: function (retDat) {
            console.log(retDat)
            var obj = JSON.parse(retDat)
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 20, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })

}




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
            AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 20, 0, 2, '', 'TL', obj.PRICE);
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
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 20, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })
}