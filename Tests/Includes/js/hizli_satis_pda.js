//document.write("hi")


function getCustomer(ev, el) {
    var keyword = el.value;
    if (ev.keyCode == 13 || el.value.length >= 3) {

        /* $.ajax({
             url: "/index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=2",
             data: {
                 keyword: keyword
             },
             success: function (retDat) {
                 console.log(retDat)
                 var e = document.getElementById("cmpDiv");
                 $(e).html(retDat);
                 $(e).show(500);
             }
         })*/
        ShowCustomerDiv()
        AjaxPageLoad("index.cfm?fuseaction=objects.emptypopup_partner_testpage&page=2&keyword=" + keyword, "cmpDiv", 1, "Yükleniyor");

    }
}

function ShowCustomerDiv() {
    var e = document.getElementById("cmpDiv");
    $(e).show(500)
}
function HideCustomerDiv() {
    var e = document.getElementById("cmpDiv");
    $(e).hide(500)
}

function setCompany(id, name) {
    let compInfo = GetAjaxQuery("CompanyInfo", id);
    console.log(compInfo.PRICE_LISTS.length)
    if (compInfo.PRICE_LISTS.length == 0) {
        alert("Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz");
        return false;
    }
    $("#company_id").val(id);
    $("#company_name").val(name);

    $("#BAKIYE").val(commaSplit(compInfo.BAKIYE, 2))
    $("#RISK").val(commaSplit(compInfo.RISK, 2))
    $("#PAYMETHOD").val(compInfo.PAYMETHOD)
    $("#PAYMETHOD_ID").val(compInfo.PAYMETHOD_ID)
    $("#VADE").val(compInfo.VADE)
    console.log(compInfo);

    for (let i = 0; i < compInfo.PRICE_LISTS.length; i++) {
        console.log(compInfo.PRICE_LISTS[i])
        if (compInfo.PRICE_LISTS[i].IS_DEFAULT == 1) {
            $("#PRICE_CATID").val(compInfo.PRICE_LISTS[i].PRICE_CATID)
            $("#PRICE_CAT").val(compInfo.PRICE_LISTS[i].PRICE_CAT)
        }
    }
    console.log(compInfo);
    HideCustomerDiv();
}


function GetAjaxQuery(type, type_id) {
    var CompanyInfo = new Object();
    var url = "/index.cfm?fuseaction=objects.get_qs_info&ajax=1&ajax_box_page=1&isAjax=1";
    var myAjaxConnector = GetAjaxConnector();
    if (myAjaxConnector) {
        data = 'type_id=' + type_id + '&q_type=' + type;
        myAjaxConnector.open("post", url + '&xmlhttp=1', false);
        myAjaxConnector.setRequestHeader('If-Modified-Since', 'Sat, 1 Jan 2000 00:00:00 GMT');
        myAjaxConnector.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
        myAjaxConnector.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        myAjaxConnector.send(data);
        if (myAjaxConnector.readyState == 4 && myAjaxConnector.status == 200) {
            try {
                CompanyInfo = eval(myAjaxConnector.responseText.replace(/\u200B/g, ''))[0];
            }
            catch (e) {
                CompanyInfo = false;
            }
        }
    }
    return CompanyInfo;
}