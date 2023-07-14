<cfcomponent>   
    <cfset dsn=application.systemparam.dsn>
<cfquery name="getQuestions" datasource="#dsn#">
select ID,QUESTION as QUESTION_NAME from workcube_metosan_1.VIRTUAL_PRODUCT_TREE_QUESTIONS    
</cfquery>
<cfscript>
    QuestionArr=arrayNew(1);
    for(i=1;i<getQuestions.recordCount;i++){         
      obj={
        QUESTION_ID=getQuestions.ID[i],
        QUESTION_NAME=getQuestions.QUESTION_NAME[i]
      };
      arrayAppend(QuestionArr,obj)            
    }    
</cfscript>
    <cffunction name="getTree" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
            <cfargument name="product_id">
            <cfargument name="isVirtual">
            <cfargument name="ddsn3">
            <cfargument name="company_id">
            <cfargument name="price_catid">
            <cfargument name="stock_id" default="">
            <cfset TreeArr="">
            <cfif arguments.isVirtual eq 1>                
                <cfset TreeArr=getTrees(product_id,isVirtual,ddsn3,product_id,company_id,price_catid)>
            <cfelse>               
                <cfset TreeArr=getTrees(product_id,0,ddsn3,stock_id,company_id,price_catid)>
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
        <cfquery name="getTree" datasource="#dsn3#"><cfif arguments.isVirtual eq 1>SELECT *,STOCK_ID AS RELATED_ID,VPT_ID AS PRODUCT_TREE_ID FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0<cfelse>select *,0 AS IS_VIRTUAL,(SELECT PROPERTY3 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID=PRODUCT_TREE.PRODUCT_ID AND PRO_INFO_ID=2) AS DISPLAY_NAME from PRODUCT_TREE WHERE STOCK_ID=#arguments.sid# </cfif></cfquery>       
      <cfsavecontent variable="test1">
        <cfdump var="#getTree#">
      </cfsavecontent>
      <cffile action="write" file = "c:\PBS\hizlisatiscfc_saveVirtualTube00#arguments.pid#.html" output="#test1#"></cffile>
            <cfset say=0> 
       <cfsavecontent variable="myV">[<cfloop query="getTree"><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)> <cfset say=say+1><cfset O=structNew()><cfif IS_VIRTUAL eq 1><cfset O.STOCK_ID=STOCK_ID><CFELSE><CFSET O.STOCK_ID=RELATED_ID></cfif><cfset O.PRICE=priceData.PRICE><cfset O.MONEY=priceData.MONEY><cfset O.DISCOUNT=priceData.DISCOUNT><cfset O.IS_VIRTUAL=IS_VIRTUAL><cfset O.VIRTUAL_PRODUCT_TREE_ID=0><CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID><cfset O.DISPLAY_NAME=DISPLAY_NAME><cfset O.PRODUCT_ID=PRODUCT_ID><cfquery name="getSInfo" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#<cfelse>SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#</cfif></cfquery><cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME><cfset O.AMOUNT=AMOUNT><cfquery name="ishvTree" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#<cfelse>SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=(SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID=#PRODUCT_ID#)</cfif></cfquery><cfoutput>{"PRODUCT_ID":#O.PRODUCT_ID#,"PRODUCT_NAME":"#O.PRODUCT_NAME#","AMOUNT":#O.AMOUNT#,"DISPLAYNAME":"#O.DISPLAY_NAME#","IS_VIRTUAL":"#O.IS_VIRTUAL#","PRICE":"#O.PRICE#","MONEY":"#O.MONEY#","DISCOUNT":"#O.DISCOUNT#","VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,"PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#","QUESTION_ID":"#QUESTION_ID#","QUESTION_NAME":"#getQuestionData(QUESTION_ID).QUESTION_NAME#","RNDM_ID":#GetRndmNmbr()#,"AGAC":<cfif ishvTree.recordCount><cfscript>writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3,sid=ishvTree.STOCK_ID,company_id=arguments.company_id,PRICE_CATID=arguments.price_catid))</cfscript><cfelse>""</cfif>,"ASDF":#say#},</cfoutput></cfloop>]</cfsavecontent>
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

    <cffunction name="NewDraft" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="PRODUCT_NAME">
        <cfargument name="PRODUCT_CATID">
        <cfargument name="PRODUCT_UNIT">
        <cfargument name="PROJECT_ID">
        <cfargument name="ddsn3">
<cfquery name="ins" datasource="#arguments.ddsn3#">
    INSERT INTO VIRTUAL_PRODUCTS_PRT (
    PRODUCT_NAME,
    PRODUCT_CATID,
    PRICE,
    MARJ,
    PRODUCT_TYPE,
    IS_CONVERT_REAL,
    IS_PRODUCTION,
    RECORD_EMP,
    RECORD_DATE,
    PRODUCT_DESCRIPTION,
    PRODUCT_UNIT,
    PROJECT_ID,
    PRODUCT_VERSION,
    PRODUCT_STAGE,
    PORCURRENCY
)
VALUES (
    '#arguments.PRODUCT_NAME#',
    #arguments.PRODUCT_CATID#,
    0,
    0,
    0,
    0,
    1,
    #session.ep.userid#,
    GETDATE(),
    '',
    '#arguments.PRODUCT_UNIT#',
    #arguments.PROJECT_ID#,
    '',
    339,
    -6
)
</cfquery>



    </cffunction>

    <cffunction name="updateStage" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="vp_id">
        <cfargument name="psatge">
        <cfargument name="projectId">
        <cfargument name="ddsn3">
        <cfquery name="upd" datasource="#arguments.ddsn3#">
            UPDATE VIRTUAL_PRODUCTS_PRT SET PRODUCT_STAGE=#arguments.psatge# where VIRTUAL_PRODUCT_ID=#arguments.vp_id#
        </cfquery>
        <cfreturn "Kayit Başarılı">
    </cffunction>

    <cffunction name="getProjectProducts" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="PROJECT_ID">
        <cfargument name="ddsn3">
        <cfquery name="getP" datasource="#arguments.ddsn3#">
            SELECT VP.*,1 AS IS_MAIN,PTR.STAGE FROM VIRTUAL_PRODUCTS_PRT  AS VP
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID=VP.PRODUCT_STAGE
            WHERE PROJECT_ID=#arguments.PROJECT_ID#           
          </cfquery>
        <cfsavecontent variable="leftMenu">
            <cfoutput query="getP">             
                <a class="list-group-item list-group-item-action" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#arguments.ddsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')">
                    #PRODUCT_NAME#
                    <cfif PRODUCT_STAGE eq 339>
                        <span style="float:right;font-size:11pt" class="badge bg-danger rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 340>
                        <span style="float:right;font-size:11pt" class="badge bg-success rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 341>
                        <span style="float:right;font-size:11pt" class="badge bg-warning rounded-pill">#STAGE#</span>
                    <cfelseif PRODUCT_STAGE eq 342>
                        <span style="float:right;font-size:11pt" class="badge bg-primary rounded-pill">#STAGE#</span>
                    <cfelse>
                        <span style="float:right;font-size:11pt" class="badge bg-dark rounded-pill">0</span>
                    </cfif>                
                </a>     
            </cfoutput>
        </cfsavecontent>
        <cfreturn leftMenu>
    </cffunction>
    <cffunction name="updateSettings" access="remote" httpMethod="POST" returntype="any" returnformat="plain">
        <cfargument name="paramValue">
        <cfargument name="paramName">
        <cfargument name="ddsn3">
        <cfquery name="up" datasource="#arguments.ddsn3#" result="res">
            update PROJECT_PRODUCT_DESIGN_PARAMS_PBS set PARAM_VALUE='#arguments.paramValue#' WHERE PARAM_NAME='#arguments.paramName#'
        </cfquery>
        <cfreturn replace(serializeJSON(res),"//","")>
    </cffunction>
    <cffunction name="getQuestionData">
        <cfargument name="question_id">
        <cfset quid=arguments.question_id>;
        <cfset V=arrayfind(QuestionArr,p=>p.QUESTION_ID==quid)>    
        <cfif V neq 0>
            <cfreturn QuestionArr[V]>
        <cfelse>
            <cfreturn {
                QUESTION_ID=arguments.question_id,
                QUESTION_NAME=""
            }>
        </cfif>
        
    </cffunction>
</cfcomponent>