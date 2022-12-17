

<cfquery name="getCompany" datasource="#dsn#">
SELECT *,CP.PARTNER_ID PARTNER_ID_,CP.COMPANY_PARTNER_NAME,CP.COMPANY_PARTNER_SURNAME,C.COMPANY_STATUS,SC.CITY_NAME FROM COMPANY  AS C
LEFT JOIN COMPANY_PARTNER AS CP ON CP.PARTNER_ID=C.MANAGER_PARTNER_ID
LEFT JOIN workcube_metosan.SETUP_CITY AS SC ON SC.CITY_ID=C.CITY
     WHERE 1=1 AND (
        LOWER(C.NICKNAME) LIKE '%#lCase(attributes.keyword)#%' OR
        LOWER(C.FULLNAME) LIKE '%#lCase(attributes.keyword)#%' OR
        LOWER(C.MEMBER_CODE) LIKE '%#lCase(attributes.keyword)#%' 
    )
    
</cfquery>


<cf_ajax_list>
    <cfoutput query="getCompany">
        <tr>
            <td style="width:75%;white-space: normal;">
                <cfif COMPANY_STATUS EQ 1>
                <a href="javascript://" onclick="setCompany(#COMPANY_ID#,'#NICKNAME#',#PARTNER_ID_#,'#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#')"> #NICKNAME#</a>
                <cfelse>
                   <a onclick="ShowMessage(#COMPANY_ID#)"> #NICKNAME#</a>
            </cfif>
            </td>
            <td>#TAXNO#</td>
            <td>#CITY_NAME#</td>
            <td>
                <cfif COMPANY_STATUS EQ 1>
                    <div class="alert alert-success" style="padding:5px"><span class="icn-md fa fa-eye"></span></div>
                <cfelse>
                    <div class="alert alert-danger" style="padding:5px"><span class="icn-md fa fa-eye-slash"></span></div>
                </cfif>
            </td>
        </tr>
    </cfoutput>
</cf_ajax_list>

