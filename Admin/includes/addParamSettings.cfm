<cf_box title="Kategori Parametreleri Ekle">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&ev=add" name="search_product">
<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
    <div class="form-group" id="item-cat_id">
        <label>Kategori </label>
        <div class="input-group">
            <input type="hidden" name="cat_id" id="cat_id" value="">
            <input type="hidden" name="cat" id="cat" value="">
            <input name="category_name" type="text" id="category_name" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="" autocomplete="off">
            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name');"></span>
        </div>
    </div>
    <div class="form-group">
        <label>
            Birim
        </label>
        <cfquery name="getUnit" datasource="#dsn#">
            select * from workcube_metosan.SETUP_UNIT
            </cfquery>
            <select name="ProductUnit">
            <cfoutput query="getUnit">
                <option value="#UNIT_ID#">#UNIT#</option>
            </cfoutput>
            </select>
       </div>
       <cfquery name="getTax" datasource="#dsn2#">
        select * from SETUP_TAX
       </cfquery>
       <div class="form-group">
        <label>Satış Kdv</label>
        <select name="TAX">
            <cfoutput query="getTax">
                <option value="#TAX#">% #TAX#</option>
            </cfoutput>
        </select>
       </div>
       <div class="form-group">
        <label>
            Alış Kdv
        </label>
        <select name="TAX_PURCHASE">
            <cfoutput query="getTax">
                <option value="#TAX#">% #TAX#</option>
            </cfoutput>
        </select>
       </div>
    <div class="form-group" id="item-is_inventory">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Envanter </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_INVENTORY" id="IS_INVENTORY" value="1" >Envantere Dahil </div>
    </div>
    <div class="form-group" id="item-is_production">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Üretim </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <input type="checkbox" name="IS_PRODUCTION" id="IS_PRODUCTION" value="1" checked="checked">Üretiliyor 
        </div>
    </div>
    <div class="form-group" id="item-is_sales">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Satış </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_SALES" id="IS_SALES" value="1" >Satışta </div>
    </div>
    <div class="form-group" id="item-is_purchase">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Tedarik </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_PURCHASE" id="IS_PURCHASE" value="1" >Tedarik Ediliyor </div>
    </div>
    <div class="form-group" id="item-is_prototype">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Prototip </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
            <input type="checkbox" name="IS_PROTOTYPE" id="IS_PROTOTYPE" value="1">Özelleştirilebilir 
        </div>
    </div>
    <div class="form-group" id="item-is_internet">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Internet </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_INTERNET" id="IS_INTERNET" value="1">Satılıyor </div>
    </div>
    <div class="form-group" id="item-is_extranet">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Extranet </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_EXTRANET" id="IS_EXTRANET" value="1">Satılıyor </div>
    </div>
    <div class="form-group" id="item-is_terazi">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Terazi </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_TERAZI" id="IS_TERAZI" value="1">Teraziye Gidiyor </div>
    </div>
    <div class="form-group" id="item-is_karma">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Karma Koli </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_KARMA" id="IS_KARMA" value="1"> Evet </div>
    </div>
    <div class="form-group" id="item-is_zero_stock">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Sıfır Stok </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_ZERO_STOCK" id="IS_ZERO_STOCK" value="1">İle Çalış </div>
    </div>
    <div class="form-group" id="item-is_limited_stock">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Stoklarla Sınırlı </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_LIMITED_STOCK" id="IS_LIMITED_STOCK" value="1"> Evet </div>
    </div>
    
        <div class="form-group" id="item-is_serial_no">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Seri No </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_SERIAL_NO" id="IS_SERIAL_NO" value="1">Takibi Yapılıyor </div>
        </div>
    
    <div class="form-group" id="item-is_lot_no">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Lot No </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_LOT_NO" id="IS_LOT_NO" value="1">Takibi Yapılıyor </div>
    </div>
    <div class="form-group" id="item-is_cost">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Maliyet </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_COST" id="IS_COST" value="1" >Takip Ediliyor </div>
    </div>
    <div class="form-group" id="item-is_imported">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">İthal </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_IMPORTED" id="IS_IMPORTED" value="1">İthal Ediliyor </div>
    </div>
    <div class="form-group" id="item-is_quality">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Kalite </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_QUALITY" id="IS_QUALITY" value="1">Takip Ediliyor </div>
    </div>
    <div class="form-group" id="item-is_commission">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Pos Komisyonu </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_COMMISION" id="IS_COMMISION" value="1">Hesapla </div>
    </div>
    
    <div class="form-group" id="item-is_gift_card">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Hediye Çeki </label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="IS_GIFT_CARD" id="IS_GIFT_CARD" value="1" onclick="kontrol_day();"></div>
    </div>


</div>

<input type="submit">
</cfform>
</cf_box>