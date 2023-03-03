<!----<style>
    .list-group-item:first-child {
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
}
.list-group-item {
    position: relative;
    display: block;
    padding: 0.75rem 1.25rem;
    margin-bottom: -1px;
    background-color: #fff;
    border: 1px solid rgba(0,0,0,.125);
}
.list-group {
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    -ms-flex-direction: column;
    flex-direction: column;
    padding-left: 0;
    margin-bottom: 0;
}
</style>----->
<link rel="stylesheet" href="/js/dx/lib/css/dx.light.css" />
<link rel="stylesheet" href="/js/dx/lib/css/styles.css" />





<script type="text/javascript" src="/js/dx/lib/js/cldr.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/cldr/event.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/cldr/supplemental.min.js"></script>

<script type="text/javascript" src="/js/dx/lib/js/globalize.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/globalize/message.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/globalize/number.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/globalize/currency.min.js"></script>
<script type="text/javascript" src="/js/dx/lib/js/globalize/date.min.js"></script>

<script type="text/javascript" src="/js/dx/lib/js/dx.all.js"></script>


 


<cfquery name="getassetsCats" datasource="#dsn#">
 Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_MAIN_ID=-1
UNION 
Select ASSETCAT_ID,ASSETCAT,ASSETCAT_PATH From workcube_metosan.ASSET_CAT where ASSETCAT_ID=-1
</cfquery>
<script>
    var products=[
        <cfoutput query="getassetsCats">
            <cfquery name="getAssets" datasource="#dsn#">
                   select ASSET_FILE_NAME,ASSET_NAME,NAME,ASSET.RECORD_DATE,workcube_metosan.getEmployeeWithId(ASSET.RECORD_EMP) AS RECORD_EMP,ASSET.ACTION_ID from workcube_metosan.ASSET 
                    left join workcube_metosan.CONTENT_PROPERTY on CONTENT_PROPERTY.CONTENT_PROPERTY_ID=ASSET.PROPERTY_ID
                    where ASSETCAT_ID=#ASSETCAT_ID# AND ASSET.ACTION_ID=#attributes.project_id#
               </cfquery>
               <cfset cr_id=currentrow>
            {
                id:'#cr_id#',
                text:'#ASSETCAT#',
                items:[
                    <cfloop query="getAssets">
                        {
                            id:'#cr_id#_#currentrow#',
                            text:'#getAssets.ASSET_NAME#'
                        },
                    </cfloop>
                ]
            },
        </cfoutput>
    ]
</script>
<cf_box title="Belgeler">
<div id="simple-treeview"></div>
</cf_box>
<script>
    $(() => {
  $('#simple-treeview').dxTreeView({
    items: products,
    width: 300,
    onItemClick(e) {
      const item = e.itemData;
      /*if (item.price) {
        $('#product-details').removeClass('hidden');
        $('#product-details > img').attr('src', item.image);
        $('#product-details > .price').text(`$${item.price}`);
        $('#product-details > .name').text(item.text);
      } else {
        $('#product-details').addClass('hidden');
      }*/
    },
  }).dxTreeView('instance');
});

</script>

<!----
<ul  class="list-group">
    <cfoutput>
        <cfloop query="getassetsCats">
            <li class="list-group-item" >
               <div style="display:flex;align-items: center;"><img src="css/assets/icons/catalyst-icon-svg/ctl-school-material.svg" width="30px"> <span style="margin-left:5px"> #ASSETCAT# </span> </div> 
               <cfquery name="getAssets" datasource="#dsn#">
                   select ASSET_FILE_NAME,ASSET_NAME,NAME,ASSET.RECORD_DATE,workcube_metosan.getEmployeeWithId(ASSET.RECORD_EMP) AS RECORD_EMP,ASSET.ACTION_ID from workcube_metosan.ASSET 
                    left join workcube_metosan.CONTENT_PROPERTY on CONTENT_PROPERTY.CONTENT_PROPERTY_ID=ASSET.PROPERTY_ID
                    where ASSETCAT_ID=#ASSETCAT_ID# AND ASSET.ACTION_ID=#attributes.project_id#
               </cfquery>
               <cfif getAssets.recordCount>
                <ul class="list-group">
                        <cfloop query="getAssets">
                            <li class="list-group-item"  >
                                <div style="display:flex;align-items: center;">
                                    <img src="css/assets/icons/catalyst-icon-svg/#listLast(ASSET_FILE_NAME,".")#.svg" width="30px">
                                    <span>
                                        #ASSET_NAME#
                                    </span>
                                </div>
                                
                            </li>
                        </cfloop>
                    </ul>
               </cfif>
            </li>
        </cfloop>
    </cfoutput>
</ul>----->