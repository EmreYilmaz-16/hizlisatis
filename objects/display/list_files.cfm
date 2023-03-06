<cf_box title="#attributes.cat_name#">
    
    <cfquery name="getAssets" datasource="#dsn#">
        select ASSET_FILE_NAME,ASSET_NAME,NAME,ASSET.RECORD_DATE,workcube_metosan.getEmployeeWithId(ASSET.RECORD_EMP) AS RECORD_EMP,ASSET.ACTION_ID from workcube_metosan.ASSET 
         left join workcube_metosan.CONTENT_PROPERTY on CONTENT_PROPERTY.CONTENT_PROPERTY_ID=ASSET.PROPERTY_ID
         where ASSETCAT_ID=#attributes.assetcatid# AND ASSET.ACTION_ID=#attributes.project_id#
    </cfquery>
<table>
<cfoutput query="getAssets">
 <tr>
    <td>
        #currentrow#
    </td>
    <td>
        <img style="width:20px" src="css/assets/icons/catalyst-icon-svg/#listLast(ASSET_FILE_NAME,'.')#.svg">&nbsp; #ASSET_NAME#
    </td>
    <td>
        #dateFormat(RECORD_DATE,"dd/mm/yyyy")#
    </td>
    <td>
        #RECORD_EMP#
    </td>
 </tr>
        
        
</cfoutput>
</table>
<!---    <cfparam name="attributes.DosyaAd" default="#attributes.pth#">    
<cfdirectory action="list" directory="#expandPath("./documents/asset/>#attributes.DosyaAd#")#" recurse="false" name="myLists">
<cfset myList=directoryList(expandPath("./documents/asset/#attributes.DosyaAd#"),false,"query","","type asc")>
<cfdump var="#myList#">
<cfoutput query="myList">
    <cfset f_info=GetFileInfo("#directory#\#name#")>
    <cfdump var="#f_info#"><br>
</cfoutput>---->
</cf_box>
