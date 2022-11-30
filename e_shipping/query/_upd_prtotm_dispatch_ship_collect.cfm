<cfset shipping_id_list_ =''>
<cfloop list="#attributes.shipping_id_list#" index="ii">
	<cfif listgetat(ii,1,'-') eq 2> <!---Sevk Talebi Olarak Gelen Parametreleri Buluyoruz--->
		<cfset shipping_id_list_ = ListAppend(shipping_id_list_, listgetat(ii,2,'-'))>
   	</cfif>
</cfloop>
<!---<cfdump var="#attributes#"><cfabort>--->
<cfif len(shipping_id_list_)>
    <cfquery name="get_ship_result_id" datasource="#dsn3#"> <!---İlgili Sevk Taleplerinin Birleşenlerini İlişkilendiriyoruz--->
    	SELECT     
        	E.SHIP_COLLECT_ID, 
            SI.DISPATCH_SHIP_ID, 
            SI.SHIP_METHOD, 
            SI.DEPARTMENT_IN
		FROM         
        	PRTOTM_DISPATCH_SHIP_COLLECT AS E RIGHT OUTER JOIN
          	#dsn2_alias#.SHIP_INTERNAL AS SI ON E.SHIP_RESULT_ID = SI.DISPATCH_SHIP_ID
		WHERE     
        	SI.DISPATCH_SHIP_ID IN (#shipping_id_list_#)
		ORDER BY 
        	E.SHIP_COLLECT_ID
    </cfquery>
	<!---İlgili Sevk Taleplerini Mağazaya ve Sevk Yöntemine göre Guruplayıp, Guruptaki en küçük Birleşme ID sine eşitliyoruz Hiç birleşeni yoksa 0 veriyoruz--->
    <cfquery name="get_min_ship_result_id" datasource="#dsn3#"> 
    	SELECT     
        	ISNULL(MIN(SHIP_COLLECT_ID),0) SHIP_COLLECT_ID, 
            SHIP_METHOD, 
            DEPARTMENT_IN
		FROM         
        	(
            SELECT     
                E.SHIP_COLLECT_ID, 
                SI.DISPATCH_SHIP_ID, 
                SI.SHIP_METHOD, 
                SI.DEPARTMENT_IN
            FROM         
                PRTOTM_DISPATCH_SHIP_COLLECT AS E RIGHT OUTER JOIN
                #dsn2_alias#.SHIP_INTERNAL AS SI ON E.SHIP_RESULT_ID = SI.DISPATCH_SHIP_ID
            WHERE     
                SI.DISPATCH_SHIP_ID IN (#shipping_id_list_#)
            ) TBL
		GROUP BY 
        	SHIP_METHOD, 
            DEPARTMENT_IN
    </cfquery>
    <cftransaction>
    	<!---Kullanılmış En Küçük Birleştirme ID sini Bulup 1 ilave ediyoruz--->
    	<cfquery name="GET_LAST_SHIP_COLLECT_ID" datasource="#dsn3#">
        	SELECT     
            	ISNULL(MAX(SHIP_COLLECT_ID),0) AS SHIP_COLLECT_ID
			FROM         
            	PRTOTM_DISPATCH_SHIP_COLLECT
        </cfquery>
        <cfif GET_LAST_SHIP_COLLECT_ID.recordcount and GET_LAST_SHIP_COLLECT_ID.SHIP_COLLECT_ID gt 0>
        	<cfset LAST_SHIP_COLLECT_ID = GET_LAST_SHIP_COLLECT_ID.SHIP_COLLECT_ID +1>
        <cfelse>
        	<cfset LAST_SHIP_COLLECT_ID = 30000001>
        </cfif>
        <cfloop query="get_min_ship_result_id">
        	<!---Eğer Birleşimler İçinde Önceden Tanımlanmış ID Varsa En küçük değer olan kayıt haricindeki diğer kayıtları buluyor ve siliyoruz--->
        	<cfif SHIP_COLLECT_ID gt 0>
                <cfquery name="get_dispatch_ids" dbtype="query"> 
                    SELECT     
                        DISPATCH_SHIP_ID   
                    FROM         
                        get_ship_result_id
                    WHERE
                        SHIP_METHOD = #SHIP_METHOD# AND
                        DEPARTMENT_IN = #DEPARTMENT_IN# AND
                        SHIP_COLLECT_ID <> #SHIP_COLLECT_ID#
          		</cfquery>          
            	<cfif get_dispatch_ids.recordcount>       	
        			<cfset dispatch_ship_id_list = ValueList(get_dispatch_ids.DISPATCH_SHIP_ID)>
                    <cfquery name="del_dispatch_ids" datasource="#dsn3#">
                    	DELETE FROM 
                        	PRTOTM_DISPATCH_SHIP_COLLECT
						WHERE     
                        	SHIP_RESULT_ID IN (#dispatch_ship_id_list#)
                    </cfquery>
                    <cfloop list="#dispatch_ship_id_list#" index="i">
                        <cfquery name="add_dispatch_ids" datasource="#dsn3#">
                            INSERT INTO 
                                PRTOTM_DISPATCH_SHIP_COLLECT
                                (
                                    SHIP_RESULT_ID, 
                                    SHIP_COLLECT_ID, 
                                    CONTROL_FLAG
                                )
                            VALUES     
                                (
                                   	#i#,
                                    #SHIP_COLLECT_ID#,
                                    0
                                )
                        </cfquery>
                	</cfloop>
                </cfif>
        	<cfelse> <!---Birleşecek ID ler içinde 0 varsa yani Hiç birleşmiş yoksa--->
            	<cfquery name="get_dispatch_ids" dbtype="query"> 
                    SELECT     
                        DISPATCH_SHIP_ID   
                    FROM         
                        get_ship_result_id
                    WHERE
                        SHIP_METHOD = #SHIP_METHOD# AND
                        DEPARTMENT_IN = #DEPARTMENT_IN# 
          		</cfquery>
                <cfset dispatch_ship_id_list = ValueList(get_dispatch_ids.DISPATCH_SHIP_ID)>
            	<cfloop list="#dispatch_ship_id_list#" index="i">
                	<cfquery name="add_dispatch_ids" datasource="#dsn3#">
                    	INSERT INTO 
                       		PRTOTM_DISPATCH_SHIP_COLLECT
                          	(
                              	SHIP_RESULT_ID, 
                              	SHIP_COLLECT_ID, 
                             	CONTROL_FLAG
                        	)
                     	VALUES     
                         	(
                           		#i#,
                              	#LAST_SHIP_COLLECT_ID#,
                             	0
                      		)
                 	</cfquery>
            	</cfloop>
                <cfset LAST_SHIP_COLLECT_ID = LAST_SHIP_COLLECT_ID +1>
            </cfif>
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
