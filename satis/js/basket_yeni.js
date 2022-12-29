function InputCreator(
  id,
  name,
  row,
  style,
  classs,
  value,
  type,
  isReadOnly = 0,
  isDisabled = 0,
  ev = "",
  trigFunc = "",
  ev1 = "",
  trigFunc1 = ""
) {
  var input = document.createElement("input");
  input.setAttribute("name", name);
  input.setAttribute("id", id);
  input.setAttribute("type", type);
  input.setAttribute("value", value);
  if (style.length > 0) {
    input.setAttribute("style", style);
  }
  if (classs.length > 0) {
    input.setAttribute("class", classs);
  }
  if (isReadOnly == 1) {
    input.setAttribute("readonly", "true");
  }
  if (isDisabled == 1) {
    input.setAttribute("disabled", "true");
  }
  if (ev.length > 0) {
    input.setAttribute(ev, trigFunc);
  }
  if (ev1.length > 0) {
    input.setAttribute(ev, trigFunc1);
  }
  return input;
}
