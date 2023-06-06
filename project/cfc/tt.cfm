<cfquery name="getTree" datasource="#dsn3#">
    <cfif arguments.isVirtual eq 1>
        SELECT *,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0
    <cfelse>
        select *,0 AS IS_VIRTUAL from PRODUCT_TREE WHERE STOCK_ID=#arguments.pid# 
    </cfif>
</cfquery>       
<cfsavecontent variable="myV">
    [
        <cfloop query="getTree">
            <cfset say=say+1>
            <cfset O=structNew()>
            <cfset O.IS_VIRTUAL=IS_VIRTUAL>
            <cfset O.VIRTUAL_PRODUCT_TREE_ID=0>
            <CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn3#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#
                <cfelse>
                    SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
                </cfif>
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.PRODUCT_NAME=getSInfo.STOCK_ID>
            <cfset O.AMOUNT=AMOUNT>
           
            <cfquery name="ishvTree" datasource="#dsn3#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#
                <cfelse>
                    SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#
                </cfif>
            </cfquery>
             <cfif O.IS_VIRTUAL EQ 1>
             <CFSET O.STOCK_ID=0>
                <cfelse>
                <CFSET O.STOCK_ID=0>
             </cfif>
            <cfoutput>
                {
                    "PRODUCT_ID":#O.PRODUCT_ID#,
                    "PRODUCT_NAME":"#O.PRODUCT_NAME#",
                    "AMOUNT":#O.AMOUNT#,
                    "IS_VIRTUAL":"#O.IS_VIRTUAL#",
                    "VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,
                    "PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#",
                    "QUESTION_ID":"#QUESTION_ID#",
                    "RNDM_ID":#GetRndmNmbr()#,
                    "AGAC":
                        <cfif ishvTree.recordCount>
                            <cfscript>
                                writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3))
                            </cfscript>
                        <cfelse>
                            ""
                        </cfif>
                    ,"ASDF":#say#
                },
            </cfoutput>
        </cfloop>
    ]
</cfsavecontent>