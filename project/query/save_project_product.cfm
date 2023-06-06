<cfdump var="#attributes#">
<cfset FormData=deserializeJSON(attributes.data)>

<cfdump var="#FormData#">

<cfquery name="getFr" datasource="#dsn3#">
        SELECT PCPS.*,PC.HIERARCHY,PC.PRODUCT_CAT,PC.DETAIL FROM #DSN#.PRO_PROJECTS AS PP
LEFT JOIN #DSN#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
LEFT JOIN #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT AS MPTC ON MPTC.MAIN_PROCESS_CATID=SMC.MAIN_PROCESS_CAT_ID
LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=MPTC.PRODUCT_CATID
LEFT JOIN #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS as PCPS ON PCPS.PRODUCT_CATID=PC.PRODUCT_CATID
WHERE PP.PROJECT_ID=#FormData.PROJECT_ID#
</cfquery>


<cfif FormData.PRODUCT_ID neq 0 and len(FormData.PRODUCT_ID)>
    <cfquery name="del" datasource="#dsn3#">
        DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#FormData.PRODUCT_ID#
    </cfquery>
    <cfif arrayLen(FormData.PRODUCT_TREE)>
        <cfloop array="#FormData.PRODUCT_TREE#" index="ai">
            <cfif isDefined("ai.QUESTION_ID")><cfset aiq=ai.QUESTION_ID><cfelse><cfset aiq="NULL"></cfif>
                <cfif isDefined("ai.PRICE")><cfset aip=ai.PRICE><cfelse><cfset aip="0"></cfif>
                    <cfif isDefined("ai.DISCOUNT")><cfset aid=ai.DISCOUNT><cfelse><cfset aid="0"></cfif>
                        <cfif isDefined("ai.MONEY")><cfset aim=ai.MONEY><cfelse><cfset aim="TL"></cfif>
            <cfif ai.PRODUCT_ID neq 0>
                <cfscript>
                    InsertedItem=InsertTree(FormData.PRODUCT_ID,ai.PRODUCT_ID,ai.STOCK_ID,ai.AMOUNT,aiq,aip,aid,aim,ai.IS_VIRTUAL);
                </cfscript>
            <cfelse>

                <cfquery name="getParams" datasource="#dsn3#">
                    SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#ai.PRODUCT_CATID#
                </cfquery>
                <cfscript>
                    CreatedProduct= CreateVirtualProduct(
                        ai.PRODUCT_NAME,
                        ai.PRODUCT_CATID,
                        0,
                        0,
                        99,
                        1,
                        '',
                        getParams.PRODUCT_UNIT,
                        FormData.PROJECT_ID,
                        '0',
                        0,
                        -6
                    );
                    CreatedProductId=CreatedProduct.IDENTITYCOL        
                    if(isDefined("ai.price")){
                        prcex=ai.price;
                    }else{
                        prcex=0;
                    }
                    if(isDefined("ai.discount")){
                        dsc=ai.discount;
                    }else{
                        dsc=0;
                    }
                    if(isDefined("ai.MONEY")){
                        mny=ai.MONEY;
                    }else{
                        mny="TL";
                    }
                    InsertedItem=InsertTree(FormData.PRODUCT_ID,CreatedProductId,0,ai.AMOUNT,aiq,prcex,dsc,mny,ai.IS_VIRTUAL);
                </cfscript>
                <cfif arraylen(ai.AGAC)>
                    <cfloop array="#ai.AGAC#" index="idx">
                        
                        <cfscript>
                            if(isDefined("idx.price")){
                                prcex1=idx.price;
                            }else{
                                prcex1=0;
                            }
                            if(isDefined("idx.discount")){
                                dsc1=idx.discount;
                            }else{
                                dsc1=0;
                            }
                            if(isDefined("idx.MONEY")){
                                mny1=idx.MONEY;
                            }else{
                                mny1="TL";
                            }
                            if(isDefined("idx.QUESTION_ID")){
                                queid=idx.QUESTION_ID;
                            }else{
                                queid="0";
                            }
                            InsertedItem=InsertTree(CreatedProductId,idx.PRODUCT_ID,idx.STOCK_ID,idx.AMOUNT,queid,prcex1,dsc1,mny1,idx.IS_VIRTUAL);
                        </cfscript>
                    </cfloop>
                </cfif>
            </cfif>
        </cfloop>
    </cfif>    


<cfelse>
   
<cfscript>
   CreatedProduct= CreateVirtualProduct(
        FormData.PRODUCT_NAME,
        getFr.PRODUCT_CATID,
        0,
        0,
        99,
        1,
        '',
        getFr.PRODUCT_UNIT,
        FormData.PROJECT_ID,
        '0',
        FormData.PRODUCT_STAGE,
        -6
    );
    CreatedProductId=CreatedProduct.IDENTITYCOL
</cfscript>
<cfdump var="#CreatedProduct#">

<cfdump var="#arrayLen(FormData.PRODUCT_TREE)#">
<cfif arrayLen(FormData.PRODUCT_TREE)>
    <cfdump var="#arrayLen(FormData.PRODUCT_TREE)#">
    agacim var
<cfloop array="#FormData.PRODUCT_TREE#" index="ai">
<cfdump var="#ai#">

<cfif ai.PRODUCT_ID neq 0>
    <cfscript>
        if(isDefined("ai.price")){
            prcex=ai.price;
        }else{
            prcex=0;
        }
        if(isDefined("ai.discount")){
            dsc=ai.discount;
        }else{
            dsc=0;
        }
        if(isDefined("ai.MONEY")){
            mny=ai.MONEY;
        }else{
            mny="TL";
        }
        if(isDefined("ai.QUESTION_ID")){
            queid=ai.QUESTION_ID;
    }else{
        queid="NULL";
    }
        InsertedItem=InsertTree(CreatedProductId,ai.PRODUCT_ID,ai.STOCK_ID,ai.AMOUNT,queid,prcex,dsc,mny,ai.IS_VIRTUAL);
    </cfscript>
<cfelse>
    <cfoutput>
        #ai.PRODUCT_CATID#
    </cfoutput>
    
    <cfquery name="getParams" datasource="#dsn3#">
        SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#ai.PRODUCT_CATID#
    </cfquery>
    <cfscript>
        CreatedProduct= CreateVirtualProduct(
            ai.PRODUCT_NAME,
            ai.PRODUCT_CATID,
            0,
            0,
            99,
            1,
            '',
            getParams.PRODUCT_UNIT,
            FormData.PROJECT_ID,
            '0',
            0,
            -6
        );
        CreatedProductId=CreatedProduct.IDENTITYCOL        
        if(isDefined("ai.price")){
            prcex=ai.price;
        }else{
            prcex=0;
        }
        if(isDefined("ai.discount")){
            dsc=ai.discount;
        }else{
            dsc=0;
        }
        if(isDefined("ai.MONEY")){
            mny=ai.MONEY;
        }else{
            mny="TL";
        }
        if(isDefined("ai.QUESTION_ID")){
                queid=ai.QUESTION_ID;
        }else{
            queid="NULL";
        }
        InsertedItem=InsertTree(FormData.PRODUCT_ID,CreatedProductId,0,ai.AMOUNT,queid,prcex,dsc,mny,ai.IS_VIRTUAL);
    </cfscript>
    <cfif arraylen(ai.AGAC)>
        <cfloop array="#ai.AGAC#" index="idx">
            
            <cfscript>
                if(isDefined("idx.price")){
                    prcex1=idx.price;
                }else{
                    prcex1=0;
                }
                if(isDefined("idx.discount")){
                    dsc1=idx.discount;
                }else{
                    dsc1=0;
                }
                if(isDefined("idx.MONEY")){
                    mny1=idx.MONEY;
                }else{
                    mny1="TL";
                }
                InsertedItem=InsertTree(CreatedProductId,idx.PRODUCT_ID,idx.STOCK_ID,idx.AMOUNT,idx.QUESTION_ID,prcex1,dsc1,mny1,idx.IS_VIRTUAL);
            </cfscript>
        </cfloop>
    </cfif>
</cfif>

</cfloop>
</cfif>
</cfif>


<cfdump var="#getFr#">

<cffunction name="CreateVirtualProduct">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRICE">
    <cfargument name="MARJ">
    <cfargument name="PRODUCT_TYPE">
    <cfargument name="IS_PRODUCTION">
    <cfargument name="PRODUCT_DESCRIPTION">
    <cfargument name="PRODUCT_UNIT">
    <cfargument name="PROJECT_ID">
    <cfargument name="PRODUCT_VERSION">
    <cfargument name="PRODUCT_STAGE">
    <cfargument name="PORCURRENCY">

   <cfquery name="ins" datasource="#dsn3#" result="res">
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
        #arguments.PRICE#,
        #arguments.MARJ#,
        #arguments.PRODUCT_TYPE#,
        0,
        #arguments.IS_PRODUCTION#,
        #session.ep.userid#,
        GETDATE(),
        '#arguments.PRODUCT_DESCRIPTION#',
        '#arguments.PRODUCT_UNIT#',
        #arguments.PROJECT_ID#,
        '#arguments.PRODUCT_VERSION#',
        <cfif len(arguments.PRODUCT_STAGE)>#arguments.PRODUCT_STAGE#<cfelse>339</cfif>,
        #arguments.PORCURRENCY#
    )
   </cfquery>
<cfreturn res>
</cffunction>

<cffunction name="UpdateVirtualProduct">
    <cfargument name="PRODUCT_NAME">
    <cfargument name="PRODUCT_CATID">
    <cfargument name="PRICE">
    <cfargument name="MARJ">
    <cfargument name="PRODUCT_TYPE">
    <cfargument name="IS_PRODUCTION">
    <cfargument name="PRODUCT_DESCRIPTION">
    <cfargument name="PRODUCT_UNIT">
    <cfargument name="PROJECT_ID">
    <cfargument name="PRODUCT_VERSION">
    <cfargument name="PRODUCT_STAGE">
    <cfargument name="PORCURRENCY">
    <cfargument name="VIRTUAL_PRODUCT_ID">
<cfquery name="UPD" datasource="#DSN3#">
UPDATE VIRTUAL_PRODUCTS_PRT
SET PRODUCT_NAME = '#arguments.PRODUCT_NAME#'
	,PRODUCT_CATID = #arguments.PRODUCT_CATID#
	,PRICE = #arguments.PRICE#
	,MARJ = #arguments.MARJ#
	,PRODUCT_TYPE = #arguments.PRODUCT_TYPE#
	,IS_CONVERT_REAL = 0 
    ,IS_PRODUCTION = #arguments.IS_PRODUCTION#
	,UPDATE_EMP = #session.ep.userid#
	,UPDATE_DATE = GETDATE()
	,PRODUCT_DESCRIPTION = '#arguments.PRODUCT_DESCRIPTION#'
	,PRODUCT_UNIT = '#arguments.PRODUCT_UNIT#'
	,PROJECT_ID = #arguments.PROJECT_ID#
	,PRODUCT_VERSION = '#arguments.PRODUCT_VERSION#'
	,PRODUCT_STAGE = #arguments.PRODUCT_STAGE#
	,PORCURRENCY = #arguments.PORCURRENCY#
    WHERE VIRTUAL_PRODUCT_ID=#arguments.VIRTUAL_PRODUCT_ID#
    
</cfquery>
    
   

</cffunction>

<cffunction name="InsertTree">
    <cfargument name="VP_ID">
    <cfargument name="PRODUCT_ID">
    <cfargument name="STOCK_ID">
    <cfargument name="AMOUNT">
    <cfargument name="QUESTION_ID">
    <cfargument name="PRICE">
    <cfargument name="DISCOUNT">
    <cfargument name="MONEY">
    <cfargument name="IS_VIRTUAL">

<cfquery name="ins" datasource="#dsn3#" result="res">
    

    INSERT INTO VIRTUAL_PRODUCT_TREE_PRT (    
    VP_ID,
    PRODUCT_ID,
    STOCK_ID,
    AMOUNT,
    QUESTION_ID,
    PRICE,
    DISCOUNT,
    MONEY,
    IS_VIRTUAL
    )
    VALUES(
        #arguments.VP_ID#,
    #arguments.PRODUCT_ID#,
    <cfif arguments.stock_id neq "undefined">#arguments.STOCK_ID#<cfelse>0</cfif>,
    #arguments.AMOUNT#,
    <cfif len(arguments.QUESTION_ID)>#arguments.QUESTION_ID#<cfelse>NULL</cfif>,
    <cfif len(arguments.price)>#arguments.PRICE#<cfelse>0</cfif>,
    <cfif len(arguments.discount)>#arguments.DISCOUNT#<cfelse>0</cfif>,
    <cfif len(arguments.money)>'#arguments.MONEY#'<cfelse>'TL'</cfif>,
    #arguments.IS_VIRTUAL#
    )

</cfquery>
<cfreturn res>
</cffunction>