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
	function kontrol() {
		if (document.gonder_new_form.image_file.value === "") {
			alert("<cf_get_lang dictionary_id='60461.Lütfen bir görüntü seçiniz'>!");
			return false;
		}
	
		var img = new Image();
		img.src = window.URL.createObjectURL(document.gonder_new_form.image_file.files[0]);
		img.onload = function() {
			var maxWidth = 3000; // Max genişlik değeri
			var maxHeight = 3000; // Max yükseklik değeri
			
			var aspectRatio = img.width / img.height;
			
			var small_width = Math.min(img.width, 200); // Max 1000 genişlik
			var small_height = Math.min(small_width / aspectRatio, maxHeight); // Genişlik oranına göre yükseklik hesaplanıyor
			
			var medium_width = Math.min(img.width, 400); // Max 4000 genişlik
			var medium_height = Math.min(medium_width / aspectRatio, maxHeight); // Genişlik oranına göre yükseklik hesaplanıyor
			
			var large_width = Math.min(img.width, maxWidth); // Max 3000 genişlik
			var large_height = Math.min(large_width / aspectRatio, maxHeight); // Genişlik oranına göre yükseklik hesaplanıyor
	
			// Form alanlarına boyutları otomatik olarak ekliyorum
			document.gonder_new_form.small_width.value = small_width;
			document.gonder_new_form.small_height.value = small_height;
			
			document.gonder_new_form.medium_width.value = medium_width;
			document.gonder_new_form.medium_height.value = medium_height;
			
			document.gonder_new_form.large_width.value = large_width;
			document.gonder_new_form.large_height.value = large_height;
			// Resim ismini al ve form alanına ata (dosya türünü eklememe)
			var fileInput = document.gonder_new_form.image_file;
			var imageName = fileInput.files[0].name;
			var indexOfLastDot = imageName.lastIndexOf(".");
			if (indexOfLastDot !== -1) {
			   imageName = imageName.substring(0, indexOfLastDot); // Dosya türünü kaldır
	}
	document.gonder_new_form.IMAGE_NAME.value = imageName;
			// Formu gönderiyorum
			document.gonder_new_form.submit();
		};
	
		return false; // Normal form submitini engelleme
	}
	</script>
	