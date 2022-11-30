<cfscript> 
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
    WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = 'list';
	
    WOStruct['#attributes.fuseaction#']['list'] = structNew();
    WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
    WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_pbs_offer';
    WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/Partner/satis/display/list_pbs_offer.cfm';
    
    WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_pbs_offer';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/Partner/satis/form/add_pbs_offer.cfm';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_upd_pbs_offer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/Partner/satis/form/upd_pbs_offer.cfm';
   
	/*
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'Satış Siparişleri';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = 'openList(1)';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = 'Satış Teklifleri';
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = 'openList(2)';

	tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);*/
</cfscript>