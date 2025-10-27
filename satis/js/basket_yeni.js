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


    function wrk_query(str_query, data_source, maxrows) {
    if (!data_source) data_source = 'dsn';
    if (!maxrows) maxrows = 0;
    
    var new_query = new Object();
    var req = createXMLHttpRequest();
    
    if (req) {
        req.open("post", '/index.cfm?fuseaction=objects2.emptypopup_get_js_query&isAjax=1&xmlhttp=1', false);
        req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setRequestHeader('pragma', 'nocache');
        
        var queryParam = encodeURI(str_query).indexOf('+') == -1 ? 
            'str_sql=' + encodeURI(str_query) : 
            'str_sql=' + encodeURIComponent(str_query);
            
        req.send(queryParam + '&data_source=' + data_source + '&maxrows=' + maxrows);
        
        if (req.readyState == 4 && req.status == 200) {
            try {
                eval(req.responseText.replace(/\u200B/g, ''));
                new_query = get_js_query;
            } catch(e) {
                new_query = false;
            }
        }
    }
    
    return new_query;
}
function createXMLHttpRequest() {
    var req = false;
    
    if (window.XMLHttpRequest) {
        try {
            req = new XMLHttpRequest();
        } catch(e) {
            req = false;
        }
    } else if (window.ActiveXObject) {
        try {
            req = new ActiveXObject("Msxml2.XMLHTTP");
        } catch(e) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch(e) {
                req = false;
            }
        }
    }
    
    return req;
}
