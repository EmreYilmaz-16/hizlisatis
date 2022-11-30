<cfsetting showdebugoutput="yes">
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
        SELECT     
            STOCK_CODE, 
            STOCK_CODE_2, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            UNIT, 
            AMOUNT, 
            SHIPPING_ID, 
            STOCK_ID,
           	CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN
                	PRODUCT_TREE_AMOUNT
             	ELSE             
                    ISNULL(
                            (
                            SELECT     
                                SUM(PAKET_SAYISI) AS PAKET_SAYISI
                            FROM         
                                PRTOTM_PAKET_SAYISI
                            WHERE     
                                MODUL_ID = TBL.STOCK_ID
                            ) * AMOUNT
                    	, 0)
           	END 
                AS PAKET_SAYISI, 
            ISNULL(
                    (
                    SELECT     
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM         
                        PRTOTM_SHIPPING_PACKAGE_LIST
                    WHERE     
                        REF_STOCK_ID = TBL.STOCK_ID AND 
                        SHIPPING_ID = TBL.SHIPPING_ID AND 
                        TYPE = 1
                    )
            , 0) AS CONTROL_AMOUNT
        FROM         
            (
            SELECT     
            	S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                ORR.UNIT, 
                SUM(ORR.QUANTITY) AS AMOUNT, 
                ESRR.SHIP_RESULT_ID AS SHIPPING_ID, 
             	S.STOCK_ID,
                S.PRODUCT_TREE_AMOUNT
			FROM         
            	ORDER_ROW AS ORR INNER JOIN
                PRTOTM_SHIP_RESULT_ROW AS ESRR ON ORR.ORDER_ROW_ID = ESRR.ORDER_ROW_ID INNER JOIN
                STOCKS AS S ON ORR.STOCK_ID = S.STOCK_ID
			GROUP BY 
            	S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                ESRR.SHIP_RESULT_ID, 
                ORR.UNIT, 
                S.STOCK_ID,
                S.PRODUCT_TREE_AMOUNT
			HAVING      
            	ESRR.SHIP_RESULT_ID = #attributes.ship_id#
            ) AS TBL                      
    </cfquery>
<cfelse>
    <cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
        SELECT     
            STOCK_CODE, 
            STOCK_CODE_2, 
            PRODUCT_ID, 
            PRODUCT_NAME, 
            UNIT, 
            AMOUNT, 
            SHIPPING_ID, 
            STOCK_ID, 
            CASE
            	WHEN 
                	PRODUCT_TREE_AMOUNT IS NOT NULL
              	THEN
                	PRODUCT_TREE_AMOUNT
             	ELSE             
                    ISNULL(
                            (
                            SELECT     
                                SUM(PAKET_SAYISI) AS PAKET_SAYISI
                            FROM         
                                PRTOTM_PAKET_SAYISI
                            WHERE     
                                MODUL_ID = TBL.STOCK_ID
                            ) * AMOUNT
                    	, 0)
           	END 
                AS PAKET_SAYISI,  
            ISNULL(
                    (
                    SELECT     
                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                    FROM         
                        PRTOTM_SHIPPING_PACKAGE_LIST
                    WHERE     
                        REF_STOCK_ID = TBL.STOCK_ID AND 
                        SHIPPING_ID = TBL.SHIPPING_ID AND 
                        TYPE = 1
                    )
            , 0) AS CONTROL_AMOUNT
        FROM         
            (
            SELECT 
            	S.PRODUCT_TREE_AMOUNT,    
                S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                SIR.UNIT, 
                SUM(SIR.AMOUNT) AS AMOUNT, 
                SIR.DISPATCH_SHIP_ID AS SHIPPING_ID, 
                SIR.STOCK_ID
            FROM          
                workcube_rendimobilya_2014_1.dbo.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                STOCKS AS S ON SIR.STOCK_ID = S.STOCK_ID
            GROUP BY
            	S.PRODUCT_TREE_AMOUNT, 
                S.STOCK_CODE, 
                S.STOCK_CODE_2, 
                S.PRODUCT_ID, 
                S.PRODUCT_NAME, 
                SIR.UNIT, 
                SIR.DISPATCH_SHIP_ID, 
                SIR.STOCK_ID
            HAVING      
                SIR.DISPATCH_SHIP_ID = #attributes.ship_id#
            ) AS TBL                      
    </cfquery>
</cfif>    
<cfquery name="get_url" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER,
    	DELIVER_STORE_ID,
        LOCATION
    FROM
    	SHIP
    WHERE
    	(SHIP_ID = #ship_id#)
</cfquery>
<style>
table, td, th, div {
    font-size: 13px;
    font-family: 'Roboto', sans-serif !important;
	font-weight: 600;
}
.form-title{
    font-size:13px;
}
</style>
<!---<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>--->
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_shipping&department_id=#department_id#&date1=#date1#&date2=#date2#&is_form_submitted=1&page=#page#&kontrol_status=#kontrol_status#">
<table cellpadding="2" cellspacing="1" align="left" class="color-border">
	    <tr>
  <td colspan="4">
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  
  </td>
  </tr>
    <form name="add_fis" method="post" action="<cfoutput>#request.self#?fuseaction=#adres#</cfoutput>">
        <tr class="color-list">
            <td colspan="4">
            <table width="99%" height="29" cellpadding="0" cellspacing="0">
                <tr>
                    <td> <cfif attributes.is_type eq 1><b>Sevk Plan No :</b><cfelse><b>Sevk Talep No :</b></cfif><cfoutput>#attributes.DELIVER_PAPER_NO#</cfoutput></b></td>
                    <td><input type="submit" value="Geri" name="1"></td>
                </tr>
            </table>
            </td>
        </tr>
        <tr class="color-list" height="20">
            <td width="45">
                Stok Kodu
            </td>
            <td>
                Stok Adı
            </td>
            <td width="25">
                Miktar
            </td>
            <td width="20">
                OK
            </td>                                
        </tr>
        <cfoutput query="GET_SHIP_ROW">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                
                <td><a href="#request.self#?fuseaction=epda.prtotm_shipping_control_stock&ship_id=#ship_id#&f_stock_id=#GET_SHIP_ROW.stock_id#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&product_name=#PRODUCT_NAME#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#">
                #STOCK_CODE_2#
                </a>
                </td>
                
                <!---&ship_id=#URLEncodedFormat(islem_id)#&belge_no=#URLEncodedFormat(belge_no)--->
        
                <td ><a href="#request.self#?fuseaction=epda.prtotm_shipping_control_stock&ship_id=#ship_id#&f_stock_id=#GET_SHIP_ROW.stock_id#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&product_name=#PRODUCT_NAME#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#">
                #PRODUCT_NAME#
                </a>
                </td>
                <!---<input type="hidden" name="stock_id" value="STOCK_ID" />
                <input type="hidden" name="ship_id" value="#attributes.ship_id#" />
                <input type="hidden" name="amount#STOCK_ID#" value="#AMOUNT#" />
                <input type="hidden" name="control_amount#STOCK_ID#" value="<cfif isdefined('control_amount#STOCK_ID#')>#Tlformat(Evaluate('control_amount#STOCK_ID#'),0)# <cfelse>#Tlformat(0,0)#</cfif>" />--->
                <td style="text-align:right;color:FF0000;"><strong>#PAKET_SAYISI#</strong></td>
                <!---<td style="text-align:right;color:FF0000;"><strong><cfif isdefined('control_amount#STOCK_ID#')>#Tlformat(Evaluate('control_amount#STOCK_ID#'),0)# <cfelse>#Tlformat(0,0)#</cfif></strong></td>--->
                <td align="center">
                 <cfif PAKET_SAYISI eq 0>
                    <img src="/images/plus_ques.gif" border="0" title="Barkod Yok.">
                 <cfelseif PAKET_SAYISI - CONTROL_AMOUNT eq 0>
                    <img src="/images/c_ok.gif" border="0" title="Kontrol Edildi.">
                 <cfelseif CONTROL_AMOUNT eq 0>
                    <img src="/images/caution_small.gif" border="0" title="Kontrol Edilmedi.">
                 <cfelseif PAKET_SAYISI gt CONTROL_AMOUNT>
                    <img src="/images/warning.gif" border="0" title="Kontrol Eksik.">   
                 </cfif>
                </td>       
            </tr>
        </cfoutput>
    </form>
</table>
