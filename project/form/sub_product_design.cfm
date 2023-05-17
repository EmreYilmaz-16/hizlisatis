<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous">
</script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/devexpress-diagram/2.1.72/dx-diagram.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/devexpress-gantt/4.1.43/dx-gantt.min.css" rel="stylesheet">


<script src="https://code.jquery.com/jquery-3.6.3.js"
integrity="sha256-nQLuAZGRRcILA+6dMBOvcRh5Pe310sBpanc6+QBmyVM=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous">
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"
integrity="sha384-mQ93GR66B00ZXjt0YO5KlohRA5SY2XofN4zfuZxLkoj1gXtW8ANNCe9d5Y3eG5eD" crossorigin="anonymous">
</script>
<!-- Diagram and Gantt -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/devexpress-diagram/2.1.72/dx-diagram.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/devexpress-gantt/4.1.43/dx-gantt.min.js"></script>
 
<!-- DevExtreme Quill (required by the HtmlEditor UI component) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/devextreme-quill/1.5.20/dx-quill.min.js"></script>
 
<!-- DevExtreme library -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/devextreme/22.2.6/js/dx.all.js"></script>
 
<!-- DevExpress.AspNet.Data -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/devextreme-aspnet-data/2.9.2/dx.aspnet.data.min.js"></script>

<cfparam name="attributes.project_id" default="2563">
<cfset dsn3=dsn>
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
        LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
    WHERE PROJECT_ID=#attributes.PROJECT_ID#
   

</cfquery>
<cfset PListe=0>
<cfif listLen(valuelist(relProjects.PROJECT_ID))>
    <cfset PListe=valuelist(relProjects.PROJECT_ID)>
</cfif>
<cfquery name="getP2" datasource="#dsn3#"> 
        SELECT VP.*,0 AS  IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE WHERE PROJECT_ID IN(#PListe#)   
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
                                <li><a href="javascript://" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1)" title="Görüntüle"><i class="icon-search">Görüntüle</i></a></li>
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


