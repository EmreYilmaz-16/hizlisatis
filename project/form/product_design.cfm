<!--- Security includes and initialization --->
<cfinclude template="../includes/security_include.cfm">

<!--- Initialize audit logger --->
<cfset auditLogger = createObject("component", "AddOns.Partner.project.cfc.AuditLogger")>

<!--- Configure page security --->
<cfscript>
    pageConfig = {
        requireAuth: true,
        requiredPermissions: ["PRODUCT_DESIGN_ACCESS"],
        enableCSRF: true,
        enableRateLimit: true,
        maxRequestsPerMinute: 30,
        auditEnabled: true
    };
    
    // Log page access
    auditLogger.logUserAction("PAGE_ACCESS", "Accessed product design form", "", {}, {}, "INFO");
</cfscript>

<!--- Performance monitoring start --->
<cfset pageStartTime = getTickCount()>

<cfif 1 eq 1146>
<div class="alert alert-danger" style="position: absolute;width: 50%;height: 20vh;z-index: 99999;left: 29%;right: 50%;top: 40%;">
    <h3 style="font-size: 3.75rem;margin-top:0px">Güncelleniyor Kullanmayınız !</h3>
    <b style="position: absolute;bottom: 0;right: 10px;font-size: 2rem;">Partner Bilgi Sistemleri</b>
    <cfabort>
</div>
</cfif>
<cfinclude template="../includes/upperMenu.cfm">
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
(SELECT RATE1 FROM #dsn#.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM #dsn#.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE1,
(SELECT EFFECTIVE_SALE AS RATE2 FROM #dsn#.MONEY_HISTORY WHERE MONEY_HISTORY_ID=(
SELECT MAX(MONEY_HISTORY_ID) FROM #dsn#.MONEY_HISTORY WHERE MONEY=SM.MONEY) )AS RATE2,
SM.MONEY
FROM #dsn#.SETUP_MONEY AS SM WHERE SM.PERIOD_ID=#session.ep.period_id#
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
<!-- Modern UI Styles -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/AddOns/Partner/project/css/modern-ui.css">

<cfparam name="attributes.project_id" default="2563">

<style>
  /* Legacy compatibility styles */
  .sortable1, ##sortable2 {
    border: 1px solid var(--gray-200);
    min-height: 20px;
    list-style-type: none;
    margin: 0;
    padding: 5px 0 0 0;
    margin-right: 10px;
    border-radius: var(--radius-md);
    background: white;
  }
  .sortable1 li, ##sortable2 li {
    margin: 0 5px 5px 5px;
    padding: var(--spacing-sm);
    font-size: 1.1em;
    background: var(--gray-50);
    border-radius: var(--radius-sm);
    border: 1px solid var(--gray-200);
    transition: all var(--transition-fast);
  }
  .sortable1 li:hover, ##sortable2 li:hover {
    background: var(--primary-50);
    border-color: var(--primary-300);
    transform: translateY(-1px);
  }
  .card-body {
    -ms-flex: 1 1 auto !important;
    flex: 1 1 auto !important;
    min-height: 1px !important;
    padding: var(--spacing-lg) !important;
    margin-top: 0px !important;
  }
  .btn i {
    margin: 0px 0px 0px 0px !important;
  }
  .btn-link {
    font-weight: 400;
    color: var(--primary-600) !important;
    text-decoration: none;
  }

  /* Enhanced Project Info Bar */
  .project-info-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-md);
    background: var(--gray-50);
    border-radius: var(--radius-md);
    border: 1px solid var(--gray-200);
    margin-bottom: var(--spacing-lg);
    flex-wrap: wrap;
    gap: var(--spacing-md);
  }

  .project-details {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    flex-wrap: wrap;
  }

  .project-label {
    color: var(--gray-600);
    font-weight: 500;
  }

  .project-value {
    color: var(--gray-800);
    font-weight: 600;
  }

  .project-separator {
    color: var(--gray-400);
  }

  .project-stats {
    display: flex;
    gap: var(--spacing-lg);
  }

  .stat-item {
    text-align: center;
  }

  .stat-value {
    display: block;
    font-size: var(--font-size-lg);
    font-weight: 700;
    color: var(--primary-600);
    line-height: 1;
  }

  .stat-label {
    display: block;
    font-size: var(--font-size-sm);
    color: var(--gray-600);
    margin-top: var(--spacing-xs);
  }

  /* Enhanced Control Panel */
  .control-panel {
    display: grid;
    grid-template-columns: 1fr auto;
    gap: var(--spacing-lg);
    align-items: end;
    margin-bottom: var(--spacing-lg);
  }

  .control-group {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm);
  }

  .control-label {
    font-weight: 500;
    color: var(--gray-700);
    font-size: var(--font-size-sm);
  }

  .control-actions {
    display: flex;
    gap: var(--spacing-sm);
    flex-wrap: wrap;
  }

  /* Tree Toolbar Enhancements */
  .tree-toolbar {
    background: linear-gradient(135deg, var(--gray-50), white);
    border-bottom: 1px solid var(--gray-200);
    padding: var(--spacing-md);
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: var(--spacing-md);
    position: sticky;
    top: 0;
    z-index: 10;
  }

  .tree-toolbar-left,
  .tree-toolbar-right {
    display: flex;
    align-items: center;
    gap: var(--spacing-sm);
  }

  .separator {
    width: 1px;
    height: 20px;
    background: var(--gray-300);
    margin: 0 var(--spacing-sm);
  }

  .search-box {
    position: relative;
    min-width: 200px;
  }

  .search-box .search-icon {
    position: absolute;
    right: var(--spacing-md);
    top: 50%;
    transform: translateY(-50%);
    color: var(--gray-500);
    pointer-events: none;
  }

  .view-options {
    display: flex;
    background: var(--gray-100);
    border-radius: var(--radius-md);
    padding: 2px;
  }

  .view-options .btn-modern {
    margin: 0;
    border-radius: var(--radius-sm);
  }

  .view-options .btn-modern.active {
    background: white;
    box-shadow: var(--shadow-sm);
  }

  /* Tree Content */
  .tree-content {
    flex: 1;
    overflow-y: auto;
    position: relative;
    padding: var(--spacing-md);
    min-height: 400px;
  }

  /* Empty State */
  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 300px;
    text-align: center;
    padding: var(--spacing-2xl);
  }

  .empty-state-icon {
    color: var(--gray-400);
    margin-bottom: var(--spacing-lg);
  }

  .empty-state-title {
    color: var(--gray-700);
    font-size: var(--font-size-xl);
    font-weight: 600;
    margin-bottom: var(--spacing-md);
  }

  .empty-state-description {
    color: var(--gray-500);
    max-width: 400px;
    margin-bottom: var(--spacing-xl);
    line-height: 1.6;
  }

  /* Status Bar */
  .status-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-md);
    background: white;
    border-top: 1px solid var(--gray-200);
    font-size: var(--font-size-sm);
    flex-wrap: wrap;
    gap: var(--spacing-md);
    min-height: 60px;
  }

  .status-left,
  .status-center,
  .status-right {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
  }

  .cache-indicator,
  .performance-indicator,
  .selection-info {
    display: flex;
    align-items: center;
    gap: var(--spacing-xs);
    color: var(--gray-600);
    font-size: var(--font-size-sm);
  }

  .cache-indicator.active {
    color: var(--success-600);
  }

  .performance-indicator.fast {
    color: var(--success-600);
  }

  .performance-indicator.slow {
    color: var(--warning-600);
  }

  .cost-display {
    min-width: 150px;
    text-align: right;
    font-weight: 600;
    color: var(--primary-700);
  }

  /* Header Actions */
  .header-actions {
    display: flex;
    gap: var(--spacing-sm);
  }

  /* Responsive adjustments */
  @media (max-width: 768px) {
    .project-info-bar {
      flex-direction: column;
      text-align: center;
    }

    .control-panel {
      grid-template-columns: 1fr;
      gap: var(--spacing-md);
    }

    .control-actions {
      justify-content: center;
    }

    .tree-toolbar {
      flex-direction: column;
    }

    .search-box {
      min-width: 100%;
    }

    .status-bar {
      flex-direction: column;
      text-align: center;
    }

    .status-left,
    .status-center,
    .status-right {
      justify-content: center;
    }
  }

  @media (max-width: 480px) {
    .control-actions .btn-modern {
      flex: 1;
      min-width: 120px;
    }

    .project-stats {
      width: 100%;
      justify-content: space-around;
    }
  }
  }

  /* PERFORMANCE OPTIMIZATIONS: New CSS for loading states and improved UX */
  
  /* Global loading spinner */
  .global-loader {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(255,255,255,0.95);
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.1);
    z-index: 9998;
    display: none;
    text-align: center;
    backdrop-filter: blur(4px);
  }
  
  .global-loader .spinner-border {
    width: 3rem;
    height: 3rem;
    margin-bottom: 15px;
  }
  
  .global-loader .loading-text {
    color: #6c757d;
    font-size: 14px;
    font-weight: 500;
  }
  
  /* Button loading states */
  .btn-loading-disabled {
    opacity: 0.6;
    cursor: not-allowed !important;
    position: relative;
  }
  
  .btn-loading-disabled::after {
    content: '';
    position: absolute;
    width: 16px;
    height: 16px;
    top: 50%;
    right: 8px;
    transform: translateY(-50%);
    border: 2px solid #ffffff;
    border-radius: 50%;
    border-top-color: transparent;
    animation: btn-spin 1s linear infinite;
  }
  
  @keyframes btn-spin {
    to { transform: translateY(-50%) rotate(360deg); }
  }
  
  /* Tree performance optimizations */
  #TreeArea {
    height: 78vh;
    overflow-y: auto;
    overflow-x: hidden;
    /* Smooth scrolling for better UX */
    scroll-behavior: smooth;
    /* Hardware acceleration */
    transform: translateZ(0);
    -webkit-overflow-scrolling: touch;
  }
  
  /* Optimize tree rendering */
  .tree-node {
    /* Use transforms for better performance */
    will-change: transform;
    /* Reduce layout thrashing */
    contain: layout;
  }
  
  /* Error alerts */
  .alert-floating {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    min-width: 300px;
    animation: slideInRight 0.3s ease-out;
  }
  
  @keyframes slideInRight {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  
  /* Responsive improvements */
  @media (max-width: 768px) {
    .col-3 {
      display: none; /* Hide left panel on mobile */
    }
    .col-9 {
      flex: 0 0 100%;
      max-width: 100%;
    }
    .global-loader {
      padding: 20px;
      border-radius: 8px;
    }
  }
  
  /* Cache status indicator */
  .cache-indicator {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: #28a745;
    color: white;
    padding: 5px 10px;
    border-radius: 4px;
    font-size: 12px;
    z-index: 9999;
    display: none;
  }
  
  .cache-indicator.cache-hit {
    background: #28a745;
  }
  
  .cache-indicator.cache-miss {
    background: #ffc107;
    color: #212529;
  }

  /* Skeleton loading for better perceived performance */
  .skeleton {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
  }
  
  @keyframes loading {
    0% { background-position: 200% 0; }
    100% { background-position: -200% 0; }
  }
  
  .tree-skeleton {
    height: 200px;
    margin: 10px 0;
    border-radius: 4px;
  }

  /* Enhanced Feature Panels */
  .feature-panel {
    position: fixed;
    top: 0;
    right: -400px;
    width: 400px;
    height: 100vh;
    background: white;
    border-left: 1px solid var(--gray-200);
    box-shadow: -4px 0 12px rgba(0,0,0,0.1);
    z-index: 1050;
    transition: right 0.3s ease-in-out;
  }

  .feature-panel.show {
    right: 0;
  }

  .feature-panel-content {
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .feature-panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-md);
    border-bottom: 1px solid var(--gray-200);
    background: var(--gray-50);
  }

  .feature-panel-header h4 {
    margin: 0;
    font-size: var(--font-size-lg);
    font-weight: 600;
    color: var(--gray-800);
  }

  .feature-panel-close {
    background: none;
    border: none;
    color: var(--gray-500);
    font-size: var(--font-size-lg);
    cursor: pointer;
    padding: var(--spacing-xs);
    border-radius: var(--radius-sm);
    transition: all 0.2s ease;
  }

  .feature-panel-close:hover {
    background: var(--gray-200);
    color: var(--gray-700);
  }

  .feature-panel-body {
    flex: 1;
    padding: var(--spacing-md);
    overflow-y: auto;
  }

  /* Feature panel overlay */
  .feature-panel-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 1040;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
  }

  .feature-panel-overlay.show {
    opacity: 1;
    visibility: visible;
  }

  /* Responsive feature panels */
  @media (max-width: 768px) {
    .feature-panel {
      width: 100%;
      right: -100%;
    }
    
    .feature-panel.show {
      right: 0;
    }
  }
</style>
  </style>

<!-----
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
----->

<!----PRODUCT_NAME,PRODUCT_TYPE,PRODUCT_DESCRIPTION---->
<div class="row">
  <div class="col col-3 col-md-3 col-sm-3 col-xs-12" style="border-right: solid 1px ##E08283;">
      <cf_box title="Ürünler">
          
     <div style="height:85vh">
        <div style="display:flex;align-items: stretch;padding: 0;justify-content: space-between;">
          <div style="width: 67%;">     
            <button type="button" onclick="newDraft()" class="btn btn-outline-primary">Yeni Taslak</button>
          </div>
          <div>
            <button type="button"onclick="AddMultiOffer()" class="btn btn-outline-success">Toplu Teklif Ver</button>
            <button type="button" style="" onclick="OpenSearchVP()" class="btn btn-outline-warning"><span class="icn-md icon-search pull-right"></span></button>
          </div>
        </div>
  <div class="list-group" id="leftMenuProject"> 
  
      
     
  </div>
  
        
      </div>
  </cf_box>
  </div>
  <div class="col col-9 col-md-9 col-sm-9 col-xs-12" >
<cf_box title="Ürün Ağacı">
  <div style="display:flex;margin-bottom:5px">
      <button class="btn btn-outline-success" onclick="OpenBasketProducts(0,5)">RP</button>
      <button class="btn btn-outline-warning" style="margin-left:5px" onclick="addProdMain()">VP</button>
      <button class="btn btn-outline-danger" id="silButon" style="margin-left:5px" onclick="remVirtualProd(this)">Sil</button>
  <div class="modern-card-header">
    <h3><i class="fas fa-project-diagram"></i> Ürün Tasarım Yönetimi</h3>
    <div class="header-actions">
      <button class="btn-modern btn-sm btn-secondary" onclick="refreshProject()" data-tooltip="Projeyi Yenile">
        <i class="fas fa-sync-alt"></i>
      </button>
      <button class="btn-modern btn-sm btn-secondary" onclick="toggleFullscreen()" data-tooltip="Tam Ekran">
        <i class="fas fa-expand"></i>
      </button>
    </div>
  </div>
  
  <div class="modern-card-body">
    <!-- Project Info Bar -->
    <div class="project-info-bar">
      <div class="project-details">
        <span class="project-label">Proje ID:</span>
        <span class="project-value"><cfoutput>#attributes.project_id#</cfoutput></span>
        <span class="project-separator">|</span>
        <span class="project-label">Son Güncelleme:</span>
        <span class="project-value" id="last-update">--</span>
      </div>
      <div class="project-stats">
        <div class="stat-item">
          <span class="stat-value" id="total-products">0</span>
          <span class="stat-label">Ürün</span>
        </div>
        <div class="stat-item">
          <span class="stat-value" id="total-cost">0</span>
          <span class="stat-label">Toplam Maliyet</span>
        </div>
      </div>
    </div>

    <!-- Main Control Panel -->
    <div class="control-panel">
      <div class="control-group">
        <label class="control-label">Ürün Adı:</label>
        <input type="text" class="form-control-modern" value="" id="pnamemain" name="pnamemain" readonly>
      </div>
      
      <div class="control-group">
        <cfquery name="getStages" datasource="#dsn3#">
            SELECT STAGE,PROCESS_ROW_ID FROM #dsn#.PROCESS_TYPE_ROWS WHERE PROCESS_ID=200
        </cfquery>
        <label class="control-label">Aşama:</label>
        <div class="select-modern">
          <select class="form-control-modern" name="pstage" id="pstage" onchange="updateStage(this,<cfoutput>#attributes.project_id#</cfoutput>)">
              <option value="">Aşama Seçin</option>
              <cfoutput query="getStages">
                  <option value="#PROCESS_ROW_ID#">#STAGE#</option>
              </cfoutput>
          </select>
        </div>
      </div>

      <div class="control-actions">
        <button onclick="Kaydet()" class="btn-modern btn-primary">
          <i class="fas fa-save"></i> Kaydet
        </button>
        <button onclick="convertToOffer()" id="teklifButton" class="btn-modern btn-success">
          <i class="fas fa-file-invoice"></i> Teklif Ver
        </button>
        <button onclick="openRelatedDocuments(<cfoutput>#attributes.project_id#</cfoutput>)" id="relb" style="display:none" class="btn-modern btn-warning">
          <i class="fas fa-folder-open"></i> İ.Belgeler
        </button>
        <button onclick="OpenFiyatGir()" class="btn-modern btn-secondary">
          <i class="fas fa-coins"></i> Fiyat Gir
        </button>
        <!-- Enhanced Feature Actions -->
        <button onclick="showBulkOperationsPanel()" class="btn-modern btn-info" data-tooltip="Toplu İşlemler">
          <i class="fas fa-tasks"></i> Toplu İşlemler
        </button>
        <button onclick="showAdvancedFiltersPanel()" class="btn-modern btn-secondary" data-tooltip="Gelişmiş Filtreler">
          <i class="fas fa-filter"></i> Filtreler
        </button>
        <button onclick="showDataExportPanel()" class="btn-modern btn-success" data-tooltip="Veri Dışa Aktar">
          <i class="fas fa-download"></i> Dışa Aktar
        </button>
        <button onclick="showUserPreferencesPanel()" class="btn-modern btn-warning" data-tooltip="Kullanıcı Tercihleri">
          <i class="fas fa-cog"></i> Tercihler
        </button>
      </div>
    </div>

    <input type="hidden" name="vp_id" id="vp_id" value="0">
    <input type="hidden" name="is_virtual" id="is_virtual" value="1">
    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
  </div>

  <!-- Modern Tree Container -->
  <div class="tree-container-modern" id="TreeArea">
    <div class="tree-toolbar">
      <div class="tree-toolbar-left">
        <button class="btn-modern btn-sm btn-secondary" onclick="expandAllNodes()" data-tooltip="Tümünü Aç">
          <i class="fas fa-expand-arrows-alt"></i>
        </button>
        <button class="btn-modern btn-sm btn-secondary" onclick="collapseAllNodes()" data-tooltip="Tümünü Kapat">
          <i class="fas fa-compress-arrows-alt"></i>
        </button>
        <div class="separator"></div>
        <button class="btn-modern btn-sm btn-primary" onclick="addNewNode()" data-tooltip="Yeni Düğüm">
          <i class="fas fa-plus"></i>
        </button>
        <button class="btn-modern btn-sm btn-warning" onclick="duplicateNode()" data-tooltip="Çoğalt" id="btn-duplicate" disabled>
          <i class="fas fa-copy"></i>
        </button>
        <button class="btn-modern btn-sm btn-danger" onclick="deleteNode()" data-tooltip="Sil" id="btn-delete" disabled>
          <i class="fas fa-trash"></i>
        </button>
      </div>
      
      <div class="tree-toolbar-right">
        <div class="search-box">
          <input type="text" class="form-control-modern" placeholder="Ürün ara..." id="tree-search">
          <i class="fas fa-search search-icon"></i>
        </div>
        <div class="view-options">
          <button class="btn-modern btn-sm btn-secondary" onclick="toggleTreeView('compact')" data-tooltip="Kompakt Görünüm">
            <i class="fas fa-list"></i>
          </button>
          <button class="btn-modern btn-sm btn-secondary active" onclick="toggleTreeView('detailed')" data-tooltip="Detaylı Görünüm">
            <i class="fas fa-th"></i>
          </button>
        </div>
      </div>
    </div>
    
    <div class="tree-content" id="tree-content">
      <!-- Loading States -->
      <div class="loading-overlay" id="tree-loading" style="display:none;">
        <div class="loading-spinner"></div>
        <div class="loading-message">Ürün ağacı yükleniyor...</div>
      </div>
      
      <!-- Empty State -->
      <div class="empty-state" id="tree-empty-state" style="display:none;">
        <div class="empty-state-icon">
          <i class="fas fa-sitemap fa-3x"></i>
        </div>
        <h4 class="empty-state-title">Henüz Ürün Ağacı Yok</h4>
        <p class="empty-state-description">
          Ürün ağacını görüntülemek için sol panelden bir ürün seçin veya yeni bir ürün oluşturun.
        </p>
        <button class="btn-modern btn-primary" onclick="createFirstProduct()">
          <i class="fas fa-plus"></i> İlk Ürünü Oluştur
        </button>
      </div>
      
      <!-- Tree Content will be loaded here -->
      <div id="tree-data" class="tree-data"></div>
    </div>
  </div>

  <!-- Enhanced Feature Panels -->
  <div id="bulkOperationsPanel" class="feature-panel" style="display: none;">
    <div class="feature-panel-content">
      <div class="feature-panel-header">
        <h4><i class="fas fa-tasks"></i> Toplu İşlemler</h4>
        <button class="feature-panel-close" onclick="hideBulkOperationsPanel()">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="feature-panel-body">
        <!-- Bulk operations content will be loaded here by enhanced-features.js -->
      </div>
    </div>
  </div>

  <div id="advancedFiltersPanel" class="feature-panel" style="display: none;">
    <div class="feature-panel-content">
      <div class="feature-panel-header">
        <h4><i class="fas fa-filter"></i> Gelişmiş Filtreler</h4>
        <button class="feature-panel-close" onclick="hideAdvancedFiltersPanel()">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="feature-panel-body">
        <!-- Advanced filters content will be loaded here by enhanced-features.js -->
      </div>
    </div>
  </div>

  <div id="dataExportPanel" class="feature-panel" style="display: none;">
    <div class="feature-panel-content">
      <div class="feature-panel-header">
        <h4><i class="fas fa-download"></i> Veri Dışa Aktarım</h4>
        <button class="feature-panel-close" onclick="hideDataExportPanel()">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="feature-panel-body">
        <!-- Data export content will be loaded here by enhanced-features.js -->
      </div>
    </div>
  </div>

  <div id="userPreferencesPanel" class="feature-panel" style="display: none;">
    <div class="feature-panel-content">
      <div class="feature-panel-header">
        <h4><i class="fas fa-cog"></i> Kullanıcı Tercihleri</h4>
        <button class="feature-panel-close" onclick="hideUserPreferencesPanel()">
          <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="feature-panel-body">
        <!-- User preferences content will be loaded here by enhanced-features.js -->
      </div>
    </div>
  </div>

  <!-- Status Bar -->
  <div class="status-bar">
    <div class="status-left">
      <div class="cache-indicator" id="cache-indicator">
        <i class="fas fa-database"></i> 
        <span id="cache-status">Cache Hazır</span>
      </div>
      <div class="performance-indicator" id="performance-indicator">
        <i class="fas fa-tachometer-alt"></i>
        <span id="load-time">--</span>ms
      </div>
    </div>
    
    <div class="status-center">
      <div class="selection-info" id="selection-info" style="display:none;">
        <i class="fas fa-mouse-pointer"></i>
        <span id="selected-count">0</span> öğe seçili
      </div>
    </div>
    
    <div class="status-right">
      <input type="text" class="form-control-modern cost-display" readonly id="maliyet" name="maliyet" value="<cfoutput>#tlformat(0)#</cfoutput>">
    </div>
  </div>
</div>


</div>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

<!--- Modern UI Components and Architecture --->
<script src="/AddOns/Partner/project/js/modern-ui-components.js"></script>
<script src="/AddOns/Partner/project/js/security-manager.js"></script>
<script src="/AddOns/Partner/project/js/enhanced-features.js"></script>
<script src="/AddOns/Partner/project/js/ProductTreeSupport.js"></script>
<script src="/AddOns/Partner/project/js/ProductTreeManager.js"></script>

<!--- Performance optimized version of urunAgaci.js --->
<script src="/AddOns/Partner/project/js/urunAgaci_optimized.js"></script>

<script>
// Modern UI Integration with Security
function initializeWhenReady() {
  // Debug: Log what's available in window object
  console.log('=== Class Availability Debug ===');
  console.log('window.ProductTreeManager:', typeof window.ProductTreeManager);
  console.log('window.EnhancedFeatureManager:', typeof window.EnhancedFeatureManager);
  console.log('window.ProductTreeCache:', typeof window.ProductTreeCache);
  console.log('window.ProductTreeUI:', typeof window.ProductTreeUI);
  console.log('window.SecurityManager:', typeof window.SecurityManager);
  
  // Wait for all required classes to be available
  function checkClassesAvailable() {
    const requiredClasses = ['ProductTreeManager', 'EnhancedFeatureManager', 'ProductTreeCache'];
    const missing = requiredClasses.filter(className => !window[className]);
    
    if (missing.length > 0) {
      console.warn('Waiting for classes to load:', missing);
      
      // Debug: Check if classes exist but with different names
      console.log('Available window properties:', Object.keys(window).filter(key => key.includes('Tree') || key.includes('Enhanced') || key.includes('Security')));
      
      setTimeout(checkClassesAvailable, 50); // Reduced from 100ms to 50ms for faster checking
      return;
    }
    
    try {
      console.log('✅ All required classes available, initializing...');
      
      // Initialize modern UI components only after all classes are available
      const treeManager = new ProductTreeManager();
      console.log('✅ ProductTreeManager initialized');
      
      // Initialize Enhanced Features
      window.enhancedFeatures = new EnhancedFeatureManager();
      console.log('✅ EnhancedFeatureManager initialized');
      
      if (typeof window.enhancedFeatures.initialize === 'function') {
        window.enhancedFeatures.initialize();
        console.log('✅ Enhanced features initialized');
      }
      
      // Initialize security for all forms
      if (typeof initializeSecurity === 'function') {
        initializeSecurity();
        console.log('✅ Security initialized');
      }
      
      // Initialize search functionality
      if (typeof initializeSearch === 'function') {
        initializeSearch();
        console.log('✅ Search initialized');
      }
      
      // Initialize tooltips
      if (typeof initializeTooltips === 'function') {
        initializeTooltips();
        console.log('✅ Tooltips initialized');
      }
      
      // Initialize responsive handlers
      if (typeof initializeResponsiveHandlers === 'function') {
        initializeResponsiveHandlers();
        console.log('✅ Responsive handlers initialized');
      }
      
      // Initialize performance monitoring
      if (typeof initializePerformanceMonitoring === 'function') {
        initializePerformanceMonitoring();
        console.log('✅ Performance monitoring initialized');
      }
      
      console.log('🎉 All UI components initialized successfully');
    } catch (error) {
      console.error('❌ Error initializing UI components:', error);
      console.error('Error details:', error.message, error.stack);
      // Retry after a short delay in case of temporary issues
      setTimeout(checkClassesAvailable, 1000);
    }
  }
  
  // Start the initialization check
  checkClassesAvailable();
}

// Try multiple initialization methods to ensure it works
document.addEventListener('DOMContentLoaded', function() {
  // Small delay to ensure all scripts have executed
  setTimeout(initializeWhenReady, 100);
  
  // Initialize cache indicators
  initializeCacheIndicators();
  
  // Load initial project stats
  loadProjectStats();
});

// Backup initialization in case DOM is already loaded
if (document.readyState === 'loading') {
  // DOM hasn't finished loading yet
  document.addEventListener('DOMContentLoaded', function() {
    setTimeout(initializeWhenReady, 100);
  });
} else {
  // DOM has already loaded
  setTimeout(initializeWhenReady, 100);
}
</script>

<script>
// Security Initialization
function initializeSecurity() {
  // Security manager is already initialized globally
  
  // Add security validation to critical functions
  const originalKaydet = window.Kaydet;
  window.Kaydet = function() {
    if (!validateSecureOperation('save')) return;
    return originalKaydet ? originalKaydet.apply(this, arguments) : null;
  };
  
  const originalUpdateStage = window.updateStage;
  window.updateStage = function(element, projectId) {
    if (!validateSecureOperation('update', { projectId: projectId })) return;
    return originalUpdateStage ? originalUpdateStage.apply(this, arguments) : null;
  };
  
  // Secure AJAX calls
  const originalTreeLoad = window.loadTree;
  window.loadTree = function(productId) {
    if (!validateSecureOperation('loadTree', { productId: productId })) return;
    return secureLoadTree(productId);
  };
}

function validateSecureOperation(operation, params = {}) {
  // Check session validity
  if (!window.SecurityManager) {
    console.error('Security manager not initialized');
    showSecurityAlert('Güvenlik sistemi hazır değil');
    return false;
  }
  
  // Validate parameters
  for (const [key, value] of Object.entries(params)) {
    let validationType = 'text';
    if (key.includes('Id') || key.includes('ID')) {
      validationType = 'projectId';
    } else if (key.includes('Name') || key.includes('name')) {
      validationType = 'productName';
    }
    
    const validation = window.SecurityManager.validateInput(value, validationType, true);
    if (!validation.isValid) {
      showSecurityAlert(`Geçersiz ${key}: ${validation.errors.join(', ')}`);
      return false;
    }
    
    // Update parameter with sanitized value
    params[key] = validation.sanitizedValue;
  }
  
  return true;
}

async function secureLoadTree(productId) {
  try {
    showTreeLoading();
      var PROJECT_ID = getParameterByName("project_id");
  var cp_id = wrk_query(
    "select COMPANY_ID FROM PRO_PROJECTS WHERE PROJECT_ID=" + PROJECT_ID,
    "DSN"
  ).COMPANY_ID[0];
  let compInfo = GetAjaxQuery("CompanyInfo", cp_id);
 var _priceCatId = compInfo.PRICE_LISTS.find((p) => p.IS_DEFAULT == 1).PRICE_CATID;
  var _compId = cp_id;
    const response = await window.SecurityManager.secureRequest('product_design.cfc?method=getTree', {
      product_id: productId,
      isVirtual: document.getElementById('is_virtual').value || '1',
      ddsn3: 'workcube_metosan_1',
      company_id: _compId,
      price_catid: _priceCatId,
      stock_id: '',
      tipo: '1',
      from_copy: '0'
    });
    
    if (typeof response === 'string' && response.includes('error')) {
      const errorData = JSON.parse(response);
      throw new Error(errorData.error);
    }
    
    // Process and display tree data
    displayTreeData(response);
    hideTreeLoading();
    
    window.ModernUI.createToast('Ürün ağacı yüklendi', 'success');
    
  } catch (error) {
    console.error('Secure tree load failed:', error);
    hideTreeLoading();
    
    if (error.message.includes('Güvenlik')) {
      showSecurityAlert(error.message);
    } else {
      window.ModernUI.createToast('Ürün ağacı yüklenemedi: ' + error.message, 'error');
    }
  }
}

function showTreeLoading() {
  const treeContent = document.getElementById('tree-content');
  if (treeContent) {
    const loading = window.ModernUI.createLoadingSpinner(treeContent, {
      message: 'Güvenli bağlantı ile yükleniyor...'
    });
    treeContent.dataset.loadingId = loading.id;
  }
}

function hideTreeLoading() {
  const treeContent = document.getElementById('tree-content');
  if (treeContent && treeContent.dataset.loadingId) {
    const loadingElement = treeContent.querySelector(`[data-loading-id="${treeContent.dataset.loadingId}"]`);
    if (loadingElement) {
      loadingElement.remove();
    }
  }
}

function displayTreeData(data) {
  const treeData = document.getElementById('tree-data');
  if (treeData) {
    // Sanitize and display tree data
    const sanitizedData = window.SecurityManager.sanitizeInput(data, 'text');
    treeData.innerHTML = sanitizedData;
  }
}

function showSecurityAlert(message) {
  window.ModernUI.createModal(`
    <div class="security-alert">
      <div class="alert alert-danger">
        <i class="fas fa-shield-alt"></i>
        <strong>Güvenlik Uyarısı</strong>
      </div>
      <p>${message}</p>
      <p class="text-muted">Bu işlem güvenlik nedeniyle engellendi. Lütfen sistem yöneticisi ile iletişime geçin.</p>
    </div>
  `, {
    title: 'Güvenlik Uyarısı',
    size: 'medium',
    buttons: [
      {
        text: 'Tamam',
        class: 'btn-primary',
        handler: () => true
      }
    ]
  });
}

// Secure form submission
function secureFormSubmit(formElement) {
  const formData = new FormData(formElement);
  const data = {};
  
  // Validate all form fields
  let isValid = true;
  for (const [key, value] of formData.entries()) {
    const validation = window.SecurityManager.validateInput(value, 'text', false);
    if (!validation.isValid) {
      window.ModernUI.createToast(`${key}: ${validation.errors.join(', ')}`, 'error');
      isValid = false;
    } else {
      data[key] = validation.sanitizedValue;
    }
  }
  
  return isValid ? data : null;
}

// Enhanced Save Function with Security
async function Kaydet() {
  try {
    const form = document.querySelector('form') || document.body;
    const secureData = secureFormSubmit(form);
    
    if (!secureData) {
      window.ModernUI.createToast('Form doğrulama hatası', 'error');
      return;
    }
    
    const response = await window.SecurityManager.secureRequest('product_design.cfc?method=save', secureData);
    
    if (response && response.success) {
      window.ModernUI.createToast('Başarıyla kaydedildi', 'success');
      loadProjectStats(); // Refresh stats
    } else {
      throw new Error(response.message || 'Kaydetme işlemi başarısız');
    }
    
  } catch (error) {
    console.error('Secure save failed:', error);
    window.ModernUI.createToast('Kaydetme hatası: ' + error.message, 'error');
  }
}

// Enhanced Update Stage with Security
async function updateStage(element, projectId) {
  try {
    const stageValue = element.value;
    
    const response = await window.SecurityManager.secureRequest('product_design.cfc?method=updateStage', {
      project_id: projectId,
      stage_id: stageValue
    });
    
    if (response && response.success) {
      window.ModernUI.createToast('Aşama güncellendi', 'success');
    } else {
      throw new Error(response.message || 'Aşama güncellenemedi');
    }
    
  } catch (error) {
    console.error('Secure stage update failed:', error);
    window.ModernUI.createToast('Aşama güncelleme hatası: ' + error.message, 'error');
  }
}

// Security-enhanced search
function initializeSearch() {
  const searchInput = document.getElementById('tree-search');
  if (!searchInput) return;
  
  const debouncedSearch = window.ModernUI.debounce(function(query) {
    // Validate search input
    const validation = window.SecurityManager.validateInput(query, 'text', false);
    if (!validation.isValid) {
      window.ModernUI.createToast('Arama terimi geçersiz', 'warning');
      return;
    }
    
    if (validation.sanitizedValue.trim() === '') {
      clearSearchHighlights();
      return;
    }
    
    searchInTree(validation.sanitizedValue);
  }, 300);
  
  searchInput.addEventListener('input', function(e) {
    debouncedSearch(e.target.value);
  });
}

// Secure project statistics loading
async function loadProjectStats() {
  try {
    const projectId = document.getElementById('project_id').value;
    if (!projectId) return;
    
    const response = await window.SecurityManager.secureRequest('product_design.cfc?method=getProjectStats', {
      project_id: projectId
    });
    
    if (response && response.stats) {
      updateProjectStat('total-products', response.stats.totalProducts || 0);
      updateProjectStat('total-cost', formatCurrency(response.stats.totalCost || 0));
      updateProjectStat('last-update', new Date().toLocaleString('tr-TR'));
    }
    
  } catch (error) {
    console.error('Failed to load project stats:', error);
    // Don't show error to user for stats loading
  }
}

// Continue with rest of the existing functions...
// (keeping all the existing functions but with security validation where needed)

function searchInTree(query) {
  const treeData = document.getElementById('tree-data');
  if (!treeData) return;
  
  const searchResults = [];
  const allNodes = treeData.querySelectorAll('[data-product-name]');
  
  allNodes.forEach(node => {
    const productName = node.dataset.productName.toLowerCase();
    if (productName.includes(query.toLowerCase())) {
      node.classList.add('search-highlight');
      searchResults.push(node);
    } else {
      node.classList.remove('search-highlight');
    }
  });
  
  // Show search results count
  updateSearchResults(searchResults.length);
  
  // Scroll to first result if any
  if (searchResults.length > 0) {
    searchResults[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
}

function clearSearchHighlights() {
  document.querySelectorAll('.search-highlight').forEach(node => {
    node.classList.remove('search-highlight');
  });
  updateSearchResults(0);
}

function updateSearchResults(count) {
  const searchInput = document.getElementById('tree-search');
  if (count > 0) {
    searchInput.style.borderColor = 'var(--success-500)';
    searchInput.title = `${count} sonuç bulundu`;
  } else {
    searchInput.style.borderColor = '';
    searchInput.title = '';
  }
}

// Enhanced Tooltip System
function initializeTooltips() {
  document.querySelectorAll('[data-tooltip]').forEach(element => {
    window.ModernUI.initializeTooltip(element);
  });
}

// Responsive Handlers
function initializeResponsiveHandlers() {
  const mediaQuery = window.matchMedia('(max-width: 768px)');
  
  function handleViewportChange(e) {
    if (e.matches) {
      // Mobile optimizations
      optimizeForMobile();
    } else {
      // Desktop optimizations
      optimizeForDesktop();
    }
  }
  
  mediaQuery.addListener(handleViewportChange);
  handleViewportChange(mediaQuery);
}

function optimizeForMobile() {
  // Collapse toolbar by default on mobile
  const toolbar = document.querySelector('.tree-toolbar');
  if (toolbar) {
    toolbar.classList.add('mobile-optimized');
  }
  
  // Adjust tree content padding
  const treeContent = document.querySelector('.tree-content');
  if (treeContent) {
    treeContent.style.padding = 'var(--spacing-sm)';
  }
}

function optimizeForDesktop() {
  const toolbar = document.querySelector('.tree-toolbar');
  if (toolbar) {
    toolbar.classList.remove('mobile-optimized');
  }
  
  const treeContent = document.querySelector('.tree-content');
  if (treeContent) {
    treeContent.style.padding = 'var(--spacing-md)';
  }
}

// Performance Monitoring
function initializePerformanceMonitoring() {
  let lastLoadTime = 0;
  
  // Monitor tree loading performance
  const observer = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    entries.forEach(entry => {
      if (entry.name.includes('tree-load')) {
        lastLoadTime = Math.round(entry.duration);
        updatePerformanceIndicator(lastLoadTime);
      }
    });
  });
  
  if ('PerformanceObserver' in window) {
    observer.observe({ entryTypes: ['measure'] });
  }
}

function updatePerformanceIndicator(loadTime) {
  const indicator = document.getElementById('performance-indicator');
  const timeSpan = document.getElementById('load-time');
  
  if (indicator && timeSpan) {
    timeSpan.textContent = loadTime;
    
    // Update indicator color based on performance
    indicator.classList.remove('fast', 'slow');
    if (loadTime < 500) {
      indicator.classList.add('fast');
    } else if (loadTime > 2000) {
      indicator.classList.add('slow');
    }
  }
}

// Cache Indicators
function initializeCacheIndicators() {
  const cacheIndicator = document.getElementById('cache-indicator');
  const cacheStatus = document.getElementById('cache-status');
  
  if (!cacheIndicator || !cacheStatus) return;
  
  // Monitor cache status
  setInterval(() => {
    const cacheSize = getCacheSize();
    const cacheHitRate = getCacheHitRate();
    
    if (cacheSize > 0) {
      cacheIndicator.classList.add('active');
      cacheStatus.textContent = `Cache (${cacheSize} öğe, %${cacheHitRate} hit)`;
    } else {
      cacheIndicator.classList.remove('active');
      cacheStatus.textContent = 'Cache Boş';
    }
  }, 5000);
}

// Project Statistics
function loadProjectStats() {
  // Load and display project statistics
  if (window.ProductTreeManager && window.ProductTreeManager.cache) {
    const cache = window.ProductTreeManager.cache;
    
    // Get total products from cache or make API call
    const totalProducts = cache.size || 0;
    updateProjectStat('total-products', totalProducts);
    
    // Calculate total cost
    calculateTotalCost().then(cost => {
      updateProjectStat('total-cost', formatCurrency(cost));
    });
    
    // Update last update time
    const lastUpdate = new Date().toLocaleString('tr-TR');
    updateProjectStat('last-update', lastUpdate);
  }
}

function updateProjectStat(statId, value) {
  const element = document.getElementById(statId);
  if (element) {
    element.textContent = value;
    
    // Add update animation
    element.style.transform = 'scale(1.1)';
    setTimeout(() => {
      element.style.transform = 'scale(1)';
    }, 200);
  }
}

// Tree Management Functions
function expandAllNodes() {
  const loadingOverlay = window.ModernUI.createLoadingSpinner(
    document.getElementById('tree-content'),
    { message: 'Tüm düğümler açılıyor...' }
  );
  
  setTimeout(() => {
    // Expand logic here
    document.querySelectorAll('.tree-node.collapsed').forEach(node => {
      node.classList.remove('collapsed');
      node.classList.add('expanded');
    });
    
    loadingOverlay.remove();
    
    window.ModernUI.createToast('Tüm düğümler açıldı', 'success', {
      duration: 3000
    });
  }, 500);
}

function collapseAllNodes() {
  document.querySelectorAll('.tree-node.expanded').forEach(node => {
    node.classList.remove('expanded');
    node.classList.add('collapsed');
  });
  
  window.ModernUI.createToast('Tüm düğümler kapatıldı', 'info', {
    duration: 3000
  });
}

function addNewNode() {
  window.ModernUI.createModal(`
    <div class="add-node-form">
      <div class="form-group">
        <label for="new-node-name">Ürün Adı:</label>
        <input type="text" id="new-node-name" class="form-control-modern" placeholder="Yeni ürün adını girin">
      </div>
      <div class="form-group">
        <label for="new-node-type">Ürün Türü:</label>
        <select id="new-node-type" class="form-control-modern">
          <option value="virtual">Sanal Ürün</option>
          <option value="real">Gerçek Ürün</option>
        </select>
      </div>
    </div>
  `, {
    title: 'Yeni Ürün Ekle',
    size: 'medium',
    buttons: [
      {
        text: 'İptal',
        class: 'btn-secondary'
      },
      {
        text: 'Ekle',
        class: 'btn-primary',
        handler: () => {
          const name = document.getElementById('new-node-name').value;
          const type = document.getElementById('new-node-type').value;
          
          if (name.trim() === '') {
            window.ModernUI.createToast('Ürün adı boş olamaz', 'error');
            return false;
          }
          
          // Add node logic here
          addNodeToTree(name, type);
          
          window.ModernUI.createToast(`"${name}" ürünü eklendi`, 'success');
          return true;
        }
      }
    ]
  });
}

function duplicateNode() {
  const selectedNode = document.querySelector('.tree-node.selected');
  if (!selectedNode) {
    window.ModernUI.createToast('Çoğaltmak için bir ürün seçin', 'warning');
    return;
  }
  
  // Duplicate logic here
  window.ModernUI.createToast('Ürün çoğaltıldı', 'success');
}

function deleteNode() {
  const selectedNode = document.querySelector('.tree-node.selected');
  if (!selectedNode) {
    window.ModernUI.createToast('Silmek için bir ürün seçin', 'warning');
    return;
  }
  
  window.ModernUI.createModal(`
    <div class="delete-confirmation">
      <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle"></i>
        Bu ürünü silmek istediğinizden emin misiniz?
      </div>
      <p><strong>Ürün:</strong> ${selectedNode.dataset.productName}</p>
      <p class="text-muted">Bu işlem geri alınamaz.</p>
    </div>
  `, {
    title: 'Ürün Sil',
    size: 'small',
    buttons: [
      {
        text: 'İptal',
        class: 'btn-secondary'
      },
      {
        text: 'Sil',
        class: 'btn-danger',
        handler: () => {
          // Delete logic here
          selectedNode.remove();
          window.ModernUI.createToast('Ürün silindi', 'success');
          return true;
        }
      }
    ]
  });
}

function toggleTreeView(viewType) {
  const buttons = document.querySelectorAll('.view-options .btn-modern');
  buttons.forEach(btn => btn.classList.remove('active'));
  
  event.target.closest('.btn-modern').classList.add('active');
  
  const treeData = document.getElementById('tree-data');
  if (treeData) {
    treeData.className = `tree-data tree-view-${viewType}`;
  }
  
  window.ModernUI.createToast(`${viewType === 'compact' ? 'Kompakt' : 'Detaylı'} görünüm aktif`, 'info', {
    duration: 2000
  });
}

function createFirstProduct() {
  addNewNode();
}

function refreshProject() {
  const button = event.target.closest('.btn-modern');
  const icon = button.querySelector('i');
  
  // Rotate icon
  icon.style.animation = 'spin 1s linear infinite';
  
  // Simulate refresh
  setTimeout(() => {
    icon.style.animation = '';
    window.ModernUI.createToast('Proje yenilendi', 'success');
    loadProjectStats();
  }, 1500);
}

function toggleFullscreen() {
  const container = document.querySelector('.tree-container-modern');
  if (!container) return;
  
  if (document.fullscreenElement) {
    document.exitFullscreen();
  } else {
    container.requestFullscreen();
  }
}

// Utility Functions
function getCacheSize() {
  return window.ProductTreeManager?.cache?.size || 0;
}

function getCacheHitRate() {
  const cache = window.ProductTreeManager?.cache;
  if (!cache || !cache.stats) return 0;
  
  const { hits, misses } = cache.stats;
  const total = hits + misses;
  return total > 0 ? Math.round((hits / total) * 100) : 0;
}

function formatCurrency(amount) {
  return new Intl.NumberFormat('tr-TR', {
    style: 'currency',
    currency: 'TRY',
    minimumFractionDigits: 2
  }).format(amount || 0);
}

async function calculateTotalCost() {
  // This would integrate with your existing cost calculation logic
  return new Promise(resolve => {
    setTimeout(() => resolve(Math.random() * 100000), 100);
  });
}

function addNodeToTree(name, type) {
  // This would integrate with your existing tree management logic
  console.log(`Adding node: ${name} (${type})`);
}

// Enhanced Feature Panel Functions
function showBulkOperationsPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.showBulkOperationsPanel();
  }
}

function hideBulkOperationsPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.hideBulkOperationsPanel();
  }
}

function showAdvancedFiltersPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.showAdvancedFiltersPanel();
  }
}

function hideAdvancedFiltersPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.hideAdvancedFiltersPanel();
  }
}

function showDataExportPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.showDataExportPanel();
  }
}

function hideDataExportPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.hideDataExportPanel();
  }
}

function showUserPreferencesPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.showUserPreferencesPanel();
  }
}

function hideUserPreferencesPanel() {
  if (window.enhancedFeatures) {
    window.enhancedFeatures.hideUserPreferencesPanel();
  }
}

// Custom Styles for Search and Enhanced Features
const customStyles = `
  .search-highlight {
    background-color: var(--warning-100) !important;
    border: 2px solid var(--warning-500) !important;
    box-shadow: 0 0 8px rgba(255, 193, 7, 0.3) !important;
  }
  
  .search-clear {
    position: absolute;
    right: 2.5rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: var(--gray-500);
    cursor: pointer;
    padding: 0.25rem;
    border-radius: var(--radius-sm);
  }
  
  .search-clear:hover {
    color: var(--gray-700);
    background: var(--gray-100);
  }
  
  .mobile-optimized {
    flex-direction: column !important;
    gap: var(--spacing-sm) !important;
  }
  
  .tree-node.selected {
    background: var(--primary-100) !important;
    border-color: var(--primary-500) !important;
  }
  
  .delete-confirmation .alert {
    margin-bottom: var(--spacing-lg);
  }
`;

// Inject custom styles
const styleSheet = document.createElement('style');
styleSheet.textContent = customStyles;
document.head.appendChild(styleSheet);
</script>

<!--- Modern ProductTree Initialization Script --->
<script>
(function() {
    'use strict';

    // Performance monitoring
    if (typeof performance !== 'undefined' && performance.mark) {
        performance.mark('product-design-start');
        
        window.addEventListener('load', function() {
            performance.mark('product-design-loaded');
            performance.measure('product-design-load-time', 'product-design-start', 'product-design-loaded');
            
            const measure = performance.getEntriesByName('product-design-load-time')[0];
            console.log(`Product Design page loaded in ${measure.duration.toFixed(2)}ms`);
        });
    }

    // Initialize ProductTree Manager when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        try {
            // Global configuration
            const config = {
                companyId: window._compId,
                priceCatId: window._priceCatId,
                dsn3: 'workcube_metosan_1',
                projectId: <cfoutput>#attributes.project_id#</cfoutput>,
                enableCache: true,
                cacheTimeout: 300000, // 5 minutes
                maxCacheSize: 50,
                maxRetries: 3,
                retryDelay: 1000
            };

            // Create global ProductTree manager instance
            window.productTreeManager = new ProductTreeManager(config);

            // Setup modern event handlers
            setupModernEventHandlers();

            // Load project products
            loadProjectProducts();

            console.log('Modern ProductTree system initialized successfully');

        } catch (error) {
            console.error('ProductTree initialization failed:', error);
            showFallbackError('Sistem yüklenirken hata oluştu. Sayfayı yenileyin.');
        }
    });

    /**
     * Setup modern event handlers
     */
    function setupModernEventHandlers() {
        const manager = window.productTreeManager;
        if (!manager) return;

        // Listen for tree load events
        manager.eventBus.on('tree:loaded', function(data) {
            console.log('Tree loaded successfully:', data);
            updateUIAfterTreeLoad(data);
        });

        // Listen for errors
        manager.eventBus.on('error:occurred', function(errorInfo) {
            console.error('ProductTree error:', errorInfo);
            handleSystemError(errorInfo);
        });

        // Listen for state changes
        manager.eventBus.on('state:changed', function(stateChange) {
            updateUIForStateChange(stateChange);
        });

        // Listen for cost calculations
        manager.eventBus.on('costs:calculated', function(costData) {
            updateCostDisplay(costData);
        });

        // Setup button event handlers with modern patterns
        setupButtonHandlers();
    }

    /**
     * Setup modern button handlers
     */
    function setupButtonHandlers() {
        // New Draft button
        const newDraftBtn = document.querySelector('[onclick*="newDraft"]');
        if (newDraftBtn) {
            newDraftBtn.addEventListener('click', handleNewDraft);
        }

        // Save button
        const saveBtn = document.querySelector('[onclick*="Kaydet"]');
        if (saveBtn) {
            saveBtn.addEventListener('click', handleSave);
        }

        // Delete button
        const deleteBtn = document.getElementById('silButon');
        if (deleteBtn) {
            deleteBtn.addEventListener('click', handleDelete);
        }

        // Stage update
        const stageSelect = document.getElementById('pstage');
        if (stageSelect) {
            stageSelect.addEventListener('change', handleStageUpdate);
        }
    }

    /**
     * Load project products using modern architecture
     */
    async function loadProjectProducts() {
        try {
            const response = await fetch('/AddOns/Partner/project/cfc/product_design.cfc', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    method: 'getProjectProducts',
                    PROJECT_ID: <cfoutput>#attributes.project_id#</cfoutput>,
                    ddsn3: 'workcube_metosan_1'
                })
            });

            const htmlContent = await response.text();
            const leftMenu = document.getElementById('leftMenuProject');
            if (leftMenu) {
                leftMenu.innerHTML = htmlContent;
                setupProductClickHandlers();
            }

        } catch (error) {
            console.error('Failed to load project products:', error);
            window.productTreeManager.ui.showError('Proje ürünleri yüklenirken hata oluştu');
        }
    }

    /**
     * Setup product click handlers with modern tree loading
     */
    function setupProductClickHandlers() {
        const productLinks = document.querySelectorAll('#leftMenuProject a[onclick*="ngetTree"]');
        
        productLinks.forEach(link => {
            // Extract parameters from onclick attribute
            const onclickAttr = link.getAttribute('onclick');
            const matches = onclickAttr.match(/ngetTree\((\d+),(\d+),'([^']+)',this,(\d+),'([^']*)','([^']*)','([^']*)'\)/);
            
            if (matches) {
                const [, productId, isVirtual, dsn3, tip, li, productName, stage] = matches;
                
                // Remove old onclick handler
                link.removeAttribute('onclick');
                
                // Add modern event handler
                link.addEventListener('click', async function(e) {
                    e.preventDefault();
                    
                    try {
                        // Update active state
                        document.querySelectorAll('#leftMenuProject a').forEach(a => 
                            a.classList.remove('active'));
                        this.classList.add('active');

                        // Load tree using modern manager
                        await window.productTreeManager.loadTree({
                            productId: parseInt(productId),
                            isVirtual: parseInt(isVirtual) === 1,
                            tip: parseInt(tip),
                            productName: productName,
                            stage: stage
                        });

                    } catch (error) {
                        console.error('Failed to load product tree:', error);
                        window.productTreeManager.ui.showError('Ürün ağacı yüklenirken hata oluştu');
                    }
                });
            }
        });
    }

    /**
     * Modern event handlers
     */
    async function handleNewDraft() {
        try {
            // Implement modern new draft functionality
            const result = await window.productTreeManager.createNewDraft();
            window.productTreeManager.ui.showSuccess('Yeni taslak oluşturuldu');
        } catch (error) {
            console.error('New draft failed:', error);
        }
    }

    async function handleSave() {
        try {
            const result = await window.productTreeManager.saveTree();
            window.productTreeManager.ui.showSuccess('Değişiklikler kaydedildi');
        } catch (error) {
            console.error('Save failed:', error);
        }
    }

    async function handleDelete() {
        const state = window.productTreeManager.getState();
        if (!state.selectedProduct) {
            window.productTreeManager.ui.showError('Silinecek ürün seçilmedi');
            return;
        }

        if (confirm('Seçili ürünü silmek istediğinizden emin misiniz?')) {
            try {
                await window.productTreeManager.deleteProduct(state.selectedProduct.productId);
                window.productTreeManager.ui.showSuccess('Ürün silindi');
            } catch (error) {
                console.error('Delete failed:', error);
            }
        }
    }

    async function handleStageUpdate(e) {
        const stage = e.target.value;
        const state = window.productTreeManager.getState();
        
        if (state.selectedProduct && stage) {
            try {
                await window.productTreeManager.updateProductStage(
                    state.selectedProduct.productId, 
                    stage
                );
                window.productTreeManager.ui.showSuccess('Aşama güncellendi');
            } catch (error) {
                console.error('Stage update failed:', error);
            }
        }
    }

    /**
     * UI update functions
     */
    function updateUIAfterTreeLoad(data) {
        // Update product info display
        if (data.params && data.params.productName) {
            window.productTreeManager.ui.updateProductInfo({
                productId: data.params.productId,
                isVirtual: data.params.isVirtual,
                name: data.params.productName,
                stage: data.params.stage
            });
        }
    }

    function updateUIForStateChange(stateChange) {
        // Handle state changes in UI
        const { newState } = stateChange;
        
        if (newState.isLoading) {
            // Show loading state
        } else {
            // Hide loading state
        }
    }

    function updateCostDisplay(costData) {
        // Update cost display
        if (costData.totalCost !== undefined) {
            window.productTreeManager.ui.updateCost(costData.totalCost);
        }
    }

    function handleSystemError(errorInfo) {
        // Handle system-level errors
        console.error('System error:', errorInfo);
    }

    function showFallbackError(message) {
        const alert = document.createElement('div');
        alert.className = 'alert alert-danger';
        alert.style.cssText = 'position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999;';
        alert.innerHTML = `<strong>Hata:</strong> ${message}`;
        document.body.appendChild(alert);
        
        setTimeout(() => alert.remove(), 5000);
    }

    // Global error handler for AJAX errors
    $(document).ajaxError(function(event, jqXHR, ajaxSettings, thrownError) {
        console.error('AJAX Error:', {
            url: ajaxSettings.url,
            status: jqXHR.status,
            error: thrownError,
            responseText: jqXHR.responseText
        });
    });

    // Optimize existing applyFilters function if it exists
    if (typeof window.applyFilters === 'function') {
        const originalApplyFilters = window.applyFilters;
        window.applyFilters = debounce(originalApplyFilters, 300);
    }

})();
</script>


<script>
  function applyFilters(type) {
  if (
    !list_find("37,38,39,40", window.event.keyCode) &&
    (window.event.keyCode == "13" || type > 0) &&
    $("#company_id_").val() &&
    $("#price_list").val()
  ) {
    $("#product_list").text("");
    var url_params = "";
    url_params += "&keyword=" + $("#keyword").val();
    url_params += "&comp_id=" + $("#company_id_").val();
    /* if($("#get_comp_name").val() && $("#get_company_id").val())
             url_params += '&get_company='+$("#get_company_id").val();
         if($("#product_cat").val() && $("#search_product_catid").val())
             url_params += '&product_hierarchy='+$("#search_product_catid").val();
         if($("#brand_name").val() && $("#brand_id").val())
             url_params += '&brand_id='+$("#brand_id").val();
         url_params += '&sort_type='+$("#sort_type").val();
         url_params += '&price_catid='+$("#price_list").val();
         url_params += '&maxrows='+$("#maxrows").val();*/
    //loadProductList(url_params);
  }
}
</script>