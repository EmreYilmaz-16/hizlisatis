<cfquery name="getD" datasource="#dsn3#">
    SELECT * FROM workcube_metosan.PRTOTM_PDA_DEPARTMENT_DEFAULTS
</cfquery>
<cfquery name="GETDETTA" datasource="#DSN#">
    SELECT CONVERT(VARCHAR,SL.DEPARTMENT_ID)+'_'+CONVERT(VARCHAR,SL.LOCATION_ID) AS D_ID,SL.COMMENT,D.DEPARTMENT_HEAD,D.DEPARTMENT_ID,SL.LOCATION_ID FROM workcube_metosan.STOCKS_LOCATION AS SL
LEFT JOIN DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID

</cfquery>
<cfloop query="GETDETTA">
    <CFSET "DEPO.DEP_#DID#"="#DEPARTMENT_HEAD# #COMMENT#">
</cfloop>
<cfdump var="#DEPO#">
<cf_big_list>
    <cfoutput>
        <cfloop query="getD">
            <CFSET D_1=listGetAt(DEFAULT_MK_TO_RF_DEP,1)>
            <CFSET D_2=listGetAt(DEFAULT_MK_TO_RF_DEP,2)>
            <CFSET L_1=listGetAt(DEFAULT_MK_TO_RF_LOC,1)>
            <CFSET L_2=listGetAt(DEFAULT_MK_TO_RF_LOC,2)>
            <cfset dl_1="#D_1#_#L_1#">
            <cfset dl_2="#D_2#_#L_2#">
            <tr>
                <td>
                    #evaluate("DEPO.DEP_#dl_1#")#
                </td>
                <td>
                    #evaluate("DEPO.DEP_#dl_2#")#
                </td>
                <CFSET D_1="">
                <CFSET D_2="">
                <CFSET L_1="">
                <CFSET L_2="">
                <CFSET D_1=listGetAt(DEFAULT_RF_TO_SV_DEP,1)>
                <CFSET D_2=listGetAt(DEFAULT_RF_TO_SV_DEP,2)>
                <CFSET L_1=listGetAt(DEFAULT_RF_TO_SV_LOC,1)>
                <CFSET L_2=listGetAt(DEFAULT_RF_TO_SV_LOC,2)>
                <cfset dl_1="#D_1#_#L_1#">
                <cfset dl_2="#D_2#_#L_2#">
                <td>
                    #evaluate("DEPO.DEP_#dl_1#")#
                </td>
                <td>
                    #evaluate("DEPO.DEP_#dl_2#")#
                </td>
            </tr>
        </cfloop>
    </cfoutput>
</cf_big_list>
