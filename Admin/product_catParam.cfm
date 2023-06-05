<cfset ColumnData=[
    {column_name='PRODUCT_CATID',descr='Ürün Kategorisi'},
    {column_name='IS_INVENTORY',descr='Envantere Dahil'},
    {column_name='IS_PRODUCTION',descr='Üretiliyor'},
    {column_name='IS_SALES',descr='Satılıyor'},
    {column_name='IS_PURCHASE',descr='Tedarik Ediliyor'},
    {column_name='IS_PROTOTYPE',descr='Prototip'},
    {column_name='IS_INTERNET',descr='İnternet te Satılıyor'},
    {column_name='IS_EXTRANET',descr='Extranet te Satılıyor'},
    {column_name='IS_TERAZI',descr='Teraziye Gidiyor'},
    {column_name='IS_KARMA',descr='Karma Koli'},
    {column_name='IS_ZERO_STOCK',descr='Sıfır Stok İle Çalış'},
    {column_name='IS_LIMITED_STOCK',descr='Stoklarla Sınırlı'},
    {column_name='IS_SERIAL_NO',descr='Seri No Takibi Yapılıyor'},
    {column_name='IS_LOT_NO',descr='Lot No Takibi Yapılıyor Sınırlı'},
    {column_name='IS_LOT_NO',descr='Lot No Takibi Yapılıyor Sınırlı'},
    {column_name='IS_COST',descr='Maliyet Takibi Yapılıyor Sınırlı'},
    {column_name='IS_IMPORTED',descr='İthal Ediliyor'},
    {column_name='IS_COMMISION',descr='Pos Komisyonu Hesapla'},
    {column_name='IS_GIFT_CARD',descr='Hediye Çekimi'},
    {column_name='PRODUCT_UNIT',descr='Birim'},
    {column_name='TAX',descr='Satış Kdv Oranı'},
    {column_name='TAX_PURCHASE',descr='Alış Kdv Oranı'},
    {column_name='ACC_CODE_CAT',descr='Muhasebe Kod Grubu'},    
]>



  

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
        <div class="form-group" id="item-product_status">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Durum </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="product_status" id="product_status" value="1" checked="">Aktif /Pasif </div>
        </div>
        <div class="form-group" id="item-is_inventory">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Envanter </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_inventory" id="is_inventory" value="1" checked="">Envantere Dahil </div>
        </div>
        <div class="form-group" id="item-is_production">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Üretim </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                <input type="checkbox" name="is_production" id="is_production" value="1" checked="checked">Üretiliyor 
            </div>
        </div>
        <div class="form-group" id="item-is_sales">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Satış </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_sales" id="is_sales" value="1" checked="">Satışta </div>
        </div>
        <div class="form-group" id="item-is_purchase">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Tedarik </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_purchase" id="is_purchase" value="1" checked="">Tedarik Ediliyor </div>
        </div>
        <div class="form-group" id="item-is_prototype">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Prototip </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <input type="checkbox" name="is_prototype" id="is_prototype" value="1">Özelleştirilebilir 
            </div>
        </div>
        <div class="form-group" id="item-is_internet">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Internet </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" value="1">Satılıyor </div>
        </div>
        <div class="form-group" id="item-is_extranet">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Extranet </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_extranet" id="is_extranet" value="1">Satılıyor </div>
        </div>
        <div class="form-group" id="item-is_terazi">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Terazi </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_terazi" id="is_terazi" value="1">Teraziye Gidiyor </div>
        </div>
        <div class="form-group" id="item-is_karma">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Karma Koli </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_karma" id="is_karma" value="1"> Evet </div>
        </div>
        <div class="form-group" id="item-is_zero_stock">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Sıfır Stok </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_zero_stock" id="is_zero_stock" value="1">İle Çalış </div>
        </div>
        <div class="form-group" id="item-is_limited_stock">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Stoklarla Sınırlı </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1"> Evet </div>
        </div>
        
            <div class="form-group" id="item-is_serial_no">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Seri No </label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_serial_no" id="is_serial_no" value="1">Takibi Yapılıyor </div>
            </div>
        
        <div class="form-group" id="item-is_lot_no">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Lot No </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_lot_no" id="is_lot_no" value="1">Takibi Yapılıyor </div>
        </div>
        <div class="form-group" id="item-is_cost">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Maliyet </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_cost" id="is_cost" value="1" checked="">Takip Ediliyor </div>
        </div>
        <div class="form-group" id="item-is_imported">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">İthal </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_imported" id="is_imported" value="1">İthal Ediliyor </div>
        </div>
        <div class="form-group" id="item-is_quality">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Kalite </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_quality" id="is_quality" value="1">Takip Ediliyor </div>
        </div>
        <div class="form-group" id="item-is_commission">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Pos Komisyonu </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_commission" id="is_commission" value="1">Hesapla </div>
        </div>
        
        <div class="form-group" id="item-is_gift_card">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Hediye Çeki </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_gift_card" id="is_gift_card" value="1" onclick="kontrol_day();"></div>
        </div>
        
        
        <div class="form-group" id="item-gift_valid_day" style="display:none">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Geçerlilik Gün </label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="input" name="gift_valid_day" id="gift_valid_day" value="" maxlength="4" onkeyup="isNumber(this);" class="moneybox"></div>
        </div>
        
    </div>