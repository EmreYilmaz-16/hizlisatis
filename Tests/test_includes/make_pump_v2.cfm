<input type="hidden" name="company_id" id="company_id" value="22781">
<input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="17"> 




<cf_box title="">
    <cfform name="search_product">
    <div style="display:flex">
    <div style="width:30%;">
        <cf_box title="Oluşacak Ürün" collapsable="0" resize="0">
            <div style="height:30vh">
                
                <div style="display: flex; margin-top: 10px; margin-right: 10px; justify-content: flex-end;">
                    <button type="button" onclick="OpenBasketProducts(0,0)"  class="btn btn-success">+</button>
                    <button type="button" onclick="AddVpIS()" class="btn btn-primary">VP</button>                            
                </div>
                <table class="table" style="">
                    <tbody><tr>
                        <td>Ürün Adı</td>
                        <td>
                            <div class="form-group">
                                <input type="text" style="font-size: 15pt !important;color:green !important" name="NamePumpa" id="NamePumpa">
                                <input type="hidden" name="pidPumpa" id="pidPumpa">
                                <input type="hidden" name="SidPumpa" id="SidPumpa">
                                <input type="hidden" name="isVirtualPumpa" id="isVirtualPumpa">
                                <input type="hidden" name="PricePumpa" id="PricePumpa">
                                <input type="hidden" name="DiscountPumpa" id="DiscountPumpa">
                                <input type="hidden" name="is_rotation" id="is_rotation" value="0">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Açıklama
                        </td>
                    </tr>
                        <tr>
                            <td colspan="2">
                                <div class="form-group">
                                <textarea onchange="ChangeDesc(this)" name="AciklamaPUMPA" id="AciklamaPUMPA"></textarea>
                            </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="form-group" id="item-cat_id">
                                    <label>Kategori </label>
                                    <div class="input-group">
                                        <input type="hidden" name="cat_id" id="cat_id" value="">
                                        <input type="hidden" name="cat" id="cat" value="">
                                        <input name="category_name" type="text" id="category_name" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="" autocomplete="off"><div id="category_name_div_2" name="category_name_div_2" class="completeListbox" autocomplete="on" style="width: 463px; max-height: 150px; overflow: auto; position: absolute; left: 487.5px; top: 145px; z-index: 159; display: none;"></div>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=search_product.cat_id&field_code=search_product.cat&field_name=search_product.category_name');"></span>
                                    </div>
                                </div>
                            </td>
                          <!---  <cfquery name="getPcats" datasource="#dsn1#">
                                SELECT PRODUCT_CATID,HIERARCHY,PRODUCT_CAT FROM PRODUCT_CAT WHERE DETAIL IN ('1','2','3','4')
                            </cfquery>
                            <td colspan="2">
                                <div class="form-group">
                                <select name="CatPumpa" id="CatPumpa">
                                    <option value="">Ürün Tipi Seçiniz</option>
                                    <cfoutput query="getPcats">
                                        <option value="#HIERARCHY#">#HIERARCHY# - #PRODUCT_CAT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            </td>---->
                        </tr>
                            
                </tbody></table>
                <div style=" display: flex;bottom: 0px;position: absolute;margin-bottom: 10px;width: 100%;justify-content: flex-end;">
                <button type="button" class="btn btn-secondary" onclick="changeRotation(this)">Yön Değiştir</button>                
                <button type="button" style="margin-right:15px" class="btn btn-success" onclick="SaveForPump()">Kaydet</button>;
            </div>
                <!--- TODO: Ürün Gerçekse Direk Pompa Tablosuna Veri Atılacak Değilse Önce Ürün Oluştur Pompa Tablosuna Veri At----->
            </div>
        </cf_box>
    </div>
    <div style="width:68%;margin-left:2%">
        <cf_box title="Bozulacak Ürün(ler)" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_1">
                    <thead>
                        <tr>
                            <th>
                                Ürün 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button  onclick="OpenBasketProducts(1,0)" type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
</div>


<hr>
<div style="display:flex">
    <div style="width:50%;">
        <cf_box title="Giren Ürünler" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_2">
                    <thead>
                        <tr>
                            <th>
                                Ürün 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button onclick="OpenBasketProducts(2,0)" type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
    <div style="width:50%;margin-left:2%">
        <cf_box title="Çıkan Ürünler" collapsable="0" resize="0">
            <div style="height:30vh">
                <cf_big_list id="tbl_3">
                    <thead>
                        <tr>
                            <th>
                                Ürün 
                            </th>
                            <th>Miktar</th>
                            <th>
                                <button onclick="OpenBasketProducts(3,0)" type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>

            </div>
        </cf_box>
    </div>
</div>
</cfform>
<script src="/AddOns/Partner/Tests/test_includes/make_pump.js"></script>

</cf_box>

<!----function OpenBasketProducts(
  ArrNum,
  question_id,
  from_row = 0,
  col = "",
  actType = "4",
  SIPARIS_MIKTARI = 1,
  
) ----->