<cf_xml_page_edit fuseact="product.form_add_popup_image">
<cfif attributes.type eq "product">
    <cfquery name="GET_STOCKS" datasource="#DSN1#">
        SELECT STOCK_CODE,PROPERTY,STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.id#
    </cfquery>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37135.İmaj Ekle'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" closable="1" draggable="1">
		<cfform name="gonder_new_form" action="#request.self#?fuseaction=product.emptypopup_add_multi_image_set_product_cat" method="post" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<input type="hidden" name="image_action_id" id="image_action_id" value="<cfoutput>#attributes.id#</cfoutput>">
					<input type="hidden" name="image_type" id="image_type" value="<cfoutput>#attributes.type#</cfoutput>">
					<div class="form-group">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_internet" id="is_internet" checked value="1"><cf_get_lang dictionary_id='58079.İnternet'>
						</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="File" name="image_file" id="image_file" style="width:200px;"></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='37429.Açıklama girmelisiniz'></cfsavecontent>
							<cfinput required="yes" message="#message#" type="Text" value="#URLDecode(attributes.detail)#" name="detail" style="width:200px;" maxlength="250">
						</div>
					</div>
							<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">Resim Adı*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message">İsim Girmelisiniz</cfsavecontent>
							<cfinput required="yes" message="#message#" type="Text" value="" name="IMAGE_NAME" style="width:200px;" maxlength="250">
						</div>
					</div>
					<!--- xml deki stoga resim eklensin parametresi --->
					<cfif is_stock_picture and attributes.type eq "product">		
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57452.Stok"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">		
								<select name="stock_id" id="stock_id" style="width:200px; height:70px;" multiple>
								<cfoutput query="get_stocks">
									<option value="#stock_id#">#stock_code#-#property#</option>
								</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57927.Küçük'> *</label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60454.Lütfen Küçük image için genişlik değerini 1 ile 200 arasında giriniz'>!</cfsavecontent>
							<cfinput type="text" name="small_width" value="#x_small_picture_width#" validate="integer" range="1,200" message="#message#" style="width:50px;">
						</div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60455.Lütfen Küçük image için yükseklik değerini 1 ile 200 arasında giriniz'>!</cfsavecontent>
							<cfinput type="text" name="small_height" value="#x_small_picture_height#" validate="integer" range="1,200" message="#message#" style="width:50px;">
						</div>
						<label class="col col-2 col-md-2 col-sm-2 col-xs-12">px.</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='516.Orta'> *</label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60456.Lütfen Orta image için genişlik değerini 1 ile 600 arasında giriniz'>!</cfsavecontent>
							<cfinput type="text" name="medium_width" value="#x_medium_picture_width#" validate="integer" range="1,600" message="#message#" style="width:50px;">
						</div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60457.Lütfen Orta image için yükseklik değerini 1 ile 600 arasında giriniz'>!</cfsavecontent>
							<cfinput type="text" name="medium_height" value="#x_medium_picture_height#" validate="integer" range="1,600" message="#message#" style="width:50px;">
						</div>
						<label class="col col-2 col-md-2 col-sm-2 col-xs-12">px.</label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='517.Büyük'> *</label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60458.Lütfen Büyük image için genişlik değerini 1 ile 3000 arasında giriniz'>!</cfsavecontent>
							<cfinput type="text" name="large_width" value="#x_large_picture_width#" validate="integer" range="1,3000" message="#message#" style="width:50px;">
						</div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60459.Lütfen Büyük image için yükseklik değerini 1 ile 3000 arasında giriniz'></cfsavecontent>
							<cfinput type="text" name="large_height" value="#x_large_picture_height#" validate="integer" range="1,3000" message="#message#" style="width:50px;">
						</div>	
						<label class="col col-2 col-md-2 col-sm-2 col-xs-12">px.</label>
					</div>
				</div>
			</cf_box_elements>    
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{ 
	if((document.gonder_new_form.small_width.value == "" || document.gonder_new_form.small_height.value == ""))
	{ 
		alert ("<cf_get_lang dictionary_id='60460.Lütfen pixel değerlerini eksiksiz giriniz'>!");
		return false;
	}
	if((document.gonder_new_form.medium_width.value == "" || document.gonder_new_form.medium_height.value == ""))
	{ 
		alert ("<cf_get_lang dictionary_id='60460.Lütfen pixel değerlerini eksiksiz giriniz'>!");
		return false;
	}
	if((document.gonder_new_form.large_width.value == "" || document.gonder_new_form.large_height.value == ""))
	{ 
		alert ("<cf_get_lang dictionary_id='60460.Lütfen pixel değerlerini eksiksiz giriniz'>!");
		return false;
	}
	return true;
}
</script>
