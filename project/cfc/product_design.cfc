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
            <cfargument name="tipo" default="1">
            <cfset TreeArr="">
            <cfif arguments.isVirtual eq 1>                
                <cfset TreeArr=getTrees(product_id,isVirtual,ddsn3,product_id,company_id,price_catid,tipo)>
            <cfelse>               
                <cfset TreeArr=getTrees(product_id,0,ddsn3,stock_id,company_id,price_catid,tipo)>
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
        <cfargument name="tipo" default="1">
        <cfset dsn3=arguments.ddsn3>
        <cfquery name="getTree" datasource="#dsn3#">
            <cfif arguments.isVirtual eq 1>
            SELECT *,STOCK_ID AS RELATED_ID,VPT_ID AS PRODUCT_TREE_ID,PRICE,DISCOUNT,MONEY FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.pid# AND PRODUCT_ID <>0
            <cfelse>
            select *,0 AS IS_VIRTUAL,(SELECT PROPERTY3 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID=PRODUCT_TREE.PRODUCT_ID AND PRO_INFO_ID=2) AS DISPLAY_NAME,PRICE_PBS AS PRICE,OTHER_MONEY_PBS AS MONEY,DISCOUNT_PBS AS DISCOUNT from PRODUCT_TREE WHERE STOCK_ID=#arguments.sid# </cfif>
            </cfquery>       
      <cfsavecontent variable="test1">
        <cfdump var="#getTree#">
      </cfsavecontent>
      <cffile action="write" file = "c:\PBS\getTrees#arguments.pid#.html" output="#test1#"></cffile>
            <cfset say=0> 
       <cfsavecontent variable="myV">[<cfloop query="getTree"><CFIF  NOT LEN (PRICE) AND PRICE EQ 0><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)><CFELSE><cfif arguments.tipo eq 1><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)><cfset priceData.PRICE=PRICE><cfset priceData.DISCOUNT=DISCOUNT><cfset priceData.MONEY=MONEY><cfset priceData.PRICE=PRICE><cfelse><cfset priceData=getPriceFunk(PRODUCT_ID=PRODUCT_ID,IS_VIRTUAL=IS_VIRTUAL,COMPANY_ID=arguments.company_id,PRICE_CATID=arguments.price_catid,ddsn3=arguments.ddsn3)></cfif><!---<cfset priceData.PRICE=PRICE><cfset priceData.DISCOUNT=DISCOUNT><cfset priceData.MONEY=MONEY><cfset priceData.PRICE=PRICE>---></CFIF> <cfset say=say+1><cfset O=structNew()><cfif IS_VIRTUAL eq 1><cfset O.STOCK_ID=STOCK_ID><CFELSE><CFSET O.STOCK_ID=RELATED_ID></cfif><cfset O.PRICE=priceData.PRICE><cfset O.STANDART_PRICE=priceData.STANDART_PRICE><cfset O.MONEY=priceData.MONEY><cfset O.DISCOUNT=priceData.DISCOUNT><cfset O.IS_VIRTUAL=IS_VIRTUAL><cfset O.VIRTUAL_PRODUCT_TREE_ID=0><CFSET O.PRODUCT_TREE_ID=PRODUCT_TREE_ID><cfset O.DISPLAY_NAME=DISPLAY_NAME><cfset O.PRODUCT_ID=PRODUCT_ID><cfquery name="getSInfo" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#PRODUCT_ID#<cfelse>SELECT * FROM STOCKS AS S WHERE PRODUCT_ID=#PRODUCT_ID#</cfif></cfquery><cfset O.PRODUCT_NAME=getSInfo.PRODUCT_NAME><cfset O.AMOUNT=AMOUNT><cfquery name="ishvTree" datasource="#dsn3#"><cfif IS_VIRTUAL EQ 1>SELECT * FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#PRODUCT_ID#<cfelse>SELECT * FROM PRODUCT_TREE AS S WHERE STOCK_ID=(SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID=#PRODUCT_ID# AND STOCK_STATUS=1)</cfif></cfquery><cfoutput>{"PRODUCT_ID":#O.PRODUCT_ID#,"PRODUCT_NAME":"#O.PRODUCT_NAME#","AMOUNT":#O.AMOUNT#,"STOCK_ID":#O.STOCK_ID#,"DISPLAYNAME":"#O.DISPLAY_NAME#","IS_VIRTUAL":"#O.IS_VIRTUAL#","PRICE":"#O.PRICE#","STANDART_PRICE":"#O.STANDART_PRICE#","MONEY":"#O.MONEY#","DISCOUNT":"#O.DISCOUNT#","VIRTUAL_PRODUCT_TREE_ID":#O.VIRTUAL_PRODUCT_TREE_ID#,"PRODUCT_TREE_ID":"#O.PRODUCT_TREE_ID#","QUESTION_ID":"#QUESTION_ID#","QUESTION_NAME":"#getQuestionData(QUESTION_ID).QUESTION_NAME#","RNDM_ID":#GetRndmNmbr()#,"AGAC":<cfif ishvTree.recordCount><cfscript>writeOutput(getTrees(pid=O.PRODUCT_ID,isVirtual=IS_VIRTUAL,ddsn3=dsn3,sid=ishvTree.STOCK_ID,company_id=arguments.company_id,PRICE_CATID=arguments.price_catid))</cfscript><cfelse>""</cfif>,"ASDF":#say#},</cfoutput></cfloop>]</cfsavecontent>
        <cfset MyS=deserializeJSON(Replace(myV,",]","]","all"))>
        <cfsavecontent variable="test1">
            <style>


                table.cfdump_wddx,
                table.cfdump_xml,
                table.cfdump_struct,
                table.cfdump_varundefined,
                table.cfdump_array,
                table.cfdump_query,
                table.cfdump_cfc,
                table.cfdump_object,
                table.cfdump_binary,
                table.cfdump_udf,
                table.cfdump_udfbody,
                table.cfdump_varnull,
                table.cfdump_udfarguments {
                    font-size: xx-small;
                    font-family: verdana, arial, helvetica, sans-serif;
                }
            
                table.cfdump_wddx th,
                table.cfdump_xml th,
                table.cfdump_struct th,
                table.cfdump_varundefined th,
                table.cfdump_array th,
                table.cfdump_query th,
                table.cfdump_cfc th,
                table.cfdump_object th,
                table.cfdump_binary th,
                table.cfdump_udf th,
                table.cfdump_udfbody th,
                table.cfdump_varnull th,
                table.cfdump_udfarguments th {
                    text-align: left;
                    color: white;
                    padding: 5px;
                }
            
                table.cfdump_wddx td,
                table.cfdump_xml td,
                table.cfdump_struct td,
                table.cfdump_varundefined td,
                table.cfdump_array td,
                table.cfdump_query td,
                table.cfdump_cfc td,
                table.cfdump_object td,
                table.cfdump_binary td,
                table.cfdump_udf td,
                table.cfdump_udfbody td,
                table.cfdump_varnull td,
                table.cfdump_udfarguments td {
                    padding: 3px;
                    background-color: #ffffff;
                    vertical-align : top;
                }
            
                table.cfdump_wddx {
                    background-color: #000000;
                }
                table.cfdump_wddx th.wddx {
                    background-color: #444444;
                }
            
            
                table.cfdump_xml {
                    background-color: #888888;
                }
                table.cfdump_xml th.xml {
                    background-color: #aaaaaa;
                }
                table.cfdump_xml td.xml {
                    background-color: #dddddd;
                }
            
                table.cfdump_struct {
                    background-color: #0000cc ;
                }
                table.cfdump_struct th.struct {
                    background-color: #4444cc ;
                }
                table.cfdump_struct td.struct {
                    background-color: #ccddff;
                }
            
                table.cfdump_varundefined {
                    background-color: #CC3300 ;
                }
                table.cfdump_varundefined th.varundefined {
                    background-color: #CC3300 ;
                }
                table.cfdump_varundefined td.varundefined {
                    background-color: #ccddff;
                }
            
                table.cfdump_array {
                    background-color: #006600 ;
                }
                table.cfdump_array th.array {
                    background-color: #009900 ;
                }
                table.cfdump_array td.array {
                    background-color: #ccffcc ;
                }
            
                table.cfdump_query {
                    background-color: #884488 ;
                }
                table.cfdump_query th.query {
                    background-color: #aa66aa ;
                }
                table.cfdump_query td.query {
                    background-color: #ffddff ;
                }
            
            
                table.cfdump_cfc {
                    background-color: #ff0000;
                }
                table.cfdump_cfc th.cfc{
                    background-color: #ff4444;
                }
                table.cfdump_cfc td.cfc {
                    background-color: #ffcccc;
                }
            
            
                table.cfdump_object {
                    background-color : #ff0000;
                }
                table.cfdump_object th.object{
                    background-color: #ff4444;
                }
            
                table.cfdump_binary {
                    background-color : #eebb00;
                }
                table.cfdump_binary th.binary {
                    background-color: #ffcc44;
                }
                table.cfdump_binary td {
                    font-size: x-small;
                }
                table.cfdump_udf {
                    background-color: #aa4400;
                }
                table.cfdump_udf th.udf {
                    background-color: #cc6600;
                }
                table.cfdump_udfarguments {
                    background-color: #dddddd;
                }
                table.cfdump_udfarguments th {
                    background-color: #eeeeee;
                    color: #000000;
                }
            
            </style> <script language="javascript">
            
            
            // for queries we have more than one td element to collapse/expand
                var expand = "open";
            
                dump = function( obj ) {
                    var out = "" ;
                    if ( typeof obj == "object" ) {
                        for ( key in obj ) {
                            if ( typeof obj[key] != "function" ) out += key + ': ' + obj[key] + '<br>' ;
                        }
                    }
                }
            
            
                cfdump_toggleRow = function(source) {
                    //target is the right cell
                    if(document.all) target = source.parentElement.cells[1];
                    else {
                        var element = null;
                        var vLen = source.parentNode.childNodes.length;
                        for(var i=vLen-1;i>0;i--){
                            if(source.parentNode.childNodes[i].nodeType == 1){
                                element = source.parentNode.childNodes[i];
                                break;
                            }
                        }
                        if(element == null)
                            target = source.parentNode.lastChild;
                        else
                            target = element;
                    }
                    //target = source.parentNode.lastChild ;
                    cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                }
            
                cfdump_toggleXmlDoc = function(source) {
            
                    var caption = source.innerHTML.split( ' [' ) ;
            
                    // toggle source (header)
                    if ( source.style.fontStyle == 'italic' ) {
                        // closed -> short
                        source.style.fontStyle = 'normal' ;
                        source.innerHTML = caption[0] + ' [short version]' ;
                        source.title = 'click to maximize' ;
                        switchLongToState = 'closed' ;
                        switchShortToState = 'open' ;
                    } else if ( source.innerHTML.indexOf('[short version]') != -1 ) {
                        // short -> full
                        source.innerHTML = caption[0] + ' [long version]' ;
                        source.title = 'click to collapse' ;
                        switchLongToState = 'open' ;
                        switchShortToState = 'closed' ;
                    } else {
                        // full -> closed
                        source.style.fontStyle = 'italic' ;
                        source.title = 'click to expand' ;
                        source.innerHTML = caption[0] ;
                        switchLongToState = 'closed' ;
                        switchShortToState = 'closed' ;
                    }
            
                    // Toggle the target (everething below the header row).
                    // First two rows are XMLComment and XMLRoot - they are part
                    // of the long dump, the rest are direct children - part of the
                    // short dump
                    if(document.all) {
                        var table = source.parentElement.parentElement ;
                        for ( var i = 1; i < table.rows.length; i++ ) {
                            target = table.rows[i] ;
                            if ( i < 3 ) cfdump_toggleTarget( target, switchLongToState ) ;
                            else cfdump_toggleTarget( target, switchShortToState ) ;
                        }
                    }
                    else {
                        var table = source.parentNode.parentNode ;
                        var row = 1;
                        for ( var i = 1; i < table.childNodes.length; i++ ) {
                            target = table.childNodes[i] ;
                            if( target.style ) {
                                if ( row < 3 ) {
                                    cfdump_toggleTarget( target, switchLongToState ) ;
                                } else {
                                    cfdump_toggleTarget( target, switchShortToState ) ;
                                }
                                row++;
                            }
                        }
                    }
                }
            
                cfdump_toggleTable = function(source) {
            
                    var switchToState = cfdump_toggleSource( source ) ;
                    if(document.all) {
                        var table = source.parentElement.parentElement ;
                        for ( var i = 1; i < table.rows.length; i++ ) {
                            target = table.rows[i] ;
                            cfdump_toggleTarget( target, switchToState ) ;
                        }
                    }
                    else {
                        var table = source.parentNode.parentNode ;
                        for ( var i = 1; i < table.childNodes.length; i++ ) {
                            target = table.childNodes[i] ;
                            if(target.style) {
                                cfdump_toggleTarget( target, switchToState ) ;
                            }
                        }
                    }
                }
            
                cfdump_toggleSource = function( source ) {
                    if ( source.style.fontStyle == 'italic' || source.style.fontStyle == null) {
                        source.style.fontStyle = 'normal' ;
                        source.title = 'click to collapse' ;
                        return 'open' ;
                    } else {
                        source.style.fontStyle = 'italic' ;
                        source.title = 'click to expand' ;
                        return 'closed' ;
                    }
                }
            
                cfdump_toggleTarget = function( target, switchToState ) {
                    if ( switchToState == 'open' )	target.style.display = '' ;
                    else target.style.display = 'none' ;
                }
            
                // collapse all td elements for queries
                cfdump_toggleRow_qry = function(source) {
                    expand = (source.title == "click to collapse") ? "closed" : "open";
                    if(document.all) {
                        var nbrChildren = source.parentElement.cells.length;
                        if(nbrChildren > 1){
                            for(i=nbrChildren-1;i>0;i--){
                                target = source.parentElement.cells[i];
                                cfdump_toggleTarget( target,expand ) ;
                                cfdump_toggleSource_qry(source);
                            }
                        }
                        else {
                            //target is the right cell
                            target = source.parentElement.cells[1];
                            cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                        }
                    }
                    else{
                        var target = null;
                        var vLen = source.parentNode.childNodes.length;
                        for(var i=vLen-1;i>1;i--){
                            if(source.parentNode.childNodes[i].nodeType == 1){
                                target = source.parentNode.childNodes[i];
                                cfdump_toggleTarget( target,expand );
                                cfdump_toggleSource_qry(source);
                            }
                        }
                        if(target == null){
                            //target is the last cell
                            target = source.parentNode.lastChild;
                            cfdump_toggleTarget( target, cfdump_toggleSource( source ) ) ;
                        }
                    }
                }
            
                cfdump_toggleSource_qry = function(source) {
                    if(expand == "closed"){
                        source.title = "click to expand";
                        source.style.fontStyle = "italic";
                    }
                    else{
                        source.title = "click to collapse";
                        source.style.fontStyle = "normal";
                    }
                }
            
            </script> 
            <cfset MyS=deserializeJSON(Replace(myV,",]","]","all"))>
            <cfdump var="#MyS#">
            <cfdump var="#arguments#">
            <cfdump var="#getTree#">
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\UrunGetir_#arguments.pid#.html" output="#test1#"></cffile>
          <cfreturn replace(serializeJSON(MyS),"//","")>
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
        <cfsavecontent variable="test1">
            
            <cfdump var="#arguments#">
            
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\getPriceFunk_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
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
            <cfsavecontent variable="test1"><cfdump var="#getPrice#"></cfsavecontent>
              <cffile action="write" file = "c:\PBS\getPriceFunk_01_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
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
            <cfsavecontent variable="test1"><cfdump var="#getDiscount#"></cfsavecontent>
            <cffile action="write" file = "c:\PBS\getPriceFunk_02_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfset ReturnData.STANDART_PRICE=getPrice.PRICE>
            <cfset ReturnData.PRICE=getPrice.PRICE>
            <cfset ReturnData.MONEY=getPrice.MONEY>
            <cfset ReturnData.DISCOUNT=getDiscount.DISCOUNT_RATE>
            <cfreturn ReturnData>
        <cfelse>
            <cfset ReturnData.PRICE=0>
            <cfset ReturnData.STANDART_PRICE=0>
            <cfset ReturnData.MONEY="TL">
            <cfset ReturnData.DISCOUNT=0>
            <cfreturn ReturnData>
        </cfif>
        
    </cffunction>

    <cffunction name="getPriceFunk_AJAX" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfargument name="PRODUCT_ID">
        <cfargument name="IS_VIRTUAL">
        <cfargument name="COMPANY_ID">
        <cfargument name="PRICE_CATID">
        <cfargument name="ddsn3">
        <cfargument name="ROW_ID">
        <cfsavecontent variable="test1">
            
            <cfdump var="#arguments#">
            
          </cfsavecontent>
          <cffile action="write" file = "c:\PBS\getPriceFunk_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
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
            <cfsavecontent variable="test1"><cfdump var="#getPrice#"></cfsavecontent>
              <cffile action="write" file = "c:\PBS\getPriceFunk_01_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
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
            <cfsavecontent variable="test1"><cfdump var="#getDiscount#"></cfsavecontent>
            <cffile action="write" file = "c:\PBS\getPriceFunk_02_#arguments.PRICE_CATID#_#arguments.PRODUCT_ID#.html" output="#test1#"></cffile>
            <cfset ReturnData.STANDART_PRICE=getPrice.PRICE>
            <cfset ReturnData.PRICE=getPrice.PRICE>
            <cfset ReturnData.MONEY=getPrice.MONEY>
            <cfset ReturnData.DISCOUNT=getDiscount.DISCOUNT_RATE>
            <CFSET ReturnData.ROW_ID=arguments.ROW_ID>
            <cfreturn ReturnData>
        <cfelse>
            <cfset ReturnData.PRICE=0>
            <cfset ReturnData.STANDART_PRICE=0>
            <cfset ReturnData.MONEY="TL">
            <cfset ReturnData.DISCOUNT=0>
            <CFSET ReturnData.ROW_ID=arguments.ROW_ID>
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
                <a class="list-group-item list-group-item-action" id="VP_#VIRTUAL_PRODUCT_ID#" onclick="ngetTree(#VIRTUAL_PRODUCT_ID#,1,'#arguments.ddsn3#',this,1,'','#PRODUCT_NAME#','#PRODUCT_STAGE#')">
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
    <cffunction name="DELVP" access="remote" httpMethod="POST" >
        <cfargument name="vp_id">
        <cfargument name="ddsn3">
        <cfquery name="del" datasource="#arguments.ddsn3#">
            DELETE  from VIRTUAL_PRODUCTS_PRT WHERE VIRTUAL_PRODUCT_ID=#arguments.vp_id# 
        </cfquery>
        <cfquery name="del" datasource="#arguments.ddsn3#">                
            DELETE  FROM VIRTUAL_PRODUCT_TREE_PRT WHERE VP_ID=#arguments.vp_id# 
        </cfquery>

    </cffunction>
    <cffunction name="SaveTreePrices" httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfdump var="#deserializeJSON(arguments.FORM_DATA)#">
        <cfset dsn3="workcube_metosan_1">
        <CFSET FORM_DATA=deserializeJSON(arguments.FORM_DATA)>
        <cfset IS_VIRTUAL=listGetAt(FORM_DATA.PRODUCT,2,"**")>
        <cfset MAIN_PRODUCT_ID=listGetAt(FORM_DATA.PRODUCT,1,"**")>
      

      <cfquery name="ins" datasource="#dsn3#" result="res">
          INSERT INTO PROJECT_PRODUCTS_TREE_PRICES_MAIN(RECORD_DATE,RECORD_EMP,MAIN_PRODUCT_ID,PROJECT_ID,IS_VIRTUAL) VALUES (GETDATE(),#FORM_DATA.RECORD_EMP#,#MAIN_PRODUCT_ID#,#FORM_DATA.PROJECT_ID#,#IS_VIRTUAL#)
        </cfquery>
        <cfdump var="#res#">
        <cfloop array="#FORM_DATA.PRODUCT_TREE#" item="it">
          <cfif IS_VIRTUAL EQ 0>
          <cfquery name="ins2" datasource="#dsn3#">
               INSERT INTO PROJECT_REAL_PRODUCTS_TREE_PRICES(PROJECT_ID,MAIN_PRODUCT_ID ,PRODUCT_TREE_ID ,UPPER_TRERE_ID ,AMOUNT ,PRICE ,OTHER_MONEY ,DISCOUNT ,MAIN_ID )
               VALUES (#FORM_DATA.PROJECT_ID#,#MAIN_PRODUCT_ID#,#it.PRODUCT_TREE_ID#,#it.UPPER_PRODUCT_TREE_ID#,#it.AMOUNT#,#it.PRICE#,'#it.OTHER_MONEY#',#it.DISCOUNT#,#res.IDENTITYCOL#)
            </cfquery>
            <CFELSE>
                <cfquery name="ins2" datasource="#dsn3#">
                    INSERT INTO PROJECT_VIRTUAL_PRODUCTS_TREE_PRICES(PROJECT_ID,MAIN_PRODUCT_ID ,PRODUCT_TREE_ID ,UPPER_TRERE_ID ,AMOUNT ,PRICE ,OTHER_MONEY ,DISCOUNT ,MAIN_ID )
                    VALUES (#FORM_DATA.PROJECT_ID#,#MAIN_PRODUCT_ID#,#it.PRODUCT_TREE_ID#,#it.UPPER_PRODUCT_TREE_ID#,#it.AMOUNT#,#it.PRICE#,'#it.OTHER_MONEY#',#it.DISCOUNT#,#res.IDENTITYCOL#)
                 </cfquery>
            </cfif>
        </cfloop>
        <cfloop array="#FORM_DATA.KURLAR#" item="kur">
        <cfquery name="INSKUR" datasource="#DSN3#">
            INSERT INTO PROJECT_PRODUCTS_TREE_PRICES_MAIN_MONEY(MAIN_ID,MONEY,RATE2) VALUES(#res.IDENTITYCOL#,'#kur.MONEY#',#kur.RATE2#)
        </cfquery>
        </cfloop>
    </cffunction>

</cfcomponent>