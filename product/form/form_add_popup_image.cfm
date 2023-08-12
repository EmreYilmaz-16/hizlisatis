<!---
    File: form_add_popup_image.cfm
    Folder: V16\objects\form\
	Controller:
    Author:
    Date:
    Description:
        Ürün resim yükleme popup sayfası
    History:
        2019-12-31 00:06:33 Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
        Görsel düzenlemeler yapıldı
    To Do:

--->
<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.id)>
<cf_box title="Resim Ekle" >
    <cfform name="gonderform" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post" enctype="multipart/form-data">
        <cf_box_elements vertical="1">
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
             
                    <input type="hidden" name="image_action_id" id="image_action_id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <input type="hidden" name="image_type" id="image_type" value="">
                    <input type="hidden" name="is_submit" value="1">
             
                
                <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58079.İnternet'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" checked value="1"></div>
                    </div>
                
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="language_id" id="language_id">
                            <cfoutput query="getLanguage">
                                <option value="#language_short#">#language_set#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50608.İçerik Yönetimi'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='50608.İmaj Adı !'></cfsavecontent>
                        <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" maxlength="250" value="">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file" onfocus="select_radio(1)"/></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29761.URL">*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="image_url_link" id="image_url_link" onfocus="select_radio(2)"></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33506.Video Link">Embed</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="video_link" id="video_link"></div>
                </div>
                <!--- xml deki stoga resim eklensin parametresi --->
                        
                <div class="form-group"> 
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="detail" id="detail"></textarea></div>
                </div>			
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="radio" name="size" id="size0" value="0" checked><label><cf_get_lang dictionary_id='57927.Küçük'></label>
                        <input type="radio" name="size" id="size1" value="1"><label><cf_get_lang dictionary_id='57928.Orta'></label>
                        <input type="radio" name="size" id="size2" value="2"><label><cf_get_lang dictionary_id='57929.Büyük'></label>
                    </div>
                </div>
             </div>
        </cf_box_elements>

        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='control()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
    <cfinclude  template="../query/add_image.cfm">
<script>
window.opener.location.relolad;
window.close();
</script>
</cfif>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function control()
	{
        <cfif isDefined("attributes.image_file")  and len(attributes.image_file) eq 1> 
            if(document.getElementById('size0').checked == false && document.getElementById('size1').checked == false && document.getElementById('size2').checked == false)
            {
                alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>: <cf_get_lang dictionary_id='57713.Boyut'>");
                return false;
            }
        </cfif>
            x = (100 - document.getElementById('detail').value.length);
            if ( x < 0 )
            { 
                alert ("<cf_get_lang dictionary_id='50599.Açıklama Alanı Uzun !'>"+ ((-1) * x) +"");
                return false;
            }
            return true;
        
	}
	function select_radio(selected)
	{
		document.getElementById('image_file_type'+selected).checked = true;
	}

</script>