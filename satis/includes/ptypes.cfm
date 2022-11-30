<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfset default_process_type = 113>

<cfquery name="get_process_cat" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_process_type# AND 
        SPCF.FUSE_NAME = 'sales.emptypopup_form_add_upd_fast_sale_partner' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat.recordcount>
	<script type="text/javascript">
		alert("Ambar Fişi İşlem Kategorisi Tanımlayınız!");
		history.back();	
	</script>
</cfif>


<cfset attributes.process_cat_id=get_process_cat.process_cat_id>



<cfset form.process_cat = attributes.process_cat_id>