<cf_box title="Sevk Kontrol">
    <cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
        <div class="form-group">
            <input type="text" placeholder="SVK Numarası" id="svk_number" name="svk_number">
            
        </div>
        <input type="hidden" name="is_submit">
        <input type="submit">
    </cfform>
</cf_box>

<cfif isDefined("attributes.is_submit")>
    <cfquery name="getS" datasource="#dsn2#">
       
       SELECT FIS_NUMBER,FIS_DATE,FIS_ID,LOCATION_OUT,DEPARTMENT_OUT,workcube_metosan.getEmployeeWithId(SF.RECORD_EMP) AS RECORD_EMP ,SL.COMMENT,D.DEPARTMENT_HEAD

FROM workcube_metosan_2023_1.STOCK_FIS AS SF 
INNER JOIN workcube_metosan.STOCKS_LOCATION AS SL ON SL.LOCATION_ID=SF.LOCATION_OUT AND SL.DEPARTMENT_ID=SF.DEPARTMENT_OUT
INNER JOIN workcube_metosan.DEPARTMENT AS D ON D.DEPARTMENT_ID=SL.DEPARTMENT_ID  WHERE REF_NO='#attributes.svk_number#'
    </cfquery>
    <table>
        <cfoutput query="getS">
            <tr>
                <td><a href="##">#FIS_NUMBER#</a></td>
                <td>#dateFormat(FIS_DATE,"dd/mm/yyyy")#</td>
                <td>#DEPARTMENT_HEAD#-#COMMENT#</td>
                <td>#RECORD_EMP#</td>
                
            </tr>
        </cfoutput>
    </table>
</cfif>