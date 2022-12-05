var HataArr = [];
var row_count = 0;
var rwww = "";
var rwwwx = "";
var rwwwxy = "";
var selectedCount = 0;
var rowCount = 0;
var tempProductData = "";
var selectedArr = [];
var CompanyData = new Object();
/*
##########    Basket Fonksiyonları    ############

openHose                ----Hortum Kaydetme Penceresi
FindProduct             ----Ürün Bul
CalculateTube           ----Hortumum Fiyatını Hesaplar
saveVirtualTube         ----Sanal Hortum Kaydeder
AddRow                  ----Sepete Satır Ekle
selectRow               ----Satır Seçme
getProductWithBarcode   ----Barkodla Ürün Getirme
selectrw                ----Satır Seçme Yeni
BasketSelControl        ----Seçili Eleman Kontrolü  #Hortum Gurubu Ve Diğer İşlemler İçin Kontroller Eklenmeye Devam Edecek
showData                ----Satırda Gözükmeyen Verileri Gösterir
saveRowExtra            ----Extra Bilgiyi Satıra Yazar
hesapla                 ----Sepeti Hesaplar
toplamHesapla           ----Alt Toplamları Hesaplar
GetShelves              ----Raf Getirmek İçin
UpdVirtualTube          ----Sanal Ürün Güncelle
UpdRow                  ----Sepet Satırı Güncelleme
RemSelected             ----Sepette Seçili Olanları Siler
rowArrange              ----Satır Numaralarını Yeniden Düzenler
SaveTube                ----Gerçek Ürün Kayıt Eder 
TubeControl             ----Gerçek Ürün Kayıt Ederken Kontrolleri Yapar
HataGosterClick         ----Hata Penceresinin Clickleri Buraya Yazılacak
openHydrolic            ----Hidrolik Kaydetme Penceresi
findHydrolic            ----Ürün Bul
addHydrolicRow          ----Hidrolik Sepetine Ürün Ekler
saveVirtualHydrolic     ----Sanal Hidrolik Kaydetme
updateVirtualHydrolic   ----Sanal Hidrolik Güncelleme
getFormData             ----Form Datasını JSONA Çevirir
CalculatehydrolicRow    ----Hidrolik Satır Tutarını Hesaplar
CalculateHydSub         ----Hidrolik Basket Toplamını Hesaplar
SetName                 ----Genel Sanal Ürün İsmi Verme
saveOrder               ----Siparişi Kayıt Etme ve Güncelleme

*/

/**
 * 
 *@description {closeBoxDraggable} Kapator
 *@function {closeBoxDraggable} kapatmaya yarar
 */


$(document).ready(function () {
    $("#barcode").focus()
    /* var w = window.innerWidth
     var x = (w / 3) - 31;
     $(".pbs_v").attr("style", "width:" + x + "px !important")*/
    RowControlForVirtual()
    var page_event = getParameterByName("event");

    console.log(page_event);
    if (page_event == 'add' || page_event == null) {
        if (generalParamsSatis.workingParams.IS_ALL_SEVK == 1) {
            document.getElementById("sales_type_1").setAttribute("checked", "true");
            document.getElementById("sevkiyat").setAttribute("checked", "true");
            document.getElementById("siparis").setAttribute("checked", "true");
            document.getElementById("snl_teklif").setAttribute("checked", "true");
            $("#sales_type_m").show();
        }
    }

})

/**
 * 
 * @param {*} id 
 * @param {*} row_id 
 */
function openHose(id = "", row_id = "") {
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    openBoxDraggable("index.cfm?fuseaction=product.emptypopup_virtual_main_partner&page=3&id=" + id + "&price_catid=" + price_catid + "&comp_id=" + comp_id + "&type=1&row_id=" + row_id)
}


/**
 * Finds a product.
 *
 * @class      FindProduct (name)
 * @param      {<type>}  ev           { parameter_description }
 * @param      {<type>}  el           { parameter_description }
 * @param      {<type>}  userid       The userid
 * @param      {<type>}  dsn2         The dsn 2
 * @param      {<type>}  dsn1         The dsn 1
 * @param      {<type>}  dsn3         The dsn 3
 * @param      {<type>}  price_catid  The price catid
 * @param      {<type>}  comp_id      The component identifier
 */
function FindProduct(ev, el, userid, dsn2, dsn1, dsn3, price_catid, comp_id) {
    var keyword = el.value;
    var elemanAtt = el.getAttribute("data-type");
    /**
     * Ürün Id Elemanı 
     * @type HTMLELEMENT
     */
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
    if (ev.keyCode == 13 || ev.type == 'change') {

        var Product = getProductMultiUse(keyword, comp_id, price_catid);
        if (Product.RECORDCOUNT != 0) {
            pidElem.value = Product.PRODUCT.PRODUCT_ID;
            sidElem.value = Product.PRODUCT.STOCK_ID;
            discountElem.value = Product.PRODUCT.DISCOUNT_RATE;
            NameElem.innerText = Product.PRODUCT.PRODUCT_NAME;
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


/**
 * Calculates the tube.
 *
 * @class      CalculateTube (name)
 */
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
    
    var TotalValue+=DegerLeriHesapla(LRekor_Prc,LRekor_DSC,LRekor_Qty);
    var TotalValue+=DegerLeriHesapla(RRekor_Prc,RRekor_Qty,RRekor_DSC);
    var TotalValue+=DegerLeriHesapla(Tube_Prc,Tube_DSC,Tube_Qty);
    var TotalValue+=DegerLeriHesapla(AdditionalProduct_Prc,AdditionalProduct_DSC,AdditionalProduct_Qty);
    var TotalValue+=DegerLeriHesapla(working_Prc,working_DSC,working_Qty);
    var TotalValue+=DegerLeriHesapla(Kabuk_Prc,Kabuk_DSC,Kabuk_Qty);

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
        data: d + "&product_name=" + p_name + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&employee_id=" + generalParamsSatis.userData.user_id,
        success: function (retDat) {
            console.log(retDat)
            var obj = JSON.parse(retDat)
            AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, 1, '', "TL", obj.PRICE, "-5");
          
            closeBoxDraggable(modal_id)

        }
    })

}

/**
 * 
 * @param {*} pid Ürün Idsi
 * @param {*} sid Stok Idsi
 * @param {*} is_virtual Sanal Ürünmü
 * @param {*} qty Miktar
 * @param {*} price Fiyat
 * @param {*} p_name Ürün Adı
 * @param {*} tax Vergi
 * @param {*} discount_rate İndirim Orano
 * @param {*} poduct_type Ürün Tipi 1-Hortum  2-Hidrolik 3-Pompa
 * @param {*} shelf_code Raf Kodu
 * @param {*} omoney Doviz 
 * @param {*} price_other Doviz Fiyat
 * @param {*} currency Satır Aşaması
 * @param {*} is_manuel Manuelmi
 * @param {*} cost Maliyet
 */
function AddRow(pid, sid, is_virtual, qty, price, p_name, tax, discount_rate, poduct_type = 0, shelf_code = '', omoney = 'TL', price_other, currency = "-6", is_manuel = 0, cost = 0) {
    row_count++;
    rowCount = row_count;
    console.log(arguments)
    var form = $(document);
    var checkedValue = form.find("input[name=_rd_money]:checked").val();
    var BASKET_MONEY = document.getElementById("_hidden_rd_money_" + checkedValue).value
    console.log(BASKET_MONEY)
    /*if (omoney != BASKET_MONEY) {
        price_other = price;
        var rsss = moneyArr.find(p => p.MONEY == omoney)
        price = price * rsss.RATE2
    }*/
    var rsss = moneyArr.find(p => p.MONEY == omoney)
    var prc = price_other * rsss.RATE2

    var tr = document.createElement("tr");
    if (is_manuel && generalParamsSatis.workingParams.MANUEL_CONTROL) {
        tr.setAttribute("style", "background-color:#86b5ff75")
    }
    tr.setAttribute("id", "row_" + row_count)
    tr.setAttribute("data-selected", "0")
    tr.setAttribute("data-rc", row_count)
    tr.setAttribute("data-ProductType", poduct_type)
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

    var i_4 = document.createElement("input");
    i_4.setAttribute("name", "shelf_code_" + row_count);
    i_4.setAttribute("id", "shelf_code_" + row_count);
    i_4.setAttribute("type", "hidden");
    i_4.setAttribute("value", shelf_code);

    var i_5 = document.createElement("input");
    i_5.setAttribute("name", "cost_" + row_count);
    i_5.setAttribute("id", "cost_" + row_count);
    i_5.setAttribute("type", "hidden");
    i_5.setAttribute("value", cost);

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
    td.appendChild(i_4);
    td.appendChild(i_5);
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
    td.setAttribute("style", "width:15%")
    var i_5 = document.createElement("input");
    i_5.setAttribute("name", "amount_" + row_count);
    i_5.setAttribute("id", "amount_" + row_count);
    i_5.setAttribute("type", "text");
    // i_5.setAttribute("class", "box");
    i_5.setAttribute("style", "width:20px")
    i_5.setAttribute("value", commaSplit(qty, 2));
    i_5.setAttribute("onchange", "hesapla('price'," + row_count + ")");
    i_5.setAttribute("onClick", "sellinputAllVal(this)")
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_5);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "width:15%")
    var i_6 = document.createElement("input");
    i_6.setAttribute("name", "price_" + row_count);
    i_6.setAttribute("id", "price_" + row_count);
    i_6.setAttribute("type", "text");
    i_6.setAttribute("onchange", "hesapla('price'," + row_count + ")");
    i_6.setAttribute("onClick", "sellinputAllVal(this)")
    // i_6.setAttribute("class", "box");
    i_6.setAttribute("style", "width:30px")
    i_6.setAttribute("value", commaSplit(prc, 2));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_6);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "display:none");
    td.setAttribute("class", "hiddenR");

    var i_10 = document.createElement("input");
    i_10.setAttribute("name", "price_other_" + row_count);
    i_10.setAttribute("id", "price_other_" + row_count);
    i_10.setAttribute("type", "text");
    i_10.setAttribute("onchange", "hesapla('price_other'," + row_count + ")");
    // i_6.setAttribute("class", "box");
    i_10.setAttribute("style", "width:30px")
    i_10.setAttribute("value", commaSplit(price_other));

    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(i_10);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "display:none");
    td.setAttribute("class", "hiddenR");

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
    sel.value = omoney;
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(sel);

    td.appendChild(div);
    tr.appendChild(td);

    var td = document.createElement("td");
    td.setAttribute("style", "width:20%")
    var i_7 = document.createElement("input");
    i_7.setAttribute("name", "row_nettotal_" + row_count);
    i_7.setAttribute("id", "row_nettotal_" + row_count);
    i_7.setAttribute("type", "text");
    // i_7.setAttribute("class", "box");
    // i_7.setAttribute("style", "width:30px")
    var tutar = parseFloat(filterNum(price)) * qty;
    i_7.setAttribute("value", commaSplit(tutar, 2));

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


    var td = document.createElement("td");
    td.setAttribute("style", "display:none");
    td.setAttribute("class", "hiddenR");

    var sel_1 = document.createElement("select");
    sel_1.setAttribute("name", "orderrow_currency_" + row_count);
    sel_1.setAttribute("id", "orderrow_currency_" + row_count);
    var opt = document.createElement("option");
    opt.setAttribute("value", -5);
    opt.innerText = "Üretim";
    sel_1.appendChild(opt)

    var opt = document.createElement("option");
    opt.setAttribute("value", -6);
    opt.innerText = "Sevk";

    sel_1.appendChild(opt)

    var opt = document.createElement("option");
    opt.setAttribute("value", -2);
    opt.innerText = "Tedarik";
    sel_1.appendChild(opt)

    var opt = document.createElement("option");
    opt.setAttribute("value", -10);
    opt.innerText = "Kapatıldı";
    sel_1.appendChild(opt)
    sel_1.value = currency;
    var div = document.createElement("div");
    div.setAttribute("class", "form-group");
    div.appendChild(sel_1);
    td.appendChild(div);
    tr.appendChild(td);

    var bask = document.getElementById("tbl_basket");
    bask.appendChild(tr);
    hesapla("other_money", rowCount)
    RowControlForVirtual()
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

function getProductAjx(keyword, comp_id, price_catid) {
    /*var keyword="30012020916";
    var comp_id=2544;
    var price_catid=9;*/
    var returnData = "";
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProduct",
        data: {
            keyword: keyword,
            userid: generalParamsSatis.userData.user_id,
            dsn2: generalParamsSatis.dataSources.dsn2,
            dsn1: generalParamsSatis.dataSources.dsn1,
            dsn3: generalParamsSatis.dataSources.dsn3,
            price_catid: price_catid,
            comp_id: comp_id
        }
    }).done(function (a) {
        returnData = a
        console.log(returnData)
    });
    return returnData
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
        var Product = getProductMultiUse(keyword, comp_id, price_catid);
        console.log(Product)
        if (Product.RECORDCOUNT != 0) {
            var q = "SELECT PP.SHELF_CODE  FROM PRODUCT_PLACE_ROWS AS PPR"
            q += " LEFT JOIN PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID"
            q += " WHERE STOCK_ID=" + Product.PRODUCT.STOCK_ID;
            var res = wrk_query(q, "dsn3")
            console.log(res)
            if (res.recordcount > 1) {
                var str = "";
                for (let i = 0; i < res.recordcount; i++) {
                    str += res.SHELF_CODE[i] + "\n";
                }
                var rafKodu = prompt("Raf Kodu \n" + str)
            } else {
                var rafKodu = res.SHELF_CODE[0];
            }
            var durum = ShelfControl(Product.PRODUCT.PRODUCT_ID, rafKodu)
            if (durum) {
                var mik = prompt("Miktar", 1);
                if (!generalParamsSatis.workingParams.IS_ZERO_QUANTITY) {
                    if (parseFloat(mik) <= 0) {


                        while (true) {
                            mik = prompt("Miktar", 1);
                            if (parseFloat(mik) > 0) {
                                break;
                            }
                        }
                    }
                }
                AddRow(
                    Product.PRODUCT.PRODUCT_ID,
                    Product.PRODUCT.STOCK_ID,
                    0,
                    mik,
                    parseFloat(Product.PRODUCT.PRICE).toString(),
                    Product.PRODUCT.PRODUCT_NAME,
                    Product.PRODUCT.TAX,
                    Product.PRODUCT.DISCOUNT_RATE,
                    0,
                    rafKodu,
                    Product.PRODUCT.MONEY,
                    parseFloat(Product.PRODUCT.PRICE).toString(),
                    -6,
                    Product.PRODUCT.IS_MANUEL,
                    Product.PRODUCT.LAST_COST
                );
            }
            el.value = '';
        } else {
            alert("Ürün Bulunamadı");
        }
    }
}

function ShelfControl(pid, RafCode) {

    var q = "select DISTINCT SHELF_CODE,PPR.PRODUCT_PLACE_ID,PPR.PRODUCT_ID,PP.STORE_ID,PP.LOCATION_ID,PPR.PRODUCT_ID,SL.DEPARTMENT_LOCATION from " + generalParamsSatis.dataSources.dsn3 + ".PRODUCT_PLACE_ROWS AS PPR"
    q += " LEFT JOIN " + generalParamsSatis.dataSources.dsn3 + ".PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID "
    q += " LEFT JOIN " + generalParamsSatis.dataSources.dsn + ".STOCKS_LOCATION AS SL ON  SL.LOCATION_ID=PP.LOCATION_ID AND SL.DEPARTMENT_ID=PP.STORE_ID "
    q += "WHERE PPR.PRODUCT_ID=" + pid + " AND SHELF_CODE='" + RafCode + "'"
    var rafData = wrk_query(q, 'dsn3')
    if (rafData.recordcount != 0) {
        return true
    } else {
        if (generalParamsSatis.workingParams.IS_RAFSIZ == 0) {
            alert("Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır");
            return false;
        } else {
            alert("Ürün Bu Rafta Tanımlı Değildir Veya Raf Kodu Bulunamamıştır Rafsız Kayıt Yapılacaktır");
            return true
        }
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
        var Ptype = e.getAttribute("data-producttype")
        var isVirt = $(e).find("#is_virtual_" + RwId).val()
        var pid = $(e).find("#product_id_" + RwId).val()
        if (parseInt(isVirt) == 1) {
            var btnUpdate = document.getElementById("UpdateRow");
            if (parseInt(Ptype) == 1) {
                btnUpdate.setAttribute("onclick", "openHose(" + pid + "," + RwId + ")")
            } else if (parseInt(Ptype) == 2) {
                btnUpdate.setAttribute("onclick", "openHydrolic(" + pid + "," + RwId + ",1)")
            }
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
    var price_other = document.getElementById("price_other_" + row_id).value
    var other_money = document.getElementById("other_money_" + row_id).value
    var disc = document.getElementById("indirim1_" + row_id).value
    openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_showdata_prt&rowid=" + row_id + "&p_name=" + p_name + "&tax=" + tax + "&disc=" + disc + "&price_other=" + price_other + "&other_money=" + other_money)
}

function saveRowExtra(row_id, modal_id) {
    // row_extra_tax_tax

    var rtax = document.getElementById("row_extra_tax_tax").value
    var rdisc = document.getElementById("row_extra_disc").value
    var rprice_other = document.getElementById("row_extra_price_other").value
    var rother_money = document.getElementById("row_extra_other_money").value
    //var p_name = document.getElementById("product_name_" + row_id).value
    var tax = document.getElementById("Tax_" + row_id).value = commaSplit(filterNum(rtax))
    //commaSplit(rtax)
    var price_other_ = document.getElementById("price_other_" + row_id).value = commaSplit(filterNum(rprice_other))
    //commaSplit(rprice_other)
    var other_money_ = document.getElementById("other_money_" + row_id).value = rother_money
    var disc = document.getElementById("indirim1_" + row_id).value = commaSplit(filterNum(rdisc))
    //commaSplit(rdisc)
    hesapla("price_other", row_id)
    closeBoxDraggable(modal_id);
}

function hesapla(input, sira) {
    var price_ = filterNum($("#price_" + sira).val(), 8);

    var price_other_ = filterNum($("#price_other_" + sira).val(), 8);

    var amount_ = filterNum($("#amount_" + sira).val(), 8);
    var cost_ = $("#cost_" + sira).val();
    //  var manuel_ = $("#manuel" + sira).val();
    var indirim1_ = filterNum($("#indirim1_" + sira).val(), 8);
    var money_ = $("#other_money_" + sira).val();
    var r1 = filterNum($("#_txt_rate1_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);
    var r2 = filterNum($("#_txt_rate2_" + $("input[id^='_hidden_rd_money_'][value='" + money_ + "']").prop("id").split('_')[4]).val(), 8);

    $("#qs_basket tbody tr[data-rc='" + sira + "']").css("background-color", "white");
    if (list_find("price,other_money", input)) {
        price_other_ = (price_ * r1) / r2;
    } else if (input == "price_other") {
        price_ = (price_other_ * r2) / r1;
    }
    var newNettotal = (price_ * (100 - indirim1_) / 100) * amount_;
    console.log("%c ------", "color:red")
    console.log(newNettotal)
    console.log(parseFloat((price_ * (100 - indirim1_) / 100)))
    console.log(cost_)
    console.log("%c ------", "color:red")
    if (generalParamsSatis.workingParams.MALIYET_CONTROL) {
        if (parseFloat((price_ * (100 - indirim1_) / 100)) < parseFloat(cost_)) {
            document.getElementById("row_" + sira).setAttribute("style", "background-color:#ff06005c")
        }
    }

    $("#price_other_" + sira).val(commaSplit(price_other_, 2));
    $("#price_" + sira).val(commaSplit(price_, 2));
    $("#row_nettotal_" + sira).val(commaSplit(newNettotal, 2));
    $("#amount_" + sira).val(commaSplit(amount_, 2));
    toplamHesapla();
    toplamHesapla_2();
}

function toplamHesapla() {
    console.log("%c Toplam Hesapla", "color:red;font-size:10pt")
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
    /* var discTe=$("#discountallt");
     var discT=$("#discountallt").val();
     discTe.val(commaSplit(discT,2))*/
    $("#subTotal").val(commaSplit(nettotal_total_, 2));
    $("#subTaxTotal").val(commaSplit(tax_total_, 2));
    $("#subWTax").val(commaSplit(tax_price_total_, 2));
}

function toplamHesapla_2() {
    var rows = document.getElementsByClassName("sepetRow")
    var netT = 0;
    var taxT = 0;
    var discT = 0;
    var grosT = 0;
    var kdv_matrah = 0;
    for (let i = 1; i <= rows.length; i++) {
        var prc = filterNum(document.getElementById("price_" + i).value)
        var qty = filterNum(document.getElementById("amount_" + i).value)
        var dsc = filterNum(document.getElementById("indirim1_" + i).value)
        var tax = filterNum(document.getElementById("Tax_" + i).value)
        //   console.log("%c Fiyat "+ prc,"color:green;font-size:10pt")
        //  console.log("%c Miktar "+qty,"color:red;font-size:10pt")
        // console.log("%c Tax "+tax,"color:orange;font-size:10pt")
        var tts = prc * qty;
        var ds = (tts * dsc) / 100
        var ttr = tts - ds
        //   console.log("%c Tutar "+commaSplit(ttr,2),"color:blue;font-size:10pt")
        var tx = (ttr * tax) / 100
        netT += ttr
        taxT += tx;
        discT += ds
        grosT += tts;



    }
    console.log("%c Genel Toplam " + commaSplit(netT, 2), "color:purple;font-size:10pt")
    console.log("%c Vergi Toplam " + commaSplit(taxT, 2), "color:violet;font-size:10pt")
    console.log("%c İndirim Toplam " + commaSplit(discT, 2), "color:lightgreen;font-size:10pt")
    console.log("%c Gros Total " + commaSplit(grosT, 2), "color:#cad13d;font-size:10pt")
    var d = parseFloat(filterNum($("#txt_disc").val()))
    $("#txt_disc").val(commaSplit(d, 3))
    var udc = (netT * generalParamsSatis.workingParams.MAX_DISCOINT) / 100
    console.log(udc)
    if (d > udc) {
        alert("Genel İndirim İşlem Tutarının %" + generalParamsSatis.workingParams.MAX_DISCOINT + "'ndan büyük Olmaz İndirim 0'lanacaktır")
        $("#txt_disc").val(commaSplit(0, 3))
        d = 0;
    }

    console.log("%c İndirim Toplam " + commaSplit(d, 2), "color:lightgreen;font-size:10pt")
    $("#txt_total").val(commaSplit(grosT, 3))
    discT += d

    $("#txt_disc_total").val(commaSplit(discT, 3))
    netT = grosT - discT
    $("#txt_nokdv_total").val(commaSplit(netT, 3))
    taxT = (netT * 18) / 100
    $("#txt_kdv_total").val(commaSplit(taxT, 3))
    $("#txt_withkdv_total").val(commaSplit(netT + taxT, 3))
}

function GetShelves(Pid) {
    $.ajax({
        url: '/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProductShelves',
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
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=UpdVirtualTube",
        data: d + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&employee_id=" + generalParamsSatis.userData.user_id,
        success: function (retDat) {
            console.log(retDat)
            var obj = JSON.parse(retDat)
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })

}

function UpdRow(pid, sid, is_virtual, qty, price, p_name, tax, discount_rate, row_id) {
    debugger;
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
    toplamHesapla_2();
    toplamHesapla();
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
        var cbx = $(row).find("input:checkbox")[0]
        cbx.setAttribute("data-row", NeWid)
        p_name.setAttribute("id", "product_name_" + NeWid)
        p_name.setAttribute("name", "product_name_" + NeWid)
        var spn = document.getElementById("spn_" + Old_rw_id)
        spn.innerText = NeWid;
        spn.setAttribute("id", "spn_" + NeWid)
        var product_id = document.getElementById("product_id_" + Old_rw_id);
        product_id.setAttribute("id", "product_id_" + NeWid)
        product_id.setAttribute("name", "product_id_" + NeWid)

        var stock_id = document.getElementById("stock_id_" + Old_rw_id);
        stock_id.setAttribute("id", "stock_id_" + NeWid)
        stock_id.setAttribute("name", "stock_id_" + NeWid)

        var is_virtual = document.getElementById("is_virtual_" + Old_rw_id);
        is_virtual.setAttribute("id", "is_virtual_" + NeWid)
        is_virtual.setAttribute("name", "is_virtual_" + NeWid)

        var cost = document.getElementById("cost_" + Old_rw_id);
        cost.setAttribute("id", "cost_" + NeWid)
        cost.setAttribute("name", "cost_" + NeWid)

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
        other_money.setAttribute("id", "price_other_" + NeWid)
        other_money.setAttribute("name", "price_other_" + NeWid)

        var other_money = document.getElementById("other_money_" + Old_rw_id);
        other_money.setAttribute("id", "other_money_" + NeWid)
        other_money.setAttribute("name", "other_money_" + NeWid)

        var row_nettotal = document.getElementById("row_nettotal_" + Old_rw_id);
        row_nettotal.setAttribute("id", "row_nettotal_" + NeWid)
        row_nettotal.setAttribute("name", "row_nettotal_" + NeWid)

        var shelf_code = document.getElementById("shelf_code_" + Old_rw_id);
        shelf_code.setAttribute("id", "shelf_code_" + NeWid)
        shelf_code.setAttribute("name", "shelf_code_" + NeWid)

        var orderrow_currency = document.getElementById("orderrow_currency_" + Old_rw_id);
        orderrow_currency.setAttribute("id", "orderrow_currency_" + NeWid)
        orderrow_currency.setAttribute("name", "orderrow_currency_" + NeWid)

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

function SaveTube(dsn3, modal_id, tip = 0) {
    var p_name = ""
    if (tip == 0) {
        var p_name = window.prompt("Ürün Adı")
        if (p_name.length > 0) {} else {
            SaveTube(dsn3, modal_id)
        }
    }
    var qs = TubeControl();
    if (qs) {

        var d = $("#TubeForm").serialize();
        $.ajax({
            url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=saveTube",
            data: d + "&product_name=" + p_name + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&dsn1=" + generalParamsSatis.dataSources.dsn1 + "&dsn=" + generalParamsSatis.dataSources.dsn,
            success: function (retDat) {
                console.log(retDat)
                var obj = JSON.parse(retDat)
                if (obj.ROW_ID.length > 0) {
                    UpdRow(obj.PID, obj.SID, 0, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
                } else {
                    AddRow(obj.PID, obj.SID, 0, 1, obj.PRICE, obj.NAME, 18, 0, 1, '', 'TL', obj.PRICE, "-5");
                }
                closeBoxDraggable(modal_id)
            }
        })
    }

}

function TubeControl() {
    HataArr = [];
    var LRekor_PId = document.getElementById("LRekor_PId").value
    var Tube_PId = document.getElementById("Tube_PId").value
    var RRekor_PId = document.getElementById("RRekor_PId").value
    var AdditionalProduct_PId = document.getElementById("AdditionalProduct_PId").value

    var working_PId = document.getElementById("working_PId").value
    var Kabuk_PId = document.getElementById("Kabuk_PId").value

    console.log(LRekor_PId);
    console.log(Tube_PId);
    console.log(RRekor_PId);
    console.log(AdditionalProduct_PId);
    console.log(working_PId);
    console.log(Kabuk_PId);

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 1)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(LRekor_PId) == 0 || LRekor_PId.length == 0) {
            HataArr.push("Sol Rekor Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 2)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(Tube_PId) == 0 || Tube_PId.length == 0) {
            HataArr.push("Hortum Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 3)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(RRekor_PId) == 0 || RRekor_PId.length == 0) {
            HataArr.push("Sağ Rekor Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 4)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(AdditionalProduct_PId || AdditionalProduct_PId.length == 0) == 0) {
            HataArr.push("Ek İşlem Seçiniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 5)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(Kabuk_PId) == 0 || Kabuk_PId.length == 0) {
            HataArr.push("Kabuk Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 6)
    console.log(Q);
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(working_PId) == 0 || working_PId.length == 0) {
            HataArr.push("İşçilik Seçiniz !")
        }
    }

    var jString = JSON.stringify(HataArr)


    if (HataArr.length > 0) {
        openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=6&data=" + jString, 'small')
        return false;
    } else {
        return true;
    }
}

function HataGosterClick(modal_id, type) {
    if (type == 1) {
        closeBoxDraggable(modal_id)
    }

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

function saveRealHydrolic(modal_id) {
    $("#hydRwc").val(hydRowCount);

    var formData = getFormData($("#HydrolicForm"));
    $.ajax({
        url: "/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=SaveRealHydrolic",
        data: formData,
        success: function (retDat) {

            var obj = JSON.parse(retDat)
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })
}

function getFormData($form) {
    var unindexed_array = $form.serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function (n, i) {
        indexed_array[n['name']] = n['value'];
    });

    return indexed_array;
}

function CalculatehydrolicRow(rw_id) {
    var dovv_ = $('input[name=_rd_money]:checked').val();
    var dow = document.getElementById("_hidden_rd_money_" + dovv_).value
    /* var rate2 = filterNum($("#_txt_rate2_" + dovv_).val(), 4)*/
    var rate2 = moneyArr.find(p => p.MONEY == dow).RATE2;
    console.log("RATE2=" + parseFloat(rate2))

    var qty = document.getElementById("quantity_" + rw_id).value;
    var prc = document.getElementById("price_" + rw_id).value;
    var mny = document.getElementById("money_" + rw_id).value;

    var a = moneyArr.filter(p => p.MONEY == mny)
    console.log(netPrc)

    var netPrc = (parseFloat(filterNum(qty)) * parseFloat(filterNum(prc)))
    document.getElementById("quantity_" + rw_id).value = commaSplit(filterNum(qty))
    document.getElementById("price_" + rw_id).value = commaSplit(filterNum(prc))
    console.log(netPrc)

    document.getElementById("netT_" + rw_id).value = commaSplit(netPrc);
    CalculateHydSub();
}

function CalculateHydSub() {
    var total = 0;
    var marj = document.getElementById("marjHyd").value;
    document.getElementById("marjHyd").value = commaSplit(marj)
    marj = filterNum(marj);
    marj = parseFloat(marj);
    for (let i = 1; i <= hydRowCount; i++) {
        var netT = document.getElementById("netT_" + i).value;
        var mny = document.getElementById("money_" + i).value;
        var a = moneyArr.filter(p => p.MONEY == mny)
        total = total + (parseFloat(filterNum(netT)) * a[0].RATE2)

    }
    total = total + ((total * marj) / 100)
    $("#hydSubTotal").val(commaSplit(total));
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

function saveOrder() {

    var rows = document.getElementsByClassName("sepetRow")
    var OrderRows = new Array();
    for (let Old_rw_id = 1; Old_rw_id <= rows.length; Old_rw_id++) {

        var product_name = document.getElementById("product_name_" + Old_rw_id).value;
        var product_id = document.getElementById("product_id_" + Old_rw_id).value;
        var stock_id = document.getElementById("stock_id_" + Old_rw_id).value;
        var is_virtual = document.getElementById("is_virtual_" + Old_rw_id).value;
        var amount = document.getElementById("amount_" + Old_rw_id).value;
        var price = document.getElementById("price_" + Old_rw_id).value;
        var other_money = document.getElementById("other_money_" + Old_rw_id).value;
        var row_nettotal = document.getElementById("row_nettotal_" + Old_rw_id).value;
        var shelf_code = document.getElementById("shelf_code_" + Old_rw_id).value;
        var Tax = document.getElementById("Tax_" + Old_rw_id).value;
        var indirim1 = document.getElementById("indirim1_" + Old_rw_id).value;
        var price_other = document.getElementById("price_other_" + Old_rw_id).value;
        var orderrow_currency = document.getElementById("orderrow_currency_" + Old_rw_id).value;
        if (!generalParamsSatis.workingParams.IS_ZERO_QUANTITY) {
            var p = filterNum(price);
            if (p <= 0) {
                alert("0 Fiyatlı Kayıt Yapamazsıznız");
                return false;
            }
        }
        var Obj = {
            product_name: product_name,
            product_id: product_id,
            stock_id: stock_id,
            is_virtual: is_virtual,
            amount: amount,
            price: price,
            other_money: other_money,
            row_nettotal: row_nettotal,
            shelf_code: shelf_code,
            Tax: Tax,
            indirim1: indirim1,
            price_other: price_other,
            orderrow_currency: orderrow_currency
        }
        OrderRows.push(Obj)
    }

    var COMPANY_ID = document.getElementById("company_id").value;
    var MEMBER_NAME = document.getElementById("company_name").value;
    var PAYMETHOD = document.getElementById("PAYMETHOD").value;
    var PAYMETHOD_ID = document.getElementById("PAYMETHOD_ID").value;
    var VADE = document.getElementById("VADE").value;
    var COMPANY_PARTNER_NAME = document.getElementById("company_partner_name").value;
    var COMPANY_PARTNER_ID = document.getElementById("company_partner_id").value;
    var PROCESS_STAGE = document.getElementById("process_stage").value;
    var SHIP_METHOD = document.getElementById("SHIP_METHOD").value;
    var SHIP_METHOD_ID = document.getElementById("SHIP_METHOD_ID").value;
    var ORDER_ID = document.getElementById("order_id").value;
    var SUBTOTAL = document.getElementById("subTotal").value;
    var SUBTAXTOTAL = document.getElementById("subTaxTotal").value;
    var SUBNETTOTAL = document.getElementById("subWTax").value;

    var GROSS_TOTAL = document.getElementById("txt_total").value;
    var AFTER_DISCOUNT = document.getElementById("txt_disc").value;
    var DISCOUNT_TOTAL = document.getElementById("txt_disc_total").value;
    var TOTAL_WITHOUT_KDV = document.getElementById("txt_nokdv_total").value;
    var TAX_TOTAL = document.getElementById("txt_kdv_total").value;
    var TOTAL_WITH_KDV = document.getElementById("txt_withkdv_total").value;

    var OFFER_DATE = document.getElementById("offer_date").value;
    var OFFER_HEAD = document.getElementById("offer_head").value;
    var SHIP_ADDRESS = document.getElementById("ship_address").value;
    var SHIP_ADDRESS_ID = document.getElementById("ship_address_id").value;
    var CITY_ID = document.getElementById("city_id").value;
    var COUNTY_ID = document.getElementById("county_id").value;

    SUBTOTAL = filterNum(SUBTOTAL, 4)
    SUBTAXTOTAL = filterNum(SUBTAXTOTAL, 4)
    SUBNETTOTAL = filterNum(SUBNETTOTAL, 4)

    GROSS_TOTAL = filterNum(GROSS_TOTAL, 4)
    AFTER_DISCOUNT = filterNum(AFTER_DISCOUNT, 4)
    DISCOUNT_TOTAL = filterNum(DISCOUNT_TOTAL, 4)
    TOTAL_WITHOUT_KDV = filterNum(TOTAL_WITHOUT_KDV, 4)
    TAX_TOTAL = filterNum(TAX_TOTAL, 4)
    TOTAL_WITH_KDV = filterNum(TOTAL_WITH_KDV, 4)

    var form = $(document);
    var checkedValue = form.find("input[name=_rd_money]:checked").val();

    var ISLEM_TIPI_PBS = "";
    if ($('#snl_teklif').is(':checked')) {
        ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "1,"
    }
    if ($('#siparis').is(':checked')) {
        ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "2,"
    }
    if ($('#sevkiyat').is(':checked')) {
        ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "3,"
    }
    if ($('#sales_type_1').is(':checked')) {
        ISLEM_TIPI_PBS = ISLEM_TIPI_PBS + "4,"
    }
    var BASKET_MONEY = document.getElementById("_hidden_rd_money_" + checkedValue).value
    var basket_rate_1 = document.getElementById("_txt_rate1_" + checkedValue).value
    var basket_rate_2 = document.getElementById("_txt_rate2_" + checkedValue).value
    var BASKET_RATE_1 = filterNum(basket_rate_1, 4);
    var BASKET_RATE_2 = filterNum(basket_rate_2, 4);
    var Fs = getParameterByName("fuseaction");
    var OrderHeader = {
        COMPANY_ID: COMPANY_ID,
        PAYMETHOD: PAYMETHOD,
        PAYMETHOD_ID: PAYMETHOD_ID,
        VADE: VADE,
        COMPANY_PARTNER_NAME: COMPANY_PARTNER_NAME,
        COMPANY_PARTNER_ID: COMPANY_PARTNER_ID,
        MEMBER_NAME: MEMBER_NAME,
        PROCESS_STAGE: PROCESS_STAGE,
        SHIP_METHOD: SHIP_METHOD,
        SHIP_METHOD_ID: SHIP_METHOD_ID,
        ORDER_ID: ORDER_ID,
        OFFER_DATE: OFFER_DATE,
        OFFER_HEAD: OFFER_HEAD,
        SHIP_ADDRESS: SHIP_ADDRESS,
        SHIP_ADDRESS_ID: SHIP_ADDRESS_ID,
        CITY_ID: CITY_ID,
        COUNTY_ID: COUNTY_ID,
        ISLEM_TIPI_PBS: ISLEM_TIPI_PBS,
        FACT: Fs
    }

    var OrderFooter = {
        SUBTOTAL: SUBTOTAL,
        SUBTAXTOTAL: SUBTAXTOTAL,
        SUBNETTOTAL: SUBNETTOTAL,
        BASKET_MONEY: BASKET_MONEY,
        BASKET_RATE_1: BASKET_RATE_1,
        BASKET_RATE_2: BASKET_RATE_2,
        GROSS_TOTAL: GROSS_TOTAL,
        AFTER_DISCOUNT: AFTER_DISCOUNT,
        DISCOUNT_TOTAL: DISCOUNT_TOTAL,
        TOTAL_WITHOUT_KDV: TOTAL_WITHOUT_KDV,
        TAX_TOTAL: TAX_TOTAL,
        TOTAL_WITH_KDV: TOTAL_WITH_KDV,
    }

    var Order = {
        OrderHeader: OrderHeader,
        OrderRows: OrderRows,
        OrderMoney: moneyArr,
        OrderFooter: OrderFooter,
        WORKING_PARAMS: generalParamsSatis.workingParams
    }
    var mapForm = document.createElement("form");
    mapForm.target = "Map";
    mapForm.method = "POST"; // or "post" if appropriate
    mapForm.action = "/index.cfm?fuseaction=sales.emptypopup_query_save_order";

    var mapInput = document.createElement("input");
    mapInput.type = "hidden";
    mapInput.name = "data";
    mapInput.value = JSON.stringify(Order);
    mapForm.appendChild(mapInput);

    document.body.appendChild(mapForm);

    map = window.open("/index.cfm?fuseaction=sales.emptypopup_query_save_order", "Map", "status=0,title=0,height=600,width=800,scrollbars=1");

    if (map) {
        mapForm.submit();
    } else {
        alert('You must allow popups for this map to work.');
    }

}



function RowControlForVirtual() {
    var elems = document.getElementsByClassName("sepetRow")
    var sanal_varmı = false;
    for (let i = 1; i <= elems.length; i++) {
        var vi = document.getElementById("is_virtual_" + i)
        console.log(vi.value)
        if (parseInt(vi.value) == 1) {
            sanal_varmı = true
        }
    }
    if (sanal_varmı) {
        document.getElementById("siparis").setAttribute("disabled", "true");
        document.getElementById("sevkiyat").setAttribute("disabled", "true");
        $(document.getElementById("snl_teklif")).click()
    }
}

function pencere_ac_product(no) {


}

function sellinputAllVal(el) {
    //el.setSelectionRange(0, el.value.length)
    el.select();
}

function discountControl() {

    toplamHesapla();
    toplamHesapla_2();
}