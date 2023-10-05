var employeeArr = [];
var interval;
var lastRc = 0;
$(document).ready(function () {
    $.ajax({
        url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=getDepartmentEmployees&DEPARTMENT_ID=" + deparmanData.department_id + "&LOCATION_ID=" + deparmanData.location_id,
        success: function (returnData) {
            console.log(returnData)
            var obj = JSON.parse(returnData);
            console.log(obj)
            employeeArr = obj.EMPLOYEES
            getDepartmentWorks()
            interval = setInterval(getDepartmentWorks, 20000)

        }
    })
})

function getDepartmentWorks() {
    var tbl = document.getElementById("grdTbl")
    tbl.innerHTML = "";
    $.ajax({
        url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=getDepartmentWorks",
        data: {
            department_id: deparmanData.department_id,
            location_id: deparmanData.location_id,
            dataSources: JSON.stringify(generalParamsSatis.dataSources)
        },
        success: function (returnData) {
            // console.log(returnData)
            var obj = JSON.parse(returnData)
            console.log(obj)
            console.log(lastRc);
            console.log(obj.length);
            if (lastRc > 0) {
                console.log("calmam lazım")
                document.getElementById("myAudio").play()
            }
            lastRc = obj.length
            for (let i = 0; i < obj.length; i++) {
                var o = obj[i]
                var tr = document.createElement("tr")
                var td = document.createElement("td")
                td.innerText = i + 1;
                tr.appendChild(td)
                var td = document.createElement("td")
                td.innerText = o.DELIVER_PAPER_NO
                tr.appendChild(td)
                var td = document.createElement("td")
                td.innerText = o.NICKNAME
                tr.appendChild(td)
                var td = document.createElement("td")
                td.innerText = o.TTS
                tr.appendChild(td)
                var td = document.createElement("td")
                td.innerText = o.KAYDEDEN
                tr.appendChild(td)
                
                var sel = document.createElement("select")
                sel.setAttribute("onchange", "setEmpToWork(this.value,"+o.IS_SVK+")")
                var opt = document.createElement("option");
                opt.setAttribute("value", "")
                opt.innerText = "Seçiniz";
                sel.appendChild(opt);

                for (let j = 0; j < employeeArr.length; j++) {
                    var opt = document.createElement("option")
                    opt.setAttribute("value", employeeArr[j].EMPLOYEE_ID + "-" + o.SHIP_RESULT_ID)
                    opt.innerText = employeeArr[j].EMPLOYEE_NAME + " " + employeeArr[j].EMPLOYEE_SURNAME
                    sel.appendChild(opt)
                }
                var td = document.createElement("td")
                td.appendChild(sel)
                tr.appendChild(td)
                tbl.appendChild(tr)
            }

        }
    })
}
function setEmpToWork(workI,SVK) {
    $.ajax({
        url: "/AddOns/Partner/Satis/cfc/depo.cfc?method=setWorkEmployee",
        data: {
            department_id: deparmanData.department_id,
            location_id: deparmanData.location_id,
            dataSources: JSON.stringify(generalParamsSatis.dataSources),
            empo: workI,
            IS_SVK:SVK
        },
    })
}