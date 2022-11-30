<cfsetting showdebugoutput="no">
<cfparam name="attributes.DELIVER_PAPER_NO" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.delivered" default="">
<cfparam name="attributes.store" default="">
<cfparam name="attributes.location" default="">
<cfparam name="attributes.kontrol_status" default="2">
<cfparam name="attributes.keyword" default="">
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_RF_TO_SV_DEP, 
        DEFAULT_RF_TO_SV_LOC
	FROM            
    	PRTOTM_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset default_departments = '#get_default_departments.DEFAULT_RF_TO_SV_DEP#'> 
<cfparam name="attributes.department_id" default="#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_RF_TO_SV_LOC,2)#">
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
  <cf_date tarih="attributes.date2">
  <cfelse>
  <cfset attributes.date2 = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
  <cf_date tarih="attributes.date1">
  <cfelse>
  <cfset attributes.date1 = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
  <cfinclude template="../query/get_shipping_list_control.cfm">
  <cfelse>
  <cfset get_sevk_fis.recordcount = 0>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.DEPARTMENT_ID IN (#default_departments#) AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		SL.STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=20>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_sevk_fis.recordcount#'>
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
<div style="width:100%">
	<cfform name="frm_search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.prtotm_svk_kontrol">
  		<input type="hidden" name="is_form_submitted" value="1">
        <input type="hidden" name="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
    	<input type="hidden" name="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
  		<table width="100%" >
            <tr >
  <td colspan="4" style="background-color: #E6E6E6;">
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_welcome</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/Home.png"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.emptypopup_prtotm_ambar_sevk</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/up30.png" title="Ambardan Malkabule"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_mal_ambar</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/down30.png" title="MalKabulden Ambara"></a>&nbsp;&nbsp;
  <a href="<cfoutput>#request.self#?fuseaction=epda.prtotm_svk_kontrol</cfoutput>"><img style="width:30px;height:30px" src="../../images/e-pd/tickmav30.png" title="Sevkiyat Kontrol"></a>&nbsp;&nbsp;
  </td>
  </tr>
    		<tr>
      			<td colspan="4" class="headbold" height="20"><b>Sevkiyat Listesi</b></td>
    		</tr>
    		<tr height="20px">
            	<td align="85px">
        			<input type="text" name="keyword" style="width:100%" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
        		</td>
                <td width="40px">Tarih</td>
      			<td>
                    <cfsavecontent variable="message">Tarih girmelisiniz</cfsavecontent>
                    <cfinput type="text" maxlength="10" name="date1" value="#dateformat(attributes.date1,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:100%;">
  				</td>
      			<td>
                    <cfsavecontent variable="message">Tarih girmelisiniz</cfsavecontent>
                    <cfinput type="text" maxlength="10" name="date2" value="#dateformat(attributes.date2,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:100%;">
        		</td>
    		</tr>
            <tr class="color-header" height="15px">
                <td colspan="4" class="form-title" width="97%">Sevkiyat Kontrol Deposu</td>
            </tr>
    		<tr height="20px">
      			<td colspan="4">
        			<select name="department_id" style="width:280px; height:20px">
          				<option value="">Tüm Depolar</option>
         	 			<cfoutput query="get_all_location" group="department_id">
            				<option value="#department_id#">#department_head#</option>
							<cfoutput>
                    			<option value="#department_id#-#location_id#" <cfif department_id is #ListFirst(attributes.department_id,'-')# and location_id is #ListLast(attributes.department_id,'-')#>selected="selected"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#</option>
                    		</cfoutput> 
						</cfoutput>
        			</select>
    			</td>
  			</tr>
  			<tr height="20px">
    			<td colspan="3">
        			<input type="radio" name="kontrol_status" value="1" <cfif attributes.kontrol_status eq 1>checked</cfif>>Satır Bazında
            		<input type="radio" name="kontrol_status" value="2" <cfif attributes.kontrol_status eq 2>checked</cfif>>Belge Bazında
            		&nbsp;
              	</td>
                <td style="text-align:right">
        			<input type="submit" style="width:50px; text-align:right" value="Ara" />
        		</td>
    		</tr>  
		</table>
	</cfform>
	<table width="100%">
  		<tr class="color-header" height="20">
    		<td style="width:60px;" class="form-title">No</td>
    		<td class="form-title">Cari</td>
    		<td width="16" class="form-title">&nbsp;</td>
  		</tr>
  		<cfif get_sevk_fis.recordcount>
    		<cfoutput query="get_sevk_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
      			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
        			<td>
            			<cfquery name="PACKEGE_CONTROL_STATUS" datasource="#DSN3#">
                			<cfif IS_TYPE eq 1>
                                SELECT     
                                    CONTROL_STATUS
                                FROM         
                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                WHERE     
                                    TYPE = 1 AND 
                                    SHIPPING_ID = #get_sevk_fis.SHIP_RESULT_ID#
                            <cfelseif IS_TYPE eq 2>
                                SELECT     
                                    CONTROL_STATUS
                                FROM         
                                    PRTOTM_SHIPPING_PACKAGE_LIST
                                WHERE     
                                    TYPE = 2 AND 
                                    SHIPPING_ID = #get_sevk_fis.SHIP_RESULT_ID#
                            </cfif>
                        </cfquery>
         				<cfif PACKEGE_CONTROL_STATUS.recordcount> 
           					<cfif PACKEGE_CONTROL_STATUS.CONTROL_STATUS eq 1>
                				<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.prtotm_shipping_control_fis&department_id=#attributes.department_id#&ship_id=">
             				<cfelse>
                				<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.prtotm_shipping_control&department_id=#attributes.department_id#&ship_id=">
            				</cfif>
        				<cfelse>
            				<cfif attributes.kontrol_status eq 1>
                				<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.prtotm_shipping_control_fis&department_id=#attributes.department_id#&ship_id=">
             				<cfelse>
                				<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.prtotm_shipping_control&department_id=#attributes.department_id#&ship_id=">
           					</cfif>
       					</cfif>
            			<a href="#url_param##SHIP_RESULT_ID#&DELIVER_PAPER_NO=#DELIVER_PAPER_NO#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#&page=#attributes.page#&kontrol_status=#attributes.kontrol_status#&is_type=#IS_TYPE#"class="tableyazi">
                			#DELIVER_PAPER_NO#
            			</a>
      				</td>
        			<td>
						<cfif IS_TYPE eq 1> 
                            #unvan#
                        <cfelse>
                            #DEPARTMENT_HEAD#
                        </cfif>      
                    </td>
					<cfif IS_TYPE eq 1>    
                        <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#">
                            SELECT     
                                ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                            FROM         
                                (
                                SELECT     
                                    PAKET_SAYISI AS PAKETSAYISI, 
                                    PAKET_ID AS STOCK_ID, 
                                    BARCOD, 
                                    STOCK_CODE, 
                                    PRODUCT_NAME,
                                    (
                                    SELECT     
                                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                    FROM          
                                        PRTOTM_SHIPPING_PACKAGE_LIST
                                    WHERE      
                                        TYPE = 1 AND 
                                        STOCK_ID = TBL.PAKET_ID AND 
                                        SHIPPING_ID = TBL.SHIP_RESULT_ID
                                    ) AS CONTROL_AMOUNT
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
                                            ESR.SHIP_RESULT_ID = #SHIP_RESULT_ID#
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
                                ) AS TBL2
                        </cfquery>
                    <cfelse>
                        <cfquery name="PACKEGE_CONTROL" datasource="#DSN3#">
                            SELECT     
                                ISNULL(SUM(PAKETSAYISI), 0) AS PAKET_SAYISI, 
                                ISNULL(SUM(CONTROL_AMOUNT), 0) AS CONTROL_AMOUNT
                            FROM         
                                (		
                                SELECT     
                                    PAKET_SAYISI AS PAKETSAYISI, 
                                    PAKET_ID AS STOCK_ID, 
                                    BARCOD, 
                                    STOCK_CODE, 
                                    PRODUCT_NAME,
                                    (
                                    SELECT     
                                        SUM(CONTROL_AMOUNT) AS CONTROL_AMOUNT
                                    FROM          
                                        PRTOTM_SHIPPING_PACKAGE_LIST
                                    WHERE      
                                        TYPE = 2 AND 
                                        STOCK_ID = TBL.PAKET_ID AND 
                                        SHIPPING_ID = TBL.SHIP_RESULT_ID
                                    ) AS CONTROL_AMOUNT, SHIP_RESULT_ID
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
                                            SI.DISPATCH_SHIP_ID = #SHIP_RESULT_ID#
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
                                ) AS TBL2
                        </cfquery>
                    </cfif> 
	  				<td align="center">
						 <cfif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI eq 0 and PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                            <img src="/images/plus_ques.gif" border="0" title="Barkod Yok.">
                         <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI - PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                            <img src="/images/c_ok.gif" border="0" title="Kontrol Edildi.">
                         <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.CONTROL_AMOUNT eq 0>
                            <img src="/images/caution_small.gif" border="0" title="Kontrol Edilmedi.">
                         <cfelseif PACKEGE_CONTROL.recordcount AND PACKEGE_CONTROL.PAKET_SAYISI gt PACKEGE_CONTROL.CONTROL_AMOUNT>
                            <img src="/images/warning.gif" border="0" title="Kontrol Eksik.">   
                         </cfif>
               		</td>
      			</tr>
    		</cfoutput>
    	<cfelse>
        	<tr class="color-row">
            	<td colspan="3" height="20">
					<cfif not isdefined("attributes.is_form_submitted")>
                        Filtre Ediniz
                    <cfelse>
                        Kayıt Yok
                    </cfif>
            		!
         		</td>
     		</tr>
  		</cfif>
	</table>
	<cfif attributes.totalrecords gt attributes.maxrows>
  		<table cellpadding="0" cellspacing="0" border="0" align="center" height="20">
    		<tr align="left">
      			<td width="60" nowrap="nowrap">
	  				<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_shipping&consumer_id=#attributes.consumer_id#&company_id=#attributes.company_id#&company=#attributes.company#">
					<cfif isDefined('attributes.cat') and len(attributes.cat)>
              			<cfset adres = adres & "&cat=" & attributes.cat>
            		</cfif>
					<cfif isdefined("attributes.DELIVER_PAPER_NO") and len(attributes.DELIVER_PAPER_NO)>
                      <cfset adres = adres & "&DELIVER_PAPER_NO=" & attributes.DELIVER_PAPER_NO>
                    </cfif>
                    <cfif isDefined('attributes.department_id') and len(attributes.department_id)>
                      <cfset adres = adres & '&department_id=' & attributes.department_id>
                    </cfif>
                    <cfif isdate(attributes.date1)>
                      <cfset adres = "#adres#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">
                    </cfif>
                    <cfif isdate(attributes.date2)>
                      <cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
                    </cfif>
                    <cfif isdefined("attributes.deliver_emp") and len(attributes.deliver_emp)>
                      <cfset adres = "#adres#&deliver_emp=#attributes.deliver_emp#">
                      <cfset adres = "#adres#&deliver_emp_id=#attributes.deliver_emp_id#">
                    </cfif>
                    <cfif isDefined('attributes.delivered') and len(attributes.delivered) >
                      <cfset adres = "#adres#&delivered=#attributes.delivered#" >
                    </cfif>
                    <cfif isDefined('attributes.kontrol_status') and len(attributes.kontrol_status) >
                      <cfset adres = "#adres#&kontrol_status=#attributes.kontrol_status#" >
                    </cfif>
                    <cfif isDefined('attributes.keyword') and len(attributes.keyword) >
                      <cfset adres = "#adres#&keyword=#attributes.keyword#" >
                    </cfif>
            		<cf_pages page="#attributes.page#" 
						  maxrows="#attributes.maxrows#" 
						  totalrecords="#attributes.totalrecords#" 
						  startrow="#attributes.startrow#" 
						  adres="#adres#&is_form_submitted=1">
      			</td>
      			<td>
					<cfoutput>
                        <cf_get_lang_main no='80.toplam'> : #attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.sayfa'> : #attributes.page#/#lastpage#
                    </cfoutput>
   				</td>
    		</tr>
  		</table>
	</cfif>
</div>
<script language="javascript">
	document.getElementById('keyword').focus();
</script>