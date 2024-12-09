<style>
    .productFound{
        border: solid 4px #00800061 !important;
    }
    .productNotFound{
        border: solid 4px #ff000061 !important;
    }
    .productDefault{
    border: 1px solid #ccc !important;
    }
</style>
<cf_box title="Ürün Fiyat Girişi">

    <div class="form-group">
        <input type="text" name="project_no" placeholder="Proje No" id="project_no" onkeydown="getProjectProducts(this,event)">
    </div>
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#"><div class="form-group">
        <select name="product">
            <option value="">Ürün</option>
            <optgroup label="Ürünler" id="ProductOptGroup">

            </optgroup>
        </select>
    </div>
    <div class="form-group">
        <input type="submit">
        <input type="hidden" name="is_submit">
    </div>
</cfform>
</cf_box>
<cfif isDefined("attributes.is_submit")>
    <cfdump var="#attributes#">
<cfquery name="getTreeLevel1" datasource="#dsn3#">
    SELECT * FROM PRODUCT_TREE AS PT LEFT JOIN STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID WHERE STOCK_ID=#attributes.PRODUCT#
</cfquery>


</cfif>



<script>
function getProjectProducts(el,ev) {
    if(ev.keyCode==13){
        
var project_number=el.value
var ProjectResult=wrk_query("SELECT TOP 10 PROJECT_ID,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_HEAD='"+project_number+"'","DSN")
var Products=wrk_query("SELECT TOP 5 PRODUCT_ID,PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE PROJECT_ID="+ProjectResult.PROJECT_ID[0],"DSN3")
if(Products.recordcount>0){
    console.log("Kayıt Var")
    document.getElementById("ProductOptGroup").parentElement.setAttribute("class","productFound")
}else{
    document.getElementById("ProductOptGroup").parentElement.setAttribute("class","productNotFound")
}
$("#ProductOptGroup").html("")
for(let i=0;i<Products.recordcount;i++){
    var opt=document.createElement("option")
    opt.value=Products.STOCK_ID[i]
    opt.innerText=Products.PRODUCT_NAME[i]
    document.getElementById("ProductOptGroup").appendChild(opt)
}

    }else{
       // document.getElementById("ProductOptGroup").parentElement.setAttribute("class","productDefault")
    }
}

</script>