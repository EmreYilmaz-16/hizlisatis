<cf_box title="">
<div style="display:flex">
    <div style="width:30%;">
        <cf_box title="Oluşacak Ürün">
            <div style="height:30vh">
                <cf_big_list>
                    <thead>
                        <tr>
                            <th>
                                Ürün 
                            </th>
                            <th>
                                <button type="button" class="btn btn-success">+</button>
                                <button type="button" class="btn btn-primary">VP</button>
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
    <div style="width:70%">
        <cf_box title="Bozulacak Ürün(ler)">
            <div style="height:30vh">
                <cf_big_list>
                    <thead>
                        <tr>
                            <th>
                                Ürün 
                            </th>
                            <th>
                                <button type="button" class="btn btn-success">+</button>
                                
                            </th>
                        </tr>
                    </thead>
                </cf_big_list>
            </div>
        </cf_box>
    </div>
</div>

</cf_box>
<hr>
<cf_box title="Giren Çıkan Stoklar">
    <input type="hidden" name="company_id" id="company_id" value="22781">
    <input type="hidden" name="PRICE_CATID" id="PRICE_CATID" value="17"> 
    <button type="button" class="btn btn-primary" onclick="OpenBasketProducts()">+</button>
    <button type="button" class="btn btn-secondary" onclick="changeRotation(this)">Yön Değiştir</button>
    <input type="hidden" name="is_rotation" id="is_rotation" value="0">
    <table class="pump_basket" id="pump_basket">
    </table>
</cf_box>