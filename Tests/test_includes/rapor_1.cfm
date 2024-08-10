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
--where COMPANY_ID=13205
</cfquery>
<cf_big_list>
    <thead>
    <tr>
        <th>
            Cari
        </th>
        <th>
            Borç
        </th>
        <th>
            Alacak
        </th>
        <th>
            Bakiye
        </th>
        <th>
            B/A
        </th>
        <th>
            Ortalama Ödeme Vade
        </th>
    </tr>


</thead>
<tbody>
<cfoutput query="getc">
    <tr>
        <td>
            #NICKNAME#
        </td>
        <td>
            #BORC#
        </td>
        <td>
            #ALACAK#
        </td>
        <td>
            #BAKIYE#
        </td>
        <td>
            #BA#
        </td>
        <td>
            <cfset attributes.date1="01/01/#year(now())#">
            <cfset attributes.date2="31/12/#year(now())#">
            <cfset attributes.company_id=COMPANY_ID>
            <cfinclude template="/V16/objects/display/dsp_make_age_pbs.cfm">
        </td>
    </tr>
</cfoutput>
</tbody>
</cf_big_list>