<cfquery name="getassetsCats" datasource="#dsn#">
 Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_MAIN_ID=-1
UNION 
Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_ID=-1
</cfquery>

<ul>
    <cfoutput>
        <cfloop query="getassetsCats">
            <li>
               <div style="display:flex"><img src="css/assets/icons/catalyst-icon-svg/ctl-school-material.svg" width="30px"> #ASSETCAT# </div> 
               <cfquery name="getAssets" datasource="#dsn#">
                   select ASSET_FILE_NAME,ASSET_NAME,NAME,ASSET.RECORD_DATE,workcube_metosan.getEmployeeWithId(ASSET.RECORD_EMP) AS RECORD_EMP,ASSET.ACTION_ID from workcube_metosan.ASSET 
                    left join workcube_metosan.CONTENT_PROPERTY on CONTENT_PROPERTY.CONTENT_PROPERTY_ID=ASSET.PROPERTY_ID
                    where ASSETCAT_ID=#ASSETCAT_ID# AND ASSET.ACTION_ID=#attributes.project_id#
               </cfquery>
               <cfif getAssets.recordCount>
                    <ul>
                        <cfloop query="getAssets">
                            <li>
                                #ASSET_NAME#
                            </li>
                        </cfloop>
                    </ul>
               </cfif>
            </li>
        </cfloop>
    </cfoutput>
</ul>