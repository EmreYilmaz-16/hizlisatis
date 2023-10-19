<cfquery name="getP" datasource="#dsn3#">
    SELECT *
    FROM (
        SELECT PO.P_ORDER_ID
            ,PO.P_ORDER_NO
            ,WS.STATION_NAME
            ,S.PRODUCT_NAME
            ,S.PRODUCT_CODE
            ,S.STOCK_ID
            ,PO.SPECT_VAR_NAME
            ,PO.START_DATE
            ,PO.FINISH_DATE
            ,PO.PROD_ORDER_STAGE
            ,PO.LOT_NO
            ,IS_STAGE
            ,POR.ORDER_ROW_ID
            ,ORR.DELIVER_DATE
            ,PO.STATION_ID
            ,PP.PROJECT_HEAD
            ,PP.PROJECT_NUMBER
            ,PO.PROJECT_ID
            ,O.ORDER_NUMBER
            ,ISNULL(TKSS.AMOUNT, 0) AMOUNT
            ,PO.QUANTITY
            ,C.NICKNAME
        FROM #DSN3#.PRODUCTION_ORDERS AS PO
        LEFT JOIN #DSN3#.WORKSTATIONS AS WS ON WS.STATION_ID = PO.STATION_ID
        LEFT JOIN #DSN#.PRO_PROJECTS AS PP ON PP.PROJECT_ID=PO.PROJECT_ID
        LEFT JOIN #DSN3#.PRODUCTION_ORDERS_ROW AS POR ON POR.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
        LEFT JOIN #DSN3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = POR.ORDER_ROW_ID
        LEFT JOIN #DSN3#.ORDERS AS O ON O.ORDER_ID = ORR.ORDER_ID
        LEFT JOIN #DSN#.COMPANY AS C ON C.COMPANY_ID = O.COMPANY_ID
        LEFT JOIN #DSN3#.STOCKS AS S ON S.STOCK_ID = PO.STOCK_ID
        LEFT JOIN (
            SELECT PORS.P_ORDER_ID
                ,SUM(PORRA.AMOUNT) AS AMOUNT
            FROM #DSN3#.PRODUCTION_ORDER_RESULTS AS PORS
            LEFT JOIN #DSN3#.PRODUCTION_ORDER_RESULTS_ROW AS PORRA ON PORRA.PR_ORDER_ID = PORS.PR_ORDER_ID
            WHERE 1 = 1
                AND PORRA.TYPE = 1
            GROUP BY PORS.P_ORDER_ID
            ) AS TKSS ON TKSS.P_ORDER_ID = PO.P_ORDER_ID
        ) AS T
     WHERE P_ORDER_ID=#attributes.P_ORDER_ID#
    </cfquery>
    
    
    <script>
        row_count_exit=0;
    </script>
    
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
            GSS.BARCODE,
            S.STOCK_CODE,
            S.PROJECT_ID,
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
            PRODUCT_UNIT PU,
            GET_SIMPLE_STOCK as GSS
        WHERE
            POS.STOCK_ID = S.STOCK_ID AND 
            GSS.STOCK_ID = S.STOCK_ID AND 
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
    <cf_box title="Üretim Emri - #getP.P_ORDER_NO#">
        <cfoutput>
            <cf_ajax_list>
            <tr>
                <th>Müşteri</th>
                <td>#getP.NICKNAME#</td>
                <th>Sipariş</th>
                <td>#getP.ORDER_NUMBER#</td>       
                <th>Proje</th>
                <td>#getP.PROJECT_NUMBER# - #getP.PROJECT_HEAD#</td>
            </tr>
            <tr>
                <th>Ürün Kodu</th>
                <td>#getP.PRODUCT_CODE#</td>
                <th>Ürün</th>
                <td>#getP.PRODUCT_NAME#</td>
                <th>Üretilen Miktarı</th>
                <td>#getP.AMOUNT#</td>
                <th>Üretilecek Miktar</th>
                <td>#getP.QUANTITY#</td>
            </tr>
        </cf_ajax_list>
        </cfoutput>
        <div class="form-group">
            <input style="font-size:24pt !important" type="text" name="Barcode" placeholder="Barkod" onkeyup="showQ(this,event)">
        </div>  
    
    <form name="add_production_order" id="add_production_order" action="index.cfm?fuseaction=production.emptypopup_upd_prtotm_real_po" method="post" >
    
        <input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.P_ORDER_ID#</cfoutput>" >
        <input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>" >
    <input type="hidden" name="product_sarf_recordcount" id="product_sarf_recordcount" value="<cfoutput>#get_product_sarf.recordcount#</cfoutput>">
    
    <cfset deger_value_row = get_product_sarf.recordcount>
    
    <input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#deger_value_row#</cfoutput>"/>
    <input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#deger_value_row#</cfoutput>"/>
    
    
    
    <!---/*Sarflar*/--->
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='30009.Sarflar'></cfsavecontent>
    <cf_seperator title="#title#" id="sarf_" is_closed="0">
    <div id="sarf_" >
        <cf_grid_list id="table2">
            <thead>
                <tr>
                   <cfif 1 eq 1>
                        <th style="display:none" width="25">
                            
                        </th>
                    </cfif>
                    <th width="15"><cf_get_lang dictionary_id="57487.No"></th>
                    <th style="display:none" width="125"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th width="270"><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th style="display:none" width="260"><cf_get_lang dictionary_id='57647.Spec'></th>
                    <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                        <th width="120"><cf_get_lang dictionary_id='36698.Lot No'></th>
                    </cfif>
                    <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th width="60"><cf_get_lang dictionary_id='57636.Birim'></th>
                </tr>
            </thead>
            <tbody>
                
            <cfoutput query="get_product_sarf">
                <tr id="frm_row_exit#currentrow#" data-barcode="#BARCODE#" <cfif IS_PHANTOM eq 1>bgcolor="66CCFF" title="Phantom Ağaç Ürünü"<cfelseif IS_PHANTOM eq 0>class="color-row"</cfif>>
                    <cfif 1 eq 1>
                        <td style="display:none">
                            <ul class="ui-icon-list">
                               <cfif len(PROJECT_ID)>
                               <cfelse>
                                <li><a onclick="copy_row_exit('#currentrow#');"><i class="fa fa-copy"  title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" border="0"></i></a></li>
                                <li><a style="cursor:pointer;" onclick="sil_exit('#currentrow#');"><i class="fa fa-minus" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
                                </cfif>
                            </ul>
                            
                        </td>
                    </cfif>
                    <td>#currentrow#</td>
                    <script>
                        row_count_exit++;
                    </script>
                    <td style="display:none">
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
                    <td style="display:none" nowrap="nowrap">
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
    
    
    <!---<span style="color:red">Üretim Tamamlanmıştır</span><cfelse><input type="button" class=" ui-wrk-btn ui-wrk-btn-primary" onclick="$('#add_production_order').submit()" value="Sarf Kaydet">  <input type="button" class=" ui-wrk-btn ui-wrk-btn-warning" onclick="UretimTamamla(<cfoutput>#attributes.p_order_id#,#getP.STATION_ID#</cfoutput>)" value="Üretimi Sonlandır"></cfif>---->
    </form>
    </cf_box>
    <script>
        function add_row_exit(is_add_info_,row_kontrol_exit,is_phantom_exit,is_sevk_exit,is_property_exit,is_free_amount_exit,stock_code_exit,product_id_exit,stock_id_exit,product_name_exit,stock_code_exit,spec_main_id_exit,spect_name_exit,lot_no_exit,amount_exit,unit_id_exit,unit_exit,spect_id_exit)
        {
            if(is_add_info_==undefined) is_add_info_=1;
            if(row_kontrol_exit==undefined) row_kontrol_exit="";
            if(is_phantom_exit==undefined) is_phantom_exit="";
            if(is_sevk_exit==undefined) is_sevk_exit="";
            if(is_property_exit==undefined) is_property_exit="";
            if(is_free_amount_exit==undefined) is_free_amount_exit="";
            if(stock_code_exit==undefined) stock_code_exit="";
            if(product_id_exit==undefined) product_id_exit="";
            if(stock_id_exit==undefined) stock_id_exit="";
            if(product_name_exit==undefined) product_name_exit="";
            if(stock_code_exit==undefined) stock_code_exit="";
            if(spec_main_id_exit==undefined) spec_main_id_exit="";
            if(spect_name_exit==undefined) spect_name_exit="";
            if(lot_no_exit==undefined) lot_no_exit="";
            if(amount_exit==undefined) amount_exit=1;
            if(unit_id_exit==undefined) unit_id_exit="";
            if(unit_exit==undefined) unit_exit="";
            if(spect_id_exit==undefined) spect_id_exit="";
            
            row_count_exit++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
            newRow.setAttribute("name","frm_row_exit" + row_count_exit);
            newRow.setAttribute("id","frm_row_exit" + row_count_exit);
            newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
            newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
            newRow.className = 'color-row';
            document.add_production_order.record_num_exit.value = row_count_exit;
            
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<ul class="ui-icon-list"><li><a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="Satır Kopyala "><i class="fa fa-copy" border="0"></i></a></li><li><a onclick="sil_exit(' + row_count_exit + ');"><i class="fa fa-minus" border="0" align="absmiddle" alt="Sil"></i></a></li></ul>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="'+is_add_info_+'"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_phantom_exit' + row_count_exit +'" id="is_phantom_exit' + row_count_exit +'" value="'+ is_phantom_exit+'"><input type="hidden" name="is_sevk_exit' + row_count_exit +'" id="is_sevk_exit' + row_count_exit +'" value="'+ is_sevk_exit+'"><input type="hidden" name="is_property_exit' + row_count_exit +'" id="is_property_exit' + row_count_exit +'" value="'+ is_property_exit+'"><input type="hidden" name="is_free_amount_exit' + row_count_exit +'" id="is_free_amount_exit' + row_count_exit +'" value="'+ is_free_amount_exit+'"><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code_exit+'" readonly style="width:150px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'"  value="'+ product_id_exit+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+ stock_id_exit+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" readonly style="width:280px;" value="'+ product_name_exit+'"><a href="javascript://" onClick="pencere_ac_product('+ row_count_exit +');"> <img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute('nowrap','nowrap');
            newCell.setAttribute('style','display:none');
            newCell.innerHTML = '<input type="hidden" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" readonly value="'+ spec_main_id_exit+'"><input type="hidden" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="'+ spect_id_exit+'"> <input type="text" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+ spect_name_exit+'" readonly style="width:241px;"> <a href="javascript://" onclick="pencere_ac_spect(\'#currentrow#\',2);"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+ unit_id_exit+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'"  value="'+ unit_exit+'" readonly style="width:60px;">';		
        }
        function pencere_ac_product(no)
        {
            windowopen('index.cfm?fuseaction=objects.popup_product_names&call_function=calc_amount_exit&call_function_paremeter='+no+'&stock_and_spect=1&product_id=add_production_order.product_id_exit'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_name=add_production_order.product_name_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_spect_main_id=add_production_order.spec_main_id_exit'+no+'&field_spect_main_name=add_production_order.spect_name_exit'+no+'&field_unit=add_production_order.unit_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_amount=add_production_order.amount_exit'+no,'list');
        }
        function calc_amount_exit(no)
        {
            $("#amount_exit" + no).val( filterNum($("#amount_exit" + no).val()) * filterNum($("#amount_exit_" + no).val()));
        }
        function pencere_ac_spect(no,type)
        {
            if(type==2)
            {	
                form_stock = document.getElementById("stock_id_exit"+no);
                
                    url_str='&field_main_id=add_production_order.spec_main_id_exit'+no+'&field_var_id=add_production_order.spect_id_exit'+no+'&field_id=add_production_order.spect_id_exit'+no+'&field_name=add_production_order.spect_name_exit' + no + '&stock_id=' + form_stock.value+'&create_main_spect_and_add_new_spect_id=1';
                
                
            }
            else if(type==3)
            {
                form_stock = document.getElementById("stock_id_outage"+no);
                
                    url_str='&field_main_id=add_production_order.spec_main_id_outage'+no+'&field_id=add_production_order.spect_id_outage'+no+'&field_name=add_production_order.spect_name_outage' + no + '&stock_id=' + form_stock.value+'&create_main_spect_and_add_new_spect_id=1&field_var_id=add_production_order.spect_id_outage'+no;
                
            }
            if(form_stock.value == "")
                alert("Lütfen Ürün Seçiniz ");
            else
                 windowopen('index.cfm?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
        }
        function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
        {
            if(type == 2)
            {//sarf ise type 2
                form_stock_code = $("#stock_code_exit"+no).val();
                if(form_stock_code!= undefined && form_stock_code!='')
                {
                    url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
                    windowopen('index.cfm?fuseaction=objects.popup_products'+url_str+'','list');
                }
                else
                    alert("Ürün Seçmelisiniz !");
            }
            else if(type == 3)
            {//fire ise type 3
                form_stock_code = $("#stock_code_outage"+no).val();
                if(form_stock_code!= undefined && form_stock_code!='')
                {
                    url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
                    windowopen('index.cfm?fuseaction=objects.popup_products'+url_str+'','list');
                }
                else
                    alert("Ürün Seçmelisiniz !");
            }
        }
        function sil_exit(sy)
        {
            var my_element=document.getElementById("row_kontrol_exit"+sy);
            my_element.value=0;
            var my_element=eval("frm_row_exit"+sy);
            my_element.style.display="none";	
        }
        function UretimTamamla(poid,stationid){
            windowopen("/index.cfm?fuseaction=production.emptypopup_add_prod_order_result&JUSPORESULT=1&p_order_id="+poid+"&pws_id="+stationid)
        }
    </script>