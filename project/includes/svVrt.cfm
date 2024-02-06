<cfquery name="getFr" datasource="#dsn3#">
    SELECT PCPS.*,PC.HIERARCHY,PC.PRODUCT_CAT,PC.DETAIL FROM #DSN#.PRO_PROJECTS AS PP
    LEFT JOIN #DSN#.SETUP_MAIN_PROCESS_CAT AS SMC ON SMC.MAIN_PROCESS_CAT_ID=PP.PROCESS_CAT
    LEFT JOIN #DSN3#.MAIN_PROCESS_CAT_TO_PRODUCT_CAT AS MPTC ON MPTC.MAIN_PROCESS_CATID=SMC.MAIN_PROCESS_CAT_ID
    LEFT JOIN #DSN1#.PRODUCT_CAT AS PC ON PC.PRODUCT_CATID=MPTC.PRODUCT_CATID
    LEFT JOIN #DSN3#.PRODUCT_CAT_PRODUCT_PARAM_SETTINGS as PCPS ON PCPS.PRODUCT_CATID=PC.PRODUCT_CATID
    WHERE PP.PROJECT_ID=#FormData.PROJECT_ID#
</cfquery>
<cfset PROJE_IDSI=FormData.PROJECT_ID>

<cfscript> UrunParse(FormData,0);</cfscript>

Giriş 1
<cffunction name="UrunParse"> 
    <cfargument name="Urun">   
    <cfargument name="DSC" default="1">
    <CFSET AktifUrun=arguments.Urun>   
    <span style="color:green">POS: 00000</span> <code>Aktif Ürün Product Id = <cfoutput>#AktifUrun.PRODUCT_ID#</cfoutput></code><br/>
    <!----//BILGI SANAL ÜRÜN OLUŞTUMU KONTROLÜ ---->
    
    <CFIF AktifUrun.PRODUCT_ID neq 0 and len(AktifUrun.PRODUCT_ID) gt 0> <!----//BILGI Bu Ürün Sanal Olarak Eklenmiş Mi ----->        
        <cfscript>
            UpdateVirtualProduct_NEW(VP_ID=AktifUrun.PRODUCT_ID,PRICE=AktifUrun.PRICE,Discount=AktifUrun.DISCOUNT,OtherMoney='#AktifUrun.MONEY#',DisplayName='#AktifUrun.DISPLAY_NAME#',ProductStage=AktifUrun.PRODUCT_STAGE)
            ClearVirtualTree(AktifUrun.PRODUCT_ID);            
        </cfscript>
        
        <CFSET AGACIM=arrayNew(1)>
        <cfif arrayLen(AktifUrun.PRODUCT_TREE)><CFSET AGACIM=AktifUrun.PRODUCT_TREE></cfif> <!---- PRODUCT_TREE DOLUMU --->
        <cfif arrayLen(AktifUrun.AGAC)><CFSET AGACIM=AktifUrun.AGAC></cfif> <!---- AGAC DOLUMU --->
        <cfloop array="#AGACIM#" item="Ait"> <!--- //BILGI Ağaç Döngüsü ---->            
            <cfif Ait.is_virtual eq 1> <!--- //BILGI Ürün Sanalmı ---->
                
                <cfif Ait.PRODUCT_ID neq 0 and len(Ait.PRODUCT_ID) gt 0> <!--- //BILGI ürün Eklenmiş mi ? ---->
                    <!---- //BILGI Ürün Eklenmişse  ---->
                   <cfscript>
                        UpdateVirtualProduct_NEW(VP_ID=Ait.PRODUCT_ID,PRICE=Ait.PRICE,Discount=Ait.DISCOUNT,OtherMoney='#Ait.MONEY#',DisplayName='#Ait.DISPLAY_NAME#',ProductStage="");
                        ClearVirtualTree(Ait.PRODUCT_ID);            
                        
                        if(isDefined("Ait.price")){
                            prcex=Ait.price;
                        }else{
                            prcex=0;
                        }
                        if(isDefined("Ait.discount")){
                            dsc=Ait.discount;
                        }else{
                            dsc=0;
                        }
                        if(isDefined("Ait.MONEY")){
                            mny=Ait.MONEY;
                        }else{
                            mny="TL";
                        }
                        if(isDefined("Ait.DISPLAY_NAME") && Ait.DISPLAY_NAME != "undefined" ){
                            dname=Ait.DISPLAY_NAME
                        }else{
                            dName="";
                        }
                        InsertedItem=InsertTree(AktifUrun.PRODUCT_ID,Ait.PRODUCT_ID,Ait.STOCK_ID,Ait.AMOUNT,aiq,aip,aid,aim,Ait.IS_VIRTUAL,dName);
                        
                    </cfscript>      
                    <cfoutput>
                        <span style="color:red">POS: 00001</span><br/>
                        UpdateVirtualProduct_NEW(VP_ID=#Ait.PRODUCT_ID#,PRICE=#Ait.PRICE#,Discount=#Ait.DISCOUNT#,OtherMoney='#Ait.MONEY#',DisplayName='#Ait.DISPLAY_NAME#',ProductStage="");<br/>
                        ClearVirtualTree(#Ait.PRODUCT_ID#);<br/>
                        InsertedItem=InsertTree(#AktifUrun.PRODUCT_ID#,#Ait.PRODUCT_ID#,#Ait.STOCK_ID#,#Ait.AMOUNT#,#aiq#,#aip#,#aid#,#aim#,#Ait.IS_VIRTUAL#,#dName#);<br/>
                    </cfoutput>

                    <CFIF arrayLen(ait.AGAC)>
                        <cfset Ait.PRODUCT_STAGE =FormData.PRODUCT_STAGE>
                         <cfscript>   UrunParse(Ait);</cfscript>
                     </CFIF>               
                <cfelse> 
                    <cfquery name="getParams" datasource="#dsn3#">
                        SELECT * FROM PRODUCT_CAT_PRODUCT_PARAM_SETTINGS where PRODUCT_CATID=#Ait.PRODUCT_CATID#
                    </cfquery>
                    <cfscript>
                        CreatedProduct.IDENTITYCOL="1453";
                        CreatedProduct= CreateVirtualProduct_New(
                            Ait.PRODUCT_NAME,
                            Ait.PRODUCT_CATID,
                            0,
                            0,
                            99,
                            1,
                            '',
                            getParams.PRODUCT_UNIT,
                            PROJE_IDSI,
                            '0',
                            FormData.PRODUCT_STAGE,
                            -6
                        );
                    </cfscript>
                    <cfoutput>
                        <span style="color:red">POS: 00002</span><br/>
                        CreatedProduct= CreateVirtualProduct_New(
                            #Ait.PRODUCT_NAME#,
                            #Ait.PRODUCT_CATID#,
                            0,
                            0,
                            99,
                            1,
                            '',
                            #getParams.PRODUCT_UNIT#,
                            #PROJE_IDSI#,
                            '0',
                            #FormData.PRODUCT_STAGE#,
                            -6
                        )<br/>
                    </cfoutput>
                    <CFSET Ait.PRODUCT_ID=CreatedProduct.IDENTITYCOL>
                   <cfscript> InsertedItem=InsertTree(AktifUrun.PRODUCT_ID,Ait.PRODUCT_ID,Ait.STOCK_ID,Ait.AMOUNT,aiq,aip,aid,aim,Ait.IS_VIRTUAL,dName);</cfscript>
                   <cfoutput>
                    <span style="color:red">POS: 00003</span><br/>
                    InsertedItem=InsertTree(#AktifUrun.PRODUCT_ID#,#Ait.PRODUCT_ID#,#Ait.STOCK_ID#,#Ait.AMOUNT#,#aiq#,#aip#,#aid#,#aim#,#Ait.IS_VIRTUAL#,#dName#); <br/>
                   </cfoutput>
                </cfif>
                <CFIF isDefined("ait.AGAC") and arrayLen(ait.AGAC)>
                   <cfset Ait.PRODUCT_STAGE =FormData.PRODUCT_STAGE>
                    <cfscript>   UrunParse(Ait);</cfscript>
                </CFIF>
            <cfelse>
                <cfif isDefined("ai.QUESTION_ID")><cfset aiq=Ait.QUESTION_ID><cfelse><cfset aiq="NULL"></cfif>
                    <cfif isDefined("ai.PRICE")><cfset aip=Ait.PRICE><cfelse><cfset aip="0"></cfif>
                    <cfif isDefined("ai.DISCOUNT")><cfset aid=Ait.DISCOUNT><cfelse><cfset aid="0"></cfif>
                    <cfif isDefined("ai.MONEY")><cfset aim=Ait.MONEY><cfelse><cfset aim="TL"></cfif>
                    <cfif isDefined("ai.DISPLAY_NAME") and Ait.DISPLAY_NAME neq "undefined"><cfset dName=Ait.DISPLAY_NAME><cfelse><cfset dName=""></cfif>
                <cfscript>
                    if(isDefined("Ait.price")){
                        prcex=Ait.price;
                    }else{
                        prcex=0;
                    }
                    if(isDefined("Ait.discount")){
                        dsc=Ait.discount;
                    }else{
                        dsc=0;
                    }
                    if(isDefined("Ait.MONEY")){
                        mny=Ait.MONEY;
                    }else{
                        mny="TL";
                    }
                    if(isDefined("Ait.DISPLAY_NAME") && Ait.DISPLAY_NAME != "undefined" ){
                        dname=Ait.DISPLAY_NAME
                    }else{
                        dName="";
                    }
                InsertedItem=InsertTree(AktifUrun.PRODUCT_ID,Ait.PRODUCT_ID,Ait.STOCK_ID,Ait.AMOUNT,aiq,aip,aid,aim,Ait.IS_VIRTUAL,dName);
                </cfscript>
                <cfoutput>
                    <span style="color:red">POS: 00004</span><br/>
                    InsertedItem=InsertTree(#AktifUrun.PRODUCT_ID#,#Ait.PRODUCT_ID#,#Ait.STOCK_ID#,#Ait.AMOUNT#,#aiq#,#aip#,#aid#,#aim#,#Ait.IS_VIRTUAL#,#dName#);<br/>
                </cfoutput>
            </cfif>
        </cfloop>
    <cfelse> <!-------Ürün Eklenmemişse------>
        <span style="color:red">POS: 00005</span><br/>
    </CFIF>
</cffunction>

<cffunction name="UpdateVirtualProduct_NEW">
    <cfargument name="VP_ID">
    <cfargument name="PRICE" default="">
    <cfargument name="Discount" default="">
    <cfargument name="OtherMoney" default="">
    <cfargument name="DisplayName" default="">
    <cfargument name="ProductStage"default="" >

    <cfquery name="UpdateProduct" datasource="#dsn3#">
        UPDATE VIRTUAL_PRODUCTS_PRT SET 
                <CFIF LEN(arguments.PRICE)>
                    PRICE=#arguments.PRICE#,
                </CFIF>
                <CFIF LEN(arguments.Discount)>
                    DISCOUNT=#arguments.Discount#,
                </CFIF>
                <CFIF LEN(arguments.OtherMoney)>
                    OTHER_MONEY='#arguments.OtherMoney#',
                </CFIF>
                <CFIF LEN(arguments.DisplayName)>
                    DISPLAY_NAME='#arguments.DisplayName#',
                </CFIF>
                <CFIF LEN(arguments.ProductStage)>
                    PRODUCT_STAGE=#arguments.ProductStage#
                </CFIF>
        WHERE VIRTUAL_PRODUCT_ID=#arguments.VP_ID#
    </cfquery>
</cffunction>
<cffunction name="InsertTreeNew">
<cfargument name="VP_ID">
<cfargument name="PRODUCT_ID">
<cfargument name="STOCK_ID">
<cfargument name="AMOUNT">
<cfargument name="QUESTION_ID">
<cfargument name="PRICE">
<cfargument name="DISCOUNT">
<cfargument name="MONEY">
<cfargument name="IS_VIRTUAL">
<cfargument name="DISPLAY_NAME" default="">
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
DISPLAY_NAME
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
#arguments.IS_VIRTUAL#,
<cfif len(arguments.DISPLAY_NAME)>'#arguments.DISPLAY_NAME#'<CFELSE>NULL</cfif>
)

</cfquery>
<cfreturn res>
</cffunction>
<cffunction name="CreateVirtualProduct_New">
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



<cffunction name="ClearVirtualTree">
    <cfargument name="VP_ID">
    <cfquery name="delTree" datasource="#dsn3#">
        DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.VP_ID#
    </cfquery>
</cffunction>




<cfabort> <!----- Burası Bir Önceki Hali --------->
<cfif FormData.PRODUCT_ID neq 0 and len(FormData.PRODUCT_ID)> <!---//BILGI ÜRÜN IDSI VARSA YANİ BU ÜÜRÜN DAHA ÖNCE SANAL OLARAK OLUŞTUYSA ----->
    <cfquery name="del" datasource="#dsn3#">
        DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#FormData.PRODUCT_ID#
    </cfquery>
    <cfif arrayLen(FormData.PRODUCT_TREE)>
        <cfloop array="#FormData.PRODUCT_TREE#" index="ai">
            <cfif isDefined("ai.QUESTION_ID")><cfset aiq=ai.QUESTION_ID><cfelse><cfset aiq="NULL"></cfif>
            <cfif isDefined("ai.PRICE")><cfset aip=ai.PRICE><cfelse><cfset aip="0"></cfif>
            <cfif isDefined("ai.DISCOUNT")><cfset aid=ai.DISCOUNT><cfelse><cfset aid="0"></cfif>
            <cfif isDefined("ai.MONEY")><cfset aim=ai.MONEY><cfelse><cfset aim="TL"></cfif>
            <cfif isDefined("ai.DISPLAY_NAME") and ai.DISPLAY_NAME neq "undefined"><cfset dName=ai.DISPLAY_NAME><cfelse><cfset dName=""></cfif>
            <cfif ai.PRODUCT_ID neq 0>
                <cfscript>
                    
                    InsertedItem=InsertTree(FormData.PRODUCT_ID,ai.PRODUCT_ID,ai.STOCK_ID,ai.AMOUNT,aiq,aip,aid,aim,ai.IS_VIRTUAL,dName);
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
                        FormData.PRODUCT_STAGE,
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
                    if(isDefined("ai.DISPLAY_NAME") && ai.DISPLAY_NAME != "undefined" ){
                        dname=ai.DISPLAY_NAME
                    }else{
                        dName="";
                    }
                    InsertedItem=InsertTree(FormData.PRODUCT_ID,CreatedProductId,0,ai.AMOUNT,aiq,prcex,dsc,mny,ai.IS_VIRTUAL,dName); //YAPILACAK INSERT TREE FONKSİYONUNU KONTROL ET
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
                            if(isDefined("idx.DISPLAY_NAME") && idx.DISPLAY_NAME != "undefined"){
                                dname=idx.DISPLAY_NAME
                            }else{
                                dName="";
                            }
                            InsertedItem=InsertTree(CreatedProductId,idx.PRODUCT_ID,idx.STOCK_ID,idx.AMOUNT,queid,prcex1,dsc1,mny1,idx.IS_VIRTUAL,dName);
                        </cfscript>
                    </cfloop>
                </cfif>
            </cfif>
        </cfloop>
    </cfif>    
<cfelse> <!-----//BILGI FormData.PRODUCT_ID neq 0 and len(FormData.PRODUCT_ID)   ÜRÜN IDSI YOKSA YANI SANAL OLARAK OLUŞMADIYSA---->
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
    <cfif arrayLen(FormData.PRODUCT_TREE)>
        <cfloop array="#FormData.PRODUCT_TREE#" index="ai">
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
                    if(isDefined("ai.DISPLAY_NAME") && ai.DISPLAY_NAME != "undefined" ){
                        dname=ai.DISPLAY_NAME
                    }else{
                        dName="";
                    }
                        InsertedItem=InsertTree(CreatedProductId,ai.PRODUCT_ID,ai.STOCK_ID,ai.AMOUNT,queid,prcex,dsc,mny,ai.IS_VIRTUAL,dName);
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
                        FormData.PRODUCT_STAGE,
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
                    if(isDefined("ai.DISPLAY_NAME") && ai.DISPLAY_NAME != "undefined" ){
                        dname=ai.DISPLAY_NAME
                    }else{
                        dName="";
                    }
                    InsertedItem=InsertTree(FormData.PRODUCT_ID,CreatedProductId,0,ai.AMOUNT,queid,prcex,dsc,mny,ai.IS_VIRTUAL,dName);
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
                                queid="NULL";
                            }
                            if(isDefined("idx.DISPLAY_NAME") && idx.DISPLAY_NAME != "undefined" ){
                                dname=idx.DISPLAY_NAME
                            }else{
                                dName="";
                            }
                            InsertedItem=InsertTree(CreatedProductId,idx.PRODUCT_ID,idx.STOCK_ID,idx.AMOUNT,idx.QUESTION_ID,prcex1,dsc1,mny1,idx.IS_VIRTUAL,dname);
                        </cfscript>
                    </cfloop>
                </cfif>
            </cfif>

        </cfloop>
    </cfif>
</cfif>

<script>
   window.opener.ngetTree(<cfoutput>#FormData.PRODUCT_ID#</cfoutput>,1,'<cfoutput>#dsn3#</cfoutput>',"",1,'','<cfoutput>#FormData.PRODUCT_NAME#</cfoutput>','<cfoutput>#FormData.PRODUCT_STAGE#</cfoutput>')
  // this.close();
    
</script>


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
<cfargument name="DISPLAY_NAME" default="">
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
DISPLAY_NAME
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
#arguments.IS_VIRTUAL#,
<cfif len(arguments.DISPLAY_NAME)>'#arguments.DISPLAY_NAME#'<CFELSE>NULL</cfif>
)

</cfquery>
<cfreturn res>
</cffunction>
