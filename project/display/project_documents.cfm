
<cfquery name="getassetsCats" datasource="#dsn#">
    Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_MAIN_ID=-1
        UNION 
    Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_ID=-1
</cfquery>
<cf_box title="Klasörler">


</cf_box>
<div style="display:flex">
<div id="folders" style="width:33%">
    <ul>
    <cfoutput query="getassetsCats">
        <li class="folder">
            <a onclick="loadFiles('#ASSETCAT_PATH#',#ASSETCAT_ID#,'#ASSETCAT#')">#ASSETCAT#</a>
        </li>    
    </cfoutput>
    </ul>
</div>  
<div style="width:66%" id="files">

</div>
</div>
<script>
    function loadFiles(pth,id,acs){
        AjaxPageLoad("index.cfm?fuseaction=objects.emptypopup_list_files_pbs&pth="+pth+"&cat_name="+acs+"&assetcatid="+id,"files",1,"Yükleniyor");
    }
</script>