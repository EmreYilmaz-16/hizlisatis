<cfquery name="getVirtualProductionOrder" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>
<cfquery name="AddVirtualResult" datasource="#dsn3#">

</cfquery>



<!-------
	Sanal Sonuç Tablosunu Oluştur
	Sanal Sonuç Ekle
	Ürün Oluştur
	Ağacacı Oluştur
	Gerçek İş Emri Oluştur
	Gerçek Üretim Sonucu Oluştur
	Teklifi Güncelle
	Bildirim Gönder
	----->

