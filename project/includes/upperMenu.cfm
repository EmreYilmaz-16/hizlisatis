<style>
.navbar .container, .navbar .container-fluid, .navbar .container-lg, .navbar .container-md, .navbar .container-sm, .navbar .container-xl {
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    -ms-flex-align: center;
    align-items: flex-end;
    -ms-flex-pack: justify;
    justify-content: flex-end !important;
}
.navbar-toggler {
    padding: 0.25rem 0.75rem;
    font-size: 1.0rem;
    line-height: 1;    
    border: none !important;
    background: none !important;
    margin-top:3px !important;
}
.navbar-toggler-icon {
    display: inline-block;
    width: 1.5em;
    height: initial !important;
    vertical-align: middle;
    content: "";
    background: no-repeat center center;
    background-size: 100% 100%;
}

</style>
<cfif isDefined("attributes.project_id")>
<cfquery name="getProjectInfo" datasource="#dsn#">
    select RELATED_PROJECT_ID,PROJECT_ID,PROJECT_NUMBER,PROJECT_HEAD from #dsn#.PRO_PROJECTS where PROJECT_ID=#attributes.project_id#
</cfquery>
<cfif len(getProjectInfo.RELATED_PROJECT_ID)>
  <cfquery name="getProjectInfo2" datasource="#dsn#">
    select RELATED_PROJECT_ID,PROJECT_ID,PROJECT_NUMBER,PROJECT_HEAD from #dsn#.PRO_PROJECTS where PROJECT_ID=#getProjectInfo.RELATED_PROJECT_ID#
</cfquery>
</cfif>
</cfif>
<nav class="navbar navbar-expand-lg bg-body-tertiary" style="padding:0">
    <div class="container-fluid">
      <cfif isDefined("attributes.project_id")><a class="navbar-brand" href="<cfif len(getProjectInfo.RELATED_PROJECT_ID)>/index.cfm?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput><cfelse>/index.cfm?fuseaction=project.emptypopup_detail_project_pbs&project_id=<cfoutput>#attributes.project_id#</cfoutput></cfif>"><cfoutput><span class="icn-md catalyst-home"></span><cfif len(getProjectInfo.RELATED_PROJECT_ID)>#getProjectInfo2.PROJECT_HEAD# &gt;</cfif>&nbsp;#getProjectInfo.PROJECT_HEAD#</cfoutput></a><cfelse><a class="navbar-brand"><span class="icn-md catalyst-home"></span>PBS Proje</a></cfif>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"><span class="text-primary icn-md fa fa-align-justify"></span></span>
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
              <cfif isDefined("attributes.project_id")>
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
            </cfif>
        </ul>
      </div>
    </div>
    </nav>
    <script src="/AddOns/Partner/project/content/project_welcome.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous">
</script>