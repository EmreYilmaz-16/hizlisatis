<cfif listlen(order_row_id_list)>
    <cfset last_year = session.ep.period_year -1>
    <cfquery name="get_invoice_durum" datasource="#dsn3#">
            SELECT        
            SUM(ORR.QUANTITY) - SUM(TBLB.AMOUNT) AS KALAN
        FROM            
            ORDER_ROW AS ORR LEFT OUTER JOIN
             (
                SELECT        
                    WRK_ROW_RELATION_ID, 
                    SUM(AMOUNT) AS AMOUNT
                   FROM            
                    (
                        SELECT        
                            AMOUNT, 
                            WRK_ROW_RELATION_ID
                           FROM            
                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW
                            LEFT JOIN  #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID=INVOICE_ROW.INVOICE_ID WHERE I.PURCHASE_SALES=1
                        UNION ALL
                         SELECT        
                            IR.AMOUNT, 
                            IR.WRK_ROW_RELATION_ID
                         FROM            
                            #dsn#_#session.ep.period_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                             #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID
                             LEFT JOIN #dsn#_#session.ep.period_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID = IR.INVOICE_ID WHERE I.PURCHASE_SALES=1
                          <cfif get_period_id.recordcount>
                            UNION ALL
                            SELECT        
                                AMOUNT, 
                                WRK_ROW_RELATION_ID
                            FROM            
                                #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW
                                LEFT JOIN  #dsn#_#last_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID=INVOICE_ROW.INVOICE_ID WHERE I.PURCHASE_SALES=1
                            UNION ALL
                            SELECT        
                                IR.AMOUNT, 
                                IR.WRK_ROW_RELATION_ID
                            FROM            
                                #dsn#_#last_year#_#session.ep.company_id#.SHIP_ROW AS SR INNER JOIN
                                #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON SR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID
                                LEFT JOIN #dsn#_#last_year#_#session.ep.company_id#.INVOICE AS I ON I.INVOICE_ID = IR.INVOICE_ID WHERE I.PURCHASE_SALES=1
                        </cfif>
                      ) AS TBLA
                   GROUP BY 
                     WRK_ROW_RELATION_ID
               ) AS TBLB ON ORR.WRK_ROW_ID = TBLB.WRK_ROW_RELATION_ID
        WHERE        
            ORR.ORDER_ROW_ID IN (#order_row_id_list#)
    </cfquery>
   <cfelse>
    <cfset get_invoice_durum.recordcount =0>
 </cfif>