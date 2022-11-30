 <cfsetting showdebugoutput="yes">
<cfquery name="get_default_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID, LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.POSITION_CODE# AND OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfif get_default_department.recordcount>
	<cfparam name="attributes.sales_departments" default="#get_default_department.DEPARTMENT_ID#-#get_default_department.LOCATION_ID#">
<cfelse>
	<cfparam name="attributes.sales_departments" default="">
    <script type="text/javascript">
     	alert("Kullanıcı İçin Default Depo Tanımlayınız!");
     	history.go(-1);
  	</script>
 	<cfabort>
</cfif>
<cfquery name="get_period_id" datasource="#dsn#">
    	SELECT        
        	PERIOD_YEAR
		FROM            
        	SETUP_PERIOD
		WHERE        
        	OUR_COMPANY_ID = #session.ep.company_id# AND 
            PERIOD_YEAR < #session.ep.period_year#
</cfquery>
<cfset last_year = session.ep.period_year -1>
<cfset lnk_str = ''><cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = DateAdd('d',-20,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>

<cfquery name="get_stocks" datasource="#dsn2#"><!---Mal Kabul Deposundaki Ürünler Listeleniyor--->
     SELECT       
     	GS.REAL_STOCK, 
        S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.PRODUCT_CODE_2, 
        S.PRODUCT_BARCOD, 
        PC.PRODUCT_CAT, 
        PU.MAIN_UNIT
	FROM            
    	GET_STOCK_LAST_LOCATION AS GS INNER JOIN
       	#dsn3_alias#.STOCKS AS S ON GS.STOCK_ID = S.STOCK_ID INNER JOIN
      	#dsn1_alias#.PRODUCT_CAT AS PC ON S.PRODUCT_CATID = PC.PRODUCT_CATID INNER JOIN
       	#dsn1_alias#.PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
	WHERE        
    	GS.DEPARTMENT_ID = 6 AND 
        GS.LOCATION_ID = 0 AND 
        PU.IS_MAIN = 1    
</cfquery>
<cfform name="form_portal" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  		<tr class="color-border">
        	<td>
            	<table cellspacing="1" cellpadding="2" width="100%" border="0">
                    <tr class="color-header" style="height:35px">
                        <td class="form-title" style="width:30px;text-align:center"><cf_get_lang_main no='1165.Sira'></td>
                        <td class="form-title" style="width:160px;text-align:center"> Kategori </td>
                        <td class="form-title" style="width:95px;text-align:center"> Özel Kodu </td>
                        <td class="form-title" style="width:95px;text-align:center"> Barkod </td>
                        <td class="form-title" style="width:115px;text-align:center"> Stok Kodu </td>
                        <td class="form-title" style="text-align:center"> Ürün Adı </td>
                        <td class="form-title" style="width:100px;text-align:center">Miktar</td>
                        <td class="form-title" style="width:60px;text-align:center"> Birim </td>
                	</tr>
        			<cfif get_stocks.recordcount>
                        <cfoutput query="get_stocks">
                       		<tr style="height:30px" class="color-row">
                           		<td style="text-align:right">#currentrow#</td>
                              	<td style="text-align:left">#PRODUCT_CAT#</td>
                            	<td style="text-align:center">#PRODUCT_CODE_2#</td>
                            	<td style="text-align:center">#PRODUCT_BARCOD#</td>
                             	<td style="text-align:left">#PRODUCT_CODE#</td>
                             	<td style="text-align:left">#PRODUCT_NAME#</td>
                             	<td style="text-align:right">#TlFormat(REAL_STOCK,2)#</td>
                             	<td style="text-align:left">#MAIN_UNIT#</td>
                          	</tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="8"><cf_get_lang_main no='72.Kayit Yok'>!</td>
                        </tr>
                    </cfif>
       	      	</table>
          	</td>
      	</tr>
        <!---<tr>
         	<td style="display:none">
            	<cfif ikaz_query.recordcount>
               		<audio autoplay="autoplay" controls="none">
                     	<source src="dingdong.mp3" type="audio/mpeg">
                  	</audio>
              	</cfif>
         	</td>
    	</tr>--->
	</table>
</cfform>
<script language="javascript">
	pn_kontrol();
	function pn_kontrol()
	{
		geciktir1 = setTimeout("window.location.href='<cfoutput>#request.self#?fuseaction=sales.list_PRTOTM_shipping_portal_first</cfoutput>'", 100000);
	}
</script>