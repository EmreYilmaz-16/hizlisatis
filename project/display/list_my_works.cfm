<link rel="stylesheet" href="/AddOns/Partner/project/content/project.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<cfinclude template="../includes/upperMenu.cfm">

<cfquery name="getProcess" datasource="#dsn#">
    SELECT * FROM #dsn#.PROCESS_TYPE_ROWS WHERE PROCESS_ID=19
</cfquery>
<div class="row">    
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
        <cf_box title="Görevlisi Olduğum İşler">
           <div class="row">
            <cfoutput query="getProcess">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="border-right: solid 1px ##E08283;">
                    <h3>#STAGE#</h3>
                    <cfquery name="W1" datasource="#dsn#">
    
                        SELECT WORK_ID
                            ,WORK_STATUS
                            ,RELATED_WORK_ID
                            ,WORK_HEAD
                            ,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
                            ,TARGET_START
                            ,TARGET_FINISH
                            ,TERMINATE_DATE
                            ,#dsn#.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
                            ,PTR.STAGE
                            ,RECORD_AUTHOR as RECORD_AUTHOR_ID
                            ,PROJECT_EMP_ID
                        FROM #dsn#.PRO_WORKS as PWH
                        LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
                        WHERE PROJECT_EMP_ID = #session.ep.userid# AND PWH.WORK_CURRENCY_ID=#PROCESS_ROW_ID#
                        </cfquery>
                       <cf_grid_list>
                        <thead>
                            <tr>
                                <th>
                                    ## 
                                </th>
                                <th>
                                    Görev
                                </th>
                                
                                <th>
                                    Termin Tarihi
                                </th>                             
                                <th>Atayan</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="W1">
                                <tr>
                                    <td>#WORK_ID#</td>
                                    <td>#WORK_HEAD#</td>                                    
                                    <td>#dateFormat(TERMINATE_DATE,"dd/mm/yyyy")#</td>                     
                                    <td>#RECORD_AUTHOR#</td>
                                    <td><span onclick="openBoxDraggable('#request.self#?fuseaction=project.emptypopup_work_detail_pbs&work_id=#WORK_ID#')" class="icn-md icon-search"></span></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </cf_grid_list>
                </div>
            </cfoutput>
        </div>
        </cf_box>
    </div>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
        <cf_box title="Atadığım İşler">
            <div class="row">
                <cfoutput query="getProcess">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="border-right: solid 1px ##E08283;">
                        <h3>#STAGE#</h3>
                        <cfquery name="W1" datasource="#dsn#">
        
                            SELECT WORK_ID
                                ,WORK_STATUS
                                ,RELATED_WORK_ID
                                ,WORK_HEAD
                                ,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
                                ,TARGET_START
                                ,TARGET_FINISH
                                ,TERMINATE_DATE
                                ,#dsn#.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
                                ,PTR.STAGE
                                ,RECORD_AUTHOR as RECORD_AUTHOR_ID
                                ,PROJECT_EMP_ID
                            FROM #dsn#.PRO_WORKS as PWH
                            LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
                            WHERE RECORD_AUTHOR = #session.ep.userid# AND PWH.WORK_CURRENCY_ID=#PROCESS_ROW_ID#
                            </cfquery>
                           <cf_grid_list>
                            <thead>
                                <tr>
                                    <th>
                                        ## 
                                    </th>
                                    <th>
                                        Görev
                                    </th>
                                    
                                    <th>
                                        Termin Tarihi
                                    </th>                             
                                    <th>Atanan</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop query="W1">
                                    <tr>
                                        <td>#WORK_ID#</td>
                                        <td>#WORK_HEAD#</td>                                    
                                        <td>#dateFormat(TERMINATE_DATE,"dd/mm/yyyy")#</td>                     
                                        <td>#PROJECT_EMP#</td>
                                        <td><span onclick="openBoxDraggable('#request.self#?fuseaction=project.emptypopup_work_detail_pbs&work_id=#WORK_ID#')" class="icn-md icon-search"></span></td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </cf_grid_list>
                    </div>
                </cfoutput>
            </div>
        </cf_box>
    </div>
</div>


<cfquery name="W1" datasource="#dsn#">
    
SELECT WORK_ID
	,WORK_STATUS
	,RELATED_WORK_ID
	,WORK_HEAD
	,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
	,TARGET_START
	,TARGET_FINISH
	,TERMINATE_DATE
	,#dsn#.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
    ,PTR.STAGE
	,RECORD_AUTHOR as RECORD_AUTHOR_ID
	,PROJECT_EMP_ID
FROM #dsn#.PRO_WORKS as PWH
LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
WHERE PROJECT_EMP_ID = #session.ep.userid#
</cfquery>
<cfquery name="W2" datasource="#dsn#">
    
    SELECT WORK_ID
        ,WORK_STATUS
        ,RELATED_WORK_ID
        ,WORK_HEAD
        ,#dsn#.getEmployeeWithId(PROJECT_EMP_ID) AS PROJECT_EMP
        ,TARGET_START
        ,TARGET_FINISH
        ,TERMINATE_DATE
        ,#dsn#.getEmployeeWithId(RECORD_AUTHOR) AS RECORD_AUTHOR
        ,PTR.STAGE
        ,RECORD_AUTHOR as RECORD_AUTHOR_ID
        ,PROJECT_EMP_ID
    FROM #dsn#.PRO_WORKS as PWH
    LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=PWH.WORK_CURRENCY_ID
    WHERE PROJECT_EMP_ID = #session.ep.userid#
    </cfquery>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>