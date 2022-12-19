

<cfquery name="getCompany" datasource="#dsn#">
SELECT C.COMPANY_ID,C.NICKNAME,CP.PARTNER_ID,CP.COMPANY_PARTNER_NAME,CP.COMPANY_PARTNER_SURNAME,SC.CITY_NAME,C.COMPANY_STATUS,C.IS_PERSON,CP.PARTNER_ID,
CASE WHEN C.IS_PERSON =1 THEN CP.TC_IDENTITY ELSE C.TAXNO END AS TAX_NO
FROM #dsn#.COMPANY  AS C
LEFT JOIN #dsn#.COMPANY_PARTNER AS CP ON CP.PARTNER_ID=C.MANAGER_PARTNER_ID
LEFT JOIN #dsn#.SETUP_CITY AS SC ON SC.CITY_ID=C.CITY
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
                    <div class="alert alert-success" style="padding:5px;margin-bottom:1px"><span class="icn-md fa fa-eye"></span></div>
                <cfelse>
                    <div class="alert alert-danger" style="padding:5px;margin-bottom:1px"><span class="icn-md fa fa-eye-slash"></span></div>
                </cfif>
            </td>
        </tr>
    </cfoutput>
</cf_ajax_list>

