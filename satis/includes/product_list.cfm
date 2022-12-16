
<table>
<tr>
    <td>
        <div class="form-group">
            
            <input type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
    </td>
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="hidden" name="get_company_id" id="get_company_id" value="">
            <input type="text" name="get_comp_name" id="get_comp_name" value="" placeholder="Tedarikçi" onfocus="AutoComplete_Create('get_comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID','get_company_id','','3','250',1,'applyFilters(1)');" autocomplete="off" style=""><div id="get_comp_name_div_2" name="get_comp_name_div_2" class="completeListbox" autocomplete="on" style="width: 259px; max-height: 150px; overflow: auto; position: absolute; left: 173.422px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3,1,9&field_comp_name=product_form.get_comp_name&field_comp_id=product_form.get_company_id&call_function=applyFilters(1)');"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
            
            <input type="text" name="keyword" id="keyword" placeholder="Filtre" onkeyup="Filtrele(this,event)">
        </div>
    </td>
    <td><div class="form-group">
        <div class="input-group" style="position: static;">
           
            <input type="text" name="miktar" id="miktar" onkeyup="Filtrele(this,event)" onchange="this.value=commaSplit(this.value)" value="<cfoutput>#TLFormat(1)#</cfoutput>" placeholder="Miktar" ></div>
            
            
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">		
            <input type="hidden" name="search_product_catid" id="search_product_catid" value="">
            <input type="hidden" name="product_catid" id="product_catid" value="">
            <input type="text" name="product_cat" id="product_cat" placeholder="Kategori" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,search_product_catid','','3','200',1,'applyFilters(1)');" autocomplete="off" style=""><div id="product_cat_div_2" name="product_cat_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 768.953px; top: 79px; z-index: 159; display: none;"></div>
            
            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_form.product_catid&field_hierarchy=product_form.search_product_catid&field_name=product_form.product_cat&caller_function=applyFilters&caller_function_paremeter=1');"></span>
        </div>
    </div>
    </td>
    <td>
        <div class="form-group">
        <div class="input-group" style="position: static;">
            <input type="Hidden" name="brand_id" id="brand_id">
            <input type="Text" name="brand_name" id="brand_name" placeholder="Marka" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100',1,'applyFilters(1)');" autocomplete="off" style=""><div id="brand_name_div_2" name="brand_name_div_2" class="completeListbox" autocomplete="on" style="width: 153px; max-height: 150px; overflow: auto; position: absolute; left: 932.375px; top: 79px; z-index: 159; display: none;"></div>
            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_extra_product_brands&brand_id=product_form.brand_id&brand_name=product_form.brand_name&caller_function=applyFilters&caller_function_parameter=1');"></span>
        </div></div>
    </td>
    <td>
        <div style="align-self: self-end;float:right">
            <button class="btn btn-primary" onclick="openHose('')" type="button">T</button>
            <button class="btn btn-danger" onclick="openHydrolic('')" type="button">H</button>
            <button class="btn btn-warning" type="button">P</button>
            <button class="btn btn-success" onclick="openVirtualProduct('')" type="button">VP</button>
        </div>
    </td>
    <td>
        <div class="form-group">    
            
            <input type="text"  name="RISK" id="RISK" style="font-size:14pt;line-height:1">
        </div>
    </td>
    <td>
        <div class="form-group">    
            
            <input type="text"  name="BAKIYE" id="BAKIYE" style="font-size:14pt;line-height:1">
        </div>
    </td>
</tr>

</table>
<div id="product_list">

</div>

