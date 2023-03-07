<cfquery name="getProject" datasource="#dsn#">
        select PRO_CURRENCY_ID,PROJECT_ID,RELATED_PROJECT_ID, PRO_PROJECTS.PROJECT_NUMBER,workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) as YONETICI,PROJECT_HEAD,TARGET_START,TARGET_FINISH,SETUP_PRIORITY.PRIORITY,SETUP_PRIORITY.COLOR,COMPANY.NICKNAME from workcube_metosan.PRO_PROJECTS
INNER join workcube_metosan.PROJECT_NUMBERS_BY_CAT ON PRO_PROJECTS.PROCESS_CAT=PROJECT_NUMBERS_BY_CAT.MAIN_PROCESS_CAT_ID
INNER JOIN workcube_metosan.SETUP_PRIORITY ON SETUP_PRIORITY.PRIORITY_ID=PRO_PROJECTS.PRO_PRIORITY_ID
INNER JOIN workcube_metosan.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID where PROJECT_ID=#attributes.project_id#
</cfquery>
<cfquery name="getassetsCats" datasource="#dsn#">
    Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_MAIN_ID=-1
        UNION 
    Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_ID=-1
</cfquery>
<cf_box title="Proje Dökümanları">



<div style="display:flex">
<div id="folders" style="width:33%">
    <cf_box title="Klasörler">
    <ul>
    <cfoutput query="getassetsCats">
        <li class="folder" style="margin-bottom:10px">
            <a onclick="loadFiles('#ASSETCAT_PATH#',#ASSETCAT_ID#,'#ASSETCAT#','#attributes.project_id#')"><img src="css/assets/icons/catalyst-icon-svg/ctl-office-material-2.svg" style="width:20px">&nbsp;#ASSETCAT#</a>
        </li>    
    </cfoutput>
    </ul>
</cf_box>
</div>  
<div style="width:66%" id="files">

</div>
</div>
<script>
    function loadFiles(pth,id,acs,pid){
        AjaxPageLoad("index.cfm?fuseaction=objects.emptypopup_list_files_pbs&pth="+pth+"&project_id="+pid+"&cat_name="+acs+"&assetcatid="+id,"files",1,"Yükleniyor");
    }
</script>
</cf_box>

<div id="leftMenuPss" style="width:10%;height:90vh;position: absolute;right: 0;top: 0;display:none">
    <cf_box title="Hızlı Erişim" expandable="0" id="box0001">
        <div style="height:90vh">
    <cf_grid_list>
        <tr>
            <td>
                <cfif len(getProject.RELATED_PROJECT_ID)>
                <a class="list-group-item" onclick="<cfoutput>window.location.href='#request.self#?fuseaction=project.emptypopup_detail_sub_project_pbs&project_id=#getProject.PROJECT_ID#'</cfoutput>">
                       Proje Detay 
                </a>        
            <cfelse>
                <a class="list-group-item" onclick="<cfoutput>window.location.href='#request.self#?fuseaction=project.emptypopup_detail_project_pbs&project_id=#getProject.PROJECT_ID#'</cfoutput>">
                    Proje Detay 
             </a>
            </cfif>
            </td>
        </tr>
        <tr>
        <td>
            <a class="list-group-item" onclick="window.location.href='<cfoutput>#request.self#?fuseaction=project.emptypopup_project_welcome</cfoutput>'">
            Proje Ana Sayfa
        </a>
    </td>
    </tr>
    
    </cf_grid_list>
</div>
</cf_box>
</div>


<script>

    $(document).on("mousemove",function(ev){

if(ev.clientX >=window.innerWidth-20){
$(leftMenuPss).show(500);
}else if(ev.clientX <=window.innerWidth-300){
$(leftMenuPss).hide(500);
}
})

</script>