<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">


<cf_box title="Malzeme İhtiyaçları">
    <div class="form-group">
        <select name="PRODUCT" onchange="getIcerik(this.value)">
            <option value="">Seçiniz</option>
            <cfquery name="getVP" datasource="#dsn3#">
                SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE PROJECT_ID=#attributes.PROJECT_ID#
            </cfquery>
            <cfoutput>
                <optgroup label="Sanal Ürünler">
                <cfloop query="getVp">
                    <option value="#1#_#VIRTUAL_PRODUCT_ID#">#PRODUCT_NAME#</option>
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
                    <option value="#0#_#STOCK_ID#">#PRODUCT_NAME#</option>
                </cfloop>
            </optgroup>
            </cfoutput>
        </select>
    </div>
    <div id="productNeed">
        
    </div>
<script>
var PROJECT_ID=<cfoutput>#attributes.PROJECT_ID#</cfoutput>
    function getIcerik(ela){
        AjaxPageLoad(
            "index.cfm?fuseaction=project.emptypopup_list_project_product_needs_ajax&pidow=" +ela,"productNeed",1,"Yükleniyor");
    }
</script>




</cf_box>
<script src="/AddOns/Partner/project/js/ihtiyacPlani.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>