<cfquery name="getWork" datasource="#dsn#">
    select 
WORK_HEAD,
WORK_DETAIL,
PWH.UPDATE_DATE,
workcube_metosan.getEmployeeWithId(PROJECT_EMP_ID) PROJECT_EMP_ID,
workcube_metosan.getEmployeeWithId(UPDATE_AUTHOR) UPDATE_AUTHOR,
WORK_CURRENCY_ID,
PWH.WORK_CAT_ID,
WORK_PRIORITY_ID ,
SP.PRIORITY,
SP.COLOR,
PWC.WORK_CAT
from workcube_metosan.PRO_WORKS_HISTORY AS PWH
LEFT JOIN workcube_metosan.SETUP_PRIORITY AS SP ON SP.PRIORITY_ID=PWH.WORK_PRIORITY_ID
LEFT JOIN workcube_metosan.PRO_WORK_CAT AS PWC ON PWC.WORK_CAT_ID=PWH.WORK_CAT_ID
where WORK_ID=#attributes.WORK_ID# order by UPDATE_DATE
</cfquery>

<cf_box title="#getWork.WORK_HEAD#">
    <h4>Detay</h4>
    <div>
        #getWork.WORK_DETAIL#
    </div>
    <cfset iss=1>
<cfloop query="getWork">
    <cfif iss neq 1>
    <div style="display:flex;border-bottom:solid 1px gray">
    <div style="display: flex;margin-top: 5px;flex-direction: row;align-content: space-between;align-items: center">
        <div style="width:20px;border:solid 0.5px black;"><cfset str=""><cfloop list="#UPDATE_AUTHOR#" item="it" index="i" delimiters=" "><cfset str="#str##left(it,1)#"></cfloop><cfoutput>#str#</cfoutput></div>
        <span style="font-weight:bold">&gt;</span>
        <div style="border:solid 0.5px black;border-radius:5px"><cfset str=""><cfloop list="#PROJECT_EMP_ID#" item="it" index="i" delimiters=" "><cfset str="#str##left(it,1)#"></cfloop><cfoutput>#str#</cfoutput></div>
    </div>
    <div >
    <cfoutput>#WORK_DETAIL#</cfoutput>
</div>
</div>
    </cfif>
    <cfset iss=iss+1>
</cfloop>

</cf_box>

