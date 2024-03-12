﻿<cfquery name="getsTree" datasource="#dsn3#">
select AMOUNT,QUESTION_ID,S.PRODUCT_CODE,S.PRODUCT_NAME,PU.MAIN_UNIT from workcube_metosan_1.PRODUCT_TREE   AS PT 
INNER JOIN workcube_metosan_1.STOCKS AS S ON S.STOCK_ID=PT.RELATED_ID
INNER JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND IS_MAIN=1
  WHERE STOCK_ID=#gets.STOCK_ID#
</cfquery>
<cfdump var="#getPo#">
<cfdump var="#gets#">
<cf_big_list>
<cfoutput query="getsTree">
    <tr>
        <td>
            #PRODUCT_CODE#
        </td>
        <td>
            #PRODUCT_NAME#
        </td>
        <td>
            #AMOUNT#
        </td>
        <td>
            #MAIN_UNIT#
        </td>
    </tr>
</cfoutput>
</cf_big_list>