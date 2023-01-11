<cfcomponent>
    <cfscript>
        if(isdefined("session.pda") and isDefined("session.pda.userid"))
        {
            session_base.money = session.pda.money;
            session_base.money2 = session.pda.money2;
            session_base.userid = session.pda.userid;
            session_base.company_id = session.pda.our_company_id;
            session_base.our_company_id = session.pda.our_company_id;
            session_base.period_id = session.pda.period_id;
        }
        else if(isdefined("session.ep") and isDefined("session.ep.userid"))
        {
            session_base.money = session.ep.money;
            session_base.money2 = session.ep.money2;
            session_base.userid = session.ep.userid;
            session_base.company_id = session.ep.company_id;
            session_base.period_id = session.ep.period_id;
        }
    </cfscript>

    <cffunction name="saveVirtualHydrolic" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="1">        
            <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
                INSERT INTO VIRTUAL_PRODUCTS_PRT(PRODUCT_NAME,PRODUCT_CATID,PRICE,IS_CONVERT_REAL,MARJ,PRODUCT_TYPE,IS_PRODUCTION) VALUES('#arguments.hydProductName#',0,#Filternum(arguments.hydSubTotal)#,0,#Filternum(arguments.marjHyd)#,2,#arguments.IsProduction#)
            </cfquery>
            <cfloop from="1" to="#arguments.hydRwc#" index="i">
                <cfquery name="InsertTree" datasource="#arguments.dsn3#">
                    INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID,PRICE,DISCOUNT,MONEY) 
                    VALUES(
                    #Res.IDENTITYCOL#,
                    #evaluate("arguments.product_id_#i#")#,
                    #evaluate("arguments.stock_id_#i#")#,
                    #Filternum(evaluate("arguments.quantity_#i#"))#,
                    0,
                    #Filternum(evaluate("arguments.price_#i#"))#,
                    #Filternum(evaluate("arguments.discount_#i#"))#,
                    '#evaluate("arguments.money_#i#")#'
                    )
                </cfquery>
            </cfloop>                
            <cfsavecontent  variable="control5">
                <cfdump  var="#CGI#">        
                <cfdump  var="#arguments#">
                
               </cfsavecontent>
               <cffile action="write" file = "c:\PBS\hizlisatiscfc_saveVirtualHydrolic.html" output="#control5#"></cffile>
               <CFSET RETURN_VAL.PID=Res.IDENTITYCOL>
               <CFSET RETURN_VAL.IS_VIRTUAL=1>
               <CFSET RETURN_VAL.PRICE=Filternum(arguments.hydSubTotal)>
               <CFSET RETURN_VAL.QTY=1>
               <CFSET RETURN_VAL.NAME=arguments.hydProductName>
               <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>
        
            
        </cffunction>
        <cffunction name="updateVirtualHydrolic" access="remote" returntype="any" returnFormat="json">
        <cfargument name="IsProduction" default="1">        
        <cfquery name="insertQ" datasource="#arguments.dsn3#" result="Res">
            UPDATE VIRTUAL_PRODUCTS_PRT 
            SET 
                PRODUCT_NAME='#arguments.hydProductName#',
                PRICE=#Filternum(arguments.hydSubTotal)#,
                MARJ=#Filternum(arguments.marjHyd)#,
                PRODUCT_TYPE=2,
                IS_PRODUCTION=1 
            WHERE VIRTUAL_PRODUCT_ID=#arguments.VPID#
        </cfquery>   
        <cfquery name="delTree" datasource="#arguments.dsn3#">
            DELETE FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.VPID#
        </cfquery>
        
        <cfloop from="1" to="#arguments.hydRwc#" index="i">
            <cfquery name="InsertTree" datasource="#arguments.dsn3#">
                INSERT INTO VIRTUAL_PRODUCT_TREE_PRT(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID,PRICE,DISCOUNT,MONEY) 
                VALUES(
                #arguments.VPID#,
                #evaluate("arguments.product_id_#i#")#,
                #evaluate("arguments.stock_id_#i#")#,
                #Filternum(evaluate("arguments.quantity_#i#"))#,
                0,
                #Filternum(evaluate("arguments.price_#i#"))#,
                #Filternum(evaluate("arguments.discount_#i#"))#,
                '#evaluate("arguments.money_#i#")#'
                )
            </cfquery>
        </cfloop>
        <CFSET RETURN_VAL.PID=arguments.VPID>
        <CFSET RETURN_VAL.IS_VIRTUAL=1>
        <CFSET RETURN_VAL.PRICE=arguments.hydSubTotal>
        <CFSET RETURN_VAL.QTY=1>
        <CFSET RETURN_VAL.ROW_ID=arguments.ROWID>
        <CFSET RETURN_VAL.NAME=arguments.hydProductName>
        <cfsavecontent  variable="control5">
            <cfdump  var="#CGI#">        
            <cfdump  var="#arguments#">
            
           </cfsavecontent>
           <cffile action="write" file = "c:\PBS\hizlisatiscfc_UpdateVirtualHydrolick.html" output="#control5#"></cffile>
        <cfreturn Replace(SerializeJSON(RETURN_VAL),'//','')>   
        </cffunction>
        
<cffunction name="SaveRealHydrolic" access="remote" returntype="any" returnFormat="json">
    <cfreturn Replace(SerializeJSON(arguments),'//','')>   
</cffunction>
</cfcomponent>