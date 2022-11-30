<!---<cfdump expand="yes" var="#attributes#">
<cfabort>--->
<cftransaction>
	<cfquery name="add_packing" datasource="#dsn3#">
    	INSERT INTO 
        	PRTOTM_PACKING
            (
            PACKING_NO, 
            RECORD_IP, 
            RECORD_EMP, 
            RECORD_DATE,
            TYPE,
            PERIOD_ID
            <cfif isdefined('attributes.ship_id')>
            ,SHIP_RESULT_ID
            </cfif>
            )
		VALUES     
        	(
            '#attributes.packet_number#',
            '#cgi.remote_addr#',
            #session.ep.userid#,
            #now()#,
            #attributes.type#,
            #session.ep.period_id#
            <cfif isdefined('attributes.ship_id')>
            ,#attributes.ship_id#
            </cfif>
            )
      	SELECT @@Identity AS MAX_ID      
		SET NOCOUNT OFF
    </cfquery>
    <cfloop list="#attributes.stock_id_list#" index="i">
    	<cfif Evaluate('attributes.control_amount#i#') gt 0>
            <cfquery name="add_packing_row" datasource="#dsn3#">
                INSERT INTO          	
                    PRTOTM_PACKING_ROW
                    (
                    PACKING_ID, 
                    AMOUNT,
                    STOCK_ID
                    )
                VALUES     
                    (
                    #add_packing.MAX_ID#,
                    #Evaluate('attributes.control_amount#i#')#,
                    #i#
                    )
            </cfquery>
       	</cfif>
    </cfloop>
</cftransaction>
<cflocation url="#request.self#?fuseaction=sales.popup_list_PRTOTM_packing_packets&ship_id=#attributes.ship_id#&deliver_paper_no=#attributes.deliver_paper_no#&type=#attributes.type#" addtoken="No">
