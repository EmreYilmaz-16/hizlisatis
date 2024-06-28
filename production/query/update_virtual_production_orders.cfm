

<cfset FormData=deserializeJSON(attributes.data)>

<cfquery name="del" datasource="#dsn3#">
    DELETE FROM #DSN3#.VIRTUAL_PRODUCTION_ORDERS_STOCKS WHERE V_P_ORDER_ID=#FormData.p_order_id#
</cfquery>



<CFLOOP array="#FormData.row_data#" item="it" index="ix">
    <cfquery name="insertPosStocks" datasource="#dsn3#">
        INSERT INTO VIRTUAL_PRODUCTION_ORDERS_STOCKS
                (V_P_ORDER_ID
                ,STOCK_ID
                ,AMOUNT
                ,PRODUCT_ID
                ,PRICE
                ,DISCOUNT
                ,QUESTION_ID)
            VALUES
                (#FormData.p_order_id#
                ,#it.ROW_DATA.STOCK_ID#
                ,#it.ROW_DATA.AMOUNT#
                ,#it.ROW_DATA.PRODUCT_ID#
                ,#it.ROW_DATA.PRICE#
                ,#it.ROW_DATA.DISCOUNT#
                ,<cfif len(it.QUESTION_ID)>#it.QUESTION_ID#<cfelse>NULL</cfif>)
        
    </cfquery>

    <script>
        window.opener.location.reload();
        this.close();
    </script>
  <!-----
  
  <cfquery name="InsertTree" datasource="#dsn3#">
          INSERT INTO VIRTUAL_PRODUCTION_ORDERS_STOCKS(VP_ID,PRODUCT_ID,STOCK_ID,AMOUNT,QUESTION_ID,PRICE,DISCOUNT,MONEY) 
          VALUES(
          #FormData.main_product_id#,
          #it.ROW_DATA.PRODUCT_ID#,
          #it.ROW_DATA.STOCK_ID#,
          #it.ROW_DATA.AMOUNT#,
          <cfif len(it.QUESTION_ID)>#it.QUESTION_ID#<cfelse>NULL</cfif>,
          #it.ROW_DATA.PRICE#,
          #it.ROW_DATA.DISCOUNT#,
          '#it.ROW_DATA.MONEY#')
      </cfquery>----->
</CFLOOP>