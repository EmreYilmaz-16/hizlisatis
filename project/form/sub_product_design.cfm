<cfquery name="getSettings" datasource="#dsn3#">
    SELECT * FROM PROJECT_PRODUCT_DESIGN_PARAMS_PBS
</cfquery>
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
        SELECT VP.*,0 AS  IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE WHERE PROJECT_ID IN(#PListe#)   
</cfquery>



<!----PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_DESCRIPTION---->
<div class="row">
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" style="border-right: solid 1px ##E08283;">
        <cf_box title="Ürünler">
            
       <div style="height:90vh">
    <div>
        <button type="button" onclick="newDraft()" class="btn btn-outline-primary">Yeni Taslak</button>
    </div>
        <cfoutput query="getP">
           <!---- <li style="background: lightgrey;border-radius: 5px;">                
                    <div class="ui-cards ui-cards-vertical">                        
                        <div class="ui-cards-text">
                            <ul class="ui-info-list">
                                <li>
                                    Ürün Adı : <i></i>
                                </li>                               
                                <li>
                                    Durum : <i></i>
                                </li>                              
                            </ul>
                            <ul class="ui-icon-list">
                                <li><a href="javascript://" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#')" title="Görüntüle"></a></li>
                            </ul>
                        </div>
                    </div>               
            </li>    ------>
           
            <div class="card">
              
                <div class="card-body">
                  <h5 class="card-title">#PRODUCT_NAME#</h5>
                  <p class="card-text">#STAGE#</p>
                  <button type="button" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#')"  class="btn btn-primary"><i class="icon-search"></i> Görüntüle</button>
                </div>
              </div>
            
        </cfoutput>
        
        <hr>
        <ul>
            <cfoutput query="getP2">
                <li>                
                        <div class="ui-cards ui-cards-vertical">                        
                            <div class="ui-cards-text">
                                <ul class="ui-info-list">
                                    <li>
                                        Ürün Adı : <i>Apple XR</i>
                                    </li>
                                    <li>
                                        Kategori : <i>Telefon</i>
                                    </li>
                                    <li>
                                        Durum : <i>Stokda Var</i>
                                    </li>                              
                                </ul>
                                <ul class="ui-icon-list">
                                    <li><a href="javascript://" title="Görüntüle"><i class="icon-search"></i></a></li>
                                </ul>
                            </div>
                        </div>               
                </li>    
            </cfoutput>
            </ul>
        </div>
    </cf_box>
    </div>
    <div class="col col-7 col-md-7 col-sm-7 col-xs-12" >
<cf_box title="Ürün Ağacı">
    <div style="display:flex;margin-bottom:5px">
        <button class="btn btn-outline-success" onclick="OpenBasketProducts(0,5)">RP</button>
        <button class="btn btn-outline-warning" style="margin-left:5px" onclick="addProdMain()">VP</button>
        <button onclick="Kaydet()" style="margin-left:5px"  class="btn btn-outline-primary">Kaydet</button>
        <input type="text" class="form-control" value="" id="pnamemain" name="pnamemain" style="margin-left: 15px;color: var(--success);">
    </div>
    <div style="position: absolute;bottom: 0;right: 0;"></div>
    <div id="TreeArea" style="height:90vh">

</div>
</cf_box>
</div>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" >
    <cf_box title="....">
        <div  style="height:84vh" id="settingsArea">
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
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="/AddOns/Partner/project/js/urunAgaci.js"></script>


