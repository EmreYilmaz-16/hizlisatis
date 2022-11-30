<cfset shipping_id_list_ =''>
<cfloop list="#attributes.shipping_id_list#" index="ii">
	<cfif listgetat(ii,1,'-') eq 1>
		<cfset shipping_id_list_ = ListAppend(shipping_id_list_, listgetat(ii,2,'-'))>
   	</cfif>
</cfloop>
<cfif len(shipping_id_list_)>
    <cfquery name="get_min_ship_result_id" datasource="#dsn3#">
        SELECT     
            ESR.COMPANY_ID, 
            ESR.SHIP_METHOD_TYPE, 
            O.CITY_ID,
            O.COUNTY_ID, 
            MIN(ESR.SHIP_RESULT_ID) AS REF_SHIP_RESULT_ID
        FROM         
            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
            PRTOTM_SHIP_RESULT_ROW AS ESSR ON ESR.SHIP_RESULT_ID = ESSR.SHIP_RESULT_ID INNER JOIN
            ORDERS AS O ON ESSR.ORDER_ID = O.ORDER_ID
        WHERE     
            ESR.SHIP_RESULT_ID IN (#shipping_id_list_#)
        GROUP BY 
            ESR.COMPANY_ID, 
            ESR.SHIP_METHOD_TYPE, 
            O.CITY_ID,
            O.COUNTY_ID
    </cfquery>
    <cftransaction>
        <cfloop query="get_min_ship_result_id">
            <cfquery name="upd_shipping_row" datasource="#dsn3#">
                UPDATE    
                    PRTOTM_SHIP_RESULT_ROW
                SET              
                    SHIP_RESULT_ID = #get_min_ship_result_id.REF_SHIP_RESULT_ID#
                WHERE     
                    SHIP_RESULT_ROW_ID IN 	
                                        (
                                        SELECT     
                                            ESSR.SHIP_RESULT_ROW_ID
                                        FROM         
                                            PRTOTM_SHIP_RESULT AS ESR INNER JOIN
                                            PRTOTM_SHIP_RESULT_ROW AS ESSR ON ESR.SHIP_RESULT_ID = ESSR.SHIP_RESULT_ID INNER JOIN
                                            ORDERS AS O ON ESSR.ORDER_ID = O.ORDER_ID
                                        WHERE     
                                            ESR.SHIP_RESULT_ID IN (#shipping_id_list_#) AND 
                                            ESR.COMPANY_ID = #get_min_ship_result_id.COMPANY_ID# 
                                            <cfif len(get_min_ship_result_id.SHIP_METHOD_TYPE)>
                                            	AND ESR.SHIP_METHOD_TYPE = #get_min_ship_result_id.SHIP_METHOD_TYPE#
                                            </cfif>
                                            <cfif len(get_min_ship_result_id.CITY_ID)>
                                            	AND O.CITY_ID = #get_min_ship_result_id.CITY_ID#
                                           	</cfif>
                                            <cfif len(get_min_ship_result_id.COUNTY_ID)>
                                            	AND O.COUNTY_ID = #get_min_ship_result_id.COUNTY_ID#
                                          	</cfif>	
                                        )
            </cfquery>
        </cfloop>
    </cftransaction>
<cfelse>
	<script language="javascript">
	   alert('Birleşecek Kayıt Bulunamadı');
	</script>
</cfif>
<script language="javascript">
   window.close();
</script>
