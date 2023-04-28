<cfquery name="relProjects" datasource="#dsn#">
SELECT * FROM workcube_metosan.PRO_PROJECTS WHERE RELATED_PROJECT_ID=#attributes.PROJECT_ID#
</cfquery>

<cfquery name="getP" datasource="#dsn3#">
    SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
    WHERE PROJECT_ID=#attributes.PROJECT_ID#
   

</cfquery>
<cfset PListe=0>
<cfif listLen(valuelist(relProjects.PROJECT_ID))>
    <cfset PListe=valuelist(relProjects.PROJECT_ID)>
</cfif>
<cfquery name="getP2" datasource="#dsn3#"> 
        SELECT VP.*,0 AS  IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE WHERE PROJECT_ID IN(#PListe#)   
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
                                <li><a href="javascript://" onclick="AjaxPageLoad('/index.cfm=fuseaction=project.emptypopup_show_tree_bs&vp_id=#VIRTUAL_PRODUCT_ID#','TreeArea')" title="Görüntüle"><i class="icon-search"></i></a></li>
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