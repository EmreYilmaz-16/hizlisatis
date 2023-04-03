<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&page=5">
    <div class="form-group">
        <input type="text" name="svk_no" id="svk_no" value="SVK-14446">
        <input type="hidden" name="is_submit">
    </div>
</cfform>

<cfif isDefined("attributes.is_submit")>
    <cfquery name="getKontrol" datasource="#dsn3#">
      
SELECT 
SF.FIS_NUMBER,
SF.DEPARTMENT_OUT,
SF.LOCATION_OUT,
SF.FIS_DATE,
SL.COMMENT,
D.DEPARTMENT_HEAD,
workcube_metosan.getEmployeeWithId(SF.RECORD_EMP) AS RECORD_EMP,
SF.RECORD_EMP AS RECORD_EMP_ID 
FROM STOCK_FIS  AS SF
LEFT JOIN workcube_metosan.STOCKS_LOCATION AS  SL ON SL.LOCATION_ID=SF.LOCATION_OUT AND SL.DEPARTMENT_ID=SF.DEPARTMENT_OUT
LEFT JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SF.DEPARTMENT_OUT
 WHERE SF.REF_NO='#attributes.svk_no#'        
    </cfquery>
    <cf_big_list>
        <cfoutput query="getKontrol">
            <tr>
                <td>#FIS_NUMBER#</td>
                <td>#FIS_NUMBER#</td>
                <td>#dateFormat(FIS_DATE,"dd/mm/yyyy")#</td>
                <td>#RECORD_EMP#</td>
                <td>#DEPARTMENT_HEAD# #COMMENT#</td>

            </tr>
        </cfoutput>
    </cf_big_list>
</cfif>