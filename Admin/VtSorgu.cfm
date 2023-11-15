    <link rel="stylesheet" href="/JS/codemirror-5.65.0/lib/codemirror.css">
    <script src="/JS/codemirror-5.65.0/lib/codemirror.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/edit/matchbrackets.js"></script>
    <script src="/JS/codemirror-5.65.0/mode/sql/sql.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/show-hint.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/sql-hint.js"></script>


<cfparam  name="attributes.sql_sorgu" default="">
    <cfquery name="getT" datasource="#dsn#">
    select ST.name,ss.name as schema_namea from #dsn#.sys.tables AS ST 
LEFT JOIN #dsn#.SYS.schemas AS SS ON SS.schema_id=ST.schema_id
order by st.schema_id

    </cfquery>
<div style="display:flex;">
    <div style="width:25%;height: 100vh;overflow: scroll;">
    <cf_big_list>
        <cfoutput query="getT">
        <tr><td><a href="javascript://" onclick="getCols('#schema_namea#','#name#')">#schema_namea#-#name#</a></td></tr>
        </cfoutput>
    </cf_big_list>
    </div>
    <div style="width:74%">
        <cf_box title="Veritabanı">
        <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#"> 
            <textarea name="sql_sorgu" id="sql_sorgu"><cfoutput>#attributes.sql_sorgu#</cfoutput></textarea>
            <input type="hidden" name="is_submit" value="1">
            <input type="submit">
        </cfform>
        <cfif isDefined("attributes.is_submit")>
            <cfif len(attributes.sql_sorgu)>
                <cfquery name="getSorgu" datasource="#dsn#" result="res">
                    #preserveSingleQuotes(attributes.sql_sorgu)#
                </cfquery>

            <div style="overflow:auto" id="sonuc_div">
                <cfif isDefined("res.COLUMNLIST")>
                    <cf_grid_list class="table striped compact" >
                        <thead>
                            <tr>
                                <th>#</th>
                                <cfloop list="#res.COLUMNLIST#" item="item"><th><cfoutput>#item#</cfoutput></th></cfloop>
                            </tr>
                        </thead>
                        <tbody>
                        <cfoutput query="getSorgu">
                            <tr>
                                <td>#currentrow#</td>
                                <cfloop list="#res.COLUMNLIST#" item="item">
                                    <td>#evaluate(item)#</td>
                                </cfloop>
                            </tr>
                        </cfoutput>
                        </tbody>
                    </cf_grid_list>
                </cfif>
            </div>
                <p>Kayıt Sayısı:<code><cfoutput>#res.recordcount#</cfoutput></p></code>
        </cfif>
    </cfif>
</cf_box>
</div>
</div>

<script>
$(document).ready(function(){
var d=document.getElementById("sonuc_div")
var v=window.innerHeight
var t=$(document.getElementsByTagName("textarea")[0]).css("height")
t=parseInt(t)
v=parseInt(v)
$(d).css("height",(v-t)/1.5+"px")
  var mime = 'text/x-mssql';
  // get mime type

  window.editor = CodeMirror.fromTextArea(document.getElementById('sql_sorgu'), {
    mode: mime,
    indentWithTabs: true,
    smartIndent: true,
    lineNumbers: true,
    matchBrackets : true,
    autofocus: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    

  });
})
$("textarea").click(function(){
var d=document.getElementById("sonuc_div")
var v=window.innerHeight
var t=$(document.getElementsByTagName("textarea")[0]).css("height")
t=parseInt(t)
v=parseInt(v)
$(d).css("height",(v-t)/1.5+"px")
})
function getCols(schm,tbl){
    var q="select COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA='"+schm+"' and TABLE_NAME='"+tbl+"'";
    var cols=wrk_query(q,"dsn");
    console.log(cols);
var tbl=document.createElement("table");
tbl.setAttribute("class","table table-stripped table-sm")
for(let i=0;i<cols.recordcount;i++){
    var tr=document.createElement("tr");

    var td=document.createElement("td");
        td.innerText=cols.COLUMN_NAME[i];
        tr.appendChild(td);

    var td=document.createElement("td");
        td.innerText=cols.DATA_TYPE[i];
        tr.appendChild(td);

    var td=document.createElement("td");
        td.innerText=cols.CHARACTER_MAXIMUM_LENGTH[i];
        tr.appendChild(td);

    tbl.appendChild(tr);
}

console.log(tbl)
    var w=window.open("","","width:80;height:150")
var p=document.createElement("p")
    p.innerText="Merhaba"
    w.document.write("<p>Kolonlar</p>")
    w.document.write('<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">')
$(w.document).find("p")[0].appendChild(tbl)

}
</script>