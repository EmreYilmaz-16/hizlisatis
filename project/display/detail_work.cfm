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

<span style="border-radius: 10px;background-color:white;padding: 5px 10px 15px 10px;width:75%" id="scrollList">
    <div style="display:flex;flex-direction: row;flex-wrap: nowrap;justify-content: flex-start;align-items: center;border-bottom:solid 1px orange">
        <h3 style="color:orange"><cfoutput>#getWork.WORK_HEAD#</cfoutput></h3>
        <button style="margin-left:auto" class="btn btn-danger" type="button" onclick="closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')"><span class="icn-md icon-times"></span></button>
    </div>
    <h4>Detay</h4>
    <div>
        <cfoutput>#getWork.WORK_DETAIL#</cfoutput>
    </div>
    <div>
        <div style="display:flex;justify-content: space-around;align-content: center;align-items: center;">
            <div style="width:68%">
                <cf_box title="Takipler" add_href='<cfoutput>openBoxDraggable("index.cfm?fuseaction=project.emptypopup_add_followup&work_id=#attributes.WORK_ID#")</cfoutput>'>
                <div style="height:25vh">
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
                </div>
                </cf_box>
     
            </div>
            <div style="width:28%">
                <cf_box title="ToDo">
                    <div style="height:25vh">
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
                    </div>
                </cf_box>
              
            </div>
        </div>
    </div>
    <cf_box id="comments"               
    title="#getLang('settings',859,'chat')#" 
    closable="0"
    add_href_size="wide"
    box_page="#request.self#?fuseaction=project.emptypopup_work_comment&id=#attributes.work_id#&height=30vh">					
</cf_box>


</span>