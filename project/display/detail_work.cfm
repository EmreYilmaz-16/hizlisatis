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

<cf_box title="İş: #getWork.WORK_HEAD#">
    <div style="">
        <div style="display:flex">
            <div style="width:70%">
                <cf_box title="Takipler">
                    <h4>Detay</h4>
                    <div>
                        <cfoutput>#getWork.WORK_DETAIL#</cfoutput>
                    </div>
                    <cfset iss=1>
                    <cfloop query="getWork">
                    <cfif iss neq 1>    
                        <table>
                            <tr>
                                <td>
                                    <div style="padding:5px;background:#ff000087;color:white;border-radius:25%"><cfset str=""><cfloop list="#UPDATE_AUTHOR#" item="it" index="i" delimiters=" "><cfset str="#str##left(it,1)#"></cfloop><cfoutput>#str#</cfoutput></div>
                                </td>
                                <td style="font-weight:bold">&gt;</td>
                                <td>
                                    <div style="border-radius:5px;padding:5px;background:#1c49d791;color:white;border-radius:25%"><cfset str=""><cfloop list="#PROJECT_EMP_ID#" item="it" index="i" delimiters=" "><cfset str="#str##left(it,1)#"></cfloop><cfoutput>#str#</cfoutput></div>
                                </td>
                                <td>
                                    <cfoutput>#WORK_DETAIL#</cfoutput>
                                </td>
                            </tr>
                        </table>                                 
                    </cfif>
                    <cfset iss=iss+1>
                    </cfloop>
                    
                </cf_box>
     
            </div>
            <div style="width:30%">
                <cf_box title="ToDo">
                        <cfquery name="getSteps" datasource="#dsn#">
                            select WORK_STEP_DETAIL,WORK_STEP_ID,WORK_STEP_COMPLETE_PERCENT from workcube_metosan.PRO_WORKS_STEP where WORK_ID=#attributes.work_id#
                        </cfquery>
                        <cf_ajax_list>
                            <cfoutput query="getSteps">
                                <tr>
                                    <td style="<cfif WORK_STEP_COMPLETE_PERCENT eq 1>text-decoration: line-through;color: gray<cfelse>color:black</cfif>">
                                        #URLDecode(WORK_STEP_DETAIL)#
                                    </td>
                                    <td>
                                     
                                    </td>
                                </tr>
                            </cfoutput>
                        </cf_ajax_list>
                </cf_box>
              
            </div>
        </div>
    </div>
    <cf_box id="comments"               
    title="#getLang('settings',859,'chat')#" 
    closable="0"
    add_href_size="wide"
    box_page="#request.self#?fuseaction=project.emptypopup_work_comment&id=#attributes.work_id#&height=20vh">					
</cf_box>
</cf_box>

