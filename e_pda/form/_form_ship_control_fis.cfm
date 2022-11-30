<cfsetting showdebugoutput="yes">
<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
	SELECT  	TB.STOCK_ID, 
			TB.AMOUNT, 
			TB.STOCK_CODE, 
			TB.SHIP_ID, 
			TB.UNIT, 
			TB.STOCK_CODE_2, 
			P.PRODUCT_NAME
	FROM         	(SELECT     	SR.STOCK_ID, 
					SUM(SR.AMOUNT) AS AMOUNT, 
					S.STOCK_CODE, SR.SHIP_ID, 
					SR.UNIT, 
					S.STOCK_CODE_2, 
					S.PRODUCT_ID
                       	FROM          	#dsn1_alias#.STOCKS AS S RIGHT OUTER JOIN
                                       	SHIP_ROW AS SR ON S.STOCK_ID = SR.STOCK_ID
                       GROUP BY 	SR.STOCK_ID, 
					S.STOCK_CODE, 
					SR.SHIP_ID, 
					SR.UNIT, S.STOCK_CODE_2, 
					S.PRODUCT_ID
                    	HAVING      	(SR.SHIP_ID = #ship_id#)) AS TB INNER JOIN
                      #dsn1_alias#.PRODUCT AS P ON TB.PRODUCT_ID = P.PRODUCT_ID
	ORDER BY TB.STOCK_CODE_2                      
</cfquery>
<cfquery name="get_detail_package_list" datasource="#dsn2#">
SELECT     REF_STOCK_ID AS STOCK_ID, SHIP_ID, MIN(CONTROL_AMOUNT) AS CONTROL_AMOUNT
FROM         (SELECT     derivedtbl_52.REF_STOCK_ID, derivedtbl_52.SHIP_ID, ESPL52.CONTROL_AMOUNT
FROM         (SELECT     derivedtbl_51.SHIP_ID, KP51.PRODUCT_AMOUNT AS AMOUNT, derivedtbl_51.REF_STOCK_ID
                       FROM          #dsn1_alias#.STOCKS AS S51 RIGHT OUTER JOIN
                                                  (SELECT     SHIP_ID, REF_STOCK_ID
                                                    FROM          PRTOTM_SHIP_PACKAGE_LIST
                                                    GROUP BY SHIP_ID, REF_STOCK_ID
                                                    HAVING      (SHIP_ID = #URLDecode(URL.ship_id)#)) AS derivedtbl_51 ON S51.STOCK_ID = derivedtbl_51.REF_STOCK_ID LEFT OUTER JOIN
                                              #dsn1_alias#.PRODUCT AS P51 ON S51.PRODUCT_ID = P51.PRODUCT_ID LEFT OUTER JOIN
                                              #dsn1_alias#.STOCKS AS S52 LEFT OUTER JOIN
                                              #dsn1_alias#.PRODUCT AS P52 ON S52.PRODUCT_ID = P52.PRODUCT_ID RIGHT OUTER JOIN
                                              #dsn1_alias#.KARMA_PRODUCTS AS KP51 ON S52.STOCK_ID = KP51.STOCK_ID ON 
                                              S51.STOCK_ID = KP51.KARMA_PRODUCT_ID
                       WHERE      (P51.IS_KARMA = 1) AND (P52.PACKAGE_CONTROL_TYPE = 1)) AS derivedtbl_52 LEFT OUTER JOIN
                      PRTOTM_SHIP_PACKAGE_LIST AS ESPL52 ON derivedtbl_52.SHIP_ID = ESPL52.SHIP_ID AND derivedtbl_52.REF_STOCK_ID = ESPL52.STOCK_ID
					UNION
					SELECT     derivedtbl_12.REF_STOCK_ID, derivedtbl_12.SHIP_ID, ISNULL(NULLIF (ESPL22.CONTROL_AMOUNT, 0) / derivedtbl_12.AMOUNT, 0) 
                                              AS CONTROL_AMOUNT
                       FROM          #dsn1_alias#.PRODUCT AS P12 RIGHT OUTER JOIN
                                              #dsn1_alias#.STOCKS AS S12 ON P12.PRODUCT_ID = S12.PRODUCT_ID RIGHT OUTER JOIN
                                                  (SELECT     ESPL12.REF_STOCK_ID, ESPL12.SHIP_ID, PT12.RELATED_ID, PT12.AMOUNT
                                                    FROM          PRTOTM_SHIP_PACKAGE_LIST AS ESPL12 INNER JOIN
                                                                           #dsn3_alias#.PRODUCT_TREE AS PT12 ON ESPL12.REF_STOCK_ID = PT12.STOCK_ID
                                                    WHERE      (ESPL12.SHIP_ID = #URLDecode(URL.ship_id)#)
                                                    GROUP BY ESPL12.REF_STOCK_ID, ESPL12.SHIP_ID, PT12.RELATED_ID, PT12.AMOUNT) AS derivedtbl_12 ON 
                                              S12.STOCK_ID = derivedtbl_12.REF_STOCK_ID LEFT OUTER JOIN
                                              PRTOTM_SHIP_PACKAGE_LIST AS ESPL22 ON derivedtbl_12.REF_STOCK_ID = ESPL22.REF_STOCK_ID AND 
                                              derivedtbl_12.SHIP_ID = ESPL22.SHIP_ID
                       WHERE      (P12.IS_KARMA = 0) AND (P12.PACKAGE_CONTROL_TYPE = 2) AND derivedtbl_12.RELATED_ID IN (
                                                                                                                        SELECT     
                                                                                                                            STOCK_ID
                                                                                                                        FROM          
                                                                                                                            #dsn3_alias#.STOCKS
                                                                                                                        WHERE      
                                                                                                                            STOCK_CODE LIKE N'01.151.01.01%' OR STOCK_CODE LIKE N'01.151.02.09%'
                                                                                                                        ) 
                       UNION
                       SELECT     derivedtbl_42.REF_STOCK_ID, derivedtbl_42.SHIP_ID, ISNULL(NULLIF (ESPL42.CONTROL_AMOUNT, 0) / derivedtbl_42.AMOUNT, 0) 
                                             AS CONTROL_AMOUNT
                       FROM         (SELECT     derivedtbl_41.SHIP_ID, PT42.RELATED_ID, PT42.AMOUNT * KP41.PRODUCT_AMOUNT AS AMOUNT, 
                                                                     derivedtbl_41.REF_STOCK_ID
                                              FROM          #dsn1_alias#.STOCKS AS S41 RIGHT OUTER JOIN
                                                                         (SELECT     SHIP_ID, REF_STOCK_ID
                                                                           FROM          PRTOTM_SHIP_PACKAGE_LIST
                                                                           GROUP BY SHIP_ID, REF_STOCK_ID
                                                                           HAVING      (SHIP_ID = #URLDecode(URL.ship_id)#)) AS derivedtbl_41 ON S41.STOCK_ID = derivedtbl_41.REF_STOCK_ID LEFT OUTER JOIN
                                                                     #dsn1_alias#.PRODUCT AS P41 ON S41.PRODUCT_ID = P41.PRODUCT_ID FULL OUTER JOIN
                                                                     #dsn3_alias#.PRODUCT_TREE AS PT42 RIGHT OUTER JOIN
                                                                     #dsn1_alias#.STOCKS AS S42 ON PT42.STOCK_ID = S42.STOCK_ID LEFT OUTER JOIN
                                                                     #dsn1_alias#.PRODUCT AS P42 ON S42.PRODUCT_ID = P42.PRODUCT_ID RIGHT OUTER JOIN
                                                                     #dsn1_alias#.KARMA_PRODUCTS AS KP41 ON S42.STOCK_ID = KP41.STOCK_ID ON 
                                                                     S41.STOCK_ID = KP41.KARMA_PRODUCT_ID
                                              WHERE      (P41.IS_KARMA = 1) AND (P42.PACKAGE_CONTROL_TYPE = 2) AND PT42.RELATED_ID IN (
                                                                                                                                        SELECT     
                                                                                                                                            STOCK_ID
                                                                                                                                        FROM          
                                                                                                                                            #dsn3_alias#.STOCKS
                                                                                                                                        WHERE      
                                                                                                                                            STOCK_CODE LIKE N'01.151.01.01%' OR STOCK_CODE LIKE N'01.151.02.09%'
                                                                                                                                        )
                                              ) AS derivedtbl_42 LEFT OUTER JOIN
                                             PRTOTM_SHIP_PACKAGE_LIST AS ESPL42 ON derivedtbl_42.SHIP_ID = ESPL42.SHIP_ID AND 
                                             derivedtbl_42.RELATED_ID = ESPL42.STOCK_ID
                       UNION
                       SELECT     ESPL32.REF_STOCK_ID, ESPL32.SHIP_ID, ESPL32.CONTROL_AMOUNT
                       FROM         #dsn1_alias#.PRODUCT AS P12 RIGHT OUTER JOIN
                                             #dsn1_alias#.STOCKS AS S32 ON P12.PRODUCT_ID = S32.PRODUCT_ID RIGHT OUTER JOIN
                                             PRTOTM_SHIP_PACKAGE_LIST AS ESPL32 ON S32.STOCK_ID = ESPL32.REF_STOCK_ID
                       WHERE     (ESPL32.SHIP_ID = #URLDecode(URL.ship_id)#) AND (P12.PACKAGE_CONTROL_TYPE = 1) AND (P12.IS_KARMA = 0)) AS derivedtbl_01
GROUP BY REF_STOCK_ID, SHIP_ID
</cfquery>
<cfquery name="get_url" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER,
    	DELIVER_STORE_ID,
        LOCATION
    FROM
    	SHIP
    WHERE
    	(SHIP_ID = #ship_id#)
</cfquery>
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_ship&department_id=#department_id#&date1=#date1#&date2=#date2#&is_form_submitted=1&page=#page#&kontrol_status=#kontrol_status#">
<table cellpadding="2" cellspacing="1" align="left" class="color-border">
<form name="add_fis" method="post" action="<cfoutput>#request.self#?fuseaction=#adres#</cfoutput>">
	<tr class="color-list">
		<td colspan="5">
		<table width="99%" height="29" cellpadding="0" cellspacing="0">
			<tr>
            	<td> <b>İrsaliye No : <cfoutput>#get_url.SHIP_NUMBER#</cfoutput></b></td>
                <td><input type="submit" value="Geri" name="1"></td>
         	</tr>
		</table>
		</td>
	</tr>
    <tr class="color-list" height="20">
    	<td width="45">
        	Stok Kodu
        </td>
    	<td>
        	Stok Adı
        </td>
    	<td width="20">
        	
        </td>
    	<td width="20">
        	
        </td>
    	<td width="15">
        	
        </td>                                
    </tr>
	<cfoutput query="GET_SHIP_ROW">
	<tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		
        <td><a href="#request.self#?fuseaction=pda.form_ship_control_stock&ship_id=#ship_id#&f_stock_id=#GET_SHIP_ROW.stock_id#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&product_name=#GET_SHIP_ROW.PRODUCT_NAME#">
        #STOCK_CODE_2#
        </a>
        </td>
        
        <!---&ship_id=#URLEncodedFormat(islem_id)#&belge_no=#URLEncodedFormat(belge_no)--->

       	<td ><a href="#request.self#?fuseaction=pda.form_ship_control_stock&ship_id=#ship_id#&f_stock_id=#GET_SHIP_ROW.stock_id#&department_id=#department_id#&date1=#date1#&date2=#date2#&page=#page#&kontrol_status=#kontrol_status#&product_name=#GET_SHIP_ROW.PRODUCT_NAME#">
        #PRODUCT_NAME#
        </a>
        </td>
        <input type="hidden" name="stock_id" value="STOCK_ID" />
        <input type="hidden" name="ship_id" value="#attributes.ship_id#" />
        <input type="hidden" name="amount#STOCK_ID#" value="#AMOUNT#" />
        <input type="hidden" name="control_amount#STOCK_ID#" value="<cfif isdefined('control_amount#STOCK_ID#')>#Tlformat(Evaluate('control_amount#STOCK_ID#'),0)# <cfelse>#Tlformat(0,0)#</cfif>" />
        <td style="text-align:right;color:FF0000;"><strong>#AMOUNT#</strong></td>
		<td style="text-align:right;color:FF0000;"><strong><cfif isdefined('control_amount#STOCK_ID#')>#Tlformat(Evaluate('control_amount#STOCK_ID#'),0)# <cfelse>#Tlformat(0,0)#</cfif></strong></td>
			<!---<div style="position:absolute; width:15;" align="right">--->
			<td><img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq AMOUNT)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
			<img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte AMOUNT)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
			<!---</div>---></td>
	</tr>
	</cfoutput>
	<input type="hidden" name="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
	</form>
   
</table>
