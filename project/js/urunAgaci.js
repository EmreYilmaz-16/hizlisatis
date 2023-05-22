var o = new Object();
var ulx = document.createElement("div");
ulx.setAttribute("id", "ppidarea");
var sonEleman = "";
function ngetTree(product_id, is_virtual, dsn3) {
  $.ajax({
    url:
      "/AddOns/Partner/project/cfc/product_design.cfc?method=getTree&product_id=" +
      product_id +
      "&isVirtual=" +
      is_virtual +
      "&ddsn3=" +
      dsn3,
    success: function (asd) {
      var jsonStr = strToJson(asd);
      o = JSON.parse(jsonStr);
      AgaciYaz(o, 0);
      var esd = document.getElementById("TreeArea");
      esd.innerHTML = "";
      esd.appendChild(ulx);
    },
  });
}
function strToJson(str) {
  var newStr = "";
  for (let i = 0; i < str.length; i++) {
    var currentChar = str.charAt(i).trim();
    if (currentChar == "," && str.charAt(i + 1).trim() == "]") {
      console.log("ebe");
      currentChar = "";
    }
    newStr += currentChar;
  }
  return newStr;
}

function AgaciYaz(arr, isoq, address = "0") {
  var ul = document.createElement("ul");
  ul.setAttribute("class", "list-group");
  ul.setAttribute("data-seviye", isoq);
  var address = address;

  address += isoq.toString();
  for (let i = 0; i < arr.length; i++) {
    var li = document.createElement("li");
    if (isoq <= 0) {
      isoq = arr[i].RNDM_ID;
    }
    li.innerHTML = arr[i].PRODUCT_NAME + "<b>(" + isoq + ")</b>";
    li.setAttribute("data-product_id", arr[i].PRODUCT_ID);
    li.setAttribute("data-IS_VIRTUAL", arr[i].IS_VIRTUAL);
    li.setAttribute("data-PRODUCT_TREE_ID", arr[i].PRODUCT_TREE_ID);
    li.setAttribute("style","display:flex;align-content: stretch;justify-content: space-between;align-items: center")
    var diva= document.createElement("div");
    var btn = document.createElement("button");
    btn.innerText = "+";
    btn.setAttribute("onclick", "getitem(this)");
    btn.setAttribute("type", "button");    
    btn.setAttribute("class", "btn btn-success");
    var inp = document.createElement("input");
    inp.setAttribute("type", "text");
    inp.setAttribute("onchange", "console.log(this)");
    inp.setAttribute("value", arr[i].AMOUNT);
    inp.setAttribute("name", "amount");
    diva.setAttribute("style","display:flex;align-items:baseline;")
    diva.appendChild(inp);
    diva.appendChild(btn);
    li.appendChild(diva);
    

    //  li.setAttribute("onclick", "getitem(this)");

    li.setAttribute("class", "list-group-item");
    if (arr[i].AGAC.length > 0) {
      li.appendChild(AgaciYaz(arr[i].AGAC, arr[i].RNDM_ID, address));
    } else {
    }

    ul.appendChild(li);
  }

  ulx.appendChild(ul);
  return ul;
}

function getitem(el) {
  sonEleman = el;
  console.log(el);
}

function getDs() {
  $("#TreeArea").dxTreeList({
    dataSource: employees,
    rootValue: -1,
    keyExpr: "ID",
    parentIdExpr: "Head_ID",
    columns: [
      {
        dataField: "Title",
        caption: "Position",
      },
      "Full_Name",
      "City",
      "State",
      "Mobile_Phone",
      {
        dataField: "Hire_Date",
        dataType: "date",
      },
    ],
    expandedRowKeys: [1],
    showRowLines: true,
    showBorders: true,
    columnAutoWidth: true,
  });
}
