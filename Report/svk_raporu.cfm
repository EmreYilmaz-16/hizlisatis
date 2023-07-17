﻿<cfquery name="getd" datasource="#DSN3#">
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
			,workcube_metosan.getEmployeeWithId(PO.SALES_EMP_ID) AS SALE_EMP
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
ORDER BY SHIP_RESULT_ID
</cfquery>

<cf_big_list>
    <thead>
        <tr>
            <th>Müşteri</th>
            <th>Teklif No</th>
            <th>Satış Çalışanı</th>
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
<cfoutput query="getd">
    <tr>
        <td>#NICKNAME#</td>
        <td>#OFFER_NUMBER#</td>
        <td>#SALE_EMP#</td>
        <td>#ORDER_NUMBER#</td>
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
        <td>#FATURALANABILIR#</td>
    </tr>
</cfoutput>
</tbody>
</cf_big_list>

