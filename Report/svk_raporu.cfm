﻿<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">,
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&report_id=#attributes.report_id#&event=det" name="order_form">
<table>
    <tr>
        <td>
            <div class="form-group">
                <label>keyword</label>
                <input type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">                 
            </div>
        </td>
        <td>
            <div class="form-group" id="item-company_id">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">Cari Hesap </label>							
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                        <input name="member_name" type="text" id="member_name" placeholder="Cari Hesap" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off"><div id="member_name_div_2" name="member_name_div_2" class="completeListbox" autocomplete="on" style="width: 453px; max-height: 150px; overflow: auto; position: absolute; left: 492.5px; top: 209px; z-index: 159; display: none;"></div>
                        
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_all_pars&field_consumer=order_form.consumer_id&field_comp_id=order_form.company_id&field_member_name=order_form.member_name&field_type=order_form.member_type&select_list=7,8&keyword='+encodeURIComponent(document.order_form.member_name.value));"></span>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <div class="form-group" id="item-order_employee_id">						
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">Satış Yapan </label>			
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
                        <input name="order_employee" type="text" id="order_employee" placeholder="Satış Yapan " onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" value="<cfoutput>#attributes.order_employee#</cfoutput>" autocomplete="off"><div id="order_employee_div_2" name="order_employee_div_2" class="completeListbox" autocomplete="on" style="width: 453px; max-height: 150px; overflow: auto; position: absolute; left: 20px; top: 529px; z-index: 159; display: none;"></div>
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=order_form.order_employee_id&field_name=order_form.order_employee&is_form_submitted=1&select_list=1');"></span>
                    </div>
                </div>
            </div>
        </td>
    <td>
        <input type="submit">
        <input type="hidden" name="is_submit" value="1">
    </td>
    </tr>
    
</table>

</cfform>



<cf_big_list>
    <thead>
        <tr>
            <th>Müşteri</th>
            <th>Teklif No</th>
            <th>Satış Çalışanı</th>
            <th>SVK No</th>
            <th>Sipariş No</th>
            <th>Ürün Kodu</th>
            <th>Ürün Adı</th>
            <th>Teklif Miktari</th>
            <th>Sipariş Miktari</th>
            <th>Hazırlanan Miktar</th>
            <th>Faturalanan Miktar</th>
            <th>Depo Miktari</th>
            <th>Depo</th>
            <th>Sevk Yöntemi</th>
            <th>Açıklama</th>
            <th>Faturalanabilir Miktar</th>
        </tr>
    </thead>
    <tbody>
        <cfif isDefined("attributes.is_submit") and attributes.is_submit eq 1>
            <cfquery name="getd" datasource="#DSN3#">
                SELECT T.*
                    ,READY_AMOUNT - INVOICED_AMOUNT AS FATURALANABILIR
                    ,C.NICKNAME
                    ,S.PRODUCT_CODE
                    ,S.PRODUCT_NAME
                    ,SM.SHIP_METHOD
                    ,SAMOU.DEPO_AMOUNT
                    ,(
                        SELECT D.DEPARTMENT_HEAD + ' ' + SL.COMMENT
                        FROM workcube_metosan.STOCKS_LOCATION AS SL
                        LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID = SL.DEPARTMENT_ID
                        WHERE SL.DEPARTMENT_ID = T.DELIVER_DEPT
                            AND SL.LOCATION_ID = T.DELIVER_LOCATION
                        ) AS DLOLK
                FROM (
                    SELECT ORR.STOCK_ID
                        ,O.ORDER_NUMBER
                        ,O.COMPANY_ID
                        ,ORR.ORDER_ID
                        ,ORR.DESCRIPTION
                        ,ORR.QUANTITY AS ORDERED_AMOUNT
                        
                        ,OFFER.*
                        ,PSR.DELIVER_PAPER_NO
                        ,ISNULL(STOK_FIS.READY_AMOUNT, 0) READY_AMOUNT
                        ,PSR.SHIP_RESULT_ID
                        ,ORR.ORDER_ROW_CURRENCY
                        ,CASE 
                            WHEN ISNULL(PSR.IS_PARCALI, 0) = 0
                                THEN 'Tamamı Sevk'
                            ELSE 'Kısmi Sevk'
                            END AS SEVK_TIPI
                        ,ISNULL(INVOICE.INVOICED_AMOUNT, 0) INVOICED_AMOUNT
                    FROM workcube_metosan_1.PRTOTM_SHIP_RESULT_ROW AS PSRR
                    INNER JOIN workcube_metosan_1.PRTOTM_SHIP_RESULT AS PSR ON PSR.SHIP_RESULT_ID = PSRR.SHIP_RESULT_ID
                    LEFT JOIN workcube_metosan_1.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = PSRR.ORDER_ROW_ID
                    LEFT JOIN workcube_metosan_1.ORDERS AS O ON O.ORDER_ID = ORR.ORDER_ID
                    LEFT JOIN (
                        SELECT SUM(AMOUNT) AS INVOICED_AMOUNT
                            ,UNIQUE_RELATION_ID
                        FROM workcube_metosan_2023_1.INVOICE_ROW AS IRR
                        LEFT JOIN workcube_metosan_2023_1.INVOICE AS I ON I.INVOICE_ID = IRR.INVOICE_ID
                        WHERE I.PURCHASE_SALES = 1
                        GROUP BY UNIQUE_RELATION_ID
                        ) AS INVOICE ON INVOICE.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID
                    LEFT JOIN (
                        SELECT PO.OFFER_NUMBER
                            ,POR.QUANTITY AS OFFERED_AMOUNT
                            ,POR.UNIQUE_RELATION_ID
                            ,PO.SHIP_METHOD
                            ,POR.DELIVER_DEPT
                            ,POR.DELIVER_LOCATION
                            ,PO.OFFER_ID
                            ,workcube_metosan.getEmployeeWithId(PO.SALES_EMP_ID) AS SALE_EMP
                            ,PO.SALES_EMP_ID
                        FROM workcube_metosan_1.PBS_OFFER_ROW AS POR
                        LEFT JOIN workcube_metosan_1.PBS_OFFER AS PO ON PO.OFFER_ID = POR.OFFER_ID
                        ) AS OFFER ON OFFER.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID
                    LEFT JOIN (
                        SELECT SUM(AMOUNT) AS READY_AMOUNT
                            ,UNIQUE_RELATION_ID
                        FROM workcube_metosan_2023_1.STOCK_FIS_ROW AS SFR
                        GROUP BY UNIQUE_RELATION_ID
                        ) AS STOK_FIS ON STOK_FIS.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID
                    WHERE ORR.QUANTITY IS NOT NULL
                        AND ORR.ORDER_ROW_CURRENCY NOT IN (
                            - 3
                            ,- 9
                            ,- 10
                            )
                    ) AS T
                LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID = T.COMPANY_ID
                LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID = T.STOCK_ID
                LEFT JOIN workcube_metosan.SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID = T.SHIP_METHOD
                LEFT JOIN (
                    SELECT SUM(STOCK_IN - STOCK_OUT) AS DEPO_AMOUNT
                        ,STOCK_ID
                        ,STORE
                        ,STORE_LOCATION
                    FROM workcube_metosan_2023_1.STOCKS_ROW AS SR
                    GROUP BY STOCK_ID
                        ,STORE
                        ,STORE_LOCATION
                    ) AS SAMOU ON SAMOU.STOCK_ID = S.STOCK_ID
                    AND SAMOU.STORE = T.DELIVER_DEPT
                    AND SAMOU.STORE_LOCATION = T.DELIVER_LOCATION
                WHERE T.ORDERED_AMOUNT <> T.INVOICED_AMOUNT
                    AND T.DELIVER_PAPER_NO NOT LIKE 'PSVK%'
                    AND T.INVOICED_AMOUNT < T.ORDERED_AMOUNT
                <cfif isDefined("attributes.company_id") and len(attributes.member_name)>
                    AND C.COMPANY_ID=#attributes.COMPANY_ID#
                </cfif>
                <cfif isDefined("attributes.order_employee_id") and len(attributes.order_employee)>
                    AND T.SALES_EMP_ID=#attributes.order_employee_id#
                </cfif>
                <cfif isDefined("attributes.order_employee_id") and len(attributes.keyword)>
                    AND (
                        T.ORDER_NUMBER LIKE '%#attributes.keyword#%'
                        OR T.OFFER_NUMBER LIKE '%#attributes.keyword#%'
                    )
                </cfif>
                ORDER BY SHIP_RESULT_ID
                </cfquery>
                
                <cfoutput query="getd">
                    <tr>
                        <td>#NICKNAME#</td>
                        <td><a href="javascript:;" onclick="windowopen('/index.cfm?fuseaction=sales.list_pbs_offer&event=upd&offer_id=#OFFER_ID#')"> #OFFER_NUMBER#</a></td>
                        
                        <td>#SALE_EMP#</td>
                        <td>#DELIVER_PAPER_NO#</td>
                        <td><a href="javascript:;" onclick="windowopen('/index.cfm?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#')">#ORDER_NUMBER#</a></td>
                        <td>#PRODUCT_CODE#</td>   
                        <td>#PRODUCT_NAME#</td>        
                        <td>#OFFERED_AMOUNT#</td>        
                        <td>#ORDERED_AMOUNT#</td>
                        <td>#READY_AMOUNT#</td>
                        <td>#INVOICED_AMOUNT#</td>
                        <td>#DEPO_AMOUNT#</td>
                        <td>#DLOLK#</td>
                        <td>#SEVK_TIPI#</td>
                        <td>#DESCRIPTION#</td>
                        <td><a href="javascript:;" onclick="windowopen('/index.cfm?fuseaction=eshipping.emptypopup_list_e_shipping_status_info&iid=#SHIP_RESULT_ID#')">#FATURALANABILIR#</a></td>
                    </tr>
                </cfoutput>
        </cfif>
</tbody>
</cf_big_list>
