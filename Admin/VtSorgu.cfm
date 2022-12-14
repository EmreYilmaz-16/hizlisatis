    <link rel="stylesheet" href="/JS/codemirror-5.65.0/lib/codemirror.css">
    <script src="/JS/codemirror-5.65.0/lib/codemirror.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/edit/matchbrackets.js"></script>
    <script src="/JS/codemirror-5.65.0/mode/sql/sql.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/show-hint.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/sql-hint.js"></script>


<cfparam  name="attributes.sql_sorgu" default="">
    <cfquery name="getT" datasource="#dsn#">
    select ST.name,ss.name as schema_namea from workcube_metosan.sys.tables AS ST 
LEFT JOIN workcube_metosan.SYS.schemas AS SS ON SS.schema_id=ST.schema_id
order by st.schema_id

    </cfquery>
<div style="display:flex;">
    <div style="width:25%;height: 100vh;overflow: scroll;">
    <cf_big_list>
        <cfoutput query="getT">
        <tr><td>#schema_namea#-#name#</td></tr>
        </cfoutput>
    </cf_big_list>
    </div>
    <div style="width:74%">
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
</script>