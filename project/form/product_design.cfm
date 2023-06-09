<cfquery name="getSettings" datasource="#dsn3#">
  SELECT * FROM PROJECT_PRODUCT_DESIGN_PARAMS_PBS
</cfquery>
<cfquery name="getQuestions" datasource="#dsn3#">
  SELECT * FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
</cfquery>
<script>
  var VIRTUAL_PRODUCT_TREE_QUESTIONS=[
      <cfoutput query="getQuestions">
          {
              QUESTION_ID:#ID#,
              QUESTION:'#QUESTION#'
          },
      </cfoutput>
  ]
</script>
<script>
  var ProductDesingSetting=[
      <cfoutput query="getSettings">
          <cfquery name="getRows" datasource="#dsn3#">
              SELECT * FROM PROJECT_PRODUCT_DESIGN_PARAMS_ROWS_PBS WHERE PARAM_ID =#getSettings.ID#
          </cfquery>
          {
              paramName:'#PARAM_NAME#',
              paramDescripton:'#PARAM_DESCRIPTION#',
              paramValue:'#PARAM_VALUE#',
              elementType:'#ELEMENT_TYPE#',
              paramOptions:[
                  <cfloop query="getRows">
                      {
                          optValue:'#OPT_VALUE#',
                          isActive:#IS_ACTIVE#
                      },
                  </cfloop>
              ]
          },
      </cfoutput>
  ]
</script>
<cfquery name="getMoney" datasource="#dsn#">
  SELECT 
(SELECT RATE1 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
(SELECT RATE2 FROM workcube_metosan.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM workcube_metosan.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE2,
SM.MONEY
FROM workcube_metosan.SETUP_MONEY AS SM WHERE SM.PERIOD_ID=#session.ep.period_id#
</cfquery>

<script>
   var moneyArr=[
       <cfoutput query="getMoney">
           {
               MONEY:"#MONEY#",
               RATE1:"#RATE1#",
               RATE2:"#RATE2#",
           },
       </cfoutput>
   ]
</script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfparam name="attributes.project_id" default="2563">

<style>
  .sortable1, #sortable2 {
    border: 1px solid #eee;
   
    min-height: 20px;
    list-style-type: none;
    margin: 0;
    padding: 5px 0 0 0;
    
    margin-right: 10px;
  }
  .sortable1 li, #sortable2 li {
    margin: 0 5px 5px 5px;
    padding: 5px;
    font-size: 1.2em;
    
  }
  .card-body {
  -ms-flex: 1 1 auto !important;
  flex: 1 1 auto !important;
  min-height: 1px !important;
  padding: 1.25rem !important;
  margin-top: 0px !important;
}
.btn i {
  margin: 0px 0px 0px 0px !important;
}
.btn-link {
  font-weight: 400;
  color: #007bff !important;
  text-decoration: none;
}
  </style>
<cfquery name="relProjects" datasource="#dsn#">
SELECT * FROM PRO_PROJECTS WHERE RELATED_PROJECT_ID=#attributes.PROJECT_ID#
</cfquery>

<cfquery name="getP" datasource="#dsn3#">
  SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
      LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
  WHERE PROJECT_ID=#attributes.PROJECT_ID#
 

</cfquery>
<cfset PListe=0>
<cfif listLen(valuelist(relProjects.PROJECT_ID))>
  <cfset PListe=valuelist(relProjects.PROJECT_ID)>
</cfif>
<cfquery name="getP2" datasource="#dsn3#"> 
      SELECT VP.*,0 AS  IS_MAIN,PTR.STAGE,SMC.MAIN_PROCESS_CAT FROM VIRTUAL_PRODUCTS_PRT  AS VP
      LEFT JOIN workcube_metosan.PRO_PROJECTS AS PP ON PP.PROJECT_ID=VP.PROJECT_ID
      LEFT JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
      LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE WHERE PP.PROJECT_ID IN(#PListe#)   
      
      AND VP.PRODUCT_STAGE=340
</cfquery>



<!----PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_DESCRIPTION---->
<div class="row">
  <div class="col col-3 col-md-3 col-sm-3 col-xs-12" style="border-right: solid 1px ##E08283;">
      <cf_box title="Ürünler">
          
     <div style="height:90vh">
  <div>
      <button type="button" onclick="newDraft()" class="btn btn-outline-primary">Yeni Taslak</button>
  </div>
  <div class="list-group" id="leftMenuProject"> 
      <cfoutput query="getP">      
          <a class="list-group-item list-group-item-action" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')">
              #PRODUCT_NAME#
              <cfif PRODUCT_STAGE eq 339>
                  <span style="float:right;font-size:11pt" class="badge bg-danger rounded-pill">#STAGE#</span>
              <cfelseif PRODUCT_STAGE eq 340>
                  <span style="float:right;font-size:11pt" class="badge bg-success rounded-pill">#STAGE#</span>
              <cfelseif PRODUCT_STAGE eq 341>
                  <span style="float:right;font-size:11pt" class="badge bg-warning rounded-pill">#STAGE#</span>
              <cfelse>
                  <span style="float:right;font-size:11pt" class="badge bg-dark rounded-pill">0</span>
              </cfif>              
          </a>     
      </cfoutput>
  </div>
      <hr>
      <div class="list-group" id="leftMenuProject"> 
          <cfoutput query="getP2">
            <a class="list-group-item list-group-item-action" >
           
              <button class="btn btn-sm btn-outline-primary" onclick="addToCurrentTree(#VIRTUAL_PRODUCT_ID#,'#PRODUCT_NAME#')">
                <i class="icn-md fa fa-plus"></i>
              </button>
              <button class="btn btn-sm btn-outline-warning" onclick="showTree(#VIRTUAL_PRODUCT_ID#)">
                  <i class="icn-md fa fa-search"></i>
              </button>
              <!----<span style="float:left;font-size:11pt;margin-right:10px" class="badge bg-primary rounded-pill" onclick="addToCurrentTree(#VIRTUAL_PRODUCT_ID#)">
                <i class="fa fa-plus"></i>
                </span>
              <span style="float:left;font-size:11pt;margin-right:10px" class="badge bg-primary rounded-pill" onclick="addToCurrentTree(#VIRTUAL_PRODUCT_ID#)">
              <i class="icn-md fa fa-search"></i>
              </span>
              ---->
              #PRODUCT_NAME#
              <cfif PRODUCT_STAGE eq 339>
                  <span style="float:right;font-size:11pt" class="badge bg-danger rounded-pill">#STAGE#</span>
              <cfelseif PRODUCT_STAGE eq 340>
                  <span style="float:right;font-size:11pt" class="badge bg-success rounded-pill">#STAGE#</span>
              <cfelseif PRODUCT_STAGE eq 341>
                  <span style="float:right;font-size:11pt" class="badge bg-warning rounded-pill">#STAGE#</span>
              <cfelse>
                  <span style="float:right;font-size:11pt" class="badge bg-dark rounded-pill">0</span>
              </cfif> 
              <div>
              <code style="display: table-cell;color:##e83e8c"><small style="font-size:8pt">#MAIN_PROCESS_CAT#</small></code>            
            </div>   
          </a>      
          
          </cfoutput>
        </div>
      </div>
  </cf_box>
  </div>
  <div class="col col-7 col-md-7 col-sm-7 col-xs-12" >
<cf_box title="Ürün Ağacı">
  <div style="display:flex;margin-bottom:5px">
      <button class="btn btn-outline-success" onclick="OpenBasketProducts(0,5)">RP</button>
      <button class="btn btn-outline-warning" style="margin-left:5px" onclick="addProdMain()">VP</button>
      <button onclick="Kaydet()" style="margin-left:5px"  class="btn btn-outline-primary">Kaydet</button>
      <input type="text" class="form-control" value="" id="pnamemain" name="pnamemain" style="margin-left: 15px;color: var(--success);" readonly>
      <cfquery name="getStages" datasource="#dsn3#">
          SELECT STAGE,PROCESS_ROW_ID FROM workcube_metosan.PROCESS_TYPE_ROWS WHERE PROCESS_ID=200
      </cfquery>
      <select class="form-control" name="pstage" id="pstage" style="width:33%" onchange="updateStage(this,<cfoutput>#attributes.project_id#</cfoutput>)">
          <option value="">Aşama</option>
          <cfoutput query="getStages">
              <option value="#PROCESS_ROW_ID#">#STAGE#</option>
          </cfoutput>
      </select>
      <input type="hidden" name="vp_id" id="vp_id" value="0">
      <input type="hidden" name="is_virtual" id="is_virtual" value="1">
      <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
  </div>
  <div style="position: absolute;bottom: 0;right: 0;"></div>
  <div id="TreeArea" style="height:85vh">

</div>
</cf_box>
</div>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" >
  <cf_box title="....">
      <div  style="height:79vh" id="settingsArea">
          <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" id="customSwitch1">
              <label class="custom-control-label" for="customSwitch1">Toggle this switch element</label>
            </div>
            <div class="custom-control custom-switch">
              <input type="checkbox" class="custom-control-input" disabled id="customSwitch2">
              <label class="custom-control-label" for="customSwitch2">Disabled switch element</label>
            </div>
      </div>
  </cf_box>
  
      <cf_box title="Maliyet">
          <input type="text" class="form-control" style="text-align:right" value="<cfoutput>#tlformat(0)#</cfoutput>">
      </cf_box>
      
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="/AddOns/Partner/project/js/urunAgaci.js"></script>


