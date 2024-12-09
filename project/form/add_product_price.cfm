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
        <select name="product" id="product">
            <option value="">Ürün</option>
            <optgroup label="Gerçek Ürünler" id="ProductrRealOptGroup">

            </optgroup>
            <optgroup label="Sanal Ürünler" id="ProductrVirtualOptGroup">

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
    SELECT PT.PRODUCT_TREE_ID,S.PRODUCT_NAME,S.PRODUCT_CODE FROM PRODUCT_TREE AS PT LEFT JOIN STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID WHERE PT.STOCK_ID=#attributes.PRODUCT#
</cfquery>


</cfif>



<script src="/AddOns/Partner/Project/js/fiyat_gir.js"></script>