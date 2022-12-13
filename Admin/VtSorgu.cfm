    <link rel="stylesheet" href="/JS/codemirror-5.65.0/lib/codemirror.css">
    <script src="/JS/codemirror-5.65.0/lib/codemirror.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/edit/matchbrackets.js"></script>
    <script src="/JS/codemirror-5.65.0/mode/sql/sql.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/show-hint.js"></script>
    <script src="/JS/codemirror-5.65.0/addon/hint/sql-hint.js"></script>


<cfparam  name="attributes.sql_sorgu" default="">
<div class="row">
<div class="cell-3">
<cfscript>
    hintoptions=structNew();
    hintoptions.tables=structNew();
</cfscript>
    <cfquery name="getT" datasource="#dsn#">
        SELECT * FROM sys.TABLES
    </cfquery>
    <div data-role="accordion" data-one-frame="true" data-show-active="true">
 <cfoutput query="getT">
        <div class="frame">
             <div class="heading">#NAME#</div>
              
            <div class="content">
                <div class="p-2">
                    <cfquery name="getinf" datasource="#dsn#">
                    select st.name as tipi,sc.name,sc.max_length,SC.is_identity from sys.columns as sc left join sys.systypes as st on sc.system_type_id=st.xusertype
                    where sc.object_id=#object_id#
                    </cfquery>
                    <table class="table striped compact">
                        <tr>
                        <th>Kolon</th>
                        <th>Tipi</th>
                        <th>Max length</th>
                        <th>identity</th>
                        </tr>
                        <cfloop query="getinf">
                        <tr>
                        <td>#name#</td>
                        <td>#tipi#</td>
                        <td>#max_length#</td>
                        <td>#is_identity#</td>
                        </tr>
                           <cfscript>
                        
                    </cfscript> 
                        </cfloop>
                        </table>
                     <cfscript>
      //StructInsert(hintoptions.tables, NAME, evaluate("#NAME#"));
      
  </cfscript>
                </div>
            </div>             
        </div>
     
 </cfoutput>
 </div>
</div>
<cfset hhopt=replace(serializeJSON(hintoptions),"//","")>
<script>
var hintOptions_=<cfoutput>#LCase(hhopt)#</cfoutput>;
</script>
<!---<cfdump  var="#hhopt#">--->
<div class="cell-9">
<cfform method="post" action="#request.self#?page=#attributes.page#"> 


<BR>
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
<table class="table striped compact" >
<thead>
<tr>
<th>#</th>
<cfloop list="#res.COLUMNLIST#" item="item">

<th><cfoutput>
#item#
</cfoutput></th>
</cfloop>
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
</table>
</cfif>
</div>
<p>Kayıt Sayısı:<code><cfoutput>#res.recordcount#</cfoutput></p>
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
    hintOptions:hintOptions_,

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