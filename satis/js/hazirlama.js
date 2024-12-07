var employeeArr = [];
var interval;
var lastRc = 0;
var LocationArr = [];

$(document).ready(function () {
  var Qr = wrk_query(
    "SELECT D.DEPARTMENT_HEAD,SL.COMMENT,D.DEPARTMENT_ID,SL.LOCATION_ID FROM STOCKS_LOCATION AS SL LEFT JOIN DEPARTMENT AS D ON D.DEPARTMENT_ID =SL.DEPARTMENT_ID"
  );

  for (let i = 0; i < Qr.recordcount; i++) {
    var O = {
      DEPARTMENT_HEAD: Qr.DEPARTMENT_HEAD[i],
      COMMENT: Qr.COMMENT[i],
      DEPARTMENT_ID: Qr.DEPARTMENT_ID[i],
      LOCATION_ID: Qr.LOCATION_ID[i],
    };
    LocationArr.push(O);
  }
  $.ajax({
    url:
      "/AddOns/Partner/Satis/cfc/depo.cfc?method=getDepartmentEmployees&DEPARTMENT_ID=" +
      deparmanData.department_id +
      "&LOCATION_ID=" +
      deparmanData.location_id,
    success: function (returnData) {
      console.log(returnData);
      var obj = JSON.parse(returnData);
      console.log(obj);
      employeeArr = obj.EMPLOYEES;
     
      getDepartmentWorks();
      interval = setInterval(getDepartmentWorks, 20000);
    },
  });
});

function getDepartmentWorks() {
  var tbl = document.getElementById("grdTbl");
  tbl.innerHTML = "";
  $.ajax({
    url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=getDepartmentWorks",
    data: {
      department_id: deparmanData.department_id,
      location_id: deparmanData.location_id,
      dataSources: JSON.stringify(generalParamsSatis.dataSources),
    },
    success: function (returnData) {
      // console.log(returnData)
      var obj = JSON.parse(returnData);
      console.log(obj);
      console.log(lastRc);
      console.log(obj.length);
      if (lastRc > 0) {
        console.log("calmam lazım");
        document.getElementById("myAudio").play();
      }
      lastRc = obj.length;
      for (let i = 0; i < obj.length; i++) {
        var ix = LocationArr.findIndex(
          (p) =>
            (p.DEPARTMENT_ID == o.DELIVERT_DEPT) &
            (p.LOCATION_ID == o.DELIVER_LOCATION)
        );
        var Depocu = LocationArr[ix];
        var o = obj[i];
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        td.innerText = i + 1;
        tr.appendChild(td);
        var td = document.createElement("td");
        td.innerText = o.DELIVER_PAPER_NO;
        tr.appendChild(td);
        var td = document.createElement("td");
        td.innerText = o.NICKNAME;
        tr.appendChild(td);
        var td = document.createElement("td");
        td.innerText = o.TTS;
        tr.appendChild(td);
        var td = document.createElement("td");
        td.innerText = o.KAYDEDEN;
        tr.appendChild(td);
        var td = document.createElement("td");
        td.innerText = Depocu.DEPARTMENT_HEAD+"-"+Depocu.COMMENT;
        tr.appendChild(td);

        var sel = document.createElement("select");
        sel.setAttribute(
          "onchange",
          "setEmpToWork(this.value," + o.IS_SVK + ")"
        );
        var opt = document.createElement("option");
        opt.setAttribute("value", "");
        opt.innerText = "Seçiniz";
        sel.appendChild(opt);

        for (let j = 0; j < employeeArr.length; j++) {
          var opt = document.createElement("option");
          opt.setAttribute(
            "value",
            employeeArr[j].EMPLOYEE_ID + "-" + o.SHIP_RESULT_ID
          );
          opt.innerText =
            employeeArr[j].EMPLOYEE_NAME +
            " " +
            employeeArr[j].EMPLOYEE_SURNAME;
          sel.appendChild(opt);
        }
        var td = document.createElement("td");
        td.appendChild(sel);
        tr.appendChild(td);
        tbl.appendChild(tr);
      }
    },
  });
}
function getDemands() {
  var tbl = document.getElementById("grdTbl2");
  tbl.innerHTML = "";
  $.ajax({
    url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=getDepartmentWorks2",
    data: {
      department_id: deparmanData.department_id,
      location_id: deparmanData.location_id,
      dataSources: JSON.stringify(generalParamsSatis.dataSources),
    },
    success: function (returnData) {
      console.log(returnData);
    },
  });
}
function setEmpToWork(workI, SVK) {
  $.ajax({
    url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=setWorkEmployee",
    data: {
      department_id: deparmanData.department_id,
      location_id: deparmanData.location_id,
      dataSources: JSON.stringify(generalParamsSatis.dataSources),
      empo: workI,
      IS_SVK: SVK,
    },
  });
}
