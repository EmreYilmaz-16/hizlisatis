<cfquery name="getSarfs" datasource="#dsn3#">
    SELECT * FROM workcube_metosan_1.PRODUCTION_ORDERS_STOCKS WHERE P_ORDER_ID=#FormData.P_ORDER_ID#
</cfquery>

<cfset attributes.record_num_exit=getSarfs.recordCount>
<cfset rc=getSarfs.recordCount+1>
<cfloop from="1" to="#attributes.record_num_exit#" index="xx">
    <cfset "attributes.row_kontrol_exit#xx#"=1>
    <cfset "attributes.spec_main_id_exit#xx#"=SPECT_MAIN_ID>
    <cfset "attributes.spect_main_row_exit#xx#"=SPECT_MAIN_ROW_ID>
    <cfset "attributes.spect_id_exit#xx#"=SPECT_VAR_ID>
    <cfset "attributes.product_id_exit#xx#"=PRODUCT_ID>
    <cfset "attributes.stock_id_exit#xx#"=STOCK_ID>
    <cfset "attributes.amount_exit#xx#"=AMOUNT>
    <cfset "attributes.unit_id_exit#xx#"=PRODUCT_UNIT_ID>
    <cfset "attributes.is_phantom_exit#xx#"=IS_PHANTOM>
    <cfset "attributes.is_sevk_exit#xx#"=IS_SEVK>
    <cfset "attributes.is_property_exit#xx#"=IS_PROPERTY>
    <cfset "attributes.is_free_amount_exit#xx#"=IS_FREE_AMOUNT>
    <cfset "attributes.line_number_exit#xx#"=LINE_NUMBER>
    <cfset "attributes.wrk_row_id_exit#xx#"=WRK_ROW_ID>
    <cfset "attributes.fire_amount_exit#xx#"=FIRE_AMOUNT>
    <cfset "attributes.fire_rate_exit#xx#"=FIRE_RATE>
    <cfset "attributes.lot_no_exit#xx#"=LOT_NO>    
</cfloop>
<cfquery name="getStok" datasource="#dsn3#">
    SELECT S.PRODUCT_ID,S.STOCK_ID,SM.SPECT_MAIN_ID,PU.PRODUCT_UNIT_ID FROM workcube_metosan_1.STOCKS AS S 
LEFT JOIN workcube_metosan_1.SPECT_MAIN AS SM ON SM.STOCK_ID=S.STOCK_ID AND SPECT_STATUS=1
LEFT JOIN workcube_metosan_1.PRODUCT_UNIT AS PU ON PU.PRODUCT_ID=S.PRODUCT_ID
WHERE S.STOCK_ID=#FormData.STOCK_ID#
</cfquery>
<cfset wrk_id_new_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##FormData.USER_ID##round(rand()*100)#U#FormData.P_ORDER_ID#S#FormData.STOCK_ID#'>
    <cfset "attributes.row_kontrol_exit#rc#"=1>
    <cfset "attributes.spec_main_id_exit#rc#"=getStok.SPECT_MAIN_ID>
    <cfset "attributes.spect_main_row_exit#rc#"="">
    <cfset "attributes.spect_id_exit#rc#"="">
    <cfset "attributes.product_id_exit#rc#"=getStok.PRODUCT_ID>
    <cfset "attributes.stock_id_exit#rc#"=getStok.STOCK_ID>
    <cfset "attributes.amount_exit#rc#"=FormData.QUANTITY>
    <cfset "attributes.unit_id_exit#rc#"=getStok.PRODUCT_UNIT_ID>
    <cfset "attributes.is_phantom_exit#rc#"="">
    <cfset "attributes.is_sevk_exit#rc#"="">
    <cfset "attributes.is_property_exit#rc#"="">
    <cfset "attributes.is_free_amount_exit#rc#"="">
    <cfset "attributes.line_number_exit#rc#"=0>
    <cfset "attributes.wrk_row_id_exit#rc#"=wrk_id_new_sarf>
    <cfset "attributes.fire_amount_exit#rc#"="">
    <cfset "attributes.fire_rate_exit#rc#"="">
    <cfset "attributes.lot_no_exit#rc#"=""> 

    <cfset attributes.record_num_exit=rc>