function openProductPopup(question_id, from_row = 0) {
    var cp_id = document.getElementById("company_id").value;
    var cp_name = document.getElementById("company_id").value;

    var p_cat = document.getElementById("PRICE_CATID").value;
    var p_cat_id = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("http://erp.metosan.com.tr/index.cfm?fuseaction=objects.emptypopup_list_products_partner&price_cat=" + p_cat + "&PRICE_CATID=" + p_cat_id + "&company_id=" + cp_id + "&company_name=" + cp_name + "&question_id=" + question_id)
}

function setRow(product_id, stock_id, product_name, question_id, barcode, main_unit, price, quantity, discount, money) {
    console.log(arguments);
    $("#PRODUCT_NAME_" + question_id).val(product_name);
    $("#STOCK_ID_" + question_id).val(stock_id);
    $("#PRODUCT_ID_" + question_id).val(product_id);
    $("#PRICE_" + question_id).val(price);
    $("#BARKODE_" + question_id).val(barcode);
    $("#AMOUNT_" + question_id).val(quantity);
    $("#MAIN_UNIT_" + question_id).text(main_unit)
    $("#DISCOUNT_" + question_id).val(discount)
    $("#MONEY_" + question_id).val(discount)
    Hesapla(1)
}


function Hesapla(type) {
    var TotalPrice = 0;
    if (type == 1) {
        var questions = generalParamsSatis.Questions.filter(p => p.QUESTION_PRODUCT_TYPE == 1)
        questions.forEach(function (el, ix) {
            console.log(el.QUESTION_ID)
            console.log("PRICE_" + el.QUESTION_ID)
            var price = document.getElementById("PRICE_" + el.QUESTION_ID).value
            var quantity = document.getElementById("AMOUNT_" + el.QUESTION_ID).value
            var discount = document.getElementById("DISCOUNT_" + el.QUESTION_ID).value
            var money = document.getElementById("MONEY_" + el.QUESTION_ID).value
            if (price.length == 0) price = 0;
            if (quantity.length == 0) quantity = 0;
            if (discount.length == 0) discount = 0;
            var RATE2 = moneyArr.find(p => p.MONEY == money).RATE2
            quantity = filterNum(quantity);
            price = parseFloat(price)
            quantity = parseFloat(quantity)
            discount = parseFloat(discount)
            console.log("Price=" + price + " Quantity=" + quantity + " Discount=" + discount)
            TotalPrice += TutarHesapla(price, quantity, discount, RATE2)
            console.log(DegerLeriHesapla(price, quantity, discount))


        })
    }
    if (type == 2) {
        for (let i = 1; i < hyd_basket_rows; i++) {
            var PRICE = $("#PRICE_" + i).val()
            var DISCOUNT = $("#DISCOUNT_" + i).val()
            var MONEY = $("#MONEY_" + i).val()
            var AMOUNT = $("#AMOUNT_" + i).val()
            AMOUNT = parseFloat(filterNum(commaSplit(AMOUNT)))
            DISCOUNT = parseFloat(filterNum(commaSplit(DISCOUNT)))
            PRICE = parseFloat(filterNum(commaSplit(PRICE)))
            var RATE2 = moneyArr.find(p => p.MONEY == MONEY).RATE2
            console.log(RATE2)
            var TOTAL_PRICE = TutarHesapla(PRICE, AMOUNT, DISCOUNT, RATE2)
            TotalPrice += TOTAL_PRICE
        }

        document.getElementById("total_price").value = TotalPrice;
    }
}


function TutarHesapla(price, quantity, discount, rate2) {

    var return_value = price * quantity;
    return_value = return_value - ((return_value * discount) / 100);
    return_value = return_value * rate2;
    return return_value;

}

function GetBasketData() {
    var questions = generalParamsSatis.Questions.filter(p => p.QUESTION_PRODUCT_TYPE == 1)
    var row_data = new Array();
    questions.forEach(function (value, key) {
        console.log(value)
        var question_id = value.QUESTION_ID
        var product_id = $("#PRODUCT_ID_" + question_id).val()
        var stock_id = $("#STOCK_ID_" + question_id).val()
        var amount = $("#AMOUNT_" + question_id).val()
        var price = $("#PRICE_" + question_id).val()
        var discount = $("#DISCOUNT_" + question_id).val()
        if (product_id.length > 0) {
            amount = parseFloat(filterNum(commaSplit(amount)))
            price = parseFloat(filterNum(commaSplit(price)))
            discount = parseFloat(filterNum(commaSplit(discount)))
            var obj = {
                QUESTION_ID: question_id,
                ROW_DATA: {
                    PRODUCT_ID: product_id,
                    STOCK_ID: stock_id,
                    AMOUNT: amount,
                    PRICE: price,
                    DISCOUNT: discount
                }
            }
            row_data.push(obj)
        }
    })
    var tprice = document.getElementById("total_price").value;
    var main_product_id = $("#main_product_id").val();
    var UNIQUE_RELATION_ID = $("#UNIQUE_RELATION_ID").val();
    var product_type = $("#product_type").val();
    var offer_row_id = $("#offer_row_id").val();
    tprice = parseFloat(filterNum(commaSplit(tprice)))
    var form_data = {
        TotalPrice: tprice,
        row_data: row_data,
        main_product_id: main_product_id,
        UNIQUE_RELATION_ID: UNIQUE_RELATION_ID,
        product_type: product_type,
        offer_row_id: offer_row_id,
        product_type: 1,
        rows: ""

    }
    return form_data;
}

function GetBasketDataHydrolik() {
    var row_data = new Array();
    for (let i = 1; i < hyd_basket_rows; i++) {
        var PRODUCT_NAME = $("#PRODUCT_NAME_" + i).val()
        var STOCK_ID = $("#STOCK_ID_" + i).val()
        var PRODUCT_ID = $("#PRODUCT_ID_" + i).val()
        var PRICE = $("#PRICE_" + i).val()
        var DISCOUNT = $("#DISCOUNT_" + i).val()
        var MONEY = $("#MONEY_" + i).val()
        var AMOUNT = $("#AMOUNT_" + i).val()
        AMOUNT = parseFloat(filterNum(commaSplit(AMOUNT)))
        DISCOUNT = parseFloat(filterNum(commaSplit(DISCOUNT)))
        PRICE = parseFloat(filterNum(commaSplit(PRICE)))
        obj = {
            PRODUCT_NAME: PRODUCT_NAME,
            STOCK_ID: STOCK_ID,
            PRODUCT_ID: PRODUCT_ID,
            PRICE: PRICE,
            DISCOUNT: DISCOUNT,
            MONEY: MONEY,
            AMOUNT: AMOUNT
        }
        row_data.push(obj)
        //console.log(obj)
    }
    console.log(row_data)
    var tprice = document.getElementById("total_price").value;
    var main_product_id = $("#main_product_id").val();
    var UNIQUE_RELATION_ID = $("#UNIQUE_RELATION_ID").val();
    var product_type = $("#product_type").val();
    var offer_row_id = $("#offer_row_id").val();
    tprice = parseFloat(filterNum(commaSplit(tprice)))
    var form_data = {
        TotalPrice: tprice,
        row_data: row_data,
        main_product_id: main_product_id,
        UNIQUE_RELATION_ID: UNIQUE_RELATION_ID,
        product_type: product_type,
        offer_row_id: offer_row_id,
        product_type: 1,
        rows: hyd_basket_rows - 1

    }
    return form_data;
}


function saveVirtual(Ptype) {
    if (Ptype == 1) {
        var BasketData = GetBasketData();
    }
    if (Ptype == 2) {
        var BasketData = GetBasketDataHydrolik();
    }
    var mapForm = document.createElement("form");
    mapForm.target = "Map";
    mapForm.method = "POST"; // or "post" if appropriate
    mapForm.action = "/index.cfm?fuseaction=sales.emptypopup_update_virtual_product";

    var mapInput = document.createElement("input");
    mapInput.type = "hidden";
    mapInput.name = "data";
    mapInput.value = JSON.stringify(BasketData);
    console.log(BasketData);
    mapForm.appendChild(mapInput);

    document.body.appendChild(mapForm);

    map = window.open("/index.cfm?fuseaction=sales.emptypopup_update_virtual_product", "Map", "status=0,title=0,height=600,width=800,scrollbars=1");

    if (map) {
        mapForm.submit();
    } else {
        alert('You must allow popups for this map to work.');
    }
}


function findHydrolic(ev, el) {
    var keyword = el.value;
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    if (ev.keyCode == 13) {
        var Product = getProductMultiUse(keyword, comp_id, price_catid);
        el.value = '';
        addHydrolikRow(Product, keyword);
        $(el).focus();
    }
}

function getProductMultiUse(keyword, comp_id, price_catid) {
    var new_query = new Object();
    var req;

    function callpage(url) {
        req = false;
        if (window.XMLHttpRequest)
            try {
                req = new XMLHttpRequest();
            }
        catch (e) {
            req = false;
        } else if (window.ActiveXObject)
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            }
        catch (e) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
                req = false;
            }
        }
        if (req) {
            function return_function_() {
                console.log(req)
                if (req.readyState == 4 && req.status == 200) {

                    JSON.parse(req.responseText.replace(/\u200B/g, ''));
                    new_query = JSON.parse(req.responseText.replace(/\u200B/g, ''));
                }
            }
            req.open("post", url + '&xmlhttp=1', false);
            req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setRequestHeader('pragma', 'nocache');

            req.send("keyword=" + keyword + "&userid=" + generalParamsSatis.userData.user_id + "&dsn2=" + generalParamsSatis.dataSources.dsn2 + "&dsn1=" + generalParamsSatis.dataSources.dsn1 + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&price_catid=" + price_catid + "&comp_id=" + comp_id);
            return_function_();
        }

    }

    //TolgaS 20070124 objects yetkisi olmayan partnerlar var diye fuseaction objects2 yapildi
    callpage('/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProduct');
    //alert(new_query);

    return new_query;
}


function addHydrolikRow(product, barcode) {

    var basket = document.getElementById("basketim")
    if (product.RECORDCOUNT > 0) {

        var tr = document.createElement("tr")
        var td = document.createElement("td")
        tr.appendChild(td)
        var td = document.createElement("td")

        var div1 = document.createElement("div");
        div1.setAttribute("class", "form-group")
        var div2 = document.createElement("div");
        div2.setAttribute("class", "input-group")
        var input1 = document.createElement("input")
        input1.value = product.PRODUCT.PRODUCT_NAME;
        input1.setAttribute("id", "PRODUCT_NAME_" + hyd_basket_rows);
        input1.setAttribute("name", "PRODUCT_NAME_" + hyd_basket_rows);
        input1.setAttribute("type", "text")
        var spn = document.createElement("span");
        spn.setAttribute("class", "input-group-addon btnPointer icon-ellipsis")
        spn.setAttribute("onclick", "openProductPopup(" + hyd_basket_rows + ")")
        var input2 = document.createElement("input")
        input2.setAttribute("type", "hidden")
        input2.setAttribute("name", "PRODUCT_ID_" + hyd_basket_rows)
        input2.setAttribute("id", "PRODUCT_ID_" + hyd_basket_rows)
        input2.value = product.PRODUCT.PRODUCT_ID
        var input3 = document.createElement("input")
        input3.setAttribute("type", "hidden")
        input3.setAttribute("name", "STOCK_ID_" + hyd_basket_rows)
        input3.setAttribute("id", "STOCK_ID_" + hyd_basket_rows)
        input3.value = product.PRODUCT.STOCK_ID
        var input4 = document.createElement("input")
        input4.setAttribute("type", "hidden")
        input4.setAttribute("name", "PRICE_" + hyd_basket_rows)
        input4.setAttribute("id", "PRICE_" + hyd_basket_rows)
        input4.value = product.PRODUCT.PRICE
        var input5 = document.createElement("input")
        input5.setAttribute("type", "hidden")
        input5.setAttribute("name", "DISCOUNT_" + hyd_basket_rows)
        input5.setAttribute("id", "DISCOUNT_" + hyd_basket_rows)
        input5.value = product.PRODUCT.DISCOUNT_RATE
        var input6 = document.createElement("input")
        input6.setAttribute("type", "hidden")
        input6.setAttribute("name", "MONEY_" + hyd_basket_rows)
        input6.setAttribute("id", "MONEY_" + hyd_basket_rows)
        input6.value = product.PRODUCT.MONEY;

        div2.appendChild(input1)
        div2.appendChild(input2)
        div2.appendChild(input3)
        div2.appendChild(input4)
        div2.appendChild(input5)
        div2.appendChild(input6)

        div2.appendChild(spn)
        div1.append(div2)
        td.appendChild(div1)
        tr.appendChild(td)
        var td = document.createElement("td")
        var div1 = document.createElement("div");
        div1.setAttribute("class", "form-group")
        var input1 = document.createElement("input")
        input1.value = barcode; //  fonksiyonYapıldığında fonksiyondaki keyword gelecek
        input1.setAttribute("id", "BARKODE_" + hyd_basket_rows);
        input1.setAttribute("name", "BARKODE_" + hyd_basket_rows);
        input1.setAttribute("type", "text")
        div1.appendChild(input1)
        td.appendChild(div1)
        tr.appendChild(td)
        var td = document.createElement("td")
        var div1 = document.createElement("div");
        div1.setAttribute("class", "form-group")
        var input1 = document.createElement("input")
        input1.value = commaSplit(1);
        input1.setAttribute("id", "AMOUNT_" + hyd_basket_rows);
        input1.setAttribute("name", "AMOUNT_" + hyd_basket_rows);
        input1.setAttribute("type", "text")
        input1.setAttribute("onchange", "this.value=commaSplit(this.value)");
        div1.appendChild(input1)
        td.appendChild(div1)
        tr.appendChild(td)
        var td = document.createElement("td")
        var spn = document.createElement("span");
        spn.innerText = product.PRODUCT.MAIN_UNIT;
        spn.setAttribute("id", "MAIN_UNIT_" + hyd_basket_rows)
        td.appendChild(spn)
        tr.appendChild(td)
        console.log(tr)
        basketim.appendChild(tr)
        hyd_basket_rows++;
    }
    Hesapla(2);
}