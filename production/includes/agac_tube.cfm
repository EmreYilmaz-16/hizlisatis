<cfoutput>
<cfloop query="getsTree">
	<cfset "Eleman#QUESTION_ID#.STOCK_ID"=STOCK_ID>
	<cfset "Eleman#QUESTION_ID#.PRODUCT_NAME"=PRODUCT_NAME>
	<cfset "Eleman#QUESTION_ID#.AMOUNT"=AMOUNT>
	<cfset "Eleman#QUESTION_ID#.MAIN_UNIT"=MAIN_UNIT>
</cfloop>
<CFLOOP query="getQUESTIONS">
	<tr>
		<th style="text-align:left;">
			#QUESTION#
		</th>					
		<cfif isDefined("Eleman#QUESTION_ID#.STOCK_ID")>
		<td>#evaluate("Eleman#QUESTION_ID#.PRODUCT_NAME")#</td>
		<td><cfif QUESTION_ID eq 2>#evaluate("Eleman#QUESTION_ID#.AMOUNT")*1000#<cfelse>#evaluate("Eleman#QUESTION_ID#.AMOUNT")#</cfif></td>
		<td>#evaluate("Eleman#QUESTION_ID#.MAIN_UNIT")#</td>
		<cfelse>				
		<td></td>
		<td></td>
		<td></td>
		</cfif>

	</tr>
</CFLOOP>
</cfoutput>