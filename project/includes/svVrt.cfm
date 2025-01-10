<!---<cfinclude template="svVrt_1.cfm">---->
<div class="alert alert-danger">
    Çalışma Yapılıyor !
</div>
<cfquery name="getFr" datasource="#dsn3#">
    SELECT PCPS.*,PC.HIERARCHY,PC.PRODUCT_CAT,PC.DETAIL FROM #DSN#.PRO_PROJECTS AS PP
    LEFT JOIN #DSN#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
    LEFT JOIN #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT AS MPTC ON MPTC.MAIN_PROCESS_CATID=SMC.MAIN_PROCESS_CAT_ID
    LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=MPTC.PRODUCT_CATID
    LEFT JOIN #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS as PCPS ON PCPS.PRODUCT_CATID=PC.PRODUCT_CATID
    WHERE PP.PROJECT_ID=#FormData.PROJECT_ID#
</cfquery>

<cfdump var="#getFr#">
<cfquery name="getParams" datasource="#dsn3#">
    SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#getFr.PRODUCT_CATID#
</cfquery>

<cfdump var="#FormData#">
<cfdump var="#getParams#">
<cfscript>
    ClearVirtualTree_1453(FormData.PRODUCT_ID);
    Obj={
        PRODUCT_CATID= getFr.PRODUCT_CATID,
        MARJ=0,
        PRODUCT_TYPE=0,
        IS_PRODUCTION=1,
        PRODUCT_DESCRIPTION='',
        PRODUCT_UNIT='Adet',
        PROJECT_ID=FormData.PROJECT_ID,
        PRODUCT_VERSION='',
        PRODUCT_STAGE=FormData.PRODUCT_STAGE,
        PORCURRENCY=-6,
        VIRTUAL_PRODUCT_ID=FormData.PRODUCT_ID,
        PRODUCT_NAME=FormData.PRODUCT_NAME,
        PRICE=FormData.PRICE
    };
    UpdateVirtualProduct_1453(Obj)
</cfscript>
<!------------
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
        <cfargument name="VIRTUAL_PRODUCT_ID">------------>


<cfset MS_ID=FormData.PRODUCT_ID>
<cfloop array="#FormData.PRODUCT_TREE#" item="SV_01_ITEM"> <!---- 1.SEVİYE AĞAÇTA DÖNÜYORUM ---->
    <CFIF SV_01_ITEM.IS_VIRTUAL EQ 0> <!----- Ürün Sanalmı ---->
        <!-------Sanal Değilse------>
        <cfif isDefined("SV_01_ITEM.QUESTION_ID")><cfelse><cfset SV_01_ITEM.QUESTION_ID=""></cfif>
            <cfif isDefined("SV_01_ITEM.DISPLAY_NAME")><cfelse><cfset SV_01_ITEM.DISPLAY_NAME=""></cfif>
        <cfscript>
            Obj={
                    VP_ID=MS_ID,
                    PRODUCT_ID=SV_01_ITEM.PRODUCT_ID,
                    STOCK_ID=SV_01_ITEM.STOCK_ID,
                    AMOUNT=SV_01_ITEM.AMOUNT,
                    QUESTION_ID=SV_01_ITEM.QUESTION_ID,
                    PRICE=SV_01_ITEM.PRICE,
                    DISCOUNT=SV_01_ITEM.DISCOUNT,
                    MONEY=SV_01_ITEM.MONEY,
                    IS_VIRTUAL=SV_01_ITEM.IS_VIRTUAL,
                    DISPLAY_NAME=SV_01_ITEM.DISPLAY_NAME,
                    PBS_ROW_ID=SV_01_ITEM.PBS_ROW_ID
                }
            InsertTreeNew_1453(Obj);
        </cfscript>
    <cfelse>
          Ürün Sanal
        <cfif SV_01_ITEM.PRODUCT_ID neq 0>
            Daha Önce Oluşmuş <cfoutput>#SV_01_ITEM.PRODUCT_ID#</cfoutput>
            <cfscript>
                ClearVirtualTree_1453(SV_01_ITEM.PRODUCT_ID);        
            </cfscript>
        <cfelse>
            Daha Önce Oluşmamış
            <cfquery name="getParams" datasource="#dsn3#">
                SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#SV_01_ITEM.PRODUCT_CATID#
            </cfquery>
            <cfscript>
                Obj={
                    PRODUCT_NAME=SV_01_ITEM.PRODUCT_NAME,
                    PRODUCT_CATID=SV_01_ITEM.PRODUCT_CATID,
                    PRICE=SV_01_ITEM.PRICE,
                    MARJ=0,
                    PRODUCT_TYPE="99",
                    IS_PRODUCTION="1",
                    PRODUCT_DESCRIPTION="",
                    PRODUCT_UNIT=getParams.PRODUCT_UNIT,
                    PROJECT_ID=FormData.PROJECT_ID,
                    PRODUCT_VERSION=0,
                    PRODUCT_STAGE=FormData.PRODUCT_STAGE,
                    PORCURRENCY=-6
                };
                OlusanUrun=CreateVirtualProduct_New_1453(Obj);
                writeDump("OLUSAN URUN <br>")
                writeDump(OlusanUrun);
            </cfscript>
            <cfset SV_01_ITEM.PRODUCT_ID=OlusanUrun.IDENTITYCOL>
        </cfif>
        <cfscript>
            Obj2={
                    VP_ID=MS_ID,
                    PRODUCT_ID=SV_01_ITEM.PRODUCT_ID,
                    STOCK_ID=SV_01_ITEM.STOCK_ID,
                    AMOUNT=SV_01_ITEM.AMOUNT,
                    QUESTION_ID=SV_01_ITEM.QUESTION_ID,
                    PRICE=SV_01_ITEM.PRICE,
                    DISCOUNT=SV_01_ITEM.DISCOUNT,
                    MONEY=SV_01_ITEM.MONEY,
                    IS_VIRTUAL=SV_01_ITEM.IS_VIRTUAL,
                    DISPLAY_NAME=SV_01_ITEM.DISPLAY_NAME,
                    PBS_ROW_ID=SV_01_ITEM.PBS_ROW_ID
                }
            InsertTreeNew_1453(Obj2);
        </cfscript>
        <CFIF ARRAYLEN(SV_01_ITEM.AGAC)>
            <cfloop array="#SV_01_ITEM.AGAC#" item="SV_02_ITEM">
                <cfif isDefined("SV_02_ITEM.QUESTION_ID")><cfelse><cfset SV_02_ITEM.QUESTION_ID=""></cfif>
                    <cfif isDefined("SV_02_ITEM.DISPLAY_NAME")><cfelse><cfset SV_02_ITEM.DISPLAY_NAME=""></cfif>
                <CFIF SV_02_ITEM.IS_VIRTUAL EQ 0>
                    <cfscript>
                        Obj={
                                VP_ID=SV_01_ITEM.PRODUCT_ID,
                                PRODUCT_ID=SV_02_ITEM.PRODUCT_ID,
                                STOCK_ID=SV_02_ITEM.STOCK_ID,
                                AMOUNT=SV_02_ITEM.AMOUNT,
                                QUESTION_ID=SV_02_ITEM.QUESTION_ID,
                                PRICE=SV_02_ITEM.PRICE,
                                DISCOUNT=SV_02_ITEM.DISCOUNT,
                                MONEY=SV_02_ITEM.MONEY,
                                IS_VIRTUAL=SV_02_ITEM.IS_VIRTUAL,
                                DISPLAY_NAME=SV_02_ITEM.DISPLAY_NAME,
                                PBS_ROW_ID=SV_02_ITEM.PBS_ROW_ID
                            }
                        InsertTreeNew_1453(Obj);
                    </cfscript>
                <cfelse>
                    <cfif len(SV_02_ITEM.PRODUCT_ID) gt 0>
                        <cfscript>
                            ClearVirtualTree_1453(SV_02_ITEM.PRODUCT_ID);        
                        </cfscript>
                    <cfelse>
                        <cfquery name="getParams" datasource="#dsn3#">
                            SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#SV_02_ITEM.PRODUCT_CATID#
                        </cfquery>
                        <cfscript>
                            Obj2={
                                PRODUCT_NAME=SV_02_ITEM.PRODUCT_NAME,
                                PRODUCT_CATID=SV_02_ITEM.PRODUCT_CATID,
                                PRICE=SV_02_ITEM.PRICE,
                                MARJ=0,
                                PRODUCT_TYPE="99",
                                IS_PRODUCTION="1",
                                PRODUCT_DESCRIPTION="",
                                PRODUCT_UNIT=getParams.PRODUCT_UNIT,
                                PROJECT_ID=FormData.PROJECT_ID,
                                PRODUCT_VERSION=0,
                                PRODUCT_STAGE=FormData.PRODUCT_STAGE,
                                PORCURRENCY=-6
                            };
                            OlusanUrun=CreateVirtualProduct_New_1453(Obj2);
                            writeDump(OlusanUrun);
                        </cfscript>
                        <cfset SV_02_ITEM.PRODUCT_ID=OlusanUrun.IDENTITYCOL>
                    </cfif>
                    <CFIF ARRAYLEN(SV_02_ITEM.AGAC)>
                        <cfloop array="#SV_02_ITEM.AGAC#" item="SV_03_ITEM">
                        
                        </cfloop>
                    </CFIF>
                </CFIF>
            </cfloop>
        </CFIF>
    </CFIF>
</cfloop>

<cffunction name="InsertTreeNew_1453">
    
    <cfargument name="OBJEM">
 
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
    IS_VIRTUAL,
    DISPLAY_NAME,
    PBS_ROW_ID
    )
    VALUES(
        #arguments.OBJEM.VP_ID#,
    #arguments.OBJEM.PRODUCT_ID#,
    <cfif arguments.OBJEM.stock_id neq "undefined">#arguments.OBJEM.STOCK_ID#<cfelse>0</cfif>,
#arguments.OBJEM.AMOUNT#,
    <cfif len(arguments.OBJEM.QUESTION_ID)> #arguments.OBJEM.QUESTION_ID#<cfelse>NULL</cfif>,
    <cfif len(arguments.OBJEM.price)>#arguments.OBJEM.PRICE#<cfelse>0</cfif>,
    <cfif len(arguments.OBJEM.discount)>#arguments.OBJEM.DISCOUNT#<cfelse>0</cfif>,
    <cfif len(arguments.OBJEM.money)>'#arguments.OBJEM.MONEY#'<cfelse>'TL'</cfif>,
                                            #arguments.OBJEM.IS_VIRTUAL#,
    <cfif len(arguments.OBJEM.DISPLAY_NAME)>'     #arguments.OBJEM.DISPLAY_NAME#'<CFELSE>NULL</cfif>,
        <cfif len(arguments.OBJEM.PBS_ROW_ID)>'     #arguments.OBJEM.PBS_ROW_ID#'<CFELSE>NULL</cfif>
    )
    
    </cfquery>
    <cfreturn res>
</cffunction>



<cffunction name="ClearVirtualTree_1453">
    <cfargument name="VP_ID">
    <cfquery name="delTree" datasource="#dsn3#">
        DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.VP_ID#
    </cfquery>
</cffunction>

<cffunction name="CreateVirtualProduct_New_1453">
    <cfargument name="OBJEM">

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
        '#arguments.OBJEM.PRODUCT_NAME#',
        #arguments.OBJEM.PRODUCT_CATID#,
        #arguments.OBJEM.PRICE#,
        #arguments.OBJEM.MARJ#,
        #arguments.OBJEM.PRODUCT_TYPE#,
        0,
        #arguments.OBJEM.IS_PRODUCTION#,
        #session.ep.userid#,
        GETDATE(),
        '#arguments.OBJEM.PRODUCT_DESCRIPTION#',
        '#arguments.OBJEM.PRODUCT_UNIT#',
        #arguments.OBJEM.PROJECT_ID#,
        '#arguments.OBJEM.PRODUCT_VERSION#',
        <cfif len(arguments.OBJEM.PRODUCT_STAGE)>#arguments.OBJEM.PRODUCT_STAGE#<cfelse>339</cfif>,
        #arguments.OBJEM.PORCURRENCY#
    )
    </cfquery>
    <cfreturn res>
    </cffunction>
    <cffunction name="UpdateVirtualProduct_1453">
        <cfargument name="OBJEM">
       
        <cfquery name="UPD" datasource="#DSN3#">
        UPDATE VIRTUAL_PRODUCTS_PRT
        SET PRODUCT_NAME = '#arguments.OBJEM.PRODUCT_NAME#'
        ,PRODUCT_CATID = #arguments.OBJEM.PRODUCT_CATID#
        ,PRICE = #arguments.OBJEM.PRICE#
        ,MARJ = #arguments.OBJEM.MARJ#
        ,PRODUCT_TYPE = #arguments.OBJEM.PRODUCT_TYPE#
        ,IS_CONVERT_REAL = 0 
        ,IS_PRODUCTION = #arguments.OBJEM.IS_PRODUCTION#
        ,UPDATE_EMP = #session.ep.userid#
        ,UPDATE_DATE = GETDATE()
        ,PRODUCT_DESCRIPTION = '#arguments.OBJEM.PRODUCT_DESCRIPTION#'
        ,PRODUCT_UNIT = '#arguments.OBJEM.PRODUCT_UNIT#'
        ,PROJECT_ID = #arguments.OBJEM.PROJECT_ID#
        ,PRODUCT_VERSION = '#arguments.OBJEM.PRODUCT_VERSION#'
        ,PRODUCT_STAGE = #arguments.OBJEM.PRODUCT_STAGE#
        ,PORCURRENCY = #arguments.OBJEM.PORCURRENCY#
        WHERE VIRTUAL_PRODUCT_ID=#arguments.OBJEM.VIRTUAL_PRODUCT_ID#
        
        </cfquery>
    </cffunction>
    <script>
        window.opener.ngetTree(<cfoutput>#FormData.PRODUCT_ID#</cfoutput>,1,'<cfoutput>#dsn3#</cfoutput>',"",1,'','<cfoutput>#FormData.PRODUCT_NAME#</cfoutput>','<cfoutput>#FormData.PRODUCT_STAGE#</cfoutput>')
    this.close();
         
     </script>