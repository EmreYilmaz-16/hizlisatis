<cfquery name="getCatimages" datasource="#dsn1#">
    SELECT * FROM PRODUCTCAT_IMAGES WHERE PRODUCT_CATID=#attributes.product_catid#
</cfquery>

<cf_grid_list>
<thead>
    <tr>
        <th></th>
        <th>Resim Adı</th>
        <th>Açklama</th>
        <th>Boyut</th>
        <th>Internet ?</th>
        <th></th>
    </tr>
</thead>

<tbody>
    <cfoutput query="getCatimages">
    <tr>
        <td>
        
         <cfif len(VIDEO_PATH)>
         <img src="https://img.youtube.com/vi/#REPLACE("#VIDEO_PATH#","https://www.youtube.com/watch?v=","","ALL")#/0.jpg" width="50" height="50"> (Video)
         <cfelse>
        <img src="/documents/productcat/#PATH#" width="50" height="50">
        </cfif>
        </td>
        <td>
        <cfif len(VIDEO_PATH)>
        <cfset video = "#REPLACE("#VIDEO_PATH#","watch?v=","embed/","ALL")#">
            <a href="javascript://" onclick="openVideo('#video#',1)">#PRD_IMG_NAME#</a>
        <cfelse>
        <a href="javascript://" onclick="openVideo('/documents/productcat/#PATH#',2)">#PRD_IMG_NAME#</a>
        </cfif></td>
        <td>#DETAIL#</td>
        <td><cfif IMAGE_SIZE eq 0>Küçük </cfif><cfif IMAGE_SIZE eq 1>Orta </cfif><cfif IMAGE_SIZE eq 2>Büyük </cfif></td>
        <td><cfif IS_INTERNET eq 0>Hayır<cfelse>Evet</cfif></td>
        <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.form_upd_popup_catimage&action_id=#PRODUCTCAT_IMAGEID#','medium');"><img src="/images/update_list.gif" border="0" title=" Güncelle "></a>
        <a  href="javascript://" onclick="delprimage('#PRODUCTCAT_IMAGEID#')"><img src="/images/delete_list.gif" border="0"></a>
        </td>
    </tr>
    </cfoutput>
</tbody>
</cf_grid_list>
<script>
function delprimage(imgid){
    var a =confirm('Kayıtlı imajı silmek istediğinize emin misiniz?')
    console.log(a)
    if(a===true){
        console.log("hello")

   windowopen('index.cfm?fuseaction=product.del_productcat_image&image_id='+imgid,"medium")
   console.log(xx)
    location.reload()
}
   
}
function openVideo(urla,tip){
    var html="";
    if(tip===1){
     html = "<div style='margin-left:auto;margin-right:auto'><iframe src='"+urla+"' width='100%' height='100%'></iframe></div>";
   }else{
       html = "<div style='margin-left:auto;margin-right:auto'><img src='"+urla+"' width='100%' /></div>";
   }
    const dualScreenLeft = window.screenLeft !==  undefined ? window.screenLeft : window.screenX;
    const dualScreenTop = window.screenTop !==  undefined   ? window.screenTop  : window.screenY;
    const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height    
    const systemZoom = width / window.screen.availWidth;
     const left = (width - 700) / 2 / systemZoom + dualScreenLeft
    const top = (height - 500) / 2 / systemZoom + dualScreenTop
    var newWindow = window.open("","","width=700,height=500,scrollbars=1,resizable=0,top="+top+",left="+left)
    newWindow .document.open()
     newWindow .document.write(html)
}

</script>

