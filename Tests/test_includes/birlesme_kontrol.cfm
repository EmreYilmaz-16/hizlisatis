<cfif IS_TYPE eq 1>
    <cfif (attributes.e_shipping_type eq 1 and ceiling(AMBAR_CONTROL.recordcount) AND ceiling(AMBAR_CONTROL.PAKET_SAYISI) - ceiling(AMBAR_CONTROL.CONTROL_AMOUNT) eq 0 AND ceiling(PACKEGE_CONTROL.PAKET_SAYISI) - ceiling(PACKEGE_CONTROL.CONTROL_AMOUNT) eq 0 and DURUM eq 1  and get_invoice_durum.kalan lt 0) or attributes.e_shipping_type neq 1 >
        <cfquery name="get_shipping_group" dbtype="query">
            SELECT
                <cfif len(COMPANY_ID)>
                    COMPANY_ID,
                <cfelseif len(CONSUMER_ID)>
                    CONSUMER_ID,
                </cfif>
                SEHIR,
                ILCE,
                SHIP_METHOD_TYPE,
                DELIVER_EMP,
                COUNT(*) AS SAYI
            FROM
                GET_SHIPPING
            WHERE
                IS_TYPE = 1 AND
                SHIP_METHOD_TYPE = #SHIP_METHOD_TYPE# AND
                SEHIR = '#SEHIR#' AND
                ILCE = '#ILCE#' AND
                DELIVER_EMP = #DELIVER_EMP# AND
                <cfif len(COMPANY_ID)>
                    COMPANY_ID = #COMPANY_ID#
                <cfelseif len(CONSUMER_ID)>
                    CONSUMER_ID = #CONSUMER_ID#
                </cfif>
            GROUP BY
                <cfif len(COMPANY_ID)>
                    COMPANY_ID,
                <cfelseif len(CONSUMER_ID)>
                    CONSUMER_ID,
                </cfif>
                SEHIR,
                ILCE,
                DELIVER_EMP,
                SHIP_METHOD_TYPE
        </cfquery>
        <cfif get_shipping_group.SAYI gt 1>
            <cfset birlesme_izni = 1>
        <cfelse>       
        </cfif>
    <cfelse>      
    </cfif>
<cfelse>
</cfif>