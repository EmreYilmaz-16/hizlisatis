<cfquery name="relProjects" datasource="#dsn#">
    SELECT * FROM PRO_PROJECTS WHERE RELATED_PROJECT_ID=#attributes.PROJECT_ID#
    </cfquery>

<cfquery name="getP" datasource="#dsn3#">
    SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
    WHERE PROJECT_ID=#attributes.PROJECT_ID# AND PRODUCT_VERSION =''
   
  
  </cfquery>
  
  <cfquery name="getP_" datasource="#dsn3#">
    SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
    WHERE PROJECT_ID=#attributes.PROJECT_ID# AND PRODUCT_VERSION <>''
   </cfquery>
  <cfset PListe=0>
  <cfif listLen(valuelist(relProjects.PROJECT_ID))>
    <cfset PListe=valuelist(relProjects.PROJECT_ID)>
  </cfif>
  <cfquery name="getP2" datasource="#dsn3#"> 
        SELECT VP.*,0 AS  IS_MAIN,PTR.STAGE,SMC.MAIN_PROCESS_CAT FROM VIRTUAL_PRODUCTS_PRT  AS VP
        LEFT JOIN #dsn#.PRO_PROJECTS AS PP ON PP.PROJECT_ID=VP.PROJECT_ID
        LEFT JOIN #dsn#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE WHERE PP.PROJECT_ID IN(#PListe#)   
        
        AND VP.PRODUCT_STAGE=340
  </cfquery>
  
  <cfquery name="getP3" datasource="#dsn3#"> 
    SELECT 
  PRODUCT.PRODUCT_NAME,
  PRODUCT.PRODUCT_ID,
  SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT,
  VIRTUAL_PRODUCTS_PRT.VIRTUAL_PRODUCT_ID,
  VIRTUAL_PRODUCTS_PRT.PRODUCT_NAME AS VIRTUAL_PRODUCT_NAME,
  PROCESS_TYPE_ROWS.STAGE,
  PROCESS_ROW_ID AS PRODUCT_STAGE
   FROM #dsn1#.PRODUCT 
  LEFT JOIN #dsn3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS ON PRODUCT.PRODUCT_CATID=PRODUCT_CAT_PRODUCT_PARAM_SETTINGS.PRODUCT_CATID
  LEFT JOIN #dsn3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT ON MAIN_PROCESS_CAT_TO_PRODUCT_CAT.PRODUCT_CATID=PRODUCT.PRODUCT_CATID
  LEFT JOIN #dsn#.SETUP_MAIN_PROCESS_CAT ON SETUP_MAIN_PROCESS_CAT.MAIN_PROCESS_CAT_ID=MAIN_PROCESS_CAT_TO_PRODUCT_CAT.MAIN_PROCESS_CATID
  LEFT JOIN #dsn3#.VIRTUAL_PRODUCTS_PRT ON VIRTUAL_PRODUCTS_PRT.REAL_PRODUCT_ID=PRODUCT.PRODUCT_ID
  LEFT JOIN #dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID=VIRTUAL_PRODUCTS_PRT.PRODUCT_STAGE
   WHERE PRODUCT.PROJECT_ID =#attributes.PROJECT_ID#   
      
  </cfquery>

<cf_seperator id="getP" header="Ürünler"  style="display:none;">
    <div id="getP" style="display:none">
      <cfoutput query="getP">      
        <a class="list-group-item list-group-item-action" id="VP_#VIRTUAL_PRODUCT_ID#" >
            <input style="margin-right:10px" type="checkbox" name="crs_0#VIRTUAL_PRODUCT_ID#" class="vpchx" value="#VIRTUAL_PRODUCT_ID#">#PRODUCT_NAME#
            <button style="float:right" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')" class="btn btn-sm btn-outline-primary"><span class="icn-md fa fa-arrow-right"></span></button>    
            <cfif PRODUCT_STAGE eq 339>
                <span style="float:right;font-size:11pt;margin-right:10px" class="badge bg-danger rounded-pill">#STAGE#</span>
            <cfelseif PRODUCT_STAGE eq 340>
                <span style="float:right;font-size:11pt;margin-right:10px" class="badge bg-success rounded-pill">#STAGE#</span>
            <cfelseif PRODUCT_STAGE eq 341>
                <span style="float:right;font-size:11pt;margin-right:10px" class="badge bg-warning rounded-pill">#STAGE#</span>
            <cfelse>
                <span style="float:right;font-size:11pt;margin-right:10px" class="badge bg-dark rounded-pill">0</span>
            </cfif>                        
        </a>     
      </cfoutput>
    </div>
<cf_seperator id="getP_" header="Yarı Mamüller"  style="display:none;">
    <div id="getP_" style="display:none">
        <cfoutput query="getP_">      
        <a class="list-group-item list-group-item-action" id="VP_#VIRTUAL_PRODUCT_ID#" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#dsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')">
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
<cf_seperator id="getP2" header="Alt Proje Ürünleri"  style="display:none;">
    <div id="getP2"  style="display:none;">
        <cfoutput query="getP2">
        <a class="list-group-item list-group-item-action">           
            <button class="btn btn-sm btn-outline-primary" onclick="addToCurrentTree(#VIRTUAL_PRODUCT_ID#,'#PRODUCT_NAME#')">
            <i class="icn-md fa fa-plus"></i>
            </button>
            <button class="btn btn-sm btn-outline-warning" onclick="showTree(#VIRTUAL_PRODUCT_ID#)">
                <i class="icn-md fa fa-search"></i>
            </button>              
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
    <cf_seperator id="getP3" header="Oluşmuş Ürünler" closed="1" is_closed="1"  style="display:none;">
        <div id="getP3"  style="display:none;">
          <cfoutput query="getP3">      
            <a class="list-group-item list-group-item-action" onclick="ngetTree(#PRODUCT_ID#,0,'#dsn3#',this,1,'','#PRODUCT_NAME#','#STAGE#')">
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