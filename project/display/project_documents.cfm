<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">
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





<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>