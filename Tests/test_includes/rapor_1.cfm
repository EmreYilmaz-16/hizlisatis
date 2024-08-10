<cfquery name="getc" datasource="#dsn#">
    select TOP 100 NICKNAME,C.COMPANY_ID,TT.* from workcube_metosan.COMPANY as C
OUTER APPLY(
    SELECT SUM(ISNULL(BR,0)) ALACAK,SUM(ISNULL(AR,0)) BORC,CONVERT(DECIMAL(18,2),SUM(ISNULL(AR,0)-ISNULL(BR,0))) AS BAKIYE,
CASE WHEN SUM(ISNULL(BR,0))>SUM(ISNULL(AR,0)) THEN 'A' ELSE 'B' END AS BA
 FROM (
SELECT 
ISNULL(FROM_CMP_ID,TO_CMP_ID) CMP,
CASE WHEN FROM_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS BR,
CASE WHEN TO_CMP_ID IS NOT NULL THEN SUM(ACTION_VALUE) END AS AR

 FROM workcube_metosan_2024_1.CARI_ROWS WHERE FROM_CMP_ID=C.COMPANY_ID OR TO_CMP_ID=C.COMPANY_ID
 GROUP BY FROM_CMP_ID,TO_CMP_ID

) AS TF
) AS TT 
where COMPANY_ID=13205
</cfquery>

<cfdump var="#getc#">


<CFSET SIRA=1>    <cfoutput>
<cfloop query="getc">
    <table>
        <tr>
            <td>
                Belge No
            </td>
            <td>
                Belge Tutarı
            </td>
            <td>
                Kapanan
            </td>
            <td>
                AF
            </td>
            <TD>
                SF
            </TD>
        </tr>
    
    
<cfquery name="GETA" datasource="#DSN2#">
    SELECT * FROM CARI_ROWS WHERE FROM_CMP_ID=#getc.COMPANY_ID# ORDER BY ACTION_DATE ASC
</cfquery>
<CFSET AF=0>
<CFSET SF=0>
<CFLOOP from="1" to="#GETA.recordCount#" index="I">
    <CFSET AF=AF+GETA.ACTION_VALUE[I]>



    
<cfquery name="GETS" datasource="#DSN2#">
    SELECT * FROM CARI_ROWS WHERE TO_CMP_ID=#getc.COMPANY_ID# ORDER BY ACTION_DATE ASC
</cfquery>
<cfloop from="1" to="#GETS.recordCount#" index="J">
<CFSET SF=SF+GETS.ACTION_VALUE[J]>

<CFIF AF GT SF>
    <CFSET KT=SF>
    <CFSET AF=AF-SF>
<CFELSE>
<CFSET KT=AF>
<CFSET SF=SF-AF>


</CFIF>
<tr>
    <td>
        #GETS.PAPER_NO[J]#
    </td>
    <td>
        #GETS.ACTION_VALUE[J]#
    </td>
    <td>
        #KT#
    </td>
    <td>#AF#</td>
    <TD>
        #SF#
    </TD>
</tr>
 <cfif AF gt SF>
    <cfcontinue>
 </cfif>

</cfloop>



</CFLOOP>








</table>
</cfloop>
</cfoutput>
