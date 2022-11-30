<cfif (listFind("70,71",listfirst(attributes.cat,'-'))) or not len (attributes.cat) or (not (len(attributes.consumer_id) or len(attributes.company_id) or len(attributes.invoice_action)))>
  <cfquery name="GET_SHIP_FIS" datasource="#DSN2#">
		<cfif (len(attributes.cat) and listFind("70,71",listfirst(attributes.cat,'-'))) or not len(attributes.cat)>
				SELECT
					1 TABLE_TYPE,
					SHIP.PURCHASE_SALES ,
					SHIP.SHIP_ID ISLEM_ID,
					SHIP_NUMBER BELGE_NO,
					SHIP_TYPE ISLEM_TIPI,
					SHIP.SHIP_DATE ISLEM_TARIHI,
					SHIP.COMPANY_ID,
					SHIP.CONSUMER_ID,
					SHIP.PARTNER_ID,
					0 EMPLOYEE_ID,
					DEPARTMENT_IN DEPARTMENT_ID,
					LOCATION_IN LOCATION,
					DELIVER_STORE_ID DEPARTMENT_ID_2,
					LOCATION LOCATION_2,
					NULL INVOICE_NUMBER, 
					DELIVER_EMP,
					SHIP.RECORD_DATE,
					0 IS_STOCK_TRANSFER,
					0 STOCK_EXCHANGE_TYPE
				FROM 	
					SHIP
				WHERE 
                <cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
					SHIP.SHIP_TYPE = #listfirst(attributes.cat,'-')#
				<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
					SHIP.PROCESS_CAT = #listlast(attributes.cat,'-')#
				<cfelse>
					SHIP.SHIP_ID IS NOT NULL
				</cfif>
				<cfif len(attributes.belge_no)>
                	AND ((SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%') OR
						(SHIP.REF_NO LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%'))
				<cfelse>
					<cfif len(attributes.date1)>
                      	AND SHIP.SHIP_DATE = #attributes.date1#
                    </cfif>
					<cfif len(attributes.department_id)>
                       <cfif listlen(attributes.department_id,'-') eq 1>
                        AND (DEPARTMENT_IN = #attributes.department_id# OR DELIVER_STORE_ID = #attributes.department_id#)
                    <cfelse>
                        AND ((DEPARTMENT_IN =  #listfirst(attributes.department_id,'-')# AND LOCATION_IN = #listlast(attributes.department_id,'-')#) OR
                            (DELIVER_STORE_ID = #listfirst(attributes.department_id,'-')# AND LOCATION = #listlast(attributes.department_id,'-')#))	
                    </cfif>
                    </cfif>
				</cfif>				  
          </cfif>
	 </cfquery>
  <cfelse>
  <cfset get_ship_fis.recordcount=0>
</cfif>
