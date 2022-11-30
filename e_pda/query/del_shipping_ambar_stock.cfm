<cfquery name="get_stock_fis_id" datasource="#dsn2#">
 	SELECT        
   		SF.FIS_ID
	FROM            
      	STOCK_FIS AS SF INNER JOIN
      	STOCK_FIS_ROW AS SFR ON SF.FIS_ID = SFR.FIS_ID
	WHERE        
  		SF.REF_NO = '#attributes.ref_no#' AND 
        SFR.STOCK_ID = #attributes.f_stock_id# AND
        SF.DEPARTMENT_OUT = #ListGetAt(attributes.dep_out,1,"-")#  AND 
      	SF.LOCATION_OUT = #ListGetAt(attributes.dep_out,2,"-")#
</cfquery>
<cfset sil_fis_id = ValueList(get_stock_fis_id.FIS_ID)>
<cfif ListLen(sil_fis_id)>
    <cftransaction>
        <cflock timeout="60">
            <cfquery name="del_stock_fis" datasource="#dsn2#">
                DELETE FROM STOCK_FIS WHERE FIS_ID IN (#sil_fis_id#)
            </cfquery>
            <cfquery name="del_stock_fis_row" datasource="#dsn2#">
                DELETE FROM STOCK_FIS_ROW WHERE FIS_ID IN (#sil_fis_id#)
            </cfquery>
            <cfquery name="del_stock_row" datasource="#dsn2#">
                DELETE FROM STOCKS_ROW WHERE UPD_ID IN (#sil_fis_id#)
            </cfquery>
        </cflock>
    </cftransaction>
</cfif>
<cfif isdefined('type')>
	<cflocation url="#request.self#?fuseaction=pda.form_shipping_ambar_fis&date1=#attributes.date1#&date2=#attributes.date2#&department_in_id=#attributes.dep_in#&department_out_id=#attributes.dep_out#&date1=#attributes.date1#&date2=#attributes.date2#&keyword=#attributes.keyword#&is_type=#attributes.is_type#&deliver_paper_no=#attributes.ref_no#&ship_id=#attributes.ship_id#&f_stock_id=#attributes.f_stock_id#" addtoken="No">
</cfif>