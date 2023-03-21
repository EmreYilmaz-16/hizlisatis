﻿SELECT PO.OFFER_NUMBER
	,PO.OFFER_DESCRIPTION
	,C.COMPANY_ID
	,C.FULLNAME
	,CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS NN
	,CP.PARTNER_ID
	,PO.OFFER_HEAD
	,PO.OFFER_DATE
	,ISNULL(PO.SHIP_METHOD, 0) SHIP_METHOD
	,ISNULL(PO.PAYMETHOD, 0) PAYMETHOD
	,PO.RECORD_DATE
	,PO.UPDATE_DATE
	,workcube_metosan.getEmployeeWithId(PO.RECORD_MEMBER) AS RECORD_MEMBER
	,workcube_metosan.getEmployeeWithId(PO.UPDATE_MEMBER) AS UPDATE_MEMBER
	,PO.OFFER_DETAIL
	,ISNULL(PO.SA_DISCOUNT, 0) SA_DISCOUNT
	,C.NICKNAME     
    ,ISNULL(CC.PAYMETHOD_ID, 0) AS PAYMETHOD_ID
    ,CC.PRICE_CAT
    ,ISNULL(CC.SHIP_METHOD_ID, 0) AS SHIP_METHOD_ID            
	,(
		SELECT S.STOCK_CODE
			,CASE 
				WHEN POR.IS_VIRTUAL = 1
					THEN (
							SELECT PRODUCT_NAME
							FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT
							WHERE VIRTUAL_PRODUCT_ID = POR.PRODUCT_ID
							) COLLATE SQL_Latin1_General_CP1_CI_AS
				ELSE S.PRODUCT_NAME
				END AS PRODUCT_NAME
			,CASE 
				WHEN POR.IS_VIRTUAL = 1
					THEN (
							SELECT PRODUCT_TYPE
							FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT
							WHERE VIRTUAL_PRODUCT_ID = POR.PRODUCT_ID
							)
				ELSE 0
				END AS PRODUCT_TYPE
			,POR.PRODUCT_ID
			,POR.STOCK_ID
			,CASE 
				WHEN POR.IS_VIRTUAL = 1
					THEN POR.UNIT COLLATE SQL_Latin1_General_CP1_CI_AS
				ELSE PU.MAIN_UNIT
				END AS MAIN_UNIT
			,PB.BRAND_NAME
			,CONVERT(DECIMAL(18,4),POR.QUANTITY) AS QUANTITY
			,CONVERT(DECIMAL(18,4),POR.PRICE) AS PRICE
			,CONVERT(DECIMAL(18,4),POR.PRICE_OTHER) AS PRICE_OTHER
			,CONVERT(DECIMAL(18,4),POR.DISCOUNT_1) AS DISCOUNT_1
			,POR.OTHER_MONEY
			,CONVERT(DECIMAL(18,4),POR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE
			,CONVERT(DECIMAL(18,4),POR.TAX) AS TAX
			,POR.SHELF_CODE
			,POR.PBS_OFFER_ROW_CURRENCY
			,POR.DETAIL_INFO_EXTRA
			,POR.PRODUCT_NAME2
			,PIP.PROPERTY1
			,CONVERT(DECIMAL(18,4),POR.EXTRA_COST) AS EXTRA_COST
			,POR.DELIVER_DATE
			,POR.IS_VIRTUAL
			,POR.UNIT
			,POR.DESCRIPTION
			,POR.UNIQUE_RELATION_ID
			,D.DEPARTMENT_HEAD + ' ' + SL.COMMENT AS DELLOC
			,CASE 
				WHEN POR.IS_VIRTUAL = 1
					THEN 1
				ELSE S.IS_PRODUCTION
				END AS IS_PRODUCTION
		FROM workcube_metosan_1.PBS_OFFER_ROW AS POR
		LEFT JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID = POR.STOCK_ID
		LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID = S.PRODUCT_ID
		LEFT JOIN workcube_metosan_1.PRODUCT_BRANDS AS PB ON PB.BRAND_ID = CASE 
				WHEN POR.IS_VIRTUAL = 1
					THEN 491
				ELSE S.BRAND_ID
				END
		LEFT JOIN (
			SELECT TOP 1 *
			FROM workcube_metosan_1.PRODUCT_INFO_PLUS
			) AS PIP ON PIP.PRODUCT_ID = S.PRODUCT_ID
		LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID = POR.DELIVER_DEPT
		LEFT JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID = POR.DELIVER_LOCATION
			AND SL.DEPARTMENT_ID = POR.DELIVER_DEPT
		WHERE POR.OFFER_ID = PO.OFFER_ID
		FOR JSON PATH
		) AS 'OFFER_ROWS'
FROM workcube_metosan_1.PBS_OFFER AS PO
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID = PO.COMPANY_ID
LEFT JOIN workcube_metosan.COMPANY_PARTNER AS CP ON CP.PARTNER_ID = PO.PARTNER_ID
LEFT JOIN workcube_metosan.COMPANY_CREDIT AS CC ON CC.COMPANY_ID = C.COMPANY_ID
LEFT JOIN workcube_metosan.SETUP_PAYMETHOD AS SPM ON SPM.PAYMETHOD_ID = CC.PAYMETHOD_ID
LEFT JOIN workcube_metosan.SHIP_METHOD AS SM ON SM.SHIP_METHOD_ID = CC.SHIP_METHOD_ID        
WHERE PO.OFFER_ID = 9496
FOR JSON PATH