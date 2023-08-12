<cfquery name="getRelDocs" datasource="#dsn#">
    SELECT ASS.ASSET_ID
           ,ASS.ACTION_ID
           ,ASS.ASSETCAT_ID
           ,ASS.ASSET_NAME
           ,ASS.ASSET_DESCRIPTION
           ,ASS.ACTION_SECTION 
           ,ASS.ASSET_FILE_NAME
           ,CP.NAME
           ,ASCC.ASSETCAT_PATH
     FROM ASSET AS ASS
          ,CONTENT_PROPERTY AS CP
          ,ASSET_CAT AS ASCC
     WHERE ASS.ASSETCAT_ID=#attributes.asset_cat_id# 
          AND ASS.ACTION_ID=#attributes.product_catid# 
          AND ASS.PROPERTY_ID=CP.CONTENT_PROPERTY_ID
          AND ASS.ASSETCAT_ID=ASCC.ASSETCAT_ID
</cfquery>

<cf_ajax_list>
    <thead>
        <tr>
            <th></th>
            <th>BelgeAdı</th>
            <th>Döküman Tipi</th>
            <th>Açıklama</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="getRelDocs">
        <tr>
        <td>#currentrow#</td>
            <td>
                <a href="index.cfm?fuseaction=objects.popup_download_file&file_name=asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#&file_control=asset.form_upd_asset&asset_id=#ASSET_ID#&assetcat_id=#ASSETCAT_ID#" class="tableyazi" title="Emre YILMAZ 29/07/2020 14:11">#ASSET_NAME#</a>





                
            </td>
            <td>#NAME#</td>
            <td>#ASSET_DESCRIPTION#</td>
            <td>
                <a style="cursor:pointer;" onclick="windowopen('index.cfm?fuseaction=asset.list_asset&event=updPopup&asset_id=#ASSET_ID#&module=product&module_id=5&action=#ACTION_SECTION#&action_id=#ACTION_ID#&asset_cat_id=#ASSETCAT_ID#&action_type=0','longpage','popup_form_upd_asset');"><img src="/images/update_list.gif" border="0" alt=" Güncelle "></a>
                <a style="cursor:pointer;" onclick="javascript:if(confirm(' Kayıtlı Belgeyi Siliyorsunuz, Emin Misiniz? ')) windowopen('index.cfm?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=product&file_name=#ASSET_FILE_NAME#&file_server_id=1','small'); else return false;"><img src="/images/delete_list.gif" border="0" alt=" Sil "></a>
            </td>
        </tr>
        </cfoutput>
         <cfif getRelDocs.recordcount><cfelse><tr><td colspan="5">Kayıt Yok</td></tr></cfif>
    </tbody>
   
</cf_ajax_list>
