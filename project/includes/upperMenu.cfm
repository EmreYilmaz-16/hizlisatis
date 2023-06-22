<style>
  .navbar-toggler-icon {
    display: inline-block;
    width: 1.5em;
    height: 1.5em;
    vertical-align: middle;
    content: "";
    background: no-repeat center center;
    background-size: 100% 100%;
    background-image: url(data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%2833, 37, 41, 0.75%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e) !important;
}
</style>
<cfquery name="getProjectInfo" datasource="#dsn#">
    select RELATED_PROJECT_ID,PROJECT_ID from workcube_metosan.PRO_PROJECTS where PROJECT_ID=#attributes.project_id#
</cfquery>
<nav class="navbar navbar-expand-lg bg-body-tertiary" style="padding:0">
    <div class="container-fluid">
      <a class="navbar-brand" href="#"></a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNavDropdown">
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Proje Welcome
                </a>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/pr.png" style="width:20px;margin-right:10px">Projeler</a></li>
                  <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs&list_my_projects=1'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/mpr.png" style="width:20px;margin-right:10px">Görevlisi Olduğum Projeler</a></li>
                  <li><a class="dropdown-item" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_add_project_fast')"  style="font-size:9pt;display:flex" ><img src="/images/e-pd/add.png" style="width:20px;margin-right:10px">Yeni Proje</a></li>
                  <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_myworks'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/wrks.png" style="width:20px;margin-right:10px">Bekleyen İşlerim</a></li>
                  <li><a class="dropdown-item"  onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&amp;act=list_my'"style="font-size:9pt;display:flex" ><img src="/images/e-pd/nt.png" style="width:20px;margin-right:10px">Notlarım</a></li>
                </ul>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Proje
                </a>
                <ul class="dropdown-menu">
                    <cfif len(getProjectInfo.RELATED_PROJECT_ID)>
                      <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/home.png" style="width:20px;margin-right:10px">Proje</a></li> 
                      <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=product.emptypopup_design_sub_product_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/pdesign.png" style="width:20px;margin-right:10px">Ürün Dizayn</a></li>
                
                    <cfelse>
                      <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_detail_project_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/home.png" style="width:20px;margin-right:10px">Proje</a></li>  
                      <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=product.emptypopup_design_product_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex">   <img src="/images/e-pd/pdesign.png" style="width:20px;margin-right:10px"> Ürün Dizayn</a></li>
                        <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_related_projects_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/pr.png" style="width:20px;margin-right:10px"> İlişkili Projeler</a></li>
                        <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_production_orders&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" > <img src="/images/e-pd/oppr.png" style="width:20px;margin-right:10px"> Üretim Emirleri</a></li>
                        <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_related_project_documents&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/rel.png" style="width:20px;margin-right:10px"> İlişkili İşlemler</a></li>
                    </cfif>
                    <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_project_group_employees&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/wrkls.png" style="width:20px;margin-right:10px"> Çalışma Gurupları</a></li>                               
                <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_works&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" > <img src="/images/e-pd/wrks.png" style="width:20px;margin-right:10px">İşler</a></li>
                <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_documents&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" > <img src="/images/e-pd/fld.png" style="width:20px;margin-right:10px"> Belgeler</a></li>
                <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&action_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" > <img src="/images/e-pd/nt.png" style="width:20px;margin-right:10px"> Notlar</a></li>
                <li><a class="dropdown-item" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_product_needs&project_id=<cfoutput>#attributes.project_id#</cfoutput>'" style="font-size:9pt;display:flex" ><img src="/images/e-pd/pord.png" style="width:20px;margin-right:10px"> Malzeme İhtiyaçları</a>    </li>
                
                
                
                </ul>
              </li>
          
        </ul>
      </div>
    </div>
    </nav>
    <script src="/AddOns/Partner/project/content/project_welcome.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous">
</script>