
<cftry >


    <cfquery name="getS" datasource="#dsn3#">
    SELECT AMOUNT
        ,DELIVER_DEPT
        ,DELIVER_LOCATION
        ,PRODUCT_NAME
        ,PRODUCT_PLACE_ID
        ,QUANTITY
        ,SHELF_CODE
        ,SHIP_RESULT_ROW_ID
        ,STOCK_ID
        ,DETAIL_INFO_EXTRA
        ,BRAND_NAME
        ,BARCOD
        ,PREPARE_PERSONAL
        ,ORDER_EMPLOYEE_ID
        ,DELIVER_PAPER_NO
        ,DELIVERY_DATE
        ,NICKNAME
        ,PRODUCT_CODE
        ,OFFER_ROW_DESCRIPTION
        ,OFFER_ID
        ,DESCRIPTION
    FROM (
        SELECT ORR.QUANTITY
            ,SF.AMOUNT
            ,S.PRODUCT_NAME
            ,PP.SHELF_CODE
            ,ORR.DELIVER_DEPT
            ,ORR.DELIVER_LOCATION
            ,S.STOCK_ID
            ,S.PRODUCT_CODE
            ,SRR.SHIP_RESULT_ROW_ID
            ,PP.PRODUCT_PLACE_ID
            ,ORR.DETAIL_INFO_EXTRA
            ,B.BRAND_NAME
            ,S.BARCOD
            ,workcube_metosan.getEmployeeWithId(SRR.PREPARE_PERSONAL) AS PREPARE_PERSONAL
            ,workcube_metosan.getEmployeeWithId(O.ORDER_EMPLOYEE_ID) AS ORDER_EMPLOYEE_ID
            ,SR.DELIVER_PAPER_NO
            ,SR.DELIVERY_DATE
            ,C.NICKNAME
            ,PPOR.OFFER_ROW_DESCRIPTION
            ,PPOR.OFFER_ID
            ,ORR.DESCRIPTION
        FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
        LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID = SRR.ORDER_ROW_ID
        LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
        LEFT JOIN #dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID
        LEFT JOIN #DSN#.COMPANY AS C ON C.COMPANY_ID=O.COMPANY_ID
        LEFT JOIN #DSN3#.PBS_OFFER_ROW AS PPOR ON PPOR.UNIQUE_RELATION_ID=ORR.UNIQUE_RELATION_ID
        LEFT JOIN (
		SELECT sum(SFR.AMOUNT) AS AMOUNT
			,UNIQUE_RELATION_ID
		FROM #dsn2#.STOCK_FIS_ROW AS SFR
		GROUP BY UNIQUE_RELATION_ID
		) AS SF ON SF.UNIQUE_RELATION_ID = ORR.UNIQUE_RELATION_ID COLLATE SQL_Latin1_General_CP1_CI_AS

        LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID = ORR.STOCK_ID
        LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID = S.STOCK_ID
        LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
        LEFT JOIN #DSN1#.PRODUCT_BRANDS AS B ON B.BRAND_ID = S.BRAND_ID
        WHERE SRR.SHIP_RESULT_ID = #attributes.action_id#
            AND ORR.DELIVER_DEPT = #listgetat(attributes.action_ids, 1, "-") #
            AND ORR.DELIVER_LOCATION = #listGetAt(attributes.action_ids, 2, "-") #
        ) AS TSL
        
        </cfquery>
        <cfif session.ep.userid eq 1146>
        
        <cfdump var="#getS#">
    </cfif>
        <table id="basket" >
            <thead>
                <tr >
                    <th colspan="9" >
                        <h3 style="font-size:14pt !important">Hazırlama Listesi</h3>
                    </th>
                </tr>
                <tr>
                    <th>SVK No</th>
                    <td><cfoutput>#gets.DELIVER_PAPER_NO#</cfoutput></td>
                    <th>Cari Hesap</th>
                    <td><cfoutput>#getS.NICKNAME#</cfoutput>
                        </td>
                    <th>Satış Çalışanı</th>
                    <td><cfoutput>#getS.ORDER_EMPLOYEE_ID#</cfoutput></td>
                    <th>Sevk Tarihi</th>
                    <td><cfoutput>#dateFormat(gets.DELIVERY_DATE)#</cfoutput></td>                
                </tr>
                <tr>
                    <th>
                        Açıklama
                    </th>
                    <td colspan="8">
                            <cfquery name="getOfferDes" datasource="#dsn3#">
                                SELECT OFFER_DESCRIPTION FROM PBS_OFFER WHERE OFFER_ID=#getS.OFFER_ID#
                            </cfquery>
                            <cfoutput>#getOfferDes.OFFER_DESCRIPTION#</cfoutput>
                    </td>
                </tr>
                <tr>
                    <td colspan="9" style="height:1mm;background:black"></td>
                </tr>
                <tr>
                    <th>Barkod</th>
                    <th>Raf</th>
                    <th>Ürün K.</th>
                    <th>Ürün</th>
                    <th>Marka</th>
                    <th>Miktar</th>
                    <th>Açıklama</th>
                    <th>Depo</th>
                    <th>Ölçü</th>
                    
        
                </tr>
            </thead>
            <tbody>
            <cfoutput query="getS">
               
                <tr>
                    <td style="text-align:center"><cf_workcube_barcode type="code128" value="#BARCOD#" show="1" width="50" height="40">
                        <br>#BARCOD#
                    </td>
                    <td>#SHELF_CODE#</td>
                    <td>#PRODUCT_CODE#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#BRAND_NAME#</td>
                    <td style="width:15%;text-align:center"><div class="form-group">#tlformat(QUANTITY,2)#</div></td>
                    <td>#DESCRIPTION#</td>
                    <td style="width:15%;text-align:center">
                        <cfquery name="getSrQ" datasource="#dsn2#">
                            select sum(STOCK_IN-STOCK_OUT) AS BAKIYE from #dsn2#.STOCKS_ROW where 1=1
                             and STOCK_ID=#STOCK_ID# 
                        AND STORE=#listgetat(attributes.action_ids,1,"-")#  AND STORE_LOCATION=#listGetAt(attributes.action_ids,2,"-")#
                        </cfquery>
                        #tlformat(getSrQ.BAKIYE)#
                    </td>
                    <td>#DETAIL_INFO_EXTRA#</td>
                  
                </tr>
            </cfoutput>
        </tbody>
        <tfoot>
            <tr>
                <th colspan="5" style="text-align:right">Hazırlayan</th>
                <th colspan="2" style="text-align:right"><cfoutput>#getS.PREPARE_PERSONAL#</cfoutput></th>
            </tr>
        </tfoot>
        </table>
    
        <cfcatch>
            <cfdump var="#cfcatch#">
        </cfcatch>
        </cftry>