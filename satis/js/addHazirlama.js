function checkT(rowid) {
  var b = document.getElementById("chkbtn" + rowid);

  var i = document.getElementById("is_add" + rowid);
  $(i).click();
  if ($(i).is(":checked")) {
    b.removeAttribute("class");
    b.setAttribute("class", "btn btn-success");
    b.innerHTML = "&#10003";
  } else {
    b.removeAttribute("class");
    b.setAttribute("class", "btn btn-danger");
    b.innerText = "X";
  }
}
function checkTKarma(r1, r2) {
  var b = document.getElementById("chkbtn" + r1 + "_" + r2);

  var i = document.getElementById("is_add" + r1 + "_" + r2);
  $(i).click();
  if ($(i).is(":checked")) {
    b.removeAttribute("class");
    b.setAttribute("class", "btn btn-success");
    b.innerHTML = "&#10003";
  } else {
    b.removeAttribute("class");
    b.setAttribute("class", "btn btn-danger");
    b.innerText = "X";
  }
}
function setKarmaMi(el, sid) {}
$(document).ready(function () {
  document.getElementsByName("quantity1")[0].addEventListener("change", pKarma);
});
function pKarma(ev) {
  var el = ev.target;
  var mk = parseFloat(el.value);
  var kmp_len = el.getAttribute("data-kmp");
  var kmp_len = parseInt(kmp_len);
  for (let i = 1; i <= kmp_len; i++) {
    var ex = document.getElementsByName("quantity1_" + i)[0];
    var ex2 = document.getElementsByName("quantity22_1_" + i)[0];
    var t = parseFloat(ex2.value) * mk;
    ex.value = commaSplit(t);
  }
  console.log(kmp_len);
  console.log(el);
}

function CheckKarmaKoli(ixx,iixx) {
  kmp_len = 2;
  var min = iixx;
  for (let i = 1; i <= kmp_len; i++) {
    var ex = document.getElementsByName("quantity1_" + i)[0];
    var ex2 = document.getElementsByName("quantity22_1_" + i)[0];
    var t = parseFloat(ex2.value);
    var t2 = parseFloat(ex.value);
    var mt = parseInt(t2 / t);
    if (mt < min) min = mt;
  }
  document.getElementsByName("quantity1")[0].value = min;
  console.log(min);
}
