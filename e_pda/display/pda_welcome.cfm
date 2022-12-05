<cfif 1136 eq 1136>
    <cfquery name="getF" datasource="#dsn#">
        SELECT * FROM WRK_MODULE WHERE FAMILY_ID=39
    </cfquery>

    
    
        <cfloop query="getF">
            <cfif listFind(session.ep.USER_LEVEL,MODULE_NO)>
            <cf_box title="#getf.MODULE#" collapsed="1">
                <cfquery name="getO" datasource="#dsn#">
                select * from WRK_OBJECTS where MODULE_NO=#getF.MODULE_NO#  and IS_LIVESTOCK=1 ORDER BY CONVERT(INT,left(HEAD,2))
                </cfquery>
                <div style="display:flex;flex-wrap: wrap;">
                <cfloop query="getO">
                    <cfquery name="gets" datasource="#dsn#">
                        select * from USER_GROUP_OBJECT where USER_GROUP_ID=(select USER_GROUP_ID from EMPLOYEE_POSITIONS where EMPLOYEE_ID=#session.ep.userid#) AND OBJECT_NAME='#FULL_FUSEACTION#'
                    </cfquery>
                    <cfif NOT gets.recordCount>
                    <cfoutput><a href="/index.cfm?fuseaction=#FULL_FUSEACTION#"  style="margin-right:2px;margin-top:1px;width: 20%;display: block;padding: 10px;text-align: center;border: solid;border-radius: 10px;"><img src="/images/e-pd/#ICON#" style="width:35px"><br>#HEAD#</cfoutput></a>
                    </cfif>
                </cfloop>
            </div>
            </cf_box>
        </cfif>
        </cfloop>
        <script>
            $(document).ready(function () {
                $(".header").hide();
            })
        </script>
    <cfabort>
</cfif>

<style>
td{
    border-bottom:solid 0.5px black;
    padding-top:5px;
    padding-bottom:5px;
}
h5{
    font-weight:bold;
    display:inline; 
    margin-left:15px;
    
}
    .btncls{
        display: block;
        width: 100%;
    }
    .btncls:hover{
        background-color: #E6E6E6;
    }

</style>
<table style="width:100%">
    <tr>
        <td colspan="2">
        <h3>E-PDA</h3>
        </td>
    </tr>
    <tr>


    <td>
    <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"class="tableyazi btncls" style="display:block;width:100% "><img src="../../images/e-pd/up30.png"> <h5>Ambardan Sevkiyata</h5></a>
    </td>
    </tr>
        <tr>
    <td>
     <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>" class="tableyazi btncls"><img src="../../images/e-pd/down30.png"><h5>Mal Kabulden Ambara</h5></a>
    </td>
    </tr>
        <tr>
    <td>
     <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_mal</cfoutput>" class="tableyazi btncls"><img src="../../images/e-pd/exit30.png"><h5>Ambardan Mal Kabule</h5></a>
    </td>
    </tr>
        <tr>
    <td>
    <a  class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png"> <h5>Sevkiyat Kontrol</h5></a>
    </td>
    </tr>
        <tr>

    <td>    

     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_list_print_spool</cfoutput>"><img src="../../images/e-pd/barcode30.png"><h5>Etiket Havuzu</h5></a>
    </td>
    </tr>
        <tr>

    <td>  

     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_raf_degistir</cfoutput>">  <img src="../../images/e-pd/shelf30.png"><h5>Raf Değiştir</h5></a>
    </td>
    </tr>
        <tr>

    <td>    

    <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_fis</cfoutput>"><img src="../../images/e-pd/ticket30.png"><h5>Ambar Fişi</h5></a>
    </td>
    </tr>
        <tr>

    <td>
     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_form_shelf</cfoutput>"><img src="../../images/e-pd/pro30.png"><h5>Ürün Raf Tanımla</h5></a>
    </td>
    </tr>
        <tr>

    <td>    

     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_depo_sayim</cfoutput>"><img src="../../images/e-pd/say30.png"><h5>Depo Sayım Belgesi</h5></a>
    </td>
    </tr>
        <tr>


    <td>
     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.prtotm_raf_sayim</cfoutput>"><img src="../../images/e-pd/say30.png"><h5>Raf Sayım Belgesi</h5></a>
    </td>
    </tr>
            <tr>


    <td>
     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=pda.stock_location_partner</cfoutput>"><img src="../../images/e-pd/say30.png"><h5>Lokasyona Göre Stoklar</h5></a>
    </td>
    </tr>
                <tr>


    <td>
     <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=pda.form_add_stock_update</cfoutput>"><img src="../../images/e-pd/ticket30.png"><h5>Raf Düzeltme Belgesi</h5></a>
    </td>
    </tr>
    <tr>


        <td>
         <a class="tableyazi btncls" href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_display_get_raf</cfoutput>"><img src="../../images/e-pd/sh30.png"><h5>Raf Sorgulama</h5></a>
        </td>
        </tr>
</table>

