<cfsetting showdebugoutput="yes">
<cfparam name="attributes.DELIVER_PAPER_NO" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.department_id" default="21-4"> <!---Dikkat Firmaya Göre Değişir--->
<cfparam name="attributes.delivered" default="">
<cfparam name="attributes.store" default="">
<cfparam name="attributes.location" default="">
<cfparam name="attributes.kontrol_status" default="2">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="#DateFormat(DateAdd('d',-1,now()),'DD/MM/YYYY')#">
<!---<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
  <cf_date tarih="attributes.date2">
  <cfelse>
  <cfset attributes.date2 = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
  <cf_date tarih="attributes.date1">
  <cfelse>
  <cfset attributes.date1 = DateAdd('d',-1,wrk_get_today())>
</cfif>--->

<cfquery name="get_ship_method" datasource="#dsn#">
	SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD
</cfquery>
<cfoutput query="get_ship_method">
	<cfset 'SHIP_METHOD_#SHIP_METHOD_ID#' = SHIP_METHOD>
</cfoutput>
<cfif isdefined("attributes.is_form_submitted")>
  <cfquery name="GET_SEVK_FIS1" datasource="#DSN2#">
  	SELECT     
    	DISPATCH_SHIP_ID, 
        COLLECT_ID, 
        DEPARTMENT_OUT, 
        SHIP_METHOD, 
        DEPARTMENT_IN
	FROM         
    	PRTOTM_SHIP_INTERNAL_COLLECT
	WHERE     
        SUBSTRING(COLLECT_ID,7,2)+'/'+SUBSTRING(COLLECT_ID,5,2)+'/'+left(COLLECT_ID,4) = '#attributes.date1#' AND
        DEPARTMENT_IN IN 
                							(
                								SELECT     
                                                	DEPARTMENT_ID
												FROM         
                                                	#dsn_alias#.DEPARTMENT
												WHERE     
                                                	BRANCH_ID IN
                          										(
                                                                	SELECT     
                                                                    	BRANCH_ID
                            										FROM          
                                                                    	#dsn_alias#.EMPLOYEE_POSITION_BRANCHES
                            										WHERE      
                                                                    	POSITION_CODE IN
                                                       									(
                                                                                        	SELECT     
                                                                                            	POSITION_CODE
                                                         									FROM          
                                                                                            	#dsn_alias#.EMPLOYEE_POSITIONS
                                                        									 WHERE      
                                                                                             	EMPLOYEE_ID = #session.pda.userid# AND 
                                                                                                POSITION_STATUS = 1 AND 
                                                                                                IS_MASTER = 1
                                                                                       	)
                                                              	)
                                          	)  
  	</cfquery>
    <!---<cfdump var="#GET_SEVK_FIS1#">--->
    <cfquery name="get_sevk_fis" dbtype="query">
    	SELECT
        	COLLECT_ID,
            DEPARTMENT_OUT, 
            SHIP_METHOD, 
            DEPARTMENT_IN
       	FROM
        	get_sevk_fis1
       	GROUP BY
        	COLLECT_ID,
            DEPARTMENT_OUT, 
            SHIP_METHOD, 
            DEPARTMENT_IN
    </cfquery>
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
		D.IS_STORE IN (1,3) AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
        SL.STATUS = 1 AND
        B.COMPANY_ID = #right(dsn3,1)#
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=20>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_sevk_fis.recordcount#'>
<cfform name="frm_search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_shipping_collect_store">
  <input type="hidden" name="is_form_submitted" value="1">
  <table width="159">
    <tr>
      <td colspan="2" class="headbold" height="20"><b>Mağaza Sevkiyat Listesi</b></td>
    </tr>
    <input type="hidden" name="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
    <input type="hidden" name="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
    <tr>
    	<td>
        	<input type="text" name="keyword" style="width:60px" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>"
        </td>
      	<td>
      		<cfsavecontent variable="message">
        		<cf_get_lang no='119.Tarih girmelisiniz'>
        	</cfsavecontent>
        	<cfinput type="text" maxlength="10" name="date1" value="#attributes.date1#" validate="eurodate" message="#message#" style="width:55px;">
            <cf_wrk_date_image date_field="date1">
  		</td>
      	<td>
        	<!---<cfsavecontent variable="message">
        		<cf_get_lang no='119.Tarih girmelisiniz'>
        	</cfsavecontent>
        	<cfinput type="text" maxlength="10" name="date2" value="#dateformat(attributes.date2,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:55px;">--->
        
        </td>
    </tr>
    <tr>
      	<td colspan="3">
        	<select name="department_id" style="width:150px">
          		<option value="">
          			Tüm Depolar
          		</option>
         	 	<cfoutput query="get_all_location" group="department_id">
            		<option value="#department_id#">#department_head#</option>
					<cfoutput>
                    <option value="#department_id#-#location_id#" <cfif department_id is #ListFirst(attributes.department_id,'-')# and location_id is #ListLast(attributes.department_id,'-')#>selected="selected"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#</option>
                    </cfoutput> 
				</cfoutput>
        	</select>
            &nbsp;
            <input type="submit" value="Ara" />
    	</td>
  	</tr>

</table>
</cfform>
<table style="width:215px;">
  <tr class="color-header" height="20">
    <td style="width:60px;" class="form-title">No</td>
    <td class="form-title">Sevk Yöntemi</td>
    <td width="16" class="form-title">&nbsp;</td>
  </tr>
  
  <cfif get_sevk_fis.recordcount>
    <cfoutput query="get_sevk_fis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
      <cfquery name="GET_SEVK_GROUP" dbtype="query">
    	SELECT
        	DISPATCH_SHIP_ID
       	FROM
        	get_sevk_fis1
        WHERE
        	COLLECT_ID = '#get_sevk_fis.COLLECT_ID#'
      </cfquery>
      <cfset tarih = '#mid(get_sevk_fis.COLLECT_ID,7,2)#/#mid(get_sevk_fis.COLLECT_ID,5,2)#/#Left(get_sevk_fis.COLLECT_ID,4)#'>
      <cfset SHIP_METHOD_ID = get_sevk_fis.SHIP_METHOD>
  	  <cfset dispatch_id_list = Valuelist(GET_SEVK_GROUP.DISPATCH_SHIP_ID)>
      <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
        <td>
           	<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_shipping_control_collect_store&ship_collect_id=">
            <a href="#url_param##COLLECT_ID#"class="tableyazi">#tarih#</a>
      	</td>
      	<td><cfif isdefined('SHIP_METHOD_#SHIP_METHOD_ID#')>#Evaluate('SHIP_METHOD_#SHIP_METHOD_ID#')#</cfif></td>
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
                            PRTOTM_SHIPPING_PACKAGE_LIST_STORE
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
                                        round(SUM(SIR.AMOUNT * EPS.PAKET_SAYISI) ,0)
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
                                SI.DISPATCH_SHIP_ID IN (#dispatch_id_list#)
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
  <table width="159" cellpadding="0" cellspacing="0" border="0" align="center" height="20">
    <tr align="left">
      <td width="60" nowrap="nowrap">
	  		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_shipping_collect_store&consumer_id=#attributes.consumer_id#&company_id=#attributes.company_id#&company=#attributes.company#">
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
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<script language="javascript">
	document.getElementById('keyword').focus();
</script>