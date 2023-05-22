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
            <ul style="margin: 0;list-style: none;"> 
        <cfoutput query="getP">
            <li style="background: lightgrey;border-radius: 5px;">                
                    <div class="ui-cards ui-cards-vertical">                        
                        <div class="ui-cards-text">
                            <ul class="ui-info-list">
                                <li>
                                    Ürün Adı : <i>#PRODUCT_NAME#</i>
                                </li>                               
                                <li>
                                    Durum : <i>#STAGE#</i>
                                </li>                              
                            </ul>
                            <ul class="ui-icon-list">
                                <li><a href="javascript://" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#')" title="Görüntüle"><i class="icon-search">Görüntüle</i></a></li>
                            </ul>
                        </div>
                    </div>               
            </li>    
        </cfoutput>
        </ul>
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
    <div id="TreeArea" style="height:90vh">

</div>
</cf_box>
</div>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" >
    <cf_box title="....">
        <div  style="height:90vh">
    
    </div>
    </cf_box>
    </div>
</div>

<script src="/AddOns/Partner/project/js/urunAgaci.js"></script>


