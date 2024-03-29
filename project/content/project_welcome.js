var zeroCount = 4;
function ProjectNameGet(el) {
  var iid = el.value;
  var pcode = SCodes.find((p) => p.MAIN_PROCESS_CAT_ID == iid).SHORT_CODE;
  var res = wrk_query(
    "SELECT * FROM PROJECT_NUMBERS_BY_CAT WHERE MAIN_PROCESS_CAT_ID=" + iid,
    "dsn"
  );
  var num = 0;
  if (res.recordcount > 0) {
    num = parseInt(res.PRNUMBER[0]);
  }
  var zc = zeroCount - num.toString().length;
  var nmr = pcode + "-";
  for (let i = 0; i < zc; i++) {
    nmr += "0";
  }
  nmr += num.toString();
  document.getElementById("project_head").value = nmr;
}

$("#add_project_form").submit(function (e) {
  e.preventDefault(); // avoid to execute the actual submit of the form.

  var form = $(this);
  var actionUrl = form.attr("action");

  $.ajax({
    type: "POST",
    url: actionUrl,
    data: form.serialize(), // serializes the form's elements.
    success: function (data) {
      alert(data); // show response from the php script.
    },
  });
});
$(document).ready(function () {
  var d = document.getElementById("wrk_main_layout");
  d.removeAttribute("class");
  d.setAttribute("class", "container-fluid");
  $("#xmlSettings").hide()
});
