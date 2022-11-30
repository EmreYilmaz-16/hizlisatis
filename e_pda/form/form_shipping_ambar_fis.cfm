<cfsetting showdebugoutput="no">
<cfquery name="get_shelf" datasource="#dsn3#">
	SELECT TOP (10) SHELF_CODE FROM PRODUCT_PLACE WHERE STORE_ID = #ListGetAt(attributes.department_out_id,1,'-')# AND LOCATION_ID = #ListGetAt(attributes.department_out_id,2,'-')#
</cfquery>
<cfquery name="get_spool" datasource="#dsn3#">
 	SELECT STOCK_ID FROM PRTOTM_PDA_PRINT_SPOOL WHERE SHIP_ID = #attributes.ship_id# AND IS_TYPE = #attributes.is_type# AND RECORD_EMP = #session.ep.userid#
</cfquery>
<cfset spollist = ValueList(get_spool.STOCK_ID)>
<cfif attributes.is_type eq 1>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
         	ISNULL((
            SELECT        
            	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
			FROM            
             	#dsn2_alias#.STOCK_FIS AS SF INNER JOIN
            	#dsn2_alias#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
			WHERE        
              	SF.FIS_TYPE = 113 AND 
              	SF.REF_NO = '#attributes.DELIVER_PAPER_NO#' AND 
            	SFR.STOCK_ID = TBL.PAKET_ID
        	),0) AS CONTROL_AMOUNT
            <cfif get_shelf.recordcount>
            	,SHELF_CODE
            </cfif>
		FROM         
        	(
            SELECT
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID
                <cfif get_shelf.recordcount>
                	, 
                    	(
                    	SELECT        
                        	TOP (1) PP.SHELF_CODE
						FROM            
                        	PRODUCT_PLACE AS PP INNER JOIN
                         	PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID LEFT OUTER JOIN
                         	#dsn2_alias#.GET_STOCK_LAST_SHELF AS GS ON PPR.STOCK_ID = GS.STOCK_ID AND PPR.PRODUCT_PLACE_ID = GS.SHELF_NUMBER
						WHERE 
                        	GS.REAL_STOCK > 0 AND 
                            PPR.STOCK_ID = TBL1.PAKET_ID AND  
                            PP.PLACE_STATUS = 1 AND     
                        	PP.STORE_ID = #ListGetAt(attributes.department_out_id,1,'-')# AND 
                            PP.LOCATION_ID = #ListGetAt(attributes.department_out_id,2,'-')#  
						ORDER BY 
                        	PP.SHELF_CODE
                    	) AS SHELF_CODE
                </cfif>
           	FROM
            	(     
                SELECT     
                    CASE 
                        WHEN 
                            S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                        THEN 
                            S.PRODUCT_TREE_AMOUNT 
                        ELSE 
                            SUM(ORR.QUANTITY * EPS.PAKET_SAYISI) 
                    END 
                        AS PAKET_SAYISI, 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID
                FROM          
                    PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                    PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                WHERE      
                    ESR.SHIP_RESULT_ID = #attributes.ship_id#
                GROUP BY 
                    EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID
             	) AS TBL1
          	GROUP BY
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 



                SHIP_RESULT_ID
        	) AS TBL
       	ORDER BY
     		<cfif get_shelf.recordcount>
            	SHELF_CODE,
                STOCK_CODE
            <cfelse>
            	STOCK_CODE
            </cfif>
  	</cfquery>
<cfelse>
   	<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT     
        	PAKET_SAYISI AS PAKETSAYISI, 
            PAKET_ID AS STOCK_ID, 
            BARCOD, 
            STOCK_CODE, 
            PRODUCT_NAME,
            ISNULL((
            SELECT        
            	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
			FROM            
             	#dsn2_alias#.STOCK_FIS AS SF INNER JOIN
            	#dsn2_alias#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
			WHERE        
              	SF.FIS_TYPE = 113 AND 
              	SF.REF_NO = '#attributes.DELIVER_PAPER_NO#' AND 
            	SFR.STOCK_ID = TBL.PAKET_ID
          	),0) AS CONTROL_AMOUNT, 
            SHIP_RESULT_ID
            <cfif get_shelf.recordcount>
            	,SHELF_CODE
            </cfif>
		FROM         
        	(
            SELECT     
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI, 
                PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID
                <cfif get_shelf.recordcount>
                	, 
                    	(
                    	SELECT        
                        	TOP (1) PP.SHELF_CODE
						FROM            
                        	PRODUCT_PLACE AS PP INNER JOIN
                         	PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID LEFT OUTER JOIN
                         	#dsn2_alias#.GET_STOCK_LAST_SHELF AS GS ON PPR.STOCK_ID = GS.STOCK_ID AND PPR.PRODUCT_PLACE_ID = GS.SHELF_NUMBER
						WHERE 
                        	GS.REAL_STOCK > 0 AND 
                            PPR.STOCK_ID = TBL1.PAKET_ID AND  
                            PP.PLACE_STATUS = 1 AND     
                        	PP.STORE_ID = #ListGetAt(attributes.department_out_id,1,'-')# AND 
                            PP.LOCATION_ID = #ListGetAt(attributes.department_out_id,2,'-')#  
						ORDER BY 
                        	PP.SHELF_CODE
                    	) AS SHELF_CODE
                </cfif>
       		FROM          
            	(
                SELECT     
                	CASE 
                    	WHEN 
                        	S.PRODUCT_TREE_AMOUNT IS NOT NULL 
                      	THEN 
                        	S.PRODUCT_TREE_AMOUNT 
                      	ELSE 
                        	SUM(SIR.AMOUNT * EPS.PAKET_SAYISI) 
              		END 
                    	AS PAKET_SAYISI, 
                 	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID AS SHIP_RESULT_ID
         		FROM          
                	STOCKS AS S INNER JOIN
                    PRTOTM_PAKET_SAYISI AS EPS ON S.STOCK_ID = EPS.PAKET_ID INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL_ROW AS SIR INNER JOIN
                    #dsn2_alias#.SHIP_INTERNAL AS SI ON SIR.DISPATCH_SHIP_ID = SI.DISPATCH_SHIP_ID ON EPS.MODUL_ID = SIR.STOCK_ID
           		WHERE      
                	SI.DISPATCH_SHIP_ID = #attributes.ship_id#
             	GROUP BY 
                	EPS.PAKET_ID, 
                    S.BARCOD, 
                    S.STOCK_CODE, 
                    S.PRODUCT_NAME, 
                    S.PRODUCT_TREE_AMOUNT, 
                    SIR.SHIP_ROW_ID, 
                    SI.DISPATCH_SHIP_ID
           		) AS TBL1
         	GROUP BY 
            	PAKET_ID, 
                BARCOD, 
                STOCK_CODE, 
                PRODUCT_NAME, 
                PRODUCT_TREE_AMOUNT, 
                SHIP_RESULT_ID
       		) AS TBL
     	ORDER BY
     		<cfif get_shelf.recordcount>

            	SHELF_CODE,
                STOCK_CODE
            <cfelse>
            	STOCK_CODE
            </cfif>
    </cfquery>
</cfif> 
<style>
table,td,th,div{
    font-size:13px;
		font-weight: 600;
}
.form-title{
    font-size:13px;
}
</style>
<cfset adres = "epda.emptypopup_prtotm_ambar_sevk&date1=#date1#&date2=#date2#&department_in_id=#attributes.department_in_id#&department_out_id=#attributes.department_out_id#&keyword=#attributes.keyword#&is_form_submitted=1">
<div style="width:100%">
	<table cellpadding="2" cellspacing="1" align="left" class="color-border" width="100%">
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
            	<td colspan="5">
            		<table width="99%" height="29" cellpadding="0" cellspacing="0">
                		<tr>
                    		<td> <cfif attributes.is_type eq 1><b>Sevk Plan No :</b><cfelse><b>Sevk Talep No :</b></cfif><cfoutput>#attributes.DELIVER_PAPER_NO#</cfoutput></b></td>
                    		<td><input type="submit" value="Geri" name="1"></td>
                		</tr>
            		</table>
            	</td>
        	</tr>
        	<tr class="color-list" height="20">
				<cfif get_shelf.recordcount>
                    <td width="45"> Raf Kodu</td>
                <cfelse>
                	<td width="50">Barkod</td>
                </cfif>
            	<td>Stok Adı</td>
            	<td width="30">Miktar</td>
            	<td width="15">OK</td>     
            	<td width="15"><input type="checkbox" alt="<cf_get_lang no ='546.Hepsini Seç'>" onClick="grupla(-1);"></td>                              
        	</tr>
        	<cfoutput query="GET_SHIP_PACKAGE_LIST">
           	 	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                	<td>
						<cfif get_shelf.recordcount>	
                            #SHELF_CODE#	
                        <cfelse>     
                            #BARCOD#
                        </cfif>
                    </td>
                    <td >
                        <cfif (get_shelf.recordcount and len(SHELF_CODE)) or (not get_shelf.recordcount and len(BARCOD))>
                            <a href="#request.self#?fuseaction=epda.form_prtotm_shipping_ambar_stock&ship_id=#attributes.ship_id#&f_stock_id=#stock_id#&department_in_id=#attributes.department_in_id#&department_out_id=#attributes.department_out_id#&date1=#attributes.date1#&date2=#attributes.date2#&product_name=#PRODUCT_NAME#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#&keyword=#attributes.keyword#&paket_sayisi=#PAKETSAYISI#" class="tableyazi">
                                #PRODUCT_NAME#
                            </a>
                    	<cfelse>
                    		#PRODUCT_NAME#
                    	</cfif>
               	 	</td>
                	<td style="text-align:right;color:FF0000;">#PAKETSAYISI#</td>
                	<td align="center">
						<cfif PAKETSAYISI eq 0>
                        	<img src="/images/plus_ques.gif" border="0" title="Barkod Yok.">
                    	<cfelseif PAKETSAYISI - CONTROL_AMOUNT eq 0>
                      		<a href="#request.self#?fuseaction=epda.prtotm_print_spool&ship_id=#attributes.ship_id#&stock_id_list=#stock_id#&department_in_id=#attributes.department_in_id#&department_out_id=#attributes.department_out_id#&date1=#attributes.date1#&date2=#attributes.date2#&product_name=#PRODUCT_NAME#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#&keyword=#attributes.keyword#&paket_sayisi=#PAKETSAYISI#">
                                <img src="/images/c_ok.gif" border="0" title="Sevk Edildi">
                            </a>
                        <cfelseif CONTROL_AMOUNT eq 0>
                            <img src="/images/caution_small.gif" border="0" title="Sevk Edilmedi">
                        <cfelseif PAKETSAYISI gt CONTROL_AMOUNT>
                            <img src="/images/warning.gif" border="0" title="Eksik Sevkiyat">
                        <cfelseif PAKETSAYISI lt CONTROL_AMOUNT>
                            <img src="/images/control.gif" border="0" title="Fazla Sevkiyat">   
                        </cfif>
                	</td> 
                	<td align="center">
                		<input type="checkbox" name="select_production" value="#STOCK_ID#_#CONTROL_AMOUNT#" <cfif ListFind(spollist,STOCK_ID)>checked</cfif>>
                	</td>      
            	</tr>
        	</cfoutput>
        	<tr class="color-list" height="20">
        		<td colspan="5" height="20px" align="right"><input type="button" value="Yazıcı Havuzuna Gönder" name="print_button" onclick="grupla(-2);" /></td>
        	</tr>
    	</form>
	</table>
</div>
<script language="javascript">
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		stock_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_production;
			if(type == -1){//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					stock_id_list +=my_objets.value+',';
			}
		}
		stock_id_list = stock_id_list.substr(0,stock_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(list_len(stock_id_list,','))
		{

			var answer1 = confirm("Seçtiğiniz Satırları Yazıcı Havuzuna Gönderiyorsunuz")
			if (answer1)
			{
			window.location ='<cfoutput>#request.self#?fuseaction=epda.prtotm_print_spool&ship_id=#attributes.ship_id#&department_in_id=#attributes.department_in_id#&department_out_id=#attributes.department_out_id#&date1=#attributes.date1#&date2=#attributes.date2#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.DELIVER_PAPER_NO#&keyword=#attributes.keyword#</cfoutput>&stock_id_list='+stock_id_list;
			}
		}
	}
</script>