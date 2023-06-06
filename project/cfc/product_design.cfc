<cfcomponent>   
    <cfset dsn=application.systemparam.dsn>
    <cffunction name="getTree" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
            <cfargument name="product_id">
            <cfargument name="isVirtual">
            <cfargument name="ddsn3">
            <cfargument name="company_id">
            <cfargument name="price_catid">
            <cfset TreeArr="">
            <cfif arguments.isVirtual eq 1>                
                <cfset TreeArr=getTrees123(product_id,isVirtual,ddsn3,product_id,company_id,price_catid)>
            <cfelse>               
                <cfset TreeArr=getTrees123(product_id,0,ddsn3,product_id,company_id,price_catid)>
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
        <cfargument name="ddsn3">
        <cfquery name="getTreeFromVirtual" datasource="#dsn#">
            SELECT * FROM #arguments.ddsn3#.PRODUCT_TREE WHERE STOCK_ID=#arguments.product_id#
        </cfquery>
        <cfset ReturnArr=arrayNew(1)>
        <cfset ReturnArr=arrayNew(1)>
        <cfloop query="getTreeFromVirtual">
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
        <cfargument name="sid">
        <cfargument name="company_id">
        <cfargument name="price_catid">
        <cfset dsn3=arguments.ddsn3>
        <cfquery name="getTree" datasource="#dsn3#"><cfif arguments.isVirtual eq 1>SELECT *,STOCK_ID AS RELATED_ID,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0<cfelse>select *,0 AS IS_VIRTUAL from PRODUCT_TREE WHERE STOCK_ID=#arguments.sid# </cfif></cfquery>       
      <cfsavecontent variable="test1">
        <cfdump var="#getTree#">
      </cfsavecontent>
      <cffile action="write" file = "c:\PBS\hizlisatiscfc_saveVirtualTube00#arguments.pid#.html" output="#test1#"></cffile>
            <cfset say=0> 
       <cfsavecontent variable="myV">[<cfloop query="getTree"><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)> <cfset say=say+1><cfset O=structNew()><cfif IS_VIRTUAL eq 1><cfset O.STOCK_ID=STOCK_ID><CFELSE><CFSET O.STOCK_ID=RELATED_ID></cfif><cfset O.PRICE=priceData.PRICE><cfset O.MONEY=priceData.MONEY><cfset O.DISCOUNT=priceData.DISCOUNT><cfset O.IS_VIRTUAL=IS_VIRTUAL><cfset O.VIRTUAL_PRODUCT_TREE_ID=0><CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID><cfset O.PRODUCT_ID=PRODUCT_ID><cfquery name="getSInfo" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#O.PRODUCT_ID#<cfelse>SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#O.PRODUCT_ID#</cfif></cfquery><cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME><cfset O.AMOUNT=AMOUNT><cfquery name="ishvTree" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#<cfelse>SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#</cfif></cfquery><cfoutput>{"PRODUCT_ID":#O.PRODUCT_ID#,"PRODUCT_NAME":"#O.PRODUCT_NAME#","AMOUNT":#O.AMOUNT#,"IS_VIRTUAL":"#O.IS_VIRTUAL#","PRICE":"#O.PRICE#","MONEY":"#O.MONEY#","DISCOUNT":"#O.DISCOUNT#","VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,"PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#","QUESTION_ID":"#QUESTION_ID#","RNDM_ID":#GetRndmNmbr()#,"AGAC":<cfif ishvTree.recordCount><cfscript>writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3,sid=O.STOCK_ID,company_id=arguments.company_id,PRICE_CATID=arguments.price_catid))</cfscript><cfelse>""</cfif>,"ASDF":#say#},</cfoutput></cfloop>]</cfsavecontent>
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

        <cffunction name="getTrees123">
            <cfargument name="pid">
            <cfargument name="isVirtual">
            <cfargument name="ddsn3">        
            <cfargument name="sid">
            <cfargument name="company_id">
            <cfargument name="price_catid">
            <cfset dsn3=arguments.ddsn3>
            <cfquery name="getTree" datasource="#dsn3#"><cfif arguments.isVirtual eq 1>SELECT *,STOCK_ID AS RELATED_ID,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0<cfelse>select *,0 AS IS_VIRTUAL from PRODUCT_TREE WHERE STOCK_ID=#arguments.sid# </cfif></cfquery>       
          <cfsavecontent variable="test1">
            <cfdump var="#getTree#">
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\hizlisatiscfc_saveVirtualTube00#arguments.pid#.html" output="#test1#"></cffile>
                <cfset say=0> 
           <cfsavecontent variable="myV">[<cfloop query="getTree"><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)> <cfset say=say+1><cfset O=structNew()><cfif IS_VIRTUAL eq 1><cfset O.STOCK_ID=STOCK_ID><CFELSE><CFSET O.STOCK_ID=RELATED_ID></cfif><cfset O.PRICE=priceData.PRICE><cfset O.MONEY=priceData.MONEY><cfset O.DISCOUNT=priceData.DISCOUNT><cfset O.IS_VIRTUAL=IS_VIRTUAL><cfset O.VIRTUAL_PRODUCT_TREE_ID=0><CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID><cfset O.PRODUCT_ID=PRODUCT_ID><cfquery name="getSInfo" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#O.PRODUCT_ID#<cfelse>SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#O.PRODUCT_ID#</cfif></cfquery><cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME><cfset O.AMOUNT=AMOUNT><cfquery name="ishvTree" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#<cfelse>SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=#STOCK_ID#</cfif></cfquery><cfoutput>{"PRODUCT_ID":#O.PRODUCT_ID#,"PRODUCT_NAME":"#O.PRODUCT_NAME#","AMOUNT":#O.AMOUNT#,"IS_VIRTUAL":"#O.IS_VIRTUAL#","PRICE":"#O.PRICE#","MONEY":"#O.MONEY#","DISCOUNT":"#O.DISCOUNT#","VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,"PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#","QUESTION_ID":"#QUESTION_ID#","RNDM_ID":#GetRndmNmbr()#,"AGAC":<cfif ishvTree.recordCount><cfscript>writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3,sid=O.STOCK_ID,company_id=arguments.company_id,PRICE_CATID=arguments.price_catid))</cfscript><cfelse>""</cfif>,"ASDF":#say#},</cfoutput></cfloop>]</cfsavecontent>
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

    <cffunction name="getPriceFunk">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="COMPANY_ID">
        <cfargument name="PRICE_CATID">
        <cfargument name="ddsn3">
<cfif arguments.IS_VIRTUAL neq 1 and len(arguments.PRODUCT_ID)>

            <cfquery name="getPrice" datasource="#arguments.ddsn3#">
                 SELECT
                    P.UNIT,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.PRODUCT_ID,
                    P.MONEY,
                    P.PRICE_CATID,
                    P.CATALOG_ID,
                    P.PRICE_DISCOUNT
                FROM
                    PRICE P,
                    PRODUCT PR
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID
                    AND P.PRICE_CATID = #arguments.price_catid#
                    AND
                    (
                        P.STARTDATE <= GETDATE()
                        AND
                        (
                            P.FINISHDATE >= GETDATE() OR
                            P.FINISHDATE IS NULL
                        )
                    )
                    AND ISNULL(P.SPECT_VAR_ID, 0) = 0 
					AND P.PRODUCT_ID=#arguments.product_id#
            </cfquery>
            <cfquery name="getDiscount" datasource="#arguments.ddsn3#">
                SELECT TOP 1
                    PCE.DISCOUNT_RATE
                FROM
                    PRODUCT P,
                    PRICE_CAT_EXCEPTIONS PCE
                    LEFT JOIN PRICE_CAT PC ON PC.PRICE_CATID = PCE.PRICE_CATID
                WHERE
                    (
                        PCE.PRODUCT_ID = P.PRODUCT_ID OR
                        PCE.PRODUCT_ID IS NULL
                    ) AND
                    (
                        PCE.BRAND_ID = P.BRAND_ID OR
                        PCE.BRAND_ID IS NULL
                    ) AND
                    (
                        PCE.PRODUCT_CATID = P.PRODUCT_CATID OR
                        PCE.PRODUCT_CATID IS NULL
                    ) AND
                    (
                        PCE.COMPANY_ID = #arguments.COMPANY_ID# OR
                        PCE.COMPANY_ID IS NULL
                    ) AND
                    P.PRODUCT_ID = #arguments.PRODUCT_ID# AND
                    ISNULL(PC.IS_SALES,0) = 1 AND
                    PCE.ACT_TYPE NOT IN (2,4) AND 
                    PC.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#">
                ORDER BY
                    PCE.COMPANY_ID DESC,
                    PCE.PRODUCT_CATID DESC
            </cfquery>
            <cfset ReturnData.PRICE=getPrice.PRICE>
            <cfset ReturnData.MONEY=getPrice.MONEY>
            <cfset ReturnData.DISCOUNT=getDiscount.DISCOUNT_RATE>
            <cfreturn ReturnData>
        <cfelse>
            <cfset ReturnData.PRICE=0>
            <cfset ReturnData.MONEY="TL">
            <cfset ReturnData.DISCOUNT=0>
            <cfreturn ReturnData>
        </cfif>
        
    </cffunction>
</cfcomponent>