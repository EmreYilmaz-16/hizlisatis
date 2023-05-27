<cfcomponent>   
    <cfset dsn=application.systemparam.dsn>
    <cffunction name="getTree" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
            <cfargument name="product_id">
            <cfargument name="isVirtual">
            <cfargument name="ddsn3">
            <cfset TreeArr="">
            <cfif arguments.isVirtual eq 1>                
                <cfset TreeArr=getTrees(product_id,isVirtual,ddsn3)>
            <cfelse>               
                <cfset TreeArr=getTreeFromRealProduct(product_id,ddsn3)>
            </cfif>
            <cfreturn replace(TreeArr,"//","")>
        </cffunction>    
    <cffunction name="getTreeFromVirtual" >
        <cfargument name="product_id">        
        <cfquery name="getTree" datasource="#dsn#">
            SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTree">
            <cfset O=structNew()>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#        
                <cfelse>
                    SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#
                </cfif>
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfquery name="ishvTree" datasource="#dsn#">
                <cfif IS_VIRTUAL EQ 1>
                    SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#
                
                <cfelse>
                    SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#
                </cfif>
            </cfquery>
            <cfif ishvTree.recordCount>
                <cfif IS_VIRTUAL EQ 1>
                    <cfset O.Tree=getTreeFromVirtual(PRODUCT_ID)>
                <cfelse>
                    <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID)>
                </cfif>
            </cfif>
            <cfscript>
                arrayAppend(ReturnArr,O);
            </cfscript>
        </cfloop>
        <cfreturn ReturnArr>
    </cffunction>



    <cffunction name="getTreeFromRealProduct" >
        <cfargument name="product_id">
        <cfargument name="ddsn3"
        <cfquery name="getTreeFromVirtual" datasource="#dsn#">
            SELECT * FROM #arguments.ddsn3#.PRODUCT_TREE WHERE STOCK_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTree">
            <cfset O=structNew()>
            <cfset O.PRODUCT_ID=PRODUCT_ID>
            <cfquery name="getSInfo" datasource="#dsn#">              
                    SELECT * FROM #arguments.ddsn3#.STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#              
            </cfquery>
            <cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME>
            <cfset O.AMOUNT=AMOUNT>
            <cfset O.PRODUCT_TREE_ID=PRODUCT_TREE_ID>
            <cfquery name="ishvTree" datasource="#dsn#">            
                    SELECT * FROM #arguments.ddsn3#.PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#            
            </cfquery>
            <!----<cfif ishvTree.recordCount>              
                    <cfset O.Tree=getTreeFromRealProduct(PRODUCT_ID)>               
            </cfif>----->
            <cfscript>
                arrayAppend(ReturnArr,O);
            </cfscript>
        </cfloop>
        <cfreturn ReturnArr>
    </cffunction>

    <cffunction name="getTrees">
        <cfargument name="pid">
        <cfargument name="isVirtual">
        <cfargument name="ddsn3">        
        <cfset dsn3=arguments.ddsn3>
        <cfquery name="getTree" datasource="#dsn3#"><cfif arguments.isVirtual eq 1>SELECT *,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0<cfelse>select *,0 AS IS_VIRTUAL from PRODUCT_TREE WHERE STOCK_ID=#arguments.pid# </cfif></cfquery>       
      <cfset say=0> 
       <cfsavecontent variable="myV">[<cfloop query="getTree"><cfset say=say+1><cfset O=structNew()><cfset O.IS_VIRTUAL=IS_VIRTUAL><cfset O.VIRTUAL_PRODUCT_TREE_ID=0><CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID><cfset O.PRODUCT_ID=PRODUCT_ID><cfquery name="getSInfo" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#<cfelse>SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#</cfif></cfquery><cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME><cfset O.AMOUNT=AMOUNT><cfquery name="ishvTree" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#<cfelse>SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#</cfif></cfquery><cfoutput>{"PRODUCT_ID":#O.PRODUCT_ID#,"PRODUCT_NAME":"#O.PRODUCT_NAME#","AMOUNT":#O.AMOUNT#,"IS_VIRTUAL":"#O.IS_VIRTUAL#","VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,"PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#","QUESTION_ID":"#QUESTION_ID#","RNDM_ID":#GetRndmNmbr()#,"AGAC":<cfif ishvTree.recordCount><cfscript>writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3))</cfscript><cfelse>""</cfif>,"ASDF":#say#},</cfoutput></cfloop>]</cfsavecontent>
    <cfreturn trim(myV)>
    </cffunction>

    <cffunction name="GetRndmNmbr">
        <cfscript>
               num1 = 0;
               num2 = 100000;
               randAlgorithmArray = ["CFMX_COMPAT", "SHA1PRNG", "IBMSecureRandom"];
            retrunNumber=randRange(num1, num2, randAlgorithmArray[1]) ;
             
        </cfscript>
        <cfreturn retrunNumber>
        </cffunction>
</cfcomponent>