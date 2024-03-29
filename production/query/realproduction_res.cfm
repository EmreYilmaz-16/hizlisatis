<cfquery name="getTree" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCTION_ORDERS_STOCKS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>

<cfquery name="getVirtualProductionOrder" datasource="#dsn3#">
	SELECT * FROM VIRTUAL_PRODUCTION_ORDERS where V_P_ORDER_ID=#attributes.V_P_ORDER_ID#
</cfquery>
<cfquery name="GETSTOK" datasource="#DSN3#">
    SELECT * FROM STOCKS WHERE PRODUCT_ID=#getVirtualProductionOrder.STOCK_ID#
</cfquery>

<cfquery name="AddVirtualResult" datasource="#dsn3#">
	INSERT INTO VIRTUAL_PRODUCTION_ORDERS_RESULT (
		P_ORDER_ID,RECORD_DATE,RECORD_EMP,RESULT_AMOUNT
		)
	VALUES(
		#attributes.V_P_ORDER_ID#,#NOW()#,#session.ep.userid#,#attributes.PRODUCT_AMOUNT_1_0#
		)

</cfquery>
<cfquery name="getMaster" datasource="#dsn1#">
    SELECT S.PRODUCT_ID
	    ,S.PRODUCT_CODE
	    ,S.PRODUCT_CODE_2
	    ,S.PRODUCT_NAME                    
	    ,S.PRODUCT_CATID
	    ,S.PROD_COMPETITIVE
	    ,S.MANUFACT_CODE
	    ,S.MIN_MARGIN 
	    ,S.IS_QUALITY
	    ,S.MAX_MARGIN
	    ,S.SHELF_LIFE
	    ,S.SEGMENT_ID
	    ,S.BSMV
	    ,S.OIV                     
	    ,S.TAX_PURCHASE
	    ,S.IS_INVENTORY
	    ,S.PRODUCT_ID
	    ,S.IS_PRODUCTION 
	    ,S.IS_SALES
	    ,S.IS_ZERO_STOCK
	    ,S.BRAND_ID
	    ,S.IS_LIMITED_STOCK
	    ,S.IS_PURCHASE
	    ,S.IS_INTERNET
	    ,S.IS_EXTRANET                                        
	    ,S.TAX
	    ,S.PRODUCT_STAGE
	    ,PU.IS_MAIN
		,PU.MAIN_UNIT
		,PU.MAIN_UNIT_ID
	    ,SS.STOCK_ID
	FROM PRODUCT AS S 
	LEFT JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID     
	INNER JOIN STOCKS AS SS ON SS.PRODUCT_ID=S.PRODUCT_ID                     
	WHERE PRODUCT_CATID=#GETSTOK.PRODUCT_CATID# AND PRODUCT_DETAIL2='MASTER'
	</cfquery>

<cfset sidArr=arrayNew(1)>
<cfloop query="getTree">
	<cfscript>
		o={
			PID=PRODUCT_ID,
			SID=STOCK_ID,
			QTY=AMOUNT,
			QUESTION_ID=QUESTION_ID
		};
		arrayAppend(sidArr,o);
	</cfscript>	

</cfloop>
<cfscript>
    main_stock_id = GETSTOK.STOCK_ID;
    main_product_id =GETSTOK.PRODUCT_ID;
    spec_name="#GETSTOK.PRODUCT_NAME#";                          
</cfscript>  
<cfset product_tree_id_list = ''>
<cfset spec_main_id_list =''>

<cfquery name="DELtREE" datasource="#DSN3#">
    DELETE FROM PRODUCT_TREE WHERE STOCK_ID=#GETSTOK.STOCK_ID#

</cfquery>

<cfloop array="#sidArr#" item="pr">
    <cfquery name="getStock_Info" datasource="#dsn3#" >
        SELECT TOP 1 PRODUCT_ID,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID=#pr.SID#
    </cfquery>
<cfset attributes.main_stock_id=GETSTOK.STOCK_ID>
    <cfset attributes.PRODUCT_ID=getStock_Info.PRODUCT_ID>
    <cfset attributes.add_stock_id=pr.SID>
    <cfset attributes.AMOUNT = filterNum(pr.QTY)>
    <cfset attributes.UNIT_ID = getStock_Info.PRODUCT_UNIT_ID>
    <cfset attributes.alternative_questions = PR.QUESTION_ID>
       <cfinclude template="/AddOns/Partner/satis/Includes/PARTNERTREEPORT.cfm">
        <cfset SPEC_MAIN_ID_LIST= listAppend(SPEC_MAIN_ID_LIST, getStock_Info.STOCK_ID)> 
</cfloop>
buraya kadar geldim sanırım
<cfquery name="insertOpp" datasource="#dsn3#">
    INSERT INTO PRODUCT_TREE (
        IS_TREE
        ,AMOUNT
        ,OPERATION_TYPE_ID
        ,STOCK_ID
        ,IS_CONFIGURE
        ,IS_SEVK
        ,SPECT_MAIN_ID
        ,IS_PHANTOM
        ,QUESTION_ID
        ,PROCESS_STAGE
        ,RECORD_EMP
        ,RECORD_DATE
        ,IS_FREE_AMOUNT
        ,FIRE_AMOUNT
        ,FIRE_RATE
        ,DETAIL
    )
        SELECT  NULL
        ,AMOUNT
        ,OPERATION_TYPE_ID
        ,#attributes.main_stock_id#
        ,IS_CONFIGURE
        ,IS_SEVK
        ,SPECT_MAIN_ID
        ,IS_PHANTOM
        ,QUESTION_ID
        ,61
        ,#session.ep.userid#
        ,#now() #
        ,NULL
        ,FIRE_AMOUNT
        ,FIRE_RATE
        ,DETAIL
        FROM PRODUCT_TREE AS PRODUCT_TREE1
        WHERE STOCK_ID = #getMaster.STOCK_ID#                    
</cfquery>	

<cfset attributes.stock_id=main_stock_id>
<cfset attributes.main_stock_id=main_stock_id>
<cfset attributes.old_main_spec_id =0>
<cfset attributes.process_stage=299>

<cfset dsn2_alias=dsn2>
<cfset dsn3_alias=dsn3>
<cfset dsn1_alias=dsn1>
<cfset dsn_alias=dsn>
<cfset X_IS_PHANTOM_TREE =0>
<cfset pp_lte=0>
<cfif  pp_lte eq 0>
    <cfinclude template="/v16/production_plan/query/get_product_list.cfm">
    <cfset pp_lte=1>
</cfif>
<cfinclude template="/AddOns/Partner/satis/Includes/add_spect_main_ver.cfm">
<cfif len(spec_main_id_list)>
    <cfquery name="get_spec_main" datasource="#dsn3#">
    	UPDATE 
        	SPECT_MAIN_ROW
		SET
        	RELATED_MAIN_SPECT_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID =SPECT_MAIN_ROW.STOCK_ID AND SM.IS_TREE = 1  ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) 
		WHERE
        	SPECT_MAIN_ID IN (#spec_main_id_list#)
    </cfquery>
</cfif>






<cfquery name="ivs" datasource="#dsn3#">

  INSERT INTO 
            WORKSTATIONS_PRODUCTS
            (
            WS_ID, STOCK_ID, CAPACITY, PRODUCTION_TIME, PRODUCTION_TIME_TYPE, SETUP_TIME, MIN_PRODUCT_AMOUNT, PRODUCTION_TYPE, PROCESS, MAIN_STOCK_ID, OPERATION_TYPE_ID, 
             ASSET_ID, RECORD_EMP, RECORD_IP, RECORD_DATE
            )
        SELECT        
            TOP (1) 
            WS_ID, #main_stock_id#,CAPACITY, PRODUCTION_TIME, PRODUCTION_TIME_TYPE, SETUP_TIME, MIN_PRODUCT_AMOUNT, PRODUCTION_TYPE, PROCESS, MAIN_STOCK_ID, OPERATION_TYPE_ID, 
             ASSET_ID, #session.ep.userid#, '#CGI.REMOTE_ADDR#', #now()#
        FROM            
            WORKSTATIONS_PRODUCTS AS WORKSTATIONS_PRODUCTS_1
        WHERE        
            STOCK_ID = #getMaster.STOCK_ID#
    </cfquery>

<cfquery name="getspekmain" datasource="#dsn3#">
SELECT top 1 * FROM SPECT_MAIN WHERE STOCK_ID=#main_stock_id#
</cfquery>
<cfset smain_pbs=getspekmain.SPECT_MAIN_ID>