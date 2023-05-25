<cf_box title="Yeni Sanal Ürün">
    <div class="form-group">
        <input type="text" name="productNameVp" id="productNameVp" placeholder="Ürün Adı" class="form-control form-control-sm">        
    </div>
    <div class="form-group">
        <input type="hidden" name="productCatIdVp" id="productCatIdVp">
        <input type="text" name="productCatVp" id="productCatVp" placeholder="Kategori" onchange="getCats(this,event)" onkeyup="getCats(this,event)" class="form-control form-control-sm">    
        <div style="position: absolute;background: white;width: 80%;display:none" id="catRdiv" >
            <cf_box title="Ürün Kategorileri">
                <div style="height: 15vh;">
                    <table id="tblCat">
                    </table>            
                </div>
            </cf_box>  
        </div>
    </div>
        <div style="display:flex;justify-content: flex-end;">
            <button type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-sm btn-danger">İptal</button>
            <button type="button" class="btn btn-sm btn-success">Tamam</button>       
        </div>
</cf_box>