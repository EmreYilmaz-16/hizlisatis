<cfquery name="relProjects" datasource="#dsn#">
SELECT * FROM workcube_metosan.PRO_PROJECTS WHERE RELATED_PROJECT_ID=#attributes.PROJECT_ID#
</cfquery>

<cfquery name="getP" datasource="#dsn3#">
    SELECT *,1 AS IS_MAIN FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID=#attributes.PROJECT_ID#
   

</cfquery>
<cfset PListe=0>
<cfif listLen(valuelist(relProjects.PROJECT_ID))>
    <cfset PListe=valuelist(relProjects.PROJECT_ID)>
</cfif>
<cfquery name="getP2" datasource="#dsn3#"> 
        SELECT *,0 AS IS_MAIN FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID IN(#PListe#)   
</cfquery>




<div class="row">
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12" style="border-right: solid 1px ##E08283;">
        <ul>
        <cfoutput query="getP">
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
        <div 
    </div>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12" >
<cf_box title="Ürün Ağacı">
    <div id="TreeArea">

</div>
</cf_box>
</div>
</div>