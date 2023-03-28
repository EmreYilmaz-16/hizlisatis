<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> <!---kullanıcının default satır satısı gelir--->
<cfparam name="attributes.price_cat" default="-1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.start_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.katsayi" default="1"><!---Katsayıyı default 1 alır --->
<cfparam name="attributes.department_id" default="44,45,46,47"><!---PBS DEPOLAR--->
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword2" default="">
<cfparam name="attributes.brand_id" default="">
<cfset this_year_max_month = Month(now())><!---İçinde bulunduğumuz ay--->
<cfset this_year_min_month = 1><!---İçinde bulunduğumuz senenin en küçük ayı 1.aydır--->
<cfset last_year_max_month = 12><!---İçinde bulunduğumuz senenin en büyük ayı 12.aydır--->
<cfset last_year_min_month = this_year_max_month><!---Bir önceki senenin en küçük ayı, bu yılın en büyük ayına eşittir--->
<cfset this_year = Year(now())><!---bu yıl=içinde bulunduğumuz yıl--->
<cfset last_year = this_year -1><!---İçinde bulunduğumuz yıl - 1 --->
<cfquery name="get_last_period" datasource="#dsn#">
	SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #last_year#
</cfquery>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)> 
	<cf_date tarih='attributes.start_date'>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfif Len(attributes.product_code) and Len(attributes.product_cat)>
        <cfquery name="GET_CATEGORIES" datasource="#DSN1#">
            SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code#.%">
        </cfquery>
    </cfif>
    <cfquery name="get_product_list" datasource="#dsn2#">
		SELECT     
        	SUM(TBL.SHIP_INTERNAL_STOCK) AS SHIP_INTERNAL_STOCK, 
            SUM(TBL.SARF_STOCK) AS SARF_STOCK,
            SUM(TBL.RESERVED_PROD_STOCK) AS RESERVED_PROD_STOCK, 
         	SUM(TBL.PURCHASE_PROD_STOCK) AS PURCHASE_PROD_STOCK, 
            SUM(TBL.RESERVE_SALE_ORDER_STOCK) AS RESERVE_SALE_ORDER_STOCK, 
            SUM(TBL.RESERVE_PURCHASE_ORDER_STOCK) AS RESERVE_PURCHASE_ORDER_STOCK, 
            SUM(TBL.NOSALE_STOCK) AS NOSALE_STOCK, 
            SUM(TBL.REAL_STOCK) AS REAL_STOCK, 
            SUM(TBL.SALEABLE_STOCK) AS SALEABLE_STOCK, 
            P.PRODUCT_CODE, 
            P.SHELF_LIFE,
            P.PRODUCT_NAME, 
            TBL.PRODUCT_ID, 
            TBL.STOCK_ID, 
            P.PRODUCT_CODE_2,
            MANUFACT_CODE,
            ISNULL((SELECT TOP (1) MINIMUM_STOCK FROM #dsn3_alias#.STOCK_STRATEGY WHERE STOCK_ID = TBL.STOCK_ID),0) AS MINIMUM_STOCK,
            ISNULL((SELECT TOP (1) MAXIMUM_STOCK FROM #dsn3_alias#.STOCK_STRATEGY WHERE STOCK_ID = TBL.STOCK_ID),0) AS MAXIMUM_STOCK
		FROM         
        	(
            SELECT     
            	0 as DEPARTMENT_ID, 
                0 as LOCATION_ID, 
                PRODUCT_ID, 
                STOCK_ID, 
                0 AS SARF_STOCK,
                0 AS SHIP_INTERNAL_STOCK, 
                RESERVED_PROD_STOCK, 
                PURCHASE_PROD_STOCK, 
                RESERVE_SALE_ORDER_STOCK, 
                RESERVE_PURCHASE_ORDER_STOCK, 
                NOSALE_STOCK, 
                REAL_STOCK, 
                SALEABLE_STOCK
         	FROM         
            	GET_STOCK_LAST_PROFILE2 AS GSL
         	) AS TBL INNER JOIN
    		#dsn1_alias#.PRODUCT AS P ON TBL.PRODUCT_ID = P.PRODUCT_ID
		WHERE     
            P.PRODUCT_STATUS = 1 <!---AND 
            (
            	TBL.DEPARTMENT_ID = #attributes.department_id#
           	)--->
            <cfif Len(attributes.product_code) and Len(attributes.product_cat)>
            	AND P.PRODUCT_ID IN (#ValueList(get_categories.product_id,',')#)
          	</cfif>
            <cfif len(attributes.keyword)>
             	AND
                	(
                     	P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                        P.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
                      	P.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%'
                    )
         	</cfif>
			<cfif len(attributes.brand_id)>
				AND P.BRAND_ID=#attributes.brand_id#
			</cfif>
             <cfif len(attributes.keyword2)>
             	AND
                	(
                        P.MANUFACT_CODE LIKE '%#attributes.keyword2#%'
                    )
         	</cfif>
		GROUP BY 
           	TBL.PRODUCT_ID, 
            TBL.STOCK_ID, 
            P.PRODUCT_CODE, 
            P.PRODUCT_NAME, 
            P.PRODUCT_CODE_2,
            MANUFACT_CODE,
            P.SHELF_LIFE
		ORDER BY
        	P.PRODUCT_CODE
   	</cfquery>

	   <cfdump var="#get_product_list#">
	    
	   <cfset stock_id_list = Valuelist(get_product_list.STOCK_ID)>
	   <cfquery name="get_all_sales" datasource="#dsn2#">
			SELECT YIL
				,AY
				,SUM(SATIS) AS SATIS
				,STOCK_ID
			FROM (
				SELECT YEAR(PROCESS_DATE) AS YIL
					,MONTH(PROCESS_DATE) AS AY
					,SUM(STOCK_OUT) AS SATIS
					,STOCK_ID
				FROM #dsn#_#this_year#_#session.ep.COMPANY_ID#.STOCKS_ROW
				WHERE STOCK_ID IN(#stock_id_list#)
					AND STORE IN (
						44
						,45
						,46
						,47
						)
					AND PROCESS_TYPE IN (70,71,111)
					AND MONTH(PROCESS_DATE) >= #this_year_min_month#
					AND MONTH(PROCESS_DATE) <= #this_year_max_month#
				GROUP BY MONTH(PROCESS_DATE)
					,YEAR(PROCESS_DATE)
					,STOCK_ID
				
				UNION ALL
				
				SELECT YEAR(PROCESS_DATE) AS YIL
					,MONTH(PROCESS_DATE) AS AY
					,SUM(STOCK_OUT) AS SATIS
					,STOCK_ID
				FROM #dsn#_#last_year#_#session.ep.COMPANY_ID#.STOCKS_ROW
				WHERE STOCK_ID IN(#stock_id_list#)
					AND STORE IN (
						44
						,45
						)
					AND PROCESS_TYPE IN (70,71,111)
					AND MONTH(PROCESS_DATE) >= #last_year_min_month#
					AND MONTH(PROCESS_DATE) <= #last_year_max_month#
				GROUP BY MONTH(PROCESS_DATE)
					,YEAR(PROCESS_DATE)
					,STOCK_ID
                UNION ALL
SELECT YEAR(S.SHIP_DATE) AS YIL,MONTH(S.SHIP_DATE) AS AY,SUM(SR.AMOUNT) AS SATIS,SR.STOCK_ID
FROM #dsn#_#this_year#_#session.ep.COMPANY_ID#.SHIP AS S 
LEFT JOIN #dsn#_#this_year#_#session.ep.COMPANY_ID#.SHIP_ROW AS SR ON S.SHIP_ID=SR.SHIP_ID
where DELIVER_STORE_ID=44 and DEPARTMENT_IN=3 and SHIP_TYPE=81 AND MONTH(S.SHIP_DATE) >= #this_year_min_month#	AND MONTH(S.SHIP_DATE) <= #this_year_max_month#
GROUP BY 
YEAR(S.SHIP_DATE),MONTH(S.SHIP_DATE),SR.STOCK_ID
UNION ALL
SELECT YEAR(S.SHIP_DATE) AS YIL,MONTH(S.SHIP_DATE) AS AY,SUM(SR.AMOUNT) AS SATIS,SR.STOCK_ID
FROM #dsn#_#last_year#_#session.ep.COMPANY_ID#.SHIP AS S 
LEFT JOIN #dsn#_#last_year#_#session.ep.COMPANY_ID#.SHIP_ROW AS SR ON S.SHIP_ID=SR.SHIP_ID
where DELIVER_STORE_ID=44 and DEPARTMENT_IN=3 and SHIP_TYPE=81  AND MONTH(S.SHIP_DATE) >= #last_year_min_month#	AND MONTH(S.SHIP_DATE) <= #last_year_max_month#
GROUP BY 
YEAR(S.SHIP_DATE),MONTH(S.SHIP_DATE),SR.STOCK_ID

				) AS TBL
			GROUP BY YIL
				,AY
				,STOCK_ID	   	 		   
	   </cfquery>
	   <cfelse>
	   <cfset get_product_list.recordcount=0>
	</cfif>
<cfquery name="GET_MONEY" datasource="#DSN2#">
 	SELECT * FROM SETUP_MONEY
</cfquery>
<cfif get_product_list.recordcount>
	<cfset stock_id_list = Valuelist(get_product_list.stock_id)>
	<cfquery name="GET_PRICE" datasource="#DSN3#">
     	SELECT
        	P.MONEY,
         	P.PRICE,
         	S.STOCK_ID
      	FROM
			<cfif attributes.price_cat eq -1>
				PRICE_STANDART P,
			<cfelse>
				PRICE P,
			</cfif>
          	STOCKS S
   		WHERE
        	S.PRODUCT_ID = P.PRODUCT_ID AND
         	S.STOCK_ID IN (#stock_id_list#) AND
			<cfif attributes.price_cat eq -1>
				P.PRICESTANDART_STATUS = 1 AND
				P.PURCHASESALES = 0
			<cfelse>
				ISNULL(P.STOCK_ID,0)=0 AND
				ISNULL(P.SPECT_VAR_ID,0)=0 AND
				P.STARTDATE <= #now()# AND
				(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
				P.PRICE_CATID = #attributes.price_cat#
			</cfif>
 	</cfquery>
  	<cfif GET_PRICE.RECORDCOUNT>
    	<cfoutput query="GET_PRICE">
         	<cfset 'product_price_#GET_PRICE.STOCK_ID#' = GET_PRICE.PRICE>
			<cfset 'product_money_#GET_PRICE.STOCK_ID#' = GET_PRICE.MONEY>
		</cfoutput>
    </cfif>
</cfif>
<!---<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_product_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>--->
<cf_basket_form id="report_orders_">
	<cfform name="list_order" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&report_id=#attributes.report_id#&event=det">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<table style="width:100%">
				<tr>
                	<td width="400">&nbsp;</td>
					<td width="30" align="right"><cf_get_lang_main no='48.Filtre'></td>
					<td width="85"><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:80px;"></td>
                    <td width="90" align="right">Cari Özel Kodu</td>
					<td width="95"><cfinput type="text" name="keyword2" id="keyword2" value="#attributes.keyword2#" maxlength="50" style="width:80px;"></td>
                    <td width="70" align="right">Kat Sayı</td>
                    <td width="40"><cfinput type="text" name="katsayi" id="katsayi" value="#attributes.katsayi#" validate="integer" maxlength="2" style="width:30px; text-align:right"></td>
                    <cfoutput>
                        <td style="width:40px;" align="right"><cf_get_lang_main no='74.Kategori'></td>
                        <td nowrap="nowrap" width="280"><input type="hidden" name="product_code" id="product_code" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_code#</cfif>">
                            <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat) and len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                            <input type="text" name="product_cat" id="product_cat" style="width:250px;" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','0','PRODUCT_CATID,HIERARCHY','product_cat_id,product_code','','3','175','','1');" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_cat#</cfif>" autocomplete="off">
                            <a href="javascript://"onClick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_order.product_cat_id&field_code=list_order.product_code&field_name=list_order.product_cat&keyword='+encodeURIComponent(document.list_order.product_cat.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:middle" title="<cf_get_lang no='576.Ürün Kategorisi Ekle'>!"></a>
                        </td>
						<td>
							<div class="form-group" id="item-brand_id">
								<label><cf_get_lang dictionary_id='58847.Marka'></label>
								<cf_wrkproductbrand
								width="100"
								compenent_name="getProductBrand"               
								boxwidth="240"
								boxheight="150"
								brand_id="#attributes.brand_id#">
							</div>
						</td>
                        <td nowrap="nowrap">
                        	<!---<cfinput type="text" name="start_date" maxlength="10" validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                			<cf_wrk_date_image date_field="start_date">
                			<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#"  validate="eurodate" style="width:65px;">
                			<cf_wrk_date_image date_field="finish_date">--->
            			</td>
                   	</cfoutput>
                       <!---
					<td width="25"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfset maxrows_ = 999>
						<cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,#maxrows_#" required="yes" message="#message#" style="width:25px;">
					</td>--->
                    <td width="35">
                    <cfsavecontent variable="message1"><cf_get_lang_main no ='499.Çalistir'></cfsavecontent>
                    <!----<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message1#' insert_alert=''>---->
						<input type="submit">
					</td>
                </tr>
			</table>
	</cfform>
<link rel="stylesheet" type="text/css" href="/JS/DataTables/datatables.css"/>
<div style="width:99%">
    <cf_basket id="report_orders_bask_">
        <!-- sil -->
        <table id="table_id"  class="basket_list">
            <thead>
                <tr>
                    <th width="25">Sıra</th>
                    <th width="100">Stok Kodu</th>
                    <th width="70">S.Özel.K</th>
                    <th width="40">C.Özel.K</th>
                    <th><cf_get_lang_main no='245.Ürün'></th>
                    <cfoutput>
                    <cfloop from="#last_year_min_month#" to="#last_year_max_month#" index="i">
                    	<th width="40" style="text-align:center">#last_year#/#i#</th>
                    </cfloop>
                    <cfloop from="#this_year_min_month#" to="#this_year_max_month#" index="j">
                    	<th width="40" style="text-align:center">#this_year#/#j#</th>
                    </cfloop>
                    </cfoutput>
                    <th width="40">Depo Stok Tutma Süresi</th>
                    <th width="40">Mevcut Miktar</th>
                    <th width="40">Depoda Kaç Aylık Stok</th>
                  	<th width="40">Verilen Sipariş Miktarı</th>
                    <th width="40">Alınan Sip. Miktarı</th>
                    <th width="40">Toplam Satış Miktarı</th>
                    <th width="40">Aylık Ort.Satış</th>
                    <th width="40"><p>Depo Stok Tutma Miktarı</p></th>
                    <th width="40">Katsayı Stok Tutma Miktarı</th>
                    <th width="40">Toplam Stok Tutma Miktar</th>
                    <!---<th width="40">Sarf</th>--->
                    <!---<th width="40">Sevk</th>--->
                    <th width="40">İhtiyaç</th>
                    <!-- sil -->
                    <th width="25" align="center">
                    	<input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','_conversion_product_',<cfoutput>#get_product_list.recordcount#</cfoutput>);">
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_product_list.recordcount>
                    <cfoutput query="get_product_list">
                    	<cfquery name="get_stock_sales" dbtype="query">
                        	SELECT * FROM get_all_sales WHERE STOCK_ID = #STOCK_ID# ORDER BY SATIS DESC
                        </cfquery>
                        <cfset toplam_satis = 0>
                        <cfloop query="get_stock_sales" startrow="1" endrow="10">
                        	<cfset toplam_satis = toplam_satis  + satis>
                        </cfloop>
                        <cfif toplam_satis gt 0>
                        	<cfset aylik_ortalama_satis = toplam_satis / 10>
                            <cfset kac_aylik_stok_var = REAL_STOCK / aylik_ortalama_satis>
                            <cfif shelf_life gt 0>
                            	<cfset elde_stok_tutma_miktari = aylik_ortalama_satis * shelf_life>
                            <cfelse>
                            	<cfset elde_stok_tutma_miktari = 0>
                            </cfif>
                            <cfif attributes.katsayi gt 0>
                            	<cfset katsayi_stok = aylik_ortalama_satis * attributes.katsayi>
                            <cfelse>
                            	<cfset katsayi_stok = 0>
                            </cfif>
                            <cfset toplam_stok_tutma_miktari = elde_stok_tutma_miktari + katsayi_stok >
                            <!--- //kam --->
                            <cfset row_total_need = toplam_stok_tutma_miktari + RESERVE_SALE_ORDER_STOCK - real_stock - RESERVE_PURCHASE_ORDER_STOCK >

                            <!---<cfif row_total_need lt 0>
                            	<cfset row_total_need = 0> 
                            </cfif>--->
                       	<cfelse>
                        	<cfset aylik_ortalama_satis = 0>
                            <cfset kac_aylik_stok_var = 12>
                            <cfset elde_stok_tutma_miktari = 0>
                            <cfset katsayi_stok = 0>
                            <cfset toplam_stok_tutma_miktari = 0>
                            <cfset row_total_need = 0>
                      	</cfif>
                        <tr>
                            <td style="text-align:right;">#currentrow#</td>
                            <td>
                            	<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#PRODUCT_CODE#</a>
                            </td>
                            <td style="text-align:center;" nowrap="nowrap">#PRODUCT_CODE_2#</td>
                            <td style="text-align:center;" nowrap="nowrap">#MANUFACT_CODE#</td>
                            <td nowrap="nowrap">
                            	<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#PRODUCT_NAME#</a>
                            </td>
                            <cfloop from="#last_year_min_month#" to="#last_year_max_month#" index="i">
                            	<cfquery name="get_stock_sales" dbtype="query">
                                    SELECT satis FROM get_all_sales WHERE STOCK_ID = #STOCK_ID# AND YIL = #last_year# AND AY = #i#
                                </cfquery>
                                <td style="text-align:center"><cfif get_stock_sales.recordcount>#TlFormat(get_stock_sales.satis,0)#<cfelse>#TlFormat(0,0)#</cfif></td>
                            </cfloop>
                            <cfloop from="#this_year_min_month#" to="#this_year_max_month#" index="j">
                                <cfquery name="get_stock_sales" dbtype="query">
                                    SELECT satis FROM get_all_sales WHERE STOCK_ID = #STOCK_ID# AND YIL = #this_year# AND AY = #j#
                                </cfquery>
                                <td style="text-align:center"><cfif get_stock_sales.recordcount>#TlFormat(get_stock_sales.satis,0)#<cfelse>#TlFormat(0,0)#</cfif></td>
                            </cfloop>
                            <td style="text-align:right;">#AmountFormat(shelf_life,2)#</td>
                            <td style="text-align:right;">#AmountFormat(REAL_STOCK,2)#</td>
                            <td style="text-align:right;">#AmountFormat(kac_aylik_stok_var,2)#</td>
                            <td style="text-align:right;">
                            	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#product_id#','medium');">#AmountFormat(RESERVE_PURCHASE_ORDER_STOCK,0)#</a>
                            </td>
                            <td style="text-align:right;">
                            	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#product_id#','medium');">#AmountFormat(RESERVE_SALE_ORDER_STOCK,0)#</a>
                            </td>
                            <td style="text-align:right;">#AmountFormat(toplam_satis,2)#</td>
                            <td style="text-align:right;">#AmountFormat(aylik_ortalama_satis,2)#</td>
                            <td style="text-align:right;">#AmountFormat(elde_stok_tutma_miktari,2)#</td>
                            <td style="text-align:right;">#AmountFormat(katsayi_stok,2)#</td>
                            <td style="text-align:right;">#AmountFormat(toplam_stok_tutma_miktari,2)#</td>
                            <!---<td style="text-align:right;">#AmountFormat(SARF_STOCK)#</td>--->
                            <!---<td style="text-align:right;">#AmountFormat(SHIP_INTERNAL_STOCK)#</td>--->
                            <td style="text-align:right;">
                            	<!--- kam <input type="text" name="row_total_need_#stock_id#" id="row_total_need_#stock_id#" value="#tlformat(row_total_need,0)#" class="box" style="width:60px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#stock_id#);"> --->
                                <cfif row_total_need lt 0>
                            	#AmountFormat(row_total_need,0)# 
                               <cfelse>
                                <b><font color="red">#AmountFormat(row_total_need,0)#</b></font>
                            </cfif>
                                
                            </td>
                            <!-- sil -->
                            <td style="text-align:center">
                                <input type="checkbox" name="conversion_product_#stock_id#" value="#stock_id#" id="_conversion_product_#currentrow#">
                            </td>
                            <!-- sil -->
                           	<cfif isdefined('product_price_#STOCK_ID#')>
								<cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
                            <cfelse>
                                <cfset row_price = 0 >
                            </cfif>
                            <input type="hidden" name="row_price_unit_#stock_id#" id="row_price_unit_#stock_id#" value="#tlformat(row_price)#">
                            <input type="hidden" name="row_price_#stock_id#" id="row_price_#stock_id#" value="#tlformat(row_total_need*row_price)#" onKeyup="return(FormatCurrency(this,event));">
                           <select name="row_stock_money_#stock_id#" id="row_stock_money_#stock_id#" style="width:45px;display:none;">
                                <cfloop query="get_money">
                                                <option value="#money#,#RATE2#"<cfif isdefined('product_money_#get_product_list.STOCK_ID#') and Evaluate('product_money_#get_product_list.STOCK_ID#') is money>selected</cfif>>#money#</option>
                                </cfloop>
                            </select>
                       	</tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="30" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
           	<tfoot>
                <tr>
                    <td colspan="30" style="text-align:right">
                    		<input type="button" value="Satın Alma Talebi Ekle" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol();" style="width:140px;">
                    </td>
                </tr>
            </tfoot>  
      	</table>
	</div>
		<!-- sil -->     

</cf_basket_form>  

<cfif isdefined("attributes.is_submitted")>
	<cfset adres="#attributes.fuseaction#&report_id=#attributes.report_id#&is_submitted=1">
    <cfif len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
   	</cfif>
    <cfif len(attributes.keyword2)>
		<cfset adres = "#adres#&keyword2=#attributes.keyword2#">
   	</cfif>
    <cfif len(attributes.katsayi)>
		<cfset adres = "#adres#&katsayi=#attributes.katsayi#">
   	</cfif>
    <cfif len(attributes.start_date)>
		<cfset adres = "#adres#&start_date=#attributes.start_date#">
   	</cfif>
    <cfif len(attributes.finish_date)>
		<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
   	</cfif>
    <cfif isdefined('attributes.report_type') and len(attributes.report_type)>
       	<cfset adres = "#adres#&report_type=#attributes.report_type#">
    </cfif>
    <cfif Len(attributes.product_code)>
		<cfset adres = "#adres#&product_code=#attributes.product_code#">
    </cfif>
	<cfif len(attributes.brand_id)>
		<cfset adres="#adres#&brand_id=#attributes.brand_id#">
	</cfif>
    <!-- sil -->
    <!---
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#">--->
        <!-- sil -->
</cfif>
<form name="aktar_form" method="post">
    <input type="hidden" name="list_price" id="list_price" value="0">
    <input type="hidden" name="price_cat" id="price_cat" value="">
    <input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
    <input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
	<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
	<input type="hidden" name="convert_price" id="convert_price" value="">
	<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
	<input type="hidden" name="convert_money" id="convert_money" value="">
</form>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kota_kontrol()
	{
		 var convert_list ="";
		 var convert_list_amount ="";
		 var convert_list_price ="";
		 var convert_list_price_other="";
		 var convert_list_money ="";
		 //
		 <cfif isdefined("attributes.is_submitted")>
			 <cfoutput query="get_product_list">
				 if(document.all.conversion_product_#stock_id#.checked && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
				 {

					convert_list += "#stock_id#,";
					convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value,3)+',';
					convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,3)+',';
					convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,8)+',';
					convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_stocks_id').value=convert_list;
		document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
		document.getElementById('convert_price').value=convert_list_price;
		document.getElementById('convert_price_other').value=convert_list_price_other;
		document.getElementById('convert_money').value=convert_list_money;
		if(convert_list)//Ürün Seçili ise
		{
			windowopen('','wide','cc_paym');
		  	aktar_form.action="<cfoutput>#request.self#?fuseaction=correspondence.add_internaldemand&type=convert</cfoutput>";
			document.getElementById('satin_alma_talebi').disabled=true;
		 	aktar_form.target='cc_paym';
			aktar_form.submit();
		 }
		 else
		 	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
	}
	function wrk_select_all2(all_conv_product,_conversion_product_,number)
	{
		for(var cl_ind=1; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_conversion_product_'+cl_ind).checked == false)
					document.getElementById('_conversion_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_conversion_product_'+cl_ind).checked == true)
					document.getElementById('_conversion_product_'+cl_ind).checked = false;
			}
		}
	}
</script>       
<!----
<script type="text/javascript" charset="utf8" src="/js/datatables/DataTables-1.10.20/js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/Buttons-1.6.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/Buttons-1.6.1/js/buttons.flash.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/buttons/1.5.6/js/buttons.html5.min.js"></script>
<script type="text/javascript" language="javascript" src="/js/datatables/buttons/1.5.6/js/buttons.print.min.js"></script>---->
 <script type="text/javascript" src="/JS/DataTables/datatables.js"></script>

<script>
$(document).ready( function () {
    $('#table_id').DataTable({
        dom: 'Bfrtip',
		   lengthMenu: [
            [ 10, 25, 50, -1 ],
            [ '10 rows', '25 rows', '50 rows', 'Show all' ]
        ],
        buttons: [
        'copy','excel', 'pdf', 'print','pageLength'
        ],
        "scrollX": true,
		"scrollY": true,
             columnDefs: [ {
            orderable: false,
            targets:   29
        } ],
    } );
} );
</script>
