<cfquery name="getVP" datasource="#dsn3#">
    SELECT * FROM (
        SELECT 
VP.PRODUCT_NAME,VP.VIRTUAL_PRODUCT_ID,PP.PROJECT_HEAD,PP.PROJECT_NUMBER,SMC.MAIN_PROCESS_CAT,ISNULL(PTR.STAGE,'Aşamasız') as STAGE,C.NICKNAME,
(select COUNT(*) from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=VP.VIRTUAL_PRODUCT_ID) AS PTW,
SMC.MAIN_PROCESS_CAT_ID
FROM workcube_metosan_1.VIRTUAL_PRODUCTS_PRT AS VP
INNER JOIN workcube_metosan.PRO_PROJECTS AS PP ON PP.PROJECT_ID=VP.PROJECT_ID
INNER JOIN workcube_metosan.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN workcube_metosan.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
LEFT JOIN workcube_metosan.COMPANY AS C ON C.COMPANY_ID =PP.COMPANY_ID
WHERE 1=1 <CFIF LEN(attributes.KeyWord_1)>
    AND PRODUCT_NAME LIKE '%#attributes.KeyWord_1#%'
</CFIF>
<CFIF LEN(attributes.KeyWord_2)>
    AND ( PROJECT_NUMBER LIKE '%#attributes.KeyWord_2#%' OR PROJECT_HEAD LIKE '%#attributes.KeyWord_2#%')
</CFIF>
<CFIF LEN(attributes.projectCatId)>
    AND  SMC.MAIN_PROCESS_CAT_ID=#attributes.projectCatId# 
</CFIF>) AS T
WHERE PTW>0
    </cfquery>
<cfoutput>
    <table class="table table-sm table-stripped">
        <tbody>
            <cfloop query="getVP">                
                <tr>
                    <td><a href="##" onclick='ngetTree(#VIRTUAL_PRODUCT_ID#,1,"#dsn3#",0,#attributes.type#,0,0,"",#attributes.idb#,2)'>#PRODUCT_NAME#</a></td>
                    <td>#PROJECT_HEAD#</td>
                    <td>#STAGE#</td>
                </tr>                
            </cfloop>
        </tbody>
    </table>
</cfoutput>