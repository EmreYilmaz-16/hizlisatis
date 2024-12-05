<cfform method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&event=det&report_id=#attributes.report_id#">
    <div class="form-group">
        <label>Belge No</label>
            <input type="text" name="SerialNo">
        
    </div>
    <div class="form-group">
        <label>Sorgu Tipi</label>
        <select name="qtyp">
            <option value="1">Banka Hareketi</option>
            <option value="2">Masraf Fişi</option>
        </select>
    </div>
    <input type="submit">
    <input type="hidden" name="is_submit">

</cfform>

<cfif isDefined("attributes.is_submit")>
<cfif attributes.qtyp eq "2">

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
<div style="width:50%">
<cfoutput query="getd">
    
    <cfset DXXX=deserializeJSON(getd.JS)>
<cfloop array="#DXXX#" item="item">
    <cf_grid_list>
        <thead>
            <tr>
                <th colspan="3">#PAPER_NO#</th>
            </tr>
            <tr>
                <th>
                    Taksit
                </th>
                <th>
                    Taksit Tutarı
                </th>
                <th>
                    Taksit Tarihi                    
                </th>
            </tr>
        </thead>
        <tbody>
        <tr>
            <td>
                #item.INSTALLMENT_DETAIL#
            </td>
            <td>
                #item.INSTALLMENT_AMOUNT#
            </td>
            <td>
                #dateformat(item.ACC_ACTION_DATE,"dd/mm/yyyy")#
            </td>
            
        </tr>
        <tr>
            <td colspan="3">
                İlişkiler
            </td>
        </tr>
        <cftry><tr>
          
            <td colspan="3">
                <cfset DYYYY=item.RELATIONS>
                <cf_grid_list>
                <thead>
                    <tr>
                        <th>
                            Banka Hareketi No
                        </th>
                        <th>
                            Kapanan Miktar
                        </th>
                    </tr>
                </thead>
                <tbody>
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
            </tbody>
            </cf_grid_list>
            </td>
        
        </tr>
    <cfcatch></cfcatch>
    </cftry>
</tbody>
    </cf_grid_list>
</cfloop>
</cfoutput>
</cfif>
<cfif attributes.qtyp eq "1">
    <cfdump var="#attributes#">
    <cfquery name="getd" datasource="#dsn2#">
        SELECT ACTION_ID
	,ACTION_TYPE
	,PAPER_NO
	,ACTION_VALUE
	,(
		SELECT CONVERT(DECIMAL(18, 2), CLOSED_AMOUNT) CLOSED_AMOUNT
			,(
				SELECT CONVERT(DECIMAL(18, 2), INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT
					,INSTALLMENT_DETAIL
					,(
						SELECT PAPER_NO
							,EXPENSE_ID
							,(
								SELECT PAPER_NO
									,CONVERT(DECIMAL(18,2),TOTAL_AMOUNT_KDVLI) TOTAL_AMOUNT_KDVLI
								FROM workcube_metosan_2024_1.EXPENSE_ITEM_PLANS
								WHERE EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.EXPENSE_ID
								FOR JSON PATH
								) AS EXMEX
						FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE
						WHERE CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID
						FOR JSON PATH
						) AS EXPENSE
				FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE_ROWS
				WHERE CC_BANK_EXPENSE_ROWS_ID = CR.CC_BANK_EXPENSE_ROWS_ID
				FOR JSON PATH
				) AS ROWS
		FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE_RELATIONS CR
		WHERE BANK_ACTION_ID = BA.ACTION_ID
		FOR JSON PATH
		) AS TK
FROM workcube_metosan_2024_1.BANK_ACTIONS BA
WHERE PAPER_NO='#attributes.SerialNo#'
    </cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th>
                Belge No
            </th>
            <th>
                Belge Tipi
            </th>
            <th>
                Belge Tutarı
            </th>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="getd">
        <tr>
            <td>
                #PAPER_NO#
            </td>
            <td>
                #ACTION_TYPE#
            </td>
            <td>
                #tlformat(ACTION_VALUE)#
            </td>
        </tr>
        <tr>
            <td colspan="3">
             
                <cf_grid_list>
                <cfset dddd=deserializeJSON(getd.TK)>
                <cfloop array="#dddd#" item="i">
                    
                        <cfset ddddy=i.ROWS>
                        <cfloop array="#ddddy#" item="i2">
                            <tr>
                                <td>
                                    #i2.INSTALLMENT_DETAIL#
                                </td>
                            </tr>
                            
                                <tr>
                                    <td colspan="3">
                                        <cf_grid_list>
                                            <tr>
                                                <td>
                                                    #i.CLOSED_AMOUNT#
                                                </td>
                                                <td>
                                                    #i2.INSTALLMENT_DETAIL#
                                                </td>
                                                <td>
                                                    #i2.INSTALLMENT_AMOUNT#
                                                </td>
                                                <td><cftry>
                                                    #i2.EXPENSE[1].PAPER_NO#
                                                    <cfcatch></cfcatch>
                                                </cftry></td>
                                            </tr>
                                        </cf_grid_list>
                                    </td>
                                
                                </tr>
                            
                        </cfloop>
                    
                </cfloop>
             </cf_grid_list>
             
                <!------<table>
                    <cfset dddd=deserializeJSON(getd.TK)>
                    <cfdump var="#dddd#">
                  <cftry>  <cfset ddddY=dddd.ROWS><cfcatch><cfset ddddY=arrayNew(1)></cfcatch></cftry>
                    <tr>
                        <cftry><td>#dddd.CLOSED_AMOUNT#</td><cfcatch><td colspan="3"></td></cfcatch></cftry>
                    </tr>
                    <CFLOOP array="#ddddY#" item="i2">
                        <tr>
                            <td>#i2.INSTALLMENT_AMOUNT#</td>
                            <td>#i2.INSTALLMENT_DETAIL#</td>
                            <cftry><td>#i2.EXPENSE[1].PAPER_NO#</td><cfcatch><td></td></cfcatch></cftry>
                        </tr>
                        
                    </CFLOOP>
SELECT ACTION_DATE,PAPER_NO,CREDITCARD_EXPENSE_ID,
(SELECT *,workcube_metosan_1.GET_BANKA_HAREKETI_WITH_ROW_ID(CC_BANK_EXPENSE_ROWS_ID) AS TF


FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID=CE.CREDITCARD_EXPENSE_ID FOR JSON PATH)

 FROM workcube_metosan_1.CREDIT_CARD_BANK_EXPENSE CE WHERE PAPER_NO='BKKO-161'
                </table>------>
            </td>
        </tr>
    </cfoutput>
</tbody>
</cf_grid_list>

</cfif>
</div>



</cfif>