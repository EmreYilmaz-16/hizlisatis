<cfquery name="getPo" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS WHERE V_P_ORDER_ID=#attributes.VP_ORDER_ID#
</cfquery>
<cfquery name="gets" datasource="#dsn3#">
	SELECT VIRTUAL_PRODUCT_ID
		,PRODUCT_NAME
		,PC.PRODUCT_CATID
		,PRICE
		,MARJ
		,PRODUCT_DESCRIPTION
		,PRODUCT_TYPE
		,IS_CONVERT_REAL
		,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.RECORD_EMP) RECORD_EMP
		,VIRTUAL_PRODUCTS_PRT.RECORD_DATE
		,#dsn#.getEmployeeWithId(VIRTUAL_PRODUCTS_PRT.UPDATE_EMP) UPDATE_EMP
		,VIRTUAL_PRODUCTS_PRT.UPDATE_DATE
		,PC.PRODUCT_CAT
	FROM #dsn3#.VIRTUAL_PRODUCTS_PRT
	LEFT JOIN #dsn3#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = VIRTUAL_PRODUCTS_PRT.PRODUCT_CATID
	WHERE VIRTUAL_PRODUCT_ID = #getPo.STOCK_ID#
</cfquery>
<cfquery name="getsTree" datasource="#dsn3#">
	SELECT S.PRODUCT_NAME
		,S.STOCK_CODE
		,S.STOCK_ID
		,S.PRODUCT_ID
		,VPT.AMOUNT
		,VPQ.QUESTION
		,PU.MAIN_UNIT
		,VP_ID
		,VPQ.QUESTION_ID
		,S.BARCOD
		,VPT.PRICE
		,VPT.DISCOUNT
	FROM #dsn3#.VIRTUAL_PRODUCT_TREE_PRT AS VPT
	LEFT JOIN #dsn3#.STOCKS AS S ON VPT.STOCK_ID = S.STOCK_ID
	LEFT JOIN #dsn3#.VIRTUAL_PRODUCT_TREE_QUESTIONS AS VPQ ON VPQ.QUESTION_ID = VPT.QUESTION_ID
	LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
		AND PRODUCT_UNIT_STATUS = 1
	WHERE VP_ID = #getPo.STOCK_ID#
	ORDER BY VP_ID
</cfquery>

<cf_box title="Üretim Emri #getPo.V_P_ORDER_NO#">
	<cfoutput>
	<table style="width:100%">
		<tr>
			<th style="text-align: left;" colspan="2">Ürün Gurubu</th>
			<td colspan="2" >#gets.PRODUCT_CAT#</td>
		</tr>
		<tr>
			<th style="font-size:14pt">
				Ürün Adı
			</th>
			<td style="font-size:14pt">			
				#gets.PRODUCT_NAME# 
				
			</td>
			<th style="font-size:14pt">
				Sipariş Miktar
			</th>
			<td style="font-size:14pt">
				#getPo.QUANTITY#
			</td>
		</tr>
		<tr>
			<th colspan="4" style="font-size:14pt">Açıklama</th>
		</tr>
		<tr>
		
			<td colspan="4">
				<div class="alert alert-success">
					#gets.PRODUCT_DESCRIPTION#
				</div>
			</td>
		</tr>
	</table>
	<cf_box title="Ürün Ağacı">
	<div class="form-group">
		<input type="text" name="barcodex" id="barcodex" onkeyup="findHydrolic(event,this)">
	</div>
		<cf_grid_list id="basketim">
			<tr>
				<th></th>
				<th>Ürün</th>
				<th>Barkod</th>
				<th>Miktar</th>
				<th>Birim</th>
			</tr>
			<cfset QUESTION_ID_=1>
			<script>
				hyd_basket_rows=1;
			</script>
			<CFLOOP query="getsTree">
				<tr>
					<th style="text-align:left;">
						#QUESTION#
					</th>					
					
						<td>
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="PRODUCT_NAME_#QUESTION_ID_#" id="PRODUCT_NAME_#QUESTION_ID_#"  value='#PRODUCT_NAME#'>
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick='openProductPopup(#QUESTION_ID_#)'></span>
									</div>
								</div>
							<input type="hidden" name="STOCK_ID_#QUESTION_ID_#" id="STOCK_ID_#QUESTION_ID_#"  value="#STOCK_ID#">
							<input type="hidden" name="PRODUCT_ID_#QUESTION_ID_#" id="PRODUCT_ID_#QUESTION_ID_#" value="#PRODUCT_ID#">	
							<input type="hidden" name="PRICE_#QUESTION_ID_#" id="PRICE_#QUESTION_ID_#" value="#PRICE#">	
							<input type="hidden" name="DISCOUNT_#QUESTION_ID_#" id="DISCOUNT_#QUESTION_ID_#" value="#DISCOUNT#">	
						</td>
						<td>
							<div class="form-group">
								<input type="text"  name="BARKODE_#QUESTION_ID_#" id="BARKODE_#QUESTION_ID_#" value="#BARCOD#">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="AMOUNT_#QUESTION_ID_#" onchange="this.value=commaSplit(this.value)" id="AMOUNT_#QUESTION_ID_#"  value="#tlformat(AMOUNT)#">
							</div>
						</td>
						<td>
							<span id="MAIN_UNIT_#QUESTION_ID_#">#MAIN_UNIT#</span>
						</td>
					
					
				</tr>
			<cfset QUESTION_ID_=QUESTION_ID_+1>
				<script>
				hyd_basket_rows++;
			</script>
			</CFLOOP>
		</cf_grid_list>
	</cf_box>
</cfoutput>

<script>
function findHydrolic(ev, el) {
    var keyword = el.value;
    var comp_id = document.getElementById("company_id").value;
    var price_catid = document.getElementById("PRICE_CATID").value;
    if (ev.keyCode == 13) {
        var Product = getProductMultiUse(keyword, comp_id, price_catid);     
        el.value = '';
        addHydrolikRow(Product,keyword);
        $(el).focus();
    }
}

function getProductMultiUse(keyword, comp_id, price_catid) {
    var new_query = new Object();
    var req;
    function callpage(url) {
        req = false;
        if (window.XMLHttpRequest)
            try { req = new XMLHttpRequest(); }
            catch (e) { req = false; }
        else if (window.ActiveXObject)
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e) {
                try { req = new ActiveXObject("Microsoft.XMLHTTP"); }
                catch (e) { req = false; }
            }
        if (req) {
            function return_function_() {
                console.log(req)
                if (req.readyState == 4 && req.status == 200) {

                    JSON.parse(req.responseText.replace(/\u200B/g, ''));
                    new_query = JSON.parse(req.responseText.replace(/\u200B/g, ''));
                }
            }
            req.open("post", url + '&xmlhttp=1', false);
            req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setRequestHeader('pragma', 'nocache');

            req.send("keyword=" + keyword + "&userid=" + generalParamsSatis.userData.user_id + "&dsn2=" + generalParamsSatis.dataSources.dsn2 + "&dsn1=" + generalParamsSatis.dataSources.dsn1 + "&dsn3=" + generalParamsSatis.dataSources.dsn3 + "&price_catid=" + price_catid + "&comp_id=" + comp_id);
            return_function_();
        }

    }

    //TolgaS 20070124 objects yetkisi olmayan partnerlar var diye fuseaction objects2 yapildi
    callpage('/AddOns/Partner/satis/cfc/hizli_satis.cfc?method=getProduct');
    //alert(new_query);

    return new_query;
}


function addHydrolikRow(product,barcode){

var basket=document.getElementById("basketim")
if(product.RECORDCOUNT >0){
    hyd_basket_rows++;
    var tr=document.createElement("tr")
    var td=document.createElement("td")
    tr.appendChild(td)
    var td=document.createElement("td")
    
    var div1=document.createElement("div");
        div1.setAttribute("class","form-group")
    var div2=document.createElement("div");
        div2.setAttribute("class","input-group")
    var input1=document.createElement("input")
        input1.value=product.PRODUCT.PRODUCT_NAME;
        input1.setAttribute("id","PRODUCT_NAME_"+hyd_basket_rows);
        input1.setAttribute("name","PRODUCT_NAME_"+hyd_basket_rows);
        input1.setAttribute("type","text")
    var spn=document.createElement("span");
        spn.setAttribute("class","input-group-addon btnPointer icon-ellipsis")
        spn.setAttribute("onclick","openProductPopup("+hyd_basket_rows+")")
    var input2=document.createElement("input")
        input2.setAttribute("type","hidden")
        input2.setAttribute("name","PRODUCT_ID_"+hyd_basket_rows)
        input2.setAttribute("id","PRODUCT_ID_"+hyd_basket_rows)
        input2.value=product.PRODUCT.PRODUCT_ID
    var input3=document.createElement("input")
        input3.setAttribute("type","hidden")
        input3.setAttribute("name","STOCK_ID_"+hyd_basket_rows)
        input3.setAttribute("id","STOCK_ID_"+hyd_basket_rows)
        input3.value=product.PRODUCT.STOCK_ID
    var input4=document.createElement("input")
        input4.setAttribute("type","hidden")
        input4.setAttribute("name","PRICE_"+hyd_basket_rows)
        input4.setAttribute("id","PRICE_"+hyd_basket_rows)
        input4.value=product.PRODUCT.PRICE  
    var input5=document.createElement("input")
        input5.setAttribute("type","hidden")
        input5.setAttribute("name","DISCOUNT_"+hyd_basket_rows)
        input5.setAttribute("id","DISCOUNT_"+hyd_basket_rows)
        input5.value=product.PRODUCT.DISCOUNT_RATE 
        div2.appendChild(input1)
        div2.appendChild(input2)
        div2.appendChild(input3)
        div2.appendChild(input4)
        div2.appendChild(input5)
        div2.appendChild(spn)
        div1.append(div2)
        td.appendChild(div1)
        tr.appendChild(td)
    var td=document.createElement("td")
    var div1=document.createElement("div");
        div1.setAttribute("class","form-group")
    var input1=document.createElement("input")
        input1.value=barcode; //  fonksiyonYapıldığında fonksiyondaki keyword gelecek
        input1.setAttribute("id","BARKODE_"+hyd_basket_rows);
        input1.setAttribute("name","BARKODE_"+hyd_basket_rows);
        input1.setAttribute("type","text")
        div1.appendChild(input1)
        td.appendChild(div1)
        tr.appendChild(td)
        var td=document.createElement("td")
    var div1=document.createElement("div");
        div1.setAttribute("class","form-group")
    var input1=document.createElement("input")
        input1.value=commaSplit(1); 
        input1.setAttribute("id","AMOUNT_"+hyd_basket_rows);
        input1.setAttribute("name","AMOUNT_"+hyd_basket_rows);
        input1.setAttribute("type","text")
        div1.appendChild(input1)
        td.appendChild(div1)
        tr.appendChild(td)
    var td=document.createElement("td")
      var spn=document.createElement("span");
    spn.innerText=product.PRODUCT.MAIN_UNIT;
    td.appendChild(spn)
    tr.appendChild(td)
    console.log(tr)
    basketim.appendChild(tr)
}
}
</script>