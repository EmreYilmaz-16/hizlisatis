<input type="hidden" name="company_id" id="company_id" value="22781">
<input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="17"> 

<button type="button" class="btn btn-primary" onclick="OpenBasketProducts()">+</button>
<button type="button" class="btn btn-secondary" onclick="changeRotation(this)">Yön Değiştir</button>
<input type="hidden" name="is_rotation" id="is_rotation" value="0">
<cf_box title="">
<div style="display:flex">
    <div style="width:30%;">
        <cf_box title="Oluşacak Ürün" collapsable="0" resize="0">
            <div style="height:30vh">
                
                <div style="display:flex">
                    <button type="button" onclick="OpenBasketProducts(0,0)"  class="btn btn-success">+</button>
                    <button type="button" onclick="AddVpIS()" class="btn btn-primary">VP</button>                            
                </div>
                <button type="button" class="btn btn-success" style="bottom: 0; position: absolute; right: 0; margin-right: 10px; margin-bottom: 10px;">Kaydet</button>
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