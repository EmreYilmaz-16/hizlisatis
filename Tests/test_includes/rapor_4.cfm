<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=det&repot_id=#attributes.report_id#">
    <div class="form-group">
        <label>Masraf Fişi No</label>
            <input type="text" name="SerialNo">
        
    </div>
    <input type="submit">
    <input type="hidden" name="is_submit">

</cfform>

<cfif isDefined("attributes.is_submit")>

    <cfquery name="getd" datasource="#dsn#">
SELECT SERIAL_NO,PAPER_NO,TS.*
FROM workcube_metosan_2024_1.EXPENSE_ITEM_PLANS
LEFT JOIN (
	SELECT CCBE.DETAIL
		,EXPENSE_ID
		,(
			SELECT CCBER.INSTALLMENT_DETAIL
				,CONVERT(DECIMAL(18, 2), CCBER.INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT
				,CCBER.ACC_ACTION_DATE
				,(
					SELECT CONVERT(DECIMAL(18, 2), CLOSED_AMOUNT) CLOSED_AMOUNT
						,BANK_ACTION_ID
						,(
							SELECT PAPER_NO
							FROM workcube_metosan_2024_1.BANK_ACTIONS AS BA
							WHERE BA.ACTION_ID = CCBERR.BANK_ACTION_ID
							) PAPERNO
					FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE_RELATIONS AS CCBERR
					WHERE CC_BANK_EXPENSE_ROWS_ID = CCBER.CC_BANK_EXPENSE_ROWS_ID
					FOR JSON PATH
					) RELATIONS
			FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE_ROWS AS CCBER
			WHERE CCBER.CREDITCARD_EXPENSE_ID = CCBE.CREDITCARD_EXPENSE_ID
			FOR JSON PATH
			) JS
	FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE CCBE
	) AS TS
	ON TS.EXPENSE_ID = EXPENSE_ITEM_PLANS.EXPENSE_ID
WHERE PAPER_NO LIKE '%#attributes.SerialNo#%' OR SERIAL_NO LIKE '%#attributes.SerialNo#%'

</cfquery>
<cfoutput query="getd">
    <h3>#PAPER_NO#</h3>
    <cfset DXXX=deserializeJSON(getd.JS)>
<cfloop array="#DXXX#" item="item">
    <table>
        <tr>
            <td>
                #item.INSTALLMENT_DETAIL#
            </td>
            <td>
                #item.INSTALLMENT_AMOUNT#
            </td>
            <td>
                #item.ACC_ACTION_DATE#
            </td>
            
        </tr>
        <tr>
            <td colspan="3">
                İlişkiler
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <cfset DYYYY=item.RELATIONS>
                <table>
                <cfloop array="#DYYYY#" item="item2">
                    <tr>
                        <td>
                            #item2.PAPERNO#
                        </td>
                        <td>
                            #item2.CLOSED_AMOUNT#
                        </td>
                    </tr>
                </cfloop>
            </table>
            </td>
        </tr>
    </table>
</cfloop>
</cfoutput>


</cfif>