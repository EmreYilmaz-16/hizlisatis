<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">


<cf_box title="Malzeme İhtiyaçları">
    <div class="form-group">
        <div class="input-group" style="display: flex;flex-wrap: nowrap;">  
        <select name="PRODUCT" onchange="getIcerik(this.value)">
            <option value="">Seçiniz</option>
            <cfquery name="getVP" datasource="#dsn3#">
                SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID=#attributes.PROJECT_ID#
            </cfquery>
            <cfoutput>
                <optgroup label="Sanal Ürünler">
                <cfloop query="getVp">
                    <option value="#1#_#VIRTUAL_PRODUCT_ID#_#attributes.PROJECT_ID#">#PRODUCT_NAME#</option>
                </cfloop>
            </optgroup>
            <optgroup label="Gerçek Ürünler">
                <cfquery name="getRp" datasource="#dsn1#">
                    SELECT * FROM (
SELECT PRODUCT.PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PRODUCT.PRODUCT_STAGE,(SELECT COUNT(*) FROM #DSN3#.PRODUCT_TREE WHERE RELATED_ID=STOCKS.STOCK_ID) AS RC FROM #DSN1#.PRODUCT 
LEFT JOIN #DSN1#.STOCKS ON STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
Where PROJECT_ID=#attributes.PROJECT_ID# ) AS T WHERE RC=0
                </cfquery>
                <cfloop query="getRp">
                    <option value="#0#_#STOCK_ID#_#attributes.PROJECT_ID#">#PRODUCT_NAME#</option>
                </cfloop>
            </optgroup>
            </cfoutput>
        </select>
        <span style="cursor: pointer;" onclick="SevkeCek()" class="input-group-text">Sevke Çek</span>
    </div>
    </div>
    <div id="productNeed">
        
    </div>
<script>
var PROJECT_ID=<cfoutput>#attributes.PROJECT_ID#</cfoutput>
    function getIcerik(ela){
        AjaxPageLoad(
            "index.cfm?fuseaction=project.emptypopup_list_project_product_needs_ajax&project_id="+PROJECT_ID+"&pidow=" +ela,"productNeed",1,"Yükleniyor");
    }
</script>
<script>
    function SevkeCek(){
        var rows=document.getElementById("rowws").children
        var row_count=document.getElementById("rowws").children.length
        for(let i=1;i<=row_count;i++){
    var Bky_element=document.getElementById("bky_"+i).innerText
    var Bky=Bky_element.split(" ")[0]

    var t_element=document.getElementById("TMK_"+i).innerText
    var TMK=t_element.split(" ")[0]
    var svbekleyen_element=document.getElementById("svbekleyen_"+i).innerText
    var svbekleyen=svbekleyen_element.split(" ")[0]
    console.log(svbekleyen)
     svbekleyen=parseFloat(filterNum(svbekleyen))
    if(Bky>(TMK-svbekleyen)){
        document.getElementById("IHTIYAC_"+i).value=parseFloat(filterNum(TMK-svbekleyen))
         document.getElementById("orderrow_currency_"+i).value=-6
         rows[i-1].style.backgroundColor="#00800054"
    }else{
        
    }
   // console.log(b1) orderrow_currency_1 IHTIYAC_1
    var O={
        bky:parseFloat(filterNum(Bky)),
        tmk:parseFloat(filterNum(TMK))
    }
    //console.log(O)
}
    }
</script>



</cf_box>
<script src="/AddOns/Partner/project/js/ihtiyacPlani.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>