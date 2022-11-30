

<cfquery name="getCompany" datasource="#dsn#">
    SELECT * FROM COMPANY AS C
     WHERE 1=1 AND (
        LOWER(NICKNAME) LIKE '%#lCase(attributes.keyword)#%' OR
        LOWER(FULLNAME) LIKE '%#lCase(attributes.keyword)#%' OR
        LOWER(MEMBER_CODE) LIKE '%#lCase(attributes.keyword)#%' 
    )
</cfquery>


<cf_ajax_list>
    <cfoutput query="getCompany">
        <tr>
            <td>
                <a href="javascript://" onclick="setCompany(#COMPANY_ID#,'#NICKNAME#')"> #NICKNAME#</a>
            </td>
        </tr>
    </cfoutput>
</cf_ajax_list>

