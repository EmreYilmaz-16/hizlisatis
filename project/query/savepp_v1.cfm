









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

<cfscript>
    UrunEKle(FormData)
</cfscript>
<cffunction name="getParams">
    <cfargument name="project_id" default="0">
    <cfargument name="cat_id" default="0">
    <cfif arguments.project_id neq 0>
        <cfquery name="getFr" datasource="#dsn3#">
            SELECT PCPS.*,PC.HIERARCHY,PC.PRODUCT_CAT,PC.DETAIL FROM #DSN#.PRO_PROJECTS AS PP
            LEFT JOIN #DSN#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
            LEFT JOIN #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT AS MPTC ON MPTC.MAIN_PROCESS_CATID=SMC.MAIN_PROCESS_CAT_ID
            LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=MPTC.PRODUCT_CATID
            LEFT JOIN #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS as PCPS ON PCPS.PRODUCT_CATID=PC.PRODUCT_CATID
            WHERE PP.PROJECT_ID=#FormData.PROJECT_ID#
        </cfquery>    
<cfelseif arguments.cat_id neq 0>
    <cfquery name="GETFR" datasource="#DSN3#">
        SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#arguments.cat_id#
    </cfquery>        
</cfif>

    <cfreturn getFr>
</cffunction>

<cffunction name="UrunEKle">
    <cfargument name="Urun">
    
    <cfscript>
        FIYAT=0;
        MARJ=0;
        DESCRIPTION="";
        PRODUCT_STAGE=339;
        PRO_CURRENCY=-1;
        params="";
        if()
         Res=CreateVirtualProductPartner(arguments.Urun.PRODUCT_NAME,getFr.PRODUCT_CATID,FIYAT,MARJ,99,1,DESCRIPTION,getFr.PRODUCT_UNIT,FormData.PROJECT_ID,1,PRODUCT_STAGE,PRO_CURRENCY);
        EklenenUrunId=res.IDENTITYCOL
    </cfscript>
    <cfif arrayLen(arguments.Urun.PRODUCT_TREE) OR( isDefined("arguments.Urun.AGAC") AND arrayLen(arguments.Urun.AGAC)) >
        <cfif arrayLen(arguments.Urun.PRODUCT_TREE)>
            <CFLOOP array="#arguments.Urun.PRODUCT_TREE#" index="ix">
<cfoutput> 
    <span style="color:red">
    #ix.PRODUCT_NAME#
    <cfif ix.product_id eq 0>
        <cfscript>
            UrunEKle(ix);
        </cfscript>
    </cfif>
</span>
</cfoutput>
            </CFLOOP>
        <cfelseif ARRAYLEN(arguments.Urun.AGAC)>
            <CFLOOP array="#arguments.Urun.AGAC#" index="ix">
                <cfoutput>
       <span style="color:green">#ix.PRODUCT_NAME#</span>
       <cfscript>
        UrunEKle(ix);
    </cfscript>
                </cfoutput>
            </CFLOOP>
        </cfif>
    </cfif>
</cffunction>
<cffunction name="CreateVirtualProduct002">
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


<cfabort>

<cfdump var="#getFr#">
<cfif len(FormData.PRODUCT_ID)>
    <!------ ÜRÜN VAR GÜNCELLEME YAP----->
<CFELSE>
    <!------ ÜRÜN YOK KAYDETME YAP----->
    <cfscript>
        // FİYAT HESAPLANIP GELECEK FİYAT ALANI DEGİSECEK
        //MARJ GELECEK
        // DESCRİPTION ALANI GELECEK
        // VERSİYON SİSTEMİ OLUŞTURULACAK İLERİKİ ZAMANLAR
        //PRODUCT_STAGE FORMDATAYA BOŞ GELİYOR KONTROL EDİLECEK
        //AŞAMA EKLENECEK (PRO_CURRENCY)
        FIYAT=0;
        MARJ=0;
        DESCRIPTION="";
        PRODUCT_STAGE=339;
        PRO_CURRENCY=-1;
         Res=CreateVirtualProductPartner(FormData.PRODUCT_NAME,getFr.PRODUCT_CATID,FIYAT,MARJ,99,1,DESCRIPTION,getFr.PRODUCT_UNIT,FormData.PROJECT_ID,1,PRODUCT_STAGE,PRO_CURRENCY);
        EklenenUrunId=res.IDENTITYCOL
    </cfscript>
    <!----- Ürün Eklendi ----->
    üRÜN AĞACI EKLEME BAŞLADI
    <cfscript>AddUpdProductTree(FormData.PRODUCT_TREE,EklenenUrunId)</cfscript>
ÜRÜN AĞACI EKLEME BİTTİ






</cfif>

<cffunction name="AddUpdProductTree">
    <cfargument name="ProductTreeArr">
    <cfargument name="MainProductId">
   
   
    
    <cfloop array="#arguments.ProductTreeArr#" index="ix">
    <cfquery name="GETFR" datasource="#DSN3#">
        SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#ix.PRODUCT_CATID#
    </cfquery>
    <cfdump var="#ix.PRODUCT_NAME#"><br>
        <cfif isDefined("ix.AGAC") and arraylen(ix.AGAC) gt 0>
            
            <cfscript>
                if(ix.IS_VIRTUAL EQ 1){
                    if(isDefined("ix.PRICE") and len(ix.PRICE)){PRICE=ix.PRICE;}else {PRICE=0;}
                    if(isDefined("ix.MARJ") and len(ix.MARJ)){MARJ=ix.MARJ;}else {MARJ=0;}
                    if(isDefined("ix.DESCRIPTION") and len(ix.DESCRIPTION)){DESCRIPTION=ix.DESCRIPTION;}else {DESCRIPTION="NULL";}
                    
                    RES=CreateVirtualProductPartner(ix.PRODUCT_NAME,ix.PRODUCT_CATID,PRICE,MARJ,0,1,DESCRIPTION,getFr.PRODUCT_UNIT,FormData.PROJECT_ID,'1',339,-6); 
                }
                EKLENECEK_URUN_ID=RES.IDENTITYCOL;
                AddUpdProductTree(ix.AGAC,Res.IDENTITYCOL)</cfscript>
            <cfelse>
                <cfscript>
                    if(isDefined("ix.PRICE") and len(ix.PRICE)){PRICE=ix.PRICE;}else {PRICE=0;}
                    if(isDefined("ix.MARJ") and len(ix.MARJ)){MARJ=ix.MARJ;}else {MARJ=0;}
                    if(isDefined("ix.DESCRIPTION") and len(ix.DESCRIPTION)){DESCRIPTION=ix.DESCRIPTION;}else {DESCRIPTION="NULL";}
                    if(isDefined("ix.QUESTION_ID") and len(ix.QUESTION_ID)){QUESTION_ID=ix.QUESTION_ID;}else {QUESTION_ID="NULL";}
                    if(isDefined("ix.DISCOUNT") and len(ix.DISCOUNT)){DISCOUNT=ix.DISCOUNT;}else {DISCOUNT="NULL";}
                    if(isDefined("ix.MONEY") and len(ix.MONEY)){MONEY=ix.MONEY;}else {MONEY="TL";}
                </cfscript>
                <CFSET EKLENECEK_URUN_ID=ix.PRODUCT_ID>
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
                        #arguments.MainProductId#,
                    #EKLENECEK_URUN_ID#,
                    #EKLENECEK_URUN_ID#,
                    #ix.AMOUNT#,
                    #QUESTION_ID#,
                    #PRICE#,
                    #DISCOUNT#,
                    '#MONEY#',
                    #ix.IS_VIRTUAL#
                    )
                
                </cfquery>        
        </cfif>----->

        <!---- EĞER AĞAÇTAKİ ÜRÜN SANAL ÜRÜNSE------>
        <!-----<CFSET EKLENECEK_URUN_ID=0>
        <cfif ix.PRODUCT_ID eq 0>
            <cfif (isDefined("ix.PRICE") and ix.PRICE neq "undefined") and len(ix.price) gt 0>
                <cfset FIYAT=ix.PRICE>
            <CFELSE>
                <CFSET FIYAT =0>
            </cfif>
            <cfif (isDefined("ix.MARJ") and ix.MARJ neq "undefined") and len(ix.MARJ) gt 0>
                <cfset MARJ=ix.MARJ>
            <CFELSE>
                <CFSET MARJ =0>
            </cfif>
            <cfif (isDefined("ix.DESCRIPTION") and ix.DESCRIPTION neq "undefined") and len(ix.DESCRIPTION) gt 0>
                <cfset DESCRIPTION=ix.DESCRIPTION>
            <CFELSE>
                <CFSET DESCRIPTION ="NULL">
            </cfif>
            <cfquery name="GETPARAMS" datasource="#DSN3#">
                 SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#ix.PRODUCT_CATID#
            </cfquery>
                AĞAÇTA GEZERKEN ÜRÜN EKLEDİM
            <cfscript>
              EK=CreateVirtualProductPartner(ix.PRODUCT_NAME,ix.PRODUCT_CATID,FIYAT,MARJ,0,1,DESCRIPTION,GETPARAMS.PRODUCT_UNIT,FormData.PROJECT_ID,1,0,-6);                
            </cfscript>
            

            <CFSET EKLENECEK_URUN_ID=EK.IDENTITYCOL>
            <cfdump var="#EKLENECEK_URUN_ID#">
            AĞAÇTA GEZERKEN ÜRÜN EKLEMEYİ BİTİRDİM
        <CFELSE>
            <CFSET EKLENECEK_URUN_ID=ix.PRODUCT_ID>
            
        </cfif>
        <cfif isDefined("ix.AGAC") and arrayLen(ix.AGAC)>
            <cfscript>
                AddUpdProductTree(ix.AGAC,EKLENECEK_URUN_ID)
            </cfscript>
        </cfif>
        <cfdump var="#arguments#">
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
                #arguments.MainProductId#,
            #EKLENECEK_URUN_ID#,
            #EKLENECEK_URUN_ID#,
            #ix.AMOUNT#,
            <cfif isDefined("ix.QUESTION_ID") and len(ix.QUESTION_ID)>#ix.QUESTION_ID#<cfelse>NULL</cfif>,
            <cfif isDefined("ix.QUESTION_ID") and len(ix.price)>#ix.PRICE#<cfelse>0</cfif>,
            <cfif isDefined("ix.QUESTION_ID") and len(ix.discount)>#ix.DISCOUNT#<cfelse>0</cfif>,
            <cfif isDefined("ix.QUESTION_ID") and len(ix.money)>'#ix.MONEY#'<cfelse>'TL'</cfif>,
            <cfif isDefined("ix.QUESTION_ID") and len(ix.IS_VIRTUAL)>#ix.IS_VIRTUAL#<cfelse>0</cfif>
            )
        
        </cfquery>----->
    </cfloop>
</cffunction>
<cffunction name="VeriKontrol">
    <cfargument name="veri">
    <cfargument name="dogurysa">
    <cfargument name="degilse">
<cfif veri neq "undefined" and len(veri)>
    <cfreturn dogurysa>
<cfelse>
    <cfreturn degilse>
</cfif>

</cffunction>

<cffunction name="CreateVirtualProductPartner">
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


<cfabort>
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