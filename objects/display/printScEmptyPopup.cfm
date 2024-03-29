﻿<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<style>
    @media print {
   .noPrint {display:none;}
   .hide-on-screen {display:block;}
}
</style>
<cfif attributes.printType eq "STOK_FIS">
    <cfquery name="getRows" datasource="#dsn2#">
        
	SELECT SR.*,SL.COMMENT,D.DEPARTMENT_HEAD,S.PRODUCT_NAME,PP.SHELF_CODE,SL.LOCATION_ID,SL.DEPARTMENT_ID,S.BARCOD,CONVERT(varchar,SL.DEPARTMENT_ID)+'-'+CONVERT(VARCHAR,SL.LOCATION_ID) AS SSLT,S.STOCK_CODE FROM #DSN2#.STOCK_FIS_ROW AS SR 
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=SR.STOCK_ID
LEFT JOIN workcube_metosan_1.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=PP.STORE_ID
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.DEPARTMENT_ID=PP.STORE_ID AND SL.LOCATION_ID=PP.LOCATION_ID
LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=SR.STOCK_ID
WHERE FIS_ID=#attributes.ACTION_ID# ORDER BY SL.DEPARTMENT_ID,SL.LOCATION_ID 


    </cfquery>
     <table class="table table-borderless" >
        <tr>
            <td style="height:40px;"><b><cf_get_lang dictionary_id='33929.Ürün Detay'></b></td>
        </tr>
    </table>
    <table class="table table-borderless" style="width:190mm">
        <tr><td style="width:100px"></td>
            <td>Raf Kodu</td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57518.Inventory Code'></b></td>
            <td   style="width:300px"><b><cf_get_lang dictionary_id='57657.ÜRÜN'></b></td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
            <td   style="width:50px"><b><cf_get_lang dictionary_id='57636.Adet'></b></td>
        </tr>
        <cfoutput query="getRows" group="SSLT">
            
        <tr><th colspan="5">#DEPARTMENT_HEAD#- #COMMENT#</th></tr>
            
            <cfoutput>
              
               <tr>
               
                <td style="text-align:center"><cf_workcube_barcode type="code128"  value="#getRows.BARCOD#" show="1" width="80" height="35"><br>
                    #BARCOD#
                </td>
                <td>#SHELF_CODE#</td>
                <td>#getRows.Stock_Code#</td>
                <td>#left(getRows.PRODUCT_NAME,53)#</td>
                <td  style="text-align:right;">#getRows.Amount#</td>
                <td>#getRows.Unit#</td>
            </tr>
            </cfoutput>
            
        </cfoutput>
        
</cfif>
<div class="noPrint" style="position: absolute;bottom: 0;width: 100%;">
    <div style="display:flex;align-content: space-between;justify-content: space-between;">
<a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"class="tableyazi btncls" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/up30.png"> <h6 style="font-size:10pt">Ambardan Sevkiyata</h6></a>
<a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>" class="tableyazi btncls" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/down30.png"><h6 style="font-size:10pt">Mal Kabulden Ambara</h6></a>
<a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_mal</cfoutput>" class="tableyazi btncls" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/exit30.png"><h6 style="font-size:10pt">Ambardan Mal Kabule</h6></a>
<a  class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png"> <h6 style="font-size:10pt">Sevkiyat Kontrol</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_list_print_spool</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/barcode30.png"><h6 style="font-size:10pt">Etiket Havuzu</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_raf_degistir</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;">  <img style="width:20px" src="../../images/e-pd/shelf30.png"><h6 style="font-size:10pt">Raf Değiştir</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_fis</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/ticket30.png"><h6 style="font-size:10pt">Ambar Fişi</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_form_shelf</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/pro30.png"><h6 style="font-size:10pt">Ürün Raf Tanımla</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_depo_sayim</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/say30.png"><h6 style="font-size:10pt">Depo Sayım Belgesi</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_raf_sayim</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/say30.png"><h6 style="font-size:10pt">Raf Sayım Belgesi</h6></a>        
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=pda.stock_location_partner</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/say30.png"><h6 style="font-size:10pt">Lokasyona Göre Stoklar</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=pda.form_add_stock_update</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/ticket30.png"><h6 style="font-size:10pt">Raf Düzeltme Belgesi</h6></a>
<a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_display_get_raf</cfoutput>" style="text-align: center;border: solid 1px gray;padding: 1px;border-radius: 10px;"><img style="width:20px" src="../../images/e-pd/sh30.png"><h6 style="font-size:10pt">Raf Sorgulama</h6></a>
</div>
            
    
</div>
<script>
    $(document).ready(function (params) {
        $("#wrk_bug_add_div").remove();
        $("body").attr("style","background:white");
        $("#wrk_main_layout").attr("class","container-fluid")
        window.print();
        

    })
</script>