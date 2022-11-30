<cfswitch expression = "#fusebox.fuseaction#">
	<cfdefaultcase>
		<cfset fusebox.is_special = false>
	</cfdefaultcase>

	<cfcase value="list_shipping_ambar">
		<cfinclude template="workcube_pda/display/list_shipping_ambar.cfm">
	</cfcase>
	<cfcase value="form_shipping_ambar_fis">
		<cfinclude template="workcube_pda/form/form_shipping_ambar_fis.cfm">
	</cfcase>
	<cfcase value="form_shipping_ambar_stock">
		<cfinclude template="workcube_pda/form/form_shipping_ambar_stock.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_shipping_ambar_stock">
		<cfinclude template="workcube_pda/query/add_shipping_ambar_stock.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_shipping_ambar_stock">
		<cfinclude template="workcube_pda/query/del_shipping_ambar_stock.cfm">
	</cfcase>
	<cfcase value="form_shelf_query">
		<cfinclude template="workcube_pda/form/form_shelf_query.cfm">
	</cfcase>
	<cfcase value="form_ship_control">
		<cfinclude template="workcube_pda/form/form_ship_control.cfm">
	</cfcase>
	<cfcase value="popup_add_ship_package">
		<cfinclude template="workcube_pda/query/add_ship_package.cfm">
	</cfcase>
	<cfcase value="popup_add_ship_package_store">
		<cfinclude template="workcube_pda/query/add_ship_package_store.cfm">
	</cfcase>
	<cfcase value="popup_add_ship_package_stock">
		<cfinclude template="workcube_pda/query/add_ship_package_stock.cfm">
	</cfcase>
	<cfcase value="popup_add_shipping_package">
		<cfinclude template="workcube_pda/query/add_shipping_package.cfm">
	</cfcase>
	<cfcase value="popup_add_shipping_package_repeat">
		<cfinclude template="workcube_pda/query/add_shipping_package_repeat.cfm">
	</cfcase>
	<cfcase value="popup_add_shipping_package_collect_store">
		<cfinclude template="workcube_pda/query/add_shipping_package_collect_store.cfm">
	</cfcase>
	<cfcase value="popup_add_shipping_package_store">
		<cfinclude template="workcube_pda/query/add_shipping_package_store.cfm">
	</cfcase>
	<cfcase value="popup_add_shipping_package_stock">
		<cfinclude template="workcube_pda/query/add_shipping_package_stock.cfm">
	</cfcase>

	<cfcase value="form_ship_control_store">
		<cfinclude template="workcube_pda/form/form_ship_control_store.cfm">
	</cfcase>
	<cfcase value="form_ship_control_fis">
		<cfinclude template="workcube_pda/form/form_ship_control_fis.cfm">
	</cfcase>
	<cfcase value="form_shipping_control">
		<cfinclude template="workcube_pda/form/form_shipping_control.cfm">
	</cfcase>
	<cfcase value="form_shipping_control_repeat">
		<cfinclude template="workcube_pda/form/form_shipping_control_repeat.cfm">
	</cfcase>
	<cfcase value="form_shipping_control_store">
		<cfinclude template="workcube_pda/form/form_shipping_control_store.cfm">
	</cfcase>
	<cfcase value="form_shipping_control_collect_store">
		<cfinclude template="workcube_pda/form/form_shipping_control_collect_store.cfm">
	</cfcase>
	<cfcase value="form_shipping_control_fis">
		<cfinclude template="workcube_pda/form/form_shipping_control_fis.cfm">
	</cfcase>
	<cfcase value="form_ship_control_stock">
		<cfinclude template="workcube_pda/form/form_ship_control_stock.cfm">
	</cfcase>
	<cfcase value="form_shipping_control_stock">
		<cfinclude template="workcube_pda/form/form_shipping_control_stock.cfm">
	</cfcase>
	<cfcase value="list_ship">
		<cfinclude template="workcube_pda/display/list_ship.cfm">
	</cfcase>
	<cfcase value="list_shipping">
		<cfinclude template="workcube_pda/display/list_shipping.cfm">
	</cfcase>
	<cfcase value="list_shipping_repeat">
		<cfinclude template="workcube_pda/display/list_shipping_repeat.cfm">
	</cfcase>
	<cfcase value="list_shipping_store">
		<cfinclude template="workcube_pda/display/list_shipping_store.cfm">
	</cfcase>
	<cfcase value="list_shipping_collect_store">
		<cfinclude template="workcube_pda/display/list_shipping_collect_store.cfm">
	</cfcase>
	<cfcase value="list_shipping_deliver_store">
		<cfinclude template="workcube_pda/display/list_shipping_deliver_store.cfm">
	</cfcase>
	<cfcase value="add_stok_fis">
		<cfinclude template="workcube_pda/query/add_stok_fis.cfm">
	</cfcase>
	<cfcase value="stock_welcome">
		<cfinclude template="workcube_pda/display/stock_welcome.cfm">
	</cfcase>
	<cfcase value="stock_welcome_store">
		<cfinclude template="workcube_pda/display/stock_welcome_store.cfm">
	</cfcase>
 	<cfcase value="form_add_stok_fis">
 		<cfinclude template="workcube_pda/form/add_stock_fis.cfm">
 	</cfcase>
	<cfcase value="form_add_ambar_fis_3">
 		<cfinclude template="workcube_pda/form/add_ambar_fis_3.cfm">
 	</cfcase>
	<cfcase value="form_add_ambar_fis_2">
 		<cfinclude template="workcube_pda/form/add_ambar_fis_2.cfm">
 	</cfcase>
    	<cfcase value="form_add_ambar_fis_1">
 		<cfinclude template="workcube_pda/form/add_ambar_fis_1.cfm">
 	</cfcase>
	<cfcase value="form_add_ambar_fis">
 		<cfinclude template="workcube_pda/form/add_ambar_fis.cfm">
 	</cfcase>
	<cfcase value="add_ambar_fis">
 		<cfinclude template="workcube_pda/query/add_ambar_fis.cfm">
 	</cfcase>
	<cfcase value="form_add_stock_count">
 		<cfinclude template="workcube_pda/form/add_stock_count.cfm">
 	</cfcase>
	<cfcase value="form_add_stock_count_loc">
 		<cfinclude template="workcube_pda/form/add_stock_count_loc.cfm">
 	</cfcase>
	<cfcase value="emptypopup_add_PRTOTM_stock_count_file">
 		<cfinclude template="workcube_pda/query/add_PRTOTM_stock_count_file.cfm">
 	</cfcase>
	<cfcase value="emptypopup_add_PRTOTM_stock_count_loc_file">
 		<cfinclude template="workcube_pda/query/add_PRTOTM_stock_count_loc_file.cfm">
 	</cfcase>
	<cfcase value="list_pda_print_spool">
 		<cfinclude template="workcube_pda/display/list_pda_print_spool.cfm">
 	</cfcase>
	<cfcase value="emptypopup_PRTOTM_print_spool">
 		<cfinclude template="workcube_pda/query/add_PRTOTM_print_spool.cfm">
 	</cfcase>
	<cfcase value="emptypopup_del_PRTOTM_pda_print_spool">
 		<cfinclude template="workcube_pda/query/del_PRTOTM_print_spool.cfm">
 	</cfcase>
	<cfcase value="popup_PRTOTM_print_files">
 		<cfinclude template="workcube_pda/display/PRTOTM_print_files.cfm">
 	</cfcase>
	<cfcase value="emptypopup_PRTOTM_print_files_inner">
 		<cfinclude template="workcube_pda/display/PRTOTM_print_files_inner.cfm">
 	</cfcase>
</cfswitch>