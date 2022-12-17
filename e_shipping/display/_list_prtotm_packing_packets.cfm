<cfsetting showdebugoutput="yes">
<cfparam name="attributes.deliver_paper_no" default="">
<cfparam name="attributes.ship_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_form_submitted" default="1">
<cfif isdefined("attributes.is_form_submitted")>
  	<cfquery name="get_pack_fis1" datasource="#dsn3#">
    	SELECT     
        	EP.PACKING_NO, 
            EP.PACKING_ID,
            EP.TYPE,
            EPR.LOT_NO, 
            EPR.AMOUNT, 
            EPR.STOCK_ID, 
            EPR.SPECT_MAIN_ID, 
            EP.RECORD_EMP, 
            EP.RECORD_DATE, 
            EP.SHIP_RESULT_ID
		FROM         
        	PRTOTM_PACKING AS EP INNER JOIN
         	PRTOTM_PACKING_ROW AS EPR ON EP.PACKING_ID = EPR.PACKING_ID
		
        WHERE
        	1=1
        	<cfif isdefined('attributes.ship_id') and len(attributes.ship_id)>
                AND EP.SHIP_RESULT_ID = #attributes.ship_id# 
                AND EP.TYPE = #attributes.type#
       		</cfif>   
        	<cfif len(attributes.keyword)>    
                AND EP.PACKING_NO = '#attributes.keyword#'
      		</cfif>
    </cfquery>
    <cfif get_pack_fis1.recordcount>
    	<cfquery name="get_pack_fis" dbtype="query">
            SELECT     
                PACKING_NO,
                PACKING_ID, 
                RECORD_EMP, 
                SHIP_RESULT_ID, 
                TYPE, 
                RECORD_DATE,
                COUNT(*) AS SAYI,
                SUM(AMOUNT) AS AMOUNT
            FROM
                get_pack_fis1
            GROUP BY 
                PACKING_NO, 
                PACKING_ID,
                RECORD_EMP, 
                SHIP_RESULT_ID, 
                TYPE, 
                RECORD_DATE
            ORDER BY 
                PACKING_NO DESC
        </cfquery>
    	<cfset stock_id_list = ValueList(get_pack_fis1.STOCK_ID)>
    	<cfquery name="get_stocks" datasource="#dsn3#">
            SELECT     
                STOCK_CODE, 
                PRODUCT_NAME, 
                PROPERTY, 
                STOCK_ID
            FROM         
                STOCKS AS S
            WHERE     
                STOCK_ID IN (#stock_id_list#)
    	</cfquery>
        <cfoutput query="get_stocks">
        	<cfset 'PRODUCT_NAME_#STOCK_ID#' = '#PRODUCT_NAME# #PROPERTY#'>
            <cfset 'STOCK_CODE_#STOCK_ID#' =  STOCK_CODE>
        </cfoutput>
	<cfelse>
    	<cfset get_pack_fis.recordcount = 0>
    </cfif>
<cfelse>
  	<cfset get_pack_fis.recordcount = 0>
</cfif>

<cfform name="frm_search" method="post" action="#request.self#?fuseaction=sales.popup_list_PRTOTM_packing_packets">
  <cfinput type="hidden" name="deliver_paper_no" value="#attributes.deliver_paper_no#">
  <cfinput type="hidden" name="ship_id" value="#attributes.ship_id#">
  <cfinput type="hidden" name="type" value="#attributes.type#">
  <input type="hidden" name="is_form_submitted" value="1">
  <cf_big_list_search title="Sevkiyat Paketleme" collapsed="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td></td>
                    <td>
                    	<a href="<cfoutput>#request.self#?fuseaction=sales.popup_add_PRTOTM_packing_fis&ship_id=#attributes.ship_id#&deliver_paper_no=#attributes.deliver_paper_no#&type=#attributes.type#</cfoutput>"><img src="/images/kasa.gif" border="0" title="Paket Ekle"></a>
                    </td>
                    <td><input type="text" name="keyword" style="width:120px" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>"></td>
                    <td><cf_wrk_search_button search_function='input_control()'><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
               	</tr>
           	</table>
     	</cf_big_list_search_area>
    </cf_big_list_search>
 	<cf_big_list id="list_product_big_list">
        <thead>
          	<tr height="20">
  				<th style="width:15px; text-align:center" class="form-title"></th>
                <th style="width:90px" >Paket No</th>
                <th style="width:90px">Tarih</th>
                <th style="width:190px">Hazırlayan</th>
                <th style="width:110px;">Paket İçi Miktar</th>
                <th>Açıklama</th>
                <th style="width:20px; text-align:center">CNT</th>
                <th style="width:20px; text-align:center">PRT</th>
  			</tr>
        </thead>
       	<tbody>
		  	<cfif get_pack_fis.recordcount>
				<cfoutput query="get_pack_fis">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td align="center">#currentrow#</td>
                    <td align="center">#PACKING_NO#</td> 
                    <td align="center">#Dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
                    <td align="center">#get_emp_info(RECORD_EMP,0,0)#</td> 
                    <td align="right">#AMOUNT# Ad.</td>
                    <td align="right"></td>
                    <td align="center"></td>
                    <td align="center">
                    	<a href="javascript://" onClick="sil(#PACKING_ID#);"><img src="/images/delete_list.gif" align="absmiddle" border="0" title="Sil"></a>
                    </td>
                  </tr>
                </cfoutput>
            <cfelse>
                <tr class="color-row">
                    <td colspan="6" height="20">
                        <cfif not isdefined("attributes.is_form_submitted")>
                            Filtre Ediniz
                        <cfelse>
                            Kayıt Yok
                        </cfif>
                        !
                    </td>
                </tr>
  			</cfif>
		</tbody>
  	</cf_big_list>
</cfform>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<script language="javascript">
	document.getElementById('keyword').focus();
	function sil(packing_id)
	{	
		window.location ='<cfoutput>#request.self#?fuseaction=sales.emptypopup_del_PRTOTM_packing_fis&ship_id=#attributes.ship_id#&deliver_paper_no=#attributes.deliver_paper_no#&type=#attributes.type#</cfoutput>&packing_id='+packing_id;
	}
</script>