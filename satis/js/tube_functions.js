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
    var money_elem = document.getElementById(elemanAtt + "_MNY")

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
            money_elem.value = Product.PRODUCT.MONEY;
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

function FindProduct2(ev, el, userid, dsn2, dsn1, dsn3, price_catid, comp_id) {
    var keyword = el.value;
    var elemanAtt = el.getAttribute("data-type");
 var NameElem = document.getElementById(elemanAtt + "_lbs")
keyword=urlencode(keyword.toLowerCase())
    if ((ev.keyCode == 13 || ev.type == 'change') && keyword.length>5 ) {

       // var Product = getProductMultiUse(keyword, comp_id, price_catid);
        var Product=getProductMultiUseA(keyword,comp_id,price_catid)
        if (Product.RECORDCOUNT != 0) {
        $("#sildiv").remove();

        var el=document.getElementById(elemanAtt)
        var div=document.createElement("div")
        div.setAttribute("style","display:none;position: fixed;z-index: 99999; background: whitesmoke;padding: 17px;border: solid 1px #ad6d6d;")
        var tbl=document.createElement("table");
        tbl.setAttribute("class","table");
        for(let i=0;i<Product.PRODUCTS.length;i++){
            var tr=document.createElement("tr")
            var td=document.createElement("td");
            //td.innerText=Product.PRODUCTS[i].PRODUCT_NAME;
            var a=document.createElement("a");
            a.setAttribute("onclick","setRwTube('"+elemanAtt+"','"+Product.PRODUCTS[i].PRODUCT_NAME+"',"+Product.PRODUCTS[i].PRODUCT_ID+","+Product.PRODUCTS[i].STOCK_ID+","+Product.PRODUCTS[i].DISCOUNT_RATE+","+Product.PRODUCTS[i].PRICE+",'"+Product.PRODUCTS[i].REL_CATNAME+"','"+Product.PRODUCTS[i].REL_HIERARCHY+"','"+Product.PRODUCTS[i].MONEY+"',"+Product.PRODUCTS[i].REL_CATID+")")
a.innerText=Product.PRODUCTS[i].PRODUCT_NAME;
            td.appendChild(a);
            tr.appendChild(td)
            tbl.appendChild(tr)    
        }
            div.appendChild(tbl)
            div.setAttribute("id","sildiv")
            el.parentElement.appendChild(div)
            $(div).show(500)

          /*  pidElem.value = Product.PRODUCT.PRODUCT_ID;
            sidElem.value = Product.PRODUCT.STOCK_ID;
            NameElem.innerText = Product.PRODUCT.PRODUCT_NAME;
            discountElem.value = Product.PRODUCT.DISCOUNT_RATE;
            money_elem.value = Product.PRODUCT.MONEY;
            priceElem.value = Product.PRODUCT.PRICE;
            if (elemanAtt == "Tube") {
                console.log(Product.PRODUCT.REL_CATNAME)
                PC_ELEM.value = Product.PRODUCT.REL_CATNAME
                PCID_ELEM.value = Product.PRODUCT.REL_CATID
                PCHIE_ELEM.value = Product.PRODUCT.REL_HIERARCHY
            }
            CalculateTube()*/
        } else {
            NameElem.innerText = "Ürün Bulunamadı";
        }


    }
}

function setRwTube(elemanAtt,product_name,product_id,stock_id,discount,price,REL_CATNAME,REL_HIERARCHY,MONEY,REL_CATID){

    var pidElem = document.getElementById(elemanAtt + "_PId")
    var sidElem = document.getElementById(elemanAtt + "_SId")
    var NameElem = document.getElementById(elemanAtt + "_lbs")
    var priceElem = document.getElementById(elemanAtt + "_Prc")
    var discountElem = document.getElementById(elemanAtt + "_DSC")
    var money_elem = document.getElementById(elemanAtt + "_MNY")

    var PC_ELEM = document.getElementById("PRODUCT_CAT")
    var PCID_ELEM = document.getElementById("PRODUCT_CATID")
    var PCHIE_ELEM = document.getElementById("HIEARCHY")
    var kwelem=document.getElementById(elemanAtt);

       pidElem.value = product_id;
            sidElem.value =stock_id;
            NameElem.innerText = product_name;
            discountElem.value = commaSplit(discount);
            money_elem.value = MONEY;
            priceElem.value = price;
            kwelem.value=product_name;
            if (elemanAtt == "Tube") {
                
                PC_ELEM.value = REL_CATNAME;
                PCID_ELEM.value = REL_CATID;
                PCHIE_ELEM.value = REL_HIERARCHY;
            }
            CalculateTube()

               $("#sildiv").remove();
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

    var LRekor_DSC = document.getElementById("LRekor_DSC").value
    var Tube_DSC = document.getElementById("Tube_DSC").value
    var RRekor_DSC = document.getElementById("RRekor_DSC").value
    var AdditionalProduct_DSC = document.getElementById("AdditionalProduct_DSC").value
    var Kabuk_DSC = document.getElementById("Kabuk_DSC").value
    var working_DSC = document.getElementById("working_DSC").value

    var LRekor_MNY = document.getElementById("LRekor_MNY").value
    var Tube_MNY = document.getElementById("Tube_MNY").value
    var RRekor_MNY = document.getElementById("RRekor_MNY").value
    var AdditionalProduct_MNY = document.getElementById("AdditionalProduct_MNY").value
    var Kabuk_MNY = document.getElementById("Kabuk_MNY").value
    var working_MNY = document.getElementById("working_MNY").value

    var marj = document.getElementById("marj").value

    var maliyet = document.getElementById("maliyet")
    var TotalValue=0;

        LRekor_Qty=parseFloat(filterNum(commaSplit(LRekor_Qty)))
        LRekor_DSC=parseFloat(filterNum(commaSplit(LRekor_DSC)))
        var ax=DegerLeriHesapla(LRekor_Prc,LRekor_DSC,LRekor_Qty,LRekor_MNY);
        document.getElementById("LRekor_TTL").value=ax;
        TotalValue+=ax;

        RRekor_Qty=parseFloat(filterNum(commaSplit(RRekor_Qty)))
        RRekor_DSC=parseFloat(filterNum(commaSplit(RRekor_DSC)))

        var ax=DegerLeriHesapla(RRekor_Prc,RRekor_Qty,RRekor_DSC,RRekor_MNY);
        document.getElementById("RRekor_TTL").value=ax;
        TotalValue+=ax;

        Tube_Qty=parseFloat(filterNum(commaSplit(Tube_Qty)))
        Tube_DSC=parseFloat(filterNum(commaSplit(Tube_DSC)))
        var ax=DegerLeriHesapla(Tube_Prc,Tube_DSC,Tube_Qty,Tube_MNY);
        document.getElementById("Tube_TTL").value=ax;
        TotalValue+=ax;

        AdditionalProduct_Qty=parseFloat(filterNum(commaSplit(AdditionalProduct_Qty)))
        AdditionalProduct_DSC=parseFloat(filterNum(commaSplit(AdditionalProduct_DSC)))
        var ax=DegerLeriHesapla(AdditionalProduct_Prc,AdditionalProduct_DSC,AdditionalProduct_Qty,AdditionalProduct_MNY);
        document.getElementById("AdditionalProduct_TTL").value=ax;
        TotalValue+=ax;
        working_Qty=parseFloat(filterNum(commaSplit(working_Qty)))
        working_DSC=parseFloat(filterNum(commaSplit(working_DSC)))
        var ax=DegerLeriHesapla(working_Prc,working_DSC,working_Qty,working_MNY);
        document.getElementById("working_TTL").value=ax;
        TotalValue+=ax;
        Kabuk_Qty=parseFloat(filterNum(commaSplit(Kabuk_Qty)))
        Kabuk_DSC=parseFloat(filterNum(commaSplit(Kabuk_DSC)))
        var ax=DegerLeriHesapla(Kabuk_Prc,Kabuk_DSC,Kabuk_Qty,Kabuk_MNY);
        document.getElementById("Kabuk_TTL").value=ax;
        TotalValue+=ax;        
    // TotalValue+=DegerLeriHesapla(RRekor_Prc,RRekor_Qty,RRekor_DSC,RRekor_MNY);
    // TotalValue+=DegerLeriHesapla(Tube_Prc,Tube_DSC,Tube_Qty,Tube_MNY);
     //TotalValue+=DegerLeriHesapla(AdditionalProduct_Prc,AdditionalProduct_DSC,AdditionalProduct_Qty,AdditionalProduct_MNY);
    // TotalValue+=DegerLeriHesapla(working_Prc,working_DSC,working_Qty,working_MNY);
    // TotalValue+=DegerLeriHesapla(Kabuk_Prc,Kabuk_DSC,Kabuk_Qty,Kabuk_MNY);

   // var Tf = (parseFloat(LRekor_Prc) * parseFloat(LRekor_Qty)) + (parseFloat(RRekor_Prc) * parseFloat(RRekor_Qty)) + (parseFloat(Tube_Prc) * parseFloat(Tube_Qty)) + (parseFloat(AdditionalProduct_Prc) * parseFloat(AdditionalProduct_Qty));
    
    var Tf=TotalValue;
    //Tf = Tf + (parseFloat(working_Prc) * parseFloat(working_Qty)) + (parseFloat(Kabuk_Prc) * parseFloat(Kabuk_Qty))
    Tf = Tf + ((Tf * parseFloat(marj)) / 100)
    maliyet.value = commaSplit(Tf, 2);
}

function DegerLeriHesapla(p,d,q,m="TL"){
    var prm="";
    if(m.trim().length==0){
        prm="TL";
    }else{
        prm=m;
    }
    var price=parseFloat(p);
    var discount=parseFloat(d);
    var quantity=parseFloat(q);
    var mn=moneyArr.find(p=>p.MONEY==prm)
    var a=price-((price*discount)/100);
    var b=(a*quantity)*mn.RATE2;
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
          //  AddRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, 1, '', "TL", obj.PRICE, "-5");
           AddRow(
            obj.PID,
            0,
            '',
            '',
            1,
            1,
            obj.PRICE,
            obj.NAME,
            18,
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
             1
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
            UpdRow(obj.PID, '', 1, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
            closeBoxDraggable(modal_id)
        }
    })

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
                var obj = JSON.parse(retDat)
                if (obj.ROW_ID.length > 0) {
                    UpdRow(obj.PID, obj.SID, 0, 1, obj.PRICE, obj.NAME, 18, 0, obj.ROW_ID);
                } else {
                  //  AddRow(obj.PID, obj.SID, 0, 1, obj.PRICE, obj.NAME, 18, 0, 1, '', 'TL', obj.PRICE, "-5");
 AddRow(
            obj.PRODUCT_ID,
            obj.STOCK_ID,
            obj.STOCK_CODE,
            obj.BRAND_NAME,
            0,
            obj.QUANTITY,
            obj.PRICE,
            obj.PRODUCT_NAME,
            obj.TAX,
            obj.DISCOUNT_RATE,
            obj.PRODUCT_TYPE,
            obj.SHELF_CODE,
            obj.OTHER_MONEY,
            obj.PRICE_OTHER,
            obj.OFFER_ROW_CURRENCY,
            obj.IS_MANUEL,
            obj.COST,
            obj.MAIN_UNIT,
            obj.PRODUCT_NAME_OTHER,
            obj.DETAIL_INFO_EXTRA,
            obj.FC,
            obj.ROW_NUM,
            obj.DELIVERDATE,
            obj.IS_PRODUCTION,
            obj.ROW_UNIQ_ID

        )

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
    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 1)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(LRekor_PId) == 0 || LRekor_PId.length == 0) {
            HataArr.push("Sol Rekor Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 2)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(Tube_PId) == 0 || Tube_PId.length == 0) {
            HataArr.push("Hortum Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 3)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(RRekor_PId) == 0 || RRekor_PId.length == 0) {
            HataArr.push("Sağ Rekor Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 4)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(AdditionalProduct_PId || AdditionalProduct_PId.length == 0) == 0) {
            HataArr.push("Ek İşlem Seçiniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 5)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(Kabuk_PId) == 0 || Kabuk_PId.length == 0) {
            HataArr.push("Kabuk Seçmediniz !")
        }
    }

    var Q = generalParamsSatis.Questions.find(p => p.QUESTION_ID == 6)
    if (Q.IS_REQUIRED == 1) {
        if (parseInt(working_PId) == 0 || working_PId.length == 0) {
            HataArr.push("İşçilik Seçiniz !")
        }
    }

    var jString = JSON.stringify(HataArr)


    if (HataArr.length > 0) {
        //openBoxDraggable("index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=6&data=" + jString, 'small')
        console.log(HataArr);
        return false;
    } else {
        return true;
    }
}


