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
    {column_name='TAX',descr='Satış Kdv'},
    {column_name='TAX_PURCHASE',descr='Alış Kdv'}
]>

<cfif attributes.ev eq "add">
    <cfif not isDefined("attributes.is_submit")>
        <cfinclude template="includes/addParamSettings.cfm">
    <cfelse>
        <cfinclude template="includes/addParamSettingsQuery.cfm">
    </cfif>
<cfelseif attributes.ev eq "list">
    
    <cfinclude template="includes/listParamSettings.cfm">
<cfelseif attributes.ev eq "upd">
</cfif>




  

    