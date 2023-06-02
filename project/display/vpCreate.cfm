<cfparam name="idb" default="0">
<cf_box title="Yeni Sanal Ürün">
    <div class="form-group">
        <label>Ürün Adı</label>
        <input type="text" name="productNameVp" id="productNameVp" placeholder="Ürün Adı" class="form-control form-control-sm">        
    </div>
    <div class="form-group">
        <label>Kategori</label>
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
    <div class="form-group">
        <cfquery name="getAq" datasource="#dsn3#">
            SELECT QUESTION_ID,QUESTION FROM VIRTUAL_PRODUCT_TREE_QUESTIONS
        </cfquery>
        <div class="input-group mb-3">
           
        <select name="saquestion" class="form-control" id="saquestion">
            <option value="">Alternatif Sorusu</option>
            <cfoutput query="getAq"><option value="#QUESTION_ID#">#QUESTION#</option></cfoutput>
        </select>
        <button class="btn btn-sm btn-outline-secondary" type="button" id="button-addon2" onclick="addAltrnativeQ()" title="Alternatif Sorusu Ekle">+</button>
    </div>
    <div class="form-group">
        <select class="form-control" name="currencyOrr" id="currencyOrr">
            <option value="">Aşama</option>                           
            <option value="-1">Açık</option>
            <option value="-2">Tedarik</option>
            <option value="-5">Üretim</option>  
        </select>
    </div>
    </div>
        <div style="display:flex;justify-content: flex-end;">
            <button type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')" class="btn btn-sm btn-danger">İptal</button>
            <button type="button" style="margin-left:5px" class="btn btn-sm btn-success" onclick="addProdMain_(<cfoutput>#idb#</cfoutput>)">Tamam</button>       
        </div>
</cf_box>

<!-----------
     var opt = document.createElement("option");
  opt.setAttribute("value", -5);
  opt.innerText = "Üretim";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -6);
  opt.innerText = "Sevk";

  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -2);
  opt.innerText = "Tedarik";
  sel_1.appendChild(opt);
  var opt = document.createElement("option");
  opt.setAttribute("value", -1);
  opt.innerText = "Açık";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", -10);
  opt.innerText = "Kapatıldı";
  sel_1.appendChild(opt);

  var opt = document.createElement("option");
  opt.setAttribute("value", 1);
  opt.innerText = "Fiyat Talep";
  sel_1.appendChild(opt);-------->