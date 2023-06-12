
<cfset FormData=deserializeJSON(attributes.data)>

<cfset attributes.type_id=FormData.company_id>
<cfset attributes.q_type="CompanyInfo">
<cfinclude template="../includes/getCompInfoQuery.cfm">

<cfset FirmaDatasi=InfoArray[1]>

<script>
    $(document).ready(function(){
        <cfoutput>
            setCompany(#FirmaDatasi.COMPANY_ID#, '#FirmaDatasi.FULLNAME#',#FirmaDatasi.MANAGER_PARTNER_ID#,'#FirmaDatasi.MANAGER#')       
        
        <cfif FirmaDatasi.PAYMETHOD_ID neq 0 and len(FirmaDatasi.PAYMETHOD_ID)>
            var pm=generalParamsSatis.PAY_METHODS.filter(p=>p.PAYMETHOD_ID==#FirmaDatasi.PAYMETHOD_ID#);
            setOdemeYontem(pm[0].PAYMETHOD_ID, pm[0].PAYMETHOD, pm[0].DUE_DAY)
        </cfif>
        <cfif FirmaDatasi.SHIP_METHOD_ID neq 0 and len(FirmaDatasi.SHIP_METHOD_ID)>
            var sm=generalParamsSatis.SHIP_METHODS.filter(p=>p.SHIP_METHOD_ID==#FirmaDatasi.SHIP_METHOD_ID#)
            setSevkYontem(sm[0].SHIP_METHOD_ID, sm[0].SHIP_METHOD)
        </cfif>
    </cfoutput>
    })
</script>