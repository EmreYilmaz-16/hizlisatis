
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cf_box title="Üretim Projeler">
<div class="list-group">
    




    <a class="list-group-item list-group-item-action" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs'">
        <img src="pr.png">
        Projeler</a>
    <a class="list-group-item list-group-item-action" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_projects_pbs&list_my_projects=1'">
        <img src="mpr.png">
        Görevlisi Olduğum Projeler</a>
    <a class="list-group-item list-group-item-action" onclick="openBoxDraggable('index.cfm?fuseaction=project.emptypopup_add_project_fast')">
        <img src="add.png">
        Yeni Proje</a>    
    <a class="list-group-item list-group-item-action">Proje Raporları</a>
    <a class="list-group-item list-group-item-action">Proje Ürünleri</a>
    <a class="list-group-item list-group-item-action">Proje Ürün Tipleri</a>
    <a class="list-group-item list-group-item-action" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_myworks'">Bekleyen İşlerim</a>
    <a class="list-group-item list-group-item-action" onclick="window.location.href='index.cfm?fuseaction=project.emptypopup_list_project_notes&act=list_my'">Notlarım</a>
</div>
</cf_box>

<script src="/AddOns/Partner/project/content/project_welcome.js"></script>

