<!--- <cfoutput>
	Main DB: #dsn# <br/ > Product DB: #dsn1# <br/ > Period DB: #dsn2# <br/ > Company DB: #dsn3# <br/ >
	</cfoutput> --->
<meta http-equiv="refresh" content="30">
<style>
	table{ font-size: }
</style>
<cfset last_year = session.ep.period_year -1>
<cfquery name="Sorgu" datasource="#dsn3#">
SELECT C.FULLNAME
	,ORR.PRODUCT_NAME
	,ORR.QUANTITY
	,ORD.ORDER_DATE
	,PR.MANUFACT_CODE
	,PR.PRODUCT_ID
	,ORR.STOCK_ID
	,(
			SELECT sum(sr.STOCK_IN - sr.STOCK_OUT)
FROM catalystTest_2019_1.STOCKS_ROW AS sr
	,catalystTest_product.STOCKS AS s
	,catalystTest_product.PRODUCT AS p
WHERE s.PRODUCT_ID = p.PRODUCT_ID
	AND s.STOCK_ID = sr.STOCK_ID
	AND SR.STORE_LOCATION = 0
	AND SR.STOCK_ID =ORR.STOCK_ID
GROUP BY s.STOCK_ID
HAVING sum(sr.STOCK_IN - SR.STOCK_OUT) > 0
		) AS MIKO
	,(SELECT TOP(1) ESR.DELIVER_PAPER_NO  FROM catalystTest_1.PRTOTM_SHIP_RESULT AS ESR,catalystTest_1.PRTOTM_SHIP_RESULT_ROW AS ESRR WHERE ESR.SHIP_RESULT_ID=ESRR.SHIP_RESULT_ID AND ORDER_ID=ORD.ORDER_ID) AS DELIVER_PAPER_NO 
	,(SELECT TOP(1) ESR.SHIP_RESULT_ID  FROM catalystTest_1.PRTOTM_SHIP_RESULT AS ESR,catalystTest_1.PRTOTM_SHIP_RESULT_ROW AS ESRR WHERE ESR.SHIP_RESULT_ID=ESRR.SHIP_RESULT_ID AND ORDER_ID=ORD.ORDER_ID) AS SSHIP_RESULT_ID
FROM catalystTest_1.ORDER_ROW AS ORR
	,catalystTest_1.ORDERS AS ORD
	,catalystTest.COMPANY AS C
	,catalystTest_product.PRODUCT as PR
WHERE STOCK_ID IN (
		SELECT sr.STOCK_ID
		FROM catalystTest_2019_1.STOCKS_ROW AS sr
			,catalystTest_product.STOCKS AS s
		WHERE STORE_LOCATION = 0
			AND sr.STOCK_ID = s.STOCK_ID
		GROUP BY sr.STOCK_ID
		HAVING SUM(STOCK_IN - STOCK_OUT) > 0
		)
	AND ORDER_ROW_CURRENCY = '-6'
	AND ORD.ORDER_ID = ORR.ORDER_ID
	AND C.COMPANY_ID = ORD.COMPANY_ID
	AND ORR.PRODUCT_ID=PR.PRODUCT_ID
ORDER BY STOCK_ID DESC
	,ORD.ORDER_DATE ASC

</cfquery>
<!--- <cfquery name="PRTOTMDeneme1" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_ORDERS_ORDERS_REL
	</cfquery>
	<cfquery name="PRTOTMDeneme2" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIP_RESULT
	</cfquery>
	<cfquery name="PRTOTMDeneme3" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIP_RESULT_ROW
	</cfquery>
	<cfquery name="PRTOTMDeneme4" datasource="#dsn2#">
	select TOP(10) * from #dsn3#.PRTOTM_SHIPPING_PACKAGE_LIST
	</cfquery>
	<cfdump var="#PRTOTMDeneme1#">
	<cfdump var="#PRTOTMDeneme2#">
	<cfdump var="#PRTOTMDeneme3#">
	<cfdump var="#PRTOTMDeneme4#">
	<cfdump var="#Sorgu#" > --->

<div style="display:inline-flex" class="row">
<div class="col-11">
<h3>Mal Kabul Bilgi Ekranı</h3>
</div><div style="float:right" class="col-1">
<cfoutput>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping_Depo&ID=1','page');"class="btn btn-primary" style="color:white" title="Sevk Fişine Git">Depo Detay Bilgileri</a>
</cfoutput>
</div></div>
<cf_big_list>
	<tr>
	<thead>
		<th>
			Sevk No
		</th>
		<th>
			Üretici Kodu
		</th>
		<th>
			Ürün Adı
		</th>
		<th>
			Sipariş Tarihi
		</th>
		<!---
		<th>
			Sipariş Miktarı
		</th>
		--->
		<th>
			Müşteri Adı
		</th>
<th>Mal Kabul Depo Mik.</th>
		<th>Sipariş Mik.</th>
		<th>
			Miktar
		</th>
		<th>
			Sevk
		</th>
		<th>
			Kalan
		</th>
	</thead>
	</tr>
	<tbody>
		<cfoutput query="Sorgu">
<cfif len(SSHIP_RESULT_ID) gt 0>
<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn3#">
        SELECT
        	PAKET_SAYISI AS PAKETSAYISI,
            PAKET_ID AS STOCK_ID,
            BARCOD,
            STOCK_CODE,
            PRODUCT_NAME,
         	ISNULL((
            		SELECT
                  		SUM(CONTROL_AMOUNT) CONTROL_AMOUNT
                   	FROM
                     	(
                       	SELECT
                          	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                      	FROM
                       		#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                         	#dsn#_#session.ep.period_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                     	WHERE
                         	SF.FIS_TYPE = 113 AND
                          	SF.REF_NO = '#Sorgu.DELIVER_PAPER_NO#' AND
                     		SFR.STOCK_ID = TBL.PAKET_ID
                       		UNION ALL
                          	SELECT
                             	SUM(SFR.AMOUNT) AS CONTROL_AMOUNT
                           	FROM
                           		#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS AS SF INNER JOIN
                              	#dsn#_#last_year#_#session.ep.company_id#.STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
                           	WHERE
                              	SF.FIS_TYPE = 113 AND
                              	SF.REF_NO = '#Sorgu.DELIVER_PAPER_NO#' AND
                              	SFR.STOCK_ID = TBL.PAKET_ID
                		) AS TBL_5
        	),0) AS CONTROL_AMOUNT,
            SHIP_RESULT_ID,
            DELIVER_PAPER_NO
		FROM
        	(
            SELECT
            	SUM(PAKET_SAYISI) AS PAKET_SAYISI,
                PAKET_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT,
                SHIP_RESULT_ID,
                DELIVER_PAPER_NO
           	FROM
            	(
                SELECT
                    CASE
                        WHEN
                            S.PRODUCT_TREE_AMOUNT IS NOT NULL
                        THEN
                            S.PRODUCT_TREE_AMOUNT
                        ELSE
                            round(SUM(ORR.QUANTITY * EPS.PAKET_SAYISI),3)
                    END
                        AS PAKET_SAYISI,
                    EPS.PAKET_ID,
                    S.BARCOD,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT,
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    ESR.DELIVER_PAPER_NO
                FROM
                    PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                    PRTOTM_SHIP_RESULT_ROW AS ESRR ON ESR.SHIP_RESULT_ID = ESRR.SHIP_RESULT_ID INNER JOIN
                    ORDER_ROW AS ORR ON ESRR.ORDER_ROW_ID = ORR.ORDER_ROW_ID INNER JOIN
                    PRTOTM_PAKET_SAYISI AS EPS ON ORR.STOCK_ID = EPS.MODUL_ID INNER JOIN
                    STOCKS AS S ON EPS.PAKET_ID = S.STOCK_ID
                WHERE
                    ESR.SHIP_RESULT_ID =#Sorgu.SSHIP_RESULT_ID#
                GROUP BY
                    EPS.PAKET_ID,
                    S.BARCOD,
                    S.STOCK_CODE,
                    S.PRODUCT_NAME,
                    S.PRODUCT_TREE_AMOUNT,
                    ESR.SHIP_RESULT_ID,
                    ESRR.ORDER_ROW_ID,
                    DELIVER_PAPER_NO
             	) AS TBL1
          	GROUP BY
            	PAKET_ID,
                BARCOD,
                STOCK_CODE,
                PRODUCT_NAME,
                PRODUCT_TREE_AMOUNT,
                SHIP_RESULT_ID,
                DELIVER_PAPER_NO
        	) AS TBL
  	</cfquery>
<cfset kalan_amount= Sorgu.QUANTITY- GET_SHIP_PACKAGE_LIST.PAKETSAYISI>
<cfif kalan_amount gt 0>
			<tr>
				<td>
					<!---#Sorgu.DELIVER_PAPER_NO#--->
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_PRTOTM_shipping&iid=#Sorgu.SSHIP_RESULT_ID#','page');" class="tableyazi" title="Sevk Fişine Git">#Sorgu.DELIVER_PAPER_NO#</a>

				</td>
				<td>
					<!---#Sorgu.MANUFACT_CODE#--->
		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#Sorgu.PRODUCT_ID#&sid=#Sorgu.STOCK_ID#','page');" class="tableyazi" title="Sevk Fişine Git">#Sorgu.MANUFACT_CODE#</a>
				</td>
				<td>
					#Sorgu.PRODUCT_NAME#
				</td>
				<td>
					<cfscript>
                      writeOutput(DateFormat(Sorgu.ORDER_DATE,"dd/mm/yy"));
                    </cfscript>
					<!--- #Sorgu.ORDER_DATE# --->
				</td>
				
			
			
				<td>
					#Sorgu.FULLNAME#
				</td>
				<td>#Sorgu.MIKO#</td>
				<td>
					#Sorgu.QUANTITY#
				</td>
				<td>								
					#Tlformat(GET_SHIP_PACKAGE_LIST.PAKETSAYISI,3)#
					
				</td>
				<td>
					#Tlformat(GET_SHIP_PACKAGE_LIST.control_amount,3)#
				</td>
				<td>
					#Tlformat(kalan_amount,3)#
				</td>
				<td>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#Sorgu.STOCK_ID#&product_id=#Sorgu.PRODUCT_ID#','page');"><img src="/images/cuberelation.gif" title="Lokasyonlara Göre Stoklar" border="0"></a>
<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#Sorgu.PRODUCT_ID#','page');"><img src="/images/ship.gif" title="Alınan Siparişler" border="0"></a>
				</td>
			</tr>
</cfif>
</cfif>
		</cfoutput>
	</tbody>
</cf_big_list>
