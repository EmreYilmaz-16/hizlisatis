<cf_box title="Sanal Ürün Detay">
    <cfquery name="GetVp" datasource="#DSN3#">
        SELECT VIRTUAL_PRODUCT_ID,PRODUCT_NAME,PRODUCT_CATID,PRICE,MARJ,PRODUCT_TYPE,IS_CONVERT_REAL,#dsn#.getEmployeeWithId(RECORD_EMP) RECORD_EMP,RECORD_DATE,#dsn#.getEmployeeWithId(UPDATE_EMP) UPDATE_EMP,UPDATE_DATE FROM #dsn3#.VIRTUAL_PRODUCTS_PRT where VIRTUAL_PRODUCT_ID=#attributes.pid#
    </cfquery>

<div class="ui-cards">
    
    <div class="ui-cards-text">
        <h1><cfoutput>#GetVp.PRODUCT_NAME#</cfoutput></h1>
        <cfquery name="getVirtualTree" datasource="#dsn3#">
            

            SELECT S.PRODUCT_NAME,S.STOCK_CODE,VPT.AMOUNT,VPQ.QUESTION,PU.MAIN_UNIT,VP_ID FROM #dsn3#.VIRTUAL_PRODUCT_TREE_PRT AS VPT
LEFT JOIN #dsn3#.STOCKS AS S ON VPT.STOCK_ID=S.STOCK_ID
LEFT JOIN #dsn3#.VIRTUAL_PRODUCT_TREE_QUESTIONS AS VPQ ON VPQ.QUESTION_ID=VPT.QUESTION_ID
LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID AND PRODUCT_UNIT_STATUS=1
            WHERE  VP_ID=#attributes.pid#
    ORDER BY VP_ID  
        </cfquery>
           <ul class="ui-info-list">
          
        
       <cfoutput query="getVirtualTree">
        <li>
            <span style="display:block;width:20%"><i>#QUESTION#:</i></span>  #PRODUCT_NAME# (#AMOUNT# #MAIN_UNIT#)
        </li>
    
       </cfoutput>
    </ul>
       
        
       
        <ul class="ui-icon-list">
            
            <li><a href="javascript://"><i class="fa fa-save"></i><code style="margin-left:5px"><cfoutput>#getVp.RECORD_EMP# &nbsp; #dateFormat(GetVp.RECORD_DATE,"dd/mm/yyyy")# </cfoutput></code></a></li>
            <li><a href="javascript://"><i class="fa fa-refresh"></i><code style="margin-left:5px"><cfoutput>#getVp.UPDATE_EMP# &nbsp; #dateFormat(GetVp.UPDATE_DATE,"dd/mm/yyyy")# </cfoutput></code></a></li>
        </ul>
    </div>
   
</div>



</cf_box>