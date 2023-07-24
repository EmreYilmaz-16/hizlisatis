<cfquery name="getWork" datasource="#dsn#">
    select 
WORK_HEAD,
WORK_DETAIL,
PWH.UPDATE_DATE,
#dsn#.getEmployeeWithId(PROJECT_EMP_ID) PROJECT_EMP_ID,
#dsn#.getEmployeeWithId(UPDATE_AUTHOR) UPDATE_AUTHOR,
WORK_CURRENCY_ID,
PWH.WORK_CAT_ID,
WORK_PRIORITY_ID ,
SP.PRIORITY,
SP.COLOR,
PWC.WORK_CAT
from #dsn#.PRO_WORKS_HISTORY AS PWH
LEFT JOIN #dsn#.SETUP_PRIORITY AS SP ON SP.PRIORITY_ID=PWH.WORK_PRIORITY_ID
LEFT JOIN #dsn#.PRO_WORK_CAT AS PWC ON PWC.WORK_CAT_ID=PWH.WORK_CAT_ID
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
        <div style="width:20px;border:solid 0.5px black,">
            <cfset llis=listLen(PROJECT_EMP_ID," ")>;
            <cfloop list="#llis#" item="it" index="i" delimiters=" ">
                <cfoutput>
                    #i#
                </cfoutput>
            </cfloop>
        </div>
    </cfif>
</cfloop>

</cf_box>