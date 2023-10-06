<cfquery name="getP" datasource="#dsn3#">
    SELECT * FROM (
SELECT PO.P_ORDER_ID,PO.P_ORDER_NO,WS.STATION_NAME,S.PRODUCT_NAME,S.STOCK_ID,PO.SPECT_VAR_NAME,PO.START_DATE,PO.FINISH_DATE,PO.PROD_ORDER_STAGE,PO.LOT_NO,IS_STAGE,POR.ORDER_ROW_ID,ORR.DELIVER_DATE,PO.STATION_ID,O.ORDER_NUMBER,ISNULL(TKSS.AMOUNT,0) AMOUNT,PO.QUANTITY,C.NICKNAME FROM #dsn3#.PRODUCTION_ORDERS  AS PO
LEFT JOIN #dsn3#.WORKSTATIONS AS WS ON WS.STATION_ID=PO.STATION_ID
LEFT JOIN #dsn3#.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID=PO.P_ORDER_ID
LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=POR.ORDER_ROW_ID
LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID =O.COMPANY_ID
LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=PO.STOCK_ID
LEFT JOIN ( SELECT PORS.P_ORDER_ID,SUM(PORRA.AMOUNT) AS AMOUNT FROM #dsn3#.PRODUCTION_ORDER_RESULTS AS PORS 
 LEFT JOIN #dsn3#.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID=PORS.PR_ORDER_ID
 WHERE 1=1 AND PORRA.TYPE=1 GROUP BY PORS.P_ORDER_ID) AS TKSS ON TKSS.P_ORDER_ID=PO.P_ORDER_ID ) AS T
 WHERE P_ORDER_ID=#attributes.P_ORDER_ID#
</cfquery>
<cfdump var="#getP#">



<!--- Üretim emrinde sarf ve fire oluşturma... --->
<cfsetting showdebugoutput="no">
<cfquery name="get_product_sarf" datasource="#DSN3#">
	SELECT 
		POS.PRODUCT_ID,
		POS.STOCK_ID,
		POS.SPECT_MAIN_ID,
        POS.SPECT_VAR_ID,
		POS.AMOUNT,
		POS.PRODUCT_UNIT_ID,
		POS.SPECT_MAIN_ROW_ID,
        POS.LINE_NUMBER,
        POS.LOT_NO,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		PU.MAIN_UNIT,
		(SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME,
		ISNULL(POS.IS_PHANTOM,0) IS_PHANTOM,
		IS_SEVK,
		IS_PROPERTY,
		IS_FREE_AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE,
        WRK_ROW_ID
	FROM 
		PRODUCTION_ORDERS_STOCKS POS,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		POS.STOCK_ID = S.STOCK_ID AND 
		POS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.P_ORDER_ID#"> AND
		TYPE = 2
	ORDER BY
		<cfif isdefined('is_line_number') and is_line_number eq 1>
        	POS.LINE_NUMBER
        <cfelse>
            POS.RECORD_DATE DESC
        </cfif>
</cfquery>
<cfset attributes.stock_id=getP.STOCK_ID>
<input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >
<input type="hidden" name="product_sarf_recordcount" id="product_sarf_recordcount" value="<cfoutput>#get_product_sarf.recordcount#</cfoutput>">

<cfset deger_value_row = get_product_sarf.recordcount>

<input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/>
<input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#deger_value_row#</cfoutput>"/>
<!---/*Sarflar*/--->
<cfsavecontent variable="title"><cf_get_lang dictionary_id='30009.Sarflar'></cfsavecontent>
<cf_seperator title="#title#" id="sarf_" is_closed="1">
<div id="sarf_" style="display:none;">
    <cf_grid_list id="table2">
        <thead>
            <tr>
               <cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                    <th width="25">
                        <a href="javascript://" onClick="add_row_exit();"><i class="fa fa-plus" align="absmiddle" border="0"></i></a>
                    </th>
                </cfif>
                <th width="15"><cf_get_lang dictionary_id="57487.No"></th>
                <th width="125"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                <th width="270"><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th width="260"><cf_get_lang dictionary_id='57647.Spec'></th>
                <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                    <th width="120"><cf_get_lang dictionary_id='36698.Lot No'></th>
                </cfif>
                <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th width="60"><cf_get_lang dictionary_id='57636.Birim'></th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_product_sarf">
            <tr id="frm_row_exit#currentrow#" <cfif IS_PHANTOM eq 1>bgcolor="66CCFF" title="Phantom Ağaç Ürünü"<cfelseif IS_PHANTOM eq 0>class="color-row"</cfif>>
                <cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                    <td>
						<ul class="ui-icon-list">
                            <li><a onclick="copy_row_exit('#currentrow#');"><i class="fa fa-copy"  title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" border="0"></i></a></li>
                            <li><a style="cursor:pointer;" onclick="sil_exit('#currentrow#');"><i class="fa fa-minus" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
                        </ul>
                        
                    </td>
                </cfif>
                <td>#currentrow#</td>
                <td>
                    <input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
                    <input type="hidden" name="is_phantom_exit#currentrow#" id="is_phantom_exit#currentrow#"value="#IS_PHANTOM#">
                    <input type="hidden" name="is_sevk_exit#currentrow#" id="is_sevk_exit#currentrow#"value="#IS_SEVK#">
                    <input type="hidden" name="is_property_exit#currentrow#" id="is_property_exit#currentrow#"value="#IS_PROPERTY#">
                    <input type="hidden" name="is_free_amount_exit#currentrow#" id="is_free_amount_exit#currentrow#"value="#IS_FREE_AMOUNT#">
                    <input type="hidden" name="fire_amount_exit#currentrow#" id="fire_amount_exit#currentrow#"value="#FIRE_AMOUNT#">
                    <input type="hidden" name="fire_rate_exit#currentrow#" id="fire_rate_exit#currentrow#"value="#FIRE_RATE#">
                    <input type="hidden" name="line_number_exit#currentrow#" id="line_number_exit#currentrow#"value="#LINE_NUMBER#">
                    <input type="hidden" name="wrk_row_id_exit#currentrow#" id="wrk_row_id_exit#currentrow#"value="#WRK_ROW_ID#">
                    <input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#STOCK_CODE#" style="width:150px;" readonly="">
                </td>
                <td nowrap>
                    <input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#"value="#product_id#">
                    <input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
                    <input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#PRODUCT_NAME#" readonly style="width:280px;">
                    <a href="javascript://" onClick="pencere_ac_alternative('#currentrow#',document.add_production_order.product_id_exit#currentrow#.value,document.add_production_order.main_stock_id.value);"><img src="/images/plus_thin.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='45311.Alternatif Ürünler'>"></a>
                    <a href="javascript://" onClick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absmiddle" border="0" title="Stok Detay"></a>
                </td>
                <td nowrap="nowrap">
                    <input type="hidden" name="spect_main_row_exit#currentrow#" id="spect_main_row_exit#currentrow#" value="#SPECT_MAIN_ROW_ID#">
                    <input type="hidden" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#spect_var_id#">
                    <input type="text" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#spect_main_id#" readonly style="width:40px;">
                    <input type="text" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#SPECT_MAIN_NAME#" readonly style="width:200px;">
					<a href="javascript://" onclick="pencere_ac_spect('#currentrow#',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                </td>
                <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                    <td nowrap="nowrap">
                    	<input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#lot_no#" onKeyup="lotno_control(#currentrow#,2);" style="width:100px;"/>
                       	<a href="javascript://" onclick="pencere_ac_list_product('#currentrow#','2');"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0"></a>
                    </td>
                </cfif>
                <td>
                    <input type="text" name="amount_exit#currentrow#" id="amount_exit#currentrow#" value="#TlFormat(wrk_round(AMOUNT,8,1),8)#" <cfif isdefined("is_update_sarf_amount") and is_update_sarf_amount eq 0>readonly="readonly"</cfif> onKeyup="return(FormatCurrency(this,event,8));" onblur="aktar2(2,#currentrow#);" class="moneybox" style="width:100px;">
                    <input type="hidden" name="amount_exit_#currentrow#" id="amount_exit_#currentrow#" value="#TlFormat(wrk_round(AMOUNT,8,1),8)#" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">
                </td>
                <td>
                    <input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#product_unit_id#">
                    <input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#main_unit#" readonly style="width:60px;">
                </td>
            </tr>
        </cfoutput>
       </tbody>
    </cf_grid_list>
</div>