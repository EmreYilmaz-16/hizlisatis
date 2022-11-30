<cfset attributes.seperator_type = 59><!--- Noktali Virgul Chr --->
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cfscript>
	CRLF=chr(13)&chr(10);
	barcode_list = ArrayNew(1);
	for(row_i=1;row_i lte attributes.row_count;row_i=row_i+1)
		ArrayAppend(barcode_list,"#evaluate('attributes.barcod#row_i#')#;#evaluate('attributes.amount#row_i#')#");
</cfscript>
<cfset file_name = "#createUUID()#.txt">
<cffile action="write" output="#ArrayToList(barcode_list,CRLF)#" file="#upload_folder##file_name#" addnewline="yes" charset="iso-8859-9">
<cfdirectory directory="#upload_folder#" name="folder_info" sort="datelastmodified" filter="#file_name#">
<cfset file_name = folder_info.name>
<cfset file_size = folder_info.size>
<cfset form.store = attributes.txt_department_in>
<cfset attributes.department_id = ListGetAt(attributes.txt_department_in,1,'-')>
<cfset attributes.location_id = ListGetAt(attributes.txt_department_in,2,'-')>
<cfset attributes.process_date = Dateformat(now(),'dd/mm/yyyy')>
<cfset attributes.stock_identity_type = 1><!--- Tip Barkod --->

<cfinclude template="import_stock_count_display.cfm">

<script type="text/javascript">
	<cfif not isdefined('error_flag')>
		alert('Sayım dosyanız başarıyla oluşturulmuştur !');
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=epda.prtotm_depo_sayim</cfoutput>';
</script>