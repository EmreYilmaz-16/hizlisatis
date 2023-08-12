<cf_xml_page_edit fuseact="product.form_add_popup_image">
<cfset getComponent = createObject('component','cfc.wrk_images')>
     <cfset table = "PRODUCTCAT_IMAGES">
     <cfset identity_column = "PRODUCT_CATID">
     <cfquery name="get_image" datasource="#dsn1#">
        select * from PRODUCTCAT_IMAGES where PRODUCTCAT_IMAGEID=#attributes.action_id# 
     </cfquery>

<cfset getLanguage = getComponent.GET_LANGUAGE()>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37075.İmaj Güncelle'></cfsavecontent>
<cf_popup_box title="#message#" >
<cfform name="gonderform" action="#request.self#?fuseaction=#attributes.fuseaction#&image_action_id=#attributes.action_id#" method="post" enctype="multipart/form-data">
<table>
  
    
        <tr>
            <td colspan="2"></td>
            <td ><input type="checkbox" name="is_internet" id="is_internet" <cfif get_image.is_internet eq 1> checked</cfif> value="1"><cf_get_lang dictionary_id='58079.İnternet'></td>
            <input type="hidden" name="ACTION_ID" value="<cfoutput>#attributes.action_id#</cfoutput>">
        </tr>
    <input type="hidden" name="is_submit" value="1">
    <tr>
        <td colspan="2"><cf_get_lang dictionary_id='58996.Dil'></td>
        <td>
            <select name="language_id" id="language_id" style="width:60px;">
                <cfoutput query="getLanguage">
                    <option value="#language_short#" <cfif get_image.language_id is language_short> selected</cfif>>#language_set#</option>
                </cfoutput>
            </select>
        </td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang dictionary_id='50608.İmaj Adı'>*</td>
        <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='50608.İmaj Adı !'></cfsavecontent>
            <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" style="width:200px;" maxlength="250" value="#get_image.PRD_IMG_NAME#">
        </td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang dictionary_id='58080.Resim'> *</td>
        <td><input type="File" name="image_file" id="image_file" onfocus="select_radio(1)" style="width:200px;"></td>
    </tr>
    <tr>
        <td colspan="2"></td>
        <td colspan="4"><cfoutput>#get_image.path#</cfoutput></td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang dictionary_id="29761.URL">*</td>
        <td><input type="text" name="image_url_link" id="image_url_link" value="<cfif isdefined("get_image.VIDEO_PATH") and len(get_image.VIDEO_PATH)><cfoutput>#get_image.VIDEO_PATH#</cfoutput></cfif>" onfocus="select_radio(2)" style="width:200px;"></td>
        <td><input type="checkbox" name="video_link" id="video_link" <cfif GET_IMAGE.VIDEO_LINK eq 1>checked="checked"</cfif>></td>
        <td><cf_get_lang dictionary_id="33506.Video Link"> Embed</td>
    </tr>                    
    <tr>
        <td colspan="2" style="vertical-align:top"><cf_get_lang_main no='217.Açıklama'></td>
        <td><textarea name="detail" id="detail" style="width:200px;height:60px;" ><cfoutput>#get_image.detail#</cfoutput></textarea></td>
    </tr>
	<!--- xml deki stoga resim eklensin parametresi --->
    <cfif is_stock_picture and attributes.type eq "product">
        <tr>
            <td colspan="2"><cf_get_lang dictionary_id="57452.Stok"></td>
            <td>
                <select name="stock_id" id="stock_id" style="width:200px; height:70px;" multiple>
					<cfoutput query="getStocks">
                        <option value="#stock_id#" <cfif listfind(get_image.stock_id, stock_id)>selected</cfif>>#stock_code#-#property#</option>
                    </cfoutput>
                </select>					
            </td>
        </tr>	
    </cfif>
    <tr>
        <td colspan="2"><cf_get_lang dictionary_id='57713.Boyut'>*</td>
        <td>
            <input type="radio" name="size" id="size" value="0" <cfif get_image.image_size eq 0> checked</cfif>><cf_get_lang dictionary_id='57927.Küçük'>
            <input type="radio" name="size" id="size" value="1" <cfif get_image.image_size eq 1> checked</cfif>><cf_get_lang dictionary_id='57928.Orta'>
            <input type="radio" name="size" id="size" value="2" <cfif get_image.image_size eq 2> checked</cfif>><cf_get_lang dictionary_id='57929.Büyük'>
        </td>
    </tr>
</table>
<cfset session.imPath = "#upload_folder#productcat#dir_seperator#">
<cfset session.module = "product">
<cf_popup_box_footer>
<table width="99%">
	<tr>
    	<td>
        	<cfif len(get_image.update_emp)>
                <cf_get_lang dictionary_id='57891.Güncelleyen'>: 
                <cfset temp_update = dateadd('h',session.ep.time_zone,get_image.update_date)>
                <cfoutput>#get_emp_info(get_image.update_emp,0,0)# - 
                #dateformat(temp_update,dateformat_style)#</cfoutput>
            </cfif>
        </td>
        <td style="text-align:right;">
        	<cf_workcube_buttons is_upd='1'is_delete='0' add_function='control()' type_format='1'>
        </td>
    </tr>
</table>
</cf_popup_box_footer>	
</cfform>
</cf_popup_box>
<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
<cfinclude  template="../query/upd_image.cfm">
</cfif>

<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function go()
	{	   
	   if(control())
		   document.gonderform.submit();
	}
	
	function control()
	{	
		if(document.getElementById('image_file_type1').checked == true)
		{
			var obj =  document.getElementById('image_file').value;
			if ((obj != "") && (!((obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'png')))){
				alert("<cf_get_lang dictionary_id='37708.Lütfen bir resim dosyası(gif,jpg veya png) giriniz'>!!");        
				return false;
			}
			<cfif  GET_IMAGE.IS_EXTERNAL_LINK eq 1>
			if(obj == "")
			{
				alert("<cf_get_lang dictionary_id='43275.Dosya Seçmelisiniz'> !");
				return false;
			}
			</cfif>
			document.getElementById('upload_status').style.display = '';
			return true;
		}
		else if(document.getElementById('image_file_type2').checked ==true)
		{
			if(trim(document.getElementById('image_url_link').value) =="")
			{
				alert("<cf_get_lang dictionary_id='29936.URL Giriniz'> !");
				return false;
			}
		}
	}

	function select_radio(selected)
	{
		document.getElementById('image_file_type'+selected).checked = true;
	}

</script>
